-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopNormalGoodsList = class("UINShopNormalGoodsList", UIBaseNode)
local base = UIBaseNode
local UINShopNormalGoogsItem = require("Game.Shop.UINShopNormalGoogsItem")
local cs_Canvas = (CS.UnityEngine).Canvas
local ShopUtil = require("Game.Shop.ShopUtil")
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopNormalGoodsList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.ItemDic = {}
  self.dataList = {}
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).goodListNode).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).goodListNode).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._OnItemRefresh = BindCallback(self, self.OnItemRefresh)
  self._RefreshItemView = BindCallback(self, self.RefreshItemView)
  self._ResortShelfItems = BindCallback(self, self.ResortShelfItems)
  self.__OnNormalTimerRefresh = BindCallback(self, self.OnNormalTimerRefresh)
end

UINShopNormalGoodsList.OnShow = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemRefresh)
  MsgCenter:AddListener(eMsgEventId.ShopGoodsBuyed, self._RefreshItemView)
  ;
  (base.OnShow)(self)
end

UINShopNormalGoodsList.ShopCommonInit = function(self, uiShop)
  -- function num : 0_2
  self.uiShop = uiShop
  self.shopCtrl = uiShop.shopCtrl
end

UINShopNormalGoodsList.RefreshShopNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_3 , upvalues : _ENV
  self.__shopId = shopId
  self.__pageId = pageId
  ;
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_3_0 , upvalues : pageId, _ENV, self, autoSelectShelfId, shopId
    local shopGoodsDic = shopData:GetCurShopGoods(pageId)
    for shelfId,goodsData in pairs(shopGoodsDic) do
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
    local topItemIds = shopData:SetResourceDisplay(shopGoodsDic)
    if (self.gameObject).activeInHierarchy then
      (UIUtil.RefreshTopResId)(topItemIds)
    end
    self:RefreshShelfItems(shopGoodsDic, ((self.uiShop).ui).quickPurchaseRoot, shopData, autoSelectShelfId)
    ;
    (self.uiShop):RefreshHeadBar(shopData)
    ;
    (self.shopCtrl):AddShopTimerCallback(self.__OnNormalTimerRefresh, "NormalGoodsList" .. tostring(shopId))
  end
)
end

UINShopNormalGoodsList.RefreshShelfItems = function(self, shopGoodsDic, purchaseRoot, shopData, autoSelectShelfId)
  -- function num : 0_4 , upvalues : _ENV, ShopUtil, cs_Canvas
  self.purchaseRoot = purchaseRoot
  self.dataList = {}
  for shelfId,goodData in pairs(shopGoodsDic) do
    (table.insert)(self.dataList, goodData)
  end
  self._isFreshShop = (shopData.shopCfg).isRefreshShop
  ;
  (ShopUtil.CommonAndFragSrotGoodList)(self.dataList, self._isFreshShop)
  local num = #self.dataList
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).goodListNode).totalCount = num
  ;
  ((self.ui).goodListNode):RefillCells()
  if autoSelectShelfId == nil then
    return 
  end
  local goodsData = nil
  for k,v in pairs(shopGoodsDic) do
    if v.shelfId == autoSelectShelfId then
      goodsData = v
    end
  end
  if goodsData ~= nil then
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
    -- function num : 0_4_0 , upvalues : _ENV, goodsData, self
    if win == nil then
      error("can\'t open QuickBuy win")
      return 
    end
    local resIds = {}
    ;
    (table.insert)(resIds, goodsData.currencyId)
    if goodsData.currencyId == ConstGlobalItem.PaidSubItem and not (table.contain)(resIds, ConstGlobalItem.PaidItem) then
      (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
    end
    win:SlideIn()
    win:InitBuyTarget(goodsData, function()
      -- function num : 0_4_0_0 , upvalues : _ENV, self, goodsData
      for k,v in pairs(self.ItemDic) do
        if v.goodData == goodsData then
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

UINShopNormalGoodsList.ResortShelfItems = function(self)
  -- function num : 0_5 , upvalues : ShopUtil, cs_Canvas
  (ShopUtil.CommonAndFragSrotGoodList)(self.dataList, self._isFreshShop)
  local num = #self.dataList
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).goodListNode).totalCount = num
  ;
  ((self.ui).goodListNode):RefillCells()
end

UINShopNormalGoodsList.__OnNewItem = function(self, go)
  -- function num : 0_6 , upvalues : UINShopNormalGoogsItem
  local goodItem = (UINShopNormalGoogsItem.New)()
  goodItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.ItemDic)[go] = goodItem
  goodItem:BindNorShopAllRefreshCallback(self._ResortShelfItems)
end

UINShopNormalGoodsList.__OnChangeItem = function(self, go, index)
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
  goodItem:InitNormalGoodsItem(goodData, self.purchaseRoot)
end

UINShopNormalGoodsList.m_GetItemGoByIndex = function(self, index)
  -- function num : 0_8
  if (((self.ui).goodListNode).content).childCount <= index then
    return nil
  end
  local go = ((self.ui).goodListNode):GetCellByIndex(index)
  do
    if go ~= nil then
      local goodItem = (self.ItemDic)[go]
      return goodItem
    end
    return nil
  end
end

UINShopNormalGoodsList.RefreshItemView = function(self, shopId, shelfId)
  -- function num : 0_9 , upvalues : ShopEnum, _ENV
  if self.__shopId ~= (ShopEnum.ShopId).hero or self.__shopId ~= shopId then
    return 
  end
  for index,goodData in ipairs(self.dataList) do
    if goodData.shelfId == shelfId then
      goodData:RefreshDataWithSeverMsg()
      local item = self:m_GetItemGoByIndex(index - 1)
      if item ~= nil then
        item:RefreshGoods()
      end
    end
  end
end

UINShopNormalGoodsList.OnItemRefresh = function(self, itemUpdate)
  -- function num : 0_10 , upvalues : ShopEnum, _ENV
  if self.__shopId ~= (ShopEnum.ShopId).hero then
    return 
  end
  for index,goodData in ipairs(self.dataList) do
    if itemUpdate[goodData.itemId] ~= nil then
      goodData:RefreshDataWithSeverMsg()
      local item = self:m_GetItemGoByIndex(index - 1)
      if item ~= nil then
        item:RefreshGoods()
      end
    end
  end
end

UINShopNormalGoodsList.OnNormalTimerRefresh = function(self)
  -- function num : 0_11 , upvalues : ShopEnum, _ENV
  if self.__shopId == (ShopEnum.ShopId).photoCommemorate then
    for index,goodData in ipairs(self.dataList) do
      local item = self:m_GetItemGoByIndex(index - 1)
      if item ~= nil then
        item:RefreshLeftSellTime()
      end
    end
  end
end

UINShopNormalGoodsList.OnHide = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemRefresh)
  MsgCenter:RemoveListener(eMsgEventId.ShopGoodsBuyed, self._RefreshItemView)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnNormalTimerRefresh)
  ;
  (base.OnHide)(self)
end

UINShopNormalGoodsList.OnDelete = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnDelete)(self)
end

return UINShopNormalGoodsList

