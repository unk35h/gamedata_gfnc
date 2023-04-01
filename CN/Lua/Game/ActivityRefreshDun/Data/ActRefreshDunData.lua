-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActivityBase")
local ActRefreshDunData = class("ActRefreshDunData", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActRefreshDunEnum = require("Game.ActivityRefreshDun.ActRefreshDunEnum")
local ARDDungeonData = require("Game.ActivityRefreshDun.Data.ARDDungeonData")
local CommonPoltReviewData = require("Game.CommonUI.PlotReview.CommonPoltReviewData")
local CommonPoltReviewGroupData = require("Game.CommonUI.PlotReview.CommonPoltReviewGroupData")
ActRefreshDunData.ctor = function(self, actId)
  -- function num : 0_0 , upvalues : _ENV, ActivityFrameEnum
  self.__ARDDCfg = (ConfigData.activity_refresh_dungeon)[actId]
  self.__actId = actId
  self.__expiredTm = nil
  self.__exchangeTimes = nil
  self.__purchaseRefreshTimes = nil
  self.__ARDDdataDic = nil
  self.__DunOrderList = nil
  self.__miniGameData = nil
  self:SetActFrameDataByType((ActivityFrameEnum.eActivityType).RefreshDun, actId)
  self:InitARDReddot()
end

ActRefreshDunData.UpdateARDByMsg = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV, ARDDungeonData
  self.__expiredTm = msg.expiredTm
  self.__exchangeTimes = msg.exchangeTimes
  self.__purchaseRefreshTimes = msg.purchaseRefreshTimes
  self.__miniGameData = msg.activityGameDamie
  self.__ARDDdataDic = {}
  self.__DunOrderList = {}
  for index,dungoenInfo in ipairs(msg.dungeons) do
    (table.insert)(self.__DunOrderList, dungoenInfo.dungoenId)
    local ARDDunData = (ARDDungeonData.New)(dungoenInfo.dungoenId, dungoenInfo.completed, self)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__ARDDdataDic)[dungoenInfo.dungoenId] = ARDDunData
  end
  self:ARDRefreshAvgReddot()
  self:ARDRefreshTaskReddot()
end

ActRefreshDunData.GetARDExpiredTm = function(self)
  -- function num : 0_2
  return self.__expiredTm
end

ActRefreshDunData.GetARDDataList = function(self)
  -- function num : 0_3
  return self.__DunOrderList
end

ActRefreshDunData.GetARDDataByDunId = function(self, dungeonId)
  -- function num : 0_4
  if self.__ARDDdataDic == nil then
    return nil
  end
  return (self.__ARDDdataDic)[dungeonId]
end

ActRefreshDunData.GetARDDataByDunIndex = function(self, index)
  -- function num : 0_5
  local dungeonId = (self.__DunOrderList)[index]
  return self:GetARDDataByDunId(dungeonId)
end

ActRefreshDunData.GetARDDCfg = function(self)
  -- function num : 0_6
  return self.__ARDDCfg
end

ActRefreshDunData.GetARDDTaskList = function(self)
  -- function num : 0_7
  return (self.__ARDDCfg).task_list
end

ActRefreshDunData.GetARDAvgId = function(self)
  -- function num : 0_8
  return (self.__ARDDCfg).activity_avg
end

ActRefreshDunData.GetARDDResetMsg = function(self)
  -- function num : 0_9
  return (self.__ARDDCfg).refresh_txt
end

ActRefreshDunData.GetARDDExchangeMsg = function(self)
  -- function num : 0_10
  return (self.__ARDDCfg).exchange_txt
end

