-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92053 = class("bs_92053", LuaSkillBase)
local base = LuaSkillBase
bs_92053.config = {buffId = 2037, buffTier = 1}
bs_92053.ctor = function(self)
  -- function num : 0_0
end

bs_92053.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92053_2", 1, self.OnAfterHurt, nil, self.caster)
end

bs_92053.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isMiss then
    self:PlayChipEffect()
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.config).buffTier, nil, true)
  end
end

bs_92053.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92053

