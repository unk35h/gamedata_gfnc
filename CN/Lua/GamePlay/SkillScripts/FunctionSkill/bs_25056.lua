-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25056 = class("bs_25056", LuaSkillBase)
local base = LuaSkillBase
bs_25056.config = {buffId = 195}
bs_25056.ctor = function(self)
  -- function num : 0_0
end

bs_25056.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_25056_3", 1, self.OnAfterHurt, self.caster)
end

bs_25056.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and isCrit and not isTriggerSet then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.arglist)[1], 75)
  end
end

bs_25056.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25056

