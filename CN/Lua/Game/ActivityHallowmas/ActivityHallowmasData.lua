-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityHallowmasData = class("ActivityHallowmasData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).Hallowmas
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local ActivitySeasonDungeonData = require("Game.ActivityChristmas.ActivitySeasonDungeonData")
local WarChessSeasonAddtionData = require("Game.WarChessSeason.WarChessSeasonAddtionData")
local ActInternalUnlockInfo = require("Game.Common.Activity.ActInternalUnlockInfo")
local ActTechTree = require("Game.ActivityFrame.ActTechTree")
ActivityHallowmasData.InitHallowmasData = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_hallowmas_main)[msg.actId]
  self._expCfg = (ConfigData.activity_hallowmas_exp)[msg.actId]
  self._achievementCfg = {}
  local achievementCfg = (ConfigData.activity_hallowmas_achievement)[msg.actId]
  for k,v in pairs(achievementCfg) do
    local envId = ((ConfigData.activity_hallowmas_general_env).taskEnvDic)[v.task_id]
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R9 in 'UnsetPending'

    if envId == nil then
      (self._achievementCfg)[k] = v
    end
  end
  local count = #self._expCfg
  self._maxLevel = count
  self._cycleExp = ((self._expCfg)[count]).need_exp
  self._fixExpMax = ((self._expCfg)[self._maxLevel]).total_exp
  self._stageInfoCfg = (ConfigData.activity_hallowmas_stage_info)[msg.actId]
  self._net = NetworkManager:GetNetwork(NetworkTypeID.ActivityHallowmas)
  self._envDiffDic = {}
  for _,envId in ipairs((self._mainCfg).env_id) do
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R9 in 'UnsetPending'

    if envId ~= 0 then
      (self._envDiffDic)[envId] = {}
      local envCfg = (ConfigData.activity_hallowmas_general_env)[envId]
      for i,diffId in ipairs(envCfg.difficulty_id) do
        -- DECOMPILER ERROR at PC82: Confused about usage of register: R15 in 'UnsetPending'

        ((self._envDiffDic)[envId])[diffId] = true
      end
    end
  end
  self:__InitTechData()
  self:__GenDungeonData()
  self:__UpdateHallowmas(msg)
  self:__InitUnlockInfo()
end

ActivityHallowmasData.__InitUnlockInfo = function(self)
  -- function num : 0_1 , upvalues : ActInternalUnlockInfo, _ENV
  self._actUnlockInfo = (ActInternalUnlockInfo.New)()
  ;
  (self._actUnlockInfo):InitActAvgUnlockInfo((self._mainCfg).story_stage)
  do
    if self._envDiffDic ~= nil then
      local diffLockDic = {}
      for envId,diffDic in pairs(self._envDiffDic) do
        for diffId,_ in pairs(diffDic) do
          if not self:IsHallowmasDiffUnlock(diffId) then
            diffLockDic[diffId] = envId
          end
        end
      end
      ;
      (self._actUnlockInfo):InitActEnvDiffUnlockInfo(diffLockDic)
    end
    if self._dungeonDataDic ~= nil then
      local dunLockDic = {}
      for dungeonId,dungeonData in pairs(self._dungeonDataDic) do
        if not dungeonData:GetIsLevelUnlock() then
          dunLockDic[dungeonId] = dungeonData
        end
      end
      ;
      (self._actUnlockInfo):InitActDunRepeatUnlockInfo(dunLockDic)
    end
  end
end

ActivityHallowmasData.__InitTechData = function(self)
  -- function num : 0_2 , upvalues : ActTechTree, _ENV
  if (self._mainCfg).tech_id == 0 then
    return 
  end
  self._actTechTree = (ActTechTree.New)()
  ;
  (self._actTechTree):InitTechTree((self._mainCfg).tech_id, self)
  local RefreshHallowmasRedTechCallback = BindCallback(self, self.RefreshHallowmasRedTech)
  ;
  (self._actTechTree):BindActTechUpdateFunc(RefreshHallowmasRedTechCallback)
  ;
  (self._actTechTree):BindActTechAllResetFunc(RefreshHallowmasRedTechCallback)
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  actFrameCtrl:AddActivityTech(self._actTechTree)
end

