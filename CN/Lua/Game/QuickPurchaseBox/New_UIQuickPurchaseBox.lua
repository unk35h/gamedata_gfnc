-- params : ...
-- function num : 0 , upvalues : _ENV
local New_UIQuickPurchaseBox = class("New_UIQuickPurchaseBox", UIBaseWindow)
local base = UIBaseWindow
local ShopEnum = require("Game.Shop.ShopEnum")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINResourceGroup = require("Game.CommonUI.ResourceGroup.UINResourceGroup")
local UINQuickPurchaseLogicPreview = require("Game.QuickPurchaseBox.UINQuickPurchaseLogicPreview")
local UINQuickPurchasePayGift = require("Game.QuickPurchaseBox.UINQuickPurchasePayGift")
local UINQuickPurchaseFixedCountGood = require("Game.QuickPurchaseBox.UINQuickPurchaseFixedCountGood")
local UINQuickPurchaseRoomTheme = require("Game.QuickPurchaseBox.UINQuickPurchaseRoomTheme")
local UINOverflowTransNode = require("Game.QuickPurchaseBox.UINOverflowTransNode")
local cs_MessageCommon = CS.MessageCommon
local JumpManager = require("Game.Jump.JumpManager")
local ShopUtil = require("Game.Shop.ShopUtil")
local UINGiftItemListPage = require("Game.QuickPurchaseBox.UINGiftItemListPage")
local CoinAllowExchange = {[ConstGlobalItem.SkinTicket] = (ShopEnum.eQuickBuy).skinTicket, [ConstGlobalItem.ADCUnlockItem] = (ShopEnum.eQuickBuy).ADCUnlockItem, [ConstGlobalItem.DormCoin] = (ShopEnum.eQuickBuy).dormCoin}
local QuickPurchaseType = {normal = 1, payGift = 2, fixedCountGoods = 3, roomTheme = 4, giftItemListNode = 5}
local QuickPurchaseNormalNodeType = {normal = 1, overflow = 2}
New_UIQuickPurchaseBox.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINResourceGroup, UINBaseItemWithCount, UINQuickPurchaseLogicPreview, UINOverflowTransNode
  self.oldRoot = (self.transform).parent
  self.ctrl = ControllerManager:GetController(ControllerTypeId.Shop, false)
  self.buyNum = 0
  self.resourceGroup = (UINResourceGroup.New)()
  ;
  (self.resourceGroup):Init((self.ui).gameResourceGroup)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_Back, self, self.SlideOut, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reduce, self, self.OnClickMin)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self.OnClickAdd)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ExtrInfo, self, self.OnClickExtraInfo)
  ;
  (((self.ui).btn_Add).onPress):AddListener(BindCallback(self, self.OnPressAdd))
  ;
  (((self.ui).btn_Reduce).onPress):AddListener(BindCallback(self, self.OnPressMin))
  ;
  (((self.ui).tween_side).onComplete):AddListener(BindCallback(self, self.OnSlideInComplete))
  ;
  (((self.ui).tween_side).onRewind):AddListener(BindCallback(self, self.Hide))
  self.itemWithCount = (UINBaseItemWithCount.New)()
  ;
  (self.itemWithCount):Init((self.ui).itemWithCount)
  ;
  (self.itemWithCount):SetNotNeedAnyJump(true)
  self.buildPreviewNode = (UINQuickPurchaseLogicPreview.New)()
  ;
  (self.buildPreviewNode):Init((self.ui).obj_logicPreviewNode)
  ;
  (self.buildPreviewNode):Hide()
  self.overflowTransNode = (UINOverflowTransNode.New)()
  ;
  (self.overflowTransNode):Init((self.ui).obj_pageOverflowItem)
  ;
  (self.overflowTransNode):Hide()
  self.__AddBuyCountCallback = BindCallback(self, self.__AddBuyCount)
end

New_UIQuickPurchaseBox.SetRoot = function(self, transform)
  -- function num : 0_1
  (self.transform):SetParent(transform)
end

New_UIQuickPurchaseBox.SlideIn = function(self, isJumpIn, isHideLeftBtn)
  -- function num : 0_2 , upvalues : _ENV
  self.isJumpIn = isJumpIn
  self.__isHideLeftBtn = isHideLeftBtn
  ;
  ((self.ui).tween_side):DOPlayForward()
  AudioManager:PlayAudioById(1070)
  if not self.isJumpIn then
    (UIUtil.SetTopStatus)(self, self.SlideOut, nil, nil, nil, nil)
    ;
    (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
  else
    local backData = (UIUtil.PeekBackStack)()
    if backData == nil or backData.backAction == nil then
      (UIUtil.SetTopStatus)(nil, nil, nil, nil, nil, nil)
      ;
      (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
    else
      ;
      (UIUtil.SetTopStatus)(self, self.SlideOut, nil, nil, nil, nil)
      ;
      (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
    end
  end
  do
    self.slideInOver = false
    self.isSlideOuting = false
  end
end

New_UIQuickPurchaseBox.SlideOut = function(self, isHome, popBackStack)
  -- function num : 0_3 , upvalues : _ENV
  if not self.slideInOver then
    if popBackStack then
      (UIUtil.PopFromBackStackByUiTab)(self)
    end
    ;
    ((self.ui).tween_side):DOComplete()
    self:Hide()
    return 
  else
    if self.isSlideOuting then
      return 
    end
  end
  self.isSlideOuting = true
  AudioManager:PlayAudioById(1071)
  ;
  ((self.ui).tween_side):DOPlayBackwards()
  if popBackStack then
    if not self.isJumpIn then
      (UIUtil.PopFromBackStackByUiTab)(self)
      self.isJumpIn = nil
    else
      ;
      (UIUtil.PopFromBackStackByUiTab)(self)
    end
  end
end

New_UIQuickPurchaseBox.SlideOutImmediately = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if not self.active then
    return 
  end
  ;
  ((self.ui).tween_side):DORewind(false)
  if (UIUtil.CheckTopIsWindow)(self:GetUIWindowTypeId()) then
    (UIUtil.PopFromBackStackByUiTab)(self)
  end
end

New_UIQuickPurchaseBox.InitBuyRoomTheme = function(self, shopGoodsDic, isNeedRes, resIdList)
  -- function num : 0_5 , upvalues : _ENV, QuickPurchaseType
  if self.outDataTiemr ~= nil then
    TimerManager:StopTimer(self.outDataTiemr)
    self.outDataTiemr = nil
  end
  self.shopGoodsDic = shopGoodsDic
  self.themeItem = (self.shopGoodsDic)[1]
  self:ShowChildNodeByType(QuickPurchaseType.roomTheme)
  ;
  ((self.ui).obj_limit):SetActive(false)
  ;
  ((self.ui).obj_discount):SetActive(false)
  ;
  (self.quickPurchaseRoomTheme):OnInitPayGift(shopGoodsDic, self.themeItem, self)
  self:__refreshResGroup(isNeedRes, resIdList)
  ;
  (((self.ui).btn_ExtrInfo).gameObject):SetActive(false)
end

New_UIQuickPurchaseBox.InitBuyPayGift = function(self, payGiftInfo)
  -- function num : 0_6 , upvalues : _ENV, QuickPurchaseType
  if self.outDataTiemr ~= nil then
    TimerManager:StopTimer(self.outDataTiemr)
    self.outDataTiemr = nil
  end
  payGiftInfo:CleanSelfSelectInfo()
  self.payGiftInfo = payGiftInfo
  self:ShowChildNodeByType(QuickPurchaseType.payGift)
  ;
  ((self.ui).obj_limit):SetActive(false)
  ;
  ((self.ui).obj_discount):SetActive(false)
  ;
  (self.quickPurchasePayGift):OnInitPayGift(payGiftInfo, self)
  if payGiftInfo:IsUseItemPay() then
    local redIds = {}
    ;
    (table.insert)(redIds, (payGiftInfo.defaultCfg).costId)
    self:__refreshResGroup(true, redIds)
  else
    do
      self:__refreshResGroup(false)
      ;
      (((self.ui).btn_ExtrInfo).gameObject):SetActive(false)
    end
  end
end

New_UIQuickPurchaseBox.InitGiftItemList = function(self, payGiftInfo, callback)
  -- function num : 0_7 , upvalues : _ENV, QuickPurchaseType
  if self.outDataTiemr ~= nil then
    TimerManager:StopTimer(self.outDataTiemr)
    self.outDataTiemr = nil
  end
  self.payGiftInfo = payGiftInfo
  self:ShowChildNodeByType(QuickPurchaseType.giftItemListNode)
  ;
  ((self.ui).obj_limit):SetActive(false)
  ;
  ((self.ui).obj_discount):SetActive(false)
  ;
  (self.giftItemListNode):InitGiftItemListPage(payGiftInfo, callback)
  if payGiftInfo:IsUseItemPay() then
    local redIds = {}
    ;
    (table.insert)(redIds, (payGiftInfo.defaultCfg).costId)
    self:__refreshResGroup(true, redIds)
  else
    do
      self:__refreshResGroup(false)
      ;
      (((self.ui).btn_ExtrInfo).gameObject):SetActive(false)
      ;
      (UIUtil.SetTopStatusBtnShow)(false, false)
    end
  end
end

New_UIQuickPurchaseBox.InitBuyTarget = function(self, goodData, BuySuccessCallback, isNeedRes, resIdList, JumpOtherWinCallback, isOverflow)
  -- function num : 0_8 , upvalues : QuickPurchaseType, QuickPurchaseNormalNodeType
  self:ShowChildNodeByType(QuickPurchaseType.normal)
  self.goodData = goodData
  self.BuySuccessCallback = BuySuccessCallback
  self.isNeedRes = isNeedRes
  self.resIdList = resIdList
  self.__hasPopTips = false
  self.JumpOtherWinCallback = JumpOtherWinCallback
  ;
  ((self.ui).obj_pageOverflowItem):SetActive(false)
  ;
  ((self.ui).obj_pageNormalItem):SetActive(false)
  if isOverflow then
    self.normalNodeType = QuickPurchaseNormalNodeType.overflow
    ;
    ((self.ui).obj_pageOverflowItem):SetActive(true)
    self:m_RefreshOverflowUI(goodData)
  else
    self.normalNodeType = QuickPurchaseNormalNodeType.normal
    ;
    ((self.ui).obj_pageNormalItem):SetActive(true)
    self:m_RefreshGoodUI(goodData)
  end
  self:m_RefreshTotalMoney()
  self:__refreshResGroup(isNeedRes, resIdList)
  self:__isContainExtrInfo()
end

New_UIQuickPurchaseBox.__isContainExtrInfo = function(self)
  -- function num : 0_9 , upvalues : ShopEnum, _ENV
  if (self.goodData).shopType == (ShopEnum.eShopType).Charcter then
    (((self.ui).btn_ExtrInfo).gameObject):SetActive(true)
  else
    ;
    (((self.ui).btn_ExtrInfo).gameObject):SetActive(false)
  end
  if self.outDataTiemrId ~= nil then
    TimerManager:StopTimer(self.outDataTiemrId)
    self.outDataTiemrId = nil
  end
  self.__outDataTime = nil
  local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop)
  local flag, outDataTime = shopCtrl:GetShelfOutDataTime((self.goodData).shopId, (self.goodData).shelfId)
  if flag then
    self.__outDataTime = outDataTime
    self.outDataTiemrId = TimerManager:StartTimer(1, self.OnTimerOutData, self)
  end
end

New_UIQuickPurchaseBox.__refreshResGroup = function(self, isNeedRes, resIdList)
  -- function num : 0_10
  if isNeedRes then
    (self.resourceGroup):SetResourceIds(resIdList)
    ;
    (self.resourceGroup):Show()
  else
    ;
    (self.resourceGroup):Hide()
  end
  ;
  (self.transform):SetAsLastSibling()
end

New_UIQuickPurchaseBox.m_RefreshGoodOriUI = function(self, goodData)
  -- function num : 0_11 , upvalues : _ENV
  self:__refreshPriceDiscountUIData(goodData)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_currPrice).text = goodData.newCurrencyNum
  local currencyItemCfg = (ConfigData.item)[goodData.currencyId]
  local smallIcon = currencyItemCfg.small_icon
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_currencyIcon).sprite = CRH:GetSprite(smallIcon)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_totalCurrencyIcon).sprite = CRH:GetSprite(smallIcon)
end

New_UIQuickPurchaseBox.m_RefreshGoodUI = function(self, goodData)
  -- function num : 0_12 , upvalues : _ENV
  self:__refreshLimitUIData(goodData)
  self:__refreshDiscountTipUI(goodData)
  self:m_RefreshGoodOriUI(goodData)
  ;
  (self.itemWithCount):InitItemWithCount(goodData.itemCfg, goodData.itemNum, nil)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((goodData.itemCfg).name)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Detail).text = (LanguageUtil.GetLocaleText)((goodData.itemCfg).describe)
  if (goodData.itemCfg).type == eItemType.DormFurniture then
    local fntCfg = (ConfigData.dorm_furniture)[(goodData.itemCfg).id]
    if fntCfg ~= nil then
      ((self.ui).comfortLv):SetActive(true)
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_Comfort).text = tostring(fntCfg.comfort)
      ;
      ((self.ui).obj_img_ThemeFurniture):SetActive(fntCfg.is_theme)
      ;
      ((self.ui).obj_img_CheckIn):SetActive(fntCfg.can_binding)
      ;
      ((self.ui).obj_img_OnlyBig):SetActive(fntCfg.only_big)
    end
  else
    do
      ;
      ((self.ui).comfortLv):SetActive(false)
      ;
      ((self.ui).obj_img_ThemeFurniture):SetActive(false)
      ;
      ((self.ui).obj_img_CheckIn):SetActive(false)
      ;
      ((self.ui).obj_img_OnlyBig):SetActive(false)
      self:RefreshItemLeftTime()
    end
  end
end

New_UIQuickPurchaseBox.m_RefreshOverflowUI = function(self, goodData)
  -- function num : 0_13
  self:m_RefreshGoodOriUI(goodData)
  ;
  (self.overflowTransNode):InitOverflowTransItemInfo(goodData)
end

New_UIQuickPurchaseBox.__refreshPriceDiscountUIData = function(self, goodData)
  -- function num : 0_14
  if goodData.discount == 100 then
    ((self.ui).obj_discount):SetActive(false)
    ;
    (((self.ui).tex_oldPrice).gameObject):SetActive(false)
  else
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_oldPrice).text = goodData.oldCurrencyNum
    ;
    (((self.ui).tex_oldPrice).gameObject):SetActive(true)
  end
end

New_UIQuickPurchaseBox.__refreshDiscountTipUI = function(self, goodData)
  -- function num : 0_15 , upvalues : _ENV
  local shelfCfg = goodData.shelfCfg
  local discountNum = goodData.discount
  if shelfCfg.showdiscount or shelfCfg == nil or 0 > 0 then
    discountNum = shelfCfg.showdiscount
  end
  if discountNum == 100 then
    ((self.ui).obj_discount):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_discount):SetActive(true)
  ;
  ((self.ui).tex_Discount):SetIndex(0, tostring(100 - discountNum))
end

New_UIQuickPurchaseBox.__refreshLimitUIData = function(self, goodData)
  -- function num : 0_16 , upvalues : ShopEnum, _ENV
  if goodData.shopType ~= (ShopEnum.eShopType).Random and goodData.isLimit and goodData.limitType ~= (ShopEnum.eLimitType).None then
    ((self.ui).tex_LimitType):SetIndex(goodData.limitType - 1)
    if goodData.totallimitTime ~= nil then
      ((self.ui).tex_LimitCount):SetIndex(0, tostring(goodData.totallimitTime - goodData.purchases), tostring(goodData.totallimitTime))
    else
      ;
      ((self.ui).tex_LimitCount):SetIndex(0, tostring(goodData.limitTime - goodData.purchases), tostring(goodData.limitTime))
    end
    ;
    ((self.ui).obj_limit):SetActive(true)
  else
    ;
    ((self.ui).obj_limit):SetActive(false)
  end
end

New_UIQuickPurchaseBox.OnClickAdd = function(self, isIgnoreTip)
  -- function num : 0_17
  if self:m_CouldAdd(1, isIgnoreTip) then
    if isIgnoreTip then
      self:__AddBuyCount(1)
    else
      self:__TryAddCountTip(1, self.__AddBuyCountCallback)
    end
  end
end

New_UIQuickPurchaseBox.OnPressAdd = function(self, isIgnoreTip)
  -- function num : 0_18 , upvalues : _ENV
  local pressedTime = ((self.ui).btn_Add):GetPressedTime()
  local changeNum = (math.ceil)(pressedTime * pressedTime / 5)
  changeNum = (math.min)(changeNum, 100)
  if self:m_CouldAdd(changeNum, isIgnoreTip) then
    if isIgnoreTip then
      self:__AddBuyCount(changeNum)
    else
      self:__TryAddCountTip(changeNum, self.__AddBuyCountCallback)
    end
  else
    self:Add2Max()
  end
end

New_UIQuickPurchaseBox.__AddBuyCount = function(self, changeNum)
  -- function num : 0_19 , upvalues : _ENV
  AudioManager:PlayAudioById(1064)
  self.buyNum = self.buyNum + changeNum
  self:m_RefreshTotalMoney()
end

New_UIQuickPurchaseBox.OnClickMin = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self.buyNum <= 1 then
    if not (self.goodData).isLimit and (table.contain)((ConfigData.game_config).highValueCurrencyList, (self.goodData).currencyId) then
      AudioManager:PlayAudioById(1065)
      return 
    end
    local maxNum = self:Add2Max(false, true)
    if maxNum == 0 then
      AudioManager:PlayAudioById(1065)
    else
      local changeNum = maxNum - self.buyNum
      if changeNum > 0 then
        self:__TryAddCountTip(changeNum, self.__AddBuyCountCallback)
      end
    end
    do
      do
        do return  end
        AudioManager:PlayAudioById(1065)
        self.buyNum = self.buyNum - 1
        self:m_RefreshTotalMoney()
      end
    end
  end
end

New_UIQuickPurchaseBox.OnPressMin = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local pressedTime = ((self.ui).btn_Reduce):GetPressedTime()
  local changeNum = (math.ceil)(pressedTime * pressedTime / 5)
  changeNum = (math.min)(changeNum, 100)
  if self.buyNum - changeNum <= 1 then
    if self.buyNum > 1 then
      AudioManager:PlayAudioById(1065)
    end
    self.buyNum = 1
    self:m_RefreshTotalMoney()
    return 
  end
  AudioManager:PlayAudioById(1065)
  self.buyNum = self.buyNum - changeNum
  self:m_RefreshTotalMoney()
end

New_UIQuickPurchaseBox.m_CouldAdd = function(self, count, isIgnoreTip)
  -- function num : 0_22 , upvalues : cs_MessageCommon, _ENV, QuickPurchaseNormalNodeType, CoinAllowExchange, ShopUtil
  if count or 0 == 0 then
    count = 1
  end
  if (self.goodData).isSoldOut then
    if not isIgnoreTip then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_SoldOut))
    end
    return false
  else
    if (self.goodData).fragMaxBuyNum ~= nil and (self.goodData).fragMaxBuyNum < self.buyNum + count then
      if not isIgnoreTip then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_BuyNumLimit))
      end
      return false
    end
  end
  local wharehouseMaxNum = (self.goodData):GetCouldBuyMaxBuyNum()
  if (self.goodData).isLimit then
    if (self.goodData).limitTime - (self.goodData).purchases < self.buyNum + count then
      if not isIgnoreTip then
        if (self.goodData).totallimitTime ~= nil and self.buyNum + count <= (self.goodData).totallimitTime - (self.goodData).purchases then
          (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_PriceChange))
        else
          ;
          (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_BuyNumLimit))
        end
      end
      return false
    end
    if wharehouseMaxNum >= 0 and wharehouseMaxNum < self.buyNum + count then
      if not isIgnoreTip then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(336))
      end
      return false
    end
  end
  if ((self.goodData).itemCfg).overflow_type == eItemTransType.actMoneyX then
    wharehouseMaxNum = -1
    if ((self.goodData).itemCfg).action_type == eItemActionType.HeroCardFrag and self.normalNodeType == QuickPurchaseNormalNodeType.normal then
      local heroData = (PlayerDataCenter.heroDic)[(((self.goodData).itemCfg).arg)[1]]
      if heroData ~= nil then
        wharehouseMaxNum = heroData:GetMaxNeedFragNum(true)
      end
    end
  end
  do
    if wharehouseMaxNum >= 0 and wharehouseMaxNum < self.buyNum + count then
      if not isIgnoreTip then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.ResourceOverflow))
      end
      return false
    end
    local totalMoney = PlayerDataCenter:GetItemCount((self.goodData).currencyId)
    local enableBuyOne = false
    if (self.goodData).currencyId == ConstGlobalItem.PaidSubItem or (self.goodData).currencyId == ConstGlobalItem.PaidItem then
      totalMoney = totalMoney + PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem)
      enableBuyOne = self.buyNum + count <= 1
    elseif CoinAllowExchange[(self.goodData).currencyId] ~= nil then
      enableBuyOne = true
    elseif (ShopUtil.CheckCurrencyExchange)((self.goodData).currencyId) then
      enableBuyOne = true
    end
    local totalNeedMoney = (self.buyNum + count) * (self.goodData).newCurrencyNum
    if totalMoney < totalNeedMoney and not enableBuyOne then
      if not isIgnoreTip then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_MoneyInsufficient))
      end
      return false
    end
    do return true end
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

New_UIQuickPurchaseBox.__TryAddCountTip = function(self, changeNum, confirmFunc)
  -- function num : 0_23 , upvalues : _ENV, QuickPurchaseNormalNodeType, cs_MessageCommon
  if confirmFunc == nil then
    return 
  end
  if self.__hasPopTips then
    confirmFunc(changeNum)
    return 
  end
  local itemCfg = (self.goodData).itemCfg
  if itemCfg.action_type ~= eItemActionType.HeroCardFrag then
    confirmFunc(changeNum)
    return 
  end
  local heroData = (PlayerDataCenter.heroDic)[(((self.goodData).itemCfg).arg)[1]]
  if heroData == nil or self.buyNum + changeNum <= heroData:GetMaxNeedFragNum(true) then
    confirmFunc(changeNum)
    return 
  end
  if self.normalNodeType == QuickPurchaseNormalNodeType.overflow then
    confirmFunc(changeNum)
    return 
  end
  ;
  (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(3010), function()
    -- function num : 0_23_0 , upvalues : self, confirmFunc, changeNum
    self.__hasPopTips = true
    confirmFunc(changeNum)
  end
, nil)
end

New_UIQuickPurchaseBox.Add2Max = function(self, maxLimit, getMax)
  -- function num : 0_24 , upvalues : _ENV, CoinAllowExchange, QuickPurchaseNormalNodeType
  local maxNum = 0
  local totalMoney = PlayerDataCenter:GetItemCount((self.goodData).currencyId)
  if (self.goodData).currencyId == ConstGlobalItem.PaidSubItem then
    totalMoney = totalMoney + PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem)
  end
  local totalNeedMoney = (self.buyNum + 1) * (self.goodData).newCurrencyNum
  maxNum = (math.max)((math.floor)((totalMoney) / (self.goodData).newCurrencyNum), 0)
  if (self.goodData).currencyId == ConstGlobalItem.PaidSubItem then
    maxNum = (math.max)(1, maxNum)
  end
  if (self.goodData).isLimit then
    if CoinAllowExchange[(self.goodData).currencyId] ~= nil then
      maxNum = (self.goodData).limitTime - (self.goodData).purchases
    else
      maxNum = (math.min)((self.goodData).limitTime - (self.goodData).purchases, maxNum)
    end
  end
  if (self.goodData).fragMaxBuyNum ~= nil then
    maxNum = (math.min)((self.goodData).fragMaxBuyNum, maxNum)
  end
  local wharehouseMaxNum = (self.goodData):GetCouldBuyMaxBuyNum()
  if ((self.goodData).itemCfg).overflow_type == eItemTransType.actMoneyX then
    wharehouseMaxNum = -1
    if ((self.goodData).itemCfg).action_type == eItemActionType.HeroCardFrag and self.normalNodeType == QuickPurchaseNormalNodeType.normal then
      local heroData = (PlayerDataCenter.heroDic)[(((self.goodData).itemCfg).arg)[1]]
      if heroData ~= nil then
        wharehouseMaxNum = heroData:GetMaxNeedFragNum(true)
      end
    end
  end
  do
    if wharehouseMaxNum >= 0 then
      maxNum = (math.min)(maxNum, wharehouseMaxNum)
    end
    if maxLimit then
      maxNum = (math.min)(maxNum, 99)
    end
    if not getMax then
      self.buyNum = maxNum
      self:m_RefreshTotalMoney()
      return maxNum
    else
      return maxNum
    end
  end
end

New_UIQuickPurchaseBox.OnClickBuy = function(self, buyNum, OnBuyCompleted)
  -- function num : 0_25 , upvalues : _ENV, cs_MessageCommon, QuickPurchaseNormalNodeType, CoinAllowExchange, ShopUtil
  if self.isSlideOuting then
    return 
  end
  if buyNum ~= nil then
    self.buyNum = buyNum
  end
  if self.buyNum <= 0 then
    return 
  end
  local containAth = false
  local itemCfg = (self.goodData).itemCfg
  if itemCfg ~= nil and itemCfg.type == eItemType.Arithmetic then
    containAth = true
  end
  if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
    return 
  end
  local tatalBuyNum = self.buyNum * (self.goodData).itemNum
  local buyFunc = function()
    -- function num : 0_25_0 , upvalues : self, _ENV, tatalBuyNum
    self._heroIdSnapShoot = PlayerDataCenter:GetHeroIdSnapShoot()
    local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop)
    if shopCtrl:GetShelfIsSouldOut((self.goodData).shopId, (self.goodData).shelfId) then
      return 
    end
    local itemTransDic = {}
    do
      if ((self.goodData).itemCfg).overflow_type == eItemTransType.actMoneyX then
        local num = PlayerDataCenter:GetItemOverflowNum((self.goodData).itemId, self.buyNum)
        if num ~= 0 then
          itemTransDic[(self.goodData).itemId] = num
        end
      end
      ;
      (self.ctrl):ReqBuyGoods((self.goodData).shopId, (self.goodData).shelfId, self.buyNum, function()
      -- function num : 0_25_0_0 , upvalues : _ENV, self, tatalBuyNum, itemTransDic
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_25_0_0_0 , upvalues : _ENV, self, tatalBuyNum, itemTransDic
        if window == nil then
          return 
        end
        local CommonRewardData = require("Game.CommonUI.CommonRewardData")
        local CRData = ((CommonRewardData.CreateCRDataUseList)({(self.goodData).itemId}, {tatalBuyNum})):SetCRHeroSnapshoot(self._heroIdSnapShoot)
        CRData:SetCRItemTransDic(itemTransDic)
        window:AddAndTryShowReward(CRData)
        self.buyNum = 0
        if UIManager:GetWindow(self:GetUIWindowTypeId()) ~= nil then
          self:m_RefreshTotalMoney()
          self:m_RefreshGoodUI(self.goodData)
        end
        if self.BuySuccessCallback ~= nil then
          (self.BuySuccessCallback)()
        end
      end
)
      self:TryClosePurchaseBox()
    end
)
    end
  end

  if self.normalNodeType == QuickPurchaseNormalNodeType.overflow then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(15002), function()
    -- function num : 0_25_1 , upvalues : self, _ENV, buyFunc
    local totalNeedMoney = self.buyNum * (self.goodData).newCurrencyNum
    local ownMoney = PlayerDataCenter:GetItemCount((self.goodData).currencyId)
    if totalNeedMoney <= ownMoney then
      buyFunc()
      return 
    end
  end
, nil)
    return 
  end
  local totalNeedMoney = self.buyNum * (self.goodData).newCurrencyNum
  local ownMoney = PlayerDataCenter:GetItemCount((self.goodData).currencyId)
  if totalNeedMoney <= ownMoney then
    buyFunc()
    return 
  end
  -- DECOMPILER ERROR at PC93: Unhandled construct in 'MakeBoolean' P1

  if ((self.goodData).currencyId == ConstGlobalItem.PaidSubItem or (self.goodData).currencyId == ConstGlobalItem.PaidItem) and ownMoney < totalNeedMoney then
    local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
    do
      local beforeJumpCallback = function(callBack)
    -- function num : 0_25_2 , upvalues : self
    if self.JumpOtherWinCallback ~= nil then
      (self.JumpOtherWinCallback)()
    end
    if callBack ~= nil then
      callBack()
    end
  end

      local directShowShop = shopWin == nil
      local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
      payCtrl:TryConvertPayItem((self.goodData).currencyId, totalNeedMoney - ownMoney, beforeJumpCallback, nil, buyFunc, directShowShop)
      return 
    end
  end
  -- DECOMPILER ERROR at PC125: Unhandled construct in 'MakeBoolean' P1

  if CoinAllowExchange[(self.goodData).currencyId] ~= nil and ownMoney < totalNeedMoney then
    local coinQuickBuyCfg = CoinAllowExchange[(self.goodData).currencyId]
    local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
    if not shopCtrl:ShopIsUnlock(coinQuickBuyCfg.shopId) then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_MoneyInsufficient))
      return 
    end
    shopCtrl:GetShopData(coinQuickBuyCfg.shopId, function(shopData)
    -- function num : 0_25_3 , upvalues : coinQuickBuyCfg, _ENV, self, totalNeedMoney, ownMoney, shopCtrl, buyFunc
    local exChangeGoodData = (shopData.shopGoodsDic)[coinQuickBuyCfg.shelfId]
    if exChangeGoodData == nil then
      error("Cant get goodData from normalShop, itemId = " .. (self.goodData).currencyId)
      return 
    end
    local needItemNum = (math.ceil)((totalNeedMoney - ownMoney) / exChangeGoodData.itemNum)
    local needCurrencyNum = exChangeGoodData.newCurrencyNum * needItemNum
    self:PaidCoinExecute(exChangeGoodData.currencyId, needCurrencyNum, (self.goodData).currencyId, needItemNum * exChangeGoodData.itemNum, function()
      -- function num : 0_25_3_0 , upvalues : shopCtrl, exChangeGoodData, needItemNum, buyFunc
      shopCtrl:ReqBuyGoods(exChangeGoodData.shopId, exChangeGoodData.shelfId, needItemNum, function()
        -- function num : 0_25_3_0_0 , upvalues : buyFunc
        buyFunc()
      end
)
    end
)
  end
)
    return 
  end
  if (ShopUtil.StartCurrencyExchange)((self.goodData).currencyId) ~= nil then
    return 
  end
  buyFunc()
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

New_UIQuickPurchaseBox.PaidCoinExecute = function(self, currencyId, currencyNum, coinId, coinNum, executeFunc)
  -- function num : 0_26 , upvalues : _ENV, cs_MessageCommon, JumpManager, ShopEnum
  local containCurrencyNum = PlayerDataCenter:GetItemCount(currencyId)
  local currencyCfg = (ConfigData.item)[currencyId]
  if currencyCfg == nil then
    error("Item Cfg is null,ID:" .. tostring(currencyId))
    return 
  end
  local currencyName = (LanguageUtil.GetLocaleText)(currencyCfg.name)
  local srcIdList = {}
  local srcNumList = {}
  local needPaidItemNum = 0
  needPaidItemNum = currencyNum - containCurrencyNum
  local linkSign = ""
  if LanguageUtil.LanguageInt == eLanguageType.EN_US then
    linkSign = " "
  end
  if currencyId == ConstGlobalItem.PaidSubItem then
    if needPaidItemNum > 0 and (containCurrencyNum == 0 or currencyId == coinId) then
      (table.insert)(srcIdList, ConstGlobalItem.PaidItem)
      ;
      (table.insert)(srcNumList, needPaidItemNum)
      local itemCfg = (ConfigData.item)[ConstGlobalItem.PaidItem]
      currencyName = tostring(needPaidItemNum) .. linkSign .. (LanguageUtil.GetLocaleText)(itemCfg.name)
    else
      do
        if needPaidItemNum > 0 and containCurrencyNum > 0 then
          (table.insert)(srcIdList, ConstGlobalItem.PaidItem)
          ;
          (table.insert)(srcNumList, needPaidItemNum)
          ;
          (table.insert)(srcIdList, ConstGlobalItem.PaidSubItem)
          ;
          (table.insert)(srcNumList, containCurrencyNum)
          local itemCfg = (ConfigData.item)[ConstGlobalItem.PaidItem]
          currencyName = tostring(needPaidItemNum) .. linkSign .. (LanguageUtil.GetLocaleText)(itemCfg.name) .. linkSign .. "+" .. linkSign .. tostring(containCurrencyNum) .. linkSign .. currencyName
        else
          do
            ;
            (table.insert)(srcIdList, ConstGlobalItem.PaidSubItem)
            ;
            (table.insert)(srcNumList, currencyNum)
            currencyName = tostring(currencyNum) .. linkSign .. currencyName
            ;
            (table.insert)(srcIdList, currencyId)
            ;
            (table.insert)(srcNumList, currencyNum)
            currencyName = tostring(currencyNum) .. linkSign .. currencyName
            local needItemName = (LanguageUtil.GetLocaleText)(((ConfigData.item)[coinId]).name)
            local msg = (string.format)(ConfigData:GetTipContent(322), currencyName, tostring(coinNum), needItemName)
            if ((Consts.GameChannelType).IsJp)() then
              msg = msg .. ConfigData:GetTipContent(334)
            end
            local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
            window:ShowItemConvert(msg, srcIdList, srcNumList, {coinId}, {coinNum}, function()
    -- function num : 0_26_0 , upvalues : needPaidItemNum, executeFunc, _ENV, srcIdList, srcNumList, cs_MessageCommon, self, JumpManager, ShopEnum
    if needPaidItemNum <= 0 then
      executeFunc()
      return 
    end
    local canConvert = true
    for i,itemId in ipairs(srcIdList) do
      local itemCount = srcNumList[i]
      if PlayerDataCenter:GetItemCount(itemId) < itemCount then
        canConvert = false
        break
      end
    end
    do
      if canConvert then
        executeFunc()
        return 
      end
      ;
      (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(TipContent.PaidItemNotEnoughTip), function()
      -- function num : 0_26_0_0 , upvalues : _ENV, self, JumpManager, ShopEnum
      local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
      local beforeJumpCallback = function(callBack)
        -- function num : 0_26_0_0_0 , upvalues : self
        if self.JumpOtherWinCallback ~= nil then
          (self.JumpOtherWinCallback)()
        end
        if callBack ~= nil then
          callBack()
        end
      end

      local directShowShop = shopWin == nil
      if directShowShop then
        JumpManager:DirectShowShop(beforeJumpCallback, nil, (ShopEnum.ShopId).recharge)
      else
        JumpManager:Jump((JumpManager.eJumpTarget).DynShop, beforeJumpCallback, nil, {(ShopEnum.ShopId).recharge})
      end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
, nil)
    end
  end
)
          end
        end
      end
    end
  end
end

New_UIQuickPurchaseBox.OnSlideInComplete = function(self)
  -- function num : 0_27
  self.slideInOver = true
end

New_UIQuickPurchaseBox.TryClosePurchaseBox = function(self)
  -- function num : 0_28 , upvalues : _ENV
  if not UIManager:GetWindow(UIWindowTypeID.QuickBuy) then
    return 
  end
  if self.isJumpIn then
    self:SlideOut(false, true)
  else
    if (UIUtil.CheckTopIsWindow)(UIWindowTypeID.QuickBuy) then
      (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.QuickBuy, true)
    else
      self:SlideOut(false, true)
    end
  end
end

New_UIQuickPurchaseBox.OnClickClose = function(self)
  -- function num : 0_29
  if not self.active then
    return 
  end
  if self.quickPurchasePayGift ~= nil then
    (self.quickPurchasePayGift):Hide()
  end
  self.isSlideOuting = false
  self:SetRoot(self.oldRoot)
  self.__beforeHideBuyNum = self.buyNum
  self.buyNum = 0
  if self.goodData ~= nil then
    self:m_RefreshTotalMoney()
  end
end

New_UIQuickPurchaseBox.m_RefreshTotalMoney = function(self)
  -- function num : 0_30 , upvalues : _ENV
  if self.buyNum == 0 then
    (((self.ui).btn_Buy).gameObject):SetActive(false)
    ;
    ((self.ui).obj_cantBuy):SetActive(true)
  else
    ;
    (((self.ui).btn_Buy).gameObject):SetActive(true)
    ;
    ((self.ui).obj_cantBuy):SetActive(false)
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_buyCount).text = tostring(self.buyNum)
  local totalMoney = self.buyNum * (self.goodData).newCurrencyNum
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_totalcurrPrice).text = tostring(totalMoney)
end

New_UIQuickPurchaseBox.OnClickExtraInfo = function(self)
  -- function num : 0_31
  local intervalList, priceList, curIndex = (self.goodData):GetPriceInterval()
  ;
  (self.buildPreviewNode):InitBuyFragPreview(intervalList, priceList, curIndex)
  ;
  (self.buildPreviewNode):Show()
end

New_UIQuickPurchaseBox.InitBuyFixedCountGood = function(self, fixedCount, goodData, isNeedRes, resIdList, buySuccessCallback)
  -- function num : 0_32 , upvalues : QuickPurchaseType, _ENV
  self.fixedCount = fixedCount
  self.goodData = goodData
  self.isNeedRes = isNeedRes
  self.resIdList = resIdList
  self.BuySuccessCallback = buySuccessCallback
  self:ShowChildNodeByType(QuickPurchaseType.fixedCountGoods)
  self:__refreshLimitUIData(goodData)
  self:__refreshDiscountTipUI(goodData)
  self:__refreshResGroup(isNeedRes, resIdList)
  self:__isContainExtrInfo()
  ;
  (self.quickPurchaseFixedCountGood):InitWithDataForFixedCountGood(goodData, BindCallback(self, self.OnClickBuy), BindCallback(self, self.m_CouldAdd))
  ;
  (self.quickPurchaseFixedCountGood):SetBuyFixedCount(fixedCount)
  self.buyNum = 0
end

New_UIQuickPurchaseBox.ShowChildNodeByType = function(self, purchaseType)
  -- function num : 0_33 , upvalues : QuickPurchaseType, UINQuickPurchasePayGift, UINQuickPurchaseFixedCountGood, UINQuickPurchaseRoomTheme, UINGiftItemListPage
  self.__purchaseType = purchaseType
  ;
  ((self.ui).itemPage):SetActive(purchaseType == QuickPurchaseType.normal)
  if self.quickPurchasePayGift ~= nil then
    if purchaseType == QuickPurchaseType.payGift then
      (self.quickPurchasePayGift):Show()
    else
      (self.quickPurchasePayGift):Hide()
    end
  elseif purchaseType == QuickPurchaseType.payGift then
    ((self.ui).giftBagPage):SetActive(true)
    self.quickPurchasePayGift = (UINQuickPurchasePayGift.New)()
    ;
    (self.quickPurchasePayGift):Init((self.ui).giftBagPage)
  else
    ((self.ui).giftBagPage):SetActive(false)
  end
  if self.quickPurchaseFixedCountGood ~= nil then
    if purchaseType == QuickPurchaseType.fixedCountGoods then
      (self.quickPurchaseFixedCountGood):Show()
    else
      (self.quickPurchaseFixedCountGood):Hide()
    end
  elseif purchaseType == QuickPurchaseType.fixedCountGoods then
    ((self.ui).singleBuyPage):SetActive(true)
    self.quickPurchaseFixedCountGood = (UINQuickPurchaseFixedCountGood.New)()
    ;
    (self.quickPurchaseFixedCountGood):Init((self.ui).singleBuyPage)
  else
    ((self.ui).singleBuyPage):SetActive(false)
  end
  if self.quickPurchaseRoomTheme ~= nil then
    if purchaseType == QuickPurchaseType.roomTheme then
      (self.quickPurchaseRoomTheme):Show()
    else
      (self.quickPurchaseRoomTheme):Hide()
    end
  elseif purchaseType == QuickPurchaseType.roomTheme then
    ((self.ui).roomThemePage):SetActive(true)
    self.quickPurchaseRoomTheme = (UINQuickPurchaseRoomTheme.New)()
    ;
    (self.quickPurchaseRoomTheme):Init((self.ui).roomThemePage)
  else
    ((self.ui).roomThemePage):SetActive(false)
  end
  if self.giftItemListNode ~= nil then
    if purchaseType == QuickPurchaseType.giftItemListNode then
      (self.giftItemListNode):Show()
    else
      (self.giftItemListNode):Hide()
    end
  elseif purchaseType == QuickPurchaseType.giftItemListNode then
    ((self.ui).giftItemListPage):SetActive(true)
    self.giftItemListNode = (UINGiftItemListPage.New)()
    ;
    (self.giftItemListNode):Init((self.ui).giftItemListPage)
  else
    ((self.ui).giftItemListPage):SetActive(false)
  end
  -- DECOMPILER ERROR: 17 unprocessed JMP targets
end

New_UIQuickPurchaseBox.OnTimerOutData = function(self)
  -- function num : 0_34 , upvalues : _ENV
  self:RefreshItemLeftTime()
  if self.__outDataTime == nil then
    return 
  end
  if self.__outDataTime - PlayerDataCenter.timestamp > 0 then
    return 
  end
  if self.outDataTiemrId ~= nil then
    TimerManager:StopTimer(self.outDataTiemrId)
    self.outDataTiemrId = nil
    self.__outDataTime = nil
  end
  self:TryClosePurchaseBox()
end

New_UIQuickPurchaseBox.RefreshItemLeftTime = function(self)
  -- function num : 0_35 , upvalues : QuickPurchaseType, _ENV
  ((self.ui).obj_fntBuyLimittime):SetActive(false)
  if self.__purchaseType == QuickPurchaseType.normal and ((self.goodData).itemCfg).type == eItemType.DormFurniture then
    local hasTimeLimit, inTime, startTime, endTime = (self.goodData):GetStillTime()
    if not hasTimeLimit or not inTime then
      return 
    end
    ;
    ((self.ui).obj_fntBuyLimittime):SetActive(true)
    local remaindTime = endTime - PlayerDataCenter.timestamp
    local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
    if d > 0 then
      ((self.ui).tex_fntBuyLimittime):SetIndex(0, tostring(d), tostring(h))
    else
      if h > 0 then
        ((self.ui).tex_fntBuyLimittime):SetIndex(1, tostring(h), tostring(m))
      else
        if s > 0 then
          m = m + 1
          ;
          ((self.ui).tex_fntBuyLimittime):SetIndex(2, tostring(m))
        end
      end
    end
  end
end

New_UIQuickPurchaseBox.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_36 , upvalues : _ENV, QuickPurchaseType
  local dataTable = {}
  for key,value in pairs(self) do
    dataTable[key] = value
  end
  self:SlideOut(nil, true)
  return function()
    -- function num : 0_36_0 , upvalues : _ENV, dataTable, self, QuickPurchaseType
    for key,value in pairs(dataTable) do
      self[key] = value
    end
    self.buyNum = self.__beforeHideBuyNum
    self:SlideIn(nil, self.__isHideLeftBtn)
    do
      if self.__purchaseType == QuickPurchaseType.payGift then
        local flag, startTime, endTime = (self.payGiftInfo):IsUnlockTimeCondition()
        if flag and endTime <= PlayerDataCenter.timestamp then
          self:SlideOut(nil, true)
          return true
        end
        self:InitBuyPayGift(self.payGiftInfo)
        return 
      end
      local ShopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
      if not ShopController:ShopIsUnlock((self.goodData).shopId) then
        self:SlideOut(nil, true)
        return true
      end
      local notNeedShow = false
      ShopController:GetShopData((self.goodData).shopId, function(shopData)
      -- function num : 0_36_0_0 , upvalues : self, notNeedShow, QuickPurchaseType
      if shopData == nil then
        self:SlideOut(nil, true)
        notNeedShow = true
        return 
      end
      self.goodData = (shopData.shopGoodsDic)[(self.goodData).shelfId]
      if self.goodData == nil then
        self:SlideOut(nil, true)
        notNeedShow = true
        return 
      end
      if self.__purchaseType == QuickPurchaseType.normal then
        local maxNum = self:Add2Max(nil, true)
        if maxNum < self.buyNum then
          if maxNum < 0 then
            maxNum = 0
          end
          self.buyNum = maxNum
        end
        self:InitBuyTarget(self.goodData, self.BuySuccessCallback, self.isNeedRes, self.resIdList, self.JumpOtherWinCallback)
      else
        do
          if self.__purchaseType == QuickPurchaseType.fixedCountGoods then
            self:InitBuyFixedCountGood(self.fixedCount, self.goodData, self.isNeedRes, self.resIdList, self.BuySuccessCallback)
          end
        end
      end
    end
)
      return notNeedShow
    end
  end

end

New_UIQuickPurchaseBox.Hide = function(self)
  -- function num : 0_37 , upvalues : base
  self:OnClickClose()
  ;
  (base.Hide)(self)
end

New_UIQuickPurchaseBox.OnHide = function(self)
  -- function num : 0_38 , upvalues : _ENV, base
  if (self.buildPreviewNode).active then
    (self.buildPreviewNode):_OnClickClose()
  end
  if self.quickPurchaseRoomTheme ~= nil then
    (self.quickPurchaseRoomTheme):ClearQPRoomThemeTimerId()
  end
  if self.outDataTiemrId ~= nil then
    TimerManager:StopTimer(self.outDataTiemrId)
    self.outDataTiemrId = nil
    self.__outDataTime = nil
  end
  ;
  (base.OnHide)(self)
end

New_UIQuickPurchaseBox.OnDelete = function(self)
  -- function num : 0_39 , upvalues : _ENV, base
  ((self.ui).tween_side):DOKill()
  ;
  (self.resourceGroup):Delete()
  ;
  (self.itemWithCount):Delete()
  ;
  (self.buildPreviewNode):Delete()
  if self.quickPurchaseFixedCountGood ~= nil then
    (self.quickPurchaseFixedCountGood):Delete()
    self.quickPurchaseFixedCountGood = nil
  end
  if self.quickPurchasePayGift ~= nil then
    (self.quickPurchasePayGift):Delete()
    self.quickPurchasePayGift = nil
  end
  if self.quickPurchaseRoomTheme ~= nil then
    (self.quickPurchaseRoomTheme):Delete()
    self.quickPurchaseRoomTheme = nil
  end
  if self.outDataTiemrId ~= nil then
    TimerManager:StopTimer(self.outDataTiemrId)
    self.outDataTiemrId = nil
  end
  ;
  (base.OnDelete)(self)
end

return New_UIQuickPurchaseBox

