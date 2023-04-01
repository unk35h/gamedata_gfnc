-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21051 = class("bs_21051", LuaSkillBase)
local base = LuaSkillBase
bs_21051.config = {}
bs_21051.ctor = function(self)
  -- function num : 0_0
end

bs_21051.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_21051.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21051

