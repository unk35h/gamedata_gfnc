-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21033 = class("bs_21033", LuaSkillBase)
local base = LuaSkillBase
bs_21033.config = {buffId = 3004, 
heal_config = {baseheal_formula = 10088, heal_number = 0, correct_formula = 9990}
}
bs_21033.ctor = function(self)
  -- function num : 0_0
end

bs_21033.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_21033_2", 2, self.OnSelfAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
end

bs_21033.OnSelfAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl:GetRoleEfcGrid(self.caster) ~= 0 and self:IsReadyToTake() then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1])
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, nil, true, true)
    skillResult:EndResult()
    self:OnSkillTake()
  end
end

bs_21033.OnRoleSplash = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster and LuaSkillCtrl:GetRoleEfcGrid(self.caster) ~= 0 and self:IsReadyToTake() then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1])
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, nil, true, true)
    skillResult:EndResult()
    self:OnSkillTake()
  end
end

bs_21033.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21033

