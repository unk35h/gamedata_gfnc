-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroTalentData = class("HeroTalentData")
local HeroTalentNodeData = require("Game.HeroTalent.HeroTalentNodeData")
HeroTalentData.CreateWithMaxLevel = function(talentCfg)
  -- function num : 0_0 , upvalues : HeroTalentData, _ENV
  local data = (HeroTalentData.New)(talentCfg)
  data._curTotalLevel = ((ConfigData.hero_talent_tree).totalLevelDic)[data._treeId]
  for k,node in pairs(data._dic) do
    node:UpdateHeroTalentNodeLevel(node:GetHeroTalentNodeMaxLevel())
    local effect = node:GetHeroTalentNodeCurLevelEffect()
    for attrId,val in pairs(effect.attribute) do
      local count = (data._attributeAddDic)[attrId] or 0
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (data._attributeAddDic)[attrId] = count + val
    end
    data._fixedComat = data._fixedComat + effect.skill_comat
  end
  return data
end

HeroTalentData.ctor = function(self, talentCfg)
  -- function num : 0_1 , upvalues : _ENV, HeroTalentNodeData
  self._dic = {}
  self._attributeAddDic = {}
  self._algorithmSpace = {}
  self._fixedComat = 0
  self._heroId = talentCfg.hero_id
  self._modelId = talentCfg.mould_id
  self._treeId = talentCfg.talent_id
  self._curTotalLevel = 0
  local treeCfg = (ConfigData.hero_talent_tree)[self._treeId]
  for pointId,cfg in pairs(treeCfg) do
    local data = (HeroTalentNodeData.New)(self._heroId, cfg, self)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self._dic)[pointId] = data
  end
end

HeroTalentData.UpdateHeroTalent = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV
  for nodeId,elem in pairs(msg.nodes) do
    local node = (self._dic)[nodeId]
    if node == nil then
      error("talent node is nil, heroId is " .. tostring(self._heroId) .. " nodeId is" .. tostring(nodeId))
    else
      self._curTotalLevel = self._curTotalLevel - node:GetHeroTalentNodeCurLevel()
      self:__ChangeNormalAddtion(node, false)
      self:__ChangeBranchAddtion(node, false)
      node:UpdateHeroTalentNodeLevel(elem.lv)
      local flag = node:GetHeroTalentNodeBranchId()
      if flag then
        node:UpdateHeroTalentNodeBranch(elem.idx + 1)
      end
      self._curTotalLevel = self._curTotalLevel + node:GetHeroTalentNodeCurLevel()
      self:__ChangeNormalAddtion(node, true)
      self:__ChangeBranchAddtion(node, true)
    end
  end
end

HeroTalentData.SetHeroTalentBranchInData = function(self, nodeId, branchId)
  -- function num : 0_3
  local node = (self._dic)[nodeId]
  if node == nil then
    return 
  end
  self:__ChangeBranchAddtion(node, false)
  node:UpdateHeroTalentNodeBranch(branchId)
  self:__ChangeBranchAddtion(node, true)
end

HeroTalentData.__ChangeNormalAddtion = function(self, node, flag)
  -- function num : 0_4 , upvalues : _ENV
  if node == nil or node:GetHeroTalentNodeCurLevel() < 1 then
    return 
  end
  local mul = flag and 1 or -1
  local effect = node:GetHeroTalentNodeCurLevelEffect()
  for attrId,val in pairs(effect.attribute) do
    local count = (self._attributeAddDic)[attrId] or 0
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._attributeAddDic)[attrId] = count + val * mul
  end
  for i,val in ipairs(effect.algorithm_space) do
    local count = (self._algorithmSpace)[i] or 0
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._algorithmSpace)[i] = count + val * mul
  end
  self._fixedComat = self._fixedComat + effect.skill_comat * mul
end

HeroTalentData.__ChangeBranchAddtion = function(self, node, flag)
  -- function num : 0_5 , upvalues : _ENV
  if node == nil or node:GetHeroTalentNodeCurLevel() < 1 then
    return 
  end
  local mul = flag and 1 or -1
  local branchAttri = node:GetHeroTalentNodeBranchAttrDic()
  if branchAttri ~= nil then
    for attrId,val in pairs(branchAttri) do
      local count = (self._attributeAddDic)[attrId] or 0
      count = count + val * mul
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R11 in 'UnsetPending'

      if count <= 0 then
        (self._attributeAddDic)[attrId] = nil
      else
        -- DECOMPILER ERROR at PC34: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (self._attributeAddDic)[attrId] = count
      end
    end
  end
end

HeroTalentData.GetHeroTalentHeroId = function(self)
  -- function num : 0_6
  return self._heroId
end

HeroTalentData.GetHeroTalentTreeId = function(self)
  -- function num : 0_7
  return self._treeId
end

HeroTalentData.GetHeroTalentModelId = function(self)
  -- function num : 0_8
  return self._modelId
end

HeroTalentData.GetHeroTalentNodeDic = function(self)
  -- function num : 0_9
  return self._dic
end

HeroTalentData.GetHeroTalentNodeById = function(self, pointId)
  -- function num : 0_10
  return (self._dic)[pointId]
end

HeroTalentData.GetHeroTalentTotalLevel = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return self._curTotalLevel, ((ConfigData.hero_talent_tree).totalLevelDic)[self._treeId]
end

HeroTalentData.ExistHeroTalentCanLevelUp = function(self)
  -- function num : 0_12 , upvalues : _ENV
  for _,node in pairs(self._dic) do
    if node:IsHeroTalentNodeCanLeveUp() then
      return true
    end
  end
  return false
end

HeroTalentData.SetSingleAttrBouns = function(self, attrId, attrVal)
  -- function num : 0_13
  local count = (self._attributeAddDic)[attrId] or 0
  count = count + attrVal
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._attributeAddDic)[attrId] = count
end

HeroTalentData.GetAttributeAddtion = function(self, attrId)
  -- function num : 0_14
  local attrVal = (self._attributeAddDic)[attrId] or 0
  return attrVal
end

HeroTalentData.GetAttributeAddtionAll = function(self)
  -- function num : 0_15
  return self._attributeAddDic
end

HeroTalentData.GetAlgorithmSpace = function(self)
  -- function num : 0_16
  return self._algorithmSpace
end

HeroTalentData.GetHeroTalentFixedComat = function(self)
  -- function num : 0_17
  return self._fixedComat
end

return HeroTalentData

