-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104500 = class("bs_104500", base)
bs_104500.config = {actionId_start1 = 1031, actionId_start2 = 1034, actionId_attack1Start = 8, actionId_attack2Start = 9, actionId_loop1 = 1032, actionId_loop1 = 1035, actionId_end1 = 1033, actionId_end2 = 1036, End_speed1 = 2.5, End_speed2 = 4, action_end = 8, effectId_target = 1045001, effectId_hurt = 1045002, effectId_lineStart = 1045003, effectId_lineEnd = 1045004, line_end_delay = 2, effectId_sj = 1045005, effectId_attack1 = 1045006, effectId_attack2 = 1045007, buffId_ChargeTier = 1045001, buffId_loopAction = 1045002, buffId_skillTarget = 1045021, buffId_speedDown = 1045003, buffId_CantSelect = 3017, buffId_taunt = 3002, buffId_taunt2 = 67, buffId_FindTarget = 1045022, buffFeature_cantSelect = 5, buffFeature_banished = 16, buffFeature_EnermyCantSelect = 22, buffFeature_Fire = 23, charge_tier = 300, charge_times_limit = 30, charge_spead = 5, turn_delay = 10, addSpeedDownBuff = 3, SpeedDownBuffTime = 45, 
hurt_config = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0, extra_arg = 99, extraArg = 99}
, 
dead_hurt_config = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
}
bs_104500.config = setmetatable(bs_104500.config, {__index = base.config})
bs_104500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_104500_1", 5, self.OnSetHurt, self.caster)
  self.ChargeTimes = 0
  self.attackTarget = nil
  self:AddHurtResultStartTrigger("bs_104500_2", 30, self.OnHurtResultStart, self.caster, nil, eBattleRoleBelong.player)
  self.criticalPoint = 0
  self.ExtraCriticalHurtPoint = 0
  self.isBreakskill = nil
  self:AddHurtResultEndTrigger("bs_104500_3", 30, self.OnHurtResultEnd, self.caster, nil, eBattleRoleBelong.player)
  self.nomalAttackAction = 1
  self.targetPosition = {x = nil, y = nil}
  self.speedBuff = 0
  self:AddAfterAddBuffTrigger("bs_104500_4", 1, self.OnAfterAddBuff, nil, self.caster)
  self:AddBuffDieTrigger("bs_104500_5", 10, self.OnBuffDie, nil, nil)
end

bs_104500.SetAttackRole = function(self, data)
  -- function num : 0_1 , upvalues : _ENV
  self.displaySelectEfc = false
  local target = self:GetMoveSelectTarget()
  if target == nil then
    return 
  end
  local moveTarget = target.targetRole
  if not (self.caster):ContainFeature(eBuffFeatureType.Taunt) and not (self.caster):ContainFeature(eBuffFeatureType.Bewitch) then
    local enermylist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, (self.caster).attackRange, false)
    if enermylist.Count > 0 then
      for i = 0, enermylist.Count - 1 do
        if (enermylist[i]).belongNum ~= (self.caster).belongNum and LuaSkillCtrl:IsAbleAttackTarget(self.caster, enermylist[i], (self.caster).attackRange, true) then
          local skillTarget = (enermylist[i]):GetBuffTier((self.config).buffId_skillTarget)
          if skillTarget > 0 then
            moveTarget = enermylist[i]
          end
        end
      end
    end
  end
  do
    if self.fireTarget ~= nil then
      if (self.fireTarget).hp <= 0 then
        self.fireTarget = nil
      else
        moveTarget = self.fireTarget
      end
    end
    if self.tauntTarget ~= nil then
      if (self.tauntTarget).hp <= 0 then
        self.tauntTarget = nil
      else
        moveTarget = self.tauntTarget
      end
    end
    if moveTarget ~= nil then
      local curAtkRole = moveTarget
      if curAtkRole ~= nil then
        if self.lastAttackRole ~= curAtkRole then
          self.displaySelectEfc = true
        end
        self.lastAttackRole = curAtkRole
        -- DECOMPILER ERROR at PC94: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.caster).recordTable).lastAttackRole = self.lastAttackRole
      end
    end
  end
end

