-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10322 = class("bs_10322", LuaSkillBase)
local base = LuaSkillBase
bs_10322.config = {}
bs_10322.ctor = function(self)
  -- function num : 0_0
end

bs_10322.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_10322.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10322

