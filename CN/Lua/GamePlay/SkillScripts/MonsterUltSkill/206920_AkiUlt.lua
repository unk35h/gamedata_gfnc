-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.102203_AkiUlt")
local bs_206920 = class("bs_206920", base)
bs_206920.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206920.config = setmetatable(bs_206920.config, {__index = base.config})
bs_206920.HandleSelectTarget = function(self)
  -- function num : 0_0 , upvalues : _ENV
  local role = ((self.caster).recordTable).lastAttackRole
  do
    if role == nil or not LuaSkillCtrl:IsAbleAttackTarget(self.caster, role, (self.cskill).SkillRange) then
      local target = self:GetMoveSelectTarget()
      role = target.targetRole
    end
    ;
    (self.caster):LookAtInstantly(role)
    return role
  end
end

bs_206920.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_1
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206920.InternalInvoke = function(self, data, role)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.PlaySkill)(self, data, role, role, SelectRolesType.SingleRole)
end

bs_206920.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206920

