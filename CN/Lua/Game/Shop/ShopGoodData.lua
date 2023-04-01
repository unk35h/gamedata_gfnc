-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopGoodData = class("ShopGoodData")
local ShopEnum = require("Game.Shop.ShopEnum")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
ShopGoodData.IsUseful = function(itemId)
  -- function num : 0_0 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  do
    if itemCfg ~= nil and itemCfg.type == eItemType.Skin then
      local isUnlock, isRecitify = (PlayerDataCenter.skinData):IsSkinUnlocked(itemId)
      if isRecitify and isGameDev then
        warn("商店中有被和谐的皮肤出现, itemId为:" .. tostring(itemId))
      end
      return isUnlock
    end
    return true
  end
end

ShopGoodData.CreateShopGoodData = function(data, shopType, shopId)
  -- function num : 0_1 , upvalues : ShopGoodData
  if not (ShopGoodData.IsUseful)(data.itemId) then
    return nil
  end
  local ShopGoodData = (ShopGoodData.New)()
  ShopGoodData:InitShopGoodData(data, shopType, shopId)
  return ShopGoodData
end

ShopGoodData.CreateNewShopGoodData = function(goodCfg, shopType, shopId, purchases, hasDouble, historyPurchases)
  -- function num : 0_2 , upvalues : ShopGoodData
  if not (ShopGoodData.IsUseful)(goodCfg.itemId) then
    return nil
  end
  local ShopGoodData = (ShopGoodData.New)()
  ShopGoodData:InitNewShopGoodData(goodCfg, shopType, shopId, purchases, hasDouble, historyPurchases)
  return ShopGoodData
end

ShopGoodData.ctor = function(self)
  -- function num : 0_3 , upvalues : ShopEnum, _ENV
  self.shopId = nil
  self.shelfId = nil
  self.itemId = nil
  self.itemCfg = nil
  self.itemNum = nil
  self.currencyId = nil
  self.oldCurrencyNum = 0
  self.newCurrencyNum = 0
  self.discount = nil
  self.isLimit = false
  self.limitType = (ShopEnum.eLimitType).None
  self.isSoldOut = false
  self.purchases = nil
  self.limitTime = nil
  self.historyPurchases = nil
  self.totallimitTime = nil
  self.freshTm = nil
  self.isRecommendGood = nil
  self.order = math.mininteger
  self.pageId = nil
end

ShopGoodData.InitShopGoodData = function(self, data, shopType, shopId)
  -- function num : 0_4 , upvalues : _ENV
  self.shopId = shopId
  self.shopType = shopType
  self.shelfId = data.shelfId
  self.itemId = data.itemId
  self.itemNum = data.itemNum
  local payType = data.payType
  self.discount = data.discount
  local FreshType = data.FreshType
  self.purchases = data.purchases
  self.freshTm = data.freshTm
  self.historyPurchases = data.historyPurchases
  local itemCfg = (ConfigData.item)[self.itemId]
  if itemCfg == nil then
    error("item cfg is null,id:" .. tostring(self.itemId))
  else
    self.itemCfg = itemCfg
    self:m_HandleCurrency(payType)
  end
  self:m_HandleDifferData(shopType, shopId, FreshType)
  if data.order ~= nil then
    self.order = data.order
  end
end

ShopGoodData.InitNewShopGoodData = function(self, goodCfg, shopType, shopId, purchases, hasDouble, historyPurchases)
  -- function num : 0_5 , upvalues : ShopEnum, _ENV
  self.shopId = shopId
  self.shopType = shopType
  self.shelfId = goodCfg.goods_shelves
  self.itemId = goodCfg.itemId
  self.discount = 100
  self.purchases = purchases or 0
  self.historyPurchases = historyPurchases or 0
  self.hasDouble = hasDouble
  self.freshTm = 0
  self.goodCfg = goodCfg
  do
    if shopType ~= (ShopEnum.eShopType).Recharge then
      local itemCfg = (ConfigData.item)[self.itemId]
      if itemCfg == nil then
        error("item cfg is null,id:" .. tostring(self.itemId))
      else
        self.itemCfg = itemCfg
      end
    end
    self.currencyId = goodCfg.currencyId
    self:m_HandleDifferData(shopType, shopId, nil)
    if goodCfg.order ~= nil then
      self.order = goodCfg.order
    end
  end
end

ShopGoodData.m_HandleCurrency = function(self, payType)
  -- function num : 0_6 , upvalues : _ENV
  local payItemCfg = (ConfigData.item)[payType]
  if payItemCfg == nil then
    error("item cfg is null,id:" .. tostring(payType))
  end
  local currencyCfg = (ConfigData.item_currency)[payType]
  if currencyCfg == nil then
    error("Item Currency Cfg is null,ID:" .. tostring(payType))
  else
    local originPrice = (math.ceil)(((self.itemCfg).currency_price)[currencyCfg.num] * self.itemNum / currencyCfg.divisor)
    self.oldCurrencyNum = originPrice
    if self.discount == 100 then
      self.newCurrencyNum = originPrice
    else
      self.newCurrencyNum = (math.ceil)(originPrice * self.discount / 100)
    end
    self.currencyId = payItemCfg.id
  end
end

ShopGoodData.m_HandleDifferData = function(self, shopType, shopId, FreshType)
  -- function num : 0_7 , upvalues : ShopEnum, _ENV
  if shopType == (ShopEnum.eShopType).Normal or shopType == (ShopEnum.eShopType).Skin then
    if (ConfigData.shop_normal)[shopId] == nil or ((ConfigData.shop_normal)[shopId])[self.shelfId] == nil then
      error("shop normal cfg is null,storeId:" .. tostring(shopId) .. " shelfId:" .. tostring(self.shelfId))
      self.isLimit = true
      self.isSoldOut = true
    else
      local shelfCfg = ((ConfigData.shop_normal)[shopId])[self.shelfId]
      local limitTime = shelfCfg.times
      self.pageId = shelfCfg.page
      if FreshType > 0 then
        self.limitType = FreshType
        self.isSoldOut = limitTime <= self.purchases
        self.limitTime = limitTime
        self.isLimit = true
      else
        self.isSoldOut = false
        self.isLimit = false
      end
      self.shelfCfg = shelfCfg
    end
  elseif shopType == (ShopEnum.eShopType).Random then
    self.isLimit = true
    self.limitType = (ShopEnum.eLimitType).Eternal
    self.limitTime = 1
    self.isSoldOut = self.purchases > 0
  elseif shopType == (ShopEnum.eShopType).Resource then
    self.isLimit = true
    self.isSoldOut = true
    self.limitType = (ShopEnum.eLimitType).Day
    if #(self.goodCfg).times ~= 0 then
      self.limitTime = ((self.goodCfg).times)[#(self.goodCfg).times]
      for i,refreshTime in ipairs((self.goodCfg).times) do
        if self.purchases < refreshTime or refreshTime == -1 then
          self.itemNum = ((self.goodCfg).itemNums)[i]
          self.isSoldOut = false
          self.oldCurrencyNum = ((self.goodCfg).currencyNums)[i]
          self.newCurrencyNum = ((self.goodCfg).currencyNums)[i]
          if refreshTime == -1 then
            self.isLimit = false
            break
          end
          self.limitTime = refreshTime
          break
        end
      end
      if self.isLimit then
        self.totallimitTime = ((self.goodCfg).times)[#(self.goodCfg).times]
      end
    end
  elseif shopType == (ShopEnum.eShopType).ResourceRefresh then
    self.isLimit = true
    self.isSoldOut = true
    self.isRecommendGood = (self.goodCfg).recommend_tag
    self.shelfCfg = ((ConfigData.shop_resource)[shopId])[self.shelfId]
    local cycleBuyLimit = math.maxinteger
    if (self.shelfCfg).limit_type ~= 0 then
      if (self.shelfCfg).limit_type == 202 then
        self.limitType = 3
      end
      if (self.shelfCfg).limit_times > 0 and not (self.shelfCfg).limit_times then
        cycleBuyLimit = math.maxinteger
      end
    end
    if #(self.goodCfg).times ~= 0 then
      self.limitTime = ((self.goodCfg).times)[#(self.goodCfg).times]
      for i,refreshTime in ipairs((self.goodCfg).times) do
        if self.purchases < refreshTime or refreshTime == -1 then
          self.itemNum = ((self.goodCfg).itemNums)[i]
          self.isSoldOut = false
          self.oldCurrencyNum = ((self.goodCfg).currencyNums)[i]
          self.newCurrencyNum = ((self.goodCfg).currencyNums)[i]
          if refreshTime == -1 then
            if cycleBuyLimit < math.maxinteger then
              self.limitTime = cycleBuyLimit
              self.totallimitTime = cycleBuyLimit
              self.isSoldOut = self.totallimitTime <= self.purchases
              break
            end
            self.isLimit = false
            break
          end
          self.limitTime = (math.min)(refreshTime, cycleBuyLimit)
          self.totallimitTime = (math.min)(((self.goodCfg).times)[#(self.goodCfg).times], cycleBuyLimit)
          self.isSoldOut = self.totallimitTime <= self.purchases
          break
        elseif i == #(self.goodCfg).times then
          self.oldCurrencyNum = ((self.goodCfg).currencyNums)[i]
          self.newCurrencyNum = ((self.goodCfg).currencyNums)[i]
        end
      end
    end
  elseif shopType == (ShopEnum.eShopType).Charcter then
    self.isLimit = true
    self.isSoldOut = true
    self.fragMaxBuyNum = 0
    if #(self.goodCfg).times ~= 0 then
      self.limitTime = ((self.goodCfg).times)[#(self.goodCfg).times]
      for i,refreshTime in ipairs((self.goodCfg).times) do
        if self.purchases < refreshTime or refreshTime == -1 then
          self.itemNum = ((self.goodCfg).itemNums)[i]
          local itemCfg = (ConfigData.item)[(self.goodCfg).itemId]
          if itemCfg == nil or itemCfg.arg == nil then
            error("cant\'t read itemCfg(.arg) with id = " .. tostring((self.goodCfg).itemId))
          end
          local heroData = (PlayerDataCenter.heroDic)[(itemCfg.arg)[1]]
          if heroData == nil then
            error("cant\'t read heroData with id = " .. tostring((itemCfg.arg)[1]))
          end
          self.fragMaxBuyNum = heroData:GetMaxNeedFragNum(true)
          self.isSoldOut = self.fragMaxBuyNum <= 0
          self.isFullHeroFrag = self.fragMaxBuyNum <= 0
          self.oldCurrencyNum = ((self.goodCfg).currencyNums)[i]
          self.newCurrencyNum = ((self.goodCfg).currencyNums)[i]
          if refreshTime == -1 then
            self.isLimit = false
            break
          end
          self.limitTime = refreshTime
          break
        end
      end
    end
    self.pageId = (self.goodCfg).page
  end
  self.isSoldOut = self.isSoldOut or PlayerDataCenter:IsItemLimitHold(self.itemId) or false
  -- DECOMPILER ERROR: 33 unprocessed JMP targets
end

ShopGoodData.GetCouldBuy = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.newCurrencyNum <= PlayerDataCenter:GetItemCount(self.currencyId) then
    return true
  else
    return false
  end
end

ShopGoodData.GetItemHoldLimit = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if (self.itemCfg).holdlimit == nil or (self.itemCfg).holdlimit == 0 then
    return -1
  end
  local specialNum = 0
  if (self.itemCfg).type == eItemType.DormFurniture then
    specialNum = specialNum + (PlayerDataCenter.dormBriefData):GetFurnitureItemCountInDorm(self.itemId)
  end
  return (math.max)((self.itemCfg).holdlimit - PlayerDataCenter:GetItemCount(self.itemId) - (specialNum), 0)
end

ShopGoodData.GetWareHouseLeftCapacity = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local num = (PlayerDataCenter.playerBonus):GetWarehouseCapcity(self.itemId)
  if num == 0 then
    return -1
  end
  local specialNum = 0
  if (self.itemCfg).type == eItemType.DormFurniture then
    specialNum = specialNum + (PlayerDataCenter.dormBriefData):GetFurnitureItemCountInDorm(self.itemId)
  end
  return (math.max)(num - PlayerDataCenter:GetItemCount(self.itemId) - (specialNum), 0)
end

ShopGoodData.GetCouldBuyMaxBuyNum = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local leftCapacity = self:GetWareHouseLeftCapacity()
  local itemHoldLimit = self:GetItemHoldLimit()
  if leftCapacity == -1 then
    if itemHoldLimit == -1 then
      return -1
    else
      local canBuyItenCount = (math.max)(0, itemHoldLimit - PlayerDataCenter:GetItemCount(self.itemId))
      return (math.floor)(canBuyItenCount / (self.itemNum or 1))
    end
  else
    do
      local leftCapacityBuyNum = (math.ceil)(leftCapacity / (self.itemNum or 1))
      if itemHoldLimit == -1 then
        return leftCapacityBuyNum
      else
        local itemHoldBuyNum = (math.floor)(itemHoldLimit / (self.itemNum or 1))
        if itemHoldBuyNum <= leftCapacityBuyNum then
          return itemHoldBuyNum
        else
          return leftCapacityBuyNum
        end
      end
    end
  end
end

ShopGoodData.GetPriceInterval = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if (self.goodCfg).times == nil or #(self.goodCfg).times == 0 then
    return 
  end
  local intervalList = {}
  local priceList = {}
  local curIndex = nil
  local lastTime = 1
  for i,refreshTime in ipairs((self.goodCfg).times) do
    priceList[i] = ((self.goodCfg).currencyNums)[i]
    if curIndex == nil and (self.purchases < refreshTime or refreshTime == -1) then
      curIndex = i
    end
    if refreshTime == -1 then
      intervalList[i] = (Vector2.New)(lastTime, -1)
      break
    else
      intervalList[i] = (Vector2.New)(lastTime, refreshTime)
      lastTime = refreshTime + 1
    end
  end
  do
    return intervalList, priceList, curIndex
  end
end

ShopGoodData.UpdateShopGoodData = function(self, data)
  -- function num : 0_13 , upvalues : ShopEnum
  if self.shopType == (ShopEnum.eShopType).Charcter or self.shopType == (ShopEnum.eShopType).Recharge or self.shopType == (ShopEnum.eShopType).Resource or self.shopType == (ShopEnum.eShopType).ResourceRefresh then
    self.shelfId = data.shelfId
    self.purchases = data.purchases
    self.hasDouble = data.hasDouble
    self.historyPurchases = data.historyPurchases
    self:m_HandleDifferData(self.shopType, self.shopId, nil)
  else
    self.shelfId = data.shelfId
    self.itemId = data.itemId
    self.itemNum = data.itemNum
    local payType = data.payType
    self.discount = data.discount
    local FreshType = data.FreshType
    self.purchases = data.purchases
    self.freshTm = data.freshTm
    self:m_HandleCurrency(payType)
    self:m_HandleDifferData(self.shopType, self.shopId, FreshType)
  end
end

ShopGoodData.GetTotallimitTime = function(self)
  -- function num : 0_14
  if not self.totallimitTime then
    return self.limitTime
  end
end

ShopGoodData.GetStillTime = function(self)
  -- function num : 0_15 , upvalues : _ENV, CheckerTypeId
  if self.shelfCfg == nil or (self.shelfCfg).pre_condition == nil then
    return false
  end
  for index,coditon in ipairs((self.shelfCfg).pre_condition) do
    if coditon == CheckerTypeId.TimeRange then
      local startTime = ((self.shelfCfg).pre_para1)[index]
      local endTime = ((self.shelfCfg).pre_para2)[index]
      local inTime = startTime < PlayerDataCenter.timestamp and PlayerDataCenter.timestamp < endTime or endTime == -1
      return true, inTime, startTime, endTime
    end
  end
  do return false end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ShopGoodData.RefreshDataWithSeverMsg = function(self)
  -- function num : 0_16
  self:m_HandleDifferData(self.shopType, self.shopId, nil)
end

ShopGoodData.IsReplenishGoodsAndCount = function(self)
  -- function num : 0_17
  do
    if not (self.goodCfg).replenish_num then
      local count = self.goodCfg == nil or 0
    end
    do return count > 0, count end
    do
      if not (self.shelfCfg).replenish_num then
        local count = self.shelfCfg == nil or 0
      end
      do return count > 0, count end
      do return false, 0 end
      -- DECOMPILER ERROR: 5 unprocessed JMP targets
    end
  end
end

return ShopGoodData

