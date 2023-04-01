-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorStageData = class("SectorStageData")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local eDifficulty = (require("Game.Sector.Enum.SectorLevelDetailEnum")).eDifficulty
local SectorEnum = require("Game.Sector.SectorEnum")
local cs_MicaSDKManager = CS.MicaSDKManager
SectorStageData.ctor = function(self)
  -- function num : 0_0
  self.__lastSelectSector = nil
  self.lastChallengeType = nil
  self.stageData = {}
  self.lastSatgeData = nil
  self._lastDiffDic = {}
  self.sectorPassTmDict = {}
end

SectorStageData.InitSelectStage = function(self, sectorId, difficult)
  -- function num : 0_1
  self.__lastSelectSector = sectorId
  self.__lastSelectDiff = difficult or 1
  if sectorId == nil then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._lastDiffDic)[sectorId] = difficult or 1
end

SectorStageData.SetSelectSectorId = function(self, sectorId)
  -- function num : 0_2
  self.__lastSelectSector = sectorId
  if sectorId == nil then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  if (self._lastDiffDic)[sectorId] == nil then
    (self._lastDiffDic)[sectorId] = 1
  end
end

SectorStageData.GetSelectSectorId = function(self)
  -- function num : 0_3
  return self.__lastSelectSector
end

SectorStageData.SetSelectDifficult = function(self, difficult)
  -- function num : 0_4
  self.__lastSelectDiff = difficult or 1
  if self.__lastSelectSector == nil then
    return 
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._lastDiffDic)[self.__lastSelectSector] = difficult or 1
end

SectorStageData.GetSelectDifficult = function(self, sectorId)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Unhandled construct in 'MakeBoolean' P1

  -- DECOMPILER ERROR at PC17: Unhandled construct in 'MakeBoolean' P1

  if not (self._lastDiffDic)[sectorId] then
    do return self.__lastSelectDiff == nil or self.__lastSelectDiff ~= eSectorStageDifficult.Endless or (ConfigData.endless)[sectorId] == nil or 1 end
    if not (self._lastDiffDic)[sectorId] then
      do return not (((ConfigData.sector_stage).sectorTotalCountDic)[sectorId])[self.__lastSelectDiff] and ((ConfigData.sector_stage).sectorTotalCountDic)[sectorId] == nil or 0 <= 0 or 1 end
      return 1
    end
  end
end

SectorStageData.UpdateSectorPassTm = function(self, data)
  -- function num : 0_6
  self.sectorPassTmDict = data
end

SectorStageData.UpdateSectorPassTmDiff = function(self, data)
  -- function num : 0_7 , upvalues : _ENV
  for i,v in pairs(data) do
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R7 in 'UnsetPending'

    (self.sectorPassTmDict)[i] = v
  end
end

SectorStageData.UpdateStageData = function(self, data, isInit)
  -- function num : 0_8 , upvalues : _ENV, CheckerTypeId
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  for k,v in pairs(data) do
    if not isInit then
      self:_StageTrackEvent(k, v)
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.stageData)[k] = v
    if not isInit then
      self:UpdateSctStageItemState(k)
      if self:IsStageComplete(k) then
        UnlockCenter:TriggerUnlockEvent((UnlockCenter.eUnlockLogic).CompleteStage, k)
      end
      local unlockDic = ((ConfigData.sector).stageUnlockDic)[k]
      if unlockDic ~= nil then
        for id,checkerTypeId in pairs(unlockDic) do
          if checkerTypeId == CheckerTypeId.CompleteStage then
            self:UpdateSctStageItemState(id)
          else
            if checkerTypeId == CheckerTypeId.CompleteAvg then
              avgPlayCtrl:UpdateMainAvgState(id)
            end
          end
        end
      end
    end
  end
end

SectorStageData.GetStageState = function(self, stageId)
  -- function num : 0_9
  local stageState = (self.stageData)[stageId]
  return stageState or 0
end

SectorStageData.IsStageUnlock = function(self, stageId)
  -- function num : 0_10 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[stageId]
  return (CheckCondition.CheckLua)(stageCfg.pre_condition, stageCfg.pre_para1, stageCfg.pre_para2)
end

SectorStageData.IsSectorUnlock = function(self, sectorId)
  -- function num : 0_11 , upvalues : _ENV
  local sectorCfg = (ConfigData.sector)[sectorId]
  if sectorCfg == nil then
    return false
  end
  local sectorStage = ((ConfigData.sector_stage).sectorIdList)[sectorId]
  if sectorStage == nil or #sectorStage == 0 then
    return false
  end
  local sectorStageCfg = (ConfigData.sector_stage)[sectorStage[1]]
  local stageId = sectorStageCfg.id
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay, true)
  local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1)
  if avgCfg == nil then
    return self:IsStageUnlock(stageId)
  else
    return avgPlayCtrl:IsAvgUnlock(avgCfg.id)
  end
end

SectorStageData.IsStageComplete = function(self, stageId)
  -- function num : 0_12
  local stageState = self:GetStageState(stageId)
  do return stageState > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SectorStageData.IsSectorClear = function(self, sectorId)
  -- function num : 0_13 , upvalues : SectorEnum, _ENV, eDifficulty
  if sectorId == 0 then
    sectorId = SectorEnum.NewbeeSectorId
  end
  local sectorCfg = (ConfigData.sector)[sectorId]
  if sectorCfg == nil then
    return false
  end
  if not self:IsSectorUnlock(sectorId) then
    return false
  end
  local normalStageList = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[eDifficulty.normal]
  local lastStageId = normalStageList[#normalStageList]
  if self:IsStageComplete(lastStageId) then
    return true
  end
  return false
end

SectorStageData.AnySectorBuildingUnlock = function(self, sectorId)
  -- function num : 0_14 , upvalues : _ENV
  local sectorCfg = (ConfigData.sector)[sectorId]
  if sectorCfg == nil then
    return 
  end
  for k,buildId in ipairs(sectorCfg.building) do
    local lvCfg = (ConfigData.buildingLevel)[buildId]
    if lvCfg == nil then
      error("Cant get buildingLevel cfg, buildId : " .. tostring(buildId))
      return 
    end
    local lv1Cfg = lvCfg[1]
    if lv1Cfg == nil then
      error("Cant get building level 1 cfg, buildId : " .. tostring(buildId))
      return 
    end
    if (CheckCondition.CheckLua)(lv1Cfg.pre_condition, lv1Cfg.pre_para1, lv1Cfg.pre_para2) then
      return true
    end
  end
end

SectorStageData.UpdateSctStageItemState = function(self, stageId)
  -- function num : 0_15 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil then
    error("Cant get sector_stage cfg, stageId = " .. tostring(stageId))
    return 
  end
  MsgCenter:Broadcast(eMsgEventId.OnMainLevelStateChange, stageCfg.sector, stageCfg.difficulty, stageId)
end

SectorStageData.GetSectorProcess = function(self, sectorId)
  -- function num : 0_16 , upvalues : _ENV, eDifficulty
  local normalStageList = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[eDifficulty.normal]
  for _,stageId in ipairs(normalStageList) do
    if not self:IsStageComplete(stageId) then
      return false, stageId
    end
  end
  return true, normalStageList[#normalStageList]
end

SectorStageData.GetSectorUnlockProcess = function(self, sectorId)
  -- function num : 0_17 , upvalues : _ENV, eDifficulty
  local normalStageList = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[eDifficulty.normal]
  local lastUnlockStageId = 0
  for _,stageId in ipairs(normalStageList) do
    if self:IsSectorUnlock(stageId) then
      do
        lastUnlockStageId = stageId
        -- DECOMPILER ERROR at PC17: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC17: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  return lastUnlockStageId
end

SectorStageData.GetEpStageCfg4Home = function(self)
  -- function num : 0_18 , upvalues : _ENV, SectorEnum
  local latestSectorId, latestStageIndex, lastdifferIdex = nil, nil, nil
  for _,sectorId in ipairs((ConfigData.sector).id_sort_list) do
    if self:IsSectorUnlock(sectorId) then
      latestSectorId = sectorId
    else
      break
    end
  end
  do
    if latestSectorId == nil then
      latestSectorId = SectorEnum.NewbeeSectorId
    end
    local sageDifferList = ((ConfigData.sector_stage).sectorDiffDic)[latestSectorId]
    for differIdex = 1, (ConfigData.sector_stage).difficultyCount do
      local stageList = sageDifferList[differIdex]
      if stageList ~= nil and #stageList ~= 0 then
        for index,stageId in ipairs(stageList) do
          if self:IsStageUnlock(stageId) then
            latestStageIndex = index
            lastdifferIdex = differIdex
          else
            return latestSectorId, latestStageIndex, lastdifferIdex
          end
        end
      end
    end
    if latestStageIndex ~= nil then
      return latestSectorId, latestStageIndex, lastdifferIdex
    end
    local final = nil
    for key,value in pairs(ConfigData.sector_stage) do
      final = value
      do break end
    end
    do
      return final.sector, final.id, final.difficulty
    end
  end
end

SectorStageData.GetEpStageCfg4UserInfo = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local latestSectorId, latestStageIndex = nil, nil
  for _,sectorId in ipairs((ConfigData.sector).id_sort_list) do
    if self:IsSectorUnlock(sectorId) then
      do
        local sectorStage = ((ConfigData.sector_stage).sectorIdList)[sectorId]
        if self:IsStageComplete(sectorStage[1]) then
          latestSectorId = sectorId
          latestStageIndex = 1
          local sageDifferList = ((ConfigData.sector_stage).sectorDiffDic)[latestSectorId]
          local differIdex = 1
          local stageList = sageDifferList[differIdex]
          if stageList ~= nil and #stageList ~= 0 then
            for index,stageId in ipairs(stageList) do
              if self:IsStageComplete(stageId) then
                latestStageIndex = index
              else
                return latestSectorId, latestStageIndex
              end
            end
          end
        else
          break
        end
        -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  if latestStageIndex ~= nil then
    return latestSectorId, latestStageIndex
  end
  return 
end

SectorStageData.CheckSectorPassTmInRange = function(self, sectorId, passTm)
  -- function num : 0_20 , upvalues : _ENV
  local sectorPassTm = (self.sectorPassTmDict)[sectorId]
  if sectorPassTm == nil then
    return false
  end
  local passAt = sectorPassTm.passAt + passTm
  local stamp = PlayerDataCenter.timestamp
  do return true, sectorPassTm.passAt + passTm < PlayerDataCenter.timestamp, sectorPassTm.passAt, sectorPassTm.passAt + passTm end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SectorStageData.GetGetUnlockInfo = function(self, stageId)
  -- function num : 0_21 , upvalues : _ENV
  local cfg = (ConfigData.sector_stage)[stageId]
  local lockInfo = (CheckCondition.GetUnlockInfoLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
  return lockInfo
end

SectorStageData.GetCanCompleteStage = function(self, difficult)
  -- function num : 0_22 , upvalues : eDifficulty, _ENV
  if difficult == eDifficulty.normal then
    local targetSectorId = nil
    for _,sectorId in ipairs((ConfigData.sector).id_sort_list) do
      if self:IsSectorUnlock(sectorId) then
        do
          local _, _, actFrameData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(sectorId)
          if actFrameData == nil then
            targetSectorId = sectorId
          end
          -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    if targetSectorId == nil then
      return nil
    end
    local normalStageList = (((ConfigData.sector_stage).sectorDiffDic)[targetSectorId])[eDifficulty.normal]
    for _,stageId in ipairs(normalStageList) do
      if self:IsStageUnlock(stageId) and not self:IsStageComplete(stageId) then
        return (ConfigData.sector_stage)[stageId]
      end
    end
    return nil
  else
    do
      if difficult == eDifficulty.nightmare then
        local stageCfg = nil
        for _,sectorId in ipairs((ConfigData.sector).id_sort_list) do
          if self:IsSectorUnlock(sectorId) then
            local _, _, actFrameData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(sectorId)
            if actFrameData == nil then
              local nightmareStageList = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[eDifficulty.nightmare]
              if nightmareStageList ~= nil and #nightmareStageList ~= 0 then
                local endStageId = nightmareStageList[#nightmareStageList]
                if not self:IsStageComplete(endStageId) then
                  for _,stageId in ipairs(nightmareStageList) do
                    if self:IsStageUnlock(stageId) and not self:IsStageComplete(stageId) then
                      local tempStage = (ConfigData.sector_stage)[stageId]
                      if tempStage ~= nil and (stageCfg == nil or tempStage.combat < stageCfg.combat) then
                        stageCfg = tempStage
                      end
                      break
                    end
                  end
                end
              end
            end
            do
              -- DECOMPILER ERROR at PC127: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC127: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
        return stageCfg
      end
    end
  end
end

local pnSdkTrackCfg = {[1105] = "stdhour1", [1112] = "stdhour3", [2103] = "levelnopurchase"}
local overseaTrackCfg = {[100101] = "stage_100101", [100105] = "stage_100105", [1104] = "stage_1104", [1112] = "stage_1112", [2115] = "stage_2115", [3115] = "stage_0315", [4115] = "stage_0415", [5115] = "stage_0515", [6129] = "stage_0629"}
SectorStageData._StageTrackEvent = function(self, stageId, state)
  -- function num : 0_23 , upvalues : cs_MicaSDKManager, _ENV, pnSdkTrackCfg, overseaTrackCfg
  if not (cs_MicaSDKManager.Instance):IsUseSdk() then
    return 
  end
  if self:IsStageComplete(stageId) then
    return 
  end
  if ((Consts.GameChannelType).IsPnSdk)() then
    local param = pnSdkTrackCfg[stageId]
    if param ~= nil then
      (cs_MicaSDKManager.Instance):TrackEvent(param)
    end
  else
    do
      if ((Consts.GameChannelType).IsOversea)() then
        local param = overseaTrackCfg[stageId]
        if param ~= nil then
          (cs_MicaSDKManager.Instance):StatsEventPreSetUid(param)
        end
      end
    end
  end
end

return SectorStageData

