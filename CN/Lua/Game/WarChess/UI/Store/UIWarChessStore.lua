-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessStore = class("UIWarChessStore", base)
local UINWarChessStoreSellList = require("Game.WarChess.UI.Store.UINWarChessSellList")
local UINWarChessStoreBuyList = require("Game.WarChess.UI.Store.UINWarChessBuyList")
local UINWarChessExchangeList = require("Game.WarChess.UI.Store.UINWarChessExchangeList")
local UINWarChessBuffDetail = require("Game.WarChess.UI.Store.UINWarChessBuffDetail")
local UINChipDetailPanel = require("Game.CommonUI.Chip.UINEpChipDetail")
local UINWarChessCoinDetail = require("Game.WarChess.UI.Store.UINWarChessCoinDetail")
local StoreType = {eBuy = 1, eSell = 2, eExchange = 3}
UIWarChessStore.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChipDetailPanel, UINWarChessBuffDetail, UINWarChessCoinDetail, UINWarChessStoreBuyList, UINWarChessStoreSellList, UINWarChessExchangeList
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self.OnClicWCSkLeave)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BuffBuy, self, self.OnStoreBuyBuffClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CoinBuy, self, self.OnStoreBuyCoinClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BuyTypeItem, self, self.LoadStoreData)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SellTypeItem, self, self.LoadChipOwnData)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ExchangeTypeItem, self, self.LoadExchangeData)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnBtnEpStoreRefresh)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnClickShowMap)
  self.__onCoinNumChange = BindCallback(self, self.OnCoinNumChange)
  MsgCenter:AddListener(eMsgEventId.WC_CoinNumChange, self.__onCoinNumChange)
  self.resloader = ((CS.ResLoader).Create)()
  self._onStoreSellClicked = BindCallback(self, self.OnStoreSellClicked)
  self._onBuyChipBuyEvent = BindCallback(self, self.OnStoreBuyClicked)
  self._onBuyChipReturnEvent = BindCallback(self, self.OnBuyChipLevel)
  self.chipDetailPanel = (UINChipDetailPanel.New)()
  ;
  (self.chipDetailPanel):Init((self.ui).chipItemDetail)
  self.epBuffDetail = (UINWarChessBuffDetail.New)()
  ;
  (self.epBuffDetail):Init((self.ui).uINBuffDetail)
  self.epCoinDetail = (UINWarChessCoinDetail.New)()
  ;
  (self.epCoinDetail):Init((self.ui).uINCoinDetail)
  self.buyListNode = (UINWarChessStoreBuyList.New)(self)
  ;
  (self.buyListNode):Init((self.ui).buyList)
  self.sellListNode = (UINWarChessStoreSellList.New)(self)
  ;
  (self.sellListNode):Init((self.ui).sellList)
  self.exchangeListNode = (UINWarChessExchangeList.New)(self)
  ;
  (self.exchangeListNode):Init((self.ui).exchangeList)
end

UIWarChessStore.LoadStoreData = function(self)
  -- function num : 0_1 , upvalues : StoreType
  self:SwitchStoreTypeUI(StoreType.eBuy)
  ;
  (self.buyListNode):InitWarchessStoreRoomBuyList(self.storeChipDataList)
end

UIWarChessStore.LoadChipOwnData = function(self)
  -- function num : 0_2 , upvalues : StoreType
  self:SwitchStoreTypeUI(StoreType.eSell)
  local teamDic = (((self.storeCtrl).wcCtrl).teamCtrl):GetWCTeams()
  ;
  (self.sellListNode):InitWarChessStoreRoomSell(teamDic)
end

UIWarChessStore.OnCoinNumChange = function(self, itemId, num)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if itemId == ConstGlobalItem.WCMoney then
    ((self.ui).tex_TopCoinNum).text = tostring(num)
    self:RefreshBuyRefreshBtn()
  else
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_TopRareNum).text = tostring(num)
  end
end

UIWarChessStore.LoadExchangeData = function(self)
  -- function num : 0_4 , upvalues : StoreType
  self:SwitchStoreTypeUI(StoreType.eExchange)
  ;
  (self.exchangeListNode):InitExchangeList(self.storeBuffDataList)
end

UIWarChessStore.SwitchRoomMapBtnState = function(self, openMap)
  -- function num : 0_5
  if openMap then
    ((self.ui).tex_MapBtnName):SetIndex(1)
  else
    ;
    ((self.ui).tex_MapBtnName):SetIndex(0)
  end
end

UIWarChessStore.SwitchStoreTypeUI = function(self, storeType)
  -- function num : 0_6 , upvalues : StoreType, _ENV
  self.storeType = storeType
  ;
  (self.epCoinDetail):Hide()
  ;
  (self.epBuffDetail):Hide()
  ;
  (self.chipDetailPanel):Hide()
  if self.storeType == StoreType.eBuy then
    ((self.ui).buyTypeImg):SetIndex(0)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).buyTypeText).color = Color.black
    ;
    ((self.ui).sellTypeImg):SetIndex(1)
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).sellTypeText).color = Color.white
    ;
    ((self.ui).exchangeTypeImg):SetIndex(1)
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).exchangeTypeText).color = Color.white
    ;
    (self.buyListNode):Show()
    ;
    (self.sellListNode):Hide()
    ;
    (self.exchangeListNode):Hide()
    self:RefreshBuyRefreshBtn()
  else
    if self.storeType == StoreType.eSell then
      ((self.ui).sellTypeImg):SetIndex(0)
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).sellTypeText).color = Color.black
      ;
      ((self.ui).buyTypeImg):SetIndex(1)
      -- DECOMPILER ERROR at PC79: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).buyTypeText).color = Color.white
      ;
      ((self.ui).exchangeTypeImg):SetIndex(1)
      -- DECOMPILER ERROR at PC89: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).exchangeTypeText).color = Color.white
      ;
      (self.exchangeListNode):Hide()
      ;
      (self.buyListNode):Hide()
      ;
      (self.sellListNode):Show()
    else
      if self.storeType == StoreType.eExchange then
        ((self.ui).exchangeTypeImg):SetIndex(0)
        -- DECOMPILER ERROR at PC113: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.ui).exchangeTypeText).color = Color.black
        ;
        ((self.ui).buyTypeImg):SetIndex(1)
        -- DECOMPILER ERROR at PC123: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.ui).buyTypeText).color = Color.white
        ;
        ((self.ui).sellTypeImg):SetIndex(1)
        -- DECOMPILER ERROR at PC133: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.ui).sellTypeText).color = Color.white
        ;
        (self.buyListNode):Hide()
        ;
        (self.sellListNode):Hide()
        ;
        (self.exchangeListNode):Show()
      end
    end
  end
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(self.storeType == StoreType.eBuy or self.storeType == StoreType.eExchange)
  self:__ShowDetailSellOutUI(false)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWarChessStore.SetDiscountUIActive = function(self, active)
  -- function num : 0_7
  (((((self.ui).tex_Discount).transform).parent).gameObject):SetActive(active)
end

UIWarChessStore.OnSelectStoreBuffItem = function(self, buffItem)
  -- function num : 0_8
  buffItem:SetStoreBuffItemSelect(true)
  self:RefreshBuffDetail((buffItem.epStoreItemData).idx, buffItem.price)
end

UIWarChessStore.OnSelectStoreCoinItem = function(self, coinItem)
  -- function num : 0_9
  coinItem:SetStoreCoinItemSelect(true)
  self:RefreshCoinDetail(coinItem)
end

UIWarChessStore.InitWCChipStore = function(self, storeCtrl)
  -- function num : 0_10 , upvalues : _ENV
  self.storeCtrl = storeCtrl
  self.storeChipDataList = (self.storeCtrl):GetWCChipDataList()
  self.storeBuffDataList = (self.storeCtrl):GetWCBuffDataList()
  self.CoinIconId = (self.storeCtrl):GetWCCoinItemIconId()
  self.RareIconId = (self.storeCtrl):GetWCRareItemIconId()
  self:LoadStoreData()
  self:SwitchRoomMapBtnState(false)
  self:SetDiscountUIActive(false)
  self:OnCoinNumChange(ConstGlobalItem.WCMoney, (((self.storeCtrl).wcCtrl).backPackCtrl):GetWCCoinNum())
  self:OnCoinNumChange(ConstGlobalItem.WCDeployPoint, (((self.storeCtrl).wcCtrl).backPackCtrl):GetWCDeployPointNum())
