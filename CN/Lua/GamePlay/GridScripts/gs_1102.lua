-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1102 = class("gs_1102", LuaGridBase)
gs_1102.config = {duration = 30, effectId = 12019}
gs_1102.ctor = function(self)
  -- function num : 0_0
end

gs_1102.OnGridBattleStart = function(self, role)
  -- function num : 0_1
end

gs_1102.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.neutral then
    return 
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  local callBack = BindCallback(self, self.CallBack, role)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).duration, callBack, nil, -1)
end

gs_1102.CallBack = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local heal = role.maxHp * 50 // 1000
  LuaSkillCtrl:CallHeal(heal, self, role, true)
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
end

gs_1102.OnGridExitRole = function(self, role)
  -- function num : 0_4
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

gs_1102.OnGridRoleDead = function(self, role)
  -- function num : 0_5
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return gs_1102

