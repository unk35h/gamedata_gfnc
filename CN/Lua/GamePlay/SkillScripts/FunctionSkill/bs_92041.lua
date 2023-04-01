-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92041 = class("bs_92041", LuaSkillBase)
local base = LuaSkillBase
bs_92041.config = {buffId = 2029, buffTier = 1}
bs_92041.ctor = function(self)
  -- function num : 0_0
end

bs_92041.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92041_1", 1, self.OnAfterHurt, nil, self.caster)
end

bs_92041.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.config).buffTier, (self.arglist)[3], true)
    self:PlayChipEffect()
  end
end

bs_92041.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92041