ActRefreshDunData.GetARDResetMAXTime = function(self)
  -- function num : 0_11
  local times = (self.__ARDDCfg).refresh_times
  return times[#times]
end

ActRefreshDunData.GetARDResetTime = function(self)
  -- function num : 0_12
  return self.__purchaseRefreshTimes or 0
end

ActRefreshDunData.IsARDResetRunOut = function(self)
  -- function num : 0_13
  do return self:GetARDResetMAXTime() <= self:GetARDResetTime() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActRefreshDunData.GetARDMAXExchangeTime = function(self)
  -- function num : 0_14
  return (self.__ARDDCfg).exchange
end

ActRefreshDunData.GetARDExchangeTime = function(self)
  -- function num : 0_15
  return self.__exchangeTimes or 0
end

ActRefreshDunData.GetARDResetCostItemId = function(self)
  -- function num : 0_16
  return (self.__ARDDCfg).refreshCostId
end

ActRefreshDunData.GetARDResetCost = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local resetTime = self:GetARDResetTime() + 1
  for index,time in ipairs((self.__ARDDCfg).refresh_times) do
    if resetTime <= time then
      return ((self.__ARDDCfg).costList)[index]
    end
  end
  return 0
end

ActRefreshDunData.GetARDLevelNum = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local totalNum = (table.count)(self.__ARDDdataDic)
  local palyedNum = 0
  for dunId,dunData in pairs(self.__ARDDdataDic) do
    if dunData:GetARDDunIsCompleted() then
      palyedNum = palyedNum + 1
    end
  end
  return totalNum, totalNum - (palyedNum)
end

ActRefreshDunData.GetARDMiniGameId = function(self)
  -- function num : 0_19
  return (self.__ARDDCfg).tiny_game
end

ActRefreshDunData.GetARDMiniGameMaxScore = function(self)
  -- function num : 0_20
  if self.__miniGameData == nil then
    return 0
  end
  return (self.__miniGameData).highestScore or 0
end

ActRefreshDunData.GetARDPlotReviewData = function(self)
  -- function num : 0_21 , upvalues : _ENV, CommonPoltReviewData, CommonPoltReviewGroupData
  local bgName = nil
  local enterAvgId = self:GetARDAvgId()
  local collect17StoryAvgId = (self.__ARDDCfg).finish_avg
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local CPRData = (CommonPoltReviewData.New)()
  CPRData:SetCPRBgResName((self.__ARDDCfg).pic, false)
  CPRData:SetCPRTitleName((LanguageUtil.GetLocaleText)((self.__ARDDCfg).avg_name))
  local avgCfg = (ConfigData.story_avg)[enterAvgId]
  local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
  local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
  local CPRGroupData = (CommonPoltReviewGroupData.New)(groupName, groupName, groupDes, {enterAvgId})
  CPRData:AddAvgGroup(CPRGroupData)
  local totalCount = 0
  local totalUnlockCount = 0
  for heroId,dunHeroCfg in pairs(ConfigData.activity_refresh_dungeon_hero) do
    totalCount = totalCount + 1
    local avgId = dunHeroCfg.avg_id
    local played = avgPlayCtrl:IsAvgPlayed(avgId)
    local avgCfg = (ConfigData.story_avg)[avgId]
    if avgCfg ~= nil then
      local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
      local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
      local CPRGroupData = ((CommonPoltReviewGroupData.New)(groupName, groupName, groupDes, {avgId}))
      local unlockDes = nil
      if not played then
        local heroName = nil
        local heroCfg = (ConfigData.hero_data)[heroId]
        if heroCfg ~= nil then
          heroName = (LanguageUtil.GetLocaleText)(heroCfg.name)
          unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7303)), heroName)
        end
      end
      do
        do
          do
            CPRGroupData:SetAvgGroupDataIsUnlock(played, unlockDes)
            CPRData:AddAvgGroup(CPRGroupData)
            if played then
              totalUnlockCount = totalUnlockCount + 1
            end
            -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local isUnlock = (self.__ARDDCfg).finish_condition <= totalUnlockCount
  local unlockDes = nil
  if not isUnlock then
    unlockDes = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7308))
  else
    totalUnlockCount = totalUnlockCount + 1
  end
  local avgCfg = (ConfigData.story_avg)[collect17StoryAvgId]
  local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
  local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
  local CPRGroupData = (CommonPoltReviewGroupData.New)(groupName, groupName, groupDes, {collect17StoryAvgId})
  CPRGroupData:SetAvgGroupDataOperateData(nil, function()
    -- function num : 0_21_0 , upvalues : self
    self:ARDRefreshAvgReddot()
  end
)
  CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
    -- function num : 0_21_1 , upvalues : self
    return self:__IsFinishAvgBlueDot()
  end
)
  CPRGroupData:SetAvgGroupDataIsUnlock(isUnlock, unlockDes)
  CPRData:AddAvgGroup(CPRGroupData)
  CPRData:SetCPRUnlockNum(totalCount + 2, totalUnlockCount + 1)
  do return CPRData end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

