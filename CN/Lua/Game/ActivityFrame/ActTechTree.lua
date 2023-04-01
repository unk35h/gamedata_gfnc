-- params : ...
-- function num : 0 , upvalues : _ENV
local ActTechTree = class("ActTechTree")
local ActTechData = require("Game.ActivitySectorII.Tech.Data.ActTechData")
ActTechTree.InitTechTree = function(self, treeId, activityBase)
  -- function num : 0_0 , upvalues : _ENV, ActTechData
  self._treeId = treeId
  self._actFrameId = activityBase:GetActFrameId()
  self._techDataDic = {}
  self._techRowDic = {}
  local actType = activityBase:GetActivityFrameCat()
  local actId = activityBase:GetActId()
  local techTypeListCfg = ((ConfigData.activity_tech).actTechTypeList)[self._treeId]
  if techTypeListCfg == nil then
    error("activity tech type is NIL,type is " .. tostring(self._treeId))
    return 
  end
  self._allTechLvDirty = true
  local IsTechAllLevelTargetCallback = BindCallback(self, self.__IsTechAllLevelTarget)
  for _,techId in ipairs(techTypeListCfg.techIds) do
    local techCfg = (ConfigData.activity_tech)[techId]
    local branchDic = (self._techDataDic)[techCfg.branch]
    if branchDic == nil then
      branchDic = {}
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self._techDataDic)[techCfg.branch] = branchDic
    end
    local tech = (ActTechData.CreatAWTechData)(techId, actType, actId)
    tech:SetActTechExtraUnlockConfitionFunc(IsTechAllLevelTargetCallback)
    branchDic[techId] = tech
    if not tech:IsActTechAutoUnlock() then
      local rowId = techCfg.row
      -- DECOMPILER ERROR at PC64: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (self._techRowDic)[rowId] = true
    end
  end
  for branchId,branchDic in pairs(self._techDataDic) do
    for techId,techData in pairs(branchDic) do
      local previousTechId = techData:GetPreTechId()
      if previousTechId ~= nil then
        local previousTech = ((self._techDataDic)[branchId])[previousTechId]
        techData:SetPreTechData(previousTech)
        previousTech:SetRearTechData(techData)
      end
    end
  end
  self._techTypeCfg = (ConfigData.activity_tech_type)[self._treeId]
end

ActTechTree.UpdateActTechTree = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  for techId,singleMsg in pairs(msg.techData) do
    local techCfg = (ConfigData.activity_tech)[techId]
    local techData = ((self._techDataDic)[techCfg.branch])[techId]
    techData:UpdateWATechByMsg(singleMsg)
  end
  self._allTechLvDirty = true
end

ActTechTree.BindActTechUpdateFunc = function(self, func)
  -- function num : 0_2
  self._techUpdateFunc = func
end

ActTechTree.BindActTechAllResetFunc = function(self, func)
  -- function num : 0_3
  self._techAllResetFunc = func
end

ActTechTree.__ResetActTechTree = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local levelMsg = {level = 0}
  for _,branchDic in pairs(self._techDataDic) do
    for _,techData in pairs(branchDic) do
      techData:UpdateWATechByMsg(levelMsg)
    end
  end
end

ActTechTree.__IsTechAllLevelTarget = function(self, techData)
  -- function num : 0_5
  local prelevel = techData:GetActTechPrfeTotleLevel()
  do return prelevel <= self:GetTechBranchLevel(0) end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActTechTree.ReqTechUp = function(self, techId, callback)
  -- function num : 0_6 , upvalues : _ENV
  local techData = self:GetTechByTechId(techId)
  if techData == nil then
    error("tech is NIL , id:" .. tostring(techId))
    return 
  end
  local flag, noEnoughItemId = techData:IsLeveUpResEnough()
  if not flag then
    return 
  end
  if not techData:IsCouldLevelUp() then
    return 
  end
  local activityFrameNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNetwork:CS_ActivityTech_Upgrade(self._actFrameId, techData:GetTechId(), function(args)
    -- function num : 0_6_0 , upvalues : _ENV, self, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local upgradedTechElement = args[0]
    for i,elemt in ipairs(upgradedTechElement) do
      local techDataElemt = self:GetTechByTechId(elemt.id)
      if techDataElemt ~= nil then
        techDataElemt:UpdateWATechByMsg(elemt)
      end
    end
    if self._techUpdateFunc ~= nil then
      (self._techUpdateFunc)()
    end
    if callback ~= nil then
      callback()
    end
  end
)
end

ActTechTree.ReqTechAllReset = function(self, callback)
  -- function num : 0_7 , upvalues : _ENV
  local flag, resetCost = self:GetTreeResetCost()
  if not flag then
    return 
  end
  for k,v in pairs(resetCost) do
    if PlayerDataCenter:GetItemCount(k) < v then
      return 
    end
  end
  if self:GetTechBranchLevel(0) <= 0 then
    return 
  end
  local activityFrameNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNetwork:CS_ActivityTech_ResetAll(self._actFrameId, function(args)
    -- function num : 0_7_0 , upvalues : self, callback
    self:__ResetActTechTree()
    if self._techAllResetFunc ~= nil then
      (self._techAllResetFunc)()
    end
    if callback ~= nil then
      callback()
    end
  end
)
end

ActTechTree.IsExsitCouldLvUpTechInBranch = function(self, branchId)
  -- function num : 0_8 , upvalues : _ENV
  local branchDic = (self._techDataDic)[branchId]
  if branchDic == nil then
    return false
  end
  for k,techData in pairs(branchDic) do
    if techData:IsCouldLevelUp() then
      return true
    end
  end
  return false
end

ActTechTree.IsExsitCouldLvUpTechInTree = function(self)
  -- function num : 0_9 , upvalues : _ENV
  for k,v in pairs(self._techDataDic) do
    if self:IsExsitCouldLvUpTechInBranch(k) then
      return true
    end
  end
  return false
end

ActTechTree.GetTreeId = function(self)
  -- function num : 0_10
  return self._treeId
end

ActTechTree.GetTechDataDic = function(self)
  -- function num : 0_11
  return self._techDataDic
end

ActTechTree.GetTechTypeCostDic = function(self)
  -- function num : 0_12 , upvalues : _ENV
  return ((ConfigData.activity_tech).techTypeCostIdDic)[self._treeId]
end

ActTechTree.GetTechRow = function(self, rowIndex)
  -- function num : 0_13 , upvalues : _ENV
  local rowCfg = (ConfigData.activity_tech_line)[rowIndex]
  if rowCfg == nil then
    return 0
  end
  return rowCfg.num
end

ActTechTree.GetTechBranchLevel = function(self, branchId)
  -- function num : 0_14 , upvalues : _ENV
  if branchId or 0 == 0 then
    if self._allTechLvDirty then
      local level = 0
      local maxLevel = 0
      local techDic = self:GetTechDataDic()
      for k,branchDic in pairs(techDic) do
        for k,tech in pairs(branchDic) do
          level = level + tech:GetCurLevel()
          maxLevel = maxLevel + tech:GetMaxLevel()
        end
      end
      self._techAllLevel = level
      self._techAllLevelMax = maxLevel
    end
    do
      do return self._techAllLevel, self._techAllLevelMax end
      local level = 0
      local maxLevel = 0
      local branchTechDic = (self._techDataDic)[branchId]
      if branchTechDic == nil then
        return 0, 0
      end
      for k,tech in pairs(branchTechDic) do
        level = level + tech:GetCurLevel()
        maxLevel = maxLevel + tech:GetMaxLevel()
      end
      return level, maxLevel
    end
  end
end

ActTechTree.GetTreeResetReturnItemId = function(self)
  -- function num : 0_15
  if self._techTypeCfg == nil then
    return false, nil
  end
  return true, (self._techTypeCfg).activity_tech_item
end

ActTechTree.GetTreeResetCost = function(self)
  -- function num : 0_16
  if self._techTypeCfg == nil then
    return false, nil
  end
  return true, (self._techTypeCfg).return_tech_item
end

ActTechTree.GetTechByTechId = function(self, techId)
  -- function num : 0_17 , upvalues : _ENV
  local tempTechCfg = (ConfigData.activity_tech)[techId]
  if tempTechCfg == nil then
    return nil
  end
  local techBranch = (self._techDataDic)[tempTechCfg.branch]
  if techBranch == nil then
    return nil
  end
  return techBranch[techId]
end

ActTechTree.GetTechActFrameId = function(self)
  -- function num : 0_18
  return self._actFrameId
end

return ActTechTree