bs_104500.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV
  local isInAttack = (self.caster):GetBuffTier((self.config).buffId_loopAction)
  if isInAttack > 0 then
    return 
  end
  self.attackTarget = target
  if target == nil or target.hp <= 0 then
    return 
  end
  self:CallSelectEffect()
  ;
  (self.caster):LookAtTarget(target)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.targetPosition).x = target.x
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.targetPosition).y = target.y
  self:CallCasterWait(9999)
  local attack = BindCallback(self, self.OnAttackTrigger, target)
  self.nomalAttackAction = LuaSkillCtrl:CallRange(1, 2)
  local action = self:AttackAction()
  local actiontime = self:ActionTime()
  local effect = self:AttackEffect()
  LuaSkillCtrl:CallEffect(self.caster, effect, self, nil, nil, 1.4)
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, action, 1.4, actiontime, attack)
end

bs_104500.AttackAction = function(self)
  -- function num : 0_3
  if self.nomalAttackAction == 1 then
    return (self.config).actionId_start1
  end
  if self.nomalAttackAction == 2 then
    return (self.config).actionId_start2
  end
end

bs_104500.ActionTime = function(self)
  -- function num : 0_4
  if self.nomalAttackAction == 1 then
    return (self.config).actionId_attack1Start
  end
  if self.nomalAttackAction == 2 then
    return (self.config).actionId_attack2Start
  end
end

bs_104500.AttackEffect = function(self)
  -- function num : 0_5
  if self.nomalAttackAction == 1 then
    return (self.config).effectId_attack1
  end
  if self.nomalAttackAction == 2 then
    return (self.config).effectId_attack2
  end
end

bs_104500.CallSelectEffect = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if ((self.caster).recordTable).completeFirstComatk and self.displaySelectEfc and self.lastAttackRole ~= nil then
    LuaSkillCtrl:CallSelectTargetEffect(self, self.lastAttackRole)
    self.displaySelectEfc = false
  end
end

bs_104500.OnAttackTrigger = function(self, target)
  -- function num : 0_7 , upvalues : _ENV
  if self.fireTarget ~= nil then
    target = self.fireTarget
    ;
    (self.caster):LookAtTarget(target)
  end
  if target.hp <= 0 then
    self:AttackEnd()
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_loopAction, 1, nil, true)
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  self.targetEffect = LuaSkillCtrl:CallEffect(target, (self.config).effectId_target, self)
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  self.lineStart = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_lineStart, self)
  LuaSkillCtrl:StartTimer(self, (self.config).line_end_delay, function()
    -- function num : 0_7_0 , upvalues : self, _ENV, target
    if self.lineEnd ~= nil then
      (self.lineEnd):Die()
      self.lineEnd = nil
    end
    self.lineEnd = LuaSkillCtrl:CallEffect(target, (self.config).effectId_lineEnd, self)
  end
)
  local checkhurt = BindCallback(self, self.Hurt, target)
  self.chargeEnergyTimer = LuaSkillCtrl:StartTimer(self, (self.config).charge_spead, checkhurt, nil, (self.config).charge_times_limit, 5)
end

