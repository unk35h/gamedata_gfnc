-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskNode")
local UINSpring23LimitTaskNode = class("UINSpring23LimitTaskNode", base)
local UINSpring23LimitTaskItem = require("Game.ActivitySpring.UI.Task.UINSpring23LimitTaskItem")
local UINChristmas22LimitTaskEmptyItem = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskEmptyItem")
local JumpManager = require("Game.Jump.JumpManager")
UINSpring23LimitTaskNode.__OnInitChristmasUI = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23LimitTaskItem, UINChristmas22LimitTaskEmptyItem
  self._taskItemPool = (UIItemPool.New)(UINSpring23LimitTaskItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self._emptyPool = (UIItemPool.New)(UINChristmas22LimitTaskEmptyItem, (self.ui).emptyItem)
  ;
  ((self.ui).emptyItem):SetActive(false)
  self.__RefillChristmas22LimitTaskNode = BindCallback(self, self.RefillChristmas22LimitTaskNode)
  MsgCenter:AddListener(eMsgEventId.ActivitySpringTaskExpired, self.__RefillChristmas22LimitTaskNode)
  self.__HideTaskRefreshWhenActEndCallback = BindCallback(self, self.__HideTaskRefreshWhenActEnd)
  MsgCenter:AddListener(eMsgEventId.SectorActivityRunEnd, self.__HideTaskRefreshWhenActEndCallback)
end

UINSpring23LimitTaskNode.InitChristmas22LimitTaskNode = function(self, actSpringData)
  -- function num : 0_1 , upvalues : _ENV
  self._springData = actSpringData
  local cfg = (self._springData):GetSpringMainCfg()
  self._limitCount = cfg.task_limit
  self._dailyReleast = cfg.task_daily_release
  self._totalRefCount = cfg.daily_task_refresh_max
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Tip).text = ConfigData:GetTipContent(8720)
end

UINSpring23LimitTaskNode.RefreshChristmas22LimitTaskChange = function(self, taskData)
  -- function num : 0_2 , upvalues : base
  if taskData:CheckComplete() then
    self:RefillChristmas22LimitTaskNode()
  else
    ;
    (base.RefreshChristmas22LimitTaskChange)(self, taskData)
  end
end

UINSpring23LimitTaskNode.__SortTaskData = function(self, taskDatas)
  -- function num : 0_3 , upvalues : _ENV
  (table.sort)(taskDatas, function(a, b)
    -- function num : 0_3_0
    if a.isPicked ~= b.isPicked then
      return not a.isPicked
    end
    local aComplete = a:CheckComplete()
    if aComplete ~= b:CheckComplete() then
      return aComplete
    end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
end

UINSpring23LimitTaskNode.__GetRefTimes = function(self)
  -- function num : 0_4
  return (self._springData):GetSpringRefTimes()
end

UINSpring23LimitTaskNode.__GetTaskIds = function(self)
  -- function num : 0_5
  return (self._springData):GetSpringRefreshTaskIds()
end

UINSpring23LimitTaskNode.__GetExpireTimes = function(self)
  -- function num : 0_6
  return (self._springData):GetSpringDailyTaskExpireTime()
end

UINSpring23LimitTaskNode.__ReqRefresh = function(self, taskId, callback)
  -- function num : 0_7
  (self._springData):ReqSpringDailyRef(taskId, callback)
end

UINSpring23LimitTaskNode.__GetActInRuning = function(self)
  -- function num : 0_8
  return (self._springData):IsActivityRunning()
end

UINSpring23LimitTaskNode.__ReqCommotTask = function(self, taskId, callback)
  -- function num : 0_9 , upvalues : _ENV, JumpManager
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
    (self._springData):ReqSpringDailyTask(taskId, callback)
  end
end

UINSpring23LimitTaskNode.__OnRemoveChristmasUI = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivitySpringTaskExpired, self.__RefillChristmas22LimitTaskNode)
  MsgCenter:RemoveListener(eMsgEventId.SectorActivityRunEnd, self.__HideTaskRefreshWhenActEndCallback)
end

UINSpring23LimitTaskNode.__HideTaskRefreshWhenActEnd = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if not self:__GetActInRuning() then
    for i,v in ipairs((self._taskItemPool).listItem) do
      v:SetChristmas22LimitTaskRef(false)
    end
    ;
    (self._emptyPool):HideAll()
  end
end

return UINSpring23LimitTaskNode

