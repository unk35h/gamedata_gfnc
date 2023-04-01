-- params : ...
-- function num : 0 , upvalues : _ENV
local ActTermTaskData = class("ActTermTaskData")
ActTermTaskData.BindTeramTaskCommitFunc = function(self, func)
  -- function num : 0_0
  self._commitFunc = func
end

ActTermTaskData.BindTeramTaskUnlockFunc = function(self, func)
  -- function num : 0_1
  self._unlockFunc = func
end

ActTermTaskData.ReqCommitTermOnceTask = function(self, taskId, callback)
  -- function num : 0_2 , upvalues : _ENV
  local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
  if taskData == nil or not taskData:CheckComplete() then
    return 
  end
  local taskCtrl = ControllerManager:GetController(ControllerTypeId.Task)
  taskCtrl:SendCommitQuestReward(taskData, true, function()
    -- function num : 0_2_0 , upvalues : self, callback
    if self._commitFunc ~= nil then
      (self._commitFunc)()
    end
    if callback ~= nil then
      callback()
    end
  end
)
end

ActTermTaskData.ReqCommitTermAllTask = function(self, term, callback)
  -- function num : 0_3 , upvalues : _ENV
  local taskIds = nil
  if term == nil then
    taskIds = {}
    for i = 1, self:GetTermTaskStageCount() do
      if self:GetTermOpenTime(i) <= PlayerDataCenter.timestamp then
        (table.insertto)(taskIds, self:GetTermTaskIds(i))
      end
    end
  else
    do
      if self:GetTermOpenTime(term) <= PlayerDataCenter.timestamp then
        taskIds = self:GetTermTaskIds(term)
      end
      if taskIds == nil then
        return 
      end
      local taskIdDic = {}
      for _,taskId in ipairs(taskIds) do
        local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
        if taskData ~= nil and taskData:CheckComplete() then
          taskIdDic[taskId] = true
        end
      end
      if (table.count)(taskIdDic) == 0 then
        return 
      end
      local network = NetworkManager:GetNetwork(NetworkTypeID.Task)
      network:CS_QUEST_OneKeyPick(taskIdDic, function()
    -- function num : 0_3_0 , upvalues : self, callback
    if self._commitFunc ~= nil then
      (self._commitFunc)()
    end
    if callback ~= nil then
      callback()
    end
  end
)
    end
  end
end

ActTermTaskData.RegisterActTermRefresh = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = frameCtrl:GetActivityFrameData(self._frameId)
  if frameData == nil or not frameData:IsInRuningState() then
    return 
  end
  local startTerm = self._lockNearTerm or 1
  local nextTime = 0
  for i = startTerm, self:GetTermTaskStageCount() do
    if PlayerDataCenter.timestamp < self:GetTermOpenTime(i) then
      nextTime = self:GetTermOpenTime(i)
      self._lockNearTerm = i
      break
    end
  end
  do
    if frameData:GetActivityEndTime() < nextTime or nextTime < PlayerDataCenter.timestamp then
      return 
    end
    if self.__ExpireDealCallback == nil then
      self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
    end
    frameCtrl:AddActivityDataUpdateTimeListen(self._frameId, nextTime, self.__ExpireDealCallback)
  end
end

ActTermTaskData.__ExpireDeal = function(self)
  -- function num : 0_5 , upvalues : _ENV
  TimerManager:StartTimer(1, function()
    -- function num : 0_5_0 , upvalues : _ENV, self
    local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
    network:CS_ACTIVITY_TermTask(self._frameId, function()
      -- function num : 0_5_0_0 , upvalues : self, _ENV
      if self._unlockFunc ~= nil then
        (self._unlockFunc)()
      end
      MsgCenter:Broadcast(eMsgEventId.ActivityTermTaskExpired, self._frameId)
    end
)
  end
, self, true)
end

ActTermTaskData.IsExistTermCompleteTask = function(self)
  -- function num : 0_6
  for i = 1, self:GetTermTaskStageCount() do
    if self:IsExistTermCompleteTaskInTerm(i) then
      return true
    end
  end
  return false
end

ActTermTaskData.IsExistTermCompleteTaskInTerm = function(self, term)
  -- function num : 0_7 , upvalues : _ENV
  if self:GetTermTaskStageCount() < term then
    return 
  end
  if PlayerDataCenter.timestamp < self:GetTermOpenTime(term) then
    return 
  end
  local taskIds = self:GetTermTaskIds(term)
  for i,taskId in ipairs(taskIds) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil and taskData:CheckComplete() then
      return true
    end
  end
  return false
end

ActTermTaskData.InitTermTask = function(self, frameId)
  -- function num : 0_8
  self._frameId = frameId
end

ActTermTaskData.IsExitInTermTask = function(self, taskId)
  -- function num : 0_9
  return false
end

ActTermTaskData.GetTermTaskStageCount = function(self)
  -- function num : 0_10
  return 0
end

ActTermTaskData.GetTermTaskIds = function(self, term)
  -- function num : 0_11
  return nil
end

ActTermTaskData.GetTermOpenTime = function(self, term)
  -- function num : 0_12
  return 0
end

return ActTermTaskData

