-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActSum22TechEffectItem = class("UINActSum22TechEffectItem", base)
UINActSum22TechEffectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActSum22TechEffectItem.InitActSum22TechEffectItem = function(self)
  -- function num : 0_1
end

UINActSum22TechEffectItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINActSum22TechEffectItem

