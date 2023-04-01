-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = class("ActivityBase")
ActivityBase.SetActFrameDataByType = function(self, typeId, actId)
  -- function num : 0_0 , upvalues : _ENV
  self.actInfo = nil
  local activityController = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local id = activityController:GetIdByActTypeAndActId(typeId, actId)
  if id ~= nil then
    self.actInfo = activityController:GetActivityFrameData(id)
  end
  if self.actInfo == nil then
    error("activity not in ActivityFrame,type and id is " .. tostring(typeId) .. "," .. tostring(actId))
    return 
  end
  ;
  (self.actInfo):SetActivityData(self)
end

ActivityBase.SetActFrameData = function(self, actInfo)
  -- function num : 0_1
  self.actInfo = actInfo
  ;
  (self.actInfo):SetActivityData(self)
end

ActivityBase.UpdateActFrameDataSingleMsg = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV
  if self.actInfo == nil then
    return 
  end
  if self.__isDealResetFinishTime then
    return 
  end
  self.__isDealResetFinishTime = true
  local startTm = msg.startTm
  if startTm or 0 == 0 then
    return 
  end
  local activityController = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  activityController:TryResetActivityFinishTimeByFrameId((self.actInfo):GetActivityFrameId(), startTm)
end

ActivityBase.GetActId = function(self)
  -- function num : 0_3
  return (self.actInfo):GetActId()
end

ActivityBase.GetActivityFrameCat = function(self)
  -- function num : 0_4
  return (self.actInfo):GetActivityFrameCat()
end

ActivityBase.GetActFrameId = function(self)
  -- function num : 0_5
  return (self.actInfo):GetActivityFrameId()
end

ActivityBase.IsActivityOpen = function(self)
  -- function num : 0_6
  if self.actInfo == nil then
    return false
  end
  return (self.actInfo):IsActivityOpen()
end

ActivityBase.IsActivityRunning = function(self)
  -- function num : 0_7
  if self.actInfo == nil then
    return false
  end
  return (self.actInfo):IsInRuningState()
end

ActivityBase.IsActivityPreview = function(self)
  -- function num : 0_8
  if self.actInfo == nil then
    return false
  end
  return (self.actInfo):IsInPreviewState()
end

ActivityBase.GetActivityDestroyTime = function(self)
  -- function num : 0_9
  if self.actInfo == nil then
    return 0
  end
  return (self.actInfo):GetActivityDestroyTime()
end

ActivityBase.GetActivityEndTime = function(self)
  -- function num : 0_10
  if self.actInfo == nil then
    return 0
  end
  return (self.actInfo):GetActivityEndTime()
end

ActivityBase.GetActivityBornTime = function(self)
  -- function num : 0_11
  if self.actInfo == nil then
    return 0
  end
  return (self.actInfo):GetActivityBornTime()
end

ActivityBase.GetActivityName = function(self)
  -- function num : 0_12
  if self.actInfo == nil then
    return 0
  end
  return (self.actInfo).name
end

ActivityBase.SetActivityAsReadOnLogin = function(self)
  -- function num : 0_13
  if self.actInfo ~= nil then
    (self.actInfo):SetActivityAsReadOnLogin()
  end
end

ActivityBase.IsActivityReadOnLogin = function(self)
  -- function num : 0_14
  if self.actInfo ~= nil then
    return (self.actInfo):IsActivityReadOnLogin()
  end
  return false
end

ActivityBase.GetActivityReddot = function(self)
  -- function num : 0_15
  if self.actInfo == nil then
    return nil
  end
  return (self.actInfo):GetActivityReddotNode()
end

ActivityBase.GetActivityReddotNum = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local isBlue = false
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    error("can\'t get activity reddot node")
    return false, 0
  end
  local num = actRedDotNode:GetRedDotCount()
  return isBlue, num
end

return ActivityBase

