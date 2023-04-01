-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80004 = class("bs_80004", LuaSkillBase)
local base = LuaSkillBase
bs_80004.config = {
real_Config = {hit_formula = 0, def_formula = 0, basehurt_formula = 502, minhurt_formula = 9994, crit_formula = 0, crithur_ratio = 0, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = 2}
}
bs_80004.ctor = function(self)
  -- function num : 0_0
end

bs_80004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_80004_3", 1, self.OnAfterHurt, self.caster)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_80004_12", 1, self.OnAfterPlaySkill)
  self.flag = false
end

bs_80004.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if role == self.caster and not skill.isCommonAttack and not self.flag then
    self.flag = true
  end
end

bs_80004.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and not isMiss and not isTriggerSet and skill.isCommonAttack and self.flag then
    self.flag = false
    local damage = (self.caster).def * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).real_Config, {damage}, true)
  end
end

bs_80004.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80004

