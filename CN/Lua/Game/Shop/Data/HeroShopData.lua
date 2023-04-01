-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Shop.Data.ShopDataBase")
local HeroShopData = class("HeroShopData", base)
local ShopEnum = require("Game.Shop.ShopEnum")
local ShopGoodData = require("Game.Shop.ShopGoodData")
HeroShopData.ctor = function(self)
  -- function num : 0_0 , upvalues : ShopEnum
  self:AddShopDataComp((ShopEnum.eShopDataCompType).page)
end

HeroShopData.UpdateShopGoodsData = function(self, shopDataMsg)
  -- function num : 0_1 , upvalues : _ENV, ShopGoodData
  local heroShopCfg = (ConfigData.shop_hero)[self.shopId]
  if heroShopCfg == nil then
    error("heroShop cfg is null,ID:" .. tostring(self.shopId))
    return 
  end
  for shelfId,data in pairs(heroShopCfg) do
    if (CheckCondition.CheckLua)(data.pre_condition, data.pre_para1, data.pre_para2) then
      local goodsData = (self.shopGoodsDic)[shelfId]
      local serverData = nil
      local purchases = 0
      local historyPurchases = 0
      local hasdouble = nil
      if shopDataMsg ~= nil then
        serverData = (shopDataMsg.data)[shelfId]
        if serverData ~= nil then
          purchases = serverData.purchases
          hasdouble = serverData.hasDouble
          historyPurchases = serverData.historyPurchases
        end
      end
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R13 in 'UnsetPending'

      if goodsData == nil or shopDataMsg == nil then
        (self.shopGoodsDic)[shelfId] = (ShopGoodData.CreateNewShopGoodData)(data, self.shopType, self.shopId, purchases, hasdouble, historyPurchases)
      else
        goodsData:InitNewShopGoodData(data, self.shopType, self.shopId, purchases, hasdouble, historyPurchases)
      end
    end
  end
end

return HeroShopData

