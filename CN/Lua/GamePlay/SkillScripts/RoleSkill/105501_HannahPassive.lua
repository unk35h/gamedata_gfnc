-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105501 = class("bs_105402", LuaSkillBase)
local base = LuaSkillBase
bs_105501.config = {fireSuppressNeedCount = 3, buffId_focus = 105501, buffId_attackSpeed = 105502, effectId = 105515, effectId_trail = 105514, configId = 3}
bs_105501.ctor = function(self)
  -- function num : 0_0
end

bs_105501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_105501_01", 1, self.OnAfterPlaySkill)
  self:AddOnRoleDieTrigger("bs_105501_02", 1, self.OnRoleDie)
  self.targetTable = {}
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).FireSuppressTarget = nil
  self.maxCount = 0
end

bs_105501.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack then
    local target = (role.recordTable).lastAttackRole
    if target ~= nil and target.belongNum ~= (self.caster).belongNum and (skill.maker).belongNum == (self.caster).belongNum then
      self:OnTargetChange(skill.maker, target)
      if ((self.caster).recordTable).FireSuppressTarget == target and skill.maker ~= self.caster then
        LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, self.caster, nil, nil, self.SkillEventFunc)
      end
    end
  end
end

bs_105501.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]}, nil, nil)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, nil, nil, nil, true)
  end
end

bs_105501.OnRoleDie = function(self, killer, role)
  -- function num : 0_4
  if role.belongNum == (self.caster).belongNum then
    self:OnTargetChange(role, nil)
  else
    if role == ((self.caster).recordTable).FireSuppressTarget then
      self:OnFireSuppressTarget()
    end
  end
end

bs_105501.OnTargetChange = function(self, role, targetRole)
  -- function num : 0_5 , upvalues : _ENV
  local lastTargetRole = (self.targetTable)[role]
  local lastTargetUid = nil
  if lastTargetRole ~= nil then
    lastTargetUid = lastTargetRole.uid
  end
  local nextTargetUid = nil
  if targetRole ~= nil then
    nextTargetUid = targetRole.uid
  end
  if lastTargetUid == nextTargetUid then
    return 
  end
  local fireRole = ((self.caster).recordTable).FireSuppressTarget
  if fireRole ~= nil and fireRole.isDead ~= true then
    local fireUid = fireRole.uid
    local isAdd = nil
    if fireUid == lastTargetUid then
      self.maxCount = self.maxCount - 1
      isAdd = false
    end
    if fireUid == nextTargetUid then
      self.maxCount = self.maxCount + 1
      isAdd = true
    end
    if (self.config).fireSuppressNeedCount <= self.maxCount then
      if isAdd == true then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_attackSpeed, 1)
      else
        if isAdd == false then
          LuaSkillCtrl:DispelBuff(role, (self.config).buffId_attackSpeed, 1)
        end
      end
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self.targetTable)[role] = targetRole
      return 
    else
      self:OnFireSuppressTarget()
    end
  end
  do
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.targetTable)[role] = targetRole
    if targetRole == nil then
      return 
    end
    local maxCount = 0
    for k,v in pairs(self.targetTable) do
      if v == targetRole then
        maxCount = maxCount + 1
      end
    end
    if (self.config).fireSuppressNeedCount <= maxCount then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId_focus, 1)
      for k,v in pairs(self.targetTable) do
        if v == targetRole then
          LuaSkillCtrl:CallBuff(self, k, (self.config).buffId_attackSpeed, 1)
        end
      end
      -- DECOMPILER ERROR at PC111: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.caster).recordTable).FireSuppressTarget = targetRole
      self.maxCount = maxCount
    end
  end
end

bs_105501.OnFireSuppressTarget = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local fireRole = ((self.caster).recordTable).FireSuppressTarget
  LuaSkillCtrl:DispelBuff(fireRole, (self.config).buffId_focus, 1)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).FireSuppressTarget = nil
  self.maxCount = 0
  for k,v in pairs(self.targetTable) do
    if v == fireRole then
      LuaSkillCtrl:DispelBuff(k, (self.config).buffId_attackSpeed, 1)
    end
  end
end

bs_105501.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  self:OnFireSuppressTarget()
  ;
  (base.OnCasterDie)(self)
end

bs_105501.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  (base.LuaDispose)(self)
  self.targetTable = nil
end

return bs_105501

