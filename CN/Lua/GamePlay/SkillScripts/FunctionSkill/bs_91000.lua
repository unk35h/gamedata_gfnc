-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91000 = class("bs_91000", LuaSkillBase)
local base = LuaSkillBase
bs_91000.config = {buffId = 2000, buffTier = 1}
bs_91000.ctor = function(self)
  -- function num : 0_0
end

bs_91000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_91000_3", 1, self.OnAfterHurt, nil, self.caster)
end

bs_91000.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isMiss and not isTriggerSet then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
  end
end

bs_91000.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91000

