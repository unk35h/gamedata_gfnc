-- params : ...
-- function num : 0 , upvalues : _ENV
local CacheSaveData = class("CacheSaveData")
CacheSaveData.ctor = function(self)
  -- function num : 0_0
  self._lastDunTowerLevel = {}
end

CacheSaveData.GetEnableConfirmInfinityNot50 = function(self)
  -- function num : 0_1
  if self.enableConfirmInfinityNot50 == nil then
    self.enableConfirmInfinityNot50 = true
  end
  return self.enableConfirmInfinityNot50
end

CacheSaveData.SetEnableConfirmInfinityNot50 = function(self, enable)
  -- function num : 0_2
  self.enableConfirmInfinityNot50 = enable
end

CacheSaveData.GetEnableLotteryPaidExecuteConfirm = function(self)
  -- function num : 0_3
  if self.enableLotteryPaidExecuteConfirm == nil then
    self.enableLotteryPaidExecuteConfirm = true
  end
  return self.enableLotteryPaidExecuteConfirm
end

CacheSaveData.SetEnableLotteryPaidExecuteConfirm = function(self, enable)
  -- function num : 0_4
  self.enableLotteryPaidExecuteConfirm = enable
end

CacheSaveData.GetEnableEpRewardBagExitConfirm = function(self)
  -- function num : 0_5
  if self.enableEpRewardBagExitConfirm == nil then
    self.enableEpRewardBagExitConfirm = true
  end
  return self.enableEpRewardBagExitConfirm
end

CacheSaveData.SetEnableEpRewardBagExitConfirm = function(self, enable)
  -- function num : 0_6
  self.enableEpRewardBagExitConfirm = enable
end

CacheSaveData.GetEnableShopRefreshExecuteConfirm = function(self)
  -- function num : 0_7
  if self.enableShopRefreshExecuteConfirm == nil then
    self.enableShopRefreshExecuteConfirm = true
  end
  return self.enableShopRefreshExecuteConfirm
end

CacheSaveData.SetEnableShopRefreshExecuteConfirm = function(self, enable)
  -- function num : 0_8
  self.enableShopRefreshExecuteConfirm = enable
end

CacheSaveData.GetEnableActivitySpringLongTailConfirm = function(self)
  -- function num : 0_9
  if self.enableEnableActivitySpringLongTailConfirm == nil then
    self.enableEnableActivitySpringLongTailConfirm = true
  end
  return self.enableEnableActivitySpringLongTailConfirm
end

CacheSaveData.SetEnableActivitySpringLongTailConfirm = function(self, enable)
  -- function num : 0_10
  self.enableEnableActivitySpringLongTailConfirm = enable
end

CacheSaveData.GetEnableActivityWinter23NoRepeatTip = function(self)
  -- function num : 0_11
  if self.enableEnableActivityWinter23NoRepeatTip == nil then
    self.enableEnableActivityWinter23NoRepeatTip = true
  end
  return self.enableEnableActivityWinter23NoRepeatTip
end

CacheSaveData.SetEnableActivityWinter23NoRepeatTip = function(self, enable)
  -- function num : 0_12
  self.enableEnableActivityWinter23NoRepeatTip = enable
end

CacheSaveData.SetSpecificHeroListSort = function(self, fid, eSortMannerType, isAsceSort)
  -- function num : 0_13
  if self.specificHeroListSort == nil then
    self.specificHeroListSort = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.specificHeroListSort)[fid] = {eSortMannerType = eSortMannerType, isAsceSort = isAsceSort}
end

CacheSaveData.GetSpecificHeroListSort = function(self, fid)
  -- function num : 0_14
  if self.specificHeroListSort == nil or (self.specificHeroListSort)[fid] == nil then
    return nil
  end
  local pecificHeroListSortData = (self.specificHeroListSort)[fid]
  return pecificHeroListSortData.eSortMannerType, pecificHeroListSortData.isAsceSort
end

CacheSaveData.GetOasisSkyHourOffset = function(self)
  -- function num : 0_15
  return self.oasisSkyHour or 0
end

CacheSaveData.SetOasisSkyHourOffset = function(self, value)
  -- function num : 0_16
  if self.oasisSkyHour ~= value then
    self.oasisSkyHour = value
  end
end

CacheSaveData.GetOasisSkyMonthOffset = function(self)
  -- function num : 0_17
  return self.oasisSkyMonth or 0
end

CacheSaveData.SetOasisSkyMonthOffset = function(self, value)
  -- function num : 0_18
  if self.oasisSkyMonth ~= value then
    self.oasisSkyMonth = value
  end
end

CacheSaveData.GetLastDunTowerProgress = function(self, towerId)
  -- function num : 0_19
  return (self._lastDunTowerLevel)[towerId]
end

CacheSaveData.SaveLastDunTowerProgress = function(self, towerId, level)
  -- function num : 0_20
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._lastDunTowerLevel)[towerId] = level
end

CacheSaveData.SetLastHeroInterationCVInfo = function(self, lastCvInfo)
  -- function num : 0_21
  self._lastCvInfo = lastCvInfo
end

CacheSaveData.GetLastHeroInterationCVInfo = function(self)
  -- function num : 0_22 , upvalues : _ENV
  if self._lastCvInfo == nil then
    self._lastCvInfo = {}
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._lastCvInfo).lastVoiceHeroId = nil
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._lastCvInfo).lastVoiceTIme = ((CS.UnityEngine).Time).time
  end
  return self._lastCvInfo
end

CacheSaveData.SetIsEndBattleForHeroInteration = function(self, value)
  -- function num : 0_23
  self._isEndBattleForHeroInteration = value
end

CacheSaveData.GetIsEndBattleForHeroInteration = function(self)
  -- function num : 0_24
  return self._isEndBattleForHeroInteration
end

CacheSaveData.SetLastChangeWeatherTimeStamp = function(self, value)
  -- function num : 0_25
  self._lastChangeWeatherTimeStamp = value
end

CacheSaveData.GetLastChangeWeatherTimeStamp = function(self)
  -- function num : 0_26
  if self._lastChangeWeatherTimeStamp == nil then
    return 0
  end
  return self._lastChangeWeatherTimeStamp
end

CacheSaveData.SetLastWeatherIndex = function(self, index)
  -- function num : 0_27
  self._lastWeatherIndex = index
end

CacheSaveData.GetLastWeatherIndex = function(self)
  -- function num : 0_28
  return self._lastWeatherIndex
end

CacheSaveData.IsHasPlayedL2dLoginAnim = function(self)
  -- function num : 0_29
  do return self.isHasPlayedL2dLoginAnim == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CacheSaveData.SetHasPlayedL2dLoginAnim = function(self, value)
  -- function num : 0_30
  self.isHasPlayedL2dLoginAnim = value
end

return CacheSaveData

