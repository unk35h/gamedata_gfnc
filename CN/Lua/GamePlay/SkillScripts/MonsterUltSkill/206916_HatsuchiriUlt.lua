-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.104203_HatsuchiriUlt")
local bs_206916 = class("bs_206916", base)
bs_206916.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206916.config = setmetatable(bs_206916.config, {__index = base.config})
bs_206916.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206916.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.PlaySkill)(self, data, role, role, SelectRolesType.SingleRole)
end

bs_206916.Sneak = function(self, selectRole)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl:IsRoleAdjacent(self.caster, selectRole) == true then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skillCD, 1, (self.config).end_time, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time, true)
    self:CallCasterWait((self.config).end_time)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
    LuaSkillCtrl:CallEffect(selectRole, (self.config).effect_out, self)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_up)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, selectRole)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[2]})
    skillResult:EndResult()
    LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_2_0 , upvalues : _ENV, selectRole, self
    LuaSkillCtrl:CallEffect(selectRole, (self.config).effect_hit, self)
  end
)
    ;
    (self.caster):LookAtTarget(selectRole)
    -- DECOMPILER ERROR at PC83: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = selectRole
    return 
  end
  do
    local grid = LuaSkillCtrl:FindEmptyGridsWithinRange(selectRole.x, selectRole.y, 10, false)
    if grid == nil then
      return 
    end
    local targetGrid = LuaSkillCtrl:GetGridWithPos((grid[0]).x, (grid[0]).y)
    local MoveTime = LuaSkillCtrl:GetGridsDistance(targetGrid.x, targetGrid.y, (self.caster).x, (self.caster).y)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skillCD, 1, (self.config).end_time + MoveTime, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time + MoveTime, true)
    local effectGrid = LuaSkillCtrl:GetTargetWithGrid(targetGrid.x, targetGrid.y)
    LuaSkillCtrl:CallEffect(effectGrid, (self.config).effect_trail, self)
    LuaSkillCtrl:CallPhaseMoveWithoutTurnAndAllowCcd(self, self.caster, targetGrid.x, targetGrid.y, MoveTime, (self.config).buff_move)
    self:CallCasterWait((self.config).end_time + MoveTime)
    LuaSkillCtrl:StartTimer(self, MoveTime, function()
    -- function num : 0_2_1 , upvalues : _ENV, self, selectRole
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
    LuaSkillCtrl:CallEffect(selectRole, (self.config).effect_out, self)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_up)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, selectRole)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[2]})
    skillResult:EndResult()
    LuaSkillCtrl:StartTimer(self, 3, function()
      -- function num : 0_2_1_0 , upvalues : _ENV, selectRole, self
      LuaSkillCtrl:CallEffect(selectRole, (self.config).effect_hit, self)
    end
)
    LuaSkillCtrl:CallReFillMainSkillCdForRole(self.caster)
    ;
    (self.caster):LookAtTarget(selectRole)
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = selectRole
  end
)
  end
end

bs_206916.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206916

