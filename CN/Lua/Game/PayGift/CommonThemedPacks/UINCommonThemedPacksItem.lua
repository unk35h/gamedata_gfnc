-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonThemedPacksItem = class("UINCommonThemedPacksItem", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local CS_ClientConsts = CS.ClientConsts
UINCommonThemedPacksItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self._resloader = ((CS.ResLoader).Create)()
end

UINCommonThemedPacksItem.InitCommonThemedPacksItem = function(self, payGiftInfo, soldOutCallback, showQuickBox)
  -- function num : 0_1 , upvalues : _ENV, CS_ClientConsts, ShopEnum
  self._payGiftInfo = payGiftInfo
  self._soldOutCallback = soldOutCallback
  self._showQuickBox = showQuickBox
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_GiftName).text = (LanguageUtil.GetLocaleText)((payGiftInfo.groupCfg).name)
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
  local giftCfg = (payGiftInfo.giftCfgList)[1]
  local payUnit = payCtrl:GetPayShowUnitStr()
  local payPrice = payCtrl:GetPayPriceInter(giftCfg.payId)
  ;
  ((self.ui).tex_Price):SetIndex(0, payUnit, tostring(payPrice))
  ;
  (((self.ui).img_Gift).gameObject):SetActive(false)
  local textureName = (payGiftInfo.groupCfg).icon
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetShopGiftBgPath(textureName), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(texture) then
      ((self.ui).img_Gift).texture = texture
      ;
      (((self.ui).img_Gift).gameObject):SetActive(true)
    end
  end
)
  ;
  (((self.ui).discount).gameObject):SetActive(false)
  ;
  (((self.ui).tag).gameObject):SetActive(false)
  do
    if not CS_ClientConsts.IsAudit and not (ConfigData.game_config).payGiftdiscountHide and (payGiftInfo.groupCfg).tagType > 0 then
      local groupCfg = payGiftInfo.groupCfg
      if groupCfg.tagType == (ShopEnum.ePayGiftTag).Discount then
        (((self.ui).discount).gameObject):SetActive(true)
        if ((Consts.GameChannelType).IsInland)() then
          ((self.ui).tex_Discount):SetIndex(1, tostring(10 - groupCfg.tagValue / 10))
        else
          ;
          ((self.ui).tex_Discount):SetIndex(0, tostring(groupCfg.tagValue))
        end
      else
        ;
        (((self.ui).tag).gameObject):SetActive(true)
        ;
        ((self.ui).tag):SetIndex(groupCfg.tagValue - 1)
        ;
        ((self.ui).tex_Tag):SetIndex(groupCfg.tagType - 2)
      end
    end
    ;
    (self._itemPool):HideAll()
    for i,itemId in ipairs(giftCfg.awardIds) do
      local itemCount = (giftCfg.awardCounts)[i]
      local item = (self._itemPool):GetOne()
      local itemCfg = (ConfigData.item)[itemId]
      item:InitItemWithCount(itemCfg, itemCount)
      item:SetNotNeedAnyJump(true)
    end
    local isPeriodcity = (self._payGiftInfo):IsPeriodicityPayGift()
    if (self._payGiftInfo):IsPeriodicityPayGift() then
      self._endTime = (self._payGiftInfo):GetPayGiftNextTime()
    else
      local flag, startTime, endTime = (self._payGiftInfo):IsUnlockTimeCondition()
      self._endTime = endTime
    end
    do
      if self._timerId == nil then
        self._timerId = TimerManager:StartTimer(1, self.__CountDown, self, false)
      end
      self:__CountDown()
      self:RefreshCommonThemedPacksItem()
    end
  end
end

UINCommonThemedPacksItem.RefreshCommonThemedPacksItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isLimit, buyCount, limitCount = (self._payGiftInfo):GetLimitBuyCount()
  if not isLimit then
    ((self.ui).limit):SetActive(false)
    ;
    ((self.ui).img_SoldOut):SetActive(false)
  else
    ;
    ((self.ui).limit):SetActive(true)
    local isPeriodcity = (self._payGiftInfo):IsPeriodicityPayGift()
    ;
    ((self.ui).tex_limit):SetIndex(isPeriodcity and 1 or 0, tostring(limitCount - buyCount))
    ;
    ((self.ui).img_SoldOut):SetActive(limitCount == buyCount)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINCommonThemedPacksItem.__CountDown = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityFrameUtil
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  if self._endTime == nil then
    ((self.ui).tex_Time).text = nil
    return 
  end
  local time = self._endTime - PlayerDataCenter.timestamp
  if time < 0 then
    return 
  end
  local timeStr = (ActivityFrameUtil.GetCountdownTimeStr)(self._endTime)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = timeStr
end

UINCommonThemedPacksItem.OnClickBuy = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local isLimit, buyCount, limitCount = (self._payGiftInfo):GetLimitBuyCount()
  if isLimit and buyCount == limitCount then
    return 
  end
  local buyEndFunc = function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    if (self._payGiftInfo):IsSoldOut() and self._soldOutCallback ~= nil then
      (self._soldOutCallback)()
      return 
    end
    self:RefreshCommonThemedPacksItem()
  end

  if self._showQuickBox then
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
    -- function num : 0_4_1 , upvalues : self, buyEndFunc
    if window == nil then
      return 
    end
    window:SlideIn()
    window:InitGiftItemList(self._payGiftInfo, buyEndFunc)
  end
)
    return 
  end
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  payGiftCtrl:SendBuyGifitInfo(self._payGiftInfo, nil, buyEndFunc)
end

UINCommonThemedPacksItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINCommonThemedPacksItem

