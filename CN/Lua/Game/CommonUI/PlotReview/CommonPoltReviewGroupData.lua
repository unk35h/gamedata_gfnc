-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonPoltReviewGroupData = class("CommonPoltReviewData")
CommonPoltReviewGroupData.ctor = function(self, groupENName, groupName, groupDes, AvgIdList)
  -- function num : 0_0
  self.groupENName = groupENName
  self.groupName = groupName
  self.groupDes = groupDes
  self.AvgIdList = AvgIdList
  self.isUnlock = true
  self.unlockDes = nil
  self.couldShowBlueDotFunc = nil
  self.unfoldCallback = nil
end

CommonPoltReviewGroupData.SetAvgGroupDataIsUnlock = function(self, isUnlock, unlockDes)
  -- function num : 0_1
  self.isUnlock = isUnlock
  self.unlockDes = unlockDes
  return self
end

CommonPoltReviewGroupData.SetAvgGroupDataBlueDotFunc = function(self, couldShowBlueDotFunc)
  -- function num : 0_2
  self.couldShowBlueDotFunc = couldShowBlueDotFunc
  return self
end

CommonPoltReviewGroupData.SetAvgSingleDotFunc = function(self, func)
  -- function num : 0_3
  self._couldShowSingleDotFunc = func
end

CommonPoltReviewGroupData.SetAvgGroupDataOperateData = function(self, unfoldCallback, playCallback)
  -- function num : 0_4
  self.unfoldCallback = unfoldCallback
  self.playCallback = playCallback
  return self
end

CommonPoltReviewGroupData.GetAvgGroupIsUnlock = function(self)
  -- function num : 0_5
  return self.isUnlock
end

CommonPoltReviewGroupData.GetAvgGroupUnlockDes = function(self)
  -- function num : 0_6
  return self.unlockDes
end

CommonPoltReviewGroupData.GetAvgGroupAvgIdList = function(self)
  -- function num : 0_7
  return self.AvgIdList
end

CommonPoltReviewGroupData.GetAvgGroupName = function(self)
  -- function num : 0_8
  return self.groupENName, self.groupName, self.groupDes
end

CommonPoltReviewGroupData.IsAvgGroupDataCouldBlueDot = function(self)
  -- function num : 0_9
  if self.couldShowBlueDotFunc ~= nil then
    return (self.couldShowBlueDotFunc)()
  end
  return false
end

CommonPoltReviewGroupData.IsAvgSingleReddot = function(self, avgid)
  -- function num : 0_10
  if self._couldShowSingleDotFunc then
    return (self._couldShowSingleDotFunc)(avgid)
  end
  return false
end

CommonPoltReviewGroupData.GetAvgGroupDataUnfoldCallback = function(self)
  -- function num : 0_11
  return self.unfoldCallback
end

CommonPoltReviewGroupData.GetAvgGroupDataPlayCallback = function(self)
  -- function num : 0_12
  return self.playCallback
end

return CommonPoltReviewGroupData