ActRefreshDunData.InitARDReddot = function(self)
  -- function num : 0_22 , upvalues : _ENV, ActRefreshDunEnum
  local isOk, actSingleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle)
  if isOk then
    local frameActId = self:GetActFrameId()
    self.ARDRedDotRootNode = actSingleNode:AddChild(frameActId)
    ;
    (self.ARDRedDotRootNode):AddChild((ActRefreshDunEnum.redDotType).task)
    ;
    (self.ARDRedDotRootNode):AddChild((ActRefreshDunEnum.redDotType).avg)
  else
    do
      error("can\'t get ActivitySingle node")
    end
  end
end

ActRefreshDunData.__IsFinishAvgBlueDot = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local isNotWatchFinalAvg = false
  if self:IsActivityRunning() then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local avgId = (self.__ARDDCfg).finish_avg
    if not avgPlayCtrl:IsAvgPlayed(avgId) then
      local totalUnlockCount = 0
      for heroId,dunHeroCfg in pairs(ConfigData.activity_refresh_dungeon_hero) do
        local avgId = dunHeroCfg.avg_id
        if avgPlayCtrl:IsAvgPlayed(avgId) then
          totalUnlockCount = totalUnlockCount + 1
        end
      end
      if (self.__ARDDCfg).finish_condition <= totalUnlockCount then
        isNotWatchFinalAvg = true
      end
    end
  end
  do
    return isNotWatchFinalAvg
  end
end

ActRefreshDunData.ARDRefreshAvgReddot = function(self)
  -- function num : 0_24 , upvalues : ActRefreshDunEnum
  local isNotWatchFinalAvg = self:__IsFinishAvgBlueDot()
  local avgNode = (self.ARDRedDotRootNode):GetChild((ActRefreshDunEnum.redDotType).avg)
  avgNode:SetRedDotCount(isNotWatchFinalAvg and 1 or 0)
end

ActRefreshDunData.ARDRefreshTaskReddot = function(self)
  -- function num : 0_25 , upvalues : _ENV, ActRefreshDunEnum
  local taskNum = 0
  if self:IsActivityOpen() then
    for _,taskId in pairs(self:GetARDDTaskList()) do
      local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
      if taskData ~= nil and taskData:CheckComplete() then
        taskNum = 1
        break
      end
    end
  end
  do
    local taskNode = (self.ARDRedDotRootNode):GetChild((ActRefreshDunEnum.redDotType).task)
    taskNode:SetRedDotCount(taskNum)
  end
end

ActRefreshDunData.__IsHaveReadDot = function(self)
  -- function num : 0_26 , upvalues : _ENV, ActRefreshDunEnum
  local num = 0
  local frameActId = self:GetActFrameId()
  local isOk, reddotNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, frameActId, (ActRefreshDunEnum.redDotType).task)
  if isOk then
    num = num + reddotNode:GetRedDotCount()
  end
  if num > 0 then
    return true
  end
end

ActRefreshDunData.GetActivityReddotNum = function(self)
  -- function num : 0_27
  local isBlue, num = nil, nil
  isBlue = not self:__IsHaveReadDot()
  num = (self.ARDRedDotRootNode):GetRedDotCount()
  return isBlue, num
end

return ActRefreshDunData

