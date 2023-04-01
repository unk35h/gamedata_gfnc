-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySpring.UI.Task.UINSpring23LimitTaskNode")
local UINWinter23DailyTask = class("UINWinter23DailyTask", base)
local UINSpring23LimitTaskItem = require("Game.ActivitySpring.UI.Task.UINSpring23LimitTaskItem")
local UINChristmas22LimitTaskEmptyItem = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskEmptyItem")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
UINWinter23DailyTask.__OnInitChristmasUI = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23LimitTaskItem, UINChristmas22LimitTaskEmptyItem
  self._taskItemPool = (UIItemPool.New)(UINSpring23LimitTaskItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self._emptyPool = (UIItemPool.New)(UINChristmas22LimitTaskEmptyItem, (self.ui).emptyItem)
  ;
  ((self.ui).emptyItem):SetActive(false)
  self.__HideTaskRefreshWhenActEndCallback = BindCallback(self, self.__HideTaskRefreshWhenActEnd)
  MsgCenter:AddListener(eMsgEventId.SectorActivityRunEnd, self.__HideTaskRefreshWhenActEndCallback)
end

UINWinter23DailyTask.BindWinter23DailyTaskOperFunc = function(self, func)
  -- function num : 0_1
  self._operFunc = func
end

UINWinter23DailyTask.InitWinter23LimitTaskNode = function(self, actDailyTaskData, frameData)
  -- function num : 0_2 , upvalues : _ENV
  self._actDailyTaskData = actDailyTaskData
  local cfg = (self._actDailyTaskData):GetActDailyTaskCfg()
  self._limitCount = cfg.task_limit
  self._dailyReleast = cfg.task_daily_release
  self._totalRefCount = cfg.daily_task_refresh_max
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Tip).text = ConfigData:GetTipContent(8720)
  self._frameData = frameData
end

UINWinter23DailyTask.__GetRefTimes = function(self)
  -- function num : 0_3
  return (self._actDailyTaskData):GetActDailyRefTimes()
end

UINWinter23DailyTask.__GetTaskIds = function(self)
  -- function num : 0_4
  return (self._actDailyTaskData):GetActDailyTaskIds()
end

UINWinter23DailyTask.__GetExpireTimes = function(self)
  -- function num : 0_5
  return (self._actDailyTaskData):GetActDailyExpireTime()
end

UINWinter23DailyTask.__ReqRefresh = function(self, taskId, callback)
  -- function num : 0_6 , upvalues : cs_MessageCommon, _ENV
  local remain = self._totalRefCount - (self._actDailyTaskData):GetActDailyRefTimes()
  ;
  (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(7129, remain, self._totalRefCount), function()
    -- function num : 0_6_0 , upvalues : self, taskId, callback
    (self._actDailyTaskData):ReqActDailyTaskRef(taskId, function()
      -- function num : 0_6_0_0 , upvalues : callback, self
      if callback ~= nil then
        callback()
      end
      if self._operFunc ~= nil then
        (self._operFunc)()
      end
    end
)
  end
, nil)
end

UINWinter23DailyTask.__GetActInRuning = function(self)
  -- function num : 0_7
  if self._frameData ~= nil then
    return (self._frameData):IsInRuningState()
  end
  return false
end

UINWinter23DailyTask.__ReqCommotTask = function(self, taskId, callback)
  -- function num : 0_8 , upvalues : _ENV, JumpManager
  local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
  if taskData == nil then
    return 
  end
  do
    if not taskData:CheckComplete() then
      local flag, jumpId, jumpArgs = taskData:GetTaskJumpArg()
      if flag then
        JumpManager:Jump(jumpId, nil, nil, jumpArgs)
      end
      return 
    end
    ;
    (self._actDailyTaskData):ReqActDailyTaskCommit(taskId, function()
    -- function num : 0_8_0 , upvalues : callback, self
    if callback ~= nil then
      callback()
    end
    if self._operFunc ~= nil then
      (self._operFunc)()
    end
  end
)
  end
end

UINWinter23DailyTask.__OnRemoveChristmasUI = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.SectorActivityRunEnd, self.__HideTaskRefreshWhenActEndCallback)
end

return UINWinter23DailyTask

