-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21039 = class("bs_21039", LuaSkillBase)
local base = LuaSkillBase
bs_21039.config = {}
bs_21039.ctor = function(self)
  -- function num : 0_0
end

bs_21039.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_21039.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21039

