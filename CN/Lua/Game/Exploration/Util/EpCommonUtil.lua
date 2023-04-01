-- params : ...
-- function num : 0 , upvalues : _ENV
local EpCommonUtil = {}
EpCommonUtil.GetEventReplaceText = function(eventCfg, originKey)
  -- function num : 0_0 , upvalues : _ENV
  if eventCfg.replace_txt > 0 then
    local stageId = ExplorationManager:GetEpDungeonId()
    local replaceCfg = (ConfigData.event_replace_txt)[eventCfg.replace_txt]
    if replaceCfg ~= nil and replaceCfg[stageId] ~= nil then
      local txt = (LanguageUtil.GetLocaleText)(replaceCfg[stageId])
      return txt
    end
  end
  do
    return (LanguageUtil.GetLocaleText)(eventCfg[originKey])
  end
end

EpCommonUtil.IsSupportEpAutoMode = function()
  -- function num : 0_1 , upvalues : _ENV
  if (ExplorationManager.epCtrl):GetSupportAutoEpType() == 0 then
    return false
  end
  local isUnlockAutoExploration = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_AutoExploration)
  local showAutoEpBtn = isUnlockAutoExploration
  if showAutoEpBtn and (ExplorationManager:GetEpModuleId() == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge or ExplorationManager:IsSectorNewbee() or ((ExplorationManager.epCtrl).mapData):EpHasViewRange() or ExplorationManager:IsSectorTeach()) then
    showAutoEpBtn = false
  end
  do
    if showAutoEpBtn and ExplorationManager:GetEpModuleId() == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration and not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_AutoExplorationSector) then
      local stageCfg = ExplorationManager:GetSectorStageCfg()
      if stageCfg ~= nil and stageCfg.difficulty == 1 and showAutoEpBtn then
        showAutoEpBtn = (PlayerDataCenter.sectorStage):IsStageComplete(stageCfg.id)
      end
    end
    return showAutoEpBtn
  end
end

EpCommonUtil.IsSupportEpRestart = function()
  -- function num : 0_2 , upvalues : _ENV
  if not ExplorationManager:IsInExploration() then
    return false
  end
  local stageCfg = ExplorationManager:GetSectorStageCfg()
  return stageCfg.replay_is_open or false
end

return EpCommonUtil

