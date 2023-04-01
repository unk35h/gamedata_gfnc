-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30046 = class("bs_30046", LuaSkillBase)
local base = LuaSkillBase
bs_30046.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10176, crit_formula = 0}
, effectId = 10929}
bs_30046.ctor = function(self)
  -- function num : 0_0
end

bs_30046.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_30046_3", 1, self.OnAfterHurt, self.caster)
end

bs_30046.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet then
    self:OnSkillTake()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
  end
end

bs_30046.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
    skillResult:EndResult()
  end
end

bs_30046.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30046

