-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessInfoInfoBase = class("UINWarChessInfoInfoBase", base)
UINWarChessInfoInfoBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoBase.OnDelete = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoBase

