-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20122 = class("bs_20122", LuaSkillBase)
local base = LuaSkillBase
bs_20122.config = {buff_id = 2012201}
bs_20122.ctor = function(self)
  -- function num : 0_0
end

bs_20122.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  LuaSkillCtrl:CallBuffRepeated(self, self.caster, (self.config).buff_id, 1, nil, false, self.OnBuffExecute)
end

bs_20122.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_2 , upvalues : _ENV
  local val = (self.caster).maxHp * (self.arglist)[2] // 1000
  LuaSkillCtrl:RemoveLife(val, self, self.caster, true)
end

bs_20122.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20122

