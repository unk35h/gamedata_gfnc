-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7009 = class("bs_7009", LuaSkillBase)
local base = LuaSkillBase
bs_7009.config = {buffId = 1228}
bs_7009.ctor = function(self)
  -- function num : 0_0
end

bs_7009.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_7009_12", 1, self.OnAfterPlaySkill)
  self:AddAfterHurtTrigger("bs_7009_3", 1, self.OnAfterHurt, self.caster)
  self:AddAfterHealTrigger("bs_7009_5", 1, self.OnAfterHeal, self.caster)
  self.isFirst = false
end

bs_7009.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if skill.maker == self.caster and not skill.isCommonAttack then
    self.isFirst = true
  end
end

bs_7009.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if not isTriggerSet and not isMiss and self.isFirst then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
    self.isFirst = false
  end
end

bs_7009.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if not isTriggerSet and self.isFirst then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
    self.isFirst = false
  end
end

bs_7009.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_7009

