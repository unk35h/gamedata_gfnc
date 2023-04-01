-- params : ...
-- function num : 0 , upvalues : _ENV
local AuraBaseSkill = class("bs_1", LuaSkillBase)
local base = LuaSkillBase
AuraBaseSkill.config = {}
AuraBaseSkill.CallAura = function(self, buffId, buffTier, influenceType, casterRole, range)
  -- function num : 0_0 , upvalues : _ENV
  local collisionEnter = BindCallback(self, self.__OnAuraCollisionEnter, buffId, buffTier)
  local collisionExit = BindCallback(self, self.__OnAuraCollisionExit, buffId)
  return LuaSkillCtrl:CallCircledEmissionStraightly(self, casterRole, casterRole, range, 0, influenceType, collisionEnter, nil, collisionExit, nil, false, false, nil, casterRole)
end

AuraBaseSkill.CallAuraWithTrigger = function(self, influenceType, casterRole, range, onAuraEnter, onAuraExit)
  -- function num : 0_1 , upvalues : _ENV
  local collisionEnter = BindCallback(self, onAuraEnter)
  local collisionExit = BindCallback(self, onAuraExit)
  return LuaSkillCtrl:CallCircledEmissionStraightly(self, casterRole, casterRole, range, 0, influenceType, collisionEnter, nil, collisionExit, nil, false, false, nil, casterRole)
end

AuraBaseSkill.__OnAuraCollisionEnter = function(self, buffId, buffTier, collider, index, entity)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, entity, buffId, buffTier)
end

AuraBaseSkill.__OnAuraCollisionExit = function(self, buffId, collider, entity)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(entity, buffId, 0)
end

AuraBaseSkill.KillAura = function(self, auraEmission)
  -- function num : 0_4
  if auraEmission ~= nil then
    auraEmission:EndAndDisposeEmission()
  end
end

return AuraBaseSkill

