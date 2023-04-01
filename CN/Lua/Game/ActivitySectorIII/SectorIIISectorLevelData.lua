-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySectorII.MainMap.Data.SectorIISectorLevelData")
local SectorIIISectorLevelData = class("SectorIIISectorIIILevelData", base)
SectorIIISectorLevelData.CreateSectorIIIEPLevelData = function(sectorId, warchessLevelDetailCfg, stageExtrCfg)
  -- function num : 0_0 , upvalues : SectorIIISectorLevelData, _ENV
  local data = (SectorIIISectorLevelData.New)()
  data.isBattle = true
  data.stageCfg = warchessLevelDetailCfg
  data.stageId = warchessLevelDetailCfg.id
  data.isClear = false
  data.isUnlock = (CheckCondition.CheckLua)((data.stageCfg).pre_condition, (data.stageCfg).pre_para1, (data.stageCfg).pre_para2)
  data.stageExtrCfg = stageExtrCfg
  local posCfg = (data.stageExtrCfg).stage_pos
  data.pos = (Vector2.New)(posCfg[1], posCfg[2])
  data.linePos = (Vector2.New)(posCfg[1] - 1, posCfg[2] - 31)
  data.is_isolated = (data.stageExtrCfg).is_isolated
  data.isSideStage = (data.stageExtrCfg).is_side
  return data
end

SectorIIISectorLevelData.CreateSectorIIIStoryLevelData = function(sectorId, avgCfg, avgExtrCfg)
  -- function num : 0_1 , upvalues : SectorIIISectorLevelData, _ENV
  local data = (SectorIIISectorLevelData.New)()
  data.sectorId = sectorId
  data.isBattle = false
  data.avgCfg = avgCfg
  data.avgId = avgCfg.id
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  data.isClear = avgPlayCtrl:IsAvgPlayed(data.avgId)
  data.isUnlock = avgPlayCtrl:IsAvgUnlock(data.avgId)
  data.avgExtrCfg = avgExtrCfg
  local posCfg = (data.avgExtrCfg).story_pos
  data.pos = (Vector2.New)(posCfg[1], posCfg[2])
  data.linePos = (Vector2.New)(posCfg[1] - 1, posCfg[2] - 31)
  data.is_isolated = (data.avgExtrCfg).is_isolated
  return data
end

SectorIIISectorLevelData.IsSectorIIIStageIsolated = function(self)
  -- function num : 0_2
  return self.is_isolated
end

return SectorIIISectorLevelData

