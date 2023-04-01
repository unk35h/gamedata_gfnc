-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopHeroGoodsList = class("UINShopHeroGoodsList", UIBaseNode)
local base = UIBaseNode
local UINShopHeroGoodsItem = require("Game.Shop.UINShopHeroGoodsItem")
local cs_Canvas = (CS.UnityEngine).Canvas
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopHeroGoodsList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.ItemDic = {}
  self.dataList = {}
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroItemList).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroItemList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._OnItemRefresh = BindCallback(self, self.OnItemRefresh)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemRefresh)
  self._RefreshItemView = BindCallback(self, self.RefreshItemView)
  MsgCenter:AddListener(eMsgEventId.ShopGoodsBuyed, self._RefreshItemView)
  self.__OnTimerRefresh = BindCallback(self, self.OnTimerRefresh)
  self.__OnClickGoodItem = BindCallback(self, self.OnClickGoodItem)
end

UINShopHeroGoodsList.ShopCommonInit = function(self, uiShop)
  -- function num : 0_1
  self.uiShop = uiShop
  self.shopCtrl = uiShop.shopCtrl
  self.purchaseRoot = (uiShop.ui).quickPurchaseRoot
  self.resloader = uiShop.resloader
end

UINShopHeroGoodsList.RefreshShopNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_2 , upvalues : _ENV, ShopEnum
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_2_0 , upvalues : _ENV, self, pageId, autoSelectShelfId, shopId, ShopEnum
    for shelfId,goodsData in pairs(shopData.shopGoodsDic) do
      local hasTimeLimit, inTime, startTime, endTime = goodsData:GetStillTime()
      if hasTimeLimit then
        if inTime then
          (self.uiShop):SetNeedRefreshTm(endTime)
        else
          ;
          (self.uiShop):SetNeedRefreshTm(startTime)
        end
      end
    end
    local shopGoodsDic = shopData:GetCurShopGoods(pageId)
    local topItemIds = shopData:SetResourceDisplay(shopGoodsDic)
    if (self.gameObject).activeInHierarchy then
      (UIUtil.RefreshTopResId)(topItemIds)
    end
    self:RefreshShelfItems(shopGoodsDic, autoSelectShelfId, shopData)
    ;
    (self.uiShop):RefreshHeadBar(shopData)
    if shopId == (ShopEnum.ShopId).skin then
      (self.shopCtrl):SetHaveNewGoodItemInShop(shopData)
    end
  end
)
end

UINShopHeroGoodsList.RefreshShelfItems = function(self, shopGoodsDic, autoSelectShelfId, shopData)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).heroItemList):ClearCells()
  self.dataList = {}
  for shelfId,goodData in pairs(shopGoodsDic) do
    (table.insert)(self.dataList, goodData)
  end
  self.__shopId = 0
  local num = #self.dataList
  if num > 0 then
    self.__shopId = ((self.dataList)[1]).shopId
  end
  ;
  ((self.ui).emptySkin):SetActive(num <= 0)
  self:SortAndSetData()
  ;
  (self.shopCtrl):AddShopTimerCallback(self.__OnTimerRefresh, "HeroGoodsList")
  if autoSelectShelfId == nil then
    return 
  end
  local selecData = nil
  for k,v in pairs(shopGoodsDic) do
    if v.shelfId == autoSelectShelfId then
      selecData = v
      break
    end
  end
  if selecData ~= nil then
    self:OnClickGoodItem(selecData)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINShopHeroGoodsList.OnClickGoodItem = function(self, goodData)
  -- function num : 0_4 , upvalues : _ENV
  if goodData.isSoldOut then
    return 
  end
  local itemCfg = (ConfigData.item)[goodData.itemId]
  if itemCfg.type == eItemType.Skin then
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
    -- function num : 0_4_0 , upvalues : goodData, _ENV, self
    if win == nil then
      return 
    end
    local skinId = goodData.itemId
    local skinIds = {}
    for i,v in ipairs(self.dataList) do
      (table.insert)(skinIds, v.itemId)
    end
    win:InitSkinBySkinList(skinId, skinIds, nil, function()
      -- function num : 0_4_0_0 , upvalues : _ENV, self, goodData
      local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
      if shopWin ~= nil then
        shopWin:Show()
      end
      for k,v in pairs(self.ItemDic) do
        if (v.goodData).itemId == goodData.itemId then
          v:RefreshGoods()
        end
      end
    end
)
    local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
    if shopWin ~= nil then
      shopWin:Hide()
    end
  end
)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
    -- function num : 0_4_1 , upvalues : _ENV, goodData, self
    if win == nil then
      return 
    end
    local resIds = {}
    ;
    (table.insert)(resIds, goodData.currencyId)
    if goodData.currencyId == ConstGlobalItem.PaidSubItem and not (table.contain)(resIds, ConstGlobalItem.PaidItem) then
      (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
    end
    win:SlideIn()
    win:InitBuyTarget(goodData, function()
      -- function num : 0_4_1_0 , upvalues : _ENV, self, goodData
      for k,v in pairs(self.ItemDic) do
        if (v.goodData).itemId == goodData.itemId then
          v:RefreshGoods()
        end
      end
    end
, true, resIds)
    win:OnClickAdd(true)
  end
)
  end
end

UINShopHeroGoodsList.SortAndSetData = function(self)
  -- function num : 0_5 , upvalues : _ENV, cs_Canvas
  (table.sort)(self.dataList, function(a, b)
    -- function num : 0_5_0
    if a.isSoldOut ~= b.isSoldOut then
      return b.isSoldOut
    end
    if b.order >= a.order then
      do return a.order == b.order end
      do return a.shelfId < b.shelfId end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  local num = #self.dataList
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).heroItemList).totalCount = num
  ;
  ((self.ui).heroItemList):RefillCells()
end

UINShopHeroGoodsList.__OnNewItem = function(self, go)
  -- function num : 0_6 , upvalues : UINShopHeroGoodsItem
  local goodItem = (UINShopHeroGoodsItem.New)()
  goodItem:Init(go)
  goodItem:InitItem(self.resloader, self.__OnClickGoodItem)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.ItemDic)[go] = goodItem
end

UINShopHeroGoodsList.__OnChangeItem = function(self, go, index)
  -- function num : 0_7 , upvalues : _ENV
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

UINShopHeroGoodsList.RefreshItemView = function(self, shopId, shelfId)
  -- function num : 0_8
  if self.__shopId ~= shopId then
    return 
  end
  self:SortAndSetData()
end

UINShopHeroGoodsList.m_GetItemGoByIndex = function(self, index)
  -- function num : 0_9
  if (((self.ui).heroItemList).content).childCount <= index then
    return nil
  end
  local go = ((self.ui).heroItemList):GetCellByIndex(index)
  do
    if go ~= nil then
      local goodItem = (self.ItemDic)[go]
      return goodItem
    end
    return nil
  end
end

UINShopHeroGoodsList.OnTimerRefresh = function(self)
  -- function num : 0_10 , upvalues : _ENV
  for go,goodsItem in pairs(self.ItemDic) do
    if go.activeInHierarchy and goodsItem.goodData ~= nil then
      goodsItem:RefreshSkinLeftTime()
    end
  end
end

UINShopHeroGoodsList.OnItemRefresh = function(self, itemUpdate)
  -- function num : 0_11 , upvalues : _ENV
  for index,goodData in ipairs(self.dataList) do
    if itemUpdate[goodData.itemId] ~= nil then
      local item = self:m_GetItemGoByIndex(index - 1)
      if item ~= nil then
        item:RefreshFrgNum()
      end
    end
  end
end

UINShopHeroGoodsList.OnShow = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnShow)(self)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
end

UINShopHeroGoodsList.OnHide = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnHide)(self)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
end

UINShopHeroGoodsList.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemRefresh)
  MsgCenter:RemoveListener(eMsgEventId.ShopGoodsBuyed, self._RefreshItemView)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
  ;
  (base.OnDelete)(self)
end

return UINShopHeroGoodsList

