-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerActivityTechBranchLevel = {}
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
CheckerActivityTechBranchLevel.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerActivityTechBranchLevel.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  local branchId = param[2]
  local level = param[3]
  local techType = ((ConfigData.activity_tech_branch).branchToTypeMapping)[branchId]
  if techType == nil then
    return false
  end
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local treeData = actFrameCtrl:GetActivityTech(techType)
  if level > treeData:GetTechBranchLevel(branchId) then
    do return treeData == nil end
    local actTable = ((ConfigData.activity_tech_branch).techTypeToActMapping)[techType]
    if actTable == nil then
      return false
    end
    if actTable.actCat == (ActivityFrameEnum.eActivityType).Carnival then
      local carnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
      if carnivalCtrl == nil then
        return false
      end
      local carnivalData = carnivalCtrl:GetCarnivalAct(actTable.actId)
      if carnivalData == nil then
        return false
      end
      return level <= carnivalData:GetCarnivalTechBranchLevel(branchId)
    end
    do return false end
    -- DECOMPILER ERROR: 7 unprocessed JMP targets
  end
end

CheckerActivityTechBranchLevel.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  local branchId = param[2]
  local level = param[3]
  local techType = ((ConfigData.activity_tech_branch).branchToTypeMapping)[branchId]
  if techType == nil then
    return ""
  end
  local branchCfg = ((ConfigData.activity_tech_branch)[techType])[branchId]
  if branchCfg == nil then
    return ""
  end
  return (string.format)(ConfigData:GetTipContent(7112), (LanguageUtil.GetLocaleText)(branchCfg.branch_name), level)
end

return CheckerActivityTechBranchLevel

