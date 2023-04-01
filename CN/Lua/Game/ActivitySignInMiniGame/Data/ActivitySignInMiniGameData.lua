-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySignInMiniGameData = class("ActivitySignInMiniGameData")
ActivitySignInMiniGameData.ctor = function(self)
  -- function num : 0_0
end

ActivitySignInMiniGameData.InitActivityFrameData = function(self, activityFrameData)
  -- function num : 0_1
  self._activityFrameData = activityFrameData
end

ActivitySignInMiniGameData.InitNetWrorkData = function(self, msg)
  -- function num : 0_2
  self._netWorkSignData = msg
end

ActivitySignInMiniGameData.GetActID = function(self)
  -- function num : 0_3
  if self._activityFrameData == nil then
    return nil
  end
  return (self._activityFrameData).actId
end

ActivitySignInMiniGameData.GetActivityFrameId = function(self)
  -- function num : 0_4
  if self._activityFrameData == nil then
    return nil
  end
  return (self._activityFrameData):GetActivityFrameId()
end

ActivitySignInMiniGameData.GetNextSignTime = function(self)
  -- function num : 0_5
  if self._netWorkSignData == nil then
    return nil
  end
  return (self._netWorkSignData).nextSignTime
end

ActivitySignInMiniGameData.GetHasSignDayCount = function(self)
  -- function num : 0_6
  if self._netWorkSignData == nil then
    return nil
  end
  return #(self._netWorkSignData).sign
end

ActivitySignInMiniGameData.GetActOpenTime = function(self)
  -- function num : 0_7
  if self._activityFrameData == nil then
    return nil
  end
  return (self._activityFrameData).startTime
end

ActivitySignInMiniGameData.GetActSign = function(self)
  -- function num : 0_8
  if self._netWorkSignData == nil then
    return nil
  end
  return (self._netWorkSignData).sign
end

ActivitySignInMiniGameData.GetActAwardGroup = function(self)
  -- function num : 0_9
  if self._netWorkSignData == nil then
    return nil
  end
  return (self._netWorkSignData).awardGroupId
end

ActivitySignInMiniGameData.GetActivityReddotNode = function(self)
  -- function num : 0_10
  if self._activityFrameData == nil then
    return nil
  end
  return (self._activityFrameData):GetActivityReddotNode()
end

ActivitySignInMiniGameData.SetActivityIscartoonPlayed = function(self)
  -- function num : 0_11
  if self._netWorkSignData == nil then
    return 
  end
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._netWorkSignData).cartoonPlayed = true
end

ActivitySignInMiniGameData.GetActivityIscartoonPlayed = function(self)
  -- function num : 0_12
  if self._netWorkSignData == nil then
    return false
  end
  return (self._netWorkSignData).cartoonPlayed
end

return ActivitySignInMiniGameData

