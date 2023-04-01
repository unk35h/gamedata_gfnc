-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivitySpringData = class("ActivitySpringData", ActivityBase)
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local eActInteract = require("Game.ActivityLobby.Activity.2023Spring.eActInteract")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).Spring
local ActivitySpringEnum = require("Game.ActivitySpring.Data.ActivitySpringEnum")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local ActivitySeasonDungeonData = require("Game.ActivityChristmas.ActivitySeasonDungeonData")
local WarChessSeasonAddtionData = require("Game.WarChessSeason.WarChessSeasonAddtionData")
local ActTechTree = require("Game.ActivityFrame.ActTechTree")
local ActInternalUnlockInfo = require("Game.Common.Activity.ActInternalUnlockInfo")
local ActivitySpringStoryData = require("Game.ActivitySpring.Data.ActivitySpringStoryData")
ActivitySpringData.InitSpringData = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV, ActivitySpringStoryData
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_spring_main)[msg.actId]
  self._levelTypeCfg = (ConfigData.activity_spring_level)[(self._mainCfg).hard_level_type]
  self._timepassCtr = ControllerManager:GetController(ControllerTypeId.TimePass, true)
  self._frameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  self._onceTaskIds = {}
  local activityGenal = (ConfigData.activity_general)[(self._mainCfg).general_id]
  if activityGenal ~= nil then
    self._onceTaskIds = activityGenal.once_quest
    self:RefreshRedOnceTask()
  end
  self._refreshTaskIds = {}
  self:__InitTechData()
  self:UpdateSpringMsg(msg)
  self._storyData = (ActivitySpringStoryData.New)()
  ;
  (self._storyData):InitSpringData(msg.actId, msg.interacted)
  self:RefreshRedTalk()
  self:RefreshSpring23LevelUnlockBuleDot()
  self:__InitUnlockInfo()
  self:RefreshRedSpringTech()
  ExplorationManager:AddEpNewEpBuffSelect((self._mainCfg).main_stage, (self._mainCfg).initial_protocol_all)
end

ActivitySpringData.UpdateSpringMsg = function(self, msg)
  -- function num : 0_1
  if (msg.refreshTaskId)[1] ~= nil then
    self._refreshTaskIds = msg.refreshTaskId
  end
  self._nextExpireTm = msg.nextRefreshTime
  if self._nextExpireTm == 0 then
    self._nextExpireTm = (self._mainCfg).task_time
  end
  if not msg.dungeonFrame then
    self._dungeonFrame = {}
    if self._actTechTree ~= nil and msg.tech ~= nil then
      (self._actTechTree):UpdateActTechTree(msg.tech)
    end
    self:RefreshRedDailyTask()
  end
end

ActivitySpringData.UpdateDungeonFrameByDunId = function(self, dungeonId, frame)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  if not (self._dungeonFrame)[dungeonId] or frame < (self._dungeonFrame)[dungeonId] or CommonUtil.UInt32Max <= frame then
    (self._dungeonFrame)[dungeonId] = frame
  end
end

ActivitySpringData.AddSpringRefDailyTask = function(self, taskIds, nextExpireTm)
  -- function num : 0_3 , upvalues : _ENV
  if taskIds[1] ~= nil then
    (table.insertto)(self._refreshTaskIds, taskIds)
  end
  self._nextExpireTm = nextExpireTm
  if self._nextExpireTm == 0 then
    self._nextExpireTm = (self._mainCfg).task_time
  end
  self:RefreshRedDailyTask()
end

ActivitySpringData.__InitTechData = function(self)
  -- function num : 0_4 , upvalues : ActTechTree, _ENV
  self._actTechTree = (ActTechTree.New)()
  ;
  (self._actTechTree):InitTechTree((self._mainCfg).tech_id, self)
  local RefreshRedTechCallback = BindCallback(self, self.RefreshRedSpringTech)
  ;
  (self._actTechTree):BindActTechUpdateFunc(RefreshRedTechCallback)
  ;
  (self._actTechTree):BindActTechAllResetFunc(RefreshRedTechCallback)
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  actFrameCtrl:AddActivityTech(self._actTechTree)
end

