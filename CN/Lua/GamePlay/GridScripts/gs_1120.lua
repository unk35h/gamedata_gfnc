-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1120 = class("gs_1120", LuaGridBase)
gs_1120.config = {buffId = 110012, effectId = 12034, buffEffectId = 12035}
gs_1120.ctor = function(self)
  -- function num : 0_0
end

gs_1120.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  if role == nil then
    self:GridLoseEffect()
  end
end

gs_1120.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1)
  LuaSkillCtrl:CallEffect(role, (self.config).buffEffectId, self)
  self:GridLoseEffect()
end

gs_1120.OnGridExitRole = function(self, role)
  -- function num : 0_3
end

gs_1120.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_1120

