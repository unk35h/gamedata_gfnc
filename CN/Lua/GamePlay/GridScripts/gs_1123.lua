-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1123 = class("gs_1123", LuaGridBase)
gs_1123.config = {buffId = 110043, effectId = 12032, buffEffectId = 12033}
gs_1123.ctor = function(self)
  -- function num : 0_0
end

gs_1123.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  if role == nil then
    self:GridLoseEffect()
  end
end

gs_1123.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1)
  LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.3, 1.3, 1.3), 0.2)
  self:GridLoseEffect()
end

gs_1123.OnGridExitRole = function(self, role)
  -- function num : 0_3
end

gs_1123.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_1123

