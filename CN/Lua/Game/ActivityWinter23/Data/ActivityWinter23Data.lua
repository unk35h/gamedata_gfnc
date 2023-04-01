-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityWinter23Data = class("ActivityWinter23Data", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).Winter23
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local ActivityWinter23Enum = require("Game.ActivityWinter23.Data.ActivityWinter23Enum")
local ActTechTree = require("Game.ActivityFrame.ActTechTree")
local ActDailyTaskData = require("Game.ActivityFrame.ActDailyTaskData")
local ActTermTaskDataMul = require("Game.ActivityFrame.ActTermTaskDataMul")
local WarChessSeasonAddtionData = require("Game.WarChessSeason.WarChessSeasonAddtionData")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
ActivityWinter23Data.InitWinter23Data = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_winter23_main)[msg.actId]
  self._chaptersCfg = ConfigData.activity_winter23_chapters
  self._difficultyCfg = ConfigData.activity_winter23_difficulty
  self._farmDescCfg = ConfigData.activity_winter23_farm_desc
  self:__InitTechData()
  self:__InitDailyTaskData()
  self:__InitTermTaskData()
  self:UpdateWinter23Data(msg)
  ;
  (self._termTaskData):RegisterActTermRefresh()
  self:RefreshRedWinter23DailyTask()
  self:RefreshRedWinter23Tech()
  self:RefreshRedWnter23OnceTask()
  self:RefreshRedWinter23Shop()
  self:SetMiniGameData(msg.bird)
  self:SetMiniGameMineMaxScore((msg.bird).highestScore)
  self:SetMiniGameIsGottenJoinRewards((msg.bird).joinRewards)
  self:RefreshRedWinter23Main()
end

ActivityWinter23Data.UpdateWinter23Data = function(self, msg)
  -- function num : 0_1
  if msg.tech ~= nil then
    (self._actTechTree):UpdateActTechTree(msg.tech)
  end
  self.recordSectorId = msg.recordSectorId
end

ActivityWinter23Data.__InitTechData = function(self)
  -- function num : 0_2 , upvalues : ActTechTree, _ENV
  self._actTechTree = (ActTechTree.New)()
  ;
  (self._actTechTree):InitTechTree((self._mainCfg).tech_id, self)
  local RefreshRedTechCallback = BindCallback(self, self.RefreshRedWinter23Tech)
  ;
  (self._actTechTree):BindActTechUpdateFunc(RefreshRedTechCallback)
  ;
  (self._actTechTree):BindActTechAllResetFunc(RefreshRedTechCallback)
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  actFrameCtrl:AddActivityTech(self._actTechTree)
end

ActivityWinter23Data.__InitDailyTaskData = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActDailyTaskData
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dailyTaskData = actFrameCtrl:GetActDailyTaskData(self:GetActFrameId())
  if self._dailyTaskData == nil then
    self._dailyTaskData = (ActDailyTaskData.New)()
    ;
    (self._dailyTaskData):InitActDailyTask(self:GetActFrameId())
  end
  local RefreshRedWinter23DailyTaskCallback = BindCallback(self, self.RefreshRedWinter23DailyTask)
  ;
  (self._dailyTaskData):BindActDailyTaskCommitFunc(RefreshRedWinter23DailyTaskCallback)
  ;
  (self._dailyTaskData):BindActDailyTaskChangeFunc(RefreshRedWinter23DailyTaskCallback)
  ;
  (self._dailyTaskData):BindActDailyTaskExpireFunc(RefreshRedWinter23DailyTaskCallback)
  ;
  (self._dailyTaskData):RegisterActDailyRefresh()
end

ActivityWinter23Data.__InitTermTaskData = function(self)
  -- function num : 0_4 , upvalues : ActTermTaskDataMul, _ENV
  self._termTaskData = (ActTermTaskDataMul.New)()
  ;
  (self._termTaskData):InitTermTask(self:GetActFrameId())
  local RefreshRedWnter23OnceTaskCallback = BindCallback(self, self.RefreshRedWnter23OnceTask)
  ;
  (self._termTaskData):BindTeramTaskCommitFunc(RefreshRedWnter23OnceTaskCallback)
  ;
  (self._termTaskData):BindTeramTaskUnlockFunc(RefreshRedWnter23OnceTaskCallback)
end

ActivityWinter23Data.RefreshRedWinter23Tech = function(self)
  -- function num : 0_5 , upvalues : ActivityWinter23Enum, ActivityFrameUtil
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).Tech)
  local spBranch = (self._mainCfg).tech_special_branch
  local flag = (ActivityFrameUtil.CalActTechRedWithSpBranchAndItem)(self, self._actTechTree, spBranch, 16000)
  local redCount = flag and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivityWinter23Data.RefreshRedWinter23DailyTask = function(self)
  -- function num : 0_6 , upvalues : ActivityWinter23Enum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  if self._dailyTaskData == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).DailyTask)
  local flag = (self._dailyTaskData):IsExistDailyCompleteTask()
  local redCount = flag and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivityWinter23Data.RefreshRedWnter23OnceTask = function(self)
  -- function num : 0_7 , upvalues : ActivityWinter23Enum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).OnceTask)
  local flag = (self._termTaskData):IsExistTermCompleteTask()
  local redCount = flag and 1 or 0
  if childReddot:GetRedDotCount() ~= redCount then
    childReddot:SetRedDotCount(redCount)
  end
