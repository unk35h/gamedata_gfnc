-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206503 = class("bs_206503", LuaSkillBase)
local base = LuaSkillBase
bs_206503.config = {buffId_judge = 206801, buffId_jifei = 165, effectId_start = 2065021, effectId_hit = 2065011, effectId_buffHit = 2068012, effectId_buffPull = 2068018, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0}
}
bs_206503.ctor = function(self)
  -- function num : 0_0
end

bs_206503.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206503.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local SkillDuration = 32
  local SkillStart = 19
  self.isInSkill = true
  self:CallCasterWait(SkillDuration)
  self:AbandonSkillCdAutoReset(true)
  LuaSkillCtrl:StartShowSkillDurationTime(self, SkillDuration)
  LuaSkillCtrl:StartTimer(self, SkillDuration, function()
    -- function num : 0_2_0 , upvalues : self
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
)
  local last_target = ((self.caster).recordTable).lastAttackRole
  local targetRole = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    targetRole = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    do
      if tempTarget == nil then
        return 
      end
      targetRole = tempTarget.targetRole
    end
  end
  do
    if targetRole ~= nil then
      (self.caster):LookAtTarget(targetRole)
      local x = targetRole.x
      local y = targetRole.y
      local effectGrid = LuaSkillCtrl:GetTargetWithGrid(targetRole.x, targetRole.y)
      LuaSkillCtrl:StartTimer(self, SkillStart, function()
    -- function num : 0_2_1 , upvalues : self, x, y, effectGrid
    self:OnAttackTrigger(x, y, effectGrid)
  end
)
      LuaSkillCtrl:CallRoleAction(self.caster, 1020, 1)
      LuaSkillCtrl:PlayAuSource(self.caster, 443)
    end
  end
end

bs_206503.OnAttackTrigger = function(self, x, y, effectGrid)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_start, self)
  local radius = 80
  local speed = 20
  local TargetGrid = LuaSkillCtrl:CallFindFurthestGridInDirRangeWithoutObstacle((self.caster).x, (self.caster).y, x, y, 2)
  local collisionTrigger = BindCallback(self, self.OnColliderEnter, x, y)
  local ColliderTarget = LuaSkillCtrl:GetTargetWithGrid(TargetGrid.x, TargetGrid.y)
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, ColliderTarget, radius, speed, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, false, true, nil)
end

bs_206503.OnColliderEnter = function(self, x, y, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  local targets = LuaSkillCtrl:GetTargetWithGrid(x, y)
  local gridPos = targets:GetLogicPos()
  local shootDir = ((((CS.TrueSync).TSVector3).Subtract)(gridPos, ((self.caster).lsObject).localPosition)).normalized
  local shootDir2D = ((CS.TrueSync).TSVector2)(shootDir.x, shootDir.z)
  local bornPos = ((self.caster).lsObject).localPosition
  if not ((entity.lsObject).localPosition):Equals(bornPos) then
    local tsVec2 = (CS.TrueSync).TSVector2
    local curDir = (((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, bornPos)
    local curDir2d = (tsVec2(curDir.x, curDir.z)).normalized
    local angle = LuaSkillCtrl:CallTSVec2Angle(curDir2d, shootDir2D)
    if angle > 100 or angle < -100 then
      return 
    end
  end
  do
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
    for i = 0, (skillResult.roleList).Count - 1 do
      if LuaSkillCtrl:IsFixedObstacle((skillResult.roleList)[i]) then
        return 
      end
      LuaSkillCtrl:CallEffect((skillResult.roleList)[i], (self.config).effectId_hit, self)
    end
    skillResult:EndResult()
    if LuaSkillCtrl:IsObstacle(entity) then
      return 
    end
    if entity:GetBuffTier((self.config).buffId_judge) > 0 and LuaSkillCtrl:IsRoleAdjacent(self.caster, entity) == false then
      LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_judge, 1)
      LuaSkillCtrl:CallEffect(entity, (self.config).effectId_buffPull, self)
      LuaSkillCtrl:CallEffect(entity, (self.config).effectId_buffHit, self)
      local emptyGrid = LuaSkillCtrl:FindEmptyGridWithinRange(self.caster, 1)
      if emptyGrid == nil then
        return 
      end
      if not LuaSkillCtrl:RoleContainsBuffFeature(entity, 15) then
        LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_jifei, 1, 6)
        LuaSkillCtrl:CallPhaseMove(self, entity, emptyGrid.x, emptyGrid.y, 4, 63)
      end
    end
  end
end

bs_206503.OnBreakSkill = function(self, role)
  -- function num : 0_5 , upvalues : base
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.isInSkill then
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
end

return bs_206503

