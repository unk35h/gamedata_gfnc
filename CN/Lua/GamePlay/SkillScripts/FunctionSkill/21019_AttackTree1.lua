-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21019 = class("bs_21019", LuaSkillBase)
local base = LuaSkillBase
bs_21019.config = {buffId = 110037}
bs_21019.ctor = function(self)
  -- function num : 0_0
end

bs_21019.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_21019_3", 1, self.OnHurtResultStart)
  self:AddSetHurtTrigger("bs_21019_2", 1, self.OnSetHurt, self.caster)
end

bs_21019.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and (self.arglist)[1] <= (context.target).hp * 1000 // (context.target).maxHp then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_21019.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.sender == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_21019.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21019

