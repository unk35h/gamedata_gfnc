-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206602 = class("bs_206602", LuaSkillBase)
local base = LuaSkillBase
bs_206602.config = {buffId_judge = 206801, buffId_151 = 3007, buffId_unselected = 206806, effectId_start = 2066011, effectId_hit = 2066002, effectId_flash = 501102, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0}
}
bs_206602.ctor = function(self)
  -- function num : 0_0
end

bs_206602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206602.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self.isInSkill = true
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
    if targetRole ~= nil then
      (self.caster):LookAtTarget(targetRole)
      local TargetGrid = LuaSkillCtrl:CallFindFurthestGridInDirRangeWithoutObstacle((self.caster).x, (self.caster).y, targetRole.x, targetRole.y, 3)
      local TargetRole = LuaSkillCtrl:GetRoleWithPos(TargetGrid.x, TargetGrid.y)
      if TargetRole ~= nil then
        local maxRange = 10
        local emptyGrid = nil
        for tempRange = 1, maxRange do
          emptyGrid = LuaSkillCtrl:FindEmptyGridWithinRange(TargetRole, tempRange)
          if emptyGrid ~= nil then
            LuaSkillCtrl:SetRolePos(emptyGrid, TargetRole)
            LuaSkillCtrl:CallEffect(TargetRole, (self.config).effectId_flash, self)
            break
          end
        end
      end
      do
        local distance = LuaSkillCtrl:GetGridsDistance((self.caster).x, (self.caster).y, TargetGrid.x, TargetGrid.y)
        local MoveDuration = distance * 3
        self:CallCasterWait(MoveDuration + 15)
        LuaSkillCtrl:StartShowSkillDurationTime(self, MoveDuration + 15)
        LuaSkillCtrl:CallRoleAction(self.caster, 1002, 1)
        LuaSkillCtrl:PlayAuSource(self.caster, 446)
        LuaSkillCtrl:StartTimer(self, 10, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, TargetGrid, MoveDuration, targetRole
    LuaSkillCtrl:CallPhaseMove(self, self.caster, TargetGrid.x, TargetGrid.y, MoveDuration, (self.config).buffId_unselected)
    local effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
    LuaSkillCtrl:StartTimer(self, MoveDuration + 5, function()
      -- function num : 0_2_0_0 , upvalues : _ENV, self, effect
      LuaSkillCtrl:CallRoleAction(self.caster, 100, 1)
      effect:Die()
      self.isInSkill = false
      self:CancleCasterWait()
      self:CallNextBossSkill()
    end
)
    self:OnAttackTrigger(targetRole, TargetGrid)
  end
)
      end
    end
  end
end

bs_206602.OnAttackTrigger = function(self, selectTarget, TargetGrid)
  -- function num : 0_3 , upvalues : _ENV
  local MoveTargetGrid = LuaSkillCtrl:GetTargetWithGrid(TargetGrid.x, TargetGrid.y)
  local collisionTrigger = BindCallback(self, self.OnColliderEnter)
  local radius = 100
  local speed = 3
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, MoveTargetGrid, radius, speed, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, false, true, nil)
end

bs_206602.OnColliderEnter = function(self, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 or entity == nil or entity.hp <= 0 then
    return 
  end
  if LuaSkillCtrl:IsFixedObstacle(entity) then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:CallEffect((skillResult.roleList)[0], (self.config).effectId_hit, self)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
  skillResult:EndResult()
  if LuaSkillCtrl:IsObstacle(entity) then
    return 
  end
  LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_judge, 1, (self.arglist)[2])
end

bs_206602.OnBreakSkill = function(self, role)
  -- function num : 0_5 , upvalues : base
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.isInSkill then
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
end

return bs_206602