ActivitySpringData.__InitUnlockInfo = function(self)
  -- function num : 0_5 , upvalues : ActInternalUnlockInfo, _ENV
  self._unlockInfo = (ActInternalUnlockInfo.New)()
  local storyInteractCfgDic = (self._storyData):GetSpringStoryMain()
  local avgList = {}
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  for _,storyInteractCfg in pairs(storyInteractCfgDic) do
    if storyInteractCfg.story > 0 and not avgPlayCtrl:IsAvgPlayed(storyInteractCfg.story) then
      (table.insert)(avgList, storyInteractCfg.story)
    end
  end
  ;
  (self._unlockInfo):InitAvgPlayedUnlockInfo(avgList)
  local envIds = (self._mainCfg).env_list
  local envIdDic = {}
  for i,envId in ipairs(envIds) do
    if not self:IsSpring23EnvUnlock(envId) then
      envIdDic[envId] = true
    end
  end
  ;
  (self._unlockInfo):InitEnvUnlockInfo(envIdDic)
end

ActivitySpringData.CalSpringAvgState = function(self)
  -- function num : 0_6
end

ActivitySpringData.SetSpringHardLevelLooked = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  userDataCache:SetSpring23HardLevelLooked(self:GetActId())
  self:RefreshRedHardLevel()
end

ActivitySpringData.RefreshRedOnceTask = function(self)
  -- function num : 0_8 , upvalues : ActivitySpringEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySpringEnum.reddotType).OnceTask)
  for i,taskId in ipairs(self._onceTaskIds) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil then
      -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

      if taskData:CheckComplete() and childReddot:GetRedDotCount() == 0 then
        childReddot:SetRedDotCount(1)
      end
      return 
    end
  end
  if childReddot:GetRedDotCount() > 0 then
    childReddot:SetRedDotCount(0)
  end
end

ActivitySpringData.RefreshRedTalk = function(self)
  -- function num : 0_9 , upvalues : ActivitySpringEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySpringEnum.reddotType).Talk)
  local haveTalk = (self._storyData):CheckHaveTalk(self:GetInteractCostNum())
  -- DECOMPILER ERROR at PC22: Unhandled construct in 'MakeBoolean' P1

  if haveTalk and childReddot:GetRedDotCount() == 0 then
    childReddot:SetRedDotCount(1)
  end
  do return  end
  if childReddot:GetRedDotCount() > 0 then
    childReddot:SetRedDotCount(0)
  end
end

ActivitySpringData.RefreshRedHardLevel = function(self)
  -- function num : 0_10 , upvalues : ActivitySpringEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySpringEnum.reddotType).HardLevel)
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local haveLooked = userDataCache:GetSpring23HardLevelLooked(self:GetActId())
  -- DECOMPILER ERROR at PC27: Unhandled construct in 'MakeBoolean' P1

  if not haveLooked and childReddot:GetRedDotCount() == 0 then
    childReddot:SetRedDotCount(1)
  end
  do return  end
  if childReddot:GetRedDotCount() > 0 then
    childReddot:SetRedDotCount(0)
  end
end

ActivitySpringData.RefreshRedDailyTask = function(self)
  -- function num : 0_11 , upvalues : ActivitySpringEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySpringEnum.reddotType).DailyTask)
  for i,taskId in ipairs(self._refreshTaskIds) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil then
      -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

      if taskData:CheckComplete() and childReddot:GetRedDotCount() == 0 then
        childReddot:SetRedDotCount(1)
      end
      return 
    end
  end
  if childReddot:GetRedDotCount() > 0 then
    childReddot:SetRedDotCount(0)
  end
end

