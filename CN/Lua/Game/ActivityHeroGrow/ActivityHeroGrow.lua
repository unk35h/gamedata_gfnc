-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityHeroGrow = class("ActivityHeroGrow", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local DungeonLevelHeroGrow = require("Game.ActivityHeroGrow.DungeonLevelHeroGrow")
local base = ActivityBase
local NoticeData = require("Game.Notice.NoticeData")
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local ActivityCharDunConfig = require("Game.ActivityHeroGrow.ActivityCharDunConfig")
ActivityHeroGrow.InitHeroGrowData = function(self, actInfo)
  -- function num : 0_0 , upvalues : _ENV, DungeonLevelHeroGrow
  self:SetActFrameData(actInfo)
  self._cfg = (ConfigData.activity_hero)[actInfo:GetActId()]
  if self._cfg == nil then
    error("HeroGrowCfg Miss  id is " .. tostring(actInfo:GetActId()))
  end
  self._costNum = 0
  self._remainTimes = 0
  self._lastExpiredTm = self:GetActivityBornTime()
  self._isHasLimitTimes = false
  local nodeParent = self:GetActivityReddot()
  local node = nodeParent:AddChild(RedDotStaticTypeId.ActivityShop)
  local dynPath = node.nodePath .. "SubItem"
  self.__shopDynPath = dynPath
  self._dungonLevelDic = {}
  for _,dungeonId in ipairs((self._cfg).dungeon_list) do
    local dungeonLevelData = (DungeonLevelHeroGrow.New)(dungeonId)
    dungeonLevelData:SetDungeonHeroGrowAct(self)
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._dungonLevelDic)[dungeonId] = dungeonLevelData
  end
end

ActivityHeroGrow.UpdateHeroGrowData = function(self, msg, isLogin)
  -- function num : 0_1 , upvalues : _ENV
  self._costNum = msg.costNum
  if self._isHasLimitTimes then
    self._remainTimes = msg.remainTimes
    if msg.lastExpiredTm ~= 0 then
      self._lastExpiredTm = msg.lastExpiredTm
    end
    self:__UpdateReddot()
  end
  self._dailyTaskFullRewardDic = {}
  for index,dailyTaskState in ipairs(msg.dailyTaskFullReward) do
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R8 in 'UnsetPending'

    (self._dailyTaskFullRewardDic)[index] = dailyTaskState > 0
  end
  self._finishedDailyTaskDic = {}
  for _,taskId in ipairs(msg.FinishedDailyTask) do
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R8 in 'UnsetPending'

    (self._finishedDailyTaskDic)[taskId] = true
  end
  self._tokenRewardLevelDic = {}
  for i,level in ipairs(msg.tokenRewardLevel) do
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R8 in 'UnsetPending'

    (self._tokenRewardLevelDic)[level] = true
  end
  MsgCenter:Broadcast(eMsgEventId.HeroGrowActivityUpdate, self)
  self:__UpdateShopUnlockAndReddot(isLogin)
  self:RefreshHeroGrowDailyTaskComReddot()
  self:RefreshHeroGrowDailyTaskNewReddot()
  self:RefreshHeroGrowLvRewrdReddot()
  self:RefreshHeroGrowChallengeNewReddot()
  self:UpdateActFrameDataSingleMsg(msg)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

ActivityHeroGrow.__UpdateShopUnlockAndReddot = function(self, isLogin)
  -- function num : 0_2 , upvalues : _ENV, ConditionListener
  if not self:IsActivityOpen() then
    return 
  end
  if self.__conditionListener ~= nil then
    return 
  end
  local shopRootNode = self:GetActivityHeroShopReddotNode()
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local unlockShopListener = function(shopId)
    -- function num : 0_2_0 , upvalues : saveUserData, self, shopRootNode
    do
      if not saveUserData:IsActivityHeroShopRead((self.actInfo):GetActId(), shopId) then
        local node = shopRootNode:AddChildWithPath(shopId, self:GetActivityHeroShopPath())
        node:SetRedDotCount(1)
      end
      self:__OnActHeroShopUnlockInfo(shopId)
    end
  end

  self.__conditionListener = (ConditionListener.New)()
  ;
  (NetworkManager.luaNetworkAgent):AddLogoutAutoDelete(self.__conditionListener)
  if self._cfg == nil then
    return 
  end
  for k,shopId in pairs((self._cfg).shop_list) do
    local cfg = (ConfigData.shop)[shopId]
    if cfg ~= nil then
      if (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2) then
        do
          do
            if not saveUserData:IsActivityHeroShopRead((self.actInfo):GetActId(), shopId) then
              local node = shopRootNode:AddChildWithPath(shopId, self:GetActivityHeroShopPath())
              node:SetRedDotCount(1)
            end
            if not isLogin then
              self:__OnActHeroShopUnlockInfo(shopId)
            end
            ;
            (self.__conditionListener):AddConditionChangeListener(shopId, unlockShopListener, cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
            -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

ActivityHeroGrow.__OnActHeroShopUnlockInfo = function(self, shopId)
  -- function num : 0_3 , upvalues : _ENV, NoticeData
  local shopCfg = (ConfigData.shop)[shopId]
  if shopCfg == nil then
    error("shop cfg is null,id:" .. tostring(shopId))
    return 
  end
  NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).ActivityHeroShop, nil, {(LanguageUtil.GetLocaleText)(shopCfg.name)}, nil))
end

ActivityHeroGrow.GetActivityHeroShopReddotNode = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local nodeParent = self:GetActivityReddot()
  local shopRootNode = nodeParent:AddChild(RedDotStaticTypeId.ActivityShop)
  return shopRootNode
end

ActivityHeroGrow.GetActivityHeroShopPath = function(self)
  -- function num : 0_5
  return self.__shopDynPath
end

ActivityHeroGrow.__UpdateReddot = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local nodeParent = self:GetActivityReddot()
  local node = nodeParent:AddChild(RedDotStaticTypeId.ActivityChallenge)
  node:SetRedDotCount(self:GetHeroGrowChallengeCount())
end

ActivityHeroGrow.RefreshHeroGrowStateDailyFlush = function(self)
  -- function num : 0_7
  if not self:IsActivityRunning() then
    return 
  end
  self:__UpdateReddot()
end

ActivityHeroGrow.ReqHeroGrowDailyFullReward = function(self, day, callback)
  -- function num : 0_8 , upvalues : _ENV
  if not self:IsHeroGrowFullRewardCanReceive(day) then
    return 
  end
  local actId = self:GetActId()
  local network = NetworkManager:GetNetwork(NetworkTypeID.HeroGrow)
  network:CS_ACTIVITYSectorHero_DailyTaskFullReward(actId, day, function()
    -- function num : 0_8_0 , upvalues : self, callback
    self:RefreshHeroGrowDailyTaskComReddot()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityHeroGrow.ReqHeroGrowDailyTaskAllReward = function(self, callback)
  -- function num : 0_9 , upvalues : _ENV
  if not self:IsHeroGrowExistTaskReceive() then
    return 
  end
  local actId = self:GetActId()
  local network = NetworkManager:GetNetwork(NetworkTypeID.HeroGrow)
  network:CS_ACTIVITYSectorHero_DailyTaskAllReward(actId, function()
    -- function num : 0_9_0 , upvalues : self, callback
    self:RefreshHeroGrowDailyTaskComReddot()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityHeroGrow.ReqHeroGrowSingleTokenReward = function(self, tokenRewardLv, callback)
  -- function num : 0_10 , upvalues : _ENV
  if (self._tokenRewardLevelDic)[tokenRewardLv] then
    return 
  end
  local actId = self:GetActId()
  local tokenRewardCfg = (ConfigData.activity_hero_token_reward)[actId]
  if tokenRewardCfg == nil then
    return 
  end
  local tokenCfg = tokenRewardCfg[tokenRewardLv]
  if tokenCfg == nil then
    return 
  end
  if PlayerDataCenter:GetItemCount((self._cfg).token) < tokenCfg.need_token then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.HeroGrow)
  network:CS_ACTIVITYSectorHero_SingleTokenReward(actId, tokenRewardLv, function()
    -- function num : 0_10_0 , upvalues : self, callback
    self:RefreshHeroGrowLvRewrdReddot()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityHeroGrow.ReqHeroGrowAllTokenReward = function(self, callback)
  -- function num : 0_11 , upvalues : _ENV
  if not self:IsHeroGrowExistLvReward() then
    return 
  end
  local actId = self:GetActId()
  local network = NetworkManager:GetNetwork(NetworkTypeID.HeroGrow)
  network:CS_ACTIVITYSectorHero_AllTokenReward(actId, function()
    -- function num : 0_11_0 , upvalues : self, callback
    self:RefreshHeroGrowLvRewrdReddot()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityHeroGrow.RefreshHeroGrowDailyTaskComReddot = function(self)
  -- function num : 0_12 , upvalues : ActivityCharDunConfig
  if not self:IsHeroGrowVer2() then
    return 
  end
  local nodeParent = self:GetActivityReddot()
  if nodeParent == nil then
    return 
  end
  local nodeChild = nodeParent:AddChild((ActivityCharDunConfig.reddotType).dailyTaskCom)
  nodeChild:SetRedDotCount(self:IsHeroGrowExistTaskReceive() and 1 or 0)
end

ActivityHeroGrow.RefreshHeroGrowDailyTaskNewReddot = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActivityCharDunConfig
  if not self:IsHeroGrowVer2() then
    return 
  end
  local nodeParent = self:GetActivityReddot()
  if nodeParent == nil then
    return 
  end
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local dailyTaskLookDic = userDataCache:GetHeroGrowDailyTask(self:GetActId())
  local reddotNum = 0
  for day,_ in pairs(self._dailyTaskFullRewardDic) do
    if not self:IsLookedHeroGrowDailyTask(day) then
      reddotNum = 1
      break
    end
  end
  do
    local nodeChild = nodeParent:AddChild((ActivityCharDunConfig.reddotType).dailyTaskNew)
    nodeChild:SetRedDotCount(reddotNum)
  end
end

ActivityHeroGrow.RefreshHeroGrowLvRewrdReddot = function(self)
  -- function num : 0_14 , upvalues : ActivityCharDunConfig
  if not self:IsHeroGrowVer2() then
    return 
  end
  local nodeParent = self:GetActivityReddot()
  if nodeParent == nil then
    return 
  end
  local nodeChild = nodeParent:AddChild((ActivityCharDunConfig.reddotType).lvReward)
  nodeChild:SetRedDotCount(self:IsHeroGrowExistLvReward() and 1 or 0)
end

ActivityHeroGrow.RefreshHeroGrowChallengeNewReddot = function(self)
  -- function num : 0_15 , upvalues : ActivityCharDunConfig, _ENV
  if not self:IsHeroGrowVer2() then
    return 
  end
  local nodeParent = self:GetActivityReddot()
  if nodeParent == nil then
    return 
  end
  local nodeChild = nodeParent:AddChild((ActivityCharDunConfig.reddotType).challengeNew)
  if not self:IsActivityRunning() then
    nodeChild:SetRedDotCount(0)
    return 
  end
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local lastLookStageId = userDataCache:GetHeroGrowChallengeStageId(self:GetActId())
  local newLookStageId = (PlayerDataCenter.sectorStage):GetSectorUnlockProcess((self._cfg).rechallenge_stage)
  nodeChild:SetRedDotCount(lastLookStageId < newLookStageId and 1 or 0)
end

ActivityHeroGrow.SetHeroGrowChallengeNew = function(self)
  -- function num : 0_16 , upvalues : _ENV, ActivityCharDunConfig
  if not self:IsHeroGrowVer2() then
    return 
  end
  local nodeParent = self:GetActivityReddot()
  if nodeParent == nil then
    return 
  end
  local newLookStageId = (PlayerDataCenter.sectorStage):GetSectorUnlockProcess((self._cfg).rechallenge_stage)
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  userDataCache:SetHeroGrowChallengeStageId(self:GetActId(), newLookStageId)
  local nodeChild = nodeParent:AddChild((ActivityCharDunConfig.reddotType).challengeNew)
  nodeChild:SetRedDotCount(0)
end

ActivityHeroGrow.LookedHeroGrowDailyTaskNewReddot = function(self, day)
  -- function num : 0_17 , upvalues : _ENV
  if not self:IsHeroGrowVer2() then
    return 
  end
  if self:IsLookedHeroGrowDailyTask(day) then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._dailyTaskLookDic)[day] = true
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  userDataCache:SetHeroGrowDailyTask(self:GetActId(), day)
  self:RefreshHeroGrowDailyTaskNewReddot()
end

ActivityHeroGrow.SetHeroGrowDungeonBattle = function(self, dungeonId)
  -- function num : 0_18 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  userDataCache:SetHeroGrowBattleDungeon(self:GetActId(), dungeonId)
end

ActivityHeroGrow.GetHeroGrowDungeonBattle = function(self, dungeonId)
  -- function num : 0_19 , upvalues : _ENV
  if not self:IsActivityRunning() then
    return false
  end
  if PlayerDataCenter:GetTotalBattleTimes(dungeonId) > 0 then
    return false
  end
  if (self._dungonLevelDic)[dungeonId] == nil or not ((self._dungonLevelDic)[dungeonId]):GetIsLevelUnlock() then
    return false
  end
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  return not userDataCache:GetHeroGrowBattleDungeon(self:GetActId(), dungeonId)
end

ActivityHeroGrow.IsLookedHeroGrowDailyTask = function(self, day)
  -- function num : 0_20 , upvalues : _ENV
  do
    if self._dailyTaskLookDic == nil then
      local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      self._dailyTaskLookDic = userDataCache:GetHeroGrowDailyTask(self:GetActId())
      if self._dailyTaskLookDic == nil then
        self._dailyTaskLookDic = {}
      end
    end
    do return (self._dailyTaskLookDic)[day] ~= nil end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

ActivityHeroGrow.IsHeroGrowExistTaskReceive = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local allDayCfg = (ConfigData.activity_hero_task_daily)[self:GetActId()]
  if allDayCfg == nil then
    return false
  end
  for day,isPicked in pairs(self._dailyTaskFullRewardDic) do
    if not isPicked and self:IsHeroGrowDailyTaskCanComplete(day) then
      return true
    end
  end
  return false
end

ActivityHeroGrow.IsHeroGrowDailyTaskCanComplete = function(self, day)
  -- function num : 0_22 , upvalues : _ENV
  if (self._dailyTaskFullRewardDic)[day] then
    return false
  end
  local allDayCfg = (ConfigData.activity_hero_task_daily)[self:GetActId()]
  if allDayCfg == nil then
    return false
  end
  local dayCfg = allDayCfg[day]
  if dayCfg == nil then
    return false
  end
  local hasNoReceiveTask = false
  for _,taskId in ipairs(dayCfg.open_task_list) do
    if (self._finishedDailyTaskDic)[taskId] == nil then
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
      if taskData ~= nil and taskData:CheckComplete() then
        return true
      end
      hasNoReceiveTask = true
    end
  end
  for _,taskId in ipairs(dayCfg.wait_task_list) do
    if (self._finishedDailyTaskDic)[taskId] == nil then
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
      if taskData ~= nil and taskData:CheckComplete() then
        return true
      end
      hasNoReceiveTask = true
    end
  end
  return not hasNoReceiveTask
end

ActivityHeroGrow.IsHeroGrowDailyTaskReceive = function(self, day)
  -- function num : 0_23 , upvalues : _ENV
  if (self._dailyTaskFullRewardDic)[day] then
    return true
  end
  local allDayCfg = (ConfigData.activity_hero_task_daily)[self:GetActId()]
  if allDayCfg == nil then
    return false
  end
  local dayCfg = allDayCfg[day]
  if dayCfg == nil then
    return false
  end
  for _,taskId in ipairs(dayCfg.open_task_list) do
    if (self._finishedDailyTaskDic)[taskId] == nil then
      return false
    end
  end
  for _,taskId in ipairs(dayCfg.wait_task_list) do
    if (self._finishedDailyTaskDic)[taskId] == nil then
      return false
    end
  end
  return true
end

ActivityHeroGrow.IsHeroGrowFullRewardCanReceive = function(self, day)
  -- function num : 0_24 , upvalues : _ENV
  if (self._dailyTaskFullRewardDic)[day] == nil or (self._dailyTaskFullRewardDic)[day] then
    return false
  end
  local actId = self:GetActId()
  local heroDailyTaskCfg = (ConfigData.activity_hero_task_daily)[actId]
  if heroDailyTaskCfg == nil then
    return false
  end
  local dayCfg = heroDailyTaskCfg[day]
  if dayCfg == nil then
    return false
  end
  for _,taskId in ipairs(dayCfg.open_task_list) do
    if (self._finishedDailyTaskDic)[taskId] == nil then
      return false
    end
  end
  for _,taskId in ipairs(dayCfg.wait_task_list) do
    if (self._finishedDailyTaskDic)[taskId] == nil then
      return false
    end
  end
  return true
end

ActivityHeroGrow.IsHeroGrowFullRewardReceived = function(self, day)
  -- function num : 0_25
  return (self._dailyTaskFullRewardDic)[day]
end

ActivityHeroGrow.IsHeroGrowDailyTaskIsUnlock = function(self, day)
  -- function num : 0_26
  do return (self._dailyTaskFullRewardDic)[day] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHeroGrow.IsHeroGrowTaskAllUnlock = function(self)
  -- function num : 0_27 , upvalues : _ENV
  local actId = self:GetActId()
  local heroDailyTaskCfg = (ConfigData.activity_hero_task_daily)[actId]
  if heroDailyTaskCfg == nil then
    return true
  end
  return self:IsHeroGrowDailyTaskIsUnlock(#heroDailyTaskCfg)
end

ActivityHeroGrow.IsHeroGrowExistLvReward = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local actId = self:GetActId()
  local tokenRewardCfg = (ConfigData.activity_hero_token_reward)[actId]
  if tokenRewardCfg == nil then
    return false
  end
  local isCanReq = false
  local tokenCount = PlayerDataCenter:GetItemCount((self._cfg).token)
  for level,tokenCfg in ipairs(tokenRewardCfg) do
    if tokenCount >= tokenCfg.need_token then
      do
        if not (self._tokenRewardLevelDic)[level] then
          return true
        end
        -- DECOMPILER ERROR at PC28: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC28: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  return false
end

ActivityHeroGrow.IsHeroGrowLvReceived = function(self, level)
  -- function num : 0_29
  return (self._tokenRewardLevelDic)[level]
end

ActivityHeroGrow.GetHeroGrowCfg = function(self)
  -- function num : 0_30
  return self._cfg
end

ActivityHeroGrow.GetHeroGrowCostNum = function(self)
  -- function num : 0_31
  return self._costNum
end

ActivityHeroGrow.GetHeroGrowCostId = function(self)
  -- function num : 0_32
  return (self._cfg).token
end

ActivityHeroGrow.IsHeroGrowLimiTimes = function(self)
  -- function num : 0_33
  return self._isHasLimitTimes
end

ActivityHeroGrow.GetHeroGrowChallengeCount = function(self)
  -- function num : 0_34 , upvalues : _ENV
  if not self:IsActivityRunning() or not self:IsHeroGrowLimiTimes() then
    return 0
  end
  if PlayerDataCenter.timestamp <= self._lastExpiredTm then
    return self._remainTimes
  end
  local nextTime = self:GetHeroGrowChallengeRefrehTime()
  local dayCount = (math.ceil)((nextTime - self._lastExpiredTm) / CommonUtil.DaySeconds)
  if dayCount <= 0 then
    return 0
  end
  local count = (self._cfg).free_times * dayCount + self._remainTimes
  count = (math.min)(count, (self._cfg).max_time)
  return count
end

ActivityHeroGrow.GetHeroGrowChallengeRefrehTime = function(self)
  -- function num : 0_35 , upvalues : _ENV
  if not self:IsActivityRunning() then
    return self:GetActivityBornTime()
  end
  local timeCtrl = ControllerManager:GetController(ControllerTypeId.TimePass)
  local nextTm = timeCtrl:GetLogicTodayPassTimeStamp()
  local timestamp = PlayerDataCenter.timestamp
  if nextTm < PlayerDataCenter.timestamp then
    nextTm = nextTm + CommonUtil.DaySeconds
  end
  return nextTm
end

ActivityHeroGrow.GetHeroGrowDungeonDic = function(self)
  -- function num : 0_36
  return self._dungonLevelDic
end

ActivityHeroGrow.GetHeroGrowReceivedToken = function(self)
  -- function num : 0_37
  return self._tokenRewardLevelDic
end

ActivityHeroGrow.GetHeroGrowFinishTask = function(self)
  -- function num : 0_38
  return self._finishedDailyTaskDic
end

ActivityHeroGrow.IsHeroGrowVer2 = function(self)
  -- function num : 0_39 , upvalues : _ENV
  do return (ConfigData.activity_hero_token_reward)[self:GetActId()] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHeroGrow.GetActivityReddotNum = function(self)
  -- function num : 0_40 , upvalues : _ENV, ActivityCharDunConfig
  if not self:IsHeroGrowVer2() then
    local cfgId = ((ConfigData.activity_entrance).activityIdDic)[(self.actInfo):GetActivityFrameId()]
    local cfg = (ConfigData.activity_entrance)[cfgId]
    local nodeParent = self:GetActivityReddot()
    local isRed = cfg.red_dot == 1
    return not isRed, nodeParent:GetRedDotCount()
  end
  local nodeParent = self:GetActivityReddot()
  if nodeParent == nil then
    return false, 0
  end
  local isRed = false
  for reddotId,_ in pairs(ActivityCharDunConfig.reddotIsRedType) do
    local reddot = nodeParent:GetChild(reddotId)
    if reddot ~= nil and reddot:GetRedDotCount() > 0 then
      isRed = true
      break
    end
  end
  do return not isRed, nodeParent:GetRedDotCount() end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

return ActivityHeroGrow

