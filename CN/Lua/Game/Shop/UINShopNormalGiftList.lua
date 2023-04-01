-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopNormalGiftList = class("UINShopNormalGiftList", UIBaseNode)
local base = UIBaseNode
local UINShopNormalGiftItem = require("Game.Shop.UINShopNormalGiftItem")
local cs_ResLoader = CS.ResLoader
local cs_Canvas = (CS.UnityEngine).Canvas
local cs_MessageCommon = CS.MessageCommon
UINShopNormalGiftList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.itemDic = {}
  self.dataList = {}
  self.__OnPayGiftChange = BindCallback(self, self.OnPayGiftChange)
  MsgCenter:AddListener(eMsgEventId.PayGiftChange, self.__OnPayGiftChange)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).giftBagList).onInstantiateItem = BindCallback(self, self.OnInstantiateItem)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).giftBagList).onChangeItem = BindCallback(self, self.OnChangeItem)
  self.__TimeRefreshView = BindCallback(self, self.TimeRefreshView)
end

UINShopNormalGiftList.OnShow = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.__OnRefreshGiftItemReddot = BindCallback(self, self.OnRefreshGiftItemReddot)
  RedDotController:AddListener(RedDotDynPath.ShopPath, self.__OnRefreshGiftItemReddot)
  self.__InitDataListView = BindCallback(self, self.InitDataListView)
  MsgCenter:AddListener(eMsgEventId.PayGiftItemPreConfition, self.__InitDataListView)
end

UINShopNormalGiftList.ShopCommonInit = function(self, uiShop)
  -- function num : 0_2
  self.uiShop = uiShop
  self.shopCtrl = uiShop.shopCtrl
end

UINShopNormalGiftList.RefreshShopNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_3 , upvalues : _ENV
  if (self.gameObject).activeInHierarchy then
    (UIUtil.RefreshTopResId)({ConstGlobalItem.PaidItem, ConstGlobalItem.PaidSubItem})
  end
  local shopCfg = (ConfigData.shop)[shopId]
  self:InitGiftList(shopCfg, pageId, ((self.uiShop).ui).quickPurchaseRoot, autoSelectShelfId)
  ;
  (self.uiShop):RefreshHeadBar(nil, shopCfg)
end

UINShopNormalGiftList.InitGiftList = function(self, shopCfg, pageId, purchaseRoot, autoSelectShelfId)
  -- function num : 0_4 , upvalues : cs_ResLoader, _ENV
  if self.resloader == nil then
    self.resloader = (cs_ResLoader.Create)()
  end
  self.purchaseRoot = purchaseRoot
  self.shopCfg = shopCfg
  self.pageId = pageId
  self.payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  self:InitDataListView()
  ;
  (self.payGiftCtrl):SetAllNewBeLooked(pageId)
  if autoSelectShelfId == nil then
    return 
  end
  local selectedData = nil
  for i,v in ipairs(self.dataList) do
    if (v.groupCfg).id == autoSelectShelfId then
      selectedData = v
      break
    end
  end
  do
    if selectedData ~= nil then
      local quickBuyWindow = UIManager:GetWindow(UIWindowTypeID.QuickBuy)
      if quickBuyWindow ~= nil and quickBuyWindow.active then
        quickBuyWindow:InitBuyPayGift(selectedData)
      else
        UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
    -- function num : 0_4_0 , upvalues : selectedData
    window:SlideIn()
    window:InitBuyPayGift(selectedData)
  end
)
      end
    end
  end
end

UINShopNormalGiftList.InitDataListView = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.dataList = (self.payGiftCtrl):GetShowPayGiftByPageId(self.pageId)
  if #self.dataList > 0 then
    (table.sort)(self.dataList, function(a, b)
    -- function num : 0_5_0
    if a.needRefresh or b.needRefresh then
      local aSoldOut = a:IsSoldOut()
      local bSoldOut = b:IsSoldOut()
      if aSoldOut ~= bSoldOut then
        return not aSoldOut
      end
    end
    do
      if a.isFree ~= b.isFree then
        return a.isFree
      end
      if a.initPreGroupLine >= b.initPreGroupLine then
        do return a.initPreGroupLine == b.initPreGroupLine end
        do return (a.groupCfg).line < (b.groupCfg).line end
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
)
    self:RefreshPayGiftView()
  else
    ;
    (self.uiShop):InitShop(nil)
  end
end

UINShopNormalGiftList.RefreshPayGiftView = function(self)
  -- function num : 0_6 , upvalues : cs_Canvas
  (cs_Canvas.ForceUpdateCanvases)()
  ;
  ((self.ui).giftBagList):ClearCells()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).giftBagList).totalCount = #self.dataList
  ;
  ((self.ui).giftBagList):RefillCells()
end

UINShopNormalGiftList.OnInstantiateItem = function(self, go)
  -- function num : 0_7 , upvalues : UINShopNormalGiftItem
  local item = (UINShopNormalGiftItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UINShopNormalGiftList.TimeRefreshView = function(self)
  -- function num : 0_8 , upvalues : _ENV, cs_MessageCommon
  self.__lastRefreshTm = self.__lastRefreshTm or 0
  if self.__lastRefreshTm <= PlayerDataCenter.timestamp and PlayerDataCenter.timestamp - self.__lastRefreshTm < 1 then
    return 
  end
  self.__lastRefreshTm = PlayerDataCenter.timestamp
  ;
  (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(331))
  self:InitDataListView()
end

UINShopNormalGiftList.OnChangeItem = function(self, go, index)
  -- function num : 0_9
  local item = (self.itemDic)[go]
  local data = (self.dataList)[index + 1]
  item:InitGiftItem(data, self.purchaseRoot, self.resloader, self.__TimeRefreshView)
  self:RefreshGiftItemReddotByItem(item)
end

UINShopNormalGiftList.OnPayGiftChange = function(self, groupId)
  -- function num : 0_10 , upvalues : _ENV
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  local data = (payGiftCtrl.dataDic)[groupId]
  if data:IsSoldOut() then
    self:InitDataListView()
  else
    for k,v in pairs(self.itemDic) do
      if ((v.data).groupCfg).id == groupId then
        v:RefreshGiftItem()
        self:RefreshGiftItemReddotByItem(v)
        break
      end
    end
  end
end

UINShopNormalGiftList.OnRefreshGiftItemReddot = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, (self.payGiftCtrl).shopId, self.pageId)
  if ok then
    for _,giftItem in pairs(self.itemDic) do
      local childNode = shopNode:GetChild(((giftItem.data).groupCfg).id)
      giftItem:SetGiftItemReddot(childNode ~= nil and childNode:GetRedDotCount() > 0)
    end
  else
    for _,giftItem in pairs(self.itemDic) do
      giftItem:SetGiftItemReddot(false)
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINShopNormalGiftList.RefreshGiftItemReddotByItem = function(self, giftItem)
  -- function num : 0_12 , upvalues : _ENV
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, (self.payGiftCtrl).shopId, self.pageId)
  if ok then
    local childNode = shopNode:GetChild(((giftItem.data).groupCfg).id)
    giftItem:SetGiftItemReddot(childNode ~= nil and childNode:GetRedDotCount() > 0)
  else
    giftItem:SetGiftItemReddot(false)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINShopNormalGiftList.OnHide = function(self)
  -- function num : 0_13 , upvalues : _ENV
  RedDotController:RemoveListener(RedDotDynPath.ShopPath, self.__OnRefreshGiftItemReddot)
  MsgCenter:RemoveListener(eMsgEventId.PayGiftItemPreConfition, self.__InitDataListView)
end

UINShopNormalGiftList.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, base
  for k,v in pairs(self.itemDic) do
    v:Delete()
  end
  MsgCenter:RemoveListener(eMsgEventId.PayGiftChange, self.__OnPayGiftChange)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINShopNormalGiftList

