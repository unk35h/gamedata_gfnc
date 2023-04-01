-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1106 = class("gs_1106", LuaGridBase)
gs_1106.config = {buffId = 110001, buffId2 = 1221}
gs_1106.ctor = function(self)
  -- function num : 0_0
end

gs_1106.__OnGridSkillInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (LuaGridBase.__OnGridSkillInit)(self)
  self.timer = LuaSkillCtrl:StartTimer(nil, 75, BindCallback(self, self.OnGridLoseEffect))
end

gs_1106.OnGridLoseEffect = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.influenceRole ~= nil then
    LuaSkillCtrl:DispelBuff(self.influenceRole, (self.config).buffId, 0, true, true)
    LuaSkillCtrl:DispelBuff(self.influenceRole, (self.config).buffId2, 0, true, true)
    self.influenceRole = nil
  end
  self.timer = nil
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.KillWaveEffect, self.x, self.y)
  self:GridLoseEffect()
end

gs_1106.OnGridBattleStart = function(self, role)
  -- function num : 0_3
end

gs_1106.OnGridEnterRole = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  if (role.recordTable)["10302_arg"] ~= nil and (role.recordTable)["10302_arg"] > 0 then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId2, (role.recordTable)["10302_arg"], nil, true)
  end
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1, nil, true)
  self.influenceRole = role
end

gs_1106.OnGridExitRole = function(self, role)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(role, (self.config).buffId, 0, true, true)
  LuaSkillCtrl:DispelBuff(role, (self.config).buffId2, 0, true, true)
  if self.influenceRole == role then
    self.influenceRole = nil
  else
    if self.influenceRole ~= nil then
      LuaSkillCtrl:DispelBuff(self.influenceRole, (self.config).buffId, 0, true, true)
      LuaSkillCtrl:DispelBuff(self.influenceRole, (self.config).buffId2, 0, true, true)
      self.influenceRole = nil
    end
  end
end

gs_1106.OnGridRoleDead = function(self, role)
  -- function num : 0_6
end

gs_1106.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (LuaGridBase.LuaDispose)(self)
  self.influenceRole = nil
end

return gs_1106

