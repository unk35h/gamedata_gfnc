-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15090 = class("bs_15090", LuaSkillBase)
local base = LuaSkillBase
bs_15090.config = {buffId = 110085}
bs_15090.ctor = function(self)
  -- function num : 0_0
end

bs_15090.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_15090_3", 1, self.OnHurtResultStart)
  self:AddSetHurtTrigger("bs_15090_2", 1, self.OnSetHurt, self.caster)
end

bs_15090.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and LuaSkillCtrl:RoleContainsBuffFeature(context.target, eBuffFeatureType.Stun) then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_15090.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.sender == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_15090.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15090

