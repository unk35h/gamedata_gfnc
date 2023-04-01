-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92005 = class("bs_92005", LuaSkillBase)
local base = LuaSkillBase
bs_92005.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10076, crit_formula = 0}
, effectId = 10953}
bs_92005.ctor = function(self)
  -- function num : 0_0
end

bs_92005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92005_3", 1, self.OnAfterHurt, self.caster)
end

bs_92005.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and not isTriggerSet then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
  end
end

bs_92005.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, ((self.caster).recordTable).lastAttackRole)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
    skillResult:EndResult()
  end
end

bs_92005.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92005

