-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHomeBannerIndexItem = class("UICarouselBanner", UIBaseNode)
UINHomeBannerIndexItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHomeBannerIndexItem.SetBannerIndexItemColor = function(self, color)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_indexItem).color = color
end

return UINHomeBannerIndexItem

