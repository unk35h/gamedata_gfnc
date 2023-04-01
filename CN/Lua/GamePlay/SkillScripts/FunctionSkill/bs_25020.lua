-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25020 = class("bs_25020", LuaSkillBase)
local base = LuaSkillBase
bs_25020.config = {}
bs_25020.ctor = function(self)
  -- function num : 0_0
end

bs_25020.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25020_1", 1, self.OnAfterBattleStart)
end

bs_25020.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local value = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:RemoveLife(value, self, self.caster, true, nil, true, true, eHurtType.RealDmg)
end

bs_25020.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25020

