-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivitySeasonData = class("ActivitySeasonData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).Season
local ActivityFrameData = require("Game.ActivityFrame.ActivityFrameData")
local ActivitySeasonEnum = require("Game.ActivitySeason.ActivitySeasonEnum")
local ActDailyTaskData = require("Game.ActivityFrame.ActDailyTaskData")
local ActTermTaskDataOne = require("Game.ActivityFrame.ActTermTaskDataOne")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local ActivitySeasonDungeonDataI = require("Game.ActivitySeason.Data.ActivitySeasonDungeonDataI")
local ActDungeonLevelCollect = require("Game.ActivityFrame.ActDungeonLevelCollect")
local ActInternalUnlockInfo = require("Game.Common.Activity.ActInternalUnlockInfo")
local ActTechTree = require("Game.ActivityFrame.ActTechTree")
local WarChessSeasonAddtionData = require("Game.WarChessSeason.WarChessSeasonAddtionData")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
ActivitySeasonData.InitSeasonData = function(self, msg)
  -- function num : 0_0 , upvalues : _ENV, CurActType
  self._net = NetworkManager:GetNetwork(NetworkTypeID.ActivitySeason)
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_season_main)[msg.actId]
  self:__InitTechData()
  self:__InitDailyTaskData()
  self:__InitTermTaskData()
  self:__InitSeasonDungeon()
  self:__GenSectorAvgDic()
  self._rewardCfg = (ConfigData.activity_season_reward)[msg.actId]
  local count = #self._rewardCfg
  self._maxLevel = count
  self._cycleExp = ((self._rewardCfg)[count]).need_exp
  self._fixExpMax = ((self._rewardCfg)[self._maxLevel]).total_exp
  self._rewardMaskDic = {}
  self:UpdateSeasonData(msg)
  ;
  (self._termTaskData):RegisterActTermRefresh()
  self:RefreshRedSeasonDailyTask()
  self:RefreshRedSeasonOnceTask()
  self:RefreshRedSeasonMainStory()
  self:RefreshRedSeasonTech()
  self:__InitUnlockInfo()
end

ActivitySeasonData.__InitTechData = function(self)
  -- function num : 0_1 , upvalues : ActTechTree, _ENV
  self._actTechTree = (ActTechTree.New)()
  ;
  (self._actTechTree):InitTechTree((self._mainCfg).tech_id, self)
  local RefreshRedTechCallback = BindCallback(self, self.RefreshRedSeasonTech)
  ;
  (self._actTechTree):BindActTechUpdateFunc(RefreshRedTechCallback)
  ;
  (self._actTechTree):BindActTechAllResetFunc(RefreshRedTechCallback)
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  actFrameCtrl:AddActivityTech(self._actTechTree)
end

ActivitySeasonData.__InitDailyTaskData = function(self)
  -- function num : 0_2 , upvalues : _ENV, ActDailyTaskData
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dailyTaskData = actFrameCtrl:GetActDailyTaskData(self:GetActFrameId())
  if self._dailyTaskData == nil then
    self._dailyTaskData = (ActDailyTaskData.New)()
    ;
    (self._dailyTaskData):InitActDailyTask(self:GetActFrameId())
  end
  local RefreshRedSeasonDailyTaskCallback = BindCallback(self, self.RefreshRedSeasonDailyTask)
  ;
  (self._dailyTaskData):BindActDailyTaskCommitFunc(RefreshRedSeasonDailyTaskCallback)
  ;
  (self._dailyTaskData):BindActDailyTaskChangeFunc(RefreshRedSeasonDailyTaskCallback)
  ;
  (self._dailyTaskData):BindActDailyTaskExpireFunc(RefreshRedSeasonDailyTaskCallback)
  ;
  (self._dailyTaskData):RegisterActDailyRefresh()
end

ActivitySeasonData.__InitTermTaskData = function(self)
  -- function num : 0_3 , upvalues : ActTermTaskDataOne, _ENV
  self._termTaskData = (ActTermTaskDataOne.New)()
  ;
  (self._termTaskData):InitTermTask(self:GetActFrameId())
  local RefreshRedSeasonOnceTaskCallback = BindCallback(self, self.RefreshRedSeasonOnceTask)
  ;
  (self._termTaskData):BindTeramTaskCommitFunc(RefreshRedSeasonOnceTaskCallback)
  ;
  (self._termTaskData):BindTeramTaskUnlockFunc(RefreshRedSeasonOnceTaskCallback)
end

ActivitySeasonData.__InitSeasonDungeon = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActivitySeasonDungeonDataI, ActDungeonLevelCollect
  local dungeonCfgs = (ConfigData.activity_season_battle_ex)[self:GetActId()]
  local dungeonCfgList = {}
  for _,dungeonCfg in pairs(dungeonCfgs) do
    (table.insert)(dungeonCfgList, dungeonCfg)
  end
  ;
  (table.sort)(dungeonCfgList, function(a, b)
    -- function num : 0_4_0
    do return a.dungeon_id < b.dungeon_id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local dungeonLevelDataList = {}
  for i,dungeonCfg in ipairs(dungeonCfgList) do
    local dungeonLevelData = (ActivitySeasonDungeonDataI.New)(dungeonCfg.dungeon_id, dungeonCfg, (self._mainCfg).warchess_season_id, i)
    ;
    (table.insert)(dungeonLevelDataList, dungeonLevelData)
  end
  self._dungeonCollect = (ActDungeonLevelCollect.New)()
  ;
  (self._dungeonCollect):InitActDungeonLevelCollect(dungeonLevelDataList, self)
  ;
  (self._dungeonCollect):SetDungeonLevelCollectName((LanguageUtil.GetLocaleText)((self._mainCfg).battle_title), (self._mainCfg).battle_title_en)
end

ActivitySeasonData.__InitUnlockInfo = function(self)
  -- function num : 0_5 , upvalues : ActInternalUnlockInfo
  self._unlockInfo = (ActInternalUnlockInfo.New)()
end

ActivitySeasonData.__InitSeasonUnlockRepeat = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._settedUnlockRepeat then
    return 
  end
  self._settedUnlockRepeat = true
  local dunLockDic = {}
  for _,dungeonLevelData in ipairs((self._dungeonCollect):GetActDungeonSortList()) do
    local stageId = dungeonLevelData:GetDungeonLevelStageId()
    if not dungeonLevelData:GetIsLevelUnlock() then
      dunLockDic[stageId] = dungeonLevelData
    end
  end
  ;
  (self._unlockInfo):InitActDunRepeatUnlockInfo(dunLockDic)
end

ActivitySeasonData.__InitSeasonUnlockAvg = function(self)
  -- function num : 0_7
  if self._settedUnlockAvg then
    return 
  end
  self._settedUnlockAvg = true
  ;
  (self._unlockInfo):InitActAvgUnlockInfo((self._mainCfg).story_stage)
end

ActivitySeasonData.RefreshRedSeasonTech = function(self)
  -- function num : 0_8 , upvalues : ActivitySeasonEnum, ActivityFrameUtil
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).Tech)
  local spBranch = (self._mainCfg).tech_special_branch
  local flag = (ActivityFrameUtil.CalActTechRedWithSpBranchAndItem)(self, self._actTechTree, spBranch, 16000)
  local redCount = flag and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivitySeasonData.RefreshRedSeasonDailyTask = function(self)
  -- function num : 0_9 , upvalues : ActivitySeasonEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  if self._dailyTaskData == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).DailyTask)
  local flag = (self._dailyTaskData):IsExistDailyCompleteTask()
  local redCount = flag and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivitySeasonData.RefreshRedSeasonOnceTask = function(self)
  -- function num : 0_10 , upvalues : ActivitySeasonEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).OnceTask)
  local flag = (self._termTaskData):IsExistTermCompleteTask()
  local redCount = flag and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivitySeasonData.RefreshRedSeasonMainStory = function(self)
  -- function num : 0_11 , upvalues : ActivitySeasonEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local flag = false
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).mainStory)
  if self._avgIdDic == nil then
    self:__GenSectorAvgDic()
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay, true)
  for k,v in pairs(self._avgIdDic) do
    local played = avgPlayCtrl:IsAvgPlayed(k)
    local unlock = avgPlayCtrl:IsAvgUnlock(k)
    if not played and unlock then
      flag = true
      break
    end
  end
  do
    local redCount = flag and 1 or 0
    if childReddot:GetRedDotCount() ~= redCount then
      childReddot:SetRedDotCount(redCount)
    end
  end
end

ActivitySeasonData.RefreshRedSeasonBonus = function(self)
  -- function num : 0_12 , upvalues : ActivitySeasonEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local canReceive = self:HasSeasonRewardExpCanReceive()
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).Bonus)
  local redCount = canReceive and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivitySeasonData.UpdateSeasonData = function(self, msg)
  -- function num : 0_13 , upvalues : _ENV
  if msg and msg.tech then
    (self._actTechTree):UpdateActTechTree(msg.tech)
  end
  local lastLevel = self._level
  self._level = msg.level
  self._exp = msg.exp
  if lastLevel ~= nil and self._level ~= lastLevel then
    self:UpdateSeasonUnlockAvg()
  end
  for level = 1, self._level do
    if not (self._rewardMaskDic)[level] then
      local index = (math.floor)(level / 32)
      local mask = (msg.rewardsMask)[index + 1]
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R9 in 'UnsetPending'

      if mask & 1 << level % 32 == 0 then
        do
          (self._rewardMaskDic)[level] = mask == nil
          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  self._cycleRewardPickedCount = msg.extraPickLevel
  self:RefreshRedSeasonBonus()
  self:RefreshRedSeasonMainStory()
  local bonusUI = UIManager:GetWindow(UIWindowTypeID.ActivitySeasonBonus)
  if bonusUI ~= nil then
    bonusUI:RefreshActivitySeasonBouns()
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

ActivitySeasonData.UpdateSeasonUnlockAvg = function(self)
  -- function num : 0_14
  if self._unlockInfo ~= nil then
    self:__InitSeasonUnlockAvg()
    ;
    (self._unlockInfo):UpdateActAvgUnlockInfo()
  end
end

ActivitySeasonData.UpdateSeasonUnlockRepeat = function(self)
  -- function num : 0_15
  if self._unlockInfo ~= nil then
    self:__InitSeasonUnlockRepeat()
    ;
    (self._unlockInfo):UpdateActDunRepeatUnlockInfo()
  end
end

ActivitySeasonData.__GenSectorAvgDic = function(self)
  -- function num : 0_16 , upvalues : _ENV
  self._avgIdDic = {}
  local avgIds = ((ConfigData.story_avg).sectorAvgDic)[(self._mainCfg).story_stage]
  if avgIds == nil then
    return 
  end
  for i,v in ipairs(avgIds) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

    (self._avgIdDic)[v] = true
  end
end

ActivitySeasonData.IsSeasonSectorAvg = function(self, avgId)
  -- function num : 0_17
  if self._avgIdDic == nil then
    self:__GenSectorAvgDic()
  end
  return (self._avgIdDic)[avgId]
end

ActivitySeasonData.GetActivityReddotNum = function(self)
  -- function num : 0_18 , upvalues : _ENV, ActivitySeasonEnum
  local isBlue = true
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    error("can\'t get activity reddot node")
    return false, 0
  end
  local num = actRedDotNode:GetRedDotCount()
  for i,v in ipairs(ActivitySeasonEnum.reddotIsRedType) do
    local redChild = actRedDotNode:GetChild(v)
    if redChild ~= nil and redChild:GetRedDotCount() > 0 then
      isBlue = false
      break
    end
  end
  do
    return isBlue, num
  end
end

ActivitySeasonData.GetSeasonTechTree = function(self)
  -- function num : 0_19
  return self._actTechTree
end

ActivitySeasonData.GetSeasonDailyTaskData = function(self)
  -- function num : 0_20
  return self._dailyTaskData
end

ActivitySeasonData.GetSeasonTermTaskData = function(self)
  -- function num : 0_21
  return self._termTaskData
end

ActivitySeasonData.GetSeasonUnlockInfo = function(self)
  -- function num : 0_22
  return self._unlockInfo
