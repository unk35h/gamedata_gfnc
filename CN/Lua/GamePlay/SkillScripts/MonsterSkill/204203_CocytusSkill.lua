-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204203 = class("bs_204203", LuaSkillBase)
local base = LuaSkillBase
bs_204203.config = {}
bs_204203.ctor = function(self)
  -- function num : 0_0
end

bs_204203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204203.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204203

