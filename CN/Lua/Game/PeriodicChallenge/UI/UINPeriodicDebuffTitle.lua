-- params : ...
-- function num : 0 , upvalues : _ENV
local UINPeriodicDebuffTitle = class("UINPeriodicDebuffTitle", UIBaseNode)
local base = UIBaseNode
UINPeriodicDebuffTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINPeriodicDebuffTitle.SetDebuffTitle = function(self, titleId)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_DebuffTitle).text = ConfigData:GetTipContent(titleId)
end

return UINPeriodicDebuffTitle

