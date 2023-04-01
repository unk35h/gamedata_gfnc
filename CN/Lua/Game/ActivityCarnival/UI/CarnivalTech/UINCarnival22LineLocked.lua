-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22LineLocked = class("UINCarnival22LineLocked", UIBaseNode)
local base = UIBaseNode
UINCarnival22LineLocked.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnival22LineLocked.InitCarnival22LineLocked = function(self, des)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Condition).text = des
end

return UINCarnival22LineLocked

