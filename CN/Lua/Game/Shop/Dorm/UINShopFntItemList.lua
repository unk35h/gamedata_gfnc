-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopFntItemList = {}
local UINShopFntItemList = class("UINShopFntItemList", UIBaseNode)
local base = UIBaseNode
local UINShopFntItem = require("Game.Shop.Dorm.UINShopFntItem")
local cs_Canvas = (CS.UnityEngine).Canvas
local ShopUtil = require("Game.Shop.ShopUtil")
local ShopEnum = require("Game.Shop.ShopEnum")
local fntNormalItem = require("Game.Shop.Dorm.UINShopFntNormalItem")
local fntEmptyItem = require("Game.Shop.Dorm.UINShopFntEmptyItem")
local fntTitleItem = require("Game.Shop.Dorm.UINShopFntTitleItem")
UINShopFntItemList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, fntNormalItem, fntEmptyItem, fntTitleItem
  self.ItemDic = {}
  self.dataList = {}
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.fntNormalItemPool = (UIItemPool.New)(fntNormalItem, (self.ui).obj_shopFurnitureItem)
  self.fntEmptyItemPool = (UIItemPool.New)(fntEmptyItem, (self.ui).obj_emptyFurnitureItem)
  self.fntTitleItemPool = (UIItemPool.New)(fntTitleItem, (self.ui).obj_furnitureThemeItem)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fntListNode).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fntListNode).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fntListNode).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self.__SortAndRefreshFntData = BindCallback(self, self.SortAndRefreshFntData)
  self.__OnFntTimerRefresh = BindCallback(self, self.OnFntTimerRefresh)
  self.__OnBuyFntSuitRefresh = BindCallback(self, self.RereshFntShopNodeData)
  MsgCenter:AddListener(eMsgEventId.ShopSuitGoodsBuyed, self.__OnBuyFntSuitRefresh)
end

UINShopFntItemList.ShopCommonInit = function(self, uiShop)
  -- function num : 0_1
  self.uiShop = uiShop
  self.shopCtrl = uiShop.shopCtrl
end

UINShopFntItemList.RefreshShopNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_2 , upvalues : _ENV
  self.shopId = shopId
  self.pageId = pageId
  self.needFresh = true
  self.autoSelectShelfId = autoSelectShelfId
  ;
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_2_0 , upvalues : pageId, _ENV, self, autoSelectShelfId
    local shopGoodsDic = shopData:GetCurShopGoods(pageId)
    local topItemIds = shopData:SetResourceDisplay(shopGoodsDic)
    ;
    (UIUtil.RefreshTopResId)(topItemIds, self:GetDormCoinQuickBuyFunc())
    self:RefreshShopFntItems(shopGoodsDic, ((self.uiShop).ui).quickPurchaseRoot, autoSelectShelfId, shopData)
    ;
    (self.uiShop):RefreshHeadBar(shopData)
  end
)
  self.suitsOtherList = self:GetFurnitureSuits()
end

UINShopFntItemList.RereshFntShopNodeData = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.needFresh = true
  ;
  (self.shopCtrl):GetShopData(self.shopId, function(shopData)
    -- function num : 0_3_0 , upvalues : self, _ENV
    local shopGoodsDic = shopData:GetCurShopGoods(self.pageId)
    local topItemIds = shopData:SetResourceDisplay(shopGoodsDic)
    ;
    (UIUtil.RefreshTopResId)(topItemIds, self:GetDormCoinQuickBuyFunc())
    self:RefreshShopFntItems(shopGoodsDic, ((self.uiShop).ui).quickPurchaseRoot, self.autoSelectShelfId, shopData)
    ;
    (self.uiShop):RefreshHeadBar(shopData)
  end
)
end

UINShopFntItemList.GetFurnitureSuits = function(self)
  -- function num : 0_4 , upvalues : ShopEnum
  if self.shopId == (ShopEnum.ShopId).dormFnt then
    return (ShopEnum.FurnitureSuits).defaultSuits
  else
    return (ShopEnum.FurnitureSuits).actSuits
  end
end

UINShopFntItemList.RefreshShopFntItems = function(self, shopGoodsDic, purchaseRoot, autoSelectShelfId, shopData)
  -- function num : 0_5 , upvalues : _ENV, ShopEnum, ShopUtil
  self.purchaseRoot = purchaseRoot
  self.shopData = shopData
  self.shopGoodsDic = shopGoodsDic
  self.dataList = {}
  for shelfId,goodData in pairs(shopGoodsDic) do
    goodData.type = (ShopEnum.eFurnitureItemType).normal
    ;
    (table.insert)(self.dataList, goodData)
  end
  self.dataBeginIndex = 1
  self.dataEndIndex = #shopGoodsDic
  ;
  (ShopUtil.CommonSortGoodList)(self.dataList)
  self:SortAndRefreshFntData(true)
  if (self.shopCtrl):GetIsThisShopHasTimeLimit((self.shopData).shopId) then
    (self.shopCtrl):AddShopTimerCallback(self.__OnFntTimerRefresh, "FntItemList")
  end
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
    -- function num : 0_5_0 , upvalues : _ENV, goodsData, self
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
      -- function num : 0_5_0_0 , upvalues : self
      self:SortAndRefreshFntData()
    end
, true, resIds)
    win:OnClickAdd(true)
  end
)
  end
end

UINShopFntItemList.QSortFntData = function(self, dataList, left, right)
  -- function num : 0_6
  if left < right then
    local pivot = self:Partition(dataList, left, right)
    self:QSortFntData(dataList, left, pivot - 1)
    self:QSortFntData(dataList, pivot + 1, right)
  end
end

UINShopFntItemList.SwapFnt = function(dataList, i, j)
  -- function num : 0_7
  local temp = dataList[j]
  dataList[j] = dataList[i]
  dataList[i] = temp
end

UINShopFntItemList.Partition = function(self, dataList, left, right)
  -- function num : 0_8 , upvalues : _ENV
  local m = left + (math.floor)((right - left) / 2)
  ;
  (self.SwapFnt)(dataList, m, left)
  local pivotKey = dataList[left]
  while 1 do
    while 1 do
      if left < right then
        if left < right and self:CompareFunc(pivotKey, dataList[right]) then
          right = right - 1
          -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    ;
    (self.SwapFnt)(dataList, right, left)
    while left < right and self:CompareFunc(dataList[left], pivotKey) do
      left = left + 1
    end
    ;
    (self.SwapFnt)(dataList, right, left)
  end
  return left
end

UINShopFntItemList.CompareFunc = function(self, a, b)
  -- function num : 0_9
  if a.isSoldOut ~= b.isSoldOut then
    return b.isSoldOut
  end
  if a.order >= b.order then
    do return a.order == b.order end
    do return a.shelfId <= b.shelfId end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINShopFntItemList.SortAndRefreshFntData = function(self, isInit)
  -- function num : 0_10 , upvalues : cs_Canvas
  self:QSortFntData(self.dataList, self.dataBeginIndex, self.dataEndIndex)
  if isInit then
    self:ReplenishFntItemList()
  end
  if self.needFresh then
    ((self.ui).fntListNode):ClearCells()
  end
  local num = #self.dataList
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  if self.ui == nil then
    return 
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fntListNode).totalCount = num
  if self.needFresh or isInit then
    ((self.ui).fntListNode):RefillCells()
  else
    ;
    ((self.ui).fntListNode):RefreshCells()
  end
  self.needFresh = false
end

UINShopFntItemList.ReplenishFntItemList = function(self)
  -- function num : 0_11 , upvalues : _ENV, ShopEnum
  for i,v in ipairs((self.suitsOtherList).forward) do
    if v == (ShopEnum.eFurnitureItemType).title then
      (table.insert)(self.dataList, 1, self:__CreatTitleItem())
    else
      ;
      (table.insert)(self.dataList, 1, self:__CreatEmptyItem())
    end
  end
  self.dataBeginIndex = #(self.suitsOtherList).forward + 1
  for i,v in ipairs((self.suitsOtherList).back) do
    if v == (ShopEnum.eFurnitureItemType).title then
      (table.insert)(self.dataList, self:__CreatTitleItem())
    else
      ;
      (table.insert)(self.dataList, self:__CreatEmptyItem())
    end
  end
  self.dataEndIndex = #self.dataList - #(self.suitsOtherList).back
end

UINShopFntItemList.__CreatEmptyItem = function(self)
  -- function num : 0_12 , upvalues : ShopEnum
  return {type = (ShopEnum.eFurnitureItemType).empty}
end

UINShopFntItemList.__CreatTitleItem = function(self)
  -- function num : 0_13 , upvalues : ShopEnum
  local item = {}
  item.type = (ShopEnum.eFurnitureItemType).title
  item.shopId = self.shopId
  item.shopGoodsDic = self.shopGoodsDic
  return item
end

