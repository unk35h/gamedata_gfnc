-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010425 = class("bs_4010425", LuaSkillBase)
local base = LuaSkillBase
bs_4010425.config = {buffId_fire = 1227}
bs_4010425.ctor = function(self)
  -- function num : 0_0
end

bs_4010425.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010425", 1, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack, false)
  self:AddSetHurtTrigger("bs_4010425", 1, self.OnSetHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack, false)
  self.MissCount = 0
  self.PowerHit = 0
end

bs_4010425.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2
  if target == self.caster and isMiss and not isTriggerSet then
    self.MissCount = self.MissCount + 1
    if (self.arglist)[1] <= self.MissCount and self.PowerHit == 0 then
      self.PowerHit = (self.arglist)[2]
      self.MissCount = 0
    end
  end
end

bs_4010425.OnSetHurt = function(self, context)
  -- function num : 0_3
  if context.sender ~= self.caster or context.isTriggerSet then
    return 
  end
  local fireTier = (context.target):GetBuffTier((self.config).buffId_fire)
  local rate = (self.arglist)[3]
  if fireTier > 0 then
    rate = (self.arglist)[3] + (self.arglist)[4]
  end
  if self.PowerHit > 0 then
    context.hurt = context.hurt + context.hurt * (rate) // 1000
    self.PowerHit = self.PowerHit - 1
  end
end

bs_4010425.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010425

