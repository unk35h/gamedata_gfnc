-- params : ...
-- function num : 0 , upvalues : _ENV
local ActWhiteDayLineOrderData = class("ActWhiteDayLineOrderData")
ActWhiteDayLineOrderData.ctor = function(self, AWDData, orderId)
  -- function num : 0_0 , upvalues : _ENV
  self.__AWDData = AWDData
  self.__orderId = orderId
  self.__orderCfg = (ConfigData.activity_white_day_order)[orderId]
  self.__IsUnlock = false
  for itemId,itemNum in pairs((self.__orderCfg).product) do
    self.__itemId = itemId
    self.__itemNum = itemNum
    if itemId ~= nil then
      self.__itemCfg = (ConfigData.item)[itemId]
    end
    do break end
  end
end

ActWhiteDayLineOrderData.UpdateWDLineOrderData = function(self)
  -- function num : 0_1
  self.__IsUnlock = (self.__orderCfg).unlock_level <= (self.__AWDData):GetAWDFactoryLevel()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActWhiteDayLineOrderData.GetWDAWDData = function(self)
  -- function num : 0_2
  return self.__AWDData
end

ActWhiteDayLineOrderData.GetWDLineOrderId = function(self)
  -- function num : 0_3
  return self.__orderId
end

ActWhiteDayLineOrderData.GetWDLineOrderIsUnlock = function(self)
  -- function num : 0_4
  return self.__IsUnlock
end

ActWhiteDayLineOrderData.GetWDLineOrderCouldShow = function(self)
  -- function num : 0_5
  do return not self.__IsUnlock or self:GetWDLineOrderUsedTime() < self:GetWDLineOrderTotalUseTime() end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ActWhiteDayLineOrderData.GetWDLineOrderUnlockLevel = function(self)
  -- function num : 0_6
  return (self.__orderCfg).unlock_level
end

ActWhiteDayLineOrderData.GetWDLineOrderUsedTime = function(self)
  -- function num : 0_7
  return (self.__AWDData):GetWDOrderUsedTime(self.__orderId)
end

ActWhiteDayLineOrderData.GetWDLineOrderTotalUseTime = function(self)
  -- function num : 0_8
  return (self.__orderCfg).max_time
end

ActWhiteDayLineOrderData.GetWDLineOrderName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__itemCfg).name)
end

ActWhiteDayLineOrderData.GetWDLineOrderCostTime = function(self)
  -- function num : 0_10
  return (self.__orderCfg).time_cost
end

ActWhiteDayLineOrderData.GetWDLineOrderExp = function(self)
  -- function num : 0_11
  return (self.__orderCfg).order_exp
end

ActWhiteDayLineOrderData.GetWDOrderItemId = function(self)
  -- function num : 0_12
  return self.__itemId
end

ActWhiteDayLineOrderData.GetWDOrderItemIdAndNum = function(self)
  -- function num : 0_13
  return self.__itemCfg, self.__itemNum
end

ActWhiteDayLineOrderData.GetWDOrderRewardDic = function(self)
  -- function num : 0_14
  return (self.__orderCfg).product
end

return ActWhiteDayLineOrderData

