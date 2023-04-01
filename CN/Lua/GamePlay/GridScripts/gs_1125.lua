-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1125 = class("gs_1125", LuaGridBase)
local base = LuaGridBase
gs_1125.config = {effectId = 10482, effectId1 = 10484, buffId = 1257}
gs_1125.ctor = function(self)
  -- function num : 0_0
end

gs_1125.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  self:StartCreatGrid()
end

gs_1125.StartCreatGrid = function(self)
  -- function num : 0_2
  self.growGrid = ((self.caster).recordTable).growGrid
  if self.growGrid == nil then
    self.growGrid = {}
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.caster).recordTable).growGrid = self.growGrid
  end
end

gs_1125.OnGridEnterRole = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, role, 1257, 1, nil, true)
end

gs_1125.OnGridBattleEnd = function(self, role)
  -- function num : 0_4 , upvalues : base
  self.growGrid = nil
  ;
  (base.OnGridBattleEnd)(self, role)
end

gs_1125.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  self.growGrid = nil
  ;
  (base.LuaDispose)(self)
end

return gs_1125