ActivityHallowmasData.UpdateHallowmasData = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  self:__UpdateHallowmas(msg)
  MsgCenter:Broadcast(eMsgEventId.ActivityHallowmas, self:GetActId())
end

ActivityHallowmasData.__UpdateHallowmas = function(self, msg)
  -- function num : 0_4 , upvalues : _ENV
  local lastLevel = self._level
  self._level = msg.level
  self._exp = msg.totalScore
  self._dailyExp = msg.dailyScore
  self._taskRefTimes = (msg.quest).refreshCnt
  self._expiredTm = (msg.quest).expireTm
  self._highestScore = msg.highestScore
  local lastRecord = self._warChessRecord
  self._warChessRecord = msg.warChessRecord
  if lastLevel ~= nil and self._level ~= lastLevel then
    (self._actUnlockInfo):UpdateActAvgUnlockInfo()
  end
  if lastRecord ~= nil and self._warChessRecord ~= nil then
    local hasChanged = false
    for k,value in pairs((self._warChessRecord).difficultyRecord) do
      if (lastRecord.difficultyRecord)[k] ~= value then
        hasChanged = true
        break
      end
    end
    do
      if hasChanged then
        local diffLockDic = (self._actUnlockInfo):GetActEnvDiffUnlockInfo()
        if diffLockDic ~= nil then
          for diff,value in pairs(diffLockDic) do
            if self:IsHallowmasDiffUnlock(diff) then
              (self._actUnlockInfo):AddActEnvDiffUnlockInfo(diff)
            end
          end
        end
        do
          do
            ;
            (self._actUnlockInfo):UpdateActDunRepeatUnlockInfo()
            if self._taskIdDic == nil then
              self._taskIdDic = {}
            else
              ;
              (table.clearmap)(self._taskIdDic)
            end
            self._taskIds = (msg.quest).received
            for i,v in ipairs((msg.quest).received) do
              -- DECOMPILER ERROR at PC89: Confused about usage of register: R9 in 'UnsetPending'

              (self._taskIdDic)[v] = true
            end
            self._expPickedDic = msg.obtainHistory
            self._cycleRewardPickedCount = msg.extraPickLevel
            self._curExp = self._exp - ((self._expCfg)[self._level]).total_exp
            if self._level == self._maxLevel then
              self._curExp = self._curExp - self._cycleExp * self._cycleRewardPickedCount
            end
            if msg.tech ~= nil and self._actTechTree ~= nil then
              (self._actTechTree):UpdateActTechTree(msg.tech)
            end
            self:__TryUpdateAddtionData()
            self:RefreshHallowmasRedDailyTask()
            self:RefreshHallowmasRedExp()
            self:RefreshHallowmasRedAchievement()
            self:RefreshHallowmasRedSectorAvg()
            self:RefreshHallowmasRedTech()
            self:RefreshHallowmasRedRedEnvTask()
          end
        end
      end
    end
  end
end

ActivityHallowmasData.__GenSectorAvgDic = function(self)
  -- function num : 0_5 , upvalues : _ENV
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

ActivityHallowmasData.__GenDungeonData = function(self)
  -- function num : 0_6 , upvalues : _ENV, ActivitySeasonDungeonData
  self._dungeonDataDic = {}
  local actId = self:GetActId()
  self._dungeonIdList = ((ConfigData.season_battle_ex).level_list_dic)[actId]
  if self._dungeonIdList == nil then
    return 
  end
  for index,dunStageId in pairs(self._dungeonIdList) do
    local extraCfg = ((ConfigData.season_battle_ex)[actId])[dunStageId]
    local dungeonData = (ActivitySeasonDungeonData.New)(dunStageId, extraCfg, actId, index)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self._dungeonDataDic)[dunStageId] = dungeonData
  end
end

ActivityHallowmasData.__TryUpdateAddtionData = function(self)
  -- function num : 0_7
  if self._seasonAddtionData == nil then
    return 
  end
  ;
  (self._seasonAddtionData):SetSeasonScoreData(self._dailyExp, (self._mainCfg).score_daily_limit)
