-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHandBookSkinTag = class("UINHandBookSkinTag", UIBaseNode)
local base = UIBaseNode
UINHandBookSkinTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHandBookSkinTag.InitBookSkinTag = function(self, index)
  -- function num : 0_1
  ((self.ui).tex_Tag):SetIndex(index - 1)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Tag).color = ((self.ui).color_tag)[index]
end

return UINHandBookSkinTag

