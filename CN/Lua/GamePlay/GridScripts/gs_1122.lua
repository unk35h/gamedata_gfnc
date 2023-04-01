-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1122 = class("gs_1122", LuaGridBase)
local base = LuaGridBase
gs_1122.config = {effectId = 10374, leafEffectId = 10733, eatEffectId = 10376, buffId = 1049, buffTier = 300, caoTime = 70, lineEffectId = 10728}
gs_1122.ctor = function(self)
  -- function num : 0_0
end

gs_1122.OnGridBattleStart = function(self, role)
  -- function num : 0_1
end

gs_1122.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnStateWake)
end

gs_1122.OnGridExitRole = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnStateSleep)
end

gs_1122.OnGridRoleDead = function(self, role)
  -- function num : 0_4
end

return gs_1122

