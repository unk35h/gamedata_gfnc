-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21041 = class("bs_21041", LuaSkillBase)
local base = LuaSkillBase
bs_21041.config = {
heal_config = {baseheal_formula = 10037, heal_number = 0, correct_formula = 9990}
, effectId = 10092}
bs_21041.ctor = function(self)
  -- function num : 0_0
end

bs_21041.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddAfterHurtTrigger("bs_21041_3", 1, self.OnAfterHurt, self.caster)
end

bs_21041.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and isCrit then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {hurt}, true)
    skillResult:EndResult()
  end
end

bs_21041.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21041