UINShopFntItemList.__OnNewItem = function(self, go)
  -- function num : 0_14 , upvalues : UINShopFntItem
  local goodItem = (UINShopFntItem.New)()
  goodItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.ItemDic)[go] = goodItem
end

UINShopFntItemList.__OnChangeItem = function(self, go, index)
  -- function num : 0_15 , upvalues : _ENV, ShopEnum
  local goodItem = (self.ItemDic)[go]
  if goodItem == nil then
    error("Can\'t find goodItem by gameObject")
    return 
  end
  self:ReturnItem(goodItem)
  local goodData = (self.dataList)[index + 1]
  if goodData == nil then
    error("Can\'t find goodData by index, index = " .. tostring(index))
  end
  local baseObj = nil
  if goodData.type == (ShopEnum.eFurnitureItemType).normal then
    baseObj = (self.fntNormalItemPool):GetOne(true)
  else
    if goodData.type == (ShopEnum.eFurnitureItemType).empty then
      baseObj = (self.fntEmptyItemPool):GetOne(true)
    else
      baseObj = (self.fntTitleItemPool):GetOne(true)
    end
  end
  goodItem:InitNormalGoodsItem(goodData, self.purchaseRoot, self.__SortAndRefreshFntData, baseObj)
end

UINShopFntItemList.__OnReturnItem = function(self, go)
  -- function num : 0_16 , upvalues : _ENV
  local goodItem = (self.ItemDic)[go]
  if goodItem == nil then
    error("Can\'t find goodItem by gameObject")
    return 
  end
  self:ReturnItem(goodItem)
end

UINShopFntItemList.ReturnItem = function(self, goodItem)
  -- function num : 0_17 , upvalues : ShopEnum
  local goodData = goodItem.goodData
  local baseObj = goodItem.baseObj
  if baseObj == nil then
    return 
  end
  ;
  (baseObj.transform):SetParent(self.transform, false)
  if goodData.type == (ShopEnum.eFurnitureItemType).normal then
    (self.fntNormalItemPool):HideOne(baseObj)
  else
    if goodData.type == (ShopEnum.eFurnitureItemType).empty then
      (self.fntEmptyItemPool):HideOne(baseObj)
    else
      ;
      (self.fntTitleItemPool):HideOne(baseObj)
    end
  end
  goodItem.baseObj = nil
end

UINShopFntItemList.GetDormCoinQuickBuyFunc = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.__quickCoinBuyFunc ~= nil then
    return self.__quickCoinBuyFunc
  end
  self.__quickCoinBuyFunc = {[ConstGlobalItem.DormCoin] = function()
    -- function num : 0_18_0 , upvalues : _ENV
    local ShopEnum = require("Game.Shop.ShopEnum")
    local quickBuyData = (ShopEnum.eQuickBuy).dormCoin
    local shopId = quickBuyData.shopId
    local shelfId = quickBuyData.shelfId
    local goodData = nil
    local ctrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
    ctrl:GetShopData(shopId, function(shopData)
      -- function num : 0_18_0_0 , upvalues : goodData, shelfId, _ENV, quickBuyData
      goodData = (shopData.shopGoodsDic)[shelfId]
      UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
        -- function num : 0_18_0_0_0 , upvalues : _ENV, goodData, quickBuyData
        if win == nil then
          error("can\'t open QuickBuy win")
          return 
        end
        win:SlideIn()
        win:InitBuyTarget(goodData, nil, true, quickBuyData.resourceIds)
        win:OnClickAdd(true)
      end
)
    end
)
  end
}
  return self.__quickCoinBuyFunc
end

UINShopFntItemList.OnFntTimerRefresh = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local isNeedRefresh = nil
  for go,goodItem in pairs(self.ItemDic) do
  end
  if (go.activeInHierarchy and goodItem:RefreshLeftSellTime()) or isNeedRefresh then
    (self.uiShop):InitShop(self.shopId)
  end
end

UINShopFntItemList.OnHide = function(self)
  -- function num : 0_20 , upvalues : base
  (base.OnHide)(self)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnFntTimerRefresh)
end

UINShopFntItemList.OnDelete = function(self)
  -- function num : 0_21 , upvalues : _ENV, base
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnFntTimerRefresh)
  MsgCenter:RemoveListener(eMsgEventId.ShopSuitGoodsBuyed, self.__OnBuyFntSuitRefresh)
  ;
  (self.fntTitleItemPool):DeleteAll()
  ;
  (self.fntEmptyItemPool):DeleteAll()
  ;
  (self.fntTitleItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINShopFntItemList

