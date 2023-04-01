-- params : ...
-- function num : 0 , upvalues : _ENV
local UINQuickPurchasePayGift = class("UINQuickPurchasePayGift", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local cs_ResLoader = CS.ResLoader
local CS_ClientConsts = CS.ClientConsts
local cs_MessageCommon = CS.MessageCommon
local ShopEnum = require("Game.Shop.ShopEnum")
local UINCustomHeroGiftNode = require("Game.PayGift.UINCustomHeroGiftNode")
UINQuickPurchasePayGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy_Normal, self, self.OnClickBuyNormal)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy_Super, self, self.OnClickBuySuper)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GiftPageDetail, self, self.OnClickGiftPageDetial)
  self.itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self.__OnPayGiftChange = BindCallback(self, self.OnPayGiftChange)
  MsgCenter:AddListener(eMsgEventId.PayGiftChange, self.__OnPayGiftChange)
  self.__OnPayGiftCondition = BindCallback(self, self.OnPayGiftCondition)
  MsgCenter:AddListener(eMsgEventId.PayGiftItemPreConfition, self.__OnPayGiftCondition)
end

UINQuickPurchasePayGift.OnInitPayGift = function(self, payGiftInfo, parentWin)
  -- function num : 0_1 , upvalues : cs_ResLoader, _ENV, CS_ClientConsts, ShopEnum, UINCustomHeroGiftNode
  self.quickBuyWindow = parentWin
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.resloader = (cs_ResLoader.Create)()
  self.payGiftInfo = payGiftInfo
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(((self.payGiftInfo).groupCfg).name)
  local giftCount = #(self.payGiftInfo).giftCfgList
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
  if self._heroSelectNode ~= nil then
    (self._heroSelectNode):Hide()
  end
  local isUseItemPay = (self.payGiftInfo):IsUseItemPay()
  local isSelfSelectGift = (self.payGiftInfo):IsSelfSelectGift()
  if isSelfSelectGift then
    local isSelfSelectChipGift = (self.payGiftInfo):IsSelfSelectChipGift()
  end
  local isSelfSelectGiftSelected = (self.payGiftInfo):GetSelfSelectGiftIsSelected()
  ;
  (((self.ui).tex_Cny_Normal).gameObject):SetActive(not isUseItemPay)
  ;
  ((self.ui).normal_cost):SetActive(isUseItemPay)
  if isUseItemPay then
    local giftCfg = ((self.payGiftInfo).giftCfgList)[1]
    local itemCfg = (ConfigData.item)[giftCfg.costId]
    -- DECOMPILER ERROR at PC76: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).Normal_img_Item).sprite = CRH:GetSprite(itemCfg.small_icon)
    -- DECOMPILER ERROR at PC82: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).Normal_tex_Cost).text = tostring(giftCfg.costCount)
  else
    do
      local payId = (((self.payGiftInfo).giftCfgList)[1]).payId
      do
        local priceStr, priceNum = payCtrl:GetPayPriceShow(payId)
        if priceNum ~= 0 then
          ((self.ui).tex_Cny_Normal):SetIndex(0, priceStr)
        else
          ;
          ((self.ui).tex_Cny_Normal):SetIndex(1)
        end
        local isTwoGift = giftCount > 1
        ;
        (((self.ui).btn_Buy_Super).gameObject):SetActive(isTwoGift)
        ;
        (((self.ui).texDes_Normal).gameObject):SetActive(isTwoGift)
        if isTwoGift then
          (((self.ui).tex_Cny_Super).gameObject):SetActive(not isUseItemPay)
          ;
          ((self.ui).super_cost):SetActive(isUseItemPay)
          if isUseItemPay then
            local giftCfg = ((self.payGiftInfo).giftCfgList)[2]
            local itemCfg = (ConfigData.item)[giftCfg.costId]
            -- DECOMPILER ERROR at PC149: Confused about usage of register: R12 in 'UnsetPending'

            ;
            ((self.ui).Super_img_Item).sprite = CRH:GetSprite(itemCfg.small_icon)
            -- DECOMPILER ERROR at PC155: Confused about usage of register: R12 in 'UnsetPending'

            ;
            ((self.ui).Super_tex_Cost).text = tostring(giftCfg.costCount)
          else
            local payId = (((self.payGiftInfo).giftCfgList)[2]).payId
            local priceStr = payCtrl:GetPayPriceShow(payId)
            -- DECOMPILER ERROR at PC166: Confused about usage of register: R12 in 'UnsetPending'

            ;
            ((self.ui).tex_Cny_Super).text = priceStr
          end
        end
        local defaultCfg = (self.payGiftInfo).defaultCfg
        ;
        ((self.ui).obj_BtnDis):SetActive(false)
        ;
        ((self.ui).obj_ItemDis):SetActive(false)
        ;
        (((self.ui).img_tag).gameObject):SetActive(false)
        do
          if not CS_ClientConsts.IsAudit and not (ConfigData.game_config).payGiftdiscountHide and isTwoGift then
            local giftCfg = ((self.payGiftInfo).giftCfgList)[2]
            -- DECOMPILER ERROR at PC206: Confused about usage of register: R12 in 'UnsetPending'

            ;
            ((self.ui).tex_BtnDis).text = "-" .. tostring(giftCfg.discount) .. "%"
            ;
            ((self.ui).obj_BtnDis):SetActive(giftCfg.discount ~= 0)
          end
          do
            if not CS_ClientConsts.IsAudit and not (ConfigData.game_config).payGiftdiscountHide and ((self.payGiftInfo).groupCfg).tagType > 0 then
              local groupCfg = (self.payGiftInfo).groupCfg
              if groupCfg.tagType == (ShopEnum.ePayGiftTag).Discount then
                ((self.ui).obj_ItemDis):SetActive(true)
                if ((Consts.GameChannelType).IsInland)() then
                  ((self.ui).tex_ItemDis):SetIndex(1, tostring(10 - groupCfg.tagValue / 10), "\n")
                else
                  ((self.ui).tex_ItemDis):SetIndex(0, tostring(groupCfg.tagValue), "\n")
                end
              else
                (((self.ui).img_tag).gameObject):SetActive(true)
                ;
                ((self.ui).img_tag):SetIndex(groupCfg.tagValue - 1)
                ;
                ((self.ui).tex_Tag):SetIndex(groupCfg.tagType - 2)
              end
            end
            local hasQz = false
            if isSelfSelectGift then
              ((self.ui).obj_rewardsNode):SetActive(true)
              ;
              (self.itemPool):HideAll()
              for k,v in pairs(defaultCfg.awardIds) do
                local itemCfg = (ConfigData.item)[v]
                local count = (defaultCfg.awardCounts)[k]
                local item = (self.itemPool):GetOne()
                item:InitItemWithCount(itemCfg, count)
                if itemCfg.id == ConstGlobalItem.PaidQZ or itemCfg.id == ConstGlobalItem.PaidItem then
                  hasQz = true
                end
              end
              if self._heroSelectNode == nil then
                ((self.ui).btn_SelectHero):SetActive(true)
                self._heroSelectNode = (UINCustomHeroGiftNode.New)()
                ;
                (self._heroSelectNode):Init((self.ui).btn_SelectHero)
                ;
                (self._heroSelectNode):BindGiftHeroSelectCallback(function()
    -- function num : 0_1_0 , upvalues : _ENV, self
    local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
    payGiftCtrl:SelfSelectGift((self.payGiftInfo).defaultCfg, self.payGiftInfo, function(selfSelectCfg)
      -- function num : 0_1_0_0 , upvalues : self
      if (self.payGiftInfo):GetSelfSelectGiftIsSelected() then
        self.selfSelectCfg = selfSelectCfg
        self:OnInitPayGift(self.payGiftInfo, self.quickBuyWindow)
      end
    end
)
  end
)
                ;
                ((self._heroSelectNode).transform):SetAsFirstSibling()
                local params = (self.payGiftInfo):GetSelfSelectGiftParams()
                local heroId = params ~= nil and (params[1]).param or nil
                if isSelfSelectChipGift then
                  (self._heroSelectNode):RefreshCustomChipGiftSelect(heroId, self.selfSelectCfg)
                else
                  (self._heroSelectNode):RefreshCustomHeroGiftSelect(heroId)
                end
              else
                (self._heroSelectNode):Show()
                ;
                ((self._heroSelectNode).transform):SetAsFirstSibling()
                local params = (self.payGiftInfo):GetSelfSelectGiftParams()
                local heroId = params ~= nil and (params[1]).param or nil
                if isSelfSelectChipGift then
                  (self._heroSelectNode):RefreshCustomChipGiftSelect(heroId, self.selfSelectCfg)
                else
                  (self._heroSelectNode):RefreshCustomHeroGiftSelect(heroId)
                end
              end
            else
              ((self.ui).obj_rewardsNode):SetActive(true)
              ;
              (self.itemPool):HideAll()
              for k,v in pairs(defaultCfg.awardIds) do
                local itemCfg = (ConfigData.item)[v]
                local count = (defaultCfg.awardCounts)[k]
                local item = (self.itemPool):GetOne()
                item:InitItemWithCount(itemCfg, count)
                if itemCfg.id == ConstGlobalItem.PaidQZ or itemCfg.id == ConstGlobalItem.PaidItem then
                  hasQz = true
                end
              end
            end
            if hasQz then
              ((self.ui).obj_JpQZ):SetActive(((Consts.GameChannelType).IsJp)())
              local textureName = ((self.payGiftInfo).groupCfg).icon
              ;
              (self.resloader):LoadABAssetAsync(PathConsts:GetShopGiftBgPath(textureName), function(texture)
    -- function num : 0_1_1 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(texture) then
      ((self.ui).img_GiftBag).texture = texture
    end
  end
)
              self:RefreshGiftPageDetail()
              self:RefreshPurchasePayGift()
              -- DECOMPILER ERROR: 22 unprocessed JMP targets
            end
          end
        end
      end
    end
  end
end

UINQuickPurchasePayGift.RefreshGiftPageDetail = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isSubscription, giftCfg, allDay = (self.payGiftInfo):TryGetGiftSubscriptionCfg()
  ;
  (((self.ui).btn_GiftPageDetail).gameObject):SetActive(isSubscription)
  ;
  (((((self.ui).tex_GiftPageDetail).transform).parent).gameObject):SetActive(isSubscription)
  if isSubscription then
    if (self.payGiftInfo):IsCheckNextGift() then
      ((self.ui).tex_GiftPageDetail):SetIndex(1)
    else
      if (self.payGiftInfo):IsOrderOfManyTypeGift() then
        ((self.ui).tex_GiftPageDetail):SetIndex(2, tostring(allDay))
      else
        ;
        ((self.ui).tex_GiftPageDetail):SetIndex(0, tostring(allDay))
      end
    end
    return 
  end
  local isRandom, giftCfg = (self.payGiftInfo):TryGetGiftRaffleCfg()
  ;
  (((self.ui).btn_GiftPageDetail).gameObject):SetActive(isRandom)
  ;
  (((((self.ui).tex_GiftPageDetail).transform).parent).gameObject):SetActive(isRandom)
  ;
  ((self.ui).tex_GiftPageDetail):SetIndex(3)
end

UINQuickPurchasePayGift.RefreshPurchasePayGift = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local isSoldOut = (self.payGiftInfo):IsSoldOut()
  local isLimit, times, limitTimes = (self.payGiftInfo):GetLimitBuyCount()
  ;
  ((self.ui).btnGroup):SetActive(not isSoldOut)
  ;
  ((self.ui).soldOut):SetActive(isSoldOut)
  ;
  ((self.ui).obj_limit):SetActive(isLimit)
  do
    if not (self.payGiftInfo).needRefresh or not 1 then
      local index = not isLimit or 0
    end
    ;
    ((self.ui).text_limit):SetIndex(index, tostring(limitTimes - times))
    ;
    ((self.ui).obj_time):SetActive(false)
    if self.timerId ~= nil then
      TimerManager:StopTimer(self.timerId)
      self.timerId = nil
    end
    if (self.payGiftInfo):NeedRefreshTime() then
      ((self.ui).obj_time):SetActive(true)
      self.lastRefreshTime = (math.floor)((self.payGiftInfo):GetPayGiftNextTime())
      self.timerId = TimerManager:StartTimer(1, self.ShowGiftCutDown, self, false, false, false)
      self:ShowGiftCutDown()
    else
      local flag, startTime, endTime = (self.payGiftInfo):IsUnlockTimeCondition()
      if flag and PlayerDataCenter.timestamp < endTime then
        ((self.ui).obj_time):SetActive(true)
        self.lastRefreshTime = endTime
        self.timerId = TimerManager:StartTimer(1, self.ShowGiftCutDown, self, false, false, false)
        self:ShowGiftCutDown()
      end
    end
  end
