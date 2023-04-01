-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayAlbumPageItem = class("UINWhiteDayAlbumPageItem", UIBaseNode)
local base = UIBaseNode
UINWhiteDayAlbumPageItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWhiteDayAlbumPageItem.SetIsSelected = function(self, bool)
  -- function num : 0_1
  if bool then
    ((self.ui).img_Page):SetIndex(1)
  else
    ;
    ((self.ui).img_Page):SetIndex(0)
  end
end

UINWhiteDayAlbumPageItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayAlbumPageItem

