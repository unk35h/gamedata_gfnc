-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityTaskController = class("ActivityTaskController", ControllerBase)
local base = ControllerBase
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
ActivityTaskController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._idDic = {}
  self._taskIdMapping = {}
  self.__TaskUpdateCallback = BindCallback(self, self.__TaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  self.__TaskCompletedCallback = BindCallback(self, self.__TaskCompleted)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__TaskCompletedCallback)
end

ActivityTaskController.AddActivityTaskList = function(self, activityQuests)
  -- function num : 0_1 , upvalues : _ENV
  for i,activityQuest in ipairs(activityQuests) do
    self:AddActivityTask(activityQuest)
  end
end

ActivityTaskController.AddActivityTask = function(self, activityQuest)
  -- function num : 0_2 , upvalues : _ENV, ActivityFrameEnum
  if (self._idDic)[activityQuest.actId] ~= nil then
    return 
  end
  local id = activityQuest.actId
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._idDic)[id] = activityQuest
  local taskIds = {}
  ;
  (table.insertto)(taskIds, activityQuest.onceQuests)
  ;
  (table.insertto)(taskIds, (activityQuest.refreshQuests).ids)
  local reddotCount = 0
  for i,taskId in ipairs(taskIds) do
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R10 in 'UnsetPending'

    if (self._taskIdMapping)[taskId] == nil then
      (self._taskIdMapping)[taskId] = {}
    end
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self._taskIdMapping)[taskId])[id] = true
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
    if taskData ~= nil and taskData:CheckComplete() then
      reddotCount = reddotCount + 1
    end
  end
  local activivityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actData = activivityCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Task, id)
  do
    if actData ~= nil then
      local reddot = actData:GetActivityReddotNode()
      if reddot ~= nil then
        reddot:SetRedDotCount(reddotCount)
      end
    end
    if activityQuest.startTm or 0 > 0 then
      activivityCtrl:TryResetActivityFinishTimeByType((ActivityFrameEnum.eActivityType).Task, id, activityQuest.startTm)
    end
  end
end

ActivityTaskController.UpadteTaskActivity = function(self, activityQuest)
  -- function num : 0_3
  if (self._idDic)[activityQuest.actId] == nil then
    return 
  end
  local data = (self._idDic)[activityQuest.actId]
  data.onceQuests = activityQuest.onceQuests
  data.refreshQuests = activityQuest.refreshQuests
end

ActivityTaskController.RemoveActivityTask = function(self, id)
  -- function num : 0_4 , upvalues : _ENV
  if (self._idDic)[id] == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._idDic)[id] = nil
  for i,idDic in pairs(self._taskIdMapping) do
    idDic[id] = nil
  end
end

ActivityTaskController.__TaskUpdate = function(self, taskData)
  -- function num : 0_5 , upvalues : _ENV, ActivityFrameEnum
  if not taskData:CheckComplete() then
    return 
  end
  local taskId = (taskData.stcData).id
  local idDic = (self._taskIdMapping)[taskId]
  if idDic == nil then
    return 
  end
  local activivityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  for id,_ in pairs(idDic) do
    local actData = activivityCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Task, id)
    if actData ~= nil then
      local reddot = actData:GetActivityReddotNode()
      if reddot ~= nil then
        local count = reddot:GetRedDotCount()
        count = count + 1
        reddot:SetRedDotCount(count)
      end
    end
  end
end

ActivityTaskController.__TaskCompleted = function(self, taskStcData)
  -- function num : 0_6 , upvalues : _ENV, ActivityFrameEnum
  local taskId = taskStcData.id
  local idDic = (self._taskIdMapping)[taskId]
  if idDic == nil then
    return 
  end
  local activivityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  for id,_ in pairs(idDic) do
    local actData = activivityCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Task, id)
    if actData ~= nil then
      local reddot = actData:GetActivityReddotNode()
      if reddot ~= nil then
        local count = reddot:GetRedDotCount()
        count = count - 1
        reddot:SetRedDotCount(count)
      end
    end
  end
end

ActivityTaskController.HasActivityTask = function(self)
  -- function num : 0_7 , upvalues : _ENV
  do return (table.count)(self._idDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityTaskController.SendCommitActivityTask = function(self, actId, taskData, callback)
  -- function num : 0_8 , upvalues : _ENV, ActivityFrameEnum
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameId = actCtrl:GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).Task, actId)
  if actFrameId or 0 > 0 then
    activityFrameNet:CS_Activity_Quest_Commit(actFrameId, taskData.id, function()
    -- function num : 0_8_0 , upvalues : self, taskData, callback
    self:__TaskCompleted(taskData.stcData)
    callback()
  end
)
  end
end

ActivityTaskController.GetAcitvityTaskData = function(self, id)
  -- function num : 0_9
  return (self._idDic)[id]
end

ActivityTaskController.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__TaskCompletedCallback)
end

return ActivityTaskController

