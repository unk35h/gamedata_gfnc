-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010427 = class("bs_4010427", LuaSkillBase)
local base = LuaSkillBase
bs_4010427.config = {}
bs_4010427.ctor = function(self)
  -- function num : 0_0
end

bs_4010427.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_4010427.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010427