end

UIWarChessStore.__SetBuffLackState = function(self, isLack)
  -- function num : 0_11
  ;
  ((self.ui).tex_BuffBuy):SetIndex(isLack and 1 or 0)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).btn_BuffBuy).interactable = not isLack
end

UIWarChessStore.__SetCoinLackState = function(self, isLack, isWCPoint)
  -- function num : 0_12
  if not isWCPoint or not 1 then
    ((self.ui).tex_CoinBuy):SetIndex(not isLack or 2)
    ;
    ((self.ui).tex_CoinBuy):SetIndex(0)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).btn_CoinBuy).interactable = not isLack
  end
end

UIWarChessStore.__ShowDetailSellOutUI = function(self, active)
  -- function num : 0_13 , upvalues : _ENV
  if active ~= true then
    ((self.ui).obj_IsSellout):SetActive(IsNull((self.ui).obj_IsSellout))
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIWarChessStore.__SetSellOutParent = function(self, parent)
  -- function num : 0_14 , upvalues : _ENV
  if not IsNull((self.ui).obj_IsSellout) then
    local trans = ((self.ui).obj_IsSellout).transform
    trans:SetParent(parent)
    trans.localPosition = Vector3.zero
    trans:SetAsLastSibling()
  end
end

UIWarChessStore.RefreshBuffDetail = function(self, index, price)
  -- function num : 0_15 , upvalues : _ENV
  (self.epBuffDetail):Show()
  ;
  (self.epCoinDetail):Hide()
  local storeData = (self.storeBuffDataList)[index]
  ;
  (self.epBuffDetail):InitEpBuffDetail(storeData.epBuffData)
  self:__SetSellOutParent((self.epBuffDetail).transform)
  local currMoney = (self.storeCtrl):GetWCRareItemNum()
  local isCanBuy = not storeData.saled
  ;
  (((self.ui).btn_BuffBuy).gameObject):SetActive(isCanBuy)
  self:__ShowDetailSellOutUI(not isCanBuy)
  if isCanBuy then
    local buyPrice = price
    local isLack = isCanBuy == true and currMoney < buyPrice and buyPrice > 0
    self:__SetBuffLackState(isLack)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_BuffMoney).sprite = CRH:GetSprite((self.storeCtrl):GetWCRareItemIconId())
    ;
    ((self.ui).tex_BuffMoney):SetIndex(1, tostring(buyPrice))
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWarChessStore.RefreshCoinDetail = function(self, coinItem)
  -- function num : 0_16 , upvalues : _ENV
  (self.epBuffDetail):Hide()
  ;
  (self.epCoinDetail):Show()
  ;
  (self.epCoinDetail):InitCoinDetail(coinItem.itemCfg)
  self:__SetSellOutParent((self.epCoinDetail).transform)
  local currMoney = 0
  local isCanBuy = false
  local isWCPoint = false
  if (coinItem.itemCfg).id == ConstGlobalItem.WCMoney then
    currMoney = (self.storeCtrl):GetWCRareItemNum()
    isCanBuy = not (self.storeCtrl):GetCoinExchangeIsUse()
    isWCPoint = false
  else
    if (coinItem.itemCfg).id == ConstGlobalItem.WCDeployPoint then
      currMoney = (self.storeCtrl):GetWCCoinItemNum()
      isCanBuy = not (self.storeCtrl):GetRareExchangeIsUse()
      isWCPoint = true
    end
  end
  ;
  (((self.ui).btn_CoinBuy).gameObject):SetActive(isCanBuy)
  self:__ShowDetailSellOutUI(not isCanBuy)
  if isCanBuy then
    local buyPrice = coinItem.buyPrice
    local isLack = isCanBuy == true and currMoney < buyPrice and buyPrice > 0
    self:__SetCoinLackState(isLack, isWCPoint)
    -- DECOMPILER ERROR at PC78: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_CoinMoney).sprite = CRH:GetSprite(coinItem.MoneyIconId)
    ;
    ((self.ui).tex_CoinMoney):SetIndex(1, tostring(buyPrice))
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWarChessStore.RefreshBuyRefreshBtn = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local refreshCostNum = (self.storeCtrl):GetWarChessStoreRefreshPrice()
  local isLack = false
  local currMoney = (self.storeCtrl):GetWCCoinItemNum()
  if refreshCostNum > 0 and currMoney < refreshCostNum then
    isLack = true
  end
  ;
  ((self.ui).tex_Refresh):SetIndex(isLack and 1 or 0)
  ;
  ((self.ui).obj_RefreshLack):SetActive(isLack)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_RefreshPay).text = tostring(refreshCostNum)
end

UIWarChessStore.RefreshSelectItemDetailSoldOut = function(self, teamData, chipData)
  -- function num : 0_18 , upvalues : _ENV
  if chipData == nil then
    (((self.ui).btn_BuffBuy).gameObject):SetActive(false)
    ;
    (self.chipDetailPanel):Hide()
    return 
  end
  ;
  (((self.ui).btn_BuffBuy).gameObject):SetActive(true)
  ;
  (self.chipDetailPanel):Show()
  ;
  (self.chipDetailPanel):InitEpChipDetail(nil, chipData, teamData:GetTeamDynPlayer(), self.resloader, true, eChipDetailPowerType.Subtract, true)
  ;
  (self.chipDetailPanel):ShowHeroHeadOrTacticActive(true)
  ;
  (self.chipDetailPanel):ShowEpChipDetailEff(5)
  ;
  (self.chipDetailPanel):SetObjNewTagActive(false)
  local buyPrice = chipData:GetChipBuyPriceForWarChess()
  local salePrice = chipData:GetChipSellPriceForWarChess()
  ;
  ((self.chipDetailPanel):GetDetailButtonGroup()):InitBtnSelByCost(false, salePrice, self._onStoreSellClicked)
  self:__SetBuffLackState(false)
end

UIWarChessStore.__IsFullActiveAlgCount = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local count = (BattleUtil.GetConsumeChipLimit)()
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer == nil then
    return false
  end
  for _,chipData in pairs(dynPlayer:GetNormalChipDic()) do
    if chipData:IsConsumeSkillChip() then
      count = count - 1
      if count == 0 then
        return true
      end
    end
  end
  return false
end

UIWarChessStore.OnBtnEpStoreRefresh = function(self)
  -- function num : 0_20 , upvalues : StoreType
  if ((self.ui).obj_RefreshLack).activeSelf then
    return 
  end
  local refreshCostNum = (self.storeCtrl):GetWarChessStoreRefreshPrice()
  local currMoney = (self.storeCtrl):GetWCCoinItemNum()
  if refreshCostNum > 0 and currMoney < refreshCostNum then
    return 
  end
  ;
  (self.storeCtrl):WCRefresh(function()
    -- function num : 0_20_0 , upvalues : self, StoreType
    self:RefreshBuyRefreshBtn()
    if self.storeType == StoreType.eBuy then
      self.storeChipDataList = (self.storeCtrl):GetWCChipDataList()
      self.storeBuffDataList = (self.storeCtrl):GetWCBuffDataList()
      self:LoadStoreData()
    else
      if self.storeType == StoreType.eExchange then
        self.storeChipDataList = (self.storeCtrl):GetWCChipDataList()
        self.storeBuffDataList = (self.storeCtrl):GetWCBuffDataList()
        self:LoadExchangeData()
      end
    end
  end
)
end

UIWarChessStore.OnClickShowMap = function(self)
  -- function num : 0_21
  local isOpen = ((self.ui).frameNode).activeInHierarchy
  ;
  ((self.ui).tex_MapBtnName):SetIndex(isOpen and 1 or 0)
  ;
  ((self.ui).frameNode):SetActive(not isOpen)
end

UIWarChessStore.OnStoreBuyBuffClicked = function(self)
  -- function num : 0_22
  local index, price, item = (self.exchangeListNode):GetEpStoreBuyData()
  local storeData = (self.storeBuffDataList)[index]
  if storeData == nil or storeData.saled then
    return 
  end
  ;
  (self.storeCtrl):WCBuyBuff(storeData, function()
    -- function num : 0_22_0 , upvalues : item, self, index, price
    item:UpdateSellOutActive()
    self:RefreshBuffDetail(index, price)
  end
)
end

