-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92007 = class("bs_92007", LuaSkillBase)
local base = LuaSkillBase
bs_92007.config = {buffId = 2012}
bs_92007.ctor = function(self)
  -- function num : 0_0
end

bs_92007.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_92007_1", 1, self.OnHurtResultStart, nil, self.caster)
end

bs_92007.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  local shieldValue = LuaSkillCtrl:GetRoleAllShield(self.caster)
  if (self.caster).maxHp * (self.arglist)[2] // 1000 < shieldValue then
    shieldValue = (self.caster).maxHp * (self.arglist)[2] // 1000
  end
  local buffTier = (self.arglist)[1] * (shieldValue) // ((self.caster).maxHp * (self.arglist)[2] // 1000)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, buffTier, nil, true)
end

bs_92007.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92007

