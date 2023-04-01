-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104503 = class("bs_104503", LuaSkillBase)
local base = LuaSkillBase
bs_104503.config = {effectId_start = 1045031, effectId_hurt = 1045032, effectId_speed = 1, actionId_start = 1005, actionId_end = 1006, end_time = 15, audioIdStart = 104507, audioIdMovie = 104508, buffId_loopAction = 1045032, buffId_skillTarget = 1045021, buffId_ChargeTier = 1045001, charge_duration = 3, hit_duration = 8, select_id = 7, select_range = 10, 
hurt_config = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
}
bs_104503.ctor = function(self)
  -- function num : 0_0
end

bs_104503.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_104503_1", 998, self.OnSetHurt, self.caster)
  self.ultChargeTimes = 0
  self.count = 0
end

bs_104503.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(20 + (self.arglist)[1] + (self.config).end_time)
  local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
  ;
  (self.caster):LookAtTarget(inputTarget)
  self:GetSelectTargetAndExecute(selectRoles)
end

bs_104503.GetSelectTargetAndExecute = function(self, selectRole)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_loopAction, 1, nil, true)
  self.ultChargeTimes = 0
  local skillTime = (self.arglist)[1]
  self.MaxChargeTimes = skillTime // (self.config).charge_duration
  local chargeEnergy = BindCallback(self, self.ChargeEnergy, selectRole)
  LuaSkillCtrl:StartTimer(self, (self.config).charge_duration, chargeEnergy, nil, self.MaxChargeTimes, (self.config).charge_duration)
end

bs_104503.ChargeEnergy = function(self, selectRole)
  -- function num : 0_4 , upvalues : _ENV
  local isInUlt = (self.caster):GetBuffTier((self.config).buffId_loopAction)
  if isInUlt < 1 then
    return 
  end
  local Tier = ((self.caster).recordTable).currentTier
  if not Tier then
    Tier = 0
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable).currentTier = Tier
  if self.ultChargeTimes < self.MaxChargeTimes then
    local addTier = (self.arglist)[2] // self.MaxChargeTimes
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.caster).recordTable).currentTier = ((self.caster).recordTable).currentTier + addTier
    self.ultChargeTimes = self.ultChargeTimes + 1
    local currentBuffTier = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
    local buffaddTier = ((self.caster).recordTable).currentTier // 10 - currentBuffTier
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_ChargeTier, buffaddTier)
    local currentTier = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
  end
  do
    if self.ultChargeTimes == self.MaxChargeTimes then
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
      if selectRole ~= nil and (table.count)(selectRole) > 0 then
        local selectTarget = selectRole[0]
        local energyRelease = BindCallback(self, self.EnergyRelease, selectTarget)
        LuaSkillCtrl:StartTimer(nil, 8, energyRelease)
      end
    end
  end
end

bs_104503.EnergyRelease = function(self, selectRole)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_loopAction, 0, true)
  if ((self.caster).recordTable).currentTier <= 0 then
    return 
  end
  local TargetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
  local skillRatio = ((self.caster).recordTable).currentTier
  if TargetList == nil or TargetList.Count < 1 then
    return 
  end
  local target = nil
  for i = 0, TargetList.Count - 1 do
    if ((TargetList[i]).targetRole).hp > 0 then
      local target = TargetList[i]
      local skillTarget = self:FindSkillTarget()
      if skillTarget ~= nil and skillTarget.hp > 0 and skillTarget.belongNum ~= (self.caster).belongNum then
        target = skillTarget
      end
      if selectRole ~= nil and selectRole.hp > 0 then
        target = selectRole
      end
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {skillRatio}, false)
      skillResult:EndResult()
      return 
    end
  end
end

bs_104503.FindSkillTarget = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local enermylist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 10, false)
  if enermylist.Count > 0 then
    for i = 0, enermylist.Count - 1 do
      if (enermylist[i]).belongNum ~= (self.caster).belongNum then
        local skillTarget = (enermylist[i]):GetBuffTier((self.config).buffId_skillTarget)
        local cantSelect = LuaSkillCtrl:RoleContainsBuffFeature(enermylist[i], (self.config).buffFeature_cantSelect)
        local banished = LuaSkillCtrl:RoleContainsBuffFeature(enermylist[i], (self.config).buffFeature_banished)
        local EnermyCantSelect = LuaSkillCtrl:RoleContainsBuffFeature(enermylist[i], (self.config).buffFeature_EnermyCantSelect)
        if skillTarget > 0 and not banished and not cantSelect and not EnermyCantSelect then
          return enermylist[i]
        end
      end
    end
  end
end

bs_104503.OnSetHurt = function(self, context)
  -- function num : 0_7 , upvalues : _ENV, base
  if context.sender ~= self.caster or not (context.skill).isUltSkill then
    return 
  end
  if (context.target).hp <= 0 then
    return 
  end
  local currentTier = ((self.caster).recordTable).currentTier
  local removeTier = 0
  local hurt = context.hurt
  local target = context.target
  local targetSheild = LuaSkillCtrl:GetRoleAllShield(context.target)
  local targetHp = (context.target).hp + targetSheild
  if targetHp < hurt then
    removeTier = targetHp * currentTier // hurt
    context.hurt = targetHp
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.caster).recordTable).currentTier = ((self.caster).recordTable).currentTier - removeTier
    local currentBuffTier = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_ChargeTier, removeTier // 10, true)
    local currentTier = (self.caster):GetBuffTier((self.config).buffId_ChargeTier)
    self.count = self.count + 1
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hurt, self)
    local energyRelease = BindCallback(self, self.EnergyRelease)
    LuaSkillCtrl:StartTimer(nil, (self.config).hit_duration, energyRelease, nil)
  end
  do
    if hurt <= targetHp then
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_hurt, self)
      LuaSkillCtrl:DispelBuff(self.caster, 196, 1, true)
      -- DECOMPILER ERROR at PC97: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.caster).recordTable).currentTier = 0
      self.ultChargeTimes = 0
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_ChargeTier, 0, true)
      if (self.caster).hp <= 0 then
        (base.OnCasterDie)(self)
      end
    end
  end
end

bs_104503.OnBreakSkill = function(self, role)
  -- function num : 0_8 , upvalues : base
  local isInUltCharge = (self.caster):GetBuffTier((self.config).buffId_loopAction)
  if role == self.caster and isInUltCharge > 0 then
    self:CancleCasterWait()
    self:EnergyRelease()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_104503.OnUltRoleAction = function(self)
  -- function num : 0_9 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_104503.PlayUltEffect = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 60, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104503.OnSkipUltView = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104503.OnMovieFadeOut = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104503.OnCasterDie = function(self)
  -- function num : 0_13 , upvalues : base
  local isInUltCharge = (self.caster):GetBuffTier((self.config).buffId_loopAction)
  if isInUltCharge > 0 then
    self:EnergyRelease()
    return 
  end
  if isInUltCharge <= 0 then
    (base.OnCasterDie)(self)
  end
end

bs_104503.LuaDispose = function(self)
  -- function num : 0_14 , upvalues : base
  (base.LuaDispose)(self)
  self.ultChargeTimes = nil
  self.count = nil
end

return bs_104503

