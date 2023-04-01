-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1119 = class("gs_1119", LuaGridBase)
gs_1119.config = {buffId = 110011, effectId = 12032, buffEffectId = 12033}
gs_1119.ctor = function(self)
  -- function num : 0_0
end

gs_1119.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  if role == nil then
    self:GridLoseEffect()
  end
end

gs_1119.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  local roleAtkSkill = role:GetCommonAttack()
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  roleAtkSkill:ResetCDTimeRatio(0)
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1)
  LuaSkillCtrl:CallEffect(role, (self.config).buffEffectId, self)
  self:GridLoseEffect()
end

gs_1119.OnGridExitRole = function(self, role)
  -- function num : 0_3
end

gs_1119.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_1119

