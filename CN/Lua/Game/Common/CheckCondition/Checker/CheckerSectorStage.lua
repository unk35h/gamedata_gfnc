-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerSectorStage = {}
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local SectorEnum = require("Game.Sector.SectorEnum")
local GetDiffStr = function(difficult)
  -- function num : 0_0 , upvalues : ExplorationEnum, _ENV
  local diffstr = nil
  if difficult == (ExplorationEnum.eDifficultType).Normal then
    diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_1)
  else
    if difficult == (ExplorationEnum.eDifficultType).Hard then
      diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_2)
    else
      diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_3)
    end
  end
  return diffstr
end

local GetSectorInfo = function(difficultStr, sectorStageCfg)
  -- function num : 0_1 , upvalues : _ENV
  local sectorId = ConfigData:GetSectorIdShow(sectorStageCfg.sector)
  return (string.format)(ConfigData:GetTipContent(TipContent.LockTip_Sector), tostring(sectorId), tostring(sectorId), tostring(sectorStageCfg.num), difficultStr)
end

local DefaultInfoFunc = function(sectorStageCfg)
  -- function num : 0_2 , upvalues : _ENV, GetDiffStr, GetSectorInfo
  if ((ConfigData.sector).onlyShowStageIdSectorDic)[sectorStageCfg.sector] then
    local sectorCfg = (ConfigData.sector)[sectorStageCfg.sector]
    local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
    return (string.format)(ConfigData:GetTipContent(7007), sectorName, sectorStageCfg.num)
  end
  do
    local diffstr = GetDiffStr(sectorStageCfg.difficulty)
    return GetSectorInfo(diffstr, sectorStageCfg)
  end
end

local specialInfoFuncDic = {[6] = function(sectorStageCfg)
  -- function num : 0_3 , upvalues : _ENV, DefaultInfoFunc
  local actId, data, inRuning = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorIdRunning(sectorStageCfg.sector)
  if inRuning then
    local sectorId, _ = ConfigData:GetSectorIdShow(sectorStageCfg.sector)
    local msg = (string.format)(ConfigData:GetTipContent(13010), sectorId, sectorStageCfg.num)
    return (string.format)(ConfigData:GetTipContent(262), msg)
  end
  do
    return DefaultInfoFunc(sectorStageCfg)
  end
end
, [90012] = function(sectorStageCfg)
  -- function num : 0_4 , upvalues : _ENV
  local sectorCfg = (ConfigData.sector)[sectorStageCfg.sector]
  local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  return (string.format)(ConfigData:GetTipContent(7007), sectorName, sectorStageCfg.num)
end
, [90011] = function(sectorStageCfg)
  -- function num : 0_5 , upvalues : _ENV
  local sectorId, _ = ConfigData:GetSectorIdShow(sectorStageCfg.sector)
  local msg = (string.format)(ConfigData:GetTipContent(13007), sectorId, sectorStageCfg.num)
  return (string.format)(ConfigData:GetTipContent(262), msg)
end
, [110011] = function(sectorStageCfg)
  -- function num : 0_6 , upvalues : _ENV
  local sectorCfg = (ConfigData.sector)[sectorStageCfg.sector]
  local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  local stageName = (LanguageUtil.GetLocaleText)(sectorStageCfg.name)
  local stageShortName = (string.format)(ConfigData:GetTipContent(13006), "", tostring(sectorStageCfg.num))
  local str = sectorName .. ":" .. stageShortName .. "-" .. stageName
  return (string.format)(ConfigData:GetTipContent(262), str)
end
, [240011] = function(sectorStageCfg)
  -- function num : 0_7 , upvalues : _ENV
  local sectorCfg = (ConfigData.sector)[sectorStageCfg.sector]
  local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  local stageName = (LanguageUtil.GetLocaleText)(sectorStageCfg.name)
  local str = sectorName .. ":" .. stageName
  return (string.format)(ConfigData:GetTipContent(262), str)
end
}
CheckerSectorStage.LengthCheck = function(param)
  -- function num : 0_8
  if #param >= 2 then
    return true
  end
  return false
end

CheckerSectorStage.ParamsCheck = function(param)
  -- function num : 0_9 , upvalues : _ENV
  return (PlayerDataCenter.sectorStage):IsStageComplete(param[2])
end

CheckerSectorStage.GetUnlockInfo = function(param)
  -- function num : 0_10 , upvalues : _ENV, specialInfoFuncDic, DefaultInfoFunc
  local sectorStageId = param[2]
  local sectorStageCfg = (ConfigData.sector_stage)[sectorStageId]
  if sectorStageCfg == nil then
    return ""
  end
  local info = nil
  local specialFunc = specialInfoFuncDic[sectorStageCfg.sector]
  if specialFunc ~= nil then
    info = specialFunc(sectorStageCfg)
    return info
  end
  return DefaultInfoFunc(sectorStageCfg)
end

return CheckerSectorStage

