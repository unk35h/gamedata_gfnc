-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22LimitTaskEmptyItem = class("UINChristmas22LimitTaskEmptyItem", UIBaseNode)
local base = UIBaseNode
UINChristmas22LimitTaskEmptyItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINChristmas22LimitTaskEmptyItem.SetTaskNextShowTex = function(self, str)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Timer).text = str
end

return UINChristmas22LimitTaskEmptyItem

