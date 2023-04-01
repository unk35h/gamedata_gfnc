-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101605 = class("bs_101605", LuaSkillBase)
local base = LuaSkillBase
bs_101605.config = {buffId_Paint = 101601, buffId_170 = 170, superBuffId = 271, effectId = 101604, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, crithur_ratio = 0}
, HurtConfig1 = 2, audioId1 = 107, audioId2 = 108, audioId3 = 109, selectCode = 57}
bs_101605.ctor = function(self)
  -- function num : 0_0
end

bs_101605.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).arg2 = (self.arglist)[2]
end

bs_101605.PlaySkill = function(self, data)
  -- function num : 0_2
  local realTargetRole = self:CheckAndGetTargetRole()
  if realTargetRole == nil then
    return 
  end
  self:PhaseMove(realTargetRole)
end

bs_101605.realRlaySkill = function(self, realTargetRole)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, realTargetRole)
  ;
  (self.caster):LookAtTarget(realTargetRole)
  self:CallCasterWait(15)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, 1020, 1.5, 7, attackTrigger)
  LuaSkillCtrl:StartTimer(self, 10, function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    local TargetRole = self:CheckAndGetTargetRole()
    if TargetRole == nil then
      return 
    end
    ;
    (self.caster):LookAtTarget(TargetRole)
    LuaSkillCtrl:CallEffect(TargetRole, (self.config).effectId, self, self.SkillEventFunc1)
  end
, nil)
end

bs_101605.OnAttackTrigger = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
end

bs_101605.CheckAndGetTargetRole = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local lastAtkRole = ((self.caster).recordTable).lastAttackRole
  if lastAtkRole ~= nil and LuaSkillCtrl:IsAbleAttackTarget(self.caster, lastAtkRole, (self.cskill).SkillRange) and lastAtkRole:GetBuffTier((self.config).buffId_Paint) <= 0 and lastAtkRole.belongNum ~= eBattleRoleBelong.neutral then
    return lastAtkRole
  end
  local realTargetRole = nil
  local moveTarget = self:GetMoveSelectTarget()
  if moveTarget ~= nil then
    realTargetRole = moveTarget.targetRole
  end
  do
    if realTargetRole == nil or realTargetRole:GetBuffTier((self.config).buffId_Paint) > 0 or realTargetRole:ContainFeature(eBuffFeatureType.AbadonDebuff) then
      local roles = LuaSkillCtrl:CallTargetSelectWithRange(self, (self.config).selectCode, (self.cskill).SkillRange)
      if (roles == nil or roles.Count <= 0) and realTargetRole == nil then
        (self.cskill):ResetCDTimeRatio((ConfigData.game_config).skillBreakCd)
        return 
      end
      realTargetRole = self:AnalysisSelectRoles(realTargetRole, roles)
    end
    return realTargetRole
  end
end

bs_101605.AnalysisSelectRoles = function(self, realTargetRole, roles)
  -- function num : 0_6 , upvalues : _ENV
  local result = realTargetRole
  if roles == nil or roles.Count <= 0 then
    return result
  end
  for i = 0, roles.Count - 1 do
    local targetRole = (roles[i]).targetRole
    if targetRole.belongNum ~= eBattleRoleBelong.neutral and targetRole:GetBuffTier((self.config).buffId_Paint) <= 0 and not targetRole:ContainFeature(eBuffFeatureType.AbadonDebuff) then
      result = targetRole
      break
    end
  end
  do
    return result
  end
end

bs_101605.PhaseMove = function(self, realTargetRole)
  -- function num : 0_7 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, 1007)
  local grid = nil
  local grids = LuaSkillCtrl:FindEmptyGridsWithinRange(realTargetRole.x, realTargetRole.y, (self.caster).attackRange, true)
  if grids ~= nil and grids.Count > 0 then
    grid = grids[0]
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = realTargetRole
  end
  if grid == nil then
    grid = LuaSkillCtrl:FindEmptyGridWithinRange(self.caster, 2)
  end
  if grid ~= nil then
    LuaSkillCtrl:CallPhaseMove(self, self.caster, grid.x, grid.y, 6, 69)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId3)
  end
  LuaSkillCtrl:StartTimer(nil, 6, function()
    -- function num : 0_7_0 , upvalues : _ENV, self, realTargetRole
    LuaSkillCtrl:CallRoleAction(self.caster, 1009)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).superBuffId, 1, (self.arglist)[3])
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[3], true)
    LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[3])
    self:realRlaySkill(realTargetRole)
  end
)
end

bs_101605.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  if eventId == eBattleEffectEvent.Trigger and LuaSkillCtrl:IsAbleAttackTarget(self.caster, target.targetRole, 10) then
    ((self.caster).recordTable).skill_target = target.targetRole
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
    skillResult:EndResult()
  end
end

bs_101605.SkillEventFunc1 = function(self, effect, eventId, target)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  if eventId == eBattleEffectEvent.Trigger and LuaSkillCtrl:IsAbleAttackTarget(self.caster, target.targetRole, 10) then
    ((self.caster).recordTable).skill_target = target.targetRole
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
    local targetNum = 0
    local targetList = LuaSkillCtrl:FindAllRolesWithinRange(target, 1, true)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        if (targetList[i]).belongNum == 2 then
          targetNum = targetNum + 1
        end
      end
    end
    do
      if targetNum == 1 then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig1, {(self.arglist)[1] * (self.arglist)[5] // 1000})
        skillResult:EndResult()
      else
        do
          do
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
            LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1] * (self.arglist)[4] // 1000})
            skillResult:EndResult()
            self:OnSkillDamageEnd()
          end
        end
      end
    end
  end
end

bs_101605.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101605