ActivitySpringData.RefreshRedSpringTech = function(self)
  -- function num : 0_12 , upvalues : ActivitySpringEnum, _ENV
  if self._actTechTree == nil then
    return 
  end
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local reddotChild = reddot:AddChild((ActivitySpringEnum.reddotType).Tech)
  local itemReddot = reddot:AddChild((ActivitySpringEnum.reddotType).TechItemLimit)
  if not self:IsActivityRunning() then
    reddotChild:ClearChild()
    itemReddot:SetRedDotCount(0)
    return 
  end
  local treeDic = (self._actTechTree):GetTechDataDic()
  local branchDic = treeDic[(self._mainCfg).tech_special_branch]
  local hasLeveUpTech = false
  for k,techData in pairs(branchDic) do
    if techData:IsCouldLevelUp() then
      hasLeveUpTech = true
      break
    end
  end
  do
    local reddotChildPage = reddotChild:AddChild((self._mainCfg).tech_special_branch)
    reddotChildPage:SetRedDotCount(hasLeveUpTech and 1 or 0)
    local flag, itemId = (self._actTechTree):GetTreeResetReturnItemId()
    if flag then
      if PlayerDataCenter:GetItemCount(itemId) >= 16000 then
        if not hasLeveUpTech then
          for k,techDataDic in pairs(treeDic) do
            if k ~= (self._mainCfg).tech_special_branch then
              for k,techData in pairs(techDataDic) do
                if techData:IsCouldLevelUp() then
                  hasLeveUpTech = true
                  break
                end
              end
            end
          end
        end
        do
          itemReddot:SetRedDotCount(hasLeveUpTech and 1 or 0)
          itemReddot:SetRedDotCount(0)
        end
      end
    end
  end
end

ActivitySpringData.GetActivityReddotNum = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActivitySpringEnum
  local isBlue = true
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    error("can\'t get activity reddot node")
    return false, 0
  end
  local num = actRedDotNode:GetRedDotCount()
  for i,v in ipairs(ActivitySpringEnum.reddotIsRedType) do
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

ActivitySpringData.RefreshSpringUnlockAvgPlayed = function(self)
  -- function num : 0_14
  if self._unlockInfo == nil then
    return 
  end
  ;
  (self._unlockInfo):UpdateAvgPlayedUnlockInfo()
end

ActivitySpringData.RefreshSpringUnlockEnv = function(self, precondition, isForce)
  -- function num : 0_15 , upvalues : _ENV
  if self._unlockInfo == nil then
    return 
  end
  local playEndTime = self:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 
  end
  if not isForce and ((ConfigData.activity_spring_advanced_env).preconditionDic)[precondition] == nil then
    return 
  end
  local envIdDic = (self._unlockInfo):GetEnvUnlockInfo()
  if envIdDic == nil then
    return 
  end
  local actId = self:GetActId()
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local isNeedUpdateBlueDot = false
  for envId,_ in pairs(envIdDic) do
    if self:IsSpring23EnvUnlock(envId) then
      (self._unlockInfo):AddEnvUnlockInfo(envId)
      userDataCache:SetSpring23IsNotEnteredNewEnv(actId, envId, true)
      isNeedUpdateBlueDot = true
    end
  end
  if isNeedUpdateBlueDot then
    self:RefreshSpring23LevelUnlockBuleDot()
  end
end

ActivitySpringData.RefreshSpring23LevelUnlockBuleDot = function(self)
  -- function num : 0_16 , upvalues : ActivitySpringEnum, _ENV, ActLbUtil, eActInteract
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivitySpringEnum.reddotType).EpEnv)
  local actId = self:GetActId()
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local envList = self:GetSpringLevelEnvs()
  for _,envId in pairs(envList) do
    local isHaveNotEnteredNewEnv = userDataCache:GetSpring23IsNotEnteredNewEnv(actId, envId)
    if isHaveNotEnteredNewEnv then
      childReddot:SetRedDotCount(1)
      ;
      (ActLbUtil.UpdLbEnttBluedot)((eActInteract.eLbIntrctEntityId).EnvSelect)
      return 
    end
  end
  childReddot:SetRedDotCount(0)
  ;
  (ActLbUtil.UpdLbEnttBluedot)((eActInteract.eLbIntrctEntityId).EnvSelect)
end

ActivitySpringData.ReqSpringDailyTask = function(self, taskId, callback)
  -- function num : 0_17 , upvalues : _ENV, CommonRewardData
  if not (table.contain)(self._refreshTaskIds, taskId) then
    return 
  end
  local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
  if taskData == nil or not taskData:CheckComplete() then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  network:CS_Activity_Quest_Commit(self:GetActFrameId(), taskId, function()
    -- function num : 0_17_0 , upvalues : taskData, CommonRewardData, _ENV, self, taskId, callback
    local rewards, nums = taskData:GetTaskCfgRewards()
    local CRData = (CommonRewardData.CreateCRDataUseList)(rewards, nums)
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_17_0_0 , upvalues : CRData
      if window == nil then
        return 
      end
      window:AddAndTryShowReward(CRData)
    end
)
    ;
    (table.removebyvalue)(self._refreshTaskIds, taskId)
    self:RefreshRedDailyTask()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivitySpringData.ReqSpringOnceTask = function(self, taskId, callback)
  -- function num : 0_18 , upvalues : _ENV
  if not (table.contain)(self._onceTaskIds, taskId) then
    return 
  end
  local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
  if taskData == nil or not taskData:CheckComplete() then
    return 
  end
  local taskCtrl = ControllerManager:GetController(ControllerTypeId.Task)
  taskCtrl:SendCommitQuestReward(taskData, true, function()
    -- function num : 0_18_0 , upvalues : self, callback
    self:RefreshRedOnceTask()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivitySpringData.ReqSpringDailyRef = function(self, taskId, callback)
  -- function num : 0_19 , upvalues : _ENV
  local times = self:GetSpringRefTimes()
  if (self._mainCfg).daily_task_refresh_max <= times then
    return 
  end
  local index = (table.indexof)(self._refreshTaskIds, taskId)
  if index then
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData == nil or taskData:CheckComplete() then
      return 
    end
    ;
    (self._frameNet):CS_ACTIVITY_RefreshSingleQuestByUser(self:GetActFrameId(), taskId, function(args)
    -- function num : 0_19_0 , upvalues : _ENV, self, index, callback
    if args == nil or args.Count == 0 then
      if isGameDev then
        error("args.Count == 0")
      end
      return 
    end
    local newTaskId = args[0]
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self._refreshTaskIds)[index] = newTaskId
    self:RefreshRedDailyTask()
    if callback ~= nil then
      callback(newTaskId)
    end
  end
)
  end
end

ActivitySpringData.ReqSpringAllOnceTask = function(self, callback)
  -- function num : 0_20 , upvalues : _ENV
  local taskIdDic = {}
  for _,taskId in ipairs(self._onceTaskIds) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil and taskData:CheckComplete() then
      taskIdDic[taskId] = true
    end
  end
  if (table.count)(taskIdDic) == 0 then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.Task)
  network:CS_QUEST_OneKeyPick(taskIdDic, function()
    -- function num : 0_20_0 , upvalues : self, callback
    self:RefreshRedOnceTask()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivitySpringData.IsSpring23EnvUnlock = function(self, envId)
  -- function num : 0_21 , upvalues : _ENV
  if self._tempUnlockEnvDic == nil then
    self._tempUnlockEnvDic = {}
  end
  if (self._tempUnlockEnvDic)[envId] then
    return true
  end
  local cfg = (ConfigData.activity_spring_advanced_env)[envId]
  if cfg == nil then
    return false
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  if #cfg.pre_condition == 0 and cfg.need_interact <= 0 then
    (self._tempUnlockEnvDic)[envId] = true
    return true
  end
  if (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2) then
    local need_interact = cfg.need_interact
    if need_interact > 0 then
      local actId = self:GetActId()
      local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass)
      local spring23InteractElement = timePassCtrl:getCounterElemData(proto_object_CounterModule.CounterModuleActivitySpringInteractNum, actId)
      if spring23InteractElement == nil then
        return false
      else
        if spring23InteractElement.times < need_interact then
          return false
        end
      end
    end
    do
      do
        -- DECOMPILER ERROR at PC63: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (self._tempUnlockEnvDic)[envId] = true
        do return true end
        return false
      end
    end
  end
end

ActivitySpringData.IsSpring23DiffUnlock = function(self, envId, diffId, index)
  -- function num : 0_22 , upvalues : _ENV
  local envCfg = (ConfigData.activity_spring_advanced_env)[envId]
  local stageList = envCfg.stage_id
  local stageId = stageList[index]
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local isUnlock = (CheckCondition.CheckLua)(stageCfg.pre_condition, stageCfg.pre_para1, stageCfg.pre_para2)
  local unlockDes = (CheckCondition.GetUnlockInfoLua)(stageCfg.pre_condition, stageCfg.pre_para1, stageCfg.pre_para2)
  return isUnlock, unlockDes
