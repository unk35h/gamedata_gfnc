-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106503 = class("bs_106503", LuaSkillBase)
local base = LuaSkillBase
bs_106503.config = {buffId_124 = 124, buffId_63 = 63, buffId_fly = 5002101, buffId_69 = 69, buffId_198 = 198, MoveDuration = 8, start_time = 0, end_time = 31, buffId_Back = 106508, buffId_Stun = 106507, actionId = 1005, action_speed = 1, actionId_loop = 1010, actionId_end = 1006, configId = 2, effectId_1 = 106510, effectId_2 = 106511, effectId_3 = 106512, effectId_4 = 106513, effectId_hit = 106514, audioIdStart = 106512, audioIdMovie = 106513, audioId_attack = 106515, audioId_loop = 106514}
bs_106503.AbandonTakeFeature = {}
bs_106503.ctor = function(self)
  -- function num : 0_0
end

bs_106503.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106503.CheckManualSkillTakeAvailable = function(self, role)
  -- function num : 0_2 , upvalues : base
  return (base.CheckManualSkillTakeAvailable)(self, role)
end

bs_106503.PlaySkill = function(self, data, selectTargetCoord, selectRoles, SelectRolesType)
  -- function num : 0_3 , upvalues : _ENV
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.SneakPrepare), SelectRolesType)
end

bs_106503.SneakPrepare = function(self, selectRole)
  -- function num : 0_4 , upvalues : _ENV
  (self.caster):LookAtTarget(selectRole)
  if LuaSkillCtrl:IsRoleAdjacent(self.caster, selectRole) == true then
    self:SkillEffectFunc(selectRole)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = selectRole
    return 
  end
  self:CallCasterWait(8)
  local attackTrigger = BindCallback(self, self.Sneak, selectRole)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_loop, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_2, self)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_3, self)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_4, self)
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnLindHurt, 3)
end

bs_106503.Sneak = function(self, selectRole)
  -- function num : 0_5 , upvalues : _ENV
  local grid, minDis = nil, nil
  local grids = LuaSkillCtrl:FindAllGridsWithinRange(selectRole, 1, false)
  if grids ~= nil then
    for i = 0, grids.Count - 1 do
      local tempGrid = grids[i]
      local isCanGo = false
      local tempRole = tempGrid.role
      -- DECOMPILER ERROR at PC31: Unhandled construct in 'MakeBoolean' P1

      if tempRole ~= nil and LuaSkillCtrl:IsFixedObstacle(tempRole) == false and LuaSkillCtrl:IsObstacle(tempRole) == true then
        isCanGo = true
      end
      isCanGo = true
      if isCanGo then
        local dis = LuaSkillCtrl:GetGridsDistance((self.caster).x, (self.caster).y, tempGrid.x, tempGrid.y)
        if minDis == nil or dis < minDis then
          minDis = dis
          grid = tempGrid
        end
      end
    end
  end
  do
    if grid ~= nil then
      local time = minDis * 2
      local targetRole = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
      ;
      (self.caster):LookAtTarget(targetRole)
      local collisionEnter = BindCallback(self, self.OnCollisionEnter)
      local collisionArrive = BindCallback(self, self.OnCollisionArrive, selectRole)
      self.loopAudio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_loop)
      LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, targetRole, 50, 0, eColliderInfluenceType.Enemy, collisionEnter, nil, nil, nil, false, true, collisionArrive, self.caster)
      LuaSkillCtrl:CallPhaseMoveWithoutTurnAndAllowCcd(self, self.caster, grid.x, grid.y, time, (self.config).buffId_69)
    end
  end
end

bs_106503.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_fly, 1, 3, true)
  if LuaSkillCtrl:IsFixedObstacle(entity) == false and LuaSkillCtrl:IsObstacle(entity) == true then
    LuaSkillCtrl:RemoveLife(entity.hp + 1, self, entity, true, nil, false, true)
  else
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
    skillResult:EndResult()
  end
end

bs_106503.OnCollisionArrive = function(self, selectRole)
  -- function num : 0_7
  if self.loopAudio ~= nil then
    self:SkillEffectFunc(selectRole)
  end
end

bs_106503.SkillEffectFunc = function(self, selectRole)
  -- function num : 0_8 , upvalues : _ENV
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_attack)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
  self:CallCasterWait((self.config).end_time)
  ;
  (self.caster):LookAtTarget(selectRole)
  LuaSkillCtrl:CallEffect(selectRole, (self.config).effectId_1, self)
  LuaSkillCtrl:StartTimer(self, 2, function()
    -- function num : 0_8_0 , upvalues : selectRole, _ENV, self
    local lastPosX = selectRole.x
    local lastPosY = selectRole.y
    LuaSkillCtrl:CallBuff(self, selectRole, (self.config).buffId_Back, 1, 3)
    LuaSkillCtrl:CallBuff(self, selectRole, (self.config).buffId_fly, 1, 3, true)
    if selectRole.x == lastPosX and selectRole.y == lastPosY then
      LuaSkillCtrl:CallBuff(self, selectRole, (self.config).buffId_Stun, 1, (self.arglist)[3])
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, selectRole)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[2]})
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(selectRole, (self.config).effectId_hit, self)
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnLindHurt, 4, selectRole)
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = selectRole
  end
)
end

bs_106503.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_9 , upvalues : _ENV, base
  if selectRoles == nil or selectRoles.Count <= 0 then
    return true
  end
  local role = LuaSkillCtrl:GetRoleWithPos(selectTargetCoord.x, selectTargetCoord.y)
  local space = false
  if role ~= nil and role.hp > 0 then
    local grid = LuaSkillCtrl:FindEmptyGridAroundRole(role)
    if grid ~= nil then
      space = true
    end
    if grid == nil then
      local targetList = LuaSkillCtrl:FindRolesAroundRole(role)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          local role_1 = targetList[i]
          if role_1 == self.caster then
            space = true
            break
          end
          if LuaSkillCtrl:IsFixedObstacle(role_1) == false and LuaSkillCtrl:IsObstacle(role_1) == true then
            space = true
            break
          end
        end
      end
    end
  end
  do
    if space == false then
      return true
    end
    ;
    (base.PlayUltEffect)(self)
    LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
    LuaSkillCtrl:CallFocusTimeLine(self.caster)
  end
end

bs_106503.OnUltRoleAction = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_106503.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106503

