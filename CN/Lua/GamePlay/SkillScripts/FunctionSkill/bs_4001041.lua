-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001041 = class("bs_4001041", LuaSkillBase)
local base = LuaSkillBase
bs_4001041.config = {}
bs_4001041.ctor = function(self)
  -- function num : 0_0
end

bs_4001041.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_4001041.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001041

