-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopNormalGoogsItem = class("UINShopNormalGoogsItem", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local cs_MessageCommon = CS.MessageCommon
local showPaidItemList = {ConstGlobalItem.DormCoin}
UINShopNormalGoogsItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_shopItem, self, self.OnClick)
  self.__BuySucessFunc = BindCallback(self, self.__BuySucess)
  self.itemWithCount = (UINBaseItemWithCount.New)()
  ;
  (self.itemWithCount):Init((self.ui).obj_itemWithCount)
  ;
  (self.itemWithCount):EnableButton(false)
  self._RefreshGoodsRecharge = BindCallback(self, self.OnGoodsShopRechargeSuccess)
  MsgCenter:AddListener(eMsgEventId.ShopRechargeComplete, self._RefreshGoodsRecharge)
  self.texItemList = {[1] = (self.ui).tex_oldPrice, [2] = (self.ui).tex_currPrice, [3] = (self.ui).tex_Name}
end

UINShopNormalGoogsItem.InitNormalGoodsItem = function(self, goodData, purchaseRoot)
  -- function num : 0_1 , upvalues : ShopEnum, _ENV
  self.goodData = goodData
  self.purchaseRoot = purchaseRoot
  self.isRecharge = goodData.shopType == (ShopEnum.eShopType).Recharge
  if self.isRecharge then
    (((self.ui).img_CustomPic).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_CustomPic).sprite = CRH:GetSprite((goodData.goodCfg).icon)
    ;
    (self.itemWithCount):Hide()
    ;
    (((self.ui).tex_Extra).gameObject):SetActive(true)
    self.payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((goodData.goodCfg).name)
    ;
    (((self.ui).img_Quality).gameObject):SetActive(false)
  else
    (((self.ui).img_CustomPic).gameObject):SetActive(false)
    ;
    (self.itemWithCount):Show()
    ;
    (((self.ui).tex_Extra).gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((goodData.itemCfg).name)
    ;
    (self.itemWithCount):InitItemWithCount(goodData.itemCfg, goodData.itemNum)
    -- DECOMPILER ERROR at PC92: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Quality).color = ItemQualityColor[(goodData.itemCfg).quality]
  end
  self:RefreshCurrencyUI(goodData)
  self:RefreshLimitUI(goodData)
  for i = 1, #self.texItemList do
    ((self.texItemList)[i]):StartScrambleTypeWriter()
  end
  ;
  ((self.ui).obj_imgTimer):SetActive(false)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINShopNormalGoogsItem.BindNorShopAllRefreshCallback = function(self, callback)
  -- function num : 0_2
  self._allRefreshCallback = callback
end

UINShopNormalGoogsItem.RefreshCurrencyUI = function(self, goodData)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if self.isRecharge then
    ((self.ui).tex_currPrice).text = (self.payCtrl):GetPayPriceShow(((self.goodData).goodCfg).pay_id)
    ;
    (((self.ui).img_priceIcon).gameObject):SetActive(false)
    local itemIdList, itemNumList = (self.payCtrl):GetPayRewards(((self.goodData).goodCfg).pay_id, (self.goodData).hasDouble)
    local content = nil
    for i = 2, #itemIdList do
      local id = itemIdList[i]
      local num = itemNumList[i]
      local itemCfg = (ConfigData.item)[id]
      if itemCfg == nil then
        error("itemCfg is nill id:" .. tostring(id))
      else
        local name = (LanguageUtil.GetLocaleText)(itemCfg.name)
        if (string.IsNullOrEmpty)(content) then
          content = ((self.ui).tex_Extra):GetIndex(0, name, tostring(num))
        else
          content = content .. "\n" .. ((self.ui).tex_Extra):GetIndex(0, name, tostring(num))
        end
      end
    end
    -- DECOMPILER ERROR at PC83: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.ui).tex_Extra).text).text = content
  else
    do
      -- DECOMPILER ERROR at PC88: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).tex_currPrice).text = goodData.newCurrencyNum
      local currencyItemCfg = (ConfigData.item)[goodData.currencyId]
      do
        local smallIcon = currencyItemCfg.small_icon
        ;
        (((self.ui).img_priceIcon).gameObject):SetActive(true)
        -- DECOMPILER ERROR at PC106: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.ui).img_priceIcon).sprite = CRH:GetSprite(smallIcon)
        if goodData.discount == 100 then
          ((self.ui).obj_discount):SetActive(false)
          ;
          (((self.ui).tex_oldPrice).gameObject):SetActive(false)
        else
          ;
          ((self.ui).tex_Discount):SetIndex(0, tostring(100 - goodData.discount))
          -- DECOMPILER ERROR at PC134: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((self.ui).tex_oldPrice).text = goodData.oldCurrencyNum
          ;
          ((self.ui).obj_discount):SetActive(true)
          ;
          (((self.ui).tex_oldPrice).gameObject):SetActive(true)
        end
      end
    end
  end
end

