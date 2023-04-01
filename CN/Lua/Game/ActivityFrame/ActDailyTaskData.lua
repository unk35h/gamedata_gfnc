-- params : ...
-- function num : 0 , upvalues : _ENV
local ActDailyTaskData = class("ActDailyTaskData")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
ActDailyTaskData.InitActDailyTask = function(self, frameId)
  -- function num : 0_0 , upvalues : _ENV
  self._cfg = (ConfigData.activity_general_daily_task)[frameId]
  self._taskIds = {}
  self._timepassCtr = ControllerManager:GetController(ControllerTypeId.TimePass, true)
end

ActDailyTaskData.BindActDailyTaskCommitFunc = function(self, func)
  -- function num : 0_1
  self._commitFunc = func
end

ActDailyTaskData.BindActDailyTaskChangeFunc = function(self, func)
  -- function num : 0_2
  self._changeFunc = func
end

ActDailyTaskData.BindActDailyTaskExpireFunc = function(self, func)
  -- function num : 0_3
  self._expireFunc = func
end

ActDailyTaskData.SetActDailyTaskIds = function(self, taskIds)
  -- function num : 0_4
  if not taskIds then
    self._taskIds = {}
  end
end

ActDailyTaskData.SetActDailyExpireTime = function(self, time)
  -- function num : 0_5
  self._expireTime = time
end

ActDailyTaskData.RegisterActDailyRefresh = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = frameCtrl:GetActivityFrameData((self._cfg).id)
  if frameData == nil or not frameData:IsInRuningState() then
    return 
  end
  local nextTime = self:GetActDailyExpireTime()
  if frameData:GetActivityEndTime() <= nextTime then
    return 
  end
  if self.__ExpireDealCallback == nil then
    self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
  end
  frameCtrl:AddActivityDataUpdateTimeListen((self._cfg).id, nextTime, self.__ExpireDealCallback)
end

ActDailyTaskData.__ExpireDeal = function(self)
  -- function num : 0_7 , upvalues : _ENV
  TimerManager:StartTimer(1, function()
    -- function num : 0_7_0 , upvalues : _ENV, self
    local net = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
    net:CS_ACTIVITY_RefreshQuestDaily((self._cfg).id, function(args)
      -- function num : 0_7_0_0 , upvalues : _ENV, self
      if (args == nil or args.Count == 0) and isGameDev then
        error("args.Count == 0")
      end
      local msg = args[0]
      if (msg.taskIds)[1] ~= nil then
        (table.insertto)(self._taskIds, msg.taskIds)
      end
      self._expireTime = msg.nextFreshTime
      self:RegisterActDailyRefresh()
      if self._expireFunc ~= nil then
        (self._expireFunc)()
      end
      MsgCenter:Broadcast(eMsgEventId.ActivityDailyTaskExpired, (self._cfg).id)
    end
)
  end
, self, true)
end

ActDailyTaskData.IsExistDailyCompleteTask = function(self)
  -- function num : 0_8 , upvalues : _ENV
  for i,taskId in ipairs(self._taskIds) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil and taskData:CheckComplete() then
      return true
    end
  end
  return false
end

ActDailyTaskData.IsExitInDailyTask = function(self, taskId)
  -- function num : 0_9 , upvalues : _ENV
  return (table.contain)(self._taskIds, taskId)
end

ActDailyTaskData.ReqActDailyTaskCommit = function(self, taskId, callback)
  -- function num : 0_10 , upvalues : _ENV, CommonRewardData
  if not (table.contain)(self._taskIds, taskId) then
    return 
  end
  local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
  if taskData == nil or not taskData:CheckComplete() then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  network:CS_Activity_Quest_Commit((self._cfg).id, taskId, function()
    -- function num : 0_10_0 , upvalues : taskData, CommonRewardData, _ENV, self, taskId, callback
    local rewards, nums = taskData:GetTaskCfgRewards()
    local CRData = (CommonRewardData.CreateCRDataUseList)(rewards, nums)
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_10_0_0 , upvalues : CRData
      if window == nil then
        return 
      end
      window:AddAndTryShowReward(CRData)
    end
)
    ;
    (table.removebyvalue)(self._taskIds, taskId)
    if self._commitFunc ~= nil then
      (self._commitFunc)()
    end
    if callback ~= nil then
      callback()
    end
  end
)
end

ActDailyTaskData.ReqActDailyTaskRef = function(self, taskId, callback)
  -- function num : 0_11 , upvalues : _ENV
  local times = self:GetActDailyRefTimes()
  if (self._cfg).daily_task_refresh_max <= times then
    return 
  end
  local index = (table.indexof)(self._taskIds, taskId)
  if index then
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData == nil or taskData:CheckComplete() then
      return 
    end
    local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
    network:CS_ACTIVITY_RefreshSingleQuestByUser((self._cfg).id, taskId, function(args)
    -- function num : 0_11_0 , upvalues : _ENV, self, index, callback
    if args == nil or args.Count == 0 then
      if isGameDev then
        error("args.Count == 0")
      end
      return 
    end
    local newTaskId = args[0]
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self._taskIds)[index] = newTaskId
    if self._changeFunc ~= nil then
      (self._changeFunc)()
    end
    if callback ~= nil then
      callback(newTaskId)
    end
  end
)
  end
end

ActDailyTaskData.GetActDailyTaskIds = function(self)
  -- function num : 0_12
  return self._taskIds
end

ActDailyTaskData.GetActDailyTaskCfg = function(self)
  -- function num : 0_13
  return self._cfg
end

ActDailyTaskData.GetActDailyExpireTime = function(self)
  -- function num : 0_14
  if self._expireTime or 0 == 0 then
    return (self._cfg).task_time
  end
  return self._expireTime
end

ActDailyTaskData.GetActDailyRefTimes = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local elemtData = (self._timepassCtr):getCounterElemData(proto_object_CounterModule.CounterModuleActivityQuestUserRefreshTimes, (self._cfg).id)
  if elemtData == nil or elemtData.nextExpiredTm < self._expireTime then
    return 0
  end
  return elemtData.times
end

return ActDailyTaskData