bs_104500.Hurt = function(self, target)
  -- function num : 0_8 , upvalues : _ENV
  local isInAttack = (self.caster):GetBuffTier((self.config).buffId_loopAction)
  if isInAttack < 1 then
    return 
  end
  if target.hp <= 0 then
    self:AttackEnd()
    return 
  end
  if self.fireTarget ~= nil and self.tauntTarget == nil and self.Bewitch == nil and self.fireTarget ~= target then
    self:AttackEnd()
    return 
  end
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

  if ((self.caster).recordTable).skillTarget ~= nil and (((self.caster).recordTable).skillTarget).hp <= 0 then
    ((self.caster).recordTable).skillTarget = nil
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_FindTarget, 0, true)
  end
  if ((self.caster).recordTable).skillTarget ~= nil then
    local banished = LuaSkillCtrl:RoleContainsBuffFeature(((self.caster).recordTable).skillTarget, (self.config).buffFeature_banished)
    local EnermyCantSelect = LuaSkillCtrl:RoleContainsBuffFeature(((self.caster).recordTable).skillTarget, (self.config).buffFeature_EnermyCantSelect)
    if ((self.caster).recordTable).skillTarget ~= target and LuaSkillCtrl:IsWorthAttacking(self, ((self.caster).recordTable).skillTarget) and LuaSkillCtrl:IsAbleAttackTarget(self.caster, ((self.caster).recordTable).skillTarget, (self.caster).attackRange, true) and not banished and not EnermyCantSelect and self.fireTarget == nil and self.tauntTarget == nil and self.Bewitch == nil then
      self:AttackEnd()
    end
  end
  do
    if target.intensity == 0 and target.belongNum == eBattleRoleBelong.neutral then
      local enermylist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, (self.caster).attackRange, false)
      if enermylist.Count > 0 then
        for i = 0, enermylist.Count - 1 do
          if (enermylist[i]).belongNum ~= (self.caster).belongNum and target.intensity ~= 0 and target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, enermylist[i], (self.caster).attackRange, true) then
            self:AttackEnd()
          end
        end
      end
    end
    do
      local banished = LuaSkillCtrl:RoleContainsBuffFeature(target, (self.config).buffFeature_banished)
      local EnermyCantSelect = LuaSkillCtrl:RoleContainsBuffFeature(target, (self.config).buffFeature_EnermyCantSelect)
      if banished or EnermyCantSelect then
        self:AttackEnd()
        return 
      end
      self:TurnToTarget(target)
      local hurtTier = ((self.caster).recordTable).currentTier
      local skillRatio = hurtTier
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      if (self.caster).hp > 0 then
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {skillRatio}, false)
        skillResult:EndResult()
      else
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).dead_hurt_config, {skillRatio}, false)
        skillResult:EndResult()
      end
      self:AddSpeedDownBuff(target)
    end
  end
end

bs_104500.AddSpeedDownBuff = function(self, target)
  -- function num : 0_9 , upvalues : _ENV
  if self.speedBuff == nil then
    self.speedBuff = 0
  end
  if self.speedBuff <= 0 and target ~= nil and target.hp > 0 and target.intensity ~= 0 and target.belongNum ~= eBattleRoleBelong.neutral then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_speedDown, 1, (self.config).SpeedDownBuffTime)
    self.speedBuff = (self.config).addSpeedDownBuff + 1
  end
  self.speedBuff = self.speedBuff - 1
end

bs_104500.TurnToTarget = function(self, target)
  -- function num : 0_10 , upvalues : _ENV
  if self.turnNotYet ~= nil then
    return 
  end
  if (self.targetPosition).x ~= target.x or (self.targetPosition).y ~= target.y then
    self.turnNotYet = 1
    LuaSkillCtrl:StartTimer(nil, (self.config).turn_delay, function()
    -- function num : 0_10_0 , upvalues : self, target
    (self.caster):LookAtTarget(target)
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.targetPosition).x = target.x
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.targetPosition).y = target.y
    self.turnNotYet = nil
  end
)
    return 
  end
end

bs_104500.OnSetHurt = function(self, context)
  -- function num : 0_11 , upvalues : _ENV
  if context.sender ~= self.caster or not (context.skill).isCommonAttack then
    return 
  end
  if (context.target).hp <= 0 then
    context.extra_arg = 0
    context.extraArg = context.extra_arg
    self:AttackEnd()
    return 
  end
  local currentTier = ((self.caster).recordTable).currentTier
  local removeTier = 0
  local hurt = context.hurt
  if (self.caster).hp <= 0 then
    self:SetHurtEnd(context.target)
    return 
  end
  local targetSheild = LuaSkillCtrl:GetRoleAllShield(context.target)
  local targetHp = (context.target).hp + targetSheild
  do
    if targetHp <= hurt then
      local removeTier = targetHp * currentTier // hurt
      if removeTier <= 0 then
        removeTier = 0
      end
      context.extra_arg = 0
      context.extraArg = context.extra_arg
      context.hurt = targetHp
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_loopAction, 0, true)
      self:SetHurtEnd(context.target, removeTier)
      return 
    end
    if hurt < targetHp then
      if self.ChargeTimes < (self.config).charge_times_limit then
        context.extra_arg = (ConfigData.buildinConfig).HurtIgnoreKey
        context.extraArg = context.extra_arg
        context.hurt_type = 2
        context.isCrit = false
        if not ((self.caster).recordTable).DeriveHurt then
          local deriveArg = (self.arglist)[2]
        end
        local skillRatio = (self.caster).skill_intensity * deriveArg * (1000 + (self.caster).damage_increase - (context.target).injury_reduce) // 1000 // 1000
        local hurt = LuaSkillCtrl:CallFormulaNumber(9994, self.caster, self.caster, skillRatio)
        if hurt < 1 then
          hurt = 1
        end
        context.hurt = hurt
        self:ChargeEnergy(context.target)
        return 
      end
      do
        if (self.config).charge_times_limit <= self.ChargeTimes then
          context.extra_arg = 0
          context.extraArg = context.extra_arg
          local removeTier = ((self.caster).recordTable).currentTier
          LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_loopAction, 0, true)
          self:SetHurtEnd(context.target, removeTier)
          return 
        end
        do
          do return  end
        end
      end
    end
  end
