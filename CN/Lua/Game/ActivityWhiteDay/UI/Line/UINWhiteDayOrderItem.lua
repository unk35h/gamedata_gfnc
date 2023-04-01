-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayOrderItem = class("UINWhiteDayOrderItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINWhiteDayOrderItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Produce, self, self.OnClickStartProduce)
  self.baseItemWithCount = (UINBaseItemWithCount.New)()
  ;
  (self.baseItemWithCount):Init((self.ui).uINBaseItemWithCount)
end

UINWhiteDayOrderItem.InitWDOrderItem = function(self, orderData, onClickkStartProduce)
  -- function num : 0_1
  self.orderData = orderData
  self.onClickkStartProduce = onClickkStartProduce
  self.AWDData = orderData:GetWDAWDData()
  self:RefreshWDOrderItem()
end

UINWhiteDayOrderItem.RefreshWDOrderItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local randomId, _ = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  local isLimit = (self.AWDData):GetWhiteDayPhotoConvertItemIsAboveLimit()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self.orderData):GetWDLineOrderName()
  local costTime = (self.orderData):GetWDLineOrderCostTime()
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = TimeUtil:TimestampToTime(costTime)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Experience).text = tostring((self.orderData):GetWDLineOrderExp())
  local totalTime = (self.orderData):GetWDLineOrderTotalUseTime()
  local usedTime = (self.orderData):GetWDLineOrderUsedTime()
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(usedTime), tostring(totalTime))
  local itemId = (self.orderData):GetWDOrderItemId()
  local orderItemCfg, itemNum = (self.orderData):GetWDOrderItemIdAndNum()
  ;
  (self.baseItemWithCount):InitItemWithCount(orderItemCfg, itemNum)
  if randomId == itemId or exchangeId == itemId then
    (self.baseItemWithCount):SetItemRecycyleTag(isLimit)
  end
end

UINWhiteDayOrderItem.OnClickStartProduce = function(self)
  -- function num : 0_3
  if self.onClickkStartProduce ~= nil then
    (self.onClickkStartProduce)(self.orderData)
  end
end

UINWhiteDayOrderItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayOrderItem

