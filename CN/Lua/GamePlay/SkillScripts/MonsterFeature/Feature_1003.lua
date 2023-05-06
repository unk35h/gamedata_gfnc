-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1003 = class("bs_1003", LuaSkillBase)
local base = LuaSkillBase
bs_1003.config = {
real_Config = {hit_formula = 0, basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, hurt_type = 2}
}
bs_1003.ctor = function(self)
  -- function num : 0_0
end

bs_1003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1003", 9, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, nil, false)
end

bs_1003.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isTriggerSet ~= true and hurt > 0 and hurtType == 0 then
    LuaSkillCtrl:CallRealDamage(self, sender, nil, (self.config).real_Config, {hurt * (self.arglist)[1] // 1000}, true)
  end
end

bs_1003.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1003

