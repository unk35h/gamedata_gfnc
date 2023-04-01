-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80007 = class("bs_80007", LuaSkillBase)
local base = LuaSkillBase
bs_80007.config = {
real_Config = {hit_formula = 0, def_formula = 0, basehurt_formula = 502, minhurt_formula = 9994, crit_formula = 0, crithur_ratio = 0, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = 2}
}
bs_80007.ctor = function(self)
  -- function num : 0_0
end

bs_80007.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_80007_3", 1, self.OnSetHurt, self.caster)
end

bs_80007.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and not context.isTriggerSet and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey and LuaSkillCtrl:GetShield(context.target) > 0 then
    local Value = (math.max)(1, (self.arglist)[1] * context.hurt // 1000)
    LuaSkillCtrl:CallRealDamage(self, context.target, nil, (self.config).real_Config, {Value}, true)
  end
end

bs_80007.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80007

