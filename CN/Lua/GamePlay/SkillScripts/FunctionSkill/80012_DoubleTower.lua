-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80012 = class("bs_80012", LuaSkillBase)
local base = LuaSkillBase
bs_80012.config = {buffId = 288, buffTime = 30}
bs_80012.ctor = function(self)
  -- function num : 0_0
end

bs_80012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_80012_2", 2, self.OnSelfAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
end

bs_80012.OnSelfAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1])
end

bs_80012.OnRoleSplash = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1])
  end
end

bs_80012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80012

