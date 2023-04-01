-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyChocolate = class("UINFlappyChocolate", UIBaseNode)
local base = UIBaseNode
UINFlappyChocolate.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINFlappyChocolate.OnDelete = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnDelete)(self)
end

return UINFlappyChocolate

