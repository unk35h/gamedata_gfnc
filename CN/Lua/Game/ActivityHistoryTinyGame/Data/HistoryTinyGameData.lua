-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActivityBase")
local HistoryTinyGameData = class("HistoryTinyGameData", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local TinyGameEnum = require("Game.TinyGames.TinyGameEnum")
local CommonPoltReviewData = require("Game.CommonUI.PlotReview.CommonPoltReviewData")
local CommonPoltReviewGroupData = require("Game.CommonUI.PlotReview.CommonPoltReviewGroupData")
local ActivityHTGEnum = require("Game.ActivityHistoryTinyGame.ActivityHTGEnum")
HistoryTinyGameData.ctor = function(self, actId)
  -- function num : 0_0 , upvalues : base, ActivityFrameEnum, _ENV
  self.__actId = actId
  self.__HTGPlayerDic = {}
  ;
  (base.SetActFrameDataByType)(self, (ActivityFrameEnum.eActivityType).HistoryTinyGame, actId)
  self:GenAllHTGPlayer()
  self._refreshTime = 0
  self._dailyTaskList = nil
  self._nextExpiredTm = 0
  self._active = 0
  self._pickedDic = {}
  self._cfg = (ConfigData.activity_tiny_game_main)[actId]
  if self._cfg == nil then
    error("can\'t read activity_tiny_game_main cfgData by id:" .. tostring(actId))
    return 
  end
  self._pointCfg = (ConfigData.activity_tiny_game_point)[(self._cfg).point_reward]
  if self._pointCfg == nil then
    error("can\'t read activity_tiny_game_point cfgData by id:" .. tostring((self._cfg).point_reward))
    return 
  end
  self._allTaskDic = {}
  for i,v in ipairs((self._cfg).activity_daily_task) do
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R7 in 'UnsetPending'

    (self._allTaskDic)[v] = true
  end
  for i,v in ipairs((self._cfg).task_list) do
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R7 in 'UnsetPending'

    (self._allTaskDic)[v] = true
  end
  self._avgGroupList = {}
  self._avgPreCondMapping = {}
  self._avgTaskMapping = ((ConfigData.activity_tiny_game_avg_pre_condition).taskDic)[self.__actId]
  local avgPreGroup = ((ConfigData.activity_tiny_game_avg_pre_condition).groupDic)[self.__actId]
  for groupId,avgPreList in ipairs(avgPreGroup) do
    -- DECOMPILER ERROR at PC91: Confused about usage of register: R8 in 'UnsetPending'

    (self._avgGroupList)[groupId] = {}
    for _,preId in ipairs(avgPreList) do
      local avgId = ((self._cfg).activity_avg)[preId]
      ;
      (table.insert)((self._avgGroupList)[groupId], avgId)
      -- DECOMPILER ERROR at PC111: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self._avgPreCondMapping)[avgId] = ((ConfigData.activity_tiny_game_avg_pre_condition)[self.__actId])[preId]
    end
  end
end

HistoryTinyGameData.UpdateHTGDataByMsg = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  self._refreshTime = msg.refreshTime
  self._dailyTaskList = msg.dailyTask
  self._nextExpiredTm = msg.nextExpiredTm
  for i,pointCfg in ipairs(self._pointCfg) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

    if (msg.pickedActiveReward)[pointCfg.need_point] ~= nil then
      (self._pickedDic)[i] = true
    end
  end
  self:UpdateHTGActive(msg.active)
  self:RefreshHTGTaskReddot(nil, true)
  self:RefreshHTGAvgReddot()
end

HistoryTinyGameData.GenAllHTGPlayer = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameId = self:GetActFrameId()
  local tinyGameDataList = activityFrameCtrl:GetTinyGameDataListByActFrameId(actFrameId)
  if tinyGameDataList == nil or #tinyGameDataList == 0 then
    error("history tiny game activity not has any TinyGames")
    return 
  end
  for _,tinyGameData in pairs(tinyGameDataList) do
    self:__GenHTGClass(tinyGameData)
  end
end

