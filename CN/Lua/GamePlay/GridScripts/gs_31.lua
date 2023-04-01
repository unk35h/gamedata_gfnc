-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_31 = class("gs_31", LuaGridBase)
gs_31.config = {effectId = 10962, 
heal_config = {baseheal_formula = 501}
}
gs_31.ctor = function(self)
  -- function num : 0_0
end

gs_31.OnGridBattleStart = function(self, role)
  -- function num : 0_1
end

gs_31.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  local healNum = role.maxHp * 50 // 1000
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role, (self.config).aoe_config)
  LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {healNum}, true, true)
end

gs_31.OnGridExitRole = function(self, role)
  -- function num : 0_3
end

gs_31.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_31

