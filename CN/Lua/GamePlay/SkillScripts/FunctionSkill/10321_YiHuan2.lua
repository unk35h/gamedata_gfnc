-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10321 = class("bs_10321", LuaSkillBase)
local base = LuaSkillBase
bs_10321.config = {}
bs_10321.ctor = function(self)
  -- function num : 0_0
end

bs_10321.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_10321.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10321

