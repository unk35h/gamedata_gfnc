-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93026 = class("bs_93026", LuaSkillBase)
local base = LuaSkillBase
bs_93026.config = {
hurt_config1 = {hit_formula = 0, crit_formula = 9992, basehurt_formula = 502}
, 
hurt_config2 = {hit_formula = 0, crit_formula = 9992, basehurt_formula = 502}
, effectIdAttack = 10953}
bs_93026.ctor = function(self)
  -- function num : 0_0
end

bs_93026.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_93026_1", 1, self.OnAfterHurt, nil, self.caster)
  self.pow_Num = 0
  self.skill_intensity_Num = 0
end

bs_93026.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss then
    self.pow_Num = target.pow * (self.arglist)[1] // 1000
    self.skill_intensity_Num = target.skill_intensity * (self.arglist)[1] // 1000
    self:OnSkillTake()
    self:PlayChipEffect()
    LuaSkillCtrl:CallEffect(sender, (self.config).effectIdAttack, self, self.SkillEventFunc)
  end
end

bs_93026.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    if self.skill_intensity_Num <= self.pow_Num then
      LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).hurt_config1, {self.pow_Num}, true)
    else
      LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).hurt_config2, {self.skill_intensity_Num}, true)
    end
  end
end

bs_93026.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93026

