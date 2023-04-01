-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92042 = class("bs_92042", LuaSkillBase)
local base = LuaSkillBase
bs_92042.config = {buffId = 2030, buffTier = 1}
bs_92042.ctor = function(self)
  -- function num : 0_0
end

bs_92042.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92042_1", 1, self.OnAfterHurt, nil, self.caster)
end

bs_92042.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.config).buffTier, nil, true)
    self:PlayChipEffect()
  end
end

bs_92042.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92042

