-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopLeftPage = class("UINShopLeftPage", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopLeftPage.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Page, self, self.OnClickPage)
  ;
  ((self.ui).obj_NewGift):SetActive(false)
end

UINShopLeftPage.InitPage = function(self, groupCfg, clickShopFunc, resloader, specialId)
  -- function num : 0_1 , upvalues : _ENV
  self.leftPageCfg = groupCfg
  self.clickShopFunc = clickShopFunc
  ;
  ((self.ui).obj_RedDot):SetActive(false)
  ;
  ((self.ui).img_Buttom):SetIndex(0)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = (AtlasUtil.GetSpriteFromAtlas)("UI_Shop", (self.leftPageCfg).icon, resloader)
  local shopId = nil
  if specialId == nil or specialId == 0 then
    shopId = ((self.leftPageCfg).sub_ids)[1]
  else
    shopId = specialId
  end
  self.shopCfg = (ConfigData.shop)[shopId]
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self.shopCfg).name)
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_NameEn).text = (LanguageUtil.GetLocaleText)((self.shopCfg).name_en)
  self:RefreshRedDotState()
  self:RefreshTimelimitTag4Page()
  self:RefreshState(false)
end

UINShopLeftPage.OnClickPage = function(self)
  -- function num : 0_2
  if self.shopCfg ~= nil and self.clickShopFunc ~= nil then
    (self.clickShopFunc)((self.shopCfg).id)
  end
end

UINShopLeftPage.RefreshState = function(self, isSelected)
  -- function num : 0_3 , upvalues : ShopEnum
  if isSelected then
    ((self.ui).img_Buttom):SetIndex(1)
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_selectedText
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_NameEn).color = (self.ui).color_selectedText
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_selectedText
  else
    ;
    ((self.ui).img_Buttom):SetIndex(0)
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_unSelectText
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_NameEn).color = (self.ui).color_unSelectText
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_unSelectText
  end
  if (self.shopCfg).id == (ShopEnum.ShopId).gift and not isSelected then
    self:RefreshRedDotState()
  end
  if (self.shopCfg).id == (ShopEnum.ShopId).skin and not isSelected then
    self:RefreshRedDotState()
  end
  return isSelected
end

UINShopLeftPage.RefreshRedDotState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_RedDot):SetActive(false)
  ;
  ((self.ui).blueDot):SetActive(false)
  local isHaveRed = false
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, (self.shopCfg).id)
  if ok and shopNode:GetRedDotCount() > 0 then
    if (self.shopCtrl):IsShopBlueReddot((self.shopCfg).id) then
      ((self.ui).blueDot):SetActive(true)
    else
      ;
      ((self.ui).obj_RedDot):SetActive(true)
      isHaveRed = true
    end
  end
  self:RefreshNewGiftTag4Page(isHaveRed)
end

UINShopLeftPage.RefreshTimelimitTag4Page = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local ishaveTimeLimit = false
  for i,shopId in ipairs((self.leftPageCfg).sub_ids) do
    if (self.shopCtrl):GetIsThisShopHasTimeLimit(shopId) then
      ishaveTimeLimit = true
      break
    end
  end
  do
    if (self.leftPageCfg).special_id ~= 0 and (self.shopCtrl):GetIsThisShopHasTimeLimit((self.leftPageCfg).special_id) then
      ishaveTimeLimit = true
    end
    local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
    if payGiftCtrl:CheckPageIdIsGiftShop((self.shopCfg).id) then
      ishaveTimeLimit = false
    end
    ;
    ((self.ui).img_TimeIcon):SetActive(ishaveTimeLimit)
  end
end

UINShopLeftPage.RefreshNewGiftTag4Page = function(self, isHaveRed)
  -- function num : 0_6 , upvalues : ShopEnum, _ENV
  if (self.shopCfg).id == (ShopEnum.ShopId).gift then
    local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
    local isHaveNewGift = payGiftCtrl:IsHaveNewGiftInShop()
    if isHaveNewGift then
      do
        ((self.ui).obj_NewGift):SetActive(not isHaveRed)
        if isHaveNewGift then
          ((self.ui).blueDot):SetActive(false)
        end
        if (self.shopCfg).id == (ShopEnum.ShopId).skin then
          local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
          shopCtrl:IsHaveNewSkinGoodItemInShop(function(isHaveNewGift)
    -- function num : 0_6_0 , upvalues : self, isHaveRed
    if isHaveNewGift then
      ((self.ui).obj_NewGift):SetActive(not isHaveRed)
      if isHaveNewGift then
        ((self.ui).blueDot):SetActive(false)
      end
    end
  end
)
        end
      end
    end
  end
end

UINShopLeftPage.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINShopLeftPage

