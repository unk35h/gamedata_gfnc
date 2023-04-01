-- params : ...
-- function num : 0 , upvalues : _ENV
local UINPeriodBattleBossResultItem = class("UINPeriodBattleBossResultItem", UIBaseNode)
local base = UIBaseNode
UINPeriodBattleBossResultItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINPeriodBattleBossResultItem.SetNameIdxPeriodBossResultItem = function(self, idx, value1)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_Name):SetIndex(idx, tostring(value1))
end

UINPeriodBattleBossResultItem.SetValueIdxPeriodBossResultItem = function(self, idx, value1, value2)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).tex_Score):SetIndex(idx, tostring(value1), tostring(value2))
end

UINPeriodBattleBossResultItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINPeriodBattleBossResultItem

