-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN_HBBackground = class("UIN_HBBackground", UIBaseNode)
local base = UIBaseNode
UIN_HBBackground.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UIN_HBBackground.PlayDoTweenAnimation = function(self, id)
  -- function num : 0_1
  ((self.ui).DoTweenAnimation):DORestartAllById(id)
end

return UIN_HBBackground

