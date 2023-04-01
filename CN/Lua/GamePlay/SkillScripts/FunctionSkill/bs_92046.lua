-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92046 = class("bs_92046", LuaSkillBase)
local base = LuaSkillBase
bs_92046.config = {fireSuppressNeedCount = 1, buffId_enemy = 2055, configId = 3, effectId = 10974}
bs_92046.ctor = function(self)
  -- function num : 0_0
end

bs_92046.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterPlaySkillTrigger("bs_92046_01", 1, self.OnAfterPlaySkill, nil, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddOnRoleDieTrigger("bs_92046_02", 1, self.OnRoleDie)
  self:AddAfterAddBuffTrigger("bs_92046_03", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId_enemy)
  self.targetTable = {}
  self.maxCount = 0
  self.targetRole = nil
  self.countBuffEffect = {}
end

bs_92046.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if skill.isCommonAttack then
    local target = (role.recordTable).lastAttackRole
    if target ~= nil and target.belongNum ~= (self.caster).belongNum and (skill.maker).belongNum == (self.caster).belongNum then
      self:OnTargetChange(skill.maker, target)
    end
  end
end

bs_92046.OnRoleDie = function(self, killer, role)
  -- function num : 0_3
  if role.belongNum == (self.caster).belongNum then
    self:OnTargetChange(role, nil)
  end
  if role.belongNum ~= (self.caster).belongNum then
    local newBuffTier = role:GetBuffTier((self.config).buffId_enemy)
    if (self.countBuffEffect)[role.uid] ~= nil then
      ((self.countBuffEffect)[role.uid]):Die()
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self.countBuffEffect)[role.uid] = nil
    end
  end
end

bs_92046.OnTargetChange = function(self, role, targetRole)
  -- function num : 0_4 , upvalues : _ENV
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
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R6 in 'UnsetPending'

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
    local buffTier = targetRole:GetBuffTier((self.config).buffId_enemy)
    if buffTier < maxCount then
      LuaSkillCtrl:DispelBuff(targetRole, 2055, 0)
      LuaSkillCtrl:CallBuff(self, targetRole, 2055, maxCount)
    end
  end
end

bs_92046.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_5 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_enemy and target ~= nil and target.hp > 0 then
    local buffTier1 = target:GetBuffTier((self.config).buffId_enemy)
    local isHaveEffect = (self.countBuffEffect)[target.uid] ~= nil
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

    if not isHaveEffect or buffTier1 == 0 then
      (self.countBuffEffect)[target.uid] = LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
      LuaSkillCtrl:EffectSetCountValue((self.countBuffEffect)[target.uid], buffTier1 - 1)
    else
      LuaSkillCtrl:EffectSetCountValue((self.countBuffEffect)[target.uid], buffTier1 - 1)
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

bs_92046.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_92046.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  self.countBuffEffect = nil
  self.targetTable = nil
  ;
  (base.LuaDispose)(self)
end

return bs_92046

