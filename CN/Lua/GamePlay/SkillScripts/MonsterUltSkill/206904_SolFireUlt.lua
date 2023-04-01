-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.100303_SolFireUlt")
local bs_206904 = class("bs_206904", base)
bs_206904.config = {delayInvoke = 7, buffId_Super = 196, actionId_start = 1001, radius = 300, arcAngleRange = 121}
bs_206904.config = setmetatable(bs_206904.config, {__index = base.config})
bs_206904.HandleSelectTarget = function(self)
  -- function num : 0_0 , upvalues : _ENV
  local role = ((self.caster).recordTable).lastAttackRole
  do
    if role == nil or not LuaSkillCtrl:IsAbleAttackTarget(self.caster, role, (self.cskill).SkillRange) then
      local target = self:GetMoveSelectTarget()
      role = target.targetRole
    end
    self.selectRoles = {}
    local casterLsObj = (self.caster).lsObject
    local selectTargetPos = (role.lsObject).localPosition
    local forwardDir = ((((CS.TrueSync).TSVector3).Subtract)(selectTargetPos, casterLsObj.localPosition)).normalized
    local ColliderEnter = BindCallback(self, self.OnColliderEnter, forwardDir, selectTargetPos)
    self.fireCollider = LuaSkillCtrl:CallGetCircleSkillCollider(self, (self.config).radius, eColliderInfluenceType.Enemy, ColliderEnter)
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.fireCollider).lsObject = (CS.LSUnityObject)()
    ;
    (self.fireCollider):SetColiderObjPosForce(casterLsObj.localPosition)
    ;
    (self.caster):LookAtInstantly(role)
    return role
  end
end

bs_206904.OnColliderEnter = function(self, forwardDir, selectTargetPos, collider, index, entity)
  -- function num : 0_1 , upvalues : _ENV
  local angle = 0
  if not ((entity.lsObject).localPosition):Equals(selectTargetPos) then
    local curdir = ((((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, selectTargetPos)).normalized
    local quaForward = (((CS.TrueSync).TSQuaternion).LookRotation)(forwardDir)
    local qua = (((CS.TrueSync).TSQuaternion).LookRotation)(curdir)
    if not qua:Equals(quaForward) then
      angle = ((((CS.TrueSync).TSQuaternion).PerigonAngle)(quaForward, qua)):AsInt()
    end
  end
  do
    if angle > 180 then
      angle = 360 - angle
    end
    if (self.config).arcAngleRange < angle then
      return 
    end
    if self.caster == nil or (self.caster).hp <= 0 then
      return 
    end
    ;
    (table.insert)(self.selectRoles, entity)
  end
end

bs_206904.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  local targetRole = self:HandleSelectTarget()
  if targetRole == nil then
    return nil
  end
  self:CallCasterWait(43)
  LuaSkillCtrl:StartTimer(nil, 1, BindCallback(self, self.InternalPlay, targetRole))
end

bs_206904.InternalPlay = function(self, targetRole)
  -- function num : 0_3 , upvalues : _ENV
  if self.fireCollider ~= nil then
    LuaSkillCtrl:ClearColliderOrEmission(self.fireCollider)
    self.fireCollider = nil
  end
  if (self.config).buffId_Super ~= nil then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Super, 1, 15, true)
  end
  if (self.config).actionId_start ~= nil then
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start)
  end
  self.invokeTimer = LuaSkillCtrl:StartTimer(nil, (self.config).delayInvoke, BindCallback(self, self.InternalInvoke, self.config, targetRole, self.selectRoles))
end

bs_206904.InternalInvoke = function(self, data, targetRole, roles)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.PlaySkill)(self, data, targetRole, roles, SelectRolesType.LuaRoleArray)
end

bs_206904.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_206904.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.selectRoles = nil
end

return bs_206904

