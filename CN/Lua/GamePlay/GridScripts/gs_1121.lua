-- params : ...
-- function num : 0 , upvalues : _ENV
local base = LuaGridBase
local gs_1121 = class("gs_1121", base)
gs_1121.config = {effectId = 206903, head_scale = 2, body_scale = 0.8}
gs_1121.ctor = function(self)
  -- function num : 0_0
end

gs_1121.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  if role ~= nil then
    self:SetRoleHead(role)
  end
  self:GridLoseEffect()
end

gs_1121.SetRoleHead = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl.IsInVerify then
    return 
  end
  local roleActionId = 1001
  if role.roleDataId == 1001005 or role.roleDataId == 1001009 then
    roleActionId = 1031
  end
  LuaSkillCtrl:CallRoleAction(role, roleActionId, 1)
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  local bindComp = role:GetBindPointComponent()
  if IsNull(bindComp) then
    return 
  end
  local transA = bindComp:GetBindPoint(102)
  if IsNull(transA) then
    return 
  end
  local transB = ((role.lsObject).transform):GetChild(0)
  if IsNull(transB) then
    return 
  end
  transA:SetLocalScale((self.config).head_scale, (self.config).head_scale, (self.config).head_scale)
  transB:SetLocalScale((self.config).body_scale, (self.config).body_scale, (self.config).body_scale)
end

return gs_1121