end

ActivityHallowmasData.RefreshHallowmasRedDailyTask = function(self, taskData)
  -- function num : 0_8 , upvalues : ActivityHallowmasEnum, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local taskRed = actRed:AddChild((ActivityHallowmasEnum.reddotType).DailyTask)
  if not self:IsActivityRunning() then
    taskRed:SetRedDotCount(0)
    return 
  end
  if taskData ~= nil then
    if taskData:CheckComplete() and taskRed:GetRedDotCount() ~= 1 then
      taskRed:SetRedDotCount(1)
    end
    return 
  end
  if self:IsActivityRunning() then
    for taskId,_ in pairs(self._taskIdDic) do
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
      if taskData ~= nil and taskData:CheckComplete() then
        taskRed:SetRedDotCount(1)
        return 
      end
    end
  end
  do
    taskRed:SetRedDotCount(0)
  end
end

ActivityHallowmasData.RefreshHallowmasRedExp = function(self)
  -- function num : 0_9 , upvalues : ActivityHallowmasEnum
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local expRed = actRed:AddChild((ActivityHallowmasEnum.reddotType).Exp)
  expRed:SetRedDotCount(self:IsHallowmasExpAllReceive() and 1 or 0)
end

ActivityHallowmasData.RefreshHallowmasRedAchievement = function(self, taskData)
  -- function num : 0_10 , upvalues : ActivityHallowmasEnum, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local achienementRed = actRed:AddChild((ActivityHallowmasEnum.reddotType).Achievement)
  if taskData ~= nil then
    if taskData:CheckComplete() and achienementRed:GetRedDotCount() ~= 1 then
      achienementRed:SetRedDotCount(1)
    end
    return 
  end
  for taskId,_ in pairs(self._achievementCfg) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil and taskData:CheckComplete() then
      achienementRed:SetRedDotCount(1)
      return 
    end
  end
  achienementRed:SetRedDotCount(0)
end

ActivityHallowmasData.RefreshHallowmasRedRedEnvTask = function(self, taskData, envId)
  -- function num : 0_11 , upvalues : ActivityHallowmasEnum, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local envTaskRed = actRed:AddChild((ActivityHallowmasEnum.reddotType).EnvTask)
  if not self:IsActivityRunning() then
    envTaskRed:ClearChild()
    return 
  end
  if taskData ~= nil then
    local envId = ((ConfigData.activity_hallowmas_general_env).taskEnvDic)[taskData.id]
    do
      do
        if envId ~= nil and taskData:CheckComplete() and self:IsHallowmasEnvUnlock(envId) then
          local envIdRed = envTaskRed:AddChild(envId)
          if envIdRed:GetRedDotCount() ~= 1 then
            envIdRed:SetRedDotCount(1)
          end
        end
        do return  end
        if envId ~= nil then
          local envIdRed = envTaskRed:AddChild(envId)
          local envCfg = (ConfigData.activity_hallowmas_general_env)[envId]
          for _,taskId in ipairs(envCfg.env_task) do
            local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
            if taskData ~= nil and taskData:CheckComplete() then
              envIdRed:SetRedDotCount(1)
              return 
            end
          end
          envIdRed:SetRedDotCount(0)
          return 
        end
        do
          for _,singEnvId in ipairs((self._mainCfg).env_id) do
            if self:IsHallowmasEnvUnlock(singEnvId) then
              local envIdRed = envTaskRed:AddChild(singEnvId)
              local envCfg = (ConfigData.activity_hallowmas_general_env)[singEnvId]
              local redCount = 0
              for _,taskId in ipairs(envCfg.env_task) do
                local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
                if taskData ~= nil and taskData:CheckComplete() then
                  redCount = 1
                  break
                end
              end
              do
                do
                  envIdRed:SetRedDotCount(redCount)
                  -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
        end
      end
    end
  end
end

ActivityHallowmasData.RefreshHallowmasRedSectorAvg = function(self)
  -- function num : 0_12 , upvalues : ActivityHallowmasEnum, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local sectorAvgRed = actRed:AddChild((ActivityHallowmasEnum.reddotType).SectorAvg)
  if self._avgIdDic == nil then
    self:__GenSectorAvgDic()
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay, true)
  for k,v in pairs(self._avgIdDic) do
    local played = avgPlayCtrl:IsAvgPlayed(k)
    local unlock = avgPlayCtrl:IsAvgUnlock(k)
    if not played and unlock then
      sectorAvgRed:SetRedDotCount(1)
      return 
    end
  end
  sectorAvgRed:SetRedDotCount(0)
end

ActivityHallowmasData.RefreshHallowmasRedTech = function(self)
  -- function num : 0_13 , upvalues : ActivityHallowmasEnum, _ENV
  if self._actTechTree == nil then
    return 
  end
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local reddotChild = reddot:AddChild((ActivityHallowmasEnum.reddotType).Tech)
  local itemReddot = reddot:AddChild((ActivityHallowmasEnum.reddotType).TechItemLimit)
  if not self:IsActivityRunning() then
    reddotChild:ClearChild()
    itemReddot:SetRedDotCount(0)
    return 
  end
  local branchDic = ((self._actTechTree):GetTechDataDic())[(self._mainCfg).tech_special_branch]
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
    itemReddot:SetRedDotCount(not flag or (PlayerDataCenter:GetItemCount(itemId) >= 20000 and 1) or 0)
  end
end

ActivityBase.GetActivityReddotNum = function(self)
  -- function num : 0_14 , upvalues : _ENV, ActivityHallowmasEnum
  local isBlue = true
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    error("can\'t get activity reddot node")
    return false, 0
  end
  local num = actRedDotNode:GetRedDotCount()
  for i,v in ipairs(ActivityHallowmasEnum.reddotIsRedType) do
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

ActivityHallowmasData.ReqHallowmasBuyScore = function(self, count, callback)
  -- function num : 0_15 , upvalues : _ENV
  if PlayerDataCenter.timestamp < (self._mainCfg).score_buy_time then
    return 
  end
  if self._maxLevel < self._level + count then
    return 
  end
  if not self._temp_buy_costDic then
    self._temp_buy_costDic = {}
    ;
    (table.clearmap)(self._temp_buy_costDic)
    for i = 0, count - 1 do
      local cfg = (self._expCfg)[self._level + i]
      local num = (self._temp_buy_costDic)[cfg.level_cost_id] or 0
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._temp_buy_costDic)[cfg.level_cost_id] = num + cfg.level_cost_num
    end
    for k,v in pairs(self._temp_buy_costDic) do
      -- DECOMPILER ERROR at PC63: Unhandled construct in 'MakeBoolean' P1

      if k == ConstGlobalItem.PaidSubItem and PlayerDataCenter:GetItemCount(k) + PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem) < v then
        return false
      end
      if PlayerDataCenter:GetItemCount(k) < v then
        return false
      end
    end
    ;
    (self._net):CS_ACTIVITY_Halloween2022_BuyScore(self:GetActId(), count, callback)
  end
end

ActivityHallowmasData.ReqHallowmasExpReceive = function(self, level, callback)
  -- function num : 0_16
  if not self:IsHallowmasLevelCanPick(level) then
    return 
  end
  ;
  (self._net):CS_ACTIVITY_Halloween2022_PickLevelReward(self:GetActId(), level, callback)
end

ActivityHallowmasData.ReqHallowmasExpCycle = function(self, callback)
  -- function num : 0_17
  if not self:IsHallowmasCycleCanPick() then
    return 
  end
  ;
  (self._net):CS_ACTIVITY_Halloween2022_PickCycleReward(self:GetActId(), callback)
end

ActivityHallowmasData.ReqHallowmasAllExp = function(self, callback)
  -- function num : 0_18
  if not self:IsHallowmasExpAllReceive() then
    return 
  end
  ;
  (self._net):CS_ACTIVITY_Halloween2022_PickAllLevelReward(self:GetActId(), callback)
end

ActivityHallowmasData.ReqHallowmasRefreshTask = function(self, taskId, callback)
  -- function num : 0_19 , upvalues : _ENV
  if not self:IsActivityRunning() then
    return 
  end
  if (self._mainCfg).daily_task_refresh_max <= self._taskRefTimes then
    return 
  end
  if (self._taskIdDic)[taskId] == nil then
    return 
  end
  local index = (table.indexof)(self._taskIds, taskId)
  ;
  (self._net):CS_ACTIVITY_Halloween2022_RefreshSingleQuest(self:GetActId(), taskId, function()
    -- function num : 0_19_0 , upvalues : callback, self, index
    if callback ~= nil then
      callback((self._taskIds)[index])
    end
  end
)
end

ActivityHallowmasData.ReqHallowmasCommitTask = function(self, taskId, callback)
  -- function num : 0_20 , upvalues : _ENV, CommonRewardData
  if not self:IsActivityRunning() then
    return 
  end
  local tasKType = nil
  if (self._taskIdDic)[taskId] then
    tasKType = 1
  else
    if (self._achievementCfg)[taskId] then
      tasKType = 2
    else
      local envId = ((ConfigData.activity_hallowmas_general_env).taskEnvDic)[taskId]
      if envId ~= nil and self:IsHallowmasEnvUnlock(envId) then
        tasKType = 3
      end
    end
  end
  do
    if tasKType == nil then
      return 
    end
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData == nil or not taskData:CheckComplete() then
      return 
    end
    local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
    network:CS_Activity_Quest_Commit(self:GetActFrameId(), taskId, function()
    -- function num : 0_20_0 , upvalues : tasKType, self, taskId, _ENV, taskData, CommonRewardData, callback
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    if tasKType == 1 then
      (self._taskIdDic)[taskId] = nil
      self:RefreshHallowmasRedDailyTask()
    else
      if tasKType == 2 then
        self:RefreshHallowmasRedAchievement()
      else
        if tasKType == 3 then
          local envId = ((ConfigData.activity_hallowmas_general_env).taskEnvDic)[taskId]
          self:RefreshHallowmasRedRedEnvTask(nil, envId)
        end
      end
    end
    do
      local rewards, nums = taskData:GetTaskCfgRewards()
      local CRData = (CommonRewardData.CreateCRDataUseList)(rewards, nums)
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_20_0_0 , upvalues : CRData
      if window == nil then
        return 
      end
      window:AddAndTryShowReward(CRData)
    end
)
      if callback ~= nil then
        callback()
      end
    end
  end
)
  end
end

