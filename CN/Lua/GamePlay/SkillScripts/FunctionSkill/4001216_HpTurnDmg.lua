-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001216 = class("bs_4001216", LuaSkillBase)
local base = LuaSkillBase
bs_4001216.config = {
real_Config = {hit_formula = 0, basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, hurt_type = 2}
}
bs_4001216.ctor = function(self)
  -- function num : 0_0
end

bs_4001216.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4001216_3", 1, self.OnAfterHurt, self.caster)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_4001216_12", 1, self.OnAfterPlaySkill)
  self.flag = false
end

bs_4001216.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if role == self.caster and not skill.isCommonAttack and not self.flag then
    self.flag = true
  end
end

bs_4001216.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and not isMiss and not isTriggerSet and skill.isCommonAttack and self.flag then
    self.flag = false
    local damage = (self.caster).maxHp * (self.arglist)[1] // 1000
    if damage <= 0 then
      damage = 1
    end
    LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).real_Config, {damage}, nil, true)
  end
end

bs_4001216.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001216

