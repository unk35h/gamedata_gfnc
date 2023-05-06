-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010453 = class("bs_4010453", LuaSkillBase)
local base = LuaSkillBase
bs_4010453.config = {buffId = 1097}
bs_4010453.ctor = function(self)
  -- function num : 0_0
end

bs_4010453.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_4010453_14", 1, self.OnHurtResultStart)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultEnd, "bs_4010453_15", 1, self.OnHurtResultEnd)
end

bs_4010453.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and (context.target).intensity >= 2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_4010453.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if targetRole == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0, true)
  end
end

bs_4010453.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010453