ActivityHallowmasData.ReqHallowmasCommitEnvTaskList = function(self, taskIds, callback)
  -- function num : 0_21 , upvalues : _ENV
  if not self:IsActivityRunning() then
    return 
  end
  local envId = ((ConfigData.activity_hallowmas_general_env).taskEnvDic)[taskIds[1]]
  if envId == nil or not self:IsHallowmasEnvUnlock(envId) then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  network:CS_Activity_Quest_Select_Commit(self:GetActFrameId(), taskIds, function()
    -- function num : 0_21_0 , upvalues : self, envId, callback
    self:RefreshHallowmasRedRedEnvTask(nil, envId)
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityHallowmasData.ReqHallowmasAllChievement = function(self, callback)
  -- function num : 0_22 , upvalues : _ENV
  local taskIds = {}
  for taskId,_ in pairs(self._achievementCfg) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil and taskData:CheckComplete() then
      (table.insert)(taskIds, taskId)
    end
  end
  if taskIds[1] == nil then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  network:CS_Activity_Quest_Select_Commit(self:GetActFrameId(), taskIds, function()
    -- function num : 0_22_0 , upvalues : self, callback
    self:RefreshHallowmasRedAchievement()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityHallowmasData.IsHallowmasLevelCanPick = function(self, level)
  -- function num : 0_23
  if (self._expPickedDic)[level] then
    return false
  end
  do return level <= self._level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHallowmasData.IsHallowmasLevelReceived = function(self, level)
  -- function num : 0_24
  return (self._expPickedDic)[level]
end

ActivityHallowmasData.IsHallowmasCycleCanPick = function(self)
  -- function num : 0_25
  if self._level < self._maxLevel then
    return false
  end
  do return self._cycleExp <= self._curExp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHallowmasData.IsHallowmasCycleCanPick = function(self)
  -- function num : 0_26
  if self._level < self._maxLevel then
    return false
  end
  do return self._cycleExp <= self._curExp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHallowmasData.IsHallowmasExpAllReceive = function(self)
  -- function num : 0_27
  if self._level ~= #self._expPickedDic then
    return true
  end
  if self._cycleExp > self._curExp then
    do return self._level ~= self._maxLevel end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

ActivityHallowmasData.IsHallowmasSectorAvg = function(self, avgId)
  -- function num : 0_28
  if self._avgIdDic ~= nil then
    self:__GenSectorAvgDic()
  end
  return (self._avgIdDic)[avgId]
end

ActivityHallowmasData.IsHallowmasDiffUnlock = function(self, difficult)
  -- function num : 0_29 , upvalues : _ENV
  local cfg = (self._stageInfoCfg)[difficult]
  if cfg == nil then
    return false
  end
  if cfg.preConditionsNum == 0 then
    return true
  end
  for i,v in ipairs(cfg.preConditions) do
    if (CheckCondition.CheckLua)(v[1], v[2], v[3]) then
      return true
    end
  end
  return false
end

ActivityHallowmasData.IsHallowmasEnvUnlock = function(self, envId)
  -- function num : 0_30 , upvalues : _ENV
  if self._tempUnlockEncDic ~= nil and (self._tempUnlockEncDic)[envId] then
    return true
  end
  local cfg = (ConfigData.activity_hallowmas_general_env)[envId]
  if cfg == nil then
    return false
  end
  if cfg.preConditionsNum == 0 then
    if self._tempUnlockEncDic == nil then
      self._tempUnlockEncDic = {}
    end
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._tempUnlockEncDic)[envId] = true
    return true
  end
  for i,v in ipairs(cfg.preConditions) do
    if (CheckCondition.CheckLua)(v[1], v[2], v[3]) then
      if self._tempUnlockEncDic == nil then
        self._tempUnlockEncDic = {}
      end
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self._tempUnlockEncDic)[envId] = true
      return true
    end
  end
  return false
end

ActivityHallowmasData.IsHallowmasEnvDiffcultyExist = function(self, envId, diffcultyId)
  -- function num : 0_31
  if (self._envDiffDic)[envId] == nil then
    return false
  end
  return ((self._envDiffDic)[envId])[diffcultyId]
end

ActivityHallowmasData.GetHallowmasMainCfg = function(self)
  -- function num : 0_32
  return self._mainCfg
end

ActivityHallowmasData.GetHallowmasExpCfg = function(self)
  -- function num : 0_33
  return self._expCfg
end

ActivityHallowmasData.GetHallowmasStageInfoCfg = function(self)
  -- function num : 0_34
  return self._stageInfoCfg
end

ActivityHallowmasData.GetHallowmasAchievementCfg = function(self)
  -- function num : 0_35
  return self._achievementCfg
end

ActivityHallowmasData.GetTaskInitTaskTime = function(self)
  -- function num : 0_36
  return (self._mainCfg).task_time
end

ActivityHallowmasData.GetHallowmasScoreDailyLimit = function(self)
  -- function num : 0_37
  return self._dailyExp, (self._mainCfg).score_daily_limit
end

ActivityHallowmasData.GetHallowmasScoreItemId = function(self)
  -- function num : 0_38
  return (self._mainCfg).score_token
end

ActivityHallowmasData.GetHallowmasWarChessRecord = function(self)
  -- function num : 0_39
  return self._warChessRecord
end

ActivityHallowmasData.GetCompleteDiffDic = function(self)
  -- function num : 0_40
  return (self._warChessRecord).difficultyRecord
end

ActivityHallowmasData.GetHallowmasEnvScore = function(self, envId)
  -- function num : 0_41
  return ((self._warChessRecord).envRecord)[envId] or 0
end

ActivityHallowmasData.GetHallowmasLv = function(self)
  -- function num : 0_42
  return self._level
end

ActivityHallowmasData.GetHallowmasLvLimit = function(self)
  -- function num : 0_43
  return self._maxLevel
