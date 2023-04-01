-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopLeftPageSub = class("UINShopLeftPageSub", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopLeftPageSub.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sub, self, self.OnClickPage)
  self.__OnTimerRefresh = BindCallback(self, self.RefreshPageTime)
end

UINShopLeftPageSub.InitPageSub = function(self, shopId, clickFunc, parentBtn)
  -- function num : 0_1 , upvalues : _ENV
  self.shopId = shopId
  self.shopCfg = (ConfigData.shop)[shopId]
  self.clickFunc = clickFunc
  self.parentBtn = parentBtn
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self.shopCfg).name)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Buttom).color = (self.ui).color_unSelectImg
  ;
  ((self.ui).obj_RedDot):SetActive(false)
  ;
  ((self.ui).obj_GiftTimeLimit):SetActive(false)
  self:RefreshPageSubRedDotState()
  self:RefreshState(false)
end

UINShopLeftPageSub.OnClickPage = function(self)
  -- function num : 0_2
  if self.clickFunc ~= nil then
    (self.clickFunc)((self.shopCfg).id)
  end
end

UINShopLeftPageSub.RefreshState = function(self, isSelected)
  -- function num : 0_3 , upvalues : ShopEnum
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if isSelected then
    ((self.ui).img_Buttom).color = (self.ui).color_selectImg
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_selectedText
  else
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Buttom).color = (self.ui).color_unSelectImg
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_unSelectText
  end
  if self.shopId == (ShopEnum.ShopId).gift and not isSelected then
    self:RefreshPageSubRedDotState()
  end
end

UINShopLeftPageSub.RefreshPageSubRedDotState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_RedDot):SetActive(false)
  ;
  ((self.ui).blueDot):SetActive(false)
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, (self.shopCfg).id)
  local flag = not ok or shopNode:GetRedDotCount() > 0
  local isBlue = (self.shopCtrl):IsShopBlueReddot((self.shopCfg).id)
  self.isHaveRed = false
  do
    if flag then
      if not isBlue or not (self.ui).blueDot then
        local reddotObj = (self.ui).obj_RedDot
      end
      reddotObj:SetActive(true)
      self.isHaveRed = true
    end
    self:RefreshNewGiftTag4Page(flag)
    do return flag, isBlue end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINShopLeftPageSub.RefreshTimelimitTag4Sub = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local ishaveTimeLimit, startTime, endTime = (self.shopCtrl):GetIsThisShopHasTimeLimit(self.shopId)
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
  ;
  ((self.ui).obj_GiftTimeLimit):SetActive(false)
  if payGiftCtrl:CheckPageIdIsGiftShop(self.shopId) and not self.isHaveRed and not self.isHaveNewGift and ishaveTimeLimit then
    ((self.ui).obj_GiftTimeLimit):SetActive(true)
    self.latestTime = endTime
    self:RefreshPageTime()
    ;
    (self.shopCtrl):AddShopTimerCallback(self.__OnTimerRefresh, "pageSub")
  end
  ;
  ((self.ui).img_TimeIcon):SetActive(ishaveTimeLimit)
end

UINShopLeftPageSub.RefreshPageTime = function(self)
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

UINShopLeftPageSub.RefreshNewGiftTag4Page = function(self, isHaveRed)
  -- function num : 0_7 , upvalues : _ENV
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  self.isHaveNewGift = false
  ;
  ((self.ui).obj_NewGift):SetActive(false)
  if payGiftCtrl:CheckPageIdIsGiftShop(self.shopId) then
    local isHaveNewGift = payGiftCtrl:IsHaveNewGiftInShop(self.shopId)
    if not IsNull((self.ui).obj_NewGift) and isHaveNewGift then
      do
        ((self.ui).obj_NewGift):SetActive(not isHaveRed)
        if isHaveNewGift then
          self.isHaveNewGift = true
          ;
          ((self.ui).blueDot):SetActive(false)
        end
        self:RefreshTimelimitTag4Sub()
      end
    end
  end
end

UINShopLeftPageSub.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (self.shopCtrl):RemoveShopTimerCallback(self.__OnTimerRefresh)
  ;
  (base.OnDelete)(self)
end

return UINShopLeftPageSub

