-- params : ...
-- function num : 0 , upvalues : _ENV
local ActTechRowData = class("ActTechRowData")
ActTechRowData.CreateTechRowData = function(line_id, techDataDic)
  -- function num : 0_0 , upvalues : ActTechRowData, _ENV
  local data = (ActTechRowData.New)()
  data.rowIndex = line_id
  local cfg = (ConfigData.activity_tech_line)[line_id]
  if cfg == nil then
    error("can\'t get activity_tech_line cfg with line id:" .. tostring(line_id))
    return 
  end
  data.techDataDic = techDataDic
  data.techLineCfg = cfg
  data.techAvgId = cfg.story_id
  data.techAvgCfg = (ConfigData.story_avg)[data.techAvgId]
  data:RefreshTechAvgState()
  return data
end

ActTechRowData.ctor = function(self)
  -- function num : 0_1
  self.rowIndex = nil
  self.techLineCfg = nil
  self.techDataDic = {}
end

ActTechRowData.GetIsUnlock = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local cfg = self.techLineCfg
  return (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
end

ActTechRowData.GetRowOrder = function(self)
  -- function num : 0_3
  return (self.techLineCfg).num
end

ActTechRowData.GetTechDataDic = function(self)
  -- function num : 0_4
  return self.techDataDic
end

ActTechRowData.GetRowName = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.techLineCfg).name)
end

ActTechRowData.GetRowEnName = function(self)
  -- function num : 0_6
  return (self.techLineCfg).name
end

ActTechRowData.GetRowIntro = function(self)
  -- function num : 0_7 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.techLineCfg).intro)
end

ActTechRowData.GetRowBgImage = function(self)
  -- function num : 0_8
  return (self.techLineCfg).bg
end

ActTechRowData.GetTechAvgId = function(self)
  -- function num : 0_9
  return self.techAvgId
end

ActTechRowData.GetIsTechAvgCfg = function(self)
  -- function num : 0_10
  return self.techAvgCfg
end

ActTechRowData.RefreshTechAvgState = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if not self:GetIsHaveTechAvg() then
    return 
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  self.isAvgClear = avgPlayCtrl:IsAvgPlayed(self.techAvgId)
  self.isAvgUnlock = avgPlayCtrl:IsAvgUnlock(self.techAvgId)
end

ActTechRowData.GetIsHaveTechAvg = function(self)
  -- function num : 0_12
  do return self.techAvgId ~= nil and self.techAvgId ~= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActTechRowData.GetIsTechAvgUnlock = function(self)
  -- function num : 0_13
  return self.isAvgUnlock
end

ActTechRowData.GetIsTechAvgCompleted = function(self)
  -- function num : 0_14
  return self.isAvgClear
end

ActTechRowData.GetIsTechAvgName = function(self)
  -- function num : 0_15 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.techAvgCfg).name)
end

ActTechRowData.GetTechAvgUnlockInfo = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local unlockInfo = avgPlayCtrl:IsAvgUnlockInfo(self.techAvgId)
  return unlockInfo
end

return ActTechRowData

