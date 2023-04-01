-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopThemeSkinItem = class("UINShopThemeSkinItem", UIBaseNode)
local base = UIBaseNode
UINShopThemeSkinItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_shopItem, self, self._OnClick)
end

UINShopThemeSkinItem.InitItem = function(self, resloader, OnClickGoodItem)
  -- function num : 0_1
  self.resloader = resloader
  self.onClickGoodItem = OnClickGoodItem
end

UINShopThemeSkinItem.InitNormalGoodsItem = function(self, goodData, parentNode, purchaseRoot)
  -- function num : 0_2
  self.goodData = goodData
  self.parentNode = parentNode
  self.purchaseRoot = purchaseRoot
  self:RefreshGoods()
end

UINShopThemeSkinItem._OnClick = function(self)
  -- function num : 0_3
  if (self.goodData).isSoldOut then
    return 
  end
  if self.onClickGoodItem ~= nil then
    (self.onClickGoodItem)(self.goodData)
  end
end

UINShopThemeSkinItem.RefreshGoods = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (((self.ui).img_SkinTheme).gameObject):SetActive(false)
  local picPath = (self.goodData).pic_skinshop
  if (string.IsNullOrEmpty)((self.goodData).pic_skinshop) then
    picPath = (self.goodData).pic
  end
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetHeroSkinThemePicPath(picPath), function(Texture)
    -- function num : 0_4_0 , upvalues : _ENV, self
    if Texture == nil or IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SkinTheme).texture = Texture
    ;
    (((self.ui).img_SkinTheme).gameObject):SetActive(true)
  end
)
end

UINShopThemeSkinItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINShopThemeSkinItem

