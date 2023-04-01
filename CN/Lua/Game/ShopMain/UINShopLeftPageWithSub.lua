-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopLeftPageWithSub = class("UINShopLeftPageWithSub", UIBaseNode)
local base = UIBaseNode
local UINShopLeftPageSub = require("Game.ShopMain.UINShopLeftPageSub")
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopLeftPageWithSub.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINShopLeftPageSub
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.subPool = (UIItemPool.New)(UINShopLeftPageSub, (self.ui).obj_btn_Sub)
  ;
  ((self.ui).obj_btn_Sub):SetActive(false)
  self.__OnTimerRefresh = BindCallback(self, self.RefreshPageTime)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Main, self, self.OnClickPage)
end

UINShopLeftPageWithSub.InitPage = function(self, groupCfg, clickShopFunc, resloader, uishop, isBeforeUnlockShop, subIds)
  -- function num : 0_1 , upvalues : _ENV
  self.leftPageCfg = groupCfg
  self.clickShopFunc = clickShopFunc
  ;
  ((self.ui).obj_RedDot):SetActive(false)
  self.subIds = subIds
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self.leftPageCfg).name)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_NameEn).text = (LanguageUtil.GetLocaleText)((self.leftPageCfg).name_en)
  ;
  (self.subPool):HideAll()
  self.payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  for _,shopId in ipairs(self.subIds) do
    if (not isBeforeUnlockShop or ((ConfigData.game_config).shopShowBeforeUnlockDic)[shopId]) and (self.shopCtrl):ShopIsUnlock(shopId) then
      local isHaveTime, _, limitTime = (self.shopCtrl):GetIsThisShopHasTimeLimit(shopId)
      if isHaveTime then
        uishop:SetNeedRefreshTm(limitTime)
      end
      local item = (self.subPool):GetOne(true)
      ;
      (item.gameObject):SetActive(true)
      ;
      (item.transform):SetParent(((self.ui).subList).transform)
      item:InitPageSub(shopId, self.clickShopFunc, self)
      -- DECOMPILER ERROR at PC81: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (item.gameObject).name = shopId
    end
  end
  if #(self.subPool).listItem <= 0 then
    self:Hide()
    return nil
  end
  self:RefreshRedDotState()
  -- DECOMPILER ERROR at PC104: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = (AtlasUtil.GetSpriteFromAtlas)("UI_Shop", (self.leftPageCfg).icon, resloader)
  ;
  ((self.ui).img_Buttom):SetIndex(1)
  -- DECOMPILER ERROR at PC114: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).color = (self.ui).color_selectedText
  -- DECOMPILER ERROR at PC119: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_NameEn).color = (self.ui).color_selectedText
  ;
  ((self.ui).subList):SetActive(false)
  self:RefreshState(false)
  return (self.subPool).listItem
end

UINShopLeftPageWithSub.OnClickPage = function(self)
  -- function num : 0_2
  if ((self.ui).subList).activeSelf then
    ((self.ui).subList):SetActive(false)
  else
    ;
    ((self.ui).subList):SetActive(true)
    ;
    (((self.subPool).listItem)[1]):OnClickPage()
  end
end

UINShopLeftPageWithSub.RefreshState = function(self, isSelected)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).subList):SetActive(isSelected)
  if isSelected then
    ((self.ui).img_Buttom):SetIndex(1)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_selectedText
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_NameEn).color = (self.ui).color_selectedText
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_selectedText
  else
    ;
    ((self.ui).img_Buttom):SetIndex(0)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_unSelectText
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_NameEn).color = (self.ui).color_unSelectText
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_unSelectText
  end
  if not isSelected then
    for i,shopId in ipairs(self.subIds) do
      if (self.payGiftCtrl):CheckPageIdIsGiftShop(shopId) then
        self:RefreshRedDotState()
        break
      end
    end
  end
end

UINShopLeftPageWithSub.RefreshRedDotState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_RedDot):SetActive(false)
  ;
  ((self.ui).blueDot):SetActive(false)
  local flag = false
  local isBlue = true
  for i,v in ipairs((self.subPool).listItem) do
    local tempFlag, tempIsBlue = v:RefreshPageSubRedDotState()
    if tempFlag then
      flag = true
      if not tempIsBlue then
        isBlue = false
      end
    end
  end
  self.redDotIsOpen = false
  do
    if flag then
      if not isBlue or not (self.ui).blueDot then
        local reddotObj = (self.ui).obj_RedDot
      end
      reddotObj:SetActive(true)
      self.redDotIsOpen = true
    end
    self:RefreshNewGiftTag4Page(flag)
  end
end

UINShopLeftPageWithSub.RefreshTimelimitTag4PageWithSub = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local ishaveTimeLimit = false
  local now = PlayerDataCenter.timestamp
  local latestTime = math.maxinteger
  local isPayGift = false
  for i,shopId in ipairs(self.subIds) do
    local hav, inTime, outTime = (self.shopCtrl):GetIsThisShopHasTimeLimit(shopId)
    if hav then
      latestTime = (math.min)(latestTime, outTime)
      ishaveTimeLimit = true
    end
    isPayGift = (self.payGiftCtrl):CheckPageIdIsGiftShop(shopId)
  end
  if ishaveTimeLimit then
    if self.updateTagTimerId ~= nil then
      TimerManager:StopTimer(self.updateTagTimerId)
      self.updateTagTimerId = nil
    end
    self.updateTagTimerId = TimerManager:StartTimer(latestTime - now + 1, function()
    -- function num : 0_5_0 , upvalues : _ENV
    local shopWindow = UIManager:GetWindow(UIWindowTypeID.ShopMain)
    if shopWindow == nil then
      return 
    end
    shopWindow.autoJumpPageId = shopWindow.seletecPageId
    shopWindow:InitShop(shopWindow.seletecShopId)
  end
, self, true, false, false)
  end
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
  ;
  ((self.ui).obj_GiftTimeLimit):SetActive(false)
  if isPayGift and not self.redDotIsOpen and not self.isHaveNewGift and ishaveTimeLimit then
    ((self.ui).obj_GiftTimeLimit):SetActive(true)
    self.latestTime = latestTime
    self:RefreshPageTime()
    ;
    (self.shopCtrl):AddShopTimerCallback(self.__OnTimerRefresh, "pageWithSub")
  end
  ;
  ((self.ui).img_TimeIcon):SetActive(ishaveTimeLimit)
end

UINShopLeftPageWithSub.RefreshPageTime = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.latestTime == nil or IsNull((self.ui).tex_GiftTimeLimit) then
    return 
  end
  local remaindTime = self.latestTime - PlayerDataCenter.timestamp
  if remaindTime < 0 then
    remaindTime = 0
  end
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
  if d > 0 then
    ((self.ui).tex_GiftTimeLimit):SetIndex(0, tostring(d))
  else
    if h > 0 then
      ((self.ui).tex_GiftTimeLimit):SetIndex(1, tostring(h))
    else
      if m > 0 then
        ((self.ui).tex_GiftTimeLimit):SetIndex(2, tostring(m))
      else
        ;
        ((self.ui).tex_GiftTimeLimit):SetIndex(3, tostring(s))
      end
    end
  end
end

UINShopLeftPageWithSub.RefreshNewGiftTag4Page = function(self, isHaveRed)
  -- function num : 0_7 , upvalues : _ENV
  self.isHaveNewGift = false
  ;
  ((self.ui).obj_NewGift):SetActive(false)
  for i,shopId in ipairs(self.subIds) do
    if (self.payGiftCtrl):CheckPageIdIsGiftShop(shopId) then
      local isHaveNewGift = (self.payGiftCtrl):IsHaveNewGiftInShop(shopId)
      if not IsNull((self.ui).obj_NewGift) and isHaveNewGift then
        do
          ((self.ui).obj_NewGift):SetActive(not isHaveRed)
          if isHaveNewGift then
            ((self.ui).blueDot):SetActive(false)
            self.isHaveNewGift = true
            break
          end
          -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  self:RefreshTimelimitTag4PageWithSub()
end

UINShopLeftPageWithSub.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self.updateTagTimerId ~= nil then
    TimerManager:StopTimer(self.updateTagTimerId)
    self.updateTagTimerId = nil
  end
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
  ;
  (self.subPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINShopLeftPageWithSub

