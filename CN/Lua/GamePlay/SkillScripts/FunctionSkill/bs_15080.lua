-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15080 = class("bs_15080", LuaSkillBase)
local base = LuaSkillBase
bs_15080.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0}
}
bs_15080.ctor = function(self)
  -- function num : 0_0
end

bs_15080.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15080_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_15080.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isMiss and not isTriggerSet then
    local sheidValue = LuaSkillCtrl:GetRoleAllShield(self.caster) * (self.arglist)[1] // 1000
    if (self.caster).maxHp * (self.arglist)[2] // 1000 < sheidValue then
      sheidValue = (self.caster).maxHp * (self.arglist)[2] // 1000
    end
    if sheidValue > 0 then
      self:PlayChipEffect()
      self:OnSkillTake()
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {sheidValue}, true)
      skillResult:EndResult()
    end
  end
end

bs_15080.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15080

