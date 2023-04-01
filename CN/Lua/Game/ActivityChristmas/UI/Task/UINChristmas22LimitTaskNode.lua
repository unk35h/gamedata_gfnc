-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22LimitTaskNode = class("UINChristmas22LimitTaskNode", UIBaseNode)
local base = UIBaseNode
local UINChristmas22LimitTaskItem = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskItem")
local UINChristmas22LimitTaskEmptyItem = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskEmptyItem")
UINChristmas22LimitTaskNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__OnTaskRefreshCallback = BindCallback(self, self.__OnTaskRefresh)
  self.__OnTaskCompleteCallback = BindCallback(self, self.__OnTaskComplete)
  self:__OnInitChristmasUI()
end

UINChristmas22LimitTaskNode.__OnInitChristmasUI = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINChristmas22LimitTaskItem, UINChristmas22LimitTaskEmptyItem
  self._taskItemPool = (UIItemPool.New)(UINChristmas22LimitTaskItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self._emptyPool = (UIItemPool.New)(UINChristmas22LimitTaskEmptyItem, (self.ui).emptyItem)
  ;
  ((self.ui).emptyItem):SetActive(false)
  self.__RefillChristmas22LimitTaskNode = BindCallback(self, self.RefillChristmas22LimitTaskNode)
  MsgCenter:AddListener(eMsgEventId.ActivityHallowmasExpired, self.__RefillChristmas22LimitTaskNode)
end

UINChristmas22LimitTaskNode.InitChristmas22LimitTaskNode = function(self, hallowmasData)
  -- function num : 0_2 , upvalues : _ENV
  self._hallowmasData = hallowmasData
  self._limitCount = ((self._hallowmasData):GetHallowmasMainCfg()).task_limit
  self._totalRefCount = ((self._hallowmasData):GetHallowmasMainCfg()).daily_task_refresh_max
  self._dailyReleast = ((self._hallowmasData):GetHallowmasMainCfg()).task_daily_releast
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Tip).text = ConfigData:GetTipContent(8720)
end

UINChristmas22LimitTaskNode.RefillChristmas22LimitTaskNode = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._taskItemDic = {}
  local refTimes = self:__GetRefTimes()
  ;
  ((self.ui).tex_RefreshTimes):SetIndex(0, tostring(self._totalRefCount - refTimes), tostring(self._totalRefCount))
  local refActive = not self:__GetActInRuning() or refTimes < self._totalRefCount
  ;
  (self._taskItemPool):HideAll()
  local taskIds = self:__GetTaskIds()
  local taskDatas = {}
  for i,v in ipairs(taskIds) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(v)
    if taskData ~= nil then
      (table.insert)(taskDatas, taskData)
    end
  end
  self:__SortTaskData(taskDatas)
  for i,taskData in ipairs(taskDatas) do
    local item = (self._taskItemPool):GetOne()
    item:InitChristmas22LimitTaskItem(taskData, self.__OnTaskCompleteCallback, self.__OnTaskRefreshCallback)
    item:SetChristmas22LimitTaskRef(refActive)
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._taskItemDic)[taskData.id] = item
  end
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  local curCount = #taskIds
  -- DECOMPILER ERROR at PC91: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskNum).text = tostring(curCount) .. "/" .. tostring(self._limitCount)
  ;
  (((self.ui).tex_Limited).gameObject):SetActive(self._limitCount <= curCount)
  ;
  (self._emptyPool):HideAll()
  if self:__GetActInRuning() then
    local nextShowCount = self._limitCount - curCount
    nextShowCount = (math.min)(nextShowCount, self._dailyReleast)
    for i = 1, nextShowCount do
      local item = (self._emptyPool):GetOne()
      ;
      (item.transform):SetAsLastSibling()
    end
  end
  self._timerId = TimerManager:StartTimer(1, self.__OnTimer, self)
  self:__OnTimer()
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINChristmas22LimitTaskNode.__SortTaskData = function(self, taskDatas)
  -- function num : 0_4
end

UINChristmas22LimitTaskNode.RefreshChristmas22LimitTaskChange = function(self, taskData)
  -- function num : 0_5
  local item = (self._taskItemDic)[taskData.id]
  if item ~= nil then
    item:RefreshChristmas22LimitTaskItem()
  end
end

UINChristmas22LimitTaskNode.__OnTaskRefresh = function(self, taskItem, taskData)
  -- function num : 0_6 , upvalues : _ENV
  local refTimes = self:__GetRefTimes()
  if self._totalRefCount <= refTimes then
    return 
  end
  if taskData:CheckComplete() then
    return 
  end
  self:__ReqRefresh(taskData.id, function(newTaskId)
    -- function num : 0_6_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self:RefillChristmas22LimitTaskNode()
  end
)
end

UINChristmas22LimitTaskNode.__OnTaskComplete = function(self, taskData)
  -- function num : 0_7 , upvalues : _ENV
  self:__ReqCommotTask(taskData.id, function()
    -- function num : 0_7_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22LimitTaskNode()
    end
  end
)
end

UINChristmas22LimitTaskNode.__OnTimer = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local diffTime = self:__GetExpireTimes() - PlayerDataCenter.timestamp
  diffTime = (math.max)(diffTime, 0)
  local str = TimeUtil:TimestampToTime(diffTime)
  for i,v in ipairs((self._emptyPool).listItem) do
    v:SetTaskNextShowTex(str)
  end
end

UINChristmas22LimitTaskNode.OnHide = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  ;
  (base.OnHide)(self)
end

UINChristmas22LimitTaskNode.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  self:__OnRemoveChristmasUI()
  ;
  (base.OnDelete)(self)
end

UINChristmas22LimitTaskNode.__OnRemoveChristmasUI = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivityHallowmasExpired, self.__RefillChristmas22LimitTaskNode)
end

UINChristmas22LimitTaskNode.__GetRefTimes = function(self)
  -- function num : 0_12
  return (self._hallowmasData):GetHallowmasTaskRefreshTimes()
end

UINChristmas22LimitTaskNode.__GetActInRuning = function(self)
  -- function num : 0_13
  return (self._hallowmasData):IsActivityRunning()
end

UINChristmas22LimitTaskNode.__GetTaskIds = function(self)
  -- function num : 0_14
  return (self._hallowmasData):GetHallowmasDailyTaskIds()
end

UINChristmas22LimitTaskNode.__GetExpireTimes = function(self)
  -- function num : 0_15
  return (self._hallowmasData):GetHallowmasExpiredTm()
end

UINChristmas22LimitTaskNode.__ReqRefresh = function(self, taskId, callback)
  -- function num : 0_16
  (self._hallowmasData):ReqHallowmasRefreshTask(taskId, callback)
end

UINChristmas22LimitTaskNode.__ReqCommotTask = function(self, taskId, callback)
  -- function num : 0_17
  (self._hallowmasData):ReqHallowmasCommitTask(taskId, callback)
end

return UINChristmas22LimitTaskNode

