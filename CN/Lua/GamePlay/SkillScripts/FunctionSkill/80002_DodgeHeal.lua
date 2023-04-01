-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80002 = class("bs_80002", LuaSkillBase)
local base = LuaSkillBase
bs_80002.config = {
heal_config = {baseheal_formula = 10089}
, effectId = 1048, 
hurt_config = {basehurt_formula = 10087}
}
bs_80002.ctor = function(self)
  -- function num : 0_0
end

bs_80002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_80002_3", 1, self.OnAfterHurt)
  self.hurtTime = 0
end

bs_80002.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isMiss and not isTriggerSet and skill.isCommonAttack then
    self.hurtTime = self.hurtTime + 1
    if (self.arglist)[2] <= self.hurtTime then
      self.hurtTime = 0
      local shieldValue = (self.caster).skill_intensity * (self.arglist)[1] // 1000
      LuaSkillCtrl:AddRoleShield(target, eShieldType.Normal, shieldValue)
    end
  end
end

bs_80002.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80002

