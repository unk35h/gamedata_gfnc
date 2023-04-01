-- params : ...
-- function num : 0 , upvalues : _ENV
local SpecWeaponData = class("SpecWeaponData")
SpecWeaponData.InitSpecWeapon = function(self, weaponId, step, level)
  -- function num : 0_0 , upvalues : _ENV
  self._weaponId = weaponId
  self._baseCfg = (ConfigData.spec_weapon_basic_config)[weaponId]
  self._stepListCfg = (ConfigData.spec_weapon_step)[weaponId]
  self._levelListCfg = (ConfigData.spec_weapon_level)[weaponId]
  self._maxStep = ((ConfigData.spec_weapon_step).stepDic)[weaponId]
  self._maxLevel = ((ConfigData.spec_weapon_level).levelDic)[weaponId]
  self:RefreshSpecWeapon(step, level)
end

SpecWeaponData.RefreshSpecWeapon = function(self, step, level)
  -- function num : 0_1 , upvalues : _ENV
  if self._maxLevel < level then
    level = self._maxLevel
  end
  if self._maxStep < step then
    step = self._maxStep
  end
  self._step = step
  self._level = level
  local levelCfg = (self._levelListCfg)[self._level]
  local stepCfg = (self._stepListCfg)[self._step]
  if levelCfg ~= nil then
    self._attrAddLevelDic = levelCfg.level_attribute
  else
    self._attrAddLevelDic = table.emptytable
  end
  if stepCfg ~= nil then
    self._attrAddStepDic = stepCfg.step_attribute
    self._reolaceSkillDic = stepCfg.replaceSkillDic
  else
    self._reolaceSkillDic = nil
    self._attrAddStepDic = table.emptytable
  end
end

SpecWeaponData.GetSpecWeaponId = function(self)
  -- function num : 0_2
  return self._weaponId
end

SpecWeaponData.GetSpecWeaponHeroId = function(self)
  -- function num : 0_3
  return (self._baseCfg).hero_id
end

SpecWeaponData.GetSpecWeaponCurStep = function(self)
  -- function num : 0_4
  return self._step
end

SpecWeaponData.GetSpecWeaponCurLevel = function(self)
  -- function num : 0_5
  return self._level
end

SpecWeaponData.GetSpecWeaponMaxStep = function(self)
  -- function num : 0_6
  return self._maxStep
end

SpecWeaponData.GetSpecWeaponMaxLevel = function(self)
  -- function num : 0_7
  return self._maxLevel
end

SpecWeaponData.IsSpecWeaponFullStep = function(self)
  -- function num : 0_8
  do return self._maxStep <= self._step end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SpecWeaponData.IsSpecWeaponFullLevel = function(self)
  -- function num : 0_9
  do return self._maxLevel <= self._level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SpecWeaponData.GetSpecWeaponStepLevel = function(self, step)
  -- function num : 0_10
  if step == nil then
    step = self._step
  end
  local stepCfg = (self._stepListCfg)[step]
  if stepCfg ~= nil then
    return stepCfg.max_level
  end
  return 0
end

SpecWeaponData.IsSpecWeaponContinueLevel = function(self)
  -- function num : 0_11
  if self:IsSpecWeaponFullLevel() then
    return false
  end
  do return self._level < self:GetSpecWeaponStepLevel() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SpecWeaponData.IsSpecWeaponContinueStep = function(self)
  -- function num : 0_12
  if self:IsSpecWeaponFullStep() then
    return false
  end
  do return self:GetSpecWeaponStepLevel() <= self._level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SpecWeaponData.GetSpecWeaponUprageCost = function(self)
  -- function num : 0_13
  local costIds, costNums = nil, nil
  local hasNext = false
  if self:IsSpecWeaponContinueStep() then
    local nextStep = (self._stepListCfg)[self._step + 1]
    costIds = nextStep.cost_ids
    costNums = nextStep.cost_nums
    hasNext = true
  else
    do
      do
        if self:IsSpecWeaponContinueLevel() then
          local nextLevel = (self._levelListCfg)[self._level]
          costIds = nextLevel.cost_ids
          costNums = nextLevel.cost_nums
          hasNext = true
        end
        return costIds, costNums, hasNext
      end
    end
  end
end

SpecWeaponData.IsSpecWeaponCouldUprage = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self._step == 0 and not self:IsSpecWeaponCouldUnlock() then
    return false
  end
  local costIds, costNums, hasNext = self:GetSpecWeaponUprageCost()
  if not hasNext then
    return false
  end
  for i,costId in ipairs(costIds) do
    if PlayerDataCenter:GetItemCount(costId) < costNums[i] then
      return false
    end
  end
  return true
