-- params : ...
-- function num : 0 , upvalues : _ENV
local AllActivitySectorIData = class("AllActivitySectorIData")
local ActivitySectorIData = require("Game.ActivitySectorI.ActivitySectorIData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
AllActivitySectorIData.ctor = function(self)
  -- function num : 0_0
  self._dataDic = {}
end

AllActivitySectorIData.UpdateSectorIMsg = function(self, datamsg)
  -- function num : 0_1 , upvalues : _ENV, ActivitySectorIData
  if datamsg == nil or #datamsg == 0 then
    return 
  end
  for _,singleData in pairs(datamsg) do
    local id = singleData.actId
    local data = (self._dataDic)[id]
    if data == nil then
      data = (ActivitySectorIData.New)()
      -- DECOMPILER ERROR at PC19: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._dataDic)[id] = data
      data:InitDataByMsg(singleData)
    else
      data:UpdateDataByMsg(singleData)
    end
  end
end

AllActivitySectorIData.GetSectorIData = function(self, actId)
  -- function num : 0_2
  local data = (self._dataDic)[actId]
  if data == nil or not data:IsActivityOpen() then
    return nil
  end
  return data
end

AllActivitySectorIData.GetDataBySectorId = function(self, sectorId)
  -- function num : 0_3 , upvalues : _ENV
  local actId = ((ConfigData.activity_time_limit).sectorMapping)[sectorId]
  if actId == nil then
    return nil, nil, false
  end
  local data = self:GetSectorIData(actId)
  if data == nil then
    return actId, nil, false
  end
  return actId, data, data:IsActivityOpen()
end

AllActivitySectorIData.GetDataBySectorIdRunning = function(self, sectorId)
  -- function num : 0_4 , upvalues : _ENV
  local actId = ((ConfigData.activity_time_limit).sectorMapping)[sectorId]
  if actId == nil then
    return nil, nil, false
  end
  local data = self:GetSectorIData(actId)
  if data == nil then
    return actId, nil, false
  end
  return actId, data, data:IsActivityRunning()
end

AllActivitySectorIData.GetOpenSectorActivity = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_LargeActivity)
  if not isUnlock then
    return nil
  end
  for actId,data in pairs(self._dataDic) do
    if data:IsActivityOpen() then
      return data
    end
  end
  return nil
end

AllActivitySectorIData.GetRunningSectorActivity = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_LargeActivity)
  if not isUnlock then
    return nil
  end
  for actId,data in pairs(self._dataDic) do
    if data:IsActivityRunning() then
      return data
    end
  end
  return nil
end

AllActivitySectorIData.IsOpenSectorIEntrance = function(self)
  -- function num : 0_7 , upvalues : _ENV
  return FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_LargeActivity)
end

AllActivitySectorIData.IsSecorIRechallengeStage = function(self, stageId)
  -- function num : 0_8 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil then
    return nil, false, false
  end
  return self:IsSecorIRechallengeSector(stageCfg.sector, stageId)
end

AllActivitySectorIData.IsSecorIRechallengeSector = function(self, sectorId, stageId)
  -- function num : 0_9 , upvalues : _ENV
  local actId, data, inTime = self:GetDataBySectorIdRunning(sectorId)
  if actId == nil then
    return nil, false, false
  end
  local isChallenge = sectorId == ((ConfigData.activity_time_limit)[actId]).rechallenge_stage
  if not self:IsOpenSectorIEntrance() then
    return actId, isChallenge, false
  end
  local canFight = true
  if isChallenge then
    local countEnough = data:GetSectorIBattleCount()
    local isSectorFinsh = (PlayerDataCenter.sectorStage):IsStageComplete(stageId)
    if inTime and not countEnough then
      canFight = not isSectorFinsh
    end
  end
  do return actId, isChallenge, canFight end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

AllActivitySectorIData.IsUnfinishSectorI = function(self, sectorId)
  -- function num : 0_10 , upvalues : _ENV, ActivityFrameEnum
  local actId, data, inTime = self:GetDataBySectorId(sectorId)
  if actId == nil then
    return false
  end
  if inTime then
    return true
  end
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameId = actCtrl:GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).SectorI, actId)
  if frameId == nil then
    return false
  end
  local frameData = actCtrl:GetActivityFrameData(frameId)
  return not frameData:GetIsActivityFinished()
end

return AllActivitySectorIData