HistoryTinyGameData.__GenHTGClass = function(self, tinyGameData)
  -- function num : 0_3 , upvalues : _ENV, TinyGameEnum
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local tinyGameType = tinyGameData:GetTinyGameCat()
  local tinyGameDataClass = (TinyGameEnum.eClassType)[tinyGameType]
  if tinyGameDataClass == nil then
    error("History Tiny Game Type not exist type:" .. tostring(tinyGameType))
    return 
  end
  tinyGameDataClass = require(tinyGameDataClass)
  local selfHistoryHighScore = activityFrameCtrl:GetTinyGameHistoryHighScore(tinyGameType)
  local playEndTime = self:GetActivityEndTime()
  local HTGPlayer = (tinyGameDataClass.New)(tinyGameData, selfHistoryHighScore, playEndTime)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.__HTGPlayerDic)[tinyGameType] = HTGPlayer
end

HistoryTinyGameData.PlayHTG = function(self, tinyGameType)
  -- function num : 0_4
  local HTGPlayer = (self.__HTGPlayerDic)[tinyGameType]
  if HTGPlayer ~= nil then
    HTGPlayer:EnterTinyGame()
  end
end

HistoryTinyGameData.UpdateHTGActive = function(self, active)
  -- function num : 0_5 , upvalues : _ENV
  self._active = active
  local curLevelActive = active
  local level = 0
  for i,v in ipairs(self._pointCfg) do
    if ((self._pointCfg)[i]).need_point <= self._active then
      level = i
    end
  end
  self._level = level
  self:__RefreshHTGACTIVEReddot()
end

HistoryTinyGameData.UpdateHTGDailyTask = function(self, msg)
  -- function num : 0_6
  self._dailyTaskList = msg.newTaskId
  self._nextExpiredTm = msg.nextExpiredTm
  self._refreshTime = 0
  self:RefreshHTGTaskReddot(nil, true)
end

HistoryTinyGameData.ReqHTGDailyReplace = function(self, taskId, callback)
  -- function num : 0_7 , upvalues : _ENV
  if (self._cfg).daily_task_refresh_max <= self._refreshTime then
    return 
  end
  if not (table.indexof)(self._dailyTaskList, taskId) then
    return 
  end
  local tinyNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.ActivityHistoryTinyGame)
  tinyNetCtrl:CS_ACTIVITY_TinyGame_RefreshQuestSingle(self:GetActId(), taskId, function(args)
    -- function num : 0_7_0 , upvalues : _ENV, self, taskId, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    self._refreshTime = self._refreshTime + 1
    local index = (table.indexof)(self._dailyTaskList, taskId)
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

    if index then
      (self._dailyTaskList)[index] = msg.newTaskId
    end
    self:RefreshHTGTaskReddot(nil, true)
    if callback ~= nil then
      callback()
    end
  end
)
end

HistoryTinyGameData.ReqHTGActiveReward = function(self, all, level, callback)
  -- function num : 0_8 , upvalues : _ENV
  local point = 0
  local reviewIds = {}
  if not all then
    if not self:IsTinyGameActiveCanReward(level) then
      return 
    end
    point = ((self._pointCfg)[level]).need_point
    ;
    (table.insert)(reviewIds, level)
  else
    local hasReview = false
    for templevel,v in pairs(self._pointCfg) do
      if self:IsTinyGameActiveCanReward(templevel) then
        (table.insert)(reviewIds, templevel)
      end
    end
    if #reviewIds == 0 then
      return 
    end
  end
  do
    local tinyNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.ActivityHistoryTinyGame)
    tinyNetCtrl:CS_ACTIVITY_TinyGame_GetActiveReward(self:GetActId(), all, point, function(args)
    -- function num : 0_8_0 , upvalues : _ENV, reviewIds, self, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    for _,templevel in ipairs(reviewIds) do
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R7 in 'UnsetPending'

      (self._pickedDic)[templevel] = true
    end
    self:__RefreshHTGACTIVEReddot()
    local rewardIds = {}
    local rewardNums = {}
    for itemId,itemCount in pairs(msg.rewards) do
      (table.insert)(rewardIds, itemId)
      ;
      (table.insert)(rewardNums, itemCount)
    end
    if #rewardIds > 0 then
      self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_8_0_0 , upvalues : _ENV, rewardIds, rewardNums, self
      if window == nil then
        return 
      end
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = ((((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot, false)):SetCRNotHandledGreat(true)):SetCRShowOverFunc(function()
        -- function num : 0_8_0_0_0 , upvalues : _ENV
        local achievementSystemWin = UIManager:GetWindow(UIWindowTypeID.AchievementSystem)
        if achievementSystemWin ~= nil then
          ((achievementSystemWin.achievementLevelNode).__NeedRefreshPlayerLevel)()
        end
      end
)
      window:AddAndTryShowReward(CRData)
    end
)
    end
    if callback ~= nil then
      callback()
    end
  end
)
  end
end

HistoryTinyGameData.RefreshHTGTaskReddot = function(self, taskId, forceUpdate)
  -- function num : 0_9 , upvalues : ActivityHTGEnum, _ENV
  if not forceUpdate and (taskId == nil or not (self._allTaskDic)[taskId]) then
    return 
  end
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivityHTGEnum.eActivityReddot).Task)
  for i,v in ipairs(self._dailyTaskList) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(v)
    if taskData ~= nil and taskData:CheckComplete() then
      childReddot:SetRedDotCount(1)
      return 
    end
  end
  for i,v in ipairs((self._cfg).task_list) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(v)
    if taskData ~= nil and taskData:CheckComplete() then
      childReddot:SetRedDotCount(1)
      return 
    end
  end
  childReddot:SetRedDotCount(0)
end

HistoryTinyGameData.__RefreshHTGACTIVEReddot = function(self)
  -- function num : 0_10 , upvalues : ActivityHTGEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local childReddot = reddot:AddChild((ActivityHTGEnum.eActivityReddot).Active)
  for i = 1, self._level do
    if self:IsTinyGameActiveCanReward(i) then
      childReddot:SetRedDotCount(1)
      return 
    end
  end
  childReddot:SetRedDotCount(0)
end

HistoryTinyGameData.RefreshHTGAvgReddot = function(self, avgid, taskId)
  -- function num : 0_11 , upvalues : ActivityHTGEnum, _ENV
  if avgid ~= nil and (self._avgPreCondMapping)[avgid] == nil then
    return 
  end
  if taskId ~= nil and not (self._avgTaskMapping)[taskId] then
    return 
  end
  local actReddot = self:GetActivityReddot()
  if actReddot == nil then
    return 
  end
  local childReddot = actReddot:AddChild((ActivityHTGEnum.eActivityReddot).Review)
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local reddotCount = 0
  for groupId,avgIds in ipairs(self._avgGroupList) do
    if groupId > 1 then
      local lastAvgList = (self._avgGroupList)[groupId - 1]
      if avgPlayCtrl:IsAvgPlayed(lastAvgList[#lastAvgList]) then
        for _,avgId in ipairs(avgIds) do
          if avgPlayCtrl:IsAvgUnlock(avgId) then
            local unlockCfg = (self._avgPreCondMapping)[avgId]
            if unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
              local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
              if (taskData == nil or taskData:CheckComplete()) and not avgPlayCtrl:IsAvgPlayed(avgId) then
                reddotCount = 1
                break
              end
            end
          end
        end
        do
          -- DECOMPILER ERROR at PC83: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC83: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC83: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC83: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  if reddotCount ~= 1 then
    childReddot:SetRedDotCount(reddotCount)
  end
end

HistoryTinyGameData.GetHTGData = function(self, tinyGameType)
  -- function num : 0_12
  return (self.__HTGPlayerDic)[tinyGameType]
end

HistoryTinyGameData.GetTinyGameDailyTaskIds = function(self)
  -- function num : 0_13
  return self._dailyTaskList
end

HistoryTinyGameData.IsTinyGameActiveHasReward = function(self, level)
  -- function num : 0_14
  return (self._pickedDic)[level]
end

HistoryTinyGameData.GetTinyGameActive = function(self)
  -- function num : 0_15
  return self._active
end

HistoryTinyGameData.GetTinyGameRefrehTimes = function(self)
  -- function num : 0_16
  return self._refreshTime
end

HistoryTinyGameData.GetTinyGameNextTm = function(self)
  -- function num : 0_17
  return self._nextExpiredTm
end

HistoryTinyGameData.IsTinyGameActiveCanReward = function(self, level)
  -- function num : 0_18 , upvalues : _ENV
  if (self._pickedDic)[level] then
    return false
  end
  local pointCfg = (self._pointCfg)[level]
  if pointCfg == nil then
    error("point level miss id:" .. tostring(level))
    return false
  end
  do return pointCfg.need_point <= self._active end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HistoryTinyGameData.GetTGCfgData = function(self)
  -- function num : 0_19
  return self._cfg
end

HistoryTinyGameData.GetTGActiveCfg = function(self)
  -- function num : 0_20
  return self._pointCfg
end

HistoryTinyGameData.GetTGMaxActive = function(self)
  -- function num : 0_21
  local maxActiveCfg = (self._pointCfg)[#self._pointCfg]
  return maxActiveCfg.need_point
end

HistoryTinyGameData.GetActiveLevel = function(self)
  -- function num : 0_22
  return self._level or 0
end

HistoryTinyGameData.GetAfterFirstAvgGuideId = function(self)
  -- function num : 0_23
  return (self._cfg).avg_guide
end

HistoryTinyGameData.GetFirstAvgId = function(self)
  -- function num : 0_24
  return (self._cfg).activity_avg_start1
end

HistoryTinyGameData.GetSecondAvgId = function(self)
  -- function num : 0_25
  return (self._cfg).activity_avg_start2
end

HistoryTinyGameData.GetUnlockAllAvgId = function(self)
  -- function num : 0_26
  return (self._cfg).activity_avg_finish
end

HistoryTinyGameData.GetHTGAVGReviewData = function(self)
  -- function num : 0_27 , upvalues : _ENV, CommonPoltReviewData, CommonPoltReviewGroupData
  local unlockAllAvgId = self:GetUnlockAllAvgId()
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local CPRData = (CommonPoltReviewData.New)()
  CPRData:SetCPRBgResName(nil)
  CPRData:SetCPRTitleName(nil)
  local totalCount = 0
  local totalUnlockCount = 0
  for index,avgids in ipairs(self._avgGroupList) do
    do
      if avgids[1] ~= unlockAllAvgId then
        totalCount = totalCount + 1
        local avgid = avgids[1]
        local avgCfg = (ConfigData.story_avg)[avgid]
        local unlockCfg = (self._avgPreCondMapping)[avgid]
        local isUnlock = avgPlayCtrl:IsAvgUnlock(avgCfg.id)
        if isUnlock and index > 1 then
          local lastAvgids = (self._avgGroupList)[index - 1]
          do
            local preAvgId = lastAvgids[#lastAvgids]
            isUnlock = (ControllerManager:GetController(ControllerTypeId.AvgPlay)):IsAvgPlayed(preAvgId)
          end
        end
        do
          do
            do
              if isUnlock and unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
                local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
                if taskData ~= nil and isUnlock then
                  isUnlock = taskData:CheckComplete()
                end
              end
              if avgCfg ~= nil then
                local groupEnName = "Stage " .. tostring(totalCount)
                local groupName = (LanguageUtil.GetLocaleText)(avgCfg.describe)
                local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
                local CPRGroupData = ((CommonPoltReviewGroupData.New)(groupEnName, groupName, groupDes, avgids))
                local unlockDes = nil
                if not isUnlock then
                  unlockDes = (LanguageUtil.GetLocaleText)(unlockCfg.describe_condition)
                end
                CPRGroupData:SetAvgGroupDataIsUnlock(isUnlock, unlockDes)
                CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
    -- function num : 0_27_0 , upvalues : index, CPRGroupData, _ENV, avgids, self
    if index == 1 then
      return false
    end
    if not CPRGroupData:GetAvgGroupIsUnlock() then
      return false
    end
    local tempavgPlay = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    for i,avgId in ipairs(avgids) do
      local unlockCfg = (self._avgPreCondMapping)[avgId]
      if unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
        local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
        if (taskData == nil or taskData:CheckComplete()) and not tempavgPlay:IsAvgPlayed(avgId) then
          return true
        end
      end
    end
    return false
  end
)
                CPRGroupData:SetAvgSingleDotFunc(function(avgId)
    -- function num : 0_27_1 , upvalues : index, self, _ENV
    if index == 1 then
      return false
    end
    local unlockCfg = (self._avgPreCondMapping)[avgId]
    do
      if unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
        local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
        if taskData ~= nil and not taskData:CheckComplete() then
          return false
        end
      end
      local active = not (ControllerManager:GetController(ControllerTypeId.AvgPlay)):IsAvgPlayed(avgId)
      return active
    end
  end
)
                CPRData:AddAvgGroup(CPRGroupData)
              end
              do
                if isUnlock then
                  totalUnlockCount = totalUnlockCount + 1
                end
              end
              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out DO_STMT

            end
          end
        end
      end
    end
  end
  local avgids = (self._avgGroupList)[#self._avgGroupList]
  local isUnlock = totalCount <= totalUnlockCount
  if isUnlock then
    isUnlock = avgPlayCtrl:IsAvgUnlock(unlockAllAvgId)
  end
  if isUnlock then
    local lastAvgids = (self._avgGroupList)[totalCount]
    local preAvgId = lastAvgids[#lastAvgids]
    local isplayed = (ControllerManager:GetController(ControllerTypeId.AvgPlay)):IsAvgPlayed(preAvgId)
    isUnlock = isplayed
  end
  do
    if isUnlock and unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
      if taskData ~= nil and isUnlock then
        isUnlock = taskData:CheckComplete()
      end
    end
    totalCount = totalCount + 1
    local unlockDes = nil
    if not isUnlock then
      local unlockCfg = (self._avgPreCondMapping)[unlockAllAvgId]
      unlockDes = (LanguageUtil.GetLocaleText)(unlockCfg.describe_condition)
    else
      totalUnlockCount = totalUnlockCount + 1
    end
    local avgCfg = (ConfigData.story_avg)[unlockAllAvgId]
    local groupEnName = "Stage " .. tostring(totalCount)
    local groupName = (LanguageUtil.GetLocaleText)(avgCfg.describe)
    local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupName, groupName, groupDes, {unlockAllAvgId})
    CPRGroupData:SetAvgGroupDataIsUnlock(isUnlock, unlockDes)
    CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
    -- function num : 0_27_2 , upvalues : CPRGroupData, _ENV, avgids, self
    if not CPRGroupData:GetAvgGroupIsUnlock() then
      return false
    end
    local tempavgPlay = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    for i,avgId in ipairs(avgids) do
      local unlockCfg = (self._avgPreCondMapping)[avgId]
      if unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
        local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
        if (taskData == nil or taskData:CheckComplete()) and not tempavgPlay:IsAvgPlayed(avgId) then
          return true
        end
      end
    end
    return false
  end
)
    CPRGroupData:SetAvgSingleDotFunc(function(avgId)
    -- function num : 0_27_3 , upvalues : self, _ENV
    local unlockCfg = (self._avgPreCondMapping)[avgId]
    do
      if unlockCfg ~= nil and unlockCfg.task_condition ~= nil then
        local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(unlockCfg.task_condition, false)
        if taskData ~= nil and not taskData:CheckComplete() then
          return false
        end
      end
      local active = not (ControllerManager:GetController(ControllerTypeId.AvgPlay)):IsAvgPlayed(avgId)
      return active
    end
  end
)
    CPRData:AddAvgGroup(CPRGroupData)
    CPRData:SetCPRUnlockNum(totalCount, totalUnlockCount)
    do return CPRData end
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

HistoryTinyGameData.GetActivityReddotNum = function(self)
  -- function num : 0_28 , upvalues : _ENV, ActivityHTGEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return true, 0
  end
  if reddot:GetRedDotCount() == 0 then
    return true, 0
  end
  local isBlue = true
  for i,v in pairs(ActivityHTGEnum.eActivityReddot) do
    if not self:IsHTGBlueReddotType(v) then
      local childReddot = reddot:GetChild(v)
      if childReddot ~= nil and childReddot:GetRedDotCount() > 0 then
        isBlue = false
        break
      end
    end
  end
  do
    return isBlue, reddot:GetRedDotCount()
  end
end

HistoryTinyGameData.IsHTGBlueReddotType = function(self, type)
  -- function num : 0_29 , upvalues : ActivityHTGEnum
  if type == (ActivityHTGEnum.eActivityReddot).Review then
    return true
  end
  return false
end

return HistoryTinyGameData

