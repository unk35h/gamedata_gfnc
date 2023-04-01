-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroTalentNodeData = class("HeroTalentNodeData")
HeroTalentNodeData.ctor = function(self, heroId, cfg, talentData)
  -- function num : 0_0 , upvalues : _ENV
  self._heroId = heroId
  self._nodeCfg = cfg
  self._parent = talentData
  self._treeId = (self._nodeCfg).tree_id
  self._effectCfg = (ConfigData.hero_talent_effect)[(self._nodeCfg).effect_id]
  self._level = 0
  self._normalConditionUnlock = false
  self._isUnlock = false
  self._branchSelectId = 0
end

HeroTalentNodeData.UpdateHeroTalentNodeLevel = function(self, level)
  -- function num : 0_1 , upvalues : _ENV
  if self:GetHeroTalentNodeMaxLevel() < level then
    error("talent level error")
    level = self:GetHeroTalentNodeMaxLevel()
  end
  self._level = level
  local flag, _ = self:GetHeroTalentNodeBranchId()
  if flag and self._branchSelectId == 0 then
    self._branchSelectId = 1
  end
end

HeroTalentNodeData.UpdateHeroTalentNodeBranch = function(self, branchId)
  -- function num : 0_2
  local curEffect = self:GetHeroTalentNodeCurLevelEffect()
  if curEffect == nil or curEffect.branch == nil or #curEffect.branch < branchId then
    branchId = 0
  end
  self._branchSelectId = branchId
end

HeroTalentNodeData.GetHeroTalentNodeCurLevelEffect = function(self)
  -- function num : 0_3
  return (self._effectCfg)[self._level]
end

HeroTalentNodeData.GetHeroTalentNodeNexLevelEffect = function(self)
  -- function num : 0_4
  if self._level == (self._nodeCfg).max_level then
    return nil
  end
  return (self._effectCfg)[self._level + 1]
end

HeroTalentNodeData.IsHeroTalentNodeMaxLevel = function(self)
  -- function num : 0_5
  do return (self._nodeCfg).max_level <= self._level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroTalentNodeData.GetHeroTalentNodeMaxLevel = function(self)
  -- function num : 0_6
  return (self._nodeCfg).max_level
end

HeroTalentNodeData.GetHeroTalentNodeCurLevel = function(self)
  -- function num : 0_7
  return self._level
end

HeroTalentNodeData.GetHeroTalentNodeHeroId = function(self)
  -- function num : 0_8
  return self._heroId
end

HeroTalentNodeData.IsHeroTalentNodeUnlock = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self._isUnlock then
    return self._isUnlock
  end
  if not self._normalConditionUnlock then
    if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Talent) then
      return false
    end
    if not (CheckCondition.CheckLua)((self._nodeCfg).pre_condition, (self._nodeCfg).pre_para1, (self._nodeCfg).pre_para2) then
      return false
    end
  end
  self._normalConditionUnlock = true
  local prePointDic = self:GetHeroTalentNodePreIdLvDic()
  if (table.count)(prePointDic) == 0 then
    self._isUnlock = true
    return self._isUnlock
  end
  local isParallel = self:IsPrePointParallel()
  local preUnlock = false
  for prePointId,preLeve in pairs(prePointDic) do
    local node = (self._parent):GetHeroTalentNodeById(prePointId)
    if node == nil then
      error("prePoint is nil, heroId is " .. tostring(self._heroId) .. " nodeId is " .. tostring(self:GetHeroTalentNodeId()) .. " prePoint is " .. tostring(prePointId))
    else
      local isUnlock = preLeve <= node:GetHeroTalentNodeCurLevel()
      if not isUnlock and not isParallel then
        return false
      elseif isUnlock then
        preUnlock = true
      end
    end
  end
  if isParallel or not preUnlock then
    return false
  end
  self._isUnlock = true
  do return self._isUnlock end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

HeroTalentNodeData.GetHeroTalentNodeLockDesList = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local list = {}
  local preLvDic = self:GetHeroTalentNodePreIdLvDic()
  for id,lv in pairs(preLvDic) do
    local prePoint = (self._parent):GetHeroTalentNodeById(id)
    if prePoint ~= nil then
      local des = (LanguageUtil.GetLocaleText)((prePoint:GetHeroTalentNodeCfg()).name)
      if lv <= 1 then
        des = (string.format)(ConfigData:GetTipContent(5071), des)
      else
        des = (string.format)(ConfigData:GetTipContent(5072), des, tostring(lv))
      end
      local unlock = lv <= prePoint:GetHeroTalentNodeCurLevel()
      ;
      (table.insert)(list, {lockReason = des, unlock = unlock})
    end
  end
  local norConditionList = (CheckCondition.GetUnlockAndInfoList)((self._nodeCfg).pre_condition, (self._nodeCfg).pre_para1, (self._nodeCfg).pre_para2)
  for i,conditionInfo in ipairs(norConditionList) do
    (table.insert)(list, {lockReason = conditionInfo.lockReason, unlock = conditionInfo.unlock})
  end
  do return list end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

HeroTalentNodeData.GetHeroTalentNodeLevelupCost = function(self)
  -- function num : 0_11
  if (self._nodeCfg).cost_dic == nil then
    return nil, nil
  end
  local cost = ((self._nodeCfg).cost_dic)[self._level + 1]
  if cost == nil then
    return nil, nil
  end
  return cost.itemIds, cost.itemNums
end

HeroTalentNodeData.GetHeroTalentNodeLevelupReward = function(self)
  -- function num : 0_12
  local cfg = self:GetHeroTalentNodeNexLevelEffect()
  if cfg == nil then
    return nil
  end
  return cfg.rewardIds, cfg.rewardNums
end

HeroTalentNodeData.IsHeroTalentNodeCanLeveUp = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self:IsHeroTalentNodeMaxLevel() or not self:IsHeroTalentNodeUnlock() then
    return false
  end
  local items, nums = self:GetHeroTalentNodeLevelupCost()
  if items ~= nil then
    for i,itemId in ipairs(items) do
      if PlayerDataCenter:GetItemCount(itemId) < nums[i] then
        return false
      end
    end
  end
  do
    return true
  end
end

HeroTalentNodeData.GetHeroTalentNodeType = function(self)
  -- function num : 0_14
  return (self._nodeCfg).nodeType
end

HeroTalentNodeData.GetHeroTalentNodeId = function(self)
  -- function num : 0_15
  return (self._nodeCfg).serial_num
end

HeroTalentNodeData.IsPrePointParallel = function(self)
  -- function num : 0_16
  return (self._nodeCfg).condition_talent_relation
end

HeroTalentNodeData.GetHeroTalentNodePreIdLvDic = function(self)
  -- function num : 0_17
  return (self._nodeCfg).pre_condition_talent
end

HeroTalentNodeData.GetHeroTalentNodeCfg = function(self)
  -- function num : 0_18
  return self._nodeCfg
end

HeroTalentNodeData.GetTalentTreeInfo = function(self)
  -- function num : 0_19
  return self._parent
end

HeroTalentNodeData.GetTalentNextLvAttriDescrib = function(self)
  -- function num : 0_20
  local curEffect = self:GetHeroTalentNodeCurLevelEffect()
  local nextEffect = self:GetHeroTalentNodeNexLevelEffect()
  local curAttris = curEffect ~= nil and curEffect.attribute or nil
  local nextEffect = nextEffect ~= nil and nextEffect.attribute or nil
  return self:__GetAttriAttriDescrib(curAttris, nextEffect)
end

HeroTalentNodeData.GetHeroTalentNodeBranchId = function(self)
  -- function num : 0_21
  local curEffect = self:GetHeroTalentNodeCurLevelEffect()
  do return curEffect ~= nil and curEffect.branch ~= nil, self._branchSelectId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroTalentNodeData.GetHeroTalentNodeBranchAttrDic = function(self)
  -- function num : 0_22
  local curEffect = self:GetHeroTalentNodeCurLevelEffect()
  if curEffect.branch == nil then
    return nil
  end
  return (curEffect.branch)[self._branchSelectId]
end

HeroTalentNodeData.GetTalentNextLvBranchAttriDescrib = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local curEffect = self:GetHeroTalentNodeCurLevelEffect()
  local nextEffect = self:GetHeroTalentNodeNexLevelEffect()
  local curBranch = curEffect ~= nil and curEffect.branch or nil
  local nextBranch = nextEffect ~= nil and nextEffect.branch or nil
  local branchCount = (math.max)(curBranch ~= nil and #curBranch or 0, nextBranch ~= nil and #nextBranch or 0)
  if branchCount == 0 then
    return nil
  end
  local res = {}
  for i = 1, branchCount do
    local curBranchSingle = curBranch ~= nil and curBranch[i] or nil
    local nextBranchSingle = nextBranch ~= nil and nextBranch[i] or nil
    ;
    (table.insert)(res, self:__GetAttriAttriDescrib(curBranchSingle, nextBranchSingle))
  end
  return res
end

HeroTalentNodeData.__GetAttriAttriDescrib = function(self, curAtrris, nextAttris)
  -- function num : 0_24 , upvalues : _ENV
  if curAtrris == nil and nextAttris == nil then
    return nil
  end
  local res = {}
  if nextAttris == nil then
    if (table.count)(curAtrris) == 0 then
      return nil
    end
    for attrId,val in pairs(curAtrris) do
      res[attrId] = {cur = val}
    end
  else
    do
      if curAtrris == nil then
        if (table.count)(nextAttris) == 0 then
          return nil
        end
        for attrId,val in pairs(nextAttris) do
          res[attrId] = {cur = 0, next = val}
        end
      else
        do
          if (table.count)(nextAttris) == 0 then
            return nil
          end
          for attrId,val in pairs(curAtrris) do
            res[attrId] = {cur = curAtrris[attrId] or 0, next = val}
          end
          do
            return res
          end
        end
      end
    end
  end
end

return HeroTalentNodeData

