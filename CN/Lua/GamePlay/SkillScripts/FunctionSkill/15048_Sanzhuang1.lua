-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15048 = class("bs_15048", LuaSkillBase)
local base = LuaSkillBase
bs_15048.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0}
}
bs_15048.ctor = function(self)
  -- function num : 0_0
end

bs_15048.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15048_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_15048.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isMiss and not isTriggerSet then
    local damageValue = (self.caster).maxHp * (self.arglist)[1] // 1000
    do
      if damageValue > 0 then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {damageValue}, true)
        skillResult:EndResult()
      end
      self:PlayChipEffect()
      self:OnSkillTake()
    end
  end
end

bs_15048.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15048