end

ActivityHallowmasData.GetHallowmasAllExp = function(self)
  -- function num : 0_44
  return self._exp
end

ActivityHallowmasData.GetHallowmasCurExp = function(self)
  -- function num : 0_45
  return self._curExp
end

ActivityHallowmasData.GetHallowmasCurExpLimit = function(self)
  -- function num : 0_46
  local cfg = (self._expCfg)[self._level]
  if cfg == nil then
    return 0
  end
  return cfg.need_exp
end

ActivityHallowmasData.GetHallowmasCycleExpLimit = function(self)
  -- function num : 0_47
  return self._cycleExp
end

ActivityHallowmasData.GetHallowmasDailyTaskIdDic = function(self)
  -- function num : 0_48
  return self._taskIdDic
end

ActivityHallowmasData.GetHallowmasDailyTaskIds = function(self)
  -- function num : 0_49
  return self._taskIds
end

ActivityHallowmasData.GetSeasonDungeonInfo = function(self)
  -- function num : 0_50
  return self._dungeonDataDic, self._dungeonIdList
end

ActivityHallowmasData.GetHallowmasExpiredTm = function(self)
  -- function num : 0_51
  return self._expiredTm
end

ActivityHallowmasData.GetHallowmasExpPicked = function(self)
  -- function num : 0_52
  return self._expPickedDic
end

ActivityHallowmasData.GetHallowmasTaskRefreshTimes = function(self)
  -- function num : 0_53
  return self._taskRefTimes
end

ActivityHallowmasData.GetHallowmasHighestScore = function(self)
  -- function num : 0_54
  return self._highestScore
end

ActivityHallowmasData.GetHallowmasSeasonAddtion = function(self)
  -- function num : 0_55 , upvalues : WarChessSeasonAddtionData, _ENV
  if self._seasonAddtionData == nil then
    self._seasonAddtionData = (WarChessSeasonAddtionData.New)()
    local tip = ConfigData:GetTipContent((self._mainCfg).clear_tip)
    ;
    (self._seasonAddtionData):SetSeasonCompleteFloorTip(tip)
    ;
    (self._seasonAddtionData):SetSeasonScoreToken(self:GetHallowmasScoreItemId())
    ;
    (self._seasonAddtionData):SetSelectLevelTokenCallback(function()
    -- function num : 0_55_0 , upvalues : _ENV, self
    UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22InfoWindow, function(win)
      -- function num : 0_55_0_0 , upvalues : self
      if win == nil then
        return 
      end
      win:InitCarnivalInfoWindow((self._mainCfg).score_limit_tip)
    end
)
  end
)
    self:__TryUpdateAddtionData()
  end
  do
    return self._seasonAddtionData
  end
end

ActivityHallowmasData.GetHallowmasTechTree = function(self)
  -- function num : 0_56
  return self._actTechTree
end

ActivityHallowmasData.GetHallowmasEnvIdByDifficultyId = function(self, diffId)
  -- function num : 0_57 , upvalues : _ENV
  for envId,diffDic in pairs(self._envDiffDic) do
    if diffDic[diffId] == true then
      return envId
    end
  end
  return -1
end

ActivityHallowmasData.GetHallowmasDiffIdByTowerId = function(self, towerId)
  -- function num : 0_58 , upvalues : _ENV
  if self._tempTowerDiffMap ~= nil and (self._tempTowerDiffMap)[towerId] ~= nil then
    return (self._tempTowerDiffMap)[towerId]
  end
  for diffId,v in pairs(self._stageInfoCfg) do
    if v.season_id == towerId then
      if self._tempTowerDiffMap == nil then
        self._tempTowerDiffMap = {}
      end
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self._tempTowerDiffMap)[towerId] = diffId
      return diffId
    end
  end
  return -1
end

ActivityHallowmasData.GetActHallowmasUnlockInfo = function(self)
  -- function num : 0_59
  return self._actUnlockInfo
end

ActivityHallowmasData.DealHallowmasWhenEnd = function(self)
  -- function num : 0_60
  (self._actUnlockInfo):ResetAllUnlockData()
end

return ActivityHallowmasData

