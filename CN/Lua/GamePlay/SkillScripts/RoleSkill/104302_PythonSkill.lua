-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104302 = class("bs_104302", LuaSkillBase)
local base = LuaSkillBase
bs_104302.config = {buff_RangeDown = 104305, start_time = 15, actionId = 1002, action_speed = 1, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0}
, 
heal_config = {baseheal_formula = 501}
, effectId_SkillStart = 104311, effectId_SkillHit = 104309, effectId_Heal = 104308, audioIdStart = 104307, radius = 300, arcAngleRange = 60}
bs_104302.ctor = function(self)
  -- function num : 0_0
end

bs_104302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.TargetCount = 0
end

bs_104302.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local targetRole = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    targetRole = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    targetRole = tempTarget.targetRole
  end
  do
    if targetRole ~= nil then
      local selectTarget = LuaSkillCtrl:GetTargetWithGrid(targetRole.x, targetRole.y)
      local targetPos = (targetRole.lsObject).localPosition
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, selectTarget, targetPos)
      ;
      (self.caster):LookAtTarget(targetRole)
      self:CallCasterWait((self.config).start_time + 15)
      LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, (self.config).start_time + 15, true)
      LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioIdStart)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
    end
  end
end

bs_104302.OnAttackTrigger = function(self, selectTarget, selectTargetPos)
  -- function num : 0_3 , upvalues : _ENV
  local forwardDir = (((CS.TrueSync).TSVector3).Subtract)(selectTargetPos, ((self.caster).lsObject).localPosition)
  local ColliderEnter = BindCallback(self, self.OnColliderEnter, forwardDir, selectTargetPos)
  LuaSkillCtrl:CallEffect(selectTarget, (self.config).effectId_SkillStart, self)
  LuaSkillCtrl:CallEffect(selectTarget, (self.config).effectId_SkillHit, self)
  local fireCollider = LuaSkillCtrl:CallGetCircleSkillCollider(self, (self.config).radius, eColliderInfluenceType.Enemy, ColliderEnter)
  fireCollider.lsObject = (CS.LSUnityObject)()
  fireCollider:SetColiderObjPosForce(selectTargetPos)
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_3_0 , upvalues : _ENV, fireCollider, self
    LuaSkillCtrl:ClearColliderOrEmission(fireCollider)
    self.TargetCount = (math.min)(self.TargetCount * (self.arglist)[2], (self.arglist)[5])
    local HealNum = self.TargetCount * (self.caster).maxHp // 1000
    if HealNum > 0 then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Heal, self)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
      LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {HealNum}, true)
      skillResult:EndResult()
      self.TargetCount = 0
    end
    do
      self:OnSkillDamageEnd()
    end
  end
)
end

bs_104302.OnColliderEnter = function(self, forwardDir, selectTargetPos, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  local angle = 0
  if not ((entity.lsObject).localPosition):Equals(selectTargetPos) then
    local tsVec2 = (CS.TrueSync).TSVector2
    local curDir = (((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, selectTargetPos)
    local curDir2d = (tsVec2(curDir.x, curDir.z)).normalized
    local forwardDir2D = tsVec2(forwardDir.x, forwardDir.z)
    angle = LuaSkillCtrl:CallTSVec2Angle(curDir2d, forwardDir2D)
  end
  do
    if angle > 180 then
      angle = 360 - angle
    end
    if (self.config).arcAngleRange < angle then
      return 
    end
    if self.caster == nil or (self.caster).hp <= 0 then
      return 
    end
    do
      if entity.intensity > 0 and (self.arglist)[3] < entity.attackRange and entity.belongNum == eBattleRoleBelong.enemy and (entity.recordTable).Demiurge ~= true then
        local rangeDownNum = entity.attackRange - (self.arglist)[3]
        LuaSkillCtrl:CallBuff(self, entity, (self.config).buff_RangeDown, rangeDownNum, (self.arglist)[1])
      end
      local rangeDownNum = entity:GetBuffTier((self.config).buff_RangeDown)
      if rangeDownNum > 0 then
        LuaSkillCtrl:CallBuff(self, entity, (self.config).buff_RangeDown, rangeDownNum, (self.arglist)[1])
      end
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[4]})
      skillResult:EndResult()
      if entity.intensity > 0 and entity.belongNum == eBattleRoleBelong.enemy then
        self.TargetCount = self.TargetCount + 1
      end
    end
  end
end

bs_104302.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104302

