-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10160 = class("bs_10160", LuaSkillBase)
local base = LuaSkillBase
bs_10160.config = {buffId = 1254}
bs_10160.ctor = function(self)
  -- function num : 0_0
end

bs_10160.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_10160_1", 1, self.OnAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
end

bs_10160.OnAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self:IsReadyToTake() then
    self:OnSkillTake()
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_10160.OnRoleSplash = function(self, role, grid)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster and self:IsReadyToTake() then
    self:OnSkillTake()
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_10160.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10160

