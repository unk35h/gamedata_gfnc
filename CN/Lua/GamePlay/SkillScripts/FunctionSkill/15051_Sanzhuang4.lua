-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15051 = class("bs_15051", LuaSkillBase)
local base = LuaSkillBase
bs_15051.config = {}
bs_15051.ctor = function(self)
  -- function num : 0_0
end

bs_15051.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15051_2", 1, self.OnAfterHurt, self.caster)
end

bs_15051.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isMiss and hurt > 0 and not isTriggerSet and hurt > 0 then
    local shieldValue = hurt * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, shieldValue)
  end
end

bs_15051.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15051

