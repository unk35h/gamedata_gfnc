-- params : ...
-- function num : 0 , upvalues : _ENV
local base = ControllerBase
local ActivityLimitTaskCtrl = class("ActivityLimitTaskCtrl", base)
local ActivityLimitTaskData = require("Game.ActivityLimitTask.Data.ActivityLimitTaskData")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
ActivityLimitTaskCtrl.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.activity_task_limit)
  self._OnTaskUpdateFunc = BindCallback(self, self._OnTaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self._OnTaskUpdateFunc)
  self._OnTaskRemoveFunc = BindCallback(self, self._OnTaskRemove)
  MsgCenter:AddListener(eMsgEventId.TaskDelete, self._OnTaskRemoveFunc)
end

ActivityLimitTaskCtrl.InitActLimitTaskCtrl = function(self, activityFrameData)
  -- function num : 0_1 , upvalues : _ENV, ActivityLimitTaskData
  if self._actLimitTaskData ~= nil then
    error("Cant support more limit task activity")
    return 
  end
  self._actLimitTaskData = (ActivityLimitTaskData.New)()
  ;
  (self._actLimitTaskData):InitActLimitTaskData(activityFrameData)
  self._taskDic = (self._actLimitTaskData):GetActLimitNotPickedTaskDataDic()
  self:UpdActLimitTaskRedDot()
end

ActivityLimitTaskCtrl.GetCurActLimitTaskData = function(self)
  -- function num : 0_2
  return self._actLimitTaskData
end

ActivityLimitTaskCtrl.CloseActLimitTaskCtrl = function(self, activityFrameData)
  -- function num : 0_3 , upvalues : _ENV
  if (self._actLimitTaskData):GetActLimitTaskFrameData() ~= activityFrameData then
    error("Cant support more limit task activity")
    return 
  end
  if UIManager:GetWindow(UIWindowTypeID.ActivityLimitTask) ~= nil then
    (UIUtil.ReturnHome)()
  end
  self:Delete()
end

ActivityLimitTaskCtrl.UpdActLimitTaskRedDot = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._UpdTimer ~= nil then
    return 
  end
  self._UpdTimer = TimerManager:StartTimer(1, self._RealUpdActLimitTaskRedDot, self, true, true)
end

ActivityLimitTaskCtrl._RealUpdActLimitTaskRedDot = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local actFrameData = (self._actLimitTaskData):GetActLimitTaskFrameData()
  local reddotNode = actFrameData:GetActivityReddotNode()
  local showReddot = false
  for taskId,taskData in pairs(self._taskDic) do
    if taskData:CheckComplete() then
      showReddot = true
      break
    end
    if (self._actLimitTaskData):IsActLimitTaskShowNew(taskData) then
      showReddot = true
      break
    end
  end
  do
    reddotNode:SetRedDotCount(showReddot and 1 or 0)
    self._UpdTimer = nil
  end
end

ActivityLimitTaskCtrl._OnTaskUpdate = function(self, taskData, isNewTask)
  -- function num : 0_6 , upvalues : _ENV
  if not (self._actLimitTaskData):IsActLimitTask((taskData.stcData).type) then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  if isNewTask then
    (self._taskDic)[taskData.id] = taskData
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  if taskData:IsPickedTaskReward() then
    (self._taskDic)[taskData.id] = nil
  end
  self:UpdActLimitTaskRedDot()
  local win = UIManager:GetWindow(UIWindowTypeID.ActivityLimitTask)
  if win ~= nil then
    win:OnUIActLimitTaskUpdate(taskData, isNewTask)
  end
end

ActivityLimitTaskCtrl._OnTaskRemove = function(self, taskId)
  -- function num : 0_7 , upvalues : _ENV
  if (self._taskDic)[taskId] == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._taskDic)[taskId] = nil
  self:UpdActLimitTaskRedDot()
  local win = UIManager:GetWindow(UIWindowTypeID.ActivityLimitTask)
  if win ~= nil then
    win:OnUIActLimitTaskRemove(taskId)
  end
end

ActivityLimitTaskCtrl.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, eDynConfigData
  TimerManager:StopTimer(self._UpdTimer)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self._OnTaskUpdateFunc)
  MsgCenter:RemoveListener(eMsgEventId.TaskDelete, self._OnTaskRemoveFunc)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_task_limit)
end

return ActivityLimitTaskCtrl

