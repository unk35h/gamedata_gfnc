-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104502 = class("bs_104502", LuaSkillBase)
local base = LuaSkillBase
bs_104502.config = {actionId_start = 1002, skill_time = 11, start_time = 4, effectId_start = 1045022, effectId_target = 1045021, effectId_boom = 1045023, buffId_skillTarget = 1045021, buffId_loopAction = 1045002, buffId_UltloopAction = 1045032, buffId_sniperGrid = 1032, buffId_FindTarget = 1045022, buffId_ChargeTier = 1045001, buffId_taunt = 3002, buffId_taunt2 = 67, 
HurtConfig_aoe = {basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
}
bs_104502.ctor = function(self)
  -- function num : 0_0
end

bs_104502.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).skillTargetRatio = (self.arglist)[1]
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).skillTarget = nil
  self:AddAfterHurtTrigger("bs_104502_2", 1, self.OnAfterHurt, self.caster)
  self:AddSelfTrigger(eSkillTriggerType.BeforePlaySkill, "bs_104502_3", 1, self.OnBeforePlaySkill)
  self:AddSetHurtTrigger("bs_104502_1", 999, self.OnSetHurt, self.caster)
end

bs_104502.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.skill ~= self.cskill or self.caster ~= role then
    return 
  end
  context.active = false
  local moveTarget = (self.cskill).moveSelectTarget
  if moveTarget ~= nil and (moveTarget.targetRole).intensity == 0 and (moveTarget.targetRole).belongNum == eBattleRoleBelong.neutral then
    moveTarget = nil
  end
  if moveTarget == nil then
    (self.cskill):ResetCDTimeRatio(80)
    return 
  end
  local target = moveTarget.targetRole
  if target == nil or target.hp <= 0 then
    return 
  end
  if moveTarget.belongNum == (self.caster).belongNum then
    (self.cskill):ResetCDTimeRatio(80)
    return 
  end
  local alreadyTarget = target:GetBuffTier((self.config).buffId_skillTarget)
  if alreadyTarget > 0 then
    (self.cskill):ResetCDTimeRatio(80)
    return 
  end
  context.active = true
end

bs_104502.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  local moveTarget = self:GetMoveSelectTarget()
  if moveTarget ~= nil and (moveTarget.targetRole).intensity == 0 and (moveTarget.targetRole).belongNum == eBattleRoleBelong.neutral then
    moveTarget = nil
  end
  local target = moveTarget.targetRole
  if target == nil or target.hp <= 0 then
    return 
  end
  local isOnSniperGrid = (self.caster):GetBuffTier((self.config).buffId_sniperGrid)
  if isOnSniperGrid > 0 then
    target = self:SniperGridTarget()
  end
  local setTarget = BindCallback(self, self.setTarget, target)
  ;
  (self.caster):LookAtTarget(target)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, 2.5, (self.config).start_time, setTarget)
end

bs_104502.SniperGridTarget = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelectWithCskill(self.cskill, 21, 10, self.caster)
  if targetlist.Count < 1 then
    return 
  end
  return (targetlist[0]).targetRole
end

bs_104502.setTarget = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_start, self, self.SkillEventFunc)
  local enermylist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 10, false)
  if enermylist.Count > 0 then
    for i = 0, enermylist.Count - 1 do
      if (enermylist[i]).belongNum ~= (self.caster).belongNum then
        local skillTarget = (enermylist[i]):GetBuffTier((self.config).buffId_skillTarget)
        if skillTarget > 0 then
          LuaSkillCtrl:DispelBuff(enermylist[i], (self.config).buffId_skillTarget, 0, true)
        end
      end
    end
  end
end

bs_104502.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ((self.caster).recordTable).skillTarget = target.targetRole
  if eventId == eBattleEffectEvent.Trigger then
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_skillTarget, 1, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_FindTarget, 1, nil, true, target.targetRole)
  end
end

bs_104502.OnSetHurt = function(self, context)
  -- function num : 0_7 , upvalues : _ENV
  local isSkillTarget = (context.target):GetBuffTier((self.config).buffId_skillTarget)
  if isSkillTarget < 1 then
    return 
  end
  if context.sender ~= self.caster then
    return 
  end
  if context.extra_arg == (ConfigData.buildinConfig).HurtIgnoreKey or context.isTriggerSet then
    return 
  end
  if not (context.skill).isCommonAttack and not (context.skill).isUltSkill then
    return 
  end
  local buffs = LuaSkillCtrl:GetRoleBuffs(context.target)
  if buffs ~= nil and buffs.Count > 0 then
    for i = 0, buffs.Count - 1 do
    end
  end
  do
    if (buffs[i]).buffType == 2 then
      self:DebuffSpread(context.target, buffs)
      self:TargetBomb(context.target, context.hurt)
      LuaSkillCtrl:DispelBuff(context.target, (self.config).buffId_skillTarget, 0, true)
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_FindTarget, 0, true)
      -- DECOMPILER ERROR at PC77: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.caster).recordTable).skillTarget = nil
    end
  end
end

bs_104502.DebuffSpread = function(self, target, buffs)
  -- function num : 0_8 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).Aoe)
  local addBuff = buffs
  if skillResult == nil or (skillResult.roleList).Count < 1 then
    return 
  end
  for i = 0, (skillResult.roleList).Count - 1 do
    if not (((skillResult.roleList)[i]).recordTable).equipSummoner then
      do
        self:AddDebuff((skillResult.roleList)[i], addBuff)
        -- DECOMPILER ERROR at PC32: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC32: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  skillResult:EndResult()
end

bs_104502.AddDebuff = function(self, target, buffs)
  -- function num : 0_9 , upvalues : _ENV
  if target == nil or target.hp <= 0 then
    return 
  end
  if buffs == nil or buffs.Count < 1 then
    return 
  end
  for i = 0, buffs.Count - 1 do
    if (buffs[i]).buffType == 2 then
      local skill = (buffs[i]).battleSkill
      local sender = (buffs[i]).maker
      local buffID = (buffs[i]).dataId
      local tier = (buffs[i]).tier
      local decade = (buffs[i]).totalTime
      if buffID == (self.config).buffId_taunt2 or buffID == (self.config).buffId_taunt then
        local setBuff = LuaSkillCtrl:CallBuff(self, target, buffID, tier, decade, false, sender)
      else
        do
          do
            local setBuff = LuaSkillCtrl:CallBuffWithOriginSkill(skill, target, buffID, tier, decade, false, self.caster)
            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

bs_104502.TargetBomb = function(self, target, hurt)
  -- function num : 0_10 , upvalues : _ENV, base
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_boom, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).Aoe)
  local baseHurt = hurt
  local realHurt = baseHurt * (self.arglist)[2] // 1000
  for i = 0, (skillResult.roleList).Count - 1 do
    if not (((skillResult.roleList)[i]).recordTable).equipSummoner then
      local role = (skillResult.roleList)[i]
      LuaSkillCtrl:CallRealDamage(self, role, nil, (self.config).HurtConfig_aoe, {realHurt}, true)
    end
  end
  skillResult:EndResult()
  self:OnSkillDamageEnd()
  if (self.caster).hp <= 0 then
    (base.OnCasterDie)(self)
  end
end

bs_104502.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  local enermylist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 10, false)
  if enermylist.Count > 0 then
    for i = 0, enermylist.Count - 1 do
      if (enermylist[i]).belongNum ~= (self.caster).belongNum then
        local skillTarget = (enermylist[i]):GetBuffTier((self.config).buffId_skillTarget)
        if skillTarget > 0 then
          local normalAttackCharge = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
          local ultCharge = (self.caster):GetBuffTier((self.config).buffId_UltloopAction)
          if normalAttackCharge + ultCharge <= 0 then
            LuaSkillCtrl:DispelBuff(enermylist[i], (self.config).buffId_skillTarget, 0, true)
            ;
            (base.OnCasterDie)(self)
          end
        end
      end
    end
  end
end

bs_104502.LuaDispose = function(self)
  -- function num : 0_12 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_104502

