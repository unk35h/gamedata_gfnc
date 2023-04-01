-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopThemeSkinList = class("UINShopThemeSkinList", UIBaseNode)
local base = UIBaseNode
local UINShopThemeSkinItem = require("Game.Shop.UINShopThemeSkinItem")
UINShopThemeSkinList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.ItemDic = {}
  self.dataList = nil
  self.containThemeDic = nil
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).skinThemeList).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).skinThemeList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__OnClickGoodItem = BindCallback(self, self.OnClickGoodItem)
end

UINShopThemeSkinList.ShopCommonInit = function(self, uiShop)
  -- function num : 0_1
  self.uiShop = uiShop
  self.shopCtrl = uiShop.shopCtrl
  self.purchaseRoot = (uiShop.ui).quickPurchaseRoot
  self.resloader = uiShop.resloader
end

UINShopThemeSkinList.RefreshShopNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_2 , upvalues : _ENV
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_2_0 , upvalues : pageId, _ENV, self, autoSelectShelfId
    local shopGoodsDic = shopData:GetCurShopGoods(pageId)
    local shopInTimeDic = {}
    for shelfId,goodsData in pairs(shopGoodsDic) do
      local hasTimeLimit, inTime, startTime, endTime = goodsData:GetStillTime()
      if hasTimeLimit and inTime then
        shopInTimeDic[shelfId] = goodsData
      end
    end
    local topItemIds = shopData:SetResourceDisplay(shopGoodsDic)
    if (self.gameObject).activeInHierarchy then
      (UIUtil.RefreshTopResId)(topItemIds)
    end
    self:RefreshShelfItems(shopInTimeDic, autoSelectShelfId, shopData)
    ;
    (self.uiShop):RefreshHeadBar(shopData)
  end
)
end

UINShopThemeSkinList.RefreshShelfItems = function(self, shopGoodsDic, autoSelectShelfId, shopData)
  -- function num : 0_3 , upvalues : _ENV
  self.dataList = {}
  self.containThemeDic = {}
  for shelfId,goodData in pairs(shopGoodsDic) do
    local skin = (ConfigData.skin)[goodData.itemId]
    local themeData = (ConfigData.skinTheme)[skin.theme]
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R11 in 'UnsetPending'

    if (self.containThemeDic)[themeData] == nil then
      (self.containThemeDic)[themeData] = {}
      ;
      (table.insert)(self.dataList, themeData)
    end
    ;
    (table.insert)((self.containThemeDic)[themeData], goodData.itemId)
  end
  ;
  (table.sort)(self.dataList, function(a, b)
    -- function num : 0_3_0
    do return b.id < a.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local num = #self.dataList
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).skinThemeList).totalCount = num
  ;
  ((self.ui).skinThemeList):RefillCells()
end

UINShopThemeSkinList.OnClickGoodItem = function(self, goodData)
  -- function num : 0_4 , upvalues : _ENV
  if goodData.isSoldOut then
    return 
  end
  local itemCfg = (ConfigData.item)[((self.containThemeDic)[goodData])[1]]
  if itemCfg.type == eItemType.Skin then
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
    -- function num : 0_4_0 , upvalues : self, goodData, _ENV
    if win == nil then
      return 
    end
    local skinId = ((self.containThemeDic)[goodData])[1]
    local skinIds = {}
    for i,v in ipairs((self.containThemeDic)[goodData]) do
      (table.insert)(skinIds, v)
    end
    win:InitSkinBySkinList(skinId, skinIds, nil, function()
      -- function num : 0_4_0_0 , upvalues : _ENV
      local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
      if shopWin ~= nil then
        shopWin:Show()
      end
    end
)
    local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
    if shopWin ~= nil then
      shopWin:Hide()
    end
  end
)
  end
end

UINShopThemeSkinList.__OnNewItem = function(self, go)
  -- function num : 0_5 , upvalues : UINShopThemeSkinItem
  local goodItem = (UINShopThemeSkinItem.New)()
  goodItem:Init(go)
  goodItem:InitItem(self.resloader, self.__OnClickGoodItem)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.ItemDic)[go] = goodItem
end

UINShopThemeSkinList.__OnChangeItem = function(self, go, index)
  -- function num : 0_6 , upvalues : _ENV
  local goodItem = (self.ItemDic)[go]
  if goodItem == nil then
    error("Can\'t find goodItem by gameObject")
    return 
  end
  local goodData = (self.dataList)[index + 1]
  if goodData == nil then
    error("Can\'t find goodData by index, index = " .. tostring(index))
  end
  goodItem:InitNormalGoodsItem(goodData, self, self.purchaseRoot)
end

UINShopThemeSkinList.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINShopThemeSkinList

