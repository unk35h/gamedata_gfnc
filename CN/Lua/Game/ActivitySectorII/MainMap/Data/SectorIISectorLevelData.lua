-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorIISectorLevelData = class("SectorIISectorLevelData")
SectorIISectorLevelData.CreateSectorIIEpLevelData = function(sectorId, stageCfg, stageExtrCfg)
  -- function num : 0_0 , upvalues : SectorIISectorLevelData, _ENV
  local data = (SectorIISectorLevelData.New)()
  data.sectorId = sectorId
  data.isBattle = true
  data.stageCfg = stageCfg
  data.stageId = stageCfg.id
  data.isClear = (PlayerDataCenter.sectorStage):IsStageComplete(data.stageId)
  data.isUnlock = (PlayerDataCenter.sectorStage):IsStageUnlock(data.stageId)
  data.stageExtrCfg = stageExtrCfg
  if data.stageExtrCfg == nil then
    error((string.format)("can\'t get winter activity sector stage extrCfg with sectorId:%s stageId:%s", tostring(sectorId), tostring(data.stageId)))
    return 
  end
  local posCfg = (data.stageExtrCfg).stage_pos
  data.pos = (Vector2.New)(posCfg[1], posCfg[2])
  data.linePos = (Vector2.New)(posCfg[1], posCfg[2] - 81.6)
  return data
end

SectorIISectorLevelData.CreateSectorIIStoryLevelData = function(sectorId, avgCfg, avgExtrCfg)
  -- function num : 0_1 , upvalues : SectorIISectorLevelData, _ENV
  local data = (SectorIISectorLevelData.New)()
  data.sectorId = sectorId
  data.isBattle = false
  data.avgCfg = avgCfg
  data.avgId = avgCfg.id
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  data.isClear = avgPlayCtrl:IsAvgPlayed(data.avgId)
  data.isUnlock = avgPlayCtrl:IsAvgUnlock(data.avgId)
  data.avgExtrCfg = avgExtrCfg
  if data.avgExtrCfg == nil then
    error((string.format)("can\'t get winter activity sector story extrCfg with sectorId:%s stroyId:%s", tostring(sectorId), tostring(data.avgId)))
    return 
  end
  local posCfg = (data.avgExtrCfg).story_pos
  data.pos = (Vector2.New)(posCfg[1], posCfg[2])
  data.linePos = data.pos
  return data
end

SectorIISectorLevelData.ctor = function(self)
  -- function num : 0_2
  self.sectorId = nil
  self.isBattle = nil
  self.isUnlock = nil
  self.isClear = nil
  self.pos = nil
  self.linePos = nil
  self.parentLevelList = {}
  self.childLevelList = nil
  self.stageId = nil
  self.stageCfg = nil
  self.stageExtrCfg = nil
  self.isSideStage = nil
  self.avgId = nil
  self.avgCfg = nil
  self.avgExtrCfg = nil
end

SectorIISectorLevelData.GetLevelSectorId = function(self)
  -- function num : 0_3
  return self.sectorId
end

SectorIISectorLevelData.GetLevelSageId = function(self)
  -- function num : 0_4
  return self.stageId
end

SectorIISectorLevelData.GetIsBattle = function(self)
  -- function num : 0_5
  return self.isBattle
end

SectorIISectorLevelData.GetIsLevelClaer = function(self)
  -- function num : 0_6
  return self.isClear
end

SectorIISectorLevelData.GetIsLevelUnlock = function(self)
  -- function num : 0_7
  return self.isUnlock
end

SectorIISectorLevelData.GetIsLevelPos = function(self)
  -- function num : 0_8
  return self.pos
end

SectorIISectorLevelData.GetIsLevelLinePos = function(self)
  -- function num : 0_9
  return self.linePos
end

SectorIISectorLevelData.RefreshSIILevelState = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.isBattle then
    self.isClear = (PlayerDataCenter.sectorStage):IsStageComplete(self.stageId)
    self.isUnlock = (PlayerDataCenter.sectorStage):IsStageUnlock(self.stageId)
  else
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    self.isClear = avgPlayCtrl:IsAvgPlayed(self.avgId)
    self.isUnlock = avgPlayCtrl:IsAvgUnlock(self.avgId)
  end
end

SectorIISectorLevelData.GetLevelEpStageCfg = function(self)
  -- function num : 0_11
  return self.stageCfg
end

SectorIISectorLevelData.GetLevelAvgCfg = function(self)
  -- function num : 0_12
  return self.avgCfg
end

SectorIISectorLevelData.GetLevelTitle = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self.isBattle and self.stageCfg ~= nil then
    return (LanguageUtil.GetLocaleText)((self.stageCfg).name)
  end
end

SectorIISectorLevelData.GetLevelSubTitle = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self.isBattle and self.stageExtrCfg ~= nil then
    return (string.format)(ConfigData:GetTipContent(13006), "", tostring((self.stageCfg).num))
  end
end

SectorIISectorLevelData.HasSectorIILevelChallengeTask = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if not self.isBattle then
    return 
  end
  local hasChallenge = (PlayerDataCenter.sectorAchievementDatas):HasStageChallengeTask(self.stageId)
  local isOpen = (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskOpen(self.stageId)
  return not hasChallenge or isOpen
end

SectorIISectorLevelData.GetSectorIILevelChallengeTaskNum = function(self)
  -- function num : 0_16 , upvalues : _ENV
  if not self.isBattle then
    return 
  end
  local totalNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskNum(self.stageId)
  local passedNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskCompleteNum(self.stageId)
  return totalNum, passedNum
end

SectorIISectorLevelData.GetSectroIILevelIconName = function(self)
  -- function num : 0_17
  if self.isBattle then
    return (self.stageCfg).icon
  else
    return (self.avgExtrCfg).icon
  end
end

SectorIISectorLevelData.GetSectroIILevelIsHard = function(self)
  -- function num : 0_18
  if not self.isBattle then
    return 
  end
  return (self.stageExtrCfg).is_hard
end

SectorIISectorLevelData.GetSectroIILevelIsSide = function(self)
  -- function num : 0_19
  if not self.isBattle then
    return 
  end
  return self.isSideStage
end

SectorIISectorLevelData.AddAParentSIILevel = function(self, levelData)
  -- function num : 0_20 , upvalues : _ENV
  (table.insert)(self.parentLevelList, levelData)
end

SectorIISectorLevelData.SwiftParent2SIILevel = function(self, levelData)
  -- function num : 0_21 , upvalues : _ENV
  levelData.parentLevelList = self.parentLevelList
  for _,mapLevelData in pairs(self.parentLevelList) do
    mapLevelData:AddAChildSIILevel(levelData)
    ;
    (table.removebyvalue)(mapLevelData.childLevelList, self)
  end
  self.parentLevelList = {}
end

SectorIISectorLevelData.GetSIILevelParentList = function(self)
  -- function num : 0_22
  return self.parentLevelList
end

SectorIISectorLevelData.ReplaceSIILevelParent = function(self, curParent, targetParent)
  -- function num : 0_23 , upvalues : _ENV
  local index = (table.indexof)(self.parentLevelList, curParent)
  if index == nil then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.parentLevelList)[index] = targetParent
end

SectorIISectorLevelData.AddAChildSIILevel = function(self, levelData)
  -- function num : 0_24 , upvalues : _ENV
  if self.childLevelList == nil then
    self.childLevelList = {}
  end
  ;
  (table.insert)(self.childLevelList, levelData)
end

SectorIISectorLevelData.GetSIILevelChildList = function(self)
  -- function num : 0_25
  return self.childLevelList
end

SectorIISectorLevelData.CleanSIILevelChildList = function(self)
  -- function num : 0_26
  self.childLevelList = nil
end

return SectorIISectorLevelData

