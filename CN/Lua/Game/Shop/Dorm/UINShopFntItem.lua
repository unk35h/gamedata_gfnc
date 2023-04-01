-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopFntItem = class("UINShopFntItem", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopFntItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINShopFntItem.InitNormalGoodsItem = function(self, goodData, purchaseRoot, refreshFunc, baseObj)
  -- function num : 0_1
  self.goodData = goodData
  self.purchaseRoot = purchaseRoot
  self.refreshFunc = refreshFunc
  self.type = goodData.type
  self.baseObj = baseObj
  ;
  ((self.baseObj).transform):SetParent(self.transform, false)
  ;
  (self.baseObj):InitFntItem(goodData, self)
end

UINShopFntItem.RefreshLeftSellTime = function(self)
  -- function num : 0_2
  (self.baseObj):RefreshLeftSellTime()
end

UINShopFntItem.RefreshGoods = function(self)
  -- function num : 0_3
  if self.refreshFunc ~= nil then
    (self.refreshFunc)()
  end
end

return UINShopFntItem

