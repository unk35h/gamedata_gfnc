-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93023 = class("bs_93023", LuaSkillBase)
local base = LuaSkillBase
bs_93023.config = {buffId = 2027, buffTier = 1}
bs_93023.ctor = function(self)
  -- function num : 0_0
end

bs_93023.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_93023_1", 1, self.OnAfterHurt, nil, self.caster)
end

bs_93023.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss then
    if target:GetBuffTier((self.config).buffId) < (self.arglist)[2] then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.config).buffTier, (self.arglist)[3], true)
    else
      LuaSkillCtrl:DispelBuff(target, (self.config).buffId, 0)
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.arglist)[2], (self.arglist)[3], true)
    end
    self:PlayChipEffect()
  end
end

bs_93023.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93023

