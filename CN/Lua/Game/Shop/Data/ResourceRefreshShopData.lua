-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Shop.Data.ResourceShopData")
local ResourceRefreshShopData = class("ResourceRefreshShopData", base)
local ShopEnum = require("Game.Shop.ShopEnum")
local ShopGoodData = require("Game.Shop.ShopGoodData")
ResourceRefreshShopData.ctor = function(self)
  -- function num : 0_0 , upvalues : ShopEnum
  self:AddShopDataComp((ShopEnum.eShopDataCompType).timeLimit)
  self:AddShopDataComp((ShopEnum.eShopDataCompType).refresh)
end

return ResourceRefreshShopData