UINShopNormalGoogsItem.RefreshLimitUI = function(self, goodData)
  -- function num : 0_4 , upvalues : ShopEnum, _ENV
  ((self.ui).obj_Times):SetActive(false)
  ;
  ((self.ui).obj_soldOut):SetActive(false)
  if goodData.isLimit and goodData.shopType ~= (ShopEnum.eShopType).Charcter and goodData.shopType ~= (ShopEnum.eShopType).Random then
    ((self.ui).obj_Times):SetActive(true)
    local timesTypeIndex = goodData.limitType
    ;
    ((self.ui).tex_Times_type):SetIndex(timesTypeIndex)
    if goodData.totallimitTime == nil or not goodData.totallimitTime then
      local limitCount = goodData.limitTime
    end
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Times).text = tostring(limitCount - goodData.purchases) .. "/" .. tostring(limitCount)
  end
  do
    local soldOutStageId = 0
    if self:__IsInHoldLimit() then
      soldOutStageId = 3
    else
      if goodData.isSoldOut then
        local isRepley = goodData:IsReplenishGoodsAndCount()
        soldOutStageId = isRepley and 2 or 1
      end
    end
    do
      if soldOutStageId > 0 then
        ((self.ui).obj_soldOut):SetActive(true)
        -- DECOMPILER ERROR at PC83: Confused about usage of register: R3 in 'UnsetPending'

        ;
        ((self.ui).buttom).color = ((self.ui).colors_state)[soldOutStageId]
        ;
        ((self.ui).textEN):SetIndex((soldOutStageId) - 1)
        ;
        ((self.ui).texCN):SetIndex((soldOutStageId) - 1)
      end
    end
  end
end

UINShopNormalGoogsItem.OnClick = function(self)
  -- function num : 0_5 , upvalues : _ENV, showPaidItemList, cs_MessageCommon
  if (self.goodData).isSoldOut then
    return 
  end
  if self:__IsInHoldLimit() then
    return 
  end
  local Local_Buy = function()
    -- function num : 0_5_0 , upvalues : self, _ENV, showPaidItemList
    if self.isRecharge then
      (ControllerManager:GetController(ControllerTypeId.Shop, true)):ReqShopRecharge(((self.goodData).goodCfg).pay_id)
    else
      UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
      -- function num : 0_5_0_0 , upvalues : _ENV, self, showPaidItemList
      if win == nil then
        error("can\'t open QuickBuy win")
        return 
      end
      local resIds = {}
      ;
      (table.insert)(resIds, (self.goodData).currencyId)
      if (table.contain)(showPaidItemList, (self.goodData).currencyId) then
        (table.insert)(resIds, 1, ConstGlobalItem.PaidSubItem)
        ;
        (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
      end
      if (self.goodData).currencyId == ConstGlobalItem.PaidSubItem and not (table.contain)(resIds, ConstGlobalItem.PaidItem) then
        (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
      end
      win:SlideIn()
      win:InitBuyTarget(self.goodData, self.__BuySucessFunc, true, resIds)
      win:OnClickAdd(true)
    end
)
    end
  end

  if self:IsHeroFragAndFull() then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(3010), Local_Buy, nil)
  else
    Local_Buy()
  end
end

UINShopNormalGoogsItem.OnGoodsShopRechargeSuccess = function(self, shopId)
  -- function num : 0_6
  if (self.goodData).shopId == shopId then
    self:RefreshGoods()
  end
end

UINShopNormalGoogsItem.__BuySucess = function(self)
  -- function num : 0_7
  if self._allRefreshCallback ~= nil and (self:IsHeroFragAndFull() or (self.goodData).isSoldOut or self:__IsInHoldLimit()) then
    (self._allRefreshCallback)()
    return 
  end
  self:RefreshGoods()
end

UINShopNormalGoogsItem.__IsInHoldLimit = function(self)
  -- function num : 0_8 , upvalues : _ENV
  return PlayerDataCenter:IsItemLimitHold((self.goodData).itemId)
end

UINShopNormalGoogsItem.RefreshGoods = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if IsNull(self.gameObject) then
    return 
  end
  self:RefreshCurrencyUI(self.goodData)
  self:RefreshLimitUI(self.goodData)
  self:RefreshLeftSellTime()
end

UINShopNormalGoogsItem.IsHeroFragAndFull = function(self)
  -- function num : 0_10 , upvalues : _ENV
  do
    if ((self.goodData).itemCfg).action_type == eItemActionType.HeroCardFrag then
      local heroData = (PlayerDataCenter.heroDic)[(((self.goodData).itemCfg).arg)[1]]
      return heroData ~= nil and heroData:GetMaxNeedFragNum(true) <= 0
    end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINShopNormalGoogsItem.RefreshLeftSellTime = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if (self.goodData).isSoldOut then
    ((self.ui).obj_imgTimer):SetActive(false)
    return 
  end
  local hasTimeLimit, inTime, startTime, endTime = (self.goodData):GetStillTime()
  if not hasTimeLimit or endTime < 0 then
    ((self.ui).obj_imgTimer):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_imgTimer):SetActive(true)
  local remaindTime = endTime - PlayerDataCenter.timestamp
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
  if d > 0 then
    ((self.ui).tex_leftTime):SetIndex(0, tostring(d), tostring(h))
    return 
  end
  if h > 0 then
    ((self.ui).tex_leftTime):SetIndex(1, tostring(h), tostring(m))
    return 
  end
  if s > 0 then
    m = m + 1
  end
  ;
  ((self.ui).tex_leftTime):SetIndex(2, tostring(m))
end

UINShopNormalGoogsItem.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnDelete)(self)
end

return UINShopNormalGoogsItem

