-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1124 = class("gs_1124", LuaGridBase)
gs_1124.config = {buffId = 110044, effectId = 12034, buffEffectId = 12035}
gs_1124.ctor = function(self)
  -- function num : 0_0
end

gs_1124.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  if role == nil then
    self:GridLoseEffect()
  end
end

gs_1124.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1)
  LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.3, 1.3, 1.3), 0.2)
  self:GridLoseEffect()
end

gs_1124.OnGridExitRole = function(self, role)
  -- function num : 0_3
end

gs_1124.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_1124

