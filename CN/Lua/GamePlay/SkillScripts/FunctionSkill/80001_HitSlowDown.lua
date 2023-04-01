-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80001 = class("bs_80001", LuaSkillBase)
local base = LuaSkillBase
bs_80001.config = {buffId = 1236}
bs_80001.ctor = function(self)
  -- function num : 0_0
end

bs_80001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_80001_3", 1, self.OnAfterHurt, self.caster)
end

bs_80001.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isTriggerSet and target.hp >= 0 and not isMiss then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, (self.arglist)[2], true)
  end
end

bs_80001.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80001

