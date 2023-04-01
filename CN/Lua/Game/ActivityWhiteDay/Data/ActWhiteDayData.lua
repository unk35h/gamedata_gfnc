-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActivityBase")
local ActWhiteDayData = class("ActWhiteDayData", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityWhiteDayEnum = require("Game.ActivityWhiteDay.ActivityWhiteDayEnum")
local ActWhiteDayLineData = require("Game.ActivityWhiteDay.Data.ActWhiteDayLineData")
local ActWhiteDayLineOrderData = require("Game.ActivityWhiteDay.Data.ActWhiteDayLineOrderData")
ActWhiteDayData.ctor = function(self, actId)
  -- function num : 0_0 , upvalues : _ENV, base, ActivityFrameEnum
  self.__actId = actId
  self.__whiteDayCfg = (ConfigData.activity_white_day)[actId]
  self.__factoryCfgs = (ConfigData.activity_white_day_factory)[actId]
  self.__photoCfgs = (ConfigData.activity_white_day_photo)[actId]
  self.__factoryLevel = nil
  self.__factoryExp = 0
  self.__beforeShowLevelUpLevel = nil
  self.__lineDic = nil
  self.__orderDic = nil
  self.__lineUnlockLevelDic = nil
  self.__levelUnlockListDic = nil
  self.__OrderProducedNumDic = nil
  self.__underAssistHeroDic = nil
  self.__unlockedPhoto = nil
  self.__unlockedPhotoNum = nil
  self.__unlockedPhotoList = nil
  self.__onceQuests = nil
  self.__endlessQuests = nil
  self.__endlessFinished = nil
  self.__endlessRateFlags = nil
  self.__endlessAcceptNum = nil
  ;
  (base.SetActFrameDataByType)(self, (ActivityFrameEnum.eActivityType).WhiteDay, actId)
  if self.__whiteDayCfg == nil or self.__factoryCfgs == nil then
    error("can\'t get white Day Cfg with actId" .. tostring(actId))
  end
  self.wdRedDotRootNode = nil
  self:InitWDReddot()
  self:__GenUnlockLevel()
end

ActWhiteDayData.__GenUnlockLevel = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local unlockLevelDic = {}
  local unlockLineList = {}
  for level,levelCfg in ipairs(self.__factoryCfgs) do
    for _,lineId in pairs(levelCfg.line_unlock) do
      if unlockLevelDic[lineId] == nil then
        unlockLevelDic[lineId] = level
        if unlockLineList[level] == nil then
          unlockLineList[level] = {}
        end
        ;
        (table.insert)(unlockLineList[level], lineId)
      end
    end
  end
  self.__lineUnlockLevelDic = unlockLevelDic
  self.__levelUnlockListDic = unlockLineList
end

ActWhiteDayData.UpdateByAWDByMsg = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV
  local factory = msg.factory
  if self.__factoryLevel ~= nil and self.__factoryLevel < factory.lv then
    self.__beforeShowLevelUpLevel = self.__factoryLevel
  end
  self.__factoryLevel = factory.lv
  self.__factoryExp = factory.exp
  self.__OrderProducedNumDic = factory.orderTimes
  self:__UpdateAWDLineDatas(factory.orders)
  self:__UpdateAWDOrderDatas()
  self:UpdateUnderAssistHeroDic()
  local polariod = msg.polariod
  self:UpdateUnlockPhotoList(polariod)
  self.__onceQuests = msg.onceQuests
  local endlessQuest = msg.endlessQuest
  self.__endlessQuests = endlessQuest.ids
  self.__endlessRateFlags = endlessQuest.flag
  self.__endlessAcceptNum = endlessQuest.refreshTimes
  self.__endlessFinished = {}
  for taskId,_ in pairs(endlessQuest.compeleteId) do
    (table.insert)(self.__endlessFinished, taskId)
  end
  self:RefreshWDReddot4Task()
  self:RefreshWDReddot4AlbumAvg()
end

ActWhiteDayData.__UpdateAWDLineDatas = function(self, orders)
  -- function num : 0_3 , upvalues : _ENV, ActWhiteDayLineData
  local lineList = self:GetWDFactoryAllLineList()
  if self.__lineDic == nil then
    self.__lineDic = {}
    for _,lineId in pairs(lineList) do
      local lineData = (ActWhiteDayLineData.New)(self, lineId)
      local orderMsg = orders[lineId]
      lineData:UpdateWDLineData(orderMsg)
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self.__lineDic)[lineId] = lineData
    end
  else
    do
      for _,lineId in pairs(lineList) do
        local lineData = (self.__lineDic)[lineId]
        local orderMsg = orders[lineId]
        lineData:UpdateWDLineData(orderMsg)
      end
    end
  end
end

ActWhiteDayData.__UpdateAWDOrderDatas = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActWhiteDayLineOrderData
  if self.__orderDic == nil then
    self.__orderDic = {}
    for lineId,lineData in pairs(self.__lineDic) do
      local orderList = lineData:GetWDLineOrderList()
      for _,orderId in pairs(orderList) do
        if (self.__orderDic)[orderId] == nil then
          local orderData = (ActWhiteDayLineOrderData.New)(self, orderId)
          orderData:UpdateWDLineOrderData()
          -- DECOMPILER ERROR at PC26: Confused about usage of register: R13 in 'UnsetPending'

          ;
          (self.__orderDic)[orderId] = orderData
        end
      end
      lineData:GenWDOrderDataList(self.__orderDic)
    end
  else
    do
      for _,orderData in pairs(self.__orderDic) do
        orderData:UpdateWDLineOrderData()
      end
    end
  end
end

ActWhiteDayData.UpdateUnderAssistHeroDic = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.__underAssistHeroDic = {}
  for lineId,lineData in pairs(self.__lineDic) do
    if lineData:GetIsInProduction() then
      local assistHeroId = lineData:GetWDLDAssistHeroID()
      -- DECOMPILER ERROR at PC15: Confused about usage of register: R7 in 'UnsetPending'

      if assistHeroId ~= nil then
        (self.__underAssistHeroDic)[assistHeroId] = true
      end
    end
  end
end

ActWhiteDayData.UpdateUnlockPhotoList = function(self, polariod)
  -- function num : 0_6 , upvalues : _ENV
  if polariod ~= nil then
    self.__unlockedPhoto = polariod.data
    self.__unlockedPhotoNum = (table.count)(polariod.data)
  else
    self.__unlockedPhoto = {}
    self.__unlockedPhotoNum = 0
  end
  self.__unlockedPhotoList = {}
  for photoId,_ in pairs(self.__unlockedPhoto) do
    (table.insert)(self.__unlockedPhotoList, photoId)
  end
  ;
  (table.sort)(self.__unlockedPhotoList)
end

ActWhiteDayData.SetWDHasShowedLevelUp = function(self)
  -- function num : 0_7
  self.__beforeShowLevelUpLevel = nil
end

ActWhiteDayData.GetWDCfg = function(self)
  -- function num : 0_8
  return self.__whiteDayCfg
end

ActWhiteDayData.GetAWDFirstEnterAvgId = function(self)
  -- function num : 0_9
  return (self.__whiteDayCfg).activity_avg
end

ActWhiteDayData.GetAWDCollectAllAvgId = function(self)
  -- function num : 0_10
  return (self.__whiteDayCfg).finish_avg
end

ActWhiteDayData.GetAWDSectorId = function(self)
  -- function num : 0_11
  return (self.__whiteDayCfg).sector_id
end

ActWhiteDayData.GetAWDGame2048Id = function(self)
  -- function num : 0_12
  return (self.__whiteDayCfg).game_2048
end

ActWhiteDayData.GetAWDFactoryLevel = function(self)
  -- function num : 0_13
  return self.__factoryLevel
end

ActWhiteDayData.GetAWDFactoryMaxLevel = function(self)
  -- function num : 0_14
  return #self.__factoryCfgs
end

ActWhiteDayData.GetWDBeforeLevelUpLevel = function(self)
  -- function num : 0_15
  return self.__beforeShowLevelUpLevel
end

ActWhiteDayData.GetAWDFactoryCfg = function(self)
  -- function num : 0_16
  return self.__factoryCfgs
end

ActWhiteDayData.GetAWDFactoryIsFullLevel = function(self)
  -- function num : 0_17
  do return self:GetAWDFactoryMaxLevel() <= self:GetAWDFactoryLevel() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActWhiteDayData.GetAWDFactoryLevelUpReward = function(self, level)
  -- function num : 0_18 , upvalues : _ENV
  if #self.__factoryCfgs <= level then
    return table.emptytable, table.emptytable
  end
  local levelCfg = (self.__factoryCfgs)[level + 1]
  return levelCfg.level_reward_ids, levelCfg.level_reward_nums
end

ActWhiteDayData.GetAWDFactoryLevelUpUnlockLineList = function(self, level)
  -- function num : 0_19
  if #self.__factoryCfgs < level then
    return 
  end
  return (self.__levelUnlockListDic)[level]
end

ActWhiteDayData.GetAWDFactoryLevelUpUnlockOrderDataList = function(self, level)
  -- function num : 0_20 , upvalues : _ENV
  if #self.__factoryCfgs < level then
    return 
  end
  local list = {}
  for ordetId,orderData in pairs(self.__orderDic) do
    if orderData:GetWDLineOrderUnlockLevel() == level then
      (table.insert)(list, orderData)
    end
  end
  return list
end

ActWhiteDayData.GetAWDFactoryExp = function(self)
  -- function num : 0_21
  return self.__factoryExp
end

ActWhiteDayData.GetAWDFactoryLevelUpExp = function(self, level)
  -- function num : 0_22
  if #self.__factoryCfgs < level then
    return 
  end
  return ((self.__factoryCfgs)[level]).level_up_exp
end

ActWhiteDayData.GetWDFactoryAllLineList = function(self)
  -- function num : 0_23
  return ((self.__factoryCfgs)[#self.__factoryCfgs]).line_unlock
end

ActWhiteDayData.GetWDactoryLineUnlockLevel = function(self, lineId)
  -- function num : 0_24
  return (self.__lineUnlockLevelDic)[lineId]
end

ActWhiteDayData.GetWDactoryLineIsUnlock = function(self, lineId)
  -- function num : 0_25
  do return self:GetWDactoryLineUnlockLevel(lineId) <= self:GetAWDFactoryLevel() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActWhiteDayData.GetWDFactoryLineData = function(self, lineId)
  -- function num : 0_26
  return (self.__lineDic)[lineId]
end

ActWhiteDayData.GetWDFactoryLineDataDic = function(self)
  -- function num : 0_27
  return self.__lineDic
end

ActWhiteDayData.GetWDOrderUsedTime = function(self, orderId)
  -- function num : 0_28
  if self.__OrderProducedNumDic == nil then
    return 0
  end
  return (self.__OrderProducedNumDic)[orderId] or 0
end

ActWhiteDayData.GetWDUnderAssistHeroDic = function(self)
  -- function num : 0_29
  return self.__underAssistHeroDic
end

ActWhiteDayData.GetWDCouldBuyAccItem = function(self)
  -- function num : 0_30
  return ((self.__factoryCfgs)[self.__factoryLevel]).speed_unclock
end

ActWhiteDayData.GetWDAccItemId = function(self)
  -- function num : 0_31
  return (self.__whiteDayCfg).speed_ticket
end

ActWhiteDayData.GetWDAccItemAcctime = function(self)
  -- function num : 0_32 , upvalues : _ENV
  if self.accItemAccTime ~= nil then
    return self.accItemAccTime
  end
  local itemCfg = (ConfigData.item)[(self.__whiteDayCfg).speed_ticket]
  if not (itemCfg.arg)[2] then
    self.accItemAccTime = itemCfg == nil or 0
    do return self.accItemAccTime end
    return 0
  end
end

ActWhiteDayData.GetWDOrderData = function(self, orderId)
  -- function num : 0_33
  if self.__orderDic == nil then
    return 
  end
  return (self.__orderDic)[orderId]
end

ActWhiteDayData.GetWDPhotoCfgs = function(self)
  -- function num : 0_34
  return self.__photoCfgs
end

ActWhiteDayData.GetWDUnlockedPhotoDic = function(self)
  -- function num : 0_35
  return self.__unlockedPhoto
end

ActWhiteDayData.GetWDUnlockedPhotoList = function(self)
  -- function num : 0_36
  return self.__unlockedPhotoList
end

ActWhiteDayData.GetWDUnlockedPhotoNum = function(self)
  -- function num : 0_37
  return self.__unlockedPhotoNum
end

ActWhiteDayData.GetWDAllPhotoNum = function(self)
  -- function num : 0_38 , upvalues : _ENV
  return (table.count)(self.__photoCfgs)
end

ActWhiteDayData.GetWDUnlockAllPhoto = function(self)
  -- function num : 0_39 , upvalues : _ENV
  do return self.__unlockedPhotoNum == (table.count)(self.__photoCfgs) end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActWhiteDayData.GetWDRandomPhotoItemIdAndNum = function(self)
  -- function num : 0_40
  return (self.__whiteDayCfg).random_tokenId, (self.__whiteDayCfg).random_tokenNum
end

ActWhiteDayData.GetWDExchangePhotoItemIdAndNum = function(self)
  -- function num : 0_41
  return (self.__whiteDayCfg).exchange_tokenId, (self.__whiteDayCfg).exchange_tokenNum
end

ActWhiteDayData.GetWDTaskList = function(self)
  -- function num : 0_42
  return self.__onceQuests
end

ActWhiteDayData.GetWDEndlessTaskList = function(self)
  -- function num : 0_43
  if not self.__endlessQuests then
    return {}
  end
end

ActWhiteDayData.GetWDEndlessTaskFinishedList = function(self)
  -- function num : 0_44
  if not self.__endlessFinished then
    return {}
  end
end

ActWhiteDayData.GetWDIsEndlessTaskMultReward = function(self, taskIndex)
  -- function num : 0_45 , upvalues : _ENV
  if 1 << taskIndex - 1 & self.__endlessRateFlags > 0 then
    if self.__whiteDayCfg == nil or (self.__whiteDayCfg).endless_limit_des == nil or (self.__whiteDayCfg).endless_limit_task == nil then
      error("can\'t read endless cfg with index:" .. tostring(taskIndex))
      return false
    end
    local multRateText = (LanguageUtil.GetLocaleText)(((self.__whiteDayCfg).endless_limit_des)[taskIndex])
    local multRate = ((self.__whiteDayCfg).endless_limit_task)[taskIndex]
    return true, multRateText, multRate
  end
  do
    return false
  end
end

ActWhiteDayData.GetWDIsAllSkinGet = function(self)
  -- function num : 0_46 , upvalues : _ENV
  for k,cfg in pairs(self.__photoCfgs) do
    if cfg.skinId ~= nil and (PlayerDataCenter.skinData):IsSkinUnlocked(cfg.skinId) and not (PlayerDataCenter.skinData):IsHaveSkin(cfg.skinId) then
      return false
    end
  end
  return true
end

ActWhiteDayData.GetWDIsUnlockPhotoSkinGet = function(self)
  -- function num : 0_47 , upvalues : _ENV
  for k,_ in pairs(self.__unlockedPhoto) do
    local cfg = (self.__photoCfgs)[k]
    if cfg.skinId ~= nil and (PlayerDataCenter.skinData):IsSkinUnlocked(cfg.skinId) and not (PlayerDataCenter.skinData):IsHaveSkin(cfg.skinId) then
      return false
    end
  end
  return true
end

ActWhiteDayData.GetWDIsPhotoSkinBought = function(self)
  -- function num : 0_48 , upvalues : _ENV
  for k,_ in pairs(self.__unlockedPhoto) do
    local cfg = (self.__photoCfgs)[k]
    if cfg.skinId ~= nil and (PlayerDataCenter.skinData):IsHaveSkin(cfg.skinId) then
      return true
    end
  end
  return false
end

ActWhiteDayData.GetWhiteDayPhotoConvertItemIsAboveLimit = function(self)
  -- function num : 0_49 , upvalues : _ENV
  local photoNum = (table.count)(self.__photoCfgs)
  local waitUnlockPhotoNum = photoNum - self.__unlockedPhotoNum
  local randomId, randomNum = self:GetWDRandomPhotoItemIdAndNum()
  local exchangeId, exchangeNum = self:GetWDExchangePhotoItemIdAndNum()
  local randomNum = PlayerDataCenter:GetItemCount(randomId) // randomNum
  local exchangeNum = PlayerDataCenter:GetItemCount(exchangeId) // exchangeNum
  local isFull = waitUnlockPhotoNum <= randomNum + exchangeNum
  do return isFull end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActWhiteDayData.InitWDReddot = function(self)
  -- function num : 0_50 , upvalues : _ENV, ActivityWhiteDayEnum
  local isOk, actSingleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle)
  if isOk then
    local frameActId = self:GetActFrameId()
    self.wdRedDotRootNode = actSingleNode:AddChild(frameActId)
    local taskNode = (self.wdRedDotRootNode):AddChild((ActivityWhiteDayEnum.redDotType).task)
    taskNode:AddChild((ActivityWhiteDayEnum.redDotType).commonTask)
    taskNode:AddChild((ActivityWhiteDayEnum.redDotType).endlesstask)
    local photoNode = (self.wdRedDotRootNode):AddChild((ActivityWhiteDayEnum.redDotType).photoNode)
    photoNode:AddChild((ActivityWhiteDayEnum.redDotType).couldGetNewPhoto)
    photoNode:AddChild((ActivityWhiteDayEnum.redDotType).getAllPhotoAvg)
    local orderNode = (self.wdRedDotRootNode):AddChild((ActivityWhiteDayEnum.redDotType).order)
    ;
    (self.wdRedDotRootNode):AddChild((ActivityWhiteDayEnum.redDotType).lineEvent)
  else
    do
      error("can\'t get ActivitySingle node")
    end
  end
end

ActWhiteDayData.RefreshWDReddot4Task = function(self)
  -- function num : 0_51 , upvalues : _ENV, ActivityWhiteDayEnum
  local commonTaskNum = 0
  local endlessTaskNum = 0
  local lineEventNum = 0
  if self:IsActivityRunning() then
    if self.__onceQuests ~= nil then
      for _,taskId in pairs(self.__onceQuests) do
        local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
        if taskData ~= nil and taskData:CheckComplete() then
          commonTaskNum = 1
          break
        end
      end
    end
    do
      if self.__endlessQuests ~= nil then
        for _,taskId in pairs(self.__endlessQuests) do
          local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
          if taskData ~= nil and taskData:CheckComplete() then
            endlessTaskNum = 1
            break
          end
        end
      end
      do
        if self.__orderDic ~= nil then
          for k,lineData in pairs(self.__lineDic) do
            if lineData:GetIsHaveEvent() then
              local taskId = lineData:GetWDLEventTaksId()
              local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
              if taskData ~= nil and taskData:CheckComplete() then
                lineEventNum = 1
                break
              end
            end
          end
        end
        do
          local commonTaskNode = ((self.wdRedDotRootNode):GetChild((ActivityWhiteDayEnum.redDotType).task)):GetChild((ActivityWhiteDayEnum.redDotType).commonTask)
          commonTaskNode:SetRedDotCount(commonTaskNum)
          local endlessTaskNode = ((self.wdRedDotRootNode):GetChild((ActivityWhiteDayEnum.redDotType).task)):GetChild((ActivityWhiteDayEnum.redDotType).endlesstask)
          endlessTaskNode:SetRedDotCount(endlessTaskNum)
          local lineEventNode = (self.wdRedDotRootNode):GetChild((ActivityWhiteDayEnum.redDotType).lineEvent)
          lineEventNode:SetRedDotCount(lineEventNum)
        end
      end
    end
  end
end

ActWhiteDayData.RefreshWDReddot4AlbumAvg = function(self)
  -- function num : 0_52 , upvalues : _ENV, ActivityWhiteDayEnum
  local isWatchedFinalAvg = false
  if self:IsActivityRunning() and self:GetWDUnlockAllPhoto() then
    local avgId = self:GetAWDCollectAllAvgId()
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    if avgPlayCtrl ~= nil and not avgPlayCtrl:IsAvgPlayed(avgId) then
      isWatchedFinalAvg = true
    end
  end
  do
    local avgNode = ((self.wdRedDotRootNode):GetChild((ActivityWhiteDayEnum.redDotType).photoNode)):GetChild((ActivityWhiteDayEnum.redDotType).getAllPhotoAvg)
    avgNode:SetRedDotCount(isWatchedFinalAvg and 1 or 0)
  end
end

ActWhiteDayData.SetWDReddot4Album = function(self, bool)
  -- function num : 0_53 , upvalues : ActivityWhiteDayEnum
  local isHaveNewGetPhotoItem = false
  if self:IsActivityRunning() then
    isHaveNewGetPhotoItem = bool
  end
  local newPhotoNode = ((self.wdRedDotRootNode):GetChild((ActivityWhiteDayEnum.redDotType).photoNode)):GetChild((ActivityWhiteDayEnum.redDotType).couldGetNewPhoto)
  newPhotoNode:SetRedDotCount(isHaveNewGetPhotoItem and 1 or 0)
end

ActWhiteDayData.RefreshWDReddot4Order = function(self)
  -- function num : 0_54 , upvalues : _ENV, ActivityWhiteDayEnum
  local isHaveCompletedOrder = false
  if self.__lineDic ~= nil and self:IsActivityRunning() then
    for lineId,lineData in pairs(self.__lineDic) do
      if lineData:GetIsInProduction() and lineData:GetIsProductionOver() then
        isHaveCompletedOrder = true
        break
      end
    end
  end
  do
    local orderNode = (self.wdRedDotRootNode):GetChild((ActivityWhiteDayEnum.redDotType).order)
    orderNode:SetRedDotCount(isHaveCompletedOrder and 1 or 0)
  end
end

ActWhiteDayData.__IsHaveReadDot = function(self)
  -- function num : 0_55 , upvalues : _ENV, ActivityWhiteDayEnum
  local num = 0
  local frameActId = self:GetActFrameId()
  local isOk, reddotNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, frameActId, (ActivityWhiteDayEnum.redDotType).task)
  if isOk then
    num = num + reddotNode:GetRedDotCount()
  end
  local isOrderOk, orderNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, frameActId, (ActivityWhiteDayEnum.redDotType).order)
  if isOrderOk then
    num = num + orderNode:GetRedDotCount()
  end
  if num > 0 then
    return true
  end
end

ActWhiteDayData.GetActivityReddotNum = function(self)
  -- function num : 0_56
  local isBlue, num = nil, nil
  isBlue = not self:__IsHaveReadDot()
  num = (self.wdRedDotRootNode):GetRedDotCount()
  return isBlue, num
end

return ActWhiteDayData

