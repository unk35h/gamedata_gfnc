-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92087 = class("bs_92087", LuaSkillBase)
local base = LuaSkillBase
bs_92087.config = {buffId = 1227, buffDuration = 90}
bs_92087.ctor = function(self)
  -- function num : 0_0
end

bs_92087.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_92087_1", 1, self.OnSetHurt, nil, self.caster)
  self:AddAfterHurtTrigger("bs_92087", 2, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, nil, false)
end

bs_92087.OnSetHurt = function(self, context)
  -- function num : 0_2
  local buffTier = (context.sender):GetBuffTier((self.config).buffId)
  if context.target == self.caster and buffTier ~= nil and buffTier > 0 then
    context.hurt = context.hurt - context.hurt * (self.arglist)[2] // 1000
  end
end

bs_92087.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if isMiss or isTriggerSet or target ~= self.caster then
    return 
  end
  local range = LuaSkillCtrl:CallRange(1, 1000)
  if range < (self.arglist)[1] and self:IsReadyToTake() then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, 1, (self.config).buffDuration, true)
    self:OnSkillTake()
  end
end

bs_92087.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92087

