-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301504 = class("bs_301504", LuaSkillBase)
local base = LuaSkillBase
bs_301504.config = {}
bs_301504.ctor = function(self)
  -- function num : 0_0
end

bs_301504.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_301504.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_301504

