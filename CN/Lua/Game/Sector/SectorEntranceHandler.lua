-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorEntranceHandler = class("SectorEntranceHandler")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local SectorEntranceCheckFunc = require("Game.Sector.SectorEntranceCheckFunc")
SectorEntranceHandler.CheckSectorValid = function(self, sectorId)
  -- function num : 0_0 , upvalues : SectorEntranceCheckFunc, _ENV
  local actType, actId, actFrameData = self:GetActivityDataBySectorId(sectorId)
  if actType ~= nil and SectorEntranceCheckFunc[actType] ~= nil then
    return (SectorEntranceCheckFunc[actType])(actId, sectorId, actFrameData)
  end
  return (PlayerDataCenter.sectorStage):IsSectorUnlock(sectorId)
end

SectorEntranceHandler.GetMainSectorBySectorId = function(self, sectorId)
  -- function num : 0_1 , upvalues : _ENV
  local sectorActivity = ((ConfigData.sector).sectorActivityDic)[sectorId]
  if sectorActivity ~= nil then
    return sectorActivity.mainSector
  end
  return sectorId
end

SectorEntranceHandler.GetMainSectorByActTypeAndId = function(self, actType, actId)
  -- function num : 0_2 , upvalues : _ENV
  local actTypeInfoDic = ((ConfigData.sector).actMainSector)[actType]
  if actTypeInfoDic == nil then
    return nil
  end
  local actMainSectorCfg = actTypeInfoDic[actId]
  if actMainSectorCfg == nil then
    return nil
  end
  return actMainSectorCfg.mainSector
end

SectorEntranceHandler.GetWarchessSeasonByActTypeAndId = function(self, actType, actId)
  -- function num : 0_3 , upvalues : _ENV
  local actTypeInfoDic = ((ConfigData.sector).actMainSector)[actType]
  if actTypeInfoDic == nil then
    return nil
  end
  local actMainSectorCfg = actTypeInfoDic[actId]
  if actMainSectorCfg == nil then
    return nil
  end
  return actMainSectorCfg.warchessSeason
end

SectorEntranceHandler.TrySpecialExitEp = function(lastSatgeData, successCallback)
  -- function num : 0_4 , upvalues : _ENV, ActLbUtil
  if lastSatgeData.stageCfg == nil then
    return false
  end
  local sectorId = (lastSatgeData.stageCfg).sector
  local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
  local isSuccess = (whiteDayCtrl ~= nil and whiteDayCtrl:TryEnterWDSector(sectorId, successCallback))
  if isSuccess then
    return true
  end
  local Winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  local realCallback = function()
    -- function num : 0_4_0 , upvalues : successCallback, ActLbUtil, Winter23Ctrl, sectorId
    if successCallback then
      successCallback()
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    Winter23Ctrl:ReEnterWinter23MainEp(sectorId, function()
      -- function num : 0_4_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end

  if Winter23Ctrl ~= nil then
    isSuccess = Winter23Ctrl:TryEnterWTSector(sectorId, realCallback)
  else
    isSuccess = false
  end
  if isSuccess then
    return true
  end
  do return false end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

SectorEntranceHandler.TrySpecialExitSeason = function(lastWCS, successCallback)
  -- function num : 0_5 , upvalues : _ENV, ActivityFrameEnum
  if lastWCS == nil or lastWCS.seasonId == nil then
    return false
  end
  local seasonId = lastWCS.seasonId
  local actType, actId, actFrameData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySeasonId(seasonId)
  if actFrameData ~= nil and actFrameData:IsActivityOpen() then
    do
      if actType == (ActivityFrameEnum.eActivityType).Hallowmas then
        local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
        if hallowmasCtrl ~= nil then
          self:OnEnterActivity()
          ;
          (UIUtil.AddOneCover)("lastSelectSector")
          hallowmasCtrl:OpenHallowmas(actId, self.__EnterSectorLevelFunc, self.__ResetToNormalState, nil, function()
    -- function num : 0_5_0 , upvalues : _ENV, successCallback
    (UIUtil.CloseOneCover)("lastSelectSector")
    if successCallback then
      successCallback()
    end
  end
)
          return true
        end
      end
      do
        if actType == (ActivityFrameEnum.eActivityType).Winter23 then
          local Winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
          if Winter23Ctrl ~= nil then
            return Winter23Ctrl:TryEnterWT23Season(seasonId, successCallback)
          end
        end
        do
          if actType == (ActivityFrameEnum.eActivityType).Season then
            local sesonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
            if sesonCtrl ~= nil then
              return sesonCtrl:OpenSeason(actId, true, successCallback)
            end
          end
          return false
        end
      end
    end
  end
end

SectorEntranceHandler.GetActivityDataBySectorId = function(self, sectorId)
  -- function num : 0_6 , upvalues : _ENV
  local sectorActivity = ((ConfigData.sector).sectorActivityDic)[sectorId]
  if sectorActivity == nil then
    return self:__GetActivitPluralDataBySectorId(sectorId)
  end
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actFrameId = actFrameCtrl:GetIdByActTypeAndActId(sectorActivity.type, sectorActivity.actId)
  local actFrameData = actFrameCtrl:GetActivityFrameData(actFrameId)
  return sectorActivity.type, sectorActivity.actId, actFrameData
end

SectorEntranceHandler.__GetActivitPluralDataBySectorId = function(self, sectorId)
  -- function num : 0_7 , upvalues : _ENV
  local sectorActivityList = ((ConfigData.sector).sectorActivityPluralDic)[sectorId]
  if sectorActivityList == nil then
    return nil, nil
  end
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  for _,sectorActivity in ipairs(sectorActivityList) do
    local actFrameId = actFrameCtrl:GetIdByActTypeAndActId(sectorActivity.type, sectorActivity.actId)
    local actFrameData = actFrameCtrl:GetActivityFrameData(actFrameId)
    if actFrameData ~= nil and actFrameData:IsActivityOpen() then
      return sectorActivity.type, sectorActivity.actId, actFrameData
    end
  end
  return nil, nil
end

SectorEntranceHandler.GetActivityDataBySeasonId = function(self, seasonId)
  -- function num : 0_8 , upvalues : _ENV
  local warChessSeasonActivity = ((ConfigData.activity).warChessSeasonActivityDic)[seasonId]
  if warChessSeasonActivity == nil then
    return 
  end
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actFrameId = actFrameCtrl:GetIdByActTypeAndActId(warChessSeasonActivity.type, warChessSeasonActivity.actId)
  local actFrameData = actFrameCtrl:GetActivityFrameData(actFrameId)
  return warChessSeasonActivity.type, warChessSeasonActivity.actId, actFrameData
end

return SectorEntranceHandler

