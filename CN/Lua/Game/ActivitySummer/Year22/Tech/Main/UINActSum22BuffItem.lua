-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActSum22BuffItem = class("UINActSum22BuffItem", base)
UINActSum22BuffItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActSum22BuffItem.InitActSum22BuffItem = function(self, desStr)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_BuffInfo).text = desStr
end

UINActSum22BuffItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINActSum22BuffItem

