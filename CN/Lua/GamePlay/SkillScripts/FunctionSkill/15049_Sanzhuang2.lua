-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15049 = class("bs_15049", LuaSkillBase)
local base = LuaSkillBase
bs_15049.config = {effectId = 10959, 
heal_config = {baseheal_formula = 501}
}
bs_15049.ctor = function(self)
  -- function num : 0_0
end

bs_15049.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15049_3", 1, self.OnAfterHurt, nil, self.caster)
  self.isFirst = true
end

bs_15049.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isMiss and (self.caster).hp < (self.caster).maxHp * (self.arglist)[1] // 1000 and self:IsReadyToTake() and self.isFirst then
    self:PlayChipEffect()
    self:OnSkillTake()
    self.isFirst = false
    local recoverNum = (self.caster).maxHp - (self.caster).hp
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {recoverNum}, true)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  end
end

bs_15049.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15049

