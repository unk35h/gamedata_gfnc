-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFntThemeTag = class("UINFntThemeTag", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINFntThemeTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINFntThemeTag.SetIndex = function(self, tagIndex)
  -- function num : 0_1 , upvalues : ShopEnum
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_bottom).color = (ShopEnum.ColorShowFntThemeTags)[tagIndex + 1]
  ;
  ((self.ui).tex_Text):SetIndex(tagIndex)
  ;
  ((self.ui).img_Icon):SetIndex(tagIndex)
end

return UINFntThemeTag

