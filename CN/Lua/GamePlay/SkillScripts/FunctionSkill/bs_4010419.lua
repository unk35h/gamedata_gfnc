-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010419 = class("bs_4010419", LuaSkillBase)
local base = LuaSkillBase
bs_4010419.config = {buffId = 195, duration = 75}
bs_4010419.ctor = function(self)
  -- function num : 0_0
end

bs_4010419.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010419", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, nil, false)
end

bs_4010419.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss or hurtType ~= eHurtType.PhysicsDmg or isTriggerSet or sender ~= self.caster then
    return 
  end
  local range = LuaSkillCtrl:CallRange(1, 1000)
  if range <= (self.arglist)[1] and self:IsReadyToTake() then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, (self.config).duration, true)
    self:OnSkillTake()
  end
end

bs_4010419.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010419

