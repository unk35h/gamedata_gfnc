-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1015 = class("bs_1015", LuaSkillBase)
local base = LuaSkillBase
bs_1015.config = {effectId_trail = 500, 
real_Config = {hit_formula = 0, basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, hurt_type = 2}
, effectId = 501}
bs_1015.ctor = function(self)
  -- function num : 0_0
end

bs_1015.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_1015", 99, self.OnSetDeadHurt, nil, self.caster)
end

bs_1015.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 then
    LuaSkillCtrl:CallEffectWithArgOverride(context.sender, (self.config).effectId_trail, self, self.caster, nil, nil, self.SkillEventFunc)
  end
end

bs_1015.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    local hurt = (self.caster).maxHp
    LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).real_Config, {hurt * (self.arglist)[1] // 1000}, true)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, nil, nil, nil, true)
  end
end

bs_1015.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1015