end

ActivityWinter23Data.RefreshRedWinter23Shop = function(self)
  -- function num : 0_8 , upvalues : ActivityWinter23Enum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local flag = false
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).Shop)
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for i,v in ipairs((self._mainCfg).shop_list) do
    if not userDataCache:GetWinter23ShopLooked(self:GetActId(), v) then
      flag = true
      return 
    end
  end
  do
    local redCount = flag and 1 or 0
    if childReddot:GetRedDotCount() ~= redCount then
      childReddot:SetRedDotCount(redCount)
    end
  end
end

ActivityWinter23Data.RefreshRedWinter23Main = function(self)
  -- function num : 0_9 , upvalues : ActivityWinter23Enum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local flag = false
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).main)
  local enterFlag, defaultSectorId = self:GetLastWinter23MainSector()
  if not enterFlag then
    flag = true
  else
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    if avgPlayCtrl:IsPlayedAllMainAvg(defaultSectorId, 1, nil, nil, true) ~= 0 then
      flag = true
    end
  end
  do
    if not self:IsActivityRunning() then
      flag = false
    end
    local redCount = flag and 1 or 0
    if childReddot:GetRedDotCount() ~= redCount then
      childReddot:SetRedDotCount(redCount)
    end
  end
end

ActivityWinter23Data.GetActivityReddotNum = function(self)
  -- function num : 0_10 , upvalues : _ENV, ActivityWinter23Enum
  local isBlue = true
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    error("can\'t get activity reddot node")
    return false, 0
  end
  local num = actRedDotNode:GetRedDotCount()
  for i,v in ipairs(ActivityWinter23Enum.reddotIsRedType) do
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

ActivityWinter23Data.GetWinter23SeconedUnlock = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return (CheckCondition.CheckLua)((self._mainCfg).second_pre_condition, (self._mainCfg).second_pre_para1, (self._mainCfg).second_pre_para2)
end

ActivityWinter23Data.IsWinter23ShopLooked = function(self, shopId)
  -- function num : 0_12 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  return userDataCache:GetWinter23ShopLooked(self:GetActId(), shopId)
end

ActivityWinter23Data.SetWinter23ShopLooked = function(self, shopId)
  -- function num : 0_13 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  userDataCache:SetWinter23ShopLooked(self:GetActId(), shopId)
  self:RefreshRedWinter23Shop()
end

ActivityWinter23Data.IsWinter23ChapterLooked = function(self, chapterId)
  -- function num : 0_14
  if not self.chapterReads then
    return false
  end
  return (self.chapterReads)[chapterId]
end

ActivityWinter23Data.SetWinter23ChapterLooked = function(self, chapterId)
  -- function num : 0_15
  if not self.chapterReads then
    self.chapterReads = {}
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.chapterReads)[chapterId] = true
  end
end

ActivityWinter23Data.IsNotRepeatStageAndComplete = function(self, stageId)
  -- function num : 0_16 , upvalues : _ENV
  if not (PlayerDataCenter.sectorStage):IsStageComplete(stageId) then
    return false
  end
  return self:IsNotRepeatStage(stageId)
end

ActivityWinter23Data.IsNotRepeatStage = function(self, stageId)
  -- function num : 0_17 , upvalues : _ENV
  local farm_stage_id = (self._mainCfg).farm_stage_id
  for i,v in pairs(farm_stage_id) do
    if stageId == v then
      return false
    end
  end
  return true
end

ActivityWinter23Data.SetWinter23ClientRecordSector = function(self, recordSectorId)
  -- function num : 0_18 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  userDataCache:SetWinter23FirstEnterSectorId(self:GetActId(), recordSectorId)
  self.recordSectorId = recordSectorId
end

ActivityWinter23Data.GetWinter23TechTree = function(self)
  -- function num : 0_19
  return self._actTechTree
end

ActivityWinter23Data.GetWinter23DailyTaskData = function(self)
  -- function num : 0_20
  return self._dailyTaskData
end

ActivityWinter23Data.GetWinter23TermTaskData = function(self)
  -- function num : 0_21
  return self._termTaskData
end

ActivityWinter23Data.GetWinter23Cfg = function(self)
  -- function num : 0_22
  return self._mainCfg
end

ActivityWinter23Data.GetChaptersCfg = function(self)
  -- function num : 0_23
  return self._chaptersCfg
end

ActivityWinter23Data.GetDifficultyCfg = function(self)
  -- function num : 0_24
  return self._difficultyCfg
