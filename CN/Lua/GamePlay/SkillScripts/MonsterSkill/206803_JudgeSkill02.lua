-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206803 = class("bs_206803", LuaSkillBase)
local base = LuaSkillBase
bs_206803.config = {buffId_Jianfang = 206802, buffId_judge = 206801, buffId_rootjudge = 206807, effectId_crime = 2068017, effectId_pinish = 2068019, effectId_pull = 2068018, effectId_hit = 2068002, buffId_jifei = 165, 
HurtConfig_crime = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, hurt_type = -1}
, 
HurtConfig_punish = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, hurt_type = 1}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
}
bs_206803.ctor = function(self)
  -- function num : 0_0
end

bs_206803.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206803.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self.isInSkill = true
  self:CallCasterWait(999)
  self:AbandonSkillCdAutoReset(true)
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
    if ((self.caster).recordTable).mask == 1 then
      local selectTarget = LuaSkillCtrl:GetRoleWithPos(targetRole.x, targetRole.y)
      local x = targetRole.x
      local y = targetRole.y
      LuaSkillCtrl:StartTimer(self, 10, function()
    -- function num : 0_2_0 , upvalues : self, x, y
    self:OnAttackTrigger1(x, y)
  end
)
      LuaSkillCtrl:PlayAuSource(self.caster, 454)
      LuaSkillCtrl:CallRoleAction(self.caster, 1020, 1)
      LuaSkillCtrl:CallEffect(selectTarget, (self.config).effectId_pinish, self)
      LuaSkillCtrl:StartShowSkillDurationTime(self, 30)
      LuaSkillCtrl:StartTimer(self, 30, function()
    -- function num : 0_2_1 , upvalues : self
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
)
    end
    do
      if ((self.caster).recordTable).mask == 2 then
        LuaSkillCtrl:StartTimer(self, 12, function()
    -- function num : 0_2_2 , upvalues : self, targetRole
    self:OnAttackTrigger2(targetRole)
  end
)
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_crime, self)
        LuaSkillCtrl:PlayAuSource(self.caster, 455)
        LuaSkillCtrl:CallRoleAction(self.caster, 1105, 1)
        LuaSkillCtrl:StartShowSkillDurationTime(self, 41)
        LuaSkillCtrl:StartTimer(self, 41, function()
    -- function num : 0_2_3 , upvalues : self
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
)
      end
    end
  end
end

bs_206803.OnAttackTrigger1 = function(self, x, y)
  -- function num : 0_3 , upvalues : _ENV
  local radius = 80
  local speed = 8
  local TargetGrid = LuaSkillCtrl:CallFindFurthestGridInDirRangeWithoutObstacle((self.caster).x, (self.caster).y, x, y, 3)
  local collisionTrigger = BindCallback(self, self.OnColliderEnter, x, y)
  local ColliderTarget = LuaSkillCtrl:GetTargetWithGrid(TargetGrid.x, TargetGrid.y)
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, ColliderTarget, radius, speed, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, false, true, nil)
end

bs_206803.OnColliderEnter = function(self, x, y, collider, index, entity)
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
    LuaSkillCtrl:CallEffect(entity, (self.config).effectId_hit, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig_crime, {(self.arglist)[4]})
    skillResult:EndResult()
    if (entity:GetBuffTier((self.config).buffId_judge) > 0 or entity:GetBuffTier((self.config).buffId_rootjudge) > 0) and LuaSkillCtrl:IsRoleAdjacent(self.caster, entity) == false then
      LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_judge, 1)
      LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_rootjudge, 1)
      local emptyGrid = LuaSkillCtrl:FindEmptyGridWithinRange(self.caster, 1)
      if emptyGrid == nil then
        return 
      end
      if not LuaSkillCtrl:RoleContainsBuffFeature(entity, 15) then
        LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_jifei, 1, 6)
        LuaSkillCtrl:CallEffect(entity, (self.config).effectId_pull, self)
        LuaSkillCtrl:CallPhaseMove(self, entity, emptyGrid.x, emptyGrid.y, 4, 63)
      end
    end
  end
end

bs_206803.OnAttackTrigger2 = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_config)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig_punish, {(self.arglist)[1]})
  if (skillResult.roleList).Count > 0 then
    for i = 0, (skillResult.roleList).Count - 1 do
      local role = (skillResult.roleList)[i]
      LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
      if role:GetBuffTier((self.config).buffId_judge) > 0 or role:GetBuffTier((self.config).buffId_rootjudge) > 0 then
        LuaSkillCtrl:DispelBuff(role, (self.config).buffId_judge, 1)
        LuaSkillCtrl:DispelBuff(role, (self.config).buffId_rootjudge, 1)
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_Jianfang, 1, (self.arglist)[3])
      end
    end
  end
  do
    skillResult:EndResult()
  end
end

bs_206803.OnBreakSkill = function(self, role)
  -- function num : 0_6 , upvalues : base
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.isInSkill then
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
end

return bs_206803

