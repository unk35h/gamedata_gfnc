-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10120 = class("bs_10120", LuaSkillBase)
local base = LuaSkillBase
bs_10120.config = {buffId1 = 1021, buffId2 = 1022, effectId = 91, 
heal_config = {baseheal_formula = 9990}
}
bs_10120.ctor = function(self)
  -- function num : 0_0
end

bs_10120.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10120_3", 1, self.OnAfterHurt, self.caster)
end

bs_10120.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  end
  if sender == self.caster and not isMiss and hurtType == 2 then
    local value = hurt * (self.arglist)[1] // 1000 * 3
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true, true)
    skillResult:EndResult()
  else
    do
      if sender == self.caster and not isMiss and hurtType ~= 2 and not isTriggerSet then
        local value = hurt * (self.arglist)[1] // 1000
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
        LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true, true)
        skillResult:EndResult()
      end
    end
  end
end

bs_10120.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10120