end

bs_104500.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_12 , upvalues : _ENV
  if skill.sender ~= self.caster and not skill.isCommonAttack then
    return 
  end
  if self.isNotReturnCrit ~= nil then
    return 
  end
  self.isNotReturnCrit = 1
  self.ret_crit = 0
  self.crit_num = (self.caster).crit
  self.critdamage_num = (self.caster).critDamage
  local changeCrit = 0 - self.crit_num
  local changeCritDamage = 0 - ((self.caster).critDamage - 500)
  if not ((self.caster).recordTable).CriticalRate then
    local arg1 = (self.arglist)[3]
  end
  self.criticalPoint = (self.caster).crit * arg1 // 100
  if not ((self.caster).recordTable).CriticaldamageRate then
    local arg2 = (self.arglist)[4]
  end
  self.ExtraCriticalHurtPoint = ((self.caster).critDamage - 500) * arg2 // 100
  ;
  (self.caster):AddRoleProperty(eHeroAttr.crit, changeCrit, eHeroAttrType.Extra)
  ;
  (self.caster):AddRoleProperty(eHeroAttr.critDamage, changeCritDamage, eHeroAttrType.Extra)
end

bs_104500.ChargeEnergy = function(self, target)
  -- function num : 0_13 , upvalues : _ENV
  local criticalRatio = self.criticalPoint
  if criticalRatio < 0 then
    criticalRatio = 0
  end
  local critDamageRatio = self.ExtraCriticalHurtPoint
  if critDamageRatio < 0 then
    critDamageRatio = 0
  end
  local baseTier = ((self.caster).recordTable).currentTier
  if not ((self.caster).recordTable).EnergyTire then
    local energyTierArg = (self.arglist)[1]
  end
  local addTier = energyTierArg * (100 + critDamageRatio + criticalRatio) // 100
  local isSkillTarget = target:GetBuffTier((self.config).buffId_skillTarget)
  if isSkillTarget >= 1 then
    addTier = addTier * (1000 + ((self.caster).recordTable).skillTargetRatio) // 1000
  end
  local curTier = ((self.caster).recordTable).currentTier or 0
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.caster).recordTable).currentTier = curTier + addTier
  local currentBuffTier = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
  local addbufftier = ((self.caster).recordTable).currentTier // 10 - currentBuffTier
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_ChargeTier, addbufftier)
  local currentTier = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
  self.ChargeTimes = self.ChargeTimes + 1
end

bs_104500.SetHurtEnd = function(self, target, removeTier)
  -- function num : 0_14 , upvalues : _ENV
  local tier = ((self.caster).recordTable).currentTier
  if removeTier ~= nil then
    tier = removeTier
  end
  if target.hp > 0 then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hurt, self)
    if target:GetBuffTier((self.config).buffId_skillTarget) < 1 then
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_sj, self)
    end
  end
  local bufftier = target:GetBuffTier((self.config).buffId_ChargeTier)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_ChargeTier, tier // 10, true)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.caster).recordTable).currentTier = ((self.caster).recordTable).currentTier - tier
  local currentTier = ((self.caster).recordTable).currentTier
  self.ChargeTimes = 0
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
  if self.chargeEnergyTimer ~= nil then
    (self.chargeEnergyTimer):Stop()
    self.chargeEnergyTimer = nil
  end
  self:AttackEnd()
end

bs_104500.EndAction = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local action = (self.config).actionId_end1
  local endspeed = (self.config).End_speed1
  if self.nomalAttackAction == 1 then
    action = (self.config).actionId_end1
    endspeed = (self.config).End_speed1
  end
  if self.nomalAttackAction == 2 then
    action = (self.config).actionId_end2
    endspeed = (self.config).End_speed2
  end
  LuaSkillCtrl:CallRoleAction(self.caster, action, endspeed)
