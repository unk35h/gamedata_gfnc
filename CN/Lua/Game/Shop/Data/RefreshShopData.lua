-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Shop.Data.ShopDataBase")
local RefreshShopData = class("RefreshShopData", base)
local ShopEnum = require("Game.Shop.ShopEnum")
RefreshShopData.ctor = function(self)
  -- function num : 0_0 , upvalues : ShopEnum
  self:AddShopDataComp((ShopEnum.eShopDataCompType).refresh)
end

return RefreshShopData