end

ActivityWinter23Data.GetFarmDescCfg = function(self)
  -- function num : 0_25
  return self._farmDescCfg
end

ActivityWinter23Data.GetRelationStage = function(self, stageId)
  -- function num : 0_26 , upvalues : _ENV
  if not self:IsActivityRunning() then
    return nil
  end
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil or stageCfg.sector ~= (self._mainCfg).hard_stage then
    return nil
  end
  local sectorDiffDic = ((ConfigData.sector_stage).sectorDiffDic)[(self._mainCfg).normal_sector]
  if sectorDiffDic == nil then
    return nil
  end
  sectorDiffDic = sectorDiffDic[stageCfg.difficulty]
  if sectorDiffDic == nil then
    return nil
  end
  local relationId = sectorDiffDic[stageCfg.num]
  if relationId == nil then
    return nil
  end
  return (ConfigData.sector_stage)[relationId]
end

ActivityWinter23Data.GetLastWinter23MainSector = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if not self.recordSectorId or self.recordSectorId == 0 then
    local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    local clientDiff = userDataCache:GetWinter23FirstEnterSectorId(self:GetActId())
    self.recordSectorId = clientDiff or nil
  end
  do
    do return self.recordSectorId == (self._mainCfg).normal_sector or self.recordSectorId == (self._mainCfg).hard_stage, self.recordSectorId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

ActivityWinter23Data.IsWinter23Sector = function(self, sectorId)
  -- function num : 0_28
  do return (self._mainCfg).hard_stage == sectorId or (self._mainCfg).normal_sector == sectorId or (self._mainCfg).warchess_guide_sector == sectorId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityWinter23Data.GetRepeatStageList = function(self, sectorId)
  -- function num : 0_29 , upvalues : _ENV
  local farm_stage_id = (self._mainCfg).farm_stage_id
  local list = {}
  for i,v in pairs(farm_stage_id) do
    local stageCfg = (ConfigData.sector_stage)[v]
    if stageCfg.sector == sectorId then
      (table.insert)(list, stageCfg.id)
    end
  end
  return list
end

ActivityWinter23Data.GetRepeatArrangeType = function(self)
  -- function num : 0_30
  return (self._mainCfg).farm_stage_arrange
end

ActivityWinter23Data.GetWarChessGreenHandSectorId = function(self)
  -- function num : 0_31
  return (self._mainCfg).warchess_guide_sector
end

ActivityWinter23Data.GetMiniGameId = function(self)
  -- function num : 0_32
  return (self._mainCfg).game_penguin
end

ActivityWinter23Data.GetMiniGameIsGottenJoinRewards = function(self)
  -- function num : 0_33 , upvalues : _ENV
  if self.minigameMsg == nil then
    error("not get minigameMsg")
  end
  return (self.minigameMsg).isGottenJoinRewards
end

ActivityWinter23Data.GetMiniGameMaxScore = function(self)
  -- function num : 0_34 , upvalues : _ENV
  if self.minigameMsg == nil then
    error("not get minigameMsg")
  end
  return (self.minigameMsg).highestScore
end

ActivityWinter23Data.GetWinter23WarchessSeasonId = function(self)
  -- function num : 0_35
  return (self._mainCfg).warchess_season_id
end

ActivityWinter23Data.GetHallowmasSeasonAddtion = function(self)
  -- function num : 0_36 , upvalues : WarChessSeasonAddtionData
  if self._seasonAddtionData == nil then
    self._seasonAddtionData = (WarChessSeasonAddtionData.New)()
  end
  return self._seasonAddtionData
end

ActivityWinter23Data.GetIsExterUnlock = function(self)
  -- function num : 0_37 , upvalues : _ENV, CheckerTypeId
  local checkLevelIds = (self._mainCfg).extra_obj_unlock
  if checkLevelIds == nil or #checkLevelIds <= 0 then
    return false
  end
  for _,stageId in pairs(checkLevelIds) do
    local isUnlock = (CheckCondition.CheckLua)({CheckerTypeId.CompleteStage}, {stageId})
    if isUnlock then
      return true
    end
  end
  return false
end

ActivityWinter23Data.SetMiniGameData = function(self, minigameMsg)
  -- function num : 0_38
  self.minigameMsg = minigameMsg
end

ActivityWinter23Data.SetMiniGameIsGottenJoinRewards = function(self, bool)
  -- function num : 0_39 , upvalues : _ENV
  if self.minigameMsg == nil then
    error("not get minigameMsg")
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.minigameMsg).isGottenJoinRewards = bool
end

ActivityWinter23Data.SetMiniGameMineMaxScore = function(self, score)
  -- function num : 0_40 , upvalues : _ENV
  if self.minigameMsg == nil then
    error("not get minigameMsg")
  end
  if score or 0 < (self.minigameMsg).highestScore then
    warn("highest score not above current highest score")
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.minigameMsg).highestScore = score
end

return ActivityWinter23Data

