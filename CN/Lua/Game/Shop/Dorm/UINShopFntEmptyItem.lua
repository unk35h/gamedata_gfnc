-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopFntEmptyItem = class("UINShopFntEmptyItem", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopFntEmptyItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINShopFntEmptyItem.InitFntItem = function(self, goodData, baseObj)
  -- function num : 0_1
end

UINShopFntEmptyItem.RefreshLeftSellTime = function(self)
  -- function num : 0_2
end

return UINShopFntEmptyItem

