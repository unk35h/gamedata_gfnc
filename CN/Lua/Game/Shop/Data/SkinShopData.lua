-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Shop.Data.ShopDataBase")
local SkinShopData = class("SkinShopData", base)
local ShopEnum = require("Game.Shop.ShopEnum")
local ShopGoodData = require("Game.Shop.ShopGoodData")
SkinShopData.ctor = function(self)
  -- function num : 0_0 , upvalues : ShopEnum
  self:AddShopDataComp((ShopEnum.eShopDataCompType).timeLimit)
  self:AddShopDataComp((ShopEnum.eShopDataCompType).page)
end

SkinShopData.UpdateShopGoodsData = function(self, shopDataMsg)
  -- function num : 0_1 , upvalues : _ENV, ShopGoodData
  if shopDataMsg == nil then
    return 
  end
  local normalShopCfg = (ConfigData.shop_normal)[self.shopId]
  if normalShopCfg == nil then
    error("normalShopCfg cfg is null,ID:" .. tostring(self.shopId))
    return 
  end
  for _,data in pairs(shopDataMsg.data) do
    local goodCfg = normalShopCfg[data.shelfId]
    if goodCfg == nil then
      error("normalShopCfg cfg is null,ID:" .. tostring(self.shopId) .. " shelfId" .. tostring(data.shelfId))
      return 
    end
    data.order = goodCfg.order
    local shopGoodsData = (self.shopGoodsDic)[data.shelfId]
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R10 in 'UnsetPending'

    if shopGoodsData == nil then
      (self.shopGoodsDic)[data.shelfId] = (ShopGoodData.CreateShopGoodData)(data, self.shopType, self.shopId)
    else
      shopGoodsData:InitShopGoodData(data, self.shopType, self.shopId)
    end
  end
end

return SkinShopData

