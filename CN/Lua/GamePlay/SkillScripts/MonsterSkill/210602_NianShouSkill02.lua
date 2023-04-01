-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210602 = class("bs_210602", LuaSkillBase)
local base = LuaSkillBase
bs_210602.config = {skilltime = 40, actionId = 1020, action_speed = 1, actionId_start_time = 8, effect_cast = 210606, effect_hit = 210607, effect_cast2 = 210615, configId = 3, buffId_124 = 124, buffId_63 = 63, buffId_fly = 5002101, buffId_69 = 69, buffId_198 = 198}
bs_210602.ctor = function(self)
  -- function num : 0_0
end

bs_210602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_210602.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target = self:GetTarget()
  ;
  (self.caster):LookAtTarget(target)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_cast, self, nil)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_cast2, self)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  local time = (self.config).skilltime
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  LuaSkillCtrl:StartTimer(self, time, callnextskill)
end

bs_210602.GetTarget = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 72, 10)
  if targetList.Count == 0 then
    return nil
  end
  local grid, role = nil, nil
  for i = 0, targetList.Count - 1 do
    local tempRole = (targetList[i]).targetRole
    if tempRole.roleType == eBattleRoleType.realSummoner then
      grid = LuaSkillCtrl:FindEmptyGridAroundRole(tempRole)
      if grid ~= nil then
        role = (targetList[i]).targetRole
        return role
      end
    end
    if grid == nil then
      grid = LuaSkillCtrl:FindEmptyGridAroundRole(tempRole)
      if grid ~= nil then
        role = tempRole
      end
    end
  end
  if role == nil then
    role = (targetList[0]).targetRole
    return role
  end
  return role
end

bs_210602.OnAttackTrigger = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local role = self:GetTarget()
  if role == nil then
    return 
  end
  ;
  (self.caster):LookAtTarget(role)
  local grid_go, grid_up = nil, nil
  if not LuaSkillCtrl:RoleContainsBuffFeature(role, eBuffFeatureType.CtrlImmunity) then
    local gridList = LuaSkillCtrl:FindEmptyGridsWithinRange(role.x, role.y, 5)
    if gridList == nil then
      return 
    end
    if gridList.Count > 0 then
      grid_go = LuaSkillCtrl:GetGridWithRole(role)
      grid_up = gridList[0]
    end
  else
    do
      do
        local gridList = LuaSkillCtrl:FindEmptyGridsWithinRange(role.x, role.y, 1)
        if gridList == nil then
          return 
        end
        if gridList.Count > 0 then
          grid_go = gridList[0]
        end
        if grid_go == nil then
          return 
        end
        if grid_up ~= nil then
          LuaSkillCtrl:PreSetRolePos(grid_up, self.caster)
        else
          LuaSkillCtrl:PreSetRolePos(grid_go, self.caster)
        end
        local MoveTime = 8
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_124, 1, 10 + MoveTime)
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_198, 1, 10 + MoveTime)
        LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_4_0 , upvalues : grid_up, _ENV, self, grid_go, MoveTime, role
    if grid_up == nil then
      LuaSkillCtrl:CanclePreSetPos(self.caster)
    end
    if not LuaSkillCtrl:InInPhaseMove(self.caster) then
      (self.caster):LookAtTarget(LuaSkillCtrl:GetTargetWithGrid(grid_go.x, grid_go.y))
      LuaSkillCtrl:CallPhaseMoveWithoutTurnAndAllowCcd(self, self.caster, grid_go.x, grid_go.y, MoveTime, (self.config).buffId_69)
      LuaSkillCtrl:StartTimer(nil, MoveTime, function()
      -- function num : 0_4_0_0 , upvalues : role, _ENV, self, grid_up, grid_go
      if role == nil or role.hp <= 0 then
        return 
      end
      LuaSkillCtrl:CallEffect(role, (self.config).effect_hit, self)
      LuaSkillCtrl:CallBattleCamShakeByParam(0, 1, 0.5, 5)
      if grid_up ~= nil then
        LuaSkillCtrl:CanclePreSetPos(self.caster)
        if not LuaSkillCtrl:InInPhaseMove(self.caster) and role.x == grid_go.x and role.y == grid_go.y then
          LuaSkillCtrl:CallPhaseMove(self, role, grid_up.x, grid_up.y, 3, (self.config).buffId_63)
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_fly, 1, 3, true)
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
          skillResult:EndResult()
        end
      else
        do
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
          skillResult:EndResult()
        end
      end
    end
)
    end
  end
)
      end
    end
  end
end

bs_210602.EndSkillAndCallNext = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, 170, 0)
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  ;
  (self.caster):CallUnFreezeNextSkill()
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_210602.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210602