end

ActivitySpringData.IsSpring23EnvHaveDiff = function(self, envId, diff, index)
  -- function num : 0_23 , upvalues : _ENV
  local envCfg = (ConfigData.activity_spring_advanced_env)[envId]
  local stageList = envCfg.stage_id
  local stageCount = #stageList
  if index <= stageCount then
    return true
  end
  return false
end

ActivitySpringData.CheckIsSpringChallengeDungeon = function(self, dungeonId)
  -- function num : 0_24 , upvalues : _ENV
  local dun_levels = (self._levelTypeCfg).dungeon_levels
  for i,v in pairs(dun_levels) do
    if v == dungeonId then
      return true
    end
  end
  return false
end

ActivitySpringData.GetSpringChallengeRecord = function(self, dungeonId)
  -- function num : 0_25 , upvalues : _ENV
  if dungeonId == nil or self._dungeonFrame == nil then
    error("dungeonFrame NIL or param error")
    return nil
  end
  return (self._dungeonFrame)[dungeonId]
end

ActivitySpringData.GetSpringHardLevelCfg = function(self)
  -- function num : 0_26
  return self._levelTypeCfg
end

ActivitySpringData.GetSpringChallengeDungeonIndex = function(self, dungeonId)
  -- function num : 0_27 , upvalues : _ENV
  local dun_levels = (self._levelTypeCfg).dungeon_levels
  for i,v in pairs(dun_levels) do
    if v == dungeonId then
      return i
    end
  end
  return 1
end

ActivitySpringData.GetInteractCostNum = function(self)
  -- function num : 0_28 , upvalues : _ENV
  return PlayerDataCenter:GetItemCount((self._mainCfg).interact_item)
end

ActivitySpringData.GetInteractCostId = function(self)
  -- function num : 0_29
  return (self._mainCfg).interact_item
end

ActivitySpringData.GetSpringStoryData = function(self)
  -- function num : 0_30
  return self._storyData
end

ActivitySpringData.GetRankId = function(self)
  -- function num : 0_31
  return (self._levelTypeCfg).ranklist_id
end

ActivitySpringData.GetSpringLevelEnvs = function(self)
  -- function num : 0_32
  return (self._mainCfg).env_list
end

ActivitySpringData.GetSpringTicketID = function(self)
  -- function num : 0_33
  return (self._mainCfg).ticket_item
end

ActivitySpringData.GetSpringMainCfg = function(self)
  -- function num : 0_34
  return self._mainCfg
end

ActivitySpringData.GetSpringRefreshTaskIds = function(self)
  -- function num : 0_35
  return self._refreshTaskIds
end

ActivitySpringData.GetSpringOnceTskIds = function(self)
  -- function num : 0_36
  return self._onceTaskIds
end

ActivitySpringData.GetSpringTechTree = function(self)
  -- function num : 0_37
  return self._actTechTree
end

ActivitySpringData.GetSpringRefTimes = function(self)
  -- function num : 0_38 , upvalues : _ENV
  local elemtData = (self._timepassCtr):getCounterElemData(proto_object_CounterModule.CounterModuleActivityQuestUserRefreshTimes, self:GetActFrameId())
  if elemtData == nil or elemtData.nextExpiredTm < self._nextExpireTm then
    return 0
  end
  return elemtData.times
end

ActivitySpringData.GetSpringDailyTaskExpireTime = function(self)
  -- function num : 0_39
  return self._nextExpireTm
end

ActivitySpringData.GetSpringUnlockInfo = function(self)
  -- function num : 0_40
  return self._unlockInfo
end

ActivitySpringData.DealSpringWhenEnd = function(self)
  -- function num : 0_41 , upvalues : _ENV
  (self._actUnlockInfo):ResetAllUnlockData()
  ExplorationManager:RemoveEpNewEpBuffSelect((self._mainCfg).main_stage, (self._mainCfg).initial_protocol_all)
end

return ActivitySpringData