end

SpecWeaponData.IsSpecWeaponCouldMultipleUprage = function(self, count)
  -- function num : 0_15
  do return self._level + count <= self:GetSpecWeaponMultipleUprageTargetLevel() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SpecWeaponData.GetSpecWeaponMultipleUprageCost = function(self, count)
  -- function num : 0_16 , upvalues : _ENV
  local costDic = {}
  for i = self._level, self._level + count - 1 do
    local nextLevel = (self._levelListCfg)[i]
    for i,v in ipairs(nextLevel.cost_ids) do
      local num = costDic[v] or 0
      num = num + (nextLevel.cost_nums)[i]
      costDic[v] = num
    end
  end
  return costDic
end

SpecWeaponData.GetSpecWeaponMultipleUprageTargetLevel = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local remainDic = {}
  local maxLevel = self:GetSpecWeaponStepLevel()
  local curLevel = self._level
  local isStop = false
  while 1 do
    if curLevel < maxLevel then
      local nextLevel = (self._levelListCfg)[curLevel]
      for i,v in ipairs(nextLevel.cost_ids) do
        if not remainDic[v] then
          local itemCount = PlayerDataCenter:GetItemCount(v)
        end
        itemCount = itemCount - (nextLevel.cost_nums)[i]
        if itemCount < 0 then
          isStop = true
          break
        end
        remainDic[v] = itemCount
      end
      do
        if not isStop then
          do
            curLevel = curLevel + 1
            -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  return curLevel
end

SpecWeaponData.IsSpecWeaponCouldUnlock = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SpecWeapon) then
    return (CheckCondition.CheckLua)((self._baseCfg).pre_condition, (self._baseCfg).pre_para1, (self._baseCfg).pre_para2)
  end
end

SpecWeaponData.GetSpecWeaponLevelCfg = function(self, level)
  -- function num : 0_19
  if level == nil then
    level = self._level
  end
  return (self._levelListCfg)[level]
end

SpecWeaponData.GetSpecWeaponStepCfg = function(self, step)
  -- function num : 0_20
  if step == nil then
    step = self._step
  end
  return (self._stepListCfg)[step]
end

SpecWeaponData.GetSpecWeaponBasicCfg = function(self)
  -- function num : 0_21
  return self._baseCfg
end

SpecWeaponData.GetSpecWeaponAttriAddtion = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local temp = {}
  for k,v in pairs(self._attrAddLevelDic) do
    temp[k] = v
  end
  for k,v in pairs(self._attrAddStepDic) do
    temp[k] = (temp[k] or 0) + v
  end
  return temp
end

SpecWeaponData.GetSpecWeaponAttriAddtionById = function(self, attriId)
  -- function num : 0_23
  return ((self._attrAddLevelDic)[attriId] or 0) + ((self._attrAddStepDic)[attriId] or 0)
end

SpecWeaponData.GetSpecWeaponReplaceSkillDic = function(self)
  -- function num : 0_24
  return self._reolaceSkillDic
end

SpecWeaponData.GetSpecWeaponHeroFragCount = function(self)
  -- function num : 0_25
  local total = (self._baseCfg).fragTotal
  do
    if self._level > 0 then
      local levelCfg = (self._levelListCfg)[self._level - 1]
      total = total - levelCfg.fragTotal2Level
    end
    do
      if self._step > 0 then
        local stepCfg = (self._stepListCfg)[self._step]
        total = total - stepCfg.fragTotal2Step
      end
      return total
    end
  end
end

SpecWeaponData.GetSpecWeaponFrontRoot = function(self, step, level)
  -- function num : 0_26 , upvalues : _ENV
  if level ~= nil then
    if level <= 1 then
      return 1, level
    end
    local targetStep = 1
    for i = self._maxStep, 1, -1 do
      local stepMaxLevel = self:GetSpecWeaponStepLevel(i)
      if stepMaxLevel < level then
        targetStep = i + 1
        break
      end
    end
    do
      do
        do return targetStep, level - 1 end
        if step ~= nil then
          if step <= 1 then
            return step, 0
          end
          step = step - 1
          local befrontStepLevel = self:GetSpecWeaponStepLevel(step)
          return step, befrontStepLevel
        end
        do
          if isGameDev then
            error("输入不能全空")
          end
          return 0, 0
        end
      end
    end
  end
end

return SpecWeaponData

