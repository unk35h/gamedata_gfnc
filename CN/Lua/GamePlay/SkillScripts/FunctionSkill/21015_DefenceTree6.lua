-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21015 = class("bs_21015", LuaSkillBase)
local base = LuaSkillBase
bs_21015.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 3012, crit_formula = 0}
}
bs_21015.ctor = function(self)
  -- function num : 0_0
end

bs_21015.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_21015_1", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_21015.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isMiss then
    LuaSkillCtrl:CallBuff(self, self.caster, 1130, 1, nil)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
    skillResult:EndResult()
  end
end

bs_21015.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21015

