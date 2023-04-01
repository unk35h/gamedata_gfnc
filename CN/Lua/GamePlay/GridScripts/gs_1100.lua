-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1100 = class("gs_1100", LuaGridBase)
gs_1100.config = {effectId = 12017}
gs_1100.ctor = function(self)
  -- function num : 0_0
end

gs_1100.OnGridBattleStart = function(self, role)
  -- function num : 0_1
end

gs_1100.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if self.AddPower ~= nil then
    (self.AddPower):Stop()
    self.Addpower = nil
  end
  if role ~= nil and role.belongNum == eBattleRoleBelong.player then
    self.AddPower = LuaSkillCtrl:StartTimer(nil, 30, function()
    -- function num : 0_2_0 , upvalues : _ENV, role, self
    LuaSkillCtrl:AddPlayerTowerMp(1)
    LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  end
, -1, 30)
  end
end

gs_1100.OnGridExitRole = function(self, role)
  -- function num : 0_3
  if self.AddPower ~= nil then
    (self.AddPower):Stop()
    self.Addpower = nil
  end
end

gs_1100.OnGridRoleDead = function(self, role)
  -- function num : 0_4
  if self.AddPower ~= nil then
    (self.AddPower):Stop()
    self.Addpower = nil
  end
end

return gs_1100

