-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopDataBase = class("ShopDataBase")
local ShopEnum = require("Game.Shop.ShopEnum")
local ShopGoodData = require("Game.Shop.ShopGoodData")
ShopDataBase.ctor = function(self)
  -- function num : 0_0
  self.shopId = nil
  self.shopCfg = nil
  self.shopType = nil
  self.shopName = nil
  self.shopName_EN = nil
  self.shopGoodsDic = {}
  self.__shopDataCompDic = {}
  self.__shopDataComplist = {}
end

ShopDataBase.InitShopData = function(self, shopDataMsg, shopId)
  -- function num : 0_1 , upvalues : _ENV
  self.shopId = shopId
  local shopCfg = (ConfigData.shop)[self.shopId]
  if shopCfg == nil then
    error("shop cfg is null,ID:" .. tostring(self.shopId))
    return 
  end
  self.shopCfg = shopCfg
  self.shopType = shopCfg.shop_type
  self.shopName = (LanguageUtil.GetLocaleText)(shopCfg.name)
  self.shopName_EN = (LanguageUtil.GetLocaleText)(shopCfg.name_en)
  self:UpdateShopData(shopDataMsg)
end

ShopDataBase.UpdateShopGoodsData = function(self, shopDataMsg)
  -- function num : 0_2 , upvalues : _ENV, ShopGoodData
  if shopDataMsg == nil then
    return 
  end
  for shelfId,shopGoods in pairs(self.shopGoodsDic) do
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R7 in 'UnsetPending'

    if (shopDataMsg.data)[shelfId] == nil then
      (self.shopGoodsDic)[shelfId] = nil
    end
  end
  for _,data in pairs(shopDataMsg.data) do
    local shopGoodsData = (self.shopGoodsDic)[data.shelfId]
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

    if shopGoodsData == nil then
      (self.shopGoodsDic)[data.shelfId] = (ShopGoodData.CreateShopGoodData)(data, self.shopType, self.shopId)
    else
      shopGoodsData:InitShopGoodData(data, self.shopType, self.shopId)
    end
  end
end

ShopDataBase.UpdateShopComps = function(self, shopDataMsg)
  -- function num : 0_3 , upvalues : _ENV
  for _,comp in ipairs(self.__shopDataComplist) do
    comp:UpdateShopDataComp(self, shopDataMsg)
  end
end

ShopDataBase.AddShopDataComp = function(self, compType)
  -- function num : 0_4 , upvalues : _ENV, ShopEnum
  if (self.__shopDataCompDic)[compType] ~= nil then
    error("shopData already have this comp" .. tostring(compType))
    return 
  end
  local compClass = (ShopEnum.eShopDataCompClass)[compType]
  if compClass == nil then
    error("can\'t find shopData comp" .. tostring(compType))
    return 
  end
  local comp = (compClass.New)()
  ;
  (table.insert)(self.__shopDataComplist, comp)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__shopDataCompDic)[compType] = comp
end

ShopDataBase.GetShopDataComp = function(self, compType)
  -- function num : 0_5
  return (self.__shopDataCompDic)[compType]
end

ShopDataBase.UpdateShopData = function(self, shopDataMsg)
  -- function num : 0_6
  self:UpdateShopGoodsData(shopDataMsg)
  self:UpdateShopComps(shopDataMsg)
end

ShopDataBase.GetIsHavePages = function(self)
  -- function num : 0_7 , upvalues : ShopEnum
  do return self:GetShopDataComp((ShopEnum.eShopDataCompType).page) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ShopDataBase.GetPageDic = function(self)
  -- function num : 0_8 , upvalues : ShopEnum
  local pageComp = self:GetShopDataComp((ShopEnum.eShopDataCompType).page)
  return pageComp:GetShopPagesDic()
end

ShopDataBase.HasShopGoodsInPage = function(self, pageId)
  -- function num : 0_9 , upvalues : ShopEnum
  local pageComp = self:GetShopDataComp((ShopEnum.eShopDataCompType).page)
  return pageComp:HasShopGoodsInPage(pageId)
end

ShopDataBase.GetCurShopGoods = function(self, pageId)
  -- function num : 0_10 , upvalues : ShopEnum, _ENV
  local pageComp = self:GetShopDataComp((ShopEnum.eShopDataCompType).page)
  if pageComp == nil or pageId == nil then
    return self.shopGoodsDic
  else
    local shelfIds = (pageComp:GetShopPagesDic())[pageId]
    local goodsDatas = {}
    for index,shelfId in ipairs(shelfIds.shelfIds) do
      (table.insert)(goodsDatas, (self.shopGoodsDic)[shelfId])
    end
    return goodsDatas
  end
end

ShopDataBase.GetIsHaveRefresh = function(self)
  -- function num : 0_11 , upvalues : ShopEnum
  do return self:GetShopDataComp((ShopEnum.eShopDataCompType).refresh) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ShopDataBase.GetIsCouldRefresh = function(self)
  -- function num : 0_12
  return self.couldFresh
end

ShopDataBase.GetRemainAutoRefreshTime = function(self, needZero)
  -- function num : 0_13 , upvalues : ShopEnum
  if self:GetIsHaveRefresh() then
    return (self:GetShopDataComp((ShopEnum.eShopDataCompType).refresh)):GetRemainAutoRefreshTime()
  end
end

ShopDataBase.GetIsHaveRefreshItem = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local latestRT = nil
  for _,goodData in pairs(self.shopGoodsDic) do
    if goodData.isLimit then
      if latestRT == nil then
        latestRT = goodData.freshTm
      else
        latestRT = (math.min)(goodData.freshTm, latestRT)
      end
    end
  end
  if latestRT == nil then
    return false
  end
  do return latestRT - PlayerDataCenter.timestamp <= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ShopDataBase.GetShopGoodDataByItemId = function(self, itemId, isCheckGift)
  -- function num : 0_15 , upvalues : _ENV
  for shelfId,goodsData in pairs(self.shopGoodsDic) do
    if goodsData.itemId == itemId then
      return goodsData
    else
      if isCheckGift then
        local itemCfg = (ConfigData.item)[goodsData.itemId]
        if itemCfg.type == eItemType.Package then
          for i = 1, #itemCfg.arg do
            if (itemCfg.arg)[i] == itemId then
              return goodsData
            end
          end
        end
      end
    end
  end
end

ShopDataBase.GetNormalShopGoodByItemId = function(self, itemId)
  -- function num : 0_16 , upvalues : _ENV
  for shelfId,goodsData in ipairs(self.shopGoodsDic) do
    if goodsData.itemId == itemId then
      return goodsData
    end
  end
end

ShopDataBase.SetResourceDisplay = function(self, shopGoodsDic)
  -- function num : 0_17 , upvalues : _ENV
  local idDic = {}
  if shopGoodsDic ~= nil then
    for _,goodsData in pairs(shopGoodsDic) do
      if goodsData.currencyId ~= nil then
        idDic[goodsData.currencyId] = true
      end
    end
  end
  do
    if self:GetIsHaveRefresh() and self.refreshCost then
      idDic[(self.refreshCost).costId] = true
    end
    if idDic[ConstGlobalItem.PaidSubItem] then
      idDic[ConstGlobalItem.PaidItem] = true
    end
    local ids = {}
    for id,_ in pairs(idDic) do
      (table.insert)(ids, id)
    end
    ;
    (table.sort)(ids, function(a, b)
    -- function num : 0_17_0
    do return a < b end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    return ids
  end
end

ShopDataBase.GetShopInSellDormThemeDic = function(self, themeIdDic)
  -- function num : 0_18 , upvalues : _ENV
  for _,goodData in pairs(self.shopGoodsDic) do
    local themeId = (goodData.shelfCfg).theme_id
    if themeId ~= 0 then
      themeIdDic[themeId] = true
    end
  end
end

return ShopDataBase