UIWarChessStore.OnStoreBuyCoinClicked = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local curCoinItem = (self.exchangeListNode):GetCurCoinItem()
  if curCoinItem == nil or curCoinItem.itemCfg == nil then
    return 
  end
  local itemId = (curCoinItem.itemCfg).id
  ;
  (self.storeCtrl):WCExchangeItem(itemId, function()
    -- function num : 0_23_0 , upvalues : itemId, _ENV, self, curCoinItem
    local isExchangeCoin = false
    if itemId == ConstGlobalItem.WCMoney then
      isExchangeCoin = (self.storeCtrl):GetCoinExchangeIsUse()
    else
      if itemId == ConstGlobalItem.WCDeployPoint then
        isExchangeCoin = (self.storeCtrl):GetRareExchangeIsUse()
      end
    end
    curCoinItem:UpdateSellOutActive(isExchangeCoin)
    self:RefreshCoinDetail(curCoinItem)
  end
)
end

UIWarChessStore.OnStoreSellClicked = function(self)
  -- function num : 0_24 , upvalues : _ENV
  local chipItem = (self.sellListNode):GetCurChipItem()
  local teamData = (self.sellListNode):GetCurTeamData()
  if chipItem ~= nil and teamData ~= nil then
    local stid = teamData:GetWCTeamId()
    ;
    (self.storeCtrl):WCSaleChip((chipItem.chipData).dataId, stid, nil)
    ;
    (self.chipDetailPanel):Hide()
    ;
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8533))
  end
end

UIWarChessStore.OnStoreBuyClicked = function(self, chipItem, teamData, storeData)
  -- function num : 0_25 , upvalues : _ENV
  if chipItem == nil or teamData == nil or storeData == nil then
    return 
  end
  if (self.storeCtrl):GetWCCoinItemNum() < chipItem.price then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8514))
    return 
  end
  local stid = teamData:GetWCTeamId()
  ;
  (self.storeCtrl):WCBuyChip(storeData, stid, function()
    -- function num : 0_25_0 , upvalues : _ENV, chipItem, storeData
    local window = UIManager:GetWindow(UIWindowTypeID.WarChessBuyChip)
    if window ~= nil then
      window:OnBuyChipSuccessCallback(chipItem, storeData)
    end
  end
)
end

UIWarChessStore.OnBuyChipLevel = function(self, index)
  -- function num : 0_26
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).canvasGroup).alpha = 1
  do
    if index ~= -1 then
      local item = (self.buyListNode):GetChipItemByIndex(index)
      if item ~= nil then
        item:SetStoreItemSelect(true)
      end
    end
    ;
    (self.buyListNode):RefreshAllItemSellOut()
  end
end

UIWarChessStore.OnSelectWCSChipItemForBuy = function(self, chipItem)
  -- function num : 0_27 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessBuyChip, function(window)
    -- function num : 0_27_0 , upvalues : self, chipItem
    if window ~= nil then
      local teamDic = (((self.storeCtrl).wcCtrl).teamCtrl):GetWCTeams()
      local currMoney = (self.storeCtrl):GetWCCoinItemNum()
      local currRare = (self.storeCtrl):GetWCRareItemNum()
      window:InitWCBuyChip(self.storeChipDataList, teamDic, self._onBuyChipBuyEvent, self._onBuyChipReturnEvent, currMoney, currRare)
      window:SetDefaultChip(chipItem.chipData)
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).canvasGroup).alpha = 0
    end
  end
)
end

UIWarChessStore.OnClicWCSkLeave = function(self)
  -- function num : 0_28
  (self.storeCtrl):ExitWCStore(function()
    -- function num : 0_28_0 , upvalues : self
    self:Delete()
  end
)
end

UIWarChessStore.OnDelete = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.sellListNode):Delete()
  ;
  (self.buyListNode):Delete()
  ;
  (self.exchangeListNode):Delete()
  ;
  (self.chipDetailPanel):Delete()
  ;
  (self.epBuffDetail):Delete()
  ;
  (self.epCoinDetail):Delete()
  self.sellListNode = nil
  self.buyListNode = nil
  self.exchangeListNode = nil
  self.chipDetailPanel = nil
  self.epBuffDetail = nil
  self.epCoinDetail = nil
  self.storeCtrl = nil
  MsgCenter:RemoveListener(eMsgEventId.WC_CoinNumChange, self.__onCoinNumChange)
end

return UIWarChessStore

