-- params : ...
-- function num : 0 , upvalues : _ENV
local ActWhiteDayLineData = class("ActWhiteDayLineData")
ActWhiteDayLineData.ctor = function(self, AWDData, lineId)
  -- function num : 0_0 , upvalues : _ENV
  self.__AWDData = AWDData
  self.__lineId = lineId
  self.__lineCfg = ((ConfigData.activity_white_day_line)[AWDData:GetActId()])[lineId]
  self.__unlockLevel = 1
  self.__isUnlock = false
  self.__assistHeroID = nil
  self.__orderDataList = nil
  self.__isInProduction = false
  self.__inProductionOrderData = nil
  self.__endProductionTm = nil
  self.__isHaveEvent = false
  self.__eventTaskId = false
end

ActWhiteDayLineData.UpdateWDLineData = function(self, orderMsg)
  -- function num : 0_1 , upvalues : _ENV
  self.__isUnlock = (self.__AWDData):GetWDactoryLineIsUnlock(self.__lineId)
  if orderMsg ~= nil then
    self.__isInProduction = true
    self.__inProductionOrderId = orderMsg.orderId
    self.__inProductionOrderData = (self.__AWDData):GetWDOrderData(orderMsg.orderId)
    self.__endProductionTm = orderMsg.endTm
    if orderMsg.heroId == 0 then
      self.__assistHeroID = nil
    else
      self.__assistHeroID = orderMsg.heroId
    end
    self.__isHaveEvent = orderMsg.questId ~= nil and orderMsg.questId ~= 0 and ((PlayerDataCenter.allTaskData).taskDatas)[orderMsg.questId] ~= nil
    self.__eventTaskId = orderMsg.questId
  else
    self.__isInProduction = false
    self.__isHaveEvent = false
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

ActWhiteDayLineData.GenWDOrderDataList = function(self, orderDic)
  -- function num : 0_2 , upvalues : _ENV
  local orderList = self:GetWDLineOrderList()
  self.__orderDataList = {}
  for index,orderId in ipairs(orderList) do
    local orderData = orderDic[orderId]
    if orderData ~= nil then
      (table.insert)(self.__orderDataList, orderData)
    end
  end
  if self.__inProductionOrderId ~= nil then
    self.__inProductionOrderData = (self.__AWDData):GetWDOrderData(self.__inProductionOrderId)
  end
end

ActWhiteDayLineData.SetWDLDAssistHeroID = function(self, heroId)
  -- function num : 0_3
  self.__assistHeroID = heroId
  ;
  (self.__AWDData):UpdateUnderAssistHeroDic()
end

ActWhiteDayLineData.GetWDLDLineID = function(self)
  -- function num : 0_4
  return self.__lineId
end

ActWhiteDayLineData.GetWDLDAssistHeroID = function(self)
  -- function num : 0_5
  return self.__assistHeroID
end

ActWhiteDayLineData.GetAWDData = function(self)
  -- function num : 0_6
  return self.__AWDData
end

ActWhiteDayLineData.GetIsWDLUnlock = function(self)
  -- function num : 0_7
  return self.__isUnlock
end

ActWhiteDayLineData.GetWDLUnlockLevel = function(self)
  -- function num : 0_8
  return (self.__AWDData):GetWDactoryLineUnlockLevel(self.__lineId)
end

ActWhiteDayLineData.GetIsInProduction = function(self)
  -- function num : 0_9
  return self.__isInProduction
end

ActWhiteDayLineData.GetIsHaveEvent = function(self)
  -- function num : 0_10 , upvalues : _ENV
  do return not self.__isHaveEvent or (self.__eventTaskId ~= nil and ((PlayerDataCenter.allTaskData).taskDatas)[self.__eventTaskId] ~= nil) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ActWhiteDayLineData.GetWDLEventTaksId = function(self)
  -- function num : 0_11
  return self.__eventTaskId
end

ActWhiteDayLineData.GetInProductionTotalTime = function(self)
  -- function num : 0_12
  return (self.__inProductionOrderData):GetWDLineOrderCostTime()
end

ActWhiteDayLineData.GetInProductionLeftTime = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local leftTime = (math.clamp)(self.__endProductionTm - PlayerDataCenter.timestamp, 0, self:GetInProductionTotalTime())
  leftTime = (math.ceil)(leftTime)
  return leftTime
end

ActWhiteDayLineData.GetIsProductionOver = function(self)
  -- function num : 0_14
  if not self.__isInProduction then
    return false
  end
  do return self:GetInProductionLeftTime() <= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActWhiteDayLineData.GetWDProductionOrderId = function(self)
  -- function num : 0_15
  if self.__isInProduction then
    return self.__inProductionOrderId
  end
end

ActWhiteDayLineData.GetWDProductionOrderData = function(self)
  -- function num : 0_16
  if self.__inProductionOrderData ~= nil then
    return self.__inProductionOrderData
  end
end

ActWhiteDayLineData.GetWDLineOrderList = function(self)
  -- function num : 0_17
  return (self.__lineCfg).order_list
end

ActWhiteDayLineData.GetWDLineCfg = function(self)
  -- function num : 0_18
  return self.__lineCfg
end

ActWhiteDayLineData.GetWDLineOrderDataList = function(self)
  -- function num : 0_19
  return self.__orderDataList
end

return ActWhiteDayLineData

