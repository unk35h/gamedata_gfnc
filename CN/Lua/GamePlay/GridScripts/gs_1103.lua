-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_1103 = class("gs_1103", LuaGridBase)
gs_1103.config = {BuffId = 110001, BuffDistance = 2, effectId = 12020}
gs_1103.ctor = function(self)
  -- function num : 0_0
end

gs_1103.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  self.gridEffect = nil
end

gs_1103.OnGridEnterRole = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if self.buffAdd ~= nil then
    (self.buffAdd):Stop()
    self.buffAdd = nil
  end
  if role ~= nil then
    local gridTarget = LuaSkillCtrl:GetTargetWithGrid(self.x, self.y)
    self.gridEffect = LuaSkillCtrl:CallEffect(gridTarget, (self.config).effectId, self)
    local targetlist = LuaSkillCtrl:FindAllRolesWithinRange(role, 2, true)
    if targetlist ~= nil then
      local collisionTrigger = BindCallback(self, self.AddBuffToRole, role)
      self.buffAdd = LuaSkillCtrl:StartTimer(nil, 10, collisionTrigger, -1, 10)
    end
  end
end

gs_1103.AddBuffToRole = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  local AddBuffList = LuaSkillCtrl:FindAllRolesWithinRange(role, 2, true)
  if AddBuffList ~= nil and AddBuffList.Count > 0 then
    for i = 0, AddBuffList.Count - 1 do
      local buffTier = (AddBuffList[i]):GetBuffTier((self.config).BuffId)
      if buffTier == 0 then
        LuaSkillCtrl:CallBuff(self, AddBuffList[i], (self.config).BuffId, 1, 10)
      end
    end
  end
end

gs_1103.OnGridExitRole = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  if self.buffAdd ~= nil then
    (self.buffAdd):Stop()
    self.buffAdd = nil
  end
  if self.gridEffect ~= nil then
    (self.gridEffect):Die()
    self.gridEffect = nil
  end
  local RemoveBuffList = LuaSkillCtrl:FindAllRolesWithinRange(role, (self.config).BuffDistance, true)
  if RemoveBuffList ~= nil and RemoveBuffList.Count > 0 then
    for i = 0, RemoveBuffList.Count - 1 do
      local buffTier = (RemoveBuffList[i]):GetBuffTier((self.config).BuffId)
      if buffTier > 0 then
        LuaSkillCtrl:DispelBuff((RemoveBuffList[i]).targetrole, (self.config).BuffId, buffTier)
      end
    end
  end
end

gs_1103.OnGridRoleDead = function(self, role)
  -- function num : 0_5
  if self.buffAdd ~= nil then
    (self.buffAdd):Stop()
    self.buffAdd = nil
  end
end

return gs_1103

