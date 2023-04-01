-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopNormalGiftItem = class("UINShopNormalGiftItem", UIBaseNode)
local base = UIBaseNode
local CS_ClientConsts = CS.ClientConsts
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopNormalGiftItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, false)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CNY, self, self.OnClickGiftBuy)
  self.__ShowGiftCutDown = BindCallback(self, self.ShowGiftCutDown)
end

UINShopNormalGiftItem.InitGiftItem = function(self, data, purchaseRoot, resloader, refreshFunc)
  -- function num : 0_1 , upvalues : _ENV, CS_ClientConsts, ShopEnum
  self.data = data
  self.purchaseRoot = purchaseRoot
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(((self.data).groupCfg).name)
  self.refreshFunc = refreshFunc
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
  local showOldPrice, oldPrice = data:TryGetPayGiftOldPrice()
  ;
  (((self.ui).tex_oldPrice).gameObject):SetActive(showOldPrice)
  if (self.data):IsUseItemPay() then
    (((self.ui).imgIcon).gameObject):SetActive(true)
    ;
    ((self.ui).tex_curPrice):SetIndex(1, tostring(((self.data).defaultCfg).costCount))
    local itemCfg = (ConfigData.item)[((self.data).defaultCfg).costId]
    -- DECOMPILER ERROR at PC59: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).imgIcon).sprite = CRH:GetSprite(itemCfg.small_icon)
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R9 in 'UnsetPending'

    if showOldPrice then
      ((self.ui).tex_oldPrice).text = tostring(oldPrice)
    end
  else
    do
      ;
      (((self.ui).imgIcon).gameObject):SetActive(false)
      local payId = ((self.data).defaultCfg).payId
      local priceStr, priceNum = payCtrl:GetPayPriceShow(payId)
      if priceNum == 0 then
        ((self.ui).tex_curPrice):SetIndex(0)
      else
        ;
        ((self.ui).tex_curPrice):SetIndex(1, priceStr)
      end
      if showOldPrice then
        local priceUnit = payCtrl:GetPayShowUnitStr()
        local oldPriceStr = priceUnit .. oldPrice
        -- DECOMPILER ERROR at PC104: Confused about usage of register: R13 in 'UnsetPending'

        ;
        ((self.ui).tex_oldPrice).text = oldPriceStr
      end
      do
        self._finimalGiftIcon = ((self.data).groupCfg).icon
        local textureName = ((self.data).groupCfg).icon
        ;
        (((self.ui).img_GiftBag).gameObject):SetActive(false)
        resloader:LoadABAssetAsync(PathConsts:GetShopGiftBgPath(textureName), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, textureName, self
    if not IsNull(texture) and textureName == self._finimalGiftIcon then
      (((self.ui).img_GiftBag).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_GiftBag).texture = texture
    end
  end
)
        ;
        (((self.ui).obj_Discount).gameObject):SetActive(false)
        ;
        (((self.ui).img_tag).gameObject):SetActive(false)
        do
          if not CS_ClientConsts.IsAudit and not (ConfigData.game_config).payGiftdiscountHide and ((self.data).groupCfg).tagType > 0 then
            local groupCfg = (self.data).groupCfg
            if groupCfg.tagType == (ShopEnum.ePayGiftTag).Discount then
              (((self.ui).obj_Discount).gameObject):SetActive(true)
              if ((Consts.GameChannelType).IsInland)() then
                ((self.ui).tex_Discount):SetIndex(1, tostring(10 - groupCfg.tagValue / 10))
              else
                ;
                ((self.ui).tex_Discount):SetIndex(0, tostring(groupCfg.tagValue))
              end
            else
              ;
              (((self.ui).img_tag).gameObject):SetActive(true)
              ;
              ((self.ui).img_tag):SetIndex(groupCfg.tagValue - 1)
              ;
              ((self.ui).tex_Tag):SetIndex(groupCfg.tagType - 2)
            end
          end
          self:RefreshGiftItem()
        end
      end
    end
  end
end

UINShopNormalGiftItem.RefreshGiftItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isSoldOut = (self.data):IsSoldOut()
  local isLimit, times, limitTimes = (self.data):GetLimitBuyCount()
  ;
  (((self.ui).obj_SoldOut).gameObject):SetActive(isSoldOut)
  ;
  ((self.ui).obj_limit):SetActive(isLimit)
  do
    if not (self.data).needRefresh or not 1 then
      local index = not isLimit or 0
    end
    ;
    ((self.ui).text_limit):SetIndex(index, tostring(limitTimes - times))
    ;
    ((self.ui).obj_time):SetActive(false)
    ;
    (self.shopCtrl):RemoveShopTimerCallback(self.__ShowGiftCutDown)
    if (self.data):NeedRefreshTime() then
      ((self.ui).obj_time):SetActive(true)
      self.lastRefreshTime = (math.floor)((self.data):GetPayGiftNextTime())
      ;
      (self.shopCtrl):AddShopTimerCallback(self.__ShowGiftCutDown, "GiftItem")
      self:ShowGiftCutDown()
    else
      local flag, startTime, endTime = (self.data):IsUnlockTimeCondition()
      if flag and PlayerDataCenter.timestamp < endTime then
        ((self.ui).obj_time):SetActive(true)
        self.lastRefreshTime = endTime
        ;
        (self.shopCtrl):AddShopTimerCallback(self.__ShowGiftCutDown, "GiftItem")
        self:ShowGiftCutDown()
      end
    end
    do
      local isNewGift = (self.data):IsNewGiftInShop()
      ;
      ((self.ui).obj_NewGift):SetActive(isNewGift)
    end
  end
end

UINShopNormalGiftItem.ShowGiftCutDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local time = self.lastRefreshTime - PlayerDataCenter.timestamp
  if time < 0 then
    if self.refreshFunc ~= nil then
      (self.refreshFunc)()
    end
    ;
    (self.shopCtrl):RemoveShopTimerCallback(self.__ShowGiftCutDown)
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

UINShopNormalGiftItem.OnClickGiftBuy = function(self)
  -- function num : 0_4 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
    -- function num : 0_4_0 , upvalues : self
    window:SlideIn()
    window:InitBuyPayGift(self.data)
  end
)
  ;
  ((self.ui).obj_NewGift):SetActive(false)
end

UINShopNormalGiftItem.SetGiftItemReddot = function(self, flag)
  -- function num : 0_5
  ((self.ui).redDot):SetActive(flag)
end

UINShopNormalGiftItem.OnHide = function(self)
  -- function num : 0_6 , upvalues : base
  (self.shopCtrl):RemoveShopTimerCallback(self.__ShowGiftCutDown)
  ;
  (base.OnHide)(self)
end

UINShopNormalGiftItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (self.shopCtrl):RemoveShopTimerCallback(self.__ShowGiftCutDown)
  ;
  (base.OnDelete)(self)
end

return UINShopNormalGiftItem

