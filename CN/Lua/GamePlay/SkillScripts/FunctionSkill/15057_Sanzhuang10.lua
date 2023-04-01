-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15057 = class("bs_15057", LuaSkillBase)
local base = LuaSkillBase
bs_15057.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10076, crit_formula = 0}
, effectIdAttack = 10953}
bs_15057.ctor = function(self)
  -- function num : 0_0
end

bs_15057.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_15057_14", 90, self.OnSetHurt, nil, nil, (self.caster).belongNum)
end

bs_15057.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.isCrit and self:IsReadyToTake() and (context.target).belongNum ~= (self.caster).belongNum then
    self:OnSkillTake()
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectIdAttack, self, self.SkillEventFunc)
  end
end

bs_15057.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
    skillResult:EndResult()
  end
end

bs_15057.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15057

