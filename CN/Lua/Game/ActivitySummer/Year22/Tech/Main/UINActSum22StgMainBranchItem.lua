-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActSum22StgMainBranchItem = class("UINActSum22StgMainBranchItem", base)
UINActSum22StgMainBranchItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActSum22StgMainBranchItem.InitActSum22StgMainBranchItem = function(self)
  -- function num : 0_1
end

UINActSum22StgMainBranchItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINActSum22StgMainBranchItem

