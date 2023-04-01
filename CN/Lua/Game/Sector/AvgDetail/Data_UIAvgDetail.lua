-- params : ...
-- function num : 0 , upvalues : _ENV
local Data_UIAvgDetail = class("Data_UIAvgDetail")
Data_UIAvgDetail.SetAvgDetailAvgId = function(self, avgId)
  -- function num : 0_0 , upvalues : _ENV
  self._avgId = avgId
  self._avgCfg = (ConfigData.story_avg)[avgId]
end

Data_UIAvgDetail.SetAvgDetailBannerTexPath = function(self, bannerTexPath)
  -- function num : 0_1
  self._bannerTexPath = bannerTexPath
end

Data_UIAvgDetail.SetAvgDetailExtraCondition = function(self, isUnlock, lockDes)
  -- function num : 0_2 , upvalues : _ENV
  if not self._extraLockConditionList then
    self._extraLockConditionList = {}
    ;
    (table.insert)(self._extraLockConditionList, {lockReason = lockDes, unlock = isUnlock})
  end
end

Data_UIAvgDetail.SetAvgDetailExtraReward = function(self, rewardDic)
  -- function num : 0_3
  self._extraReward = rewardDic
end

Data_UIAvgDetail.SetAvgDetailExTitle = function(self, str)
  -- function num : 0_4
  self._exTitle = str
end

Data_UIAvgDetail.SetAvgDetailCloseBgOpen = function(self, flag)
  -- function num : 0_5
  self._closeBgOpen = flag
end

Data_UIAvgDetail.SetAvgDetailCloseCallback = function(self, callback)
  -- function num : 0_6
  self._closeCallback = callback
end

Data_UIAvgDetail.SetAvgDetailOpenTweenBeginCallback = function(self, callback)
  -- function num : 0_7
  self._openBeginTweenCallback = callback
end

Data_UIAvgDetail.SetAvgDetailCloseTweenBeginCallback = function(self, callback)
  -- function num : 0_8
  self._closeBeginTweenCallback = callback
end

Data_UIAvgDetail.SetAvgDetailExtraPlayedState = function(self, flag)
  -- function num : 0_9
  self._extraPlayed = flag
end

Data_UIAvgDetail.SetAvgDetailRewardShowState = function(self, flag)
  -- function num : 0_10
  self._rewardShowState = flag
end

Data_UIAvgDetail.GetAvgDetailAvgId = function(self)
  -- function num : 0_11
  return self._avgId
end

Data_UIAvgDetail.GetAvgDetailAvgCfg = function(self)
  -- function num : 0_12
  return self._avgCfg
end

Data_UIAvgDetail.GetAvgDetailAvgBannerTexPath = function(self)
  -- function num : 0_13
  return self._bannerTexPath
end

Data_UIAvgDetail.GetAvgDetailExtraCondition = function(self)
  -- function num : 0_14
  return self._extraLockConditionList
end

Data_UIAvgDetail.GetAvgDetailCloseBgOpen = function(self)
  -- function num : 0_15
  return self._closeBgOpen
end

Data_UIAvgDetail.GetAvgDetailExTitle = function(self)
  -- function num : 0_16
  return self._exTitle
end

Data_UIAvgDetail.GetAvgDetailCloseCallback = function(self)
  -- function num : 0_17
  return self._closeCallback
end

Data_UIAvgDetail.GetAvgDetailExtraReward = function(self)
  -- function num : 0_18
  return self._extraReward
end

Data_UIAvgDetail.GetAvgDetailOpenTweenBeginCallback = function(self)
  -- function num : 0_19
  return self._openBeginTweenCallback
end

Data_UIAvgDetail.GetAvgDetailCloseTweenBeginCallback = function(self)
  -- function num : 0_20
  return self._closeBeginTweenCallback
end

Data_UIAvgDetail.GetAvgDetailPlayed = function(self)
  -- function num : 0_21 , upvalues : _ENV
  if self._extraPlayed ~= nil then
    return self._extraPlayed
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  return avgPlayCtrl:IsAvgPlayed(self._avgId)
end

Data_UIAvgDetail.GetAvgDetailRewardShowState = function(self)
  -- function num : 0_22
  if self._rewardShowState == nil then
    return true
  end
  return self._rewardShowState
end

return Data_UIAvgDetail

