-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_25 = class("gs_25", LuaGridBase)
gs_25.ctor = function(self)
  -- function num : 0_0
end

gs_25.OnGridBattleStart = function(self, role)
  -- function num : 0_1
end

gs_25.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, role, 1226, 1, nil, true)
end

gs_25.OnGridExitRole = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, 1226, 0)
end

gs_25.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_25

