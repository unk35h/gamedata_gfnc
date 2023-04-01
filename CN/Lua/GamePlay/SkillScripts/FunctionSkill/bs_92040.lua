-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92040 = class("bs_92040", LuaSkillBase)
local base = LuaSkillBase
bs_92040.config = {
heal_config = {baseheal_formula = 3022}
}
bs_92040.ctor = function(self)
  -- function num : 0_0
end

bs_92040.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92040_1", 1, self.OnAfterHurt, nil, self.caster)
end

bs_92040.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss then
    self:PlayChipEffect()
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[1]})
    skillResult:EndResult()
  end
end

bs_92040.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92040

