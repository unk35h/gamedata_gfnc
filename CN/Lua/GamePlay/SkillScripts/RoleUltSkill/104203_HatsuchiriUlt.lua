-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104203 = class("bs_104203", LuaSkillBase)
local base = LuaSkillBase
bs_104203.config = {effect_in = 104211, effect_out = 104212, effect_trail = 104213, effect_hit = 104217, actionId_speed = 1, actionId = 1008, actionId_end = 1009, start_time = 15, end_time = 9, buffId_god = 3009, buffId_yinshen = 3016, buff_move = 104202, buff_chanrao = 104203, buffId_skillCD = 170, buffId_attackCD = 104205, 
hurt_config = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0}
, audioIdStart = 104209, audioIdMovie = 104210, audioId_up = 104211}
bs_104203.ctor = function(self)
  -- function num : 0_0
end

bs_104203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104203.PlaySkill = function(self, data, selectTargetCoord, selectRoles, SelectRolesType)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.SneakPrepare), SelectRolesType)
end

bs_104203.SneakPrepare = function(self, selectRole)
  -- function num : 0_3 , upvalues : _ENV
  (self.caster):LookAtTarget(selectRole)
  self:CallCasterWait((self.config).start_time)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skillCD, 1, (self.config).start_time + 3, true)
  local attackTrigger = BindCallback(self, self.Sneak, selectRole)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_in, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_yinshen, 1, 15)
  LuaSkillCtrl:CallBuff(self, selectRole, (self.config).buff_chanrao, 1, (self.arglist)[1], false)
end

bs_104203.Sneak = function(self, selectRole)
  -- function num : 0_4 , upvalues : _ENV
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
    -- function num : 0_4_0 , upvalues : _ENV, selectRole, self
    LuaSkillCtrl:CallEffect(selectRole, (self.config).effect_hit, self)
  end
)
    LuaSkillCtrl:CallReFillMainSkillCdForRole(self.caster)
    ;
    (self.caster):LookAtTarget(selectRole)
    -- DECOMPILER ERROR at PC87: Confused about usage of register: R3 in 'UnsetPending'

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
    -- function num : 0_4_1 , upvalues : _ENV, self, selectRole
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
    LuaSkillCtrl:CallEffect(selectRole, (self.config).effect_out, self)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_up)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, selectRole)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[2]})
    skillResult:EndResult()
    LuaSkillCtrl:StartTimer(self, 3, function()
      -- function num : 0_4_1_0 , upvalues : _ENV, selectRole, self
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

bs_104203.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_5 , upvalues : base, _ENV
  if selectRoles == nil or selectRoles.Count <= 0 then
    return true
  end
  ;
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104203.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 2)
end

bs_104203.OnSkipUltView = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104203.OnMovieFadeOut = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104203.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104203.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_104203

