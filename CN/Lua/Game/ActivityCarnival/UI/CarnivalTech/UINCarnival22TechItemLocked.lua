-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechItemLocked = class("UINCarnival22TechItemLocked", UIBaseNode)
local base = UIBaseNode
UINCarnival22TechItemLocked.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnival22TechItemLocked.SetTechItemLockedAlpha = function(self, a)
  -- function num : 0_1
  local color = ((self.ui).img_ItemLocked).color
  color.a = a
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_ItemLocked).color = color
end

return UINCarnival22TechItemLocked

