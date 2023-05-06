-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010424 = class("bs_4010424", LuaSkillBase)
local base = LuaSkillBase
bs_4010424.config = {buffId = 1227, duration = 90}
bs_4010424.ctor = function(self)
  -- function num : 0_0
end

bs_4010424.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010424", 1, self.OnAfterHurt, nil, self.caster)
end

bs_4010424.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and isMiss and self:IsReadyToTake() then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, (self.arglist)[1], (self.config).duration, true)
    self:OnSkillTake()
  end
end

bs_4010424.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010424

