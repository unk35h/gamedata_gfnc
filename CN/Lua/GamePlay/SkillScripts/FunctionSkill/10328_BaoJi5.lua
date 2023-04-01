-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10328 = class("bs_10328", LuaSkillBase)
local base = LuaSkillBase
bs_10328.config = {buffId = 1265, buffTier = 1}
bs_10328.ctor = function(self)
  -- function num : 0_0
end

bs_10328.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10328_1", 1, self.OnAfterHurt, self.caster)
  self.times = 0
end

bs_10328.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit then
    self.times = self.times + 1
    if (self.arglist)[1] <= self.times then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
      self.times = 0
    end
  end
end

bs_10328.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10328

