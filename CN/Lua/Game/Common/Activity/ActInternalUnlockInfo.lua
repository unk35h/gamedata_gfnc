-- params : ...
-- function num : 0 , upvalues : _ENV
local ActInternalUnlockInfo = class("ActInternalUnlockInfo")
local ActCommonEnum = require("Game.Common.Activity.ActCommonEnum")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
ActInternalUnlockInfo.ctor = function(self)
  -- function num : 0_0
  self._newUnlockInfoList = {}
end

ActInternalUnlockInfo.InitActAvgUnlockInfo = function(self, sectorId)
  -- function num : 0_1 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local avgList = ((ConfigData.story_avg).sectorAvgDic)[sectorId]
  if avgList == nil then
    return 
  end
  self._lockedAvgList = {}
  for _,avgId in pairs(avgList) do
    if not avgPlayCtrl:IsAvgPlayed(avgId) and not avgPlayCtrl:IsAvgUnlock(avgId) then
      (table.insert)(self._lockedAvgList, avgId)
    end
  end
end

ActInternalUnlockInfo.UpdateActAvgUnlockInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV, ActCommonEnum
  if self._lockedAvgList == nil then
    return 
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  while 1 do
    if #self._lockedAvgList > 0 then
      local avgId = (self._lockedAvgList)[1]
      if avgPlayCtrl:IsAvgUnlock(avgId) then
        do
          (table.remove)(self._lockedAvgList, 1)
          self:__AddNewUnlockInfo((ActCommonEnum.ActUnlockType).NormalAvg, avgId)
          -- DECOMPILER ERROR at PC30: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC30: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC30: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC30: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

ActInternalUnlockInfo.InitActEnvDiffUnlockInfo = function(self, diffLockDic)
  -- function num : 0_3
  self._diffLockDic = diffLockDic
end

ActInternalUnlockInfo.GetActEnvDiffUnlockInfo = function(self)
  -- function num : 0_4
  return self._diffLockDic
end

ActInternalUnlockInfo.AddActEnvDiffUnlockInfo = function(self, diff)
  -- function num : 0_5 , upvalues : ActCommonEnum
  if self._diffLockDic == nil then
    return 
  end
  local envId = (self._diffLockDic)[diff]
  if envId == nil then
    return 
  end
  self:__AddNewUnlockInfo((ActCommonEnum.ActUnlockType).EnvDifficulty, diff, envId)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._diffLockDic)[diff] = nil
end

ActInternalUnlockInfo.InitActDunRepeatUnlockInfo = function(self, dunLockDic)
  -- function num : 0_6
  self._dunLockDic = dunLockDic
end

ActInternalUnlockInfo.UpdateActDunRepeatUnlockInfo = function(self)
  -- function num : 0_7 , upvalues : _ENV, ActCommonEnum
  if self._dunLockDic == nil then
    return 
  end
  for dungeonId,dungeonData in pairs(self._dunLockDic) do
    if dungeonData:GetIsLevelUnlock() then
      self:__AddNewUnlockInfo((ActCommonEnum.ActUnlockType).DunRepeat, dungeonId)
      -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self._dunLockDic)[dungeonId] = nil
    end
  end
end

ActInternalUnlockInfo.InitAvgPlayedUnlockInfo = function(self, avgList)
  -- function num : 0_8 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  self._avgPlayedList = {}
  for _,avgId in pairs(avgList) do
    if not avgPlayCtrl:IsAvgPlayed(avgId) then
      (table.insert)(self._avgPlayedList, avgId)
    end
  end
end

ActInternalUnlockInfo.UpdateAvgPlayedUnlockInfo = function(self)
  -- function num : 0_9 , upvalues : _ENV, ActCommonEnum
  if self._avgPlayedList == nil or (self._avgPlayedList)[1] == nil then
    return 
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  for i = #self._avgPlayedList, 1, -1 do
    if avgPlayCtrl:IsAvgPlayed((self._avgPlayedList)[i]) then
      do
        (table.remove)(self._avgPlayedList, i)
        -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  if (self._avgPlayedList)[1] == nil then
    self:__AddNewUnlockInfo((ActCommonEnum.ActUnlockType).AVGAllPlayed, 0, 0)
  end
end

ActInternalUnlockInfo.InitEnvUnlockInfo = function(self, envIdDic)
  -- function num : 0_10
  self._envDic = envIdDic
end

ActInternalUnlockInfo.AddEnvUnlockInfo = function(self, envId)
  -- function num : 0_11 , upvalues : ActCommonEnum
  if self._envDic == nil or (self._envDic)[envId] == nil then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._envDic)[envId] = nil
  self:__AddNewUnlockInfo((ActCommonEnum.ActUnlockType).Env, envId, 0)
end

ActInternalUnlockInfo.GetEnvUnlockInfo = function(self)
  -- function num : 0_12
  return self._envDic
end

ActInternalUnlockInfo.__AddNewUnlockInfo = function(self, unlockType, unlockId, unlockPara)
  -- function num : 0_13 , upvalues : _ENV
  local data = {unlockType = unlockType, unlockId = unlockId, unlockPara = unlockPara}
  ;
  (table.insert)(self._newUnlockInfoList, data)
  if type(data.unlockId) == "number" then
    (table.sort)(self._newUnlockInfoList, function(a, b)
    -- function num : 0_13_0
    do return a.unlockId < b.unlockId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  end
end

ActInternalUnlockInfo.ClearActUnlockInfo = function(self)
  -- function num : 0_14 , upvalues : _ENV
  (table.removeall)(self._newUnlockInfoList)
end

ActInternalUnlockInfo.GetActUnlockInfoList = function(self)
  -- function num : 0_15
  return self._newUnlockInfoList
end

ActInternalUnlockInfo.IsExistActUnlockInfo = function(self)
  -- function num : 0_16
  do return #self._newUnlockInfoList > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActInternalUnlockInfo.ResetAllUnlockData = function(self)
  -- function num : 0_17
  self:ClearActUnlockInfo()
  self._diffLockDic = nil
  self._lockedAvgList = nil
  self._dunLockDic = nil
  self._envDic = nil
  self._avgPlayedList = nil
end

return ActInternalUnlockInfo

