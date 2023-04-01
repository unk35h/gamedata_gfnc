-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWAMMMapLevelCurItem = class("UINWAMMMapLevelCurItem", UIBaseNode)
local base = UIBaseNode
UINWAMMMapLevelCurItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWAMMMapLevelCurItem.OnDelete = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnDelete)(self)
end

return UINWAMMMapLevelCurItem

