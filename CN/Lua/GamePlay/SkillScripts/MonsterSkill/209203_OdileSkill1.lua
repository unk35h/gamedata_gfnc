-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209203 = class("bs_209203", LuaSkillBase)
local base = LuaSkillBase
bs_209203.config = {buffId_fly = 209204, buffId_hurt = 209205, buffId_lockCd = 170, actionId_start = 1008, actionId_loop = 1007, actionId_end = 1009, actionId_end1 = 1053, action_speed = 1, actionId_start_time = 30, actionId_end_time = 22, actionId_end1_time = 38, effectId_fly = 209204, effectId_shootLeft = 209205, effectId_shootRight = 209206, effectId_trail = 209207, effectId_trailHit = 209208, effectId_interrupt = 209209, configId = 3}
bs_209203.ctor = function(self)
  -- function num : 0_0
end

bs_209203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = (self.arglist)[2]
end

bs_209203.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:OnSkillTake()
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_209203_1", 1, self.OnBreakShield)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_fly, self)
  local time = (self.config).actionId_start_time + (self.config).actionId_end_time + self.loopTime
  self:CallCasterWait(time)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_fly, 1, time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
  self.loopAttack = LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, (self.config).action_speed)
  end
, nil)
  self.finishAttack = LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time + self.loopTime, function()
    -- function num : 0_2_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
    self:RemoveSkillTrigger(eSkillTriggerType.OnBreakShield)
  end
, nil)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_lockCd, 1, time, true)
  self:AbandonSkillCdAutoReset(true)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  LuaSkillCtrl:StartTimer(self, time, callnextskill)
end

bs_209203.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:ChangeRoleHeadInfoWorldOffest(self.caster, 1.6)
  local value = (self.caster).maxHp * (self.arglist)[4] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Beelneith, value)
  local shoot = BindCallback(self, self.ShootWave)
  self.onLoopAttack = LuaSkillCtrl:StartTimer(self, (self.arglist)[3], shoot, self, -1, (self.arglist)[3] // 2)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[2])
  self.boom = LuaSkillCtrl:StartTimer(self, (self.arglist)[2], function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    local SelfShieldValue = LuaSkillCtrl:GetShield(self.caster, 3)
    if SelfShieldValue ~= 0 then
      LuaSkillCtrl:ClearShield(self.caster, 3)
    end
  end
)
end

bs_209203.ShootWave = function(self, last_target)
  -- function num : 0_4 , upvalues : _ENV
  local hpRate = (self.caster)._curHp * 1000 // (self.caster).maxHp
  local target = nil
  if hpRate <= 500 then
    local targets = LuaSkillCtrl:CallTargetSelect(self, 19, 10)
    if targets.Count > 0 then
      target = (targets[0]).targetRole
    end
  else
    do
      local last_target = ((self.caster).recordTable).lastAttackRole
      if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, (self.cskill).SkillRange) then
        target = last_target
      else
        local tempTarget = self:GetMoveSelectTarget()
        if tempTarget == nil then
          return 
        end
        target = tempTarget.targetRole
      end
      do
        if target == nil or target.hp <= 0 then
          return 
        end
        ;
        (self.caster):LookAtTarget(target)
        local grid = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
        if grid == nil then
          return 
        end
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_shootRight, self)
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self)
        local gridPos = grid:GetLogicPos()
        local shootDir = ((((CS.TrueSync).TSVector3).Subtract)(gridPos, ((self.caster).lsObject).localPosition)).normalized
        local shootDir2D = ((CS.TrueSync).TSVector2)(shootDir.x, shootDir.z)
        local OnCollition = BindCallback(self, self.OnCollision, shootDir2D)
        LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, grid, 70, 7, 14, OnCollition, nil, nil, nil, true, true)
      end
    end
  end
end

bs_209203.OnCollision = function(self, shootDir2d, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 or entity == nil or entity.hp <= 0 then
    return 
  end
  local bornPos = ((self.caster).lsObject).localPosition
  if not ((entity.lsObject).localPosition):Equals(bornPos) then
    local tsVec2 = (CS.TrueSync).TSVector2
    local curDir = (((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, bornPos)
    local curDir2d = (tsVec2(curDir.x, curDir.z)).normalized
    local angle = LuaSkillCtrl:CallTSVec2Angle(curDir2d, shootDir2d)
    if angle > 100 or angle < -100 then
      return 
    end
  end
  do
    if entity.belongNum ~= (self.caster).belongNum and not LuaSkillCtrl:IsFixedObstacle(entity) then
      self:HurtEnermy(entity)
    end
  end
end

bs_209203.HurtEnermy = function(self, target)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trailHit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
  skillResult:EndResult()
end

bs_209203.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_7 , upvalues : _ENV
  if target == self.caster and shieldType == 3 then
    if self.boom ~= nil then
      (self.boom):Stop()
      self.boom = nil
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_interrupt, self)
    if self.loopAttack ~= nil then
      (self.loopAttack):Stop()
      self.loopAttack = nil
    end
    if self.finishAttack ~= nil then
      (self.finishAttack):Stop()
      self.finishAttack = nil
    end
    if self.onLoopAttack ~= nil then
      (self.onLoopAttack):Stop()
      self.onLoopAttack = nil
    end
    self:RemoveSkillTrigger(eSkillTriggerType.OnBreakShield)
    local OnDropTrigger = BindCallback(self, self.OnDropTrigger)
    self:CancleCasterWait()
    local time = (self.config).actionId_end1_time
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_end1, (self.config).action_speed, (self.config).actionId_end1_time, OnDropTrigger)
  end
end

bs_209203.OnDropTrigger = function(self)
  -- function num : 0_8 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_lockCd, 1)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_fly, 1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_hurt, 1, (self.arglist)[5])
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:EndSkillAndCallNext()
end

bs_209203.EndSkillAndCallNext = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.loopAttack ~= nil then
    (self.loopAttack):Stop()
    self.loopAttack = nil
  end
  if self.finishAttack ~= nil then
    (self.finishAttack):Stop()
    self.finishAttack = nil
  end
  if self.onLoopAttack ~= nil then
    (self.onLoopAttack):Stop()
    self.onLoopAttack = nil
  end
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
  LuaSkillCtrl:ChangeRoleHeadInfoWorldOffest(self.caster, 0.6)
end

bs_209203.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
  if self.loopAttack ~= nil then
    (self.loopAttack):Stop()
    self.loopAttack = nil
  end
  if self.finishAttack ~= nil then
    (self.finishAttack):Stop()
    self.finishAttack = nil
  end
  if self.onLoopAttack ~= nil then
    (self.onLoopAttack):Stop()
    self.onLoopAttack = nil
  end
end

return bs_209203