end

ActivitySeasonData.GetSeasonMainCfg = function(self)
  -- function num : 0_23
  return self._mainCfg
end

ActivitySeasonData.GetSeasonRewardCfg = function(self)
  -- function num : 0_24
  return self._rewardCfg
end

ActivitySeasonData.GetSeasonTokenItemId = function(self)
  -- function num : 0_25
  return (self._mainCfg).token_item
end

ActivitySeasonData.GetSeasonRewardCurLv = function(self)
  -- function num : 0_26
  return self._level
end

ActivitySeasonData.GetSeasonRewardLvLimit = function(self)
  -- function num : 0_27
  return self._maxLevel
end

ActivitySeasonData.GetSeasonRewardAllExp = function(self)
  -- function num : 0_28 , upvalues : _ENV
  return PlayerDataCenter:GetItemCount(self:GetSeasonTokenItemId())
end

ActivitySeasonData.GetSeasonRewardCurExp = function(self)
  -- function num : 0_29
  return self._exp
end

ActivitySeasonData.GetSeasonRewardCurExpLimit = function(self)
  -- function num : 0_30
  local cfg = (self._rewardCfg)[self:GetSeasonRewardCurLv()]
  if cfg == nil then
    return 0
  end
  return cfg.need_exp
end

ActivitySeasonData.GetSeasonRewardCycleExpLimit = function(self)
  -- function num : 0_31
  return self._cycleExp
end

ActivitySeasonData.GetSeasonDungeonCollect = function(self)
  -- function num : 0_32
  return self._dungeonCollect
end

ActivitySeasonData.GeSeasonTechTree = function(self)
  -- function num : 0_33
  return self._actTechTree
end

ActivitySeasonData.IsSeasonRewardLevelCanPick = function(self, level)
  -- function num : 0_34
  if (self._rewardMaskDic)[level] then
    return false
  end
  do return level <= self._level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySeasonData.IsSeasonRewardLevelReceived = function(self, level)
  -- function num : 0_35
  return (self._rewardMaskDic)[level]
end

ActivitySeasonData.IsSeasonRewardCycleCanPick = function(self)
  -- function num : 0_36
  if self._level < self._maxLevel then
    return false
  end
  do return self._cycleExp <= self._exp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySeasonData.HasSeasonRewardExpCanReceive = function(self)
  -- function num : 0_37 , upvalues : _ENV
  for _,isPicked in ipairs(self._rewardMaskDic) do
    if not isPicked then
      return true
    end
  end
  return self:IsSeasonRewardCycleCanPick()
end

ActivitySeasonData.ReqSeasonRewardExpReceive = function(self, level, callback)
  -- function num : 0_38
  if not self:IsSeasonRewardLevelCanPick(level) then
    return 
  end
  ;
  (self._net):CS_ACTIVITY_Season_PickLevelReward(self:GetActId(), level, callback)
end

ActivitySeasonData.ReqSeasonRewardExpCycle = function(self, callback)
  -- function num : 0_39
  if not self:IsSeasonRewardCycleCanPick() then
    return 
  end
  ;
  (self._net):CS_ACTIVITY_Season_PickCirCleReward(self:GetActId(), callback)
end

ActivitySeasonData.ReqSeasonRewardAllExp = function(self, callback)
  -- function num : 0_40
  if not self:HasSeasonRewardExpCanReceive() then
    return 
  end
  ;
  (self._net):CS_ACTIVITY_Season_PickAllLevelReward(self:GetActId(), callback)
end

ActivitySeasonData.GetSeasonId = function(self)
  -- function num : 0_41
  return (self._mainCfg).warchess_season_id
end

ActivitySeasonData.GetGreenHandSectorId = function(self)
  -- function num : 0_42
  return (self._mainCfg).warchess_guide_sector
end

ActivitySeasonData.GetSeasonAddtion = function(self)
  -- function num : 0_43 , upvalues : WarChessSeasonAddtionData
  if self._seasonAddtionData == nil then
    self._seasonAddtionData = (WarChessSeasonAddtionData.New)()
  end
  return self._seasonAddtionData
end

return ActivitySeasonData

