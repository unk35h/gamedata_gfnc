-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyAccItem = class("UINFlappyAccItem", UIBaseNode)
local base = UIBaseNode
UINFlappyAccItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINFlappyAccItem.OnDelete = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnDelete)(self)
end

return UINFlappyAccItem

