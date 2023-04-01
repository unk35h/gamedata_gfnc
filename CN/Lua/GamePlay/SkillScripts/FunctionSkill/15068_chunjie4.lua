-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15068 = class("bs_15068", LuaSkillBase)
local base = LuaSkillBase
bs_15068.config = {buffId = 1270, buffId2 = 1273, 
heal_config = {baseheal_formula = 501, heal_number = 0, correct_formula = 9990}
}
bs_15068.ctor = function(self)
  -- function num : 0_0
end

bs_15068.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15068_1", 1, self.OnAfterBattleStart)
end

bs_15068.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 150, self.CallBack, self, -1)
  local value = (self.arglist)[1] // 10
  local healNum = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, value, nil, true)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
  LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {healNum}, true, true)
  skillResult:EndResult()
end

bs_15068.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local value2 = (self.arglist)[2] * (self.caster).hp // 1000
  LuaSkillCtrl:RemoveLife(value2, self, self.caster, true, nil, false, true, eHurtType.RealDmg, true)
end

bs_15068.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15068