end

bs_104500.AttackEnd = function(self)
  -- function num : 0_16 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_loopAction, 0, true)
  if self.chargeEnergyTimer ~= nil then
    (self.chargeEnergyTimer):Stop()
    self.chargeEnergyTimer = nil
  end
  self.attackTarget = nil
  self.speedBuff = nil
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R1 in 'UnsetPending'

  if ((self.caster).recordTable).completeFirstComatk == nil then
    ((self.caster).recordTable).completeFirstComatk = true
  end
  self:EndAction()
  if self.isBreakskill then
    self:CancleCasterWait()
  else
    LuaSkillCtrl:StartTimer(self, (self.config).action_end, function()
    -- function num : 0_16_0 , upvalues : self
    self:CancleCasterWait()
  end
)
  end
end

bs_104500.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_17 , upvalues : _ENV
  if skill.sender ~= self.caster and not skill.isCommonAttack then
    return 
  end
  if self.isNotReturnCrit ~= 1 then
    return 
  end
  self.isNotReturnCrit = nil
  ;
  (self.caster):AddRoleProperty(eHeroAttr.crit, self.crit_num, eHeroAttrType.Extra)
  ;
  (self.caster):AddRoleProperty(eHeroAttr.critDamage, self.critdamage_num - 500, eHeroAttrType.Extra)
end

bs_104500.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_18 , upvalues : _ENV
  if buff.maker == self.caster then
    return 
  end
  if target ~= self.caster then
    return 
  end
  if buff:ContainFeature(eBuffFeatureType.FocusOnFiring) then
    self.fireTarget = buff.maker
    self.fireTargetbuff = buff
  end
  if buff.dataId == (self.config).buffId_taunt or buff.dataId == (self.config).buffId_taunt2 then
    self.tauntTarget = buff.maker
    self.tauntTargetbuff = buff
  end
  if buff:ContainFeature(eBuffFeatureType.Bewitch) then
    self.Bewitch = true
    self.BewitchBuff = buff
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_FindTarget, 0, true)
    self:AttackEnd()
  end
end

bs_104500.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_19 , upvalues : _ENV
  if buff == self.fireTargetbuff then
    self.fireTarget = nil
    self.fireTargetbuff = nil
  end
  if buff == self.tauntTargetbuff then
    self.tauntTarget = nil
    self.tauntTargetbuff = nil
  end
  if buff == self.BewitchBuff then
    self.Bewitch = nil
    self.BewitchBuff = nil
    self.BewitchTarget = nil
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

    if ((self.caster).recordTable).skillTarget ~= nil and (((self.caster).recordTable).skillTarget).hp <= 0 then
      ((self.caster).recordTable).skillTarget = nil
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_FindTarget, 0, true)
    end
    if ((self.caster).recordTable).skillTarget ~= nil then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_FindTarget, 1, nil, true, ((self.caster).recordTable).skillTarget)
    end
    self:AttackEnd()
  end
end

bs_104500.OnBreakSkill = function(self, role)
  -- function num : 0_20 , upvalues : _ENV, base
  if role == self.caster then
    self.isBreakskill = true
    self:CancleCasterWait()
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_loopAction, 0, true)
    self:AttackEnd()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_104500.OnCasterDie = function(self)
  -- function num : 0_21 , upvalues : base
  if self.attackTarget ~= nil then
    self:Hurt(self.attackTarget)
  end
  ;
  (base.OnCasterDie)(self)
end

bs_104500.LuaDispose = function(self)
  -- function num : 0_22 , upvalues : base
  (base.LuaDispose)(self)
  self.ChargeTimes = nil
  self.attackTarget = nil
  self.nomalAttackAction = nil
  self.targetPosition = nil
  self.turnNotYet = nil
  self.fireTarget = nil
  self.fireTargetbuff = nil
  self.tauntTarget = nil
  self.tauntTargetbuff = nil
  self.speedBuff = nil
  self.Bewitch = nil
  self.BewitchTarget = nil
  self.BewitchBuff = nil
  self.isBreakskill = nil
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
end

return bs_104500