end

UINQuickPurchasePayGift.ShowGiftCutDown = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local time = self.lastRefreshTime - PlayerDataCenter.timestamp
  if time < 0 then
    if (self.payGiftInfo):IsUnlock() and (self.payGiftInfo).initPreGroupId == ((self.payGiftInfo).groupCfg).id then
      self:RefreshPurchasePayGift()
    end
    return 
  end
  local d, h, m, s = TimeUtil:TimestampToTimeInter(time, false, true)
  if d > 0 then
    ((self.ui).text_time):SetIndex(0, tostring(d), tostring(h))
  else
    if h > 0 then
      ((self.ui).text_time):SetIndex(1, tostring(h), tostring(m))
    else
      if m > 0 then
        ((self.ui).text_time):SetIndex(2, tostring(m))
      else
        ;
        ((self.ui).text_time):SetIndex(2, tostring(1))
      end
    end
  end
end

UINQuickPurchasePayGift.OnPayGiftChange = function(self, id)
  -- function num : 0_5 , upvalues : _ENV
  if id ~= ((self.payGiftInfo).groupCfg).id then
    return 
  end
  local otherPayGiftInfo = ((ControllerManager:GetController(ControllerTypeId.PayGift)).dataDic)[(self.payGiftInfo).initPreGroupId]
  if (self.quickBuyWindow).active and self.active and (self.payGiftInfo).initPreGroupId ~= ((self.payGiftInfo).groupCfg).id and not otherPayGiftInfo:IsSoldOut() then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.QuickBuy, true)
  else
    self:RefreshPurchasePayGift()
  end
end

UINQuickPurchasePayGift.OnPayGiftCondition = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if (self.quickBuyWindow).active and self.active and not (self.payGiftInfo):IsUnlock() then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.QuickBuy, true)
  end
end

UINQuickPurchasePayGift.OnClickBuyNormal = function(self)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  if (self.quickBuyWindow).isSlideOuting then
    return 
  end
  if not (self.payGiftInfo):IsUnlock() then
    return 
  end
  local giftCfg = ((self.payGiftInfo).giftCfgList)[1]
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  local isSelfSelectGift = (self.payGiftInfo):IsSelfSelectGift()
  local isSelfSelectGiftSelected = (self.payGiftInfo):GetSelfSelectGiftIsSelected()
  if isSelfSelectGift then
    if not isSelfSelectGiftSelected then
      if (self.payGiftInfo):IsSelfSelectChipGift() then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(419))
      else
        if (self.payGiftInfo):IsSelfSelectHeroGift() then
          (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(418))
        end
      end
      return 
    end
    payGiftCtrl:SendBuyGifit(giftCfg, (self.payGiftInfo):GetSelfSelectGiftParams(), function()
    -- function num : 0_7_0 , upvalues : _ENV
    (UIUtil.OnClickBack)()
  end
)
    return 
  end
  payGiftCtrl:SendBuyGifit(giftCfg, nil, function()
    -- function num : 0_7_1 , upvalues : _ENV
    (UIUtil.OnClickBack)()
  end
)
end

UINQuickPurchasePayGift.OnClickBuySuper = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if (self.quickBuyWindow).isSlideOuting then
    return 
  end
  if not (self.payGiftInfo):IsUnlock() then
    return 
  end
  local giftCfg = ((self.payGiftInfo).giftCfgList)[2]
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  payGiftCtrl:SendBuyGifit(giftCfg, nil, function()
    -- function num : 0_8_0 , upvalues : _ENV
    (UIUtil.OnClickBack)()
  end
)
end

UINQuickPurchasePayGift.OnClickGiftPageDetial = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GiftPageDetail, function(win)
    -- function num : 0_9_0 , upvalues : self
    win:InitGiftPageDetail(self.payGiftInfo)
  end
)
end

UINQuickPurchasePayGift.OnHide = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  ;
  (base.OnHide)(self)
end

UINQuickPurchasePayGift.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.PayGiftChange, self.__OnPayGiftChange)
  MsgCenter:RemoveListener(eMsgEventId.PayGiftItemPreConfition, self.__OnPayGiftCondition)
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if self._heroSelectNode ~= nil then
    (self._heroSelectNode):Delete()
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINQuickPurchasePayGift

