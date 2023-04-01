-- params : ...
-- function num : 0 , upvalues : _ENV
local FactoryEnum = require("Game.Factory.FactoryEnum")
local FactoryCalcSendOrder = class("FactoryCalcSendOrder")
local FactoryHelper = require("Game.Factory.FactoryHelper")
FactoryCalcSendOrder.ctor = function(self)
  -- function num : 0_0
  self.isOrderMax = false
end

FactoryCalcSendOrder.CreateSendOrderDig = function(orderId, curOrderNum, lineIndex, orderData)
  -- function num : 0_1 , upvalues : FactoryCalcSendOrder, FactoryEnum
  local calcSendOrder = (FactoryCalcSendOrder.New)()
  calcSendOrder.orderType = (FactoryEnum.eOrderType).dig
  calcSendOrder.curOrderId = orderId
  calcSendOrder.curOrderNum = curOrderNum
  calcSendOrder.lineIndex = lineIndex
  calcSendOrder.usedTime = orderData:GetTimeCost() * curOrderNum
  calcSendOrder._orderData = orderData
  return calcSendOrder
end

FactoryCalcSendOrder.TryCreateSendOrderProduct = function(orderData, lineIndex, MAX_TIME_COST, usedBagItem)
  -- function num : 0_2 , upvalues : FactoryCalcSendOrder, FactoryHelper, FactoryEnum
  local calcSendOrder = (FactoryCalcSendOrder.New)()
  local orderCfg = orderData:GetOrderCfg()
  local orderId = orderCfg.id
  local usedMat = {}
  local subDic = {}
  local useBagMat = {}
  calcSendOrder._usedBagItem = usedBagItem
  local couldAdd, nowLeftTime = (FactoryHelper.CheckOrderResource)(calcSendOrder, orderData, 1, usedMat, subDic, MAX_TIME_COST, useBagMat)
  calcSendOrder._usedBagItem = nil
  if not couldAdd then
    return false, nowLeftTime
  end
  if not orderData:GetIsWhareHouseNotFull(0) then
    return false, (FactoryEnum.eCannotAddReason).warehouseFull
  end
  calcSendOrder.orderType = (FactoryEnum.eOrderType).product
  calcSendOrder.curOrderId = orderId
  calcSendOrder.curOrderNum = 1
  calcSendOrder.lineIndex = lineIndex
  calcSendOrder.assistOrderDic = subDic
  calcSendOrder.usedMat = usedMat
  calcSendOrder.usedTime = MAX_TIME_COST - nowLeftTime
  calcSendOrder._orderData = orderData
  calcSendOrder.useBagMat = useBagMat
  return true, calcSendOrder
end

FactoryCalcSendOrder.HasSubOrder = function(self)
  -- function num : 0_3 , upvalues : _ENV
  do return self.assistOrderDic ~= nil and (table.count)(self.assistOrderDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

FactoryCalcSendOrder.GetPlayerItemCount = function(self, itemId)
  -- function num : 0_4 , upvalues : _ENV
  local originCount = PlayerDataCenter:GetItemCount(itemId)
  do
    if not (self._usedBagItem)[itemId] then
      local consumeCount = self._usedBagItem == nil or 0
    end
    if consumeCount < 0 then
      originCount = 0
    else
      originCount = originCount - consumeCount
    end
    return originCount
  end
end

FactoryCalcSendOrder.CheckNextProductOrder = function(self, MAX_TIME_COST, usedBagItem)
  -- function num : 0_5 , upvalues : _ENV, FactoryHelper, FactoryEnum
  local usedMat = (table.deepCopy)(self.usedMat)
  local subDic = (table.deepCopy)(self.assistOrderDic)
  local nowLeftTime = MAX_TIME_COST - self.usedTime
  self._usedBagItem = usedBagItem
  local couldAdd, nowLeftTime = (FactoryHelper.CheckOrderResource)(self, self._orderData, 1, usedMat, subDic, nowLeftTime, self.useBagMat)
  self._usedBagItem = nil
  if not couldAdd then
    return false, nowLeftTime
  end
  if not (self._orderData):GetIsWhareHouseNotFull(self.curOrderNum) then
    return false, (FactoryEnum.eCannotAddReason).warehouseFull
  end
  self.curOrderNum = self.curOrderNum + 1
  self.usedMat = usedMat
  self.assistOrderDic = subDic
  self.usedTime = MAX_TIME_COST - nowLeftTime
  return true
end

return FactoryCalcSendOrder

