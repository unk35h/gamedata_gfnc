-- params : ...
-- function num : 0 , upvalues : _ENV
local ActTechData = class("ActTechData")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
ActTechData.CreatAWTechData = function(techId, actType, actId)
  -- function num : 0_0 , upvalues : ActTechData, _ENV
  local data = (ActTechData.New)()
  data.techId = techId
  data.actType = actType
  data.actId = actId
  local cfg = (ConfigData.activity_tech)[techId]
  if cfg == nil then
    error("can\'t get activity_tech cfg with techId:" .. tostring(techId))
    return 
  end
  data.techCfg = cfg
  data.techLevelCfg = (ConfigData.activity_tech_level)[techId]
  data.rowIndex = cfg.row
  data.colIndex = cfg.col
  data.previousTech = cfg.pre_tech
  data.maxLevel = #data.techLevelCfg
  return data
end

ActTechData.ctor = function(self)
  -- function num : 0_1
  self.actType = nil
  self.actId = nil
  self.techId = nil
  self.rowIndex = nil
  self.colIndex = nil
  self.techCfg = nil
  self.techLevelCfg = nil
  self.level = nil
  self.maxLevel = nil
  self.previousTech = nil
  self.previousTechData = nil
end

ActTechData.UpdateWATechByMsg = function(self, activityTechElem)
  -- function num : 0_2
  self.level = activityTechElem.level
end

ActTechData.GetIsTechUnlocked = function(self)
  -- function num : 0_3
  do return self:GetCurLevel() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActTechData.GetTechLogic = function(self, level)
  -- function num : 0_4 , upvalues : _ENV
  local levelCfg = (self.techLevelCfg)[level]
  if levelCfg == nil then
    error((string.format)("can\'t get tech(id:%s) level cfg with level:%s", self.techId, level))
    return nil
  end
  local logicArray = levelCfg.logic
  local para1Array = levelCfg.para1
  local para2Array = levelCfg.para2
  local para3Array = levelCfg.para3
  return logicArray, para1Array, para2Array, para3Array
end

ActTechData.GetTechDescription = function(self, level, moduleType)
  -- function num : 0_5 , upvalues : CommonLogicUtil
  if level == nil and (self:GetCurLevel() ~= 0 or not 1) then
    level = self.level
  end
  local logicArray, para1Array, para2Array, para3Array = self:GetTechLogic(level)
  local desStr = (CommonLogicUtil.GetLogicDesStrMultiLine)(logicArray, para1Array, para2Array, para3Array, moduleType)
  return desStr
end

ActTechData.GetTechDescriptionFirst = function(self, level, moduleType)
  -- function num : 0_6 , upvalues : CommonLogicUtil
  if level == nil and (self:GetCurLevel() ~= 0 or not 1) then
    level = self.level
  end
  local logicArray, para1Array, para2Array, para3Array = self:GetTechLogic(level)
  if #logicArray <= 0 then
    return 
  end
  local logic, para1, para2, para3 = logicArray[1], para1Array[1], para2Array[1], para3Array[1]
  local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, moduleType)
  return longDes, shortDes, valueDes
end

ActTechData.GetUnlockPreTechCondition = function(self)
  -- function num : 0_7
  return (self.techCfg).pre_tech_level
end

ActTechData.GetLevelCost = function(self, targetLevel)
  -- function num : 0_8
  local targetLevelCfg = (self.techLevelCfg)[targetLevel]
  return targetLevelCfg.cost
end

ActTechData.GetUnlockCfg = function(self)
  -- function num : 0_9
  local levelCfg = (self.techLevelCfg)[1]
  return levelCfg
end

ActTechData.GetIsUnlock = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local preTechData = self:GetPreTechData()
  if preTechData ~= nil and preTechData:GetCurLevel() < self:GetUnlockPreTechCondition() then
    return false
  end
  if self._extraUnlockFunc ~= nil and not (self._extraUnlockFunc)(self) then
    return false
  end
  local levelCfg = (self.techLevelCfg)[1]
  local isUnlock = (CheckCondition.CheckLua)(levelCfg.pre_condition, levelCfg.pre_para1, levelCfg.pre_para2)
  return isUnlock
end

ActTechData.IsCouldLevelUp = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local targetLevel = self:GetCurLevel() + 1
  local preTechData = self:GetPreTechData()
  if preTechData ~= nil and preTechData:GetCurLevel() < self:GetUnlockPreTechCondition() then
    return false, (string.format)(ConfigData:GetTipContent(7105), self:GetUnlockPreTechCondition(), preTechData:GetAWTechName())
  end
  if self._extraUnlockFunc ~= nil and not (self._extraUnlockFunc)(self) then
    return false
  end
  local levelCfg = (self.techLevelCfg)[targetLevel]
  if levelCfg == nil then
    return false
  end
  local isUnlock = (CheckCondition.CheckLua)(levelCfg.pre_condition, levelCfg.pre_para1, levelCfg.pre_para2)
  if not isUnlock then
    return false, (CheckCondition.GetUnlockInfoLua)(levelCfg.pre_condition, levelCfg.pre_para1, levelCfg.pre_para2)
  end
  local costDic = self:GetLevelCost(targetLevel)
  for costItemId,costNum in pairs(costDic) do
    local backPackNum = PlayerDataCenter:GetItemCount(costItemId)
    if backPackNum < costNum then
      local itemCfg = (ConfigData.item)[costItemId]
      local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
      return false, (string.format)(ConfigData:GetTipContent(7110), itemName, itemName)
    end
  end
  return true
end

ActTechData.IsLeveUpResEnough = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local targetLevel = self:GetCurLevel() + 1
  local levelCfg = (self.techLevelCfg)[targetLevel]
  if levelCfg == nil then
    return false, nil
  end
  local costDic = self:GetLevelCost(targetLevel)
  for costItemId,costNum in pairs(costDic) do
    local backPackNum = PlayerDataCenter:GetItemCount(costItemId)
    if backPackNum < costNum then
      local itemCfg = (ConfigData.item)[costItemId]
      local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
      return false, costItemId
    end
  end
  return true, nil
end

ActTechData.GetAWTechName = function(self)
  -- function num : 0_13 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.techCfg).name)
end

ActTechData.GetAWTechUnlockParam = function(self, level)
  -- function num : 0_14
  local levelCfg = (self.techLevelCfg)[level]
  return levelCfg.pre_condition, levelCfg.pre_para1, levelCfg.pre_para2
end

ActTechData.GetAWTechUnlockInfo = function(self, level)
  -- function num : 0_15 , upvalues : _ENV
  local levelCfg = (self.techLevelCfg)[level]
  local preConditionList = (CheckCondition.GetUnlockAndInfoList)(levelCfg.pre_condition, levelCfg.pre_para1, levelCfg.pre_para2)
  return preConditionList
end

ActTechData.GetTechCol = function(self)
  -- function num : 0_16
  return self.colIndex
end

ActTechData.GetTechId = function(self)
  -- function num : 0_17
  return self.techId
end

ActTechData.GetPreTechId = function(self)
  -- function num : 0_18
  if self.previousTech == 0 then
    return nil
  end
  return self.previousTech
end

ActTechData.SetPreTechData = function(self, techData)
  -- function num : 0_19
  self.previousTechData = techData
end

ActTechData.GetPreTechData = function(self)
  -- function num : 0_20
  return self.previousTechData
end

ActTechData.SetRearTechData = function(self, techData)
  -- function num : 0_21
  self._rearTechData = techData
end

ActTechData.GetRearTechData = function(self)
  -- function num : 0_22
  return self._rearTechData
end

ActTechData.GetWATechIcon = function(self)
  -- function num : 0_23
  return (self.techCfg).icon
end

ActTechData.GetCurLevel = function(self)
  -- function num : 0_24
  return self.level or 0
end

ActTechData.GetMaxLevel = function(self)
  -- function num : 0_25
  return self.maxLevel
end

ActTechData.IsActTechLevelLoop = function(self)
  -- function num : 0_26 , upvalues : _ENV
  do return (self.techCfg).refresh_type == proto_csmsg_TechRefreshType.Loop end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActTechData.IsActTechSpecial = function(self)
  -- function num : 0_27 , upvalues : _ENV
  do return (self.techCfg).refresh_type == proto_csmsg_TechRefreshType.Every end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActTechData.IsMaxLvel = function(self)
  -- function num : 0_28
  do return self:GetMaxLevel() <= self:GetCurLevel() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActTechData.GetTechActId = function(self)
  -- function num : 0_29
  return self.actId
end

ActTechData.GetActFrameId = function(self)
  -- function num : 0_30 , upvalues : _ENV
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  return activityFrameCtrl:GetIdByActTypeAndActId(self.actType, self.actId)
end

ActTechData.IsActTechAutoUnlock = function(self)
  -- function num : 0_31
  local levelCfg = (self.techLevelCfg)[1]
  return levelCfg.auto_unlock
end

ActTechData.GetActTechCfg = function(self)
  -- function num : 0_32
  return self.techCfg
end

ActTechData.GetActTechPrfeTotleLevel = function(self)
  -- function num : 0_33
  return (self.techCfg).pre_total_level
end

ActTechData.GetActTechBranch = function(self)
  -- function num : 0_34
  return (self.techCfg).branch
end

ActTechData.GetActTechRowCol = function(self)
  -- function num : 0_35 , upvalues : _ENV
  local lineCfg = (ConfigData.activity_tech_line)[(self.techCfg).row]
  if lineCfg == nil then
    error("cant get activity_tech_line,id = " .. tostring((self.techCfg).row))
    return 1, 1
  end
  return lineCfg.num, (self.techCfg).col
end

ActTechData.GetActTechUIFrameId = function(self)
  -- function num : 0_36
  return (self.techCfg).frame
end

ActTechData.GetActTechBranchCfg = function(self)
  -- function num : 0_37 , upvalues : _ENV
  local branchId = self:GetActTechBranch()
  local branchType = ((ConfigData.activity_tech_branch).branchToTypeMapping)[branchId]
  local branchCfg = ((ConfigData.activity_tech_branch)[branchType])[branchId]
  return branchCfg
end

ActTechData.SetActTechExtraUnlockConfitionFunc = function(self, func)
  -- function num : 0_38
  self._extraUnlockFunc = func
end

return ActTechData

