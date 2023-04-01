-- params : ...
-- function num : 0 , upvalues : _ENV
local UICarnival22Task = class("UICarnival22Task", UIBaseWindow)
local base = UIBaseWindow
local UINCarnival22TaskItem = require("Game.ActivityCarnival.UI.CarnivalTask.UINCarnival22TaskItem")
local TaskEnum = require("Game.Task.TaskEnum")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
UICarnival22Task.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCarnival22TaskItem
  (UIUtil.SetTopStatus)(self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Intro, self, self.OnClickTaskIntro)
  self._taskItemPool = (UIItemPool.New)(UINCarnival22TaskItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self.__OnTaskUpteEventCallback = BindCallback(self, self.__OnTaskUpteEvent)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__OnTaskUpteEventCallback)
  self.__UpdateTaskAllCallback = BindCallback(self, self.__UpdateTaskAll)
  MsgCenter:AddListener(eMsgEventId.ActivityCarnivalTimePass, self.__UpdateTaskAllCallback)
  self.__OnChangeTaskCallback = BindCallback(self, self.__OnChangeTask)
  self.__OnCompleteTaskCallback = BindCallback(self, self.__OnCompleteTask)
  self.__OnJumpTaskCallback = BindCallback(self, self.__OnJumpTask)
end

UICarnival22Task.InitCarnivalTask = function(self, carnivalData, callback)
  -- function num : 0_1
  self._carnivalData = carnivalData
  self:__UpdateTaskAll()
  self._callback = callback
end

UICarnival22Task.__UpdateTaskAll = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._taskChangeCD = ((self._carnivalData):GetCarnivalMainCfg()).change_frequency
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._timerId = TimerManager:StartTimer(1, self.__UpdateTimer, self)
  self:__UpdateTimer()
  self:__TaskAllRefresh()
end

UICarnival22Task.__TaskAllRefresh = function(self)
  -- function num : 0_3 , upvalues : _ENV, TaskEnum
  local taskDic = (self._carnivalData):GetCarnivalTask()
  local taskDataList = {}
  for taskId,_ in pairs(taskDic) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, true)
    ;
    (table.insert)(taskDataList, taskData)
  end
  ;
  (table.sort)(taskDataList, function(a, b)
    -- function num : 0_3_0 , upvalues : TaskEnum, taskDic
    local isPickedA = a.state == (TaskEnum.eTaskState).Picked
    local isPickedB = b.state == (TaskEnum.eTaskState).Picked
    if isPickedA ~= isPickedB then
      return not isPickedA
    end
    do return taskDic[a.id] < taskDic[b.id] end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
  ;
  (self._taskItemPool):HideAll()
  self._taskItemDic = {}
  for _,taskData in ipairs(taskDataList) do
    local item = (self._taskItemPool):GetOne()
    item:BindCarnivalTaskCallback(self.__OnChangeTaskCallback, self.__OnCompleteTaskCallback, self.__OnJumpTaskCallback)
    item:InitCarnivalTaskItem(self._carnivalData, taskData)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self._taskItemDic)[taskData.id] = item
  end
end

UICarnival22Task.__UpdateTimer = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local nextRefreshTm = (self._carnivalData):GetCarnivalTaskNextTm()
  local diff = nextRefreshTm - PlayerDataCenter.timestamp
  if diff <= 0 then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_ClockTime).text = "00:00:00"
    return 
  end
  local _, h, m, s = TimeUtil:TimestampToTimeInter(diff)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_ClockTime).text = (string.format)("%02d:%02d:%02d", h, m, s)
end

UICarnival22Task.__OnTaskUpteEvent = function(self, taskData)
  -- function num : 0_5
  if (self._taskItemDic)[taskData.id] == nil then
    return 
  end
  if taskData:CheckComplete() then
    self:__TaskAllRefresh()
  else
    self:__RefreshTaskSingle(taskData.id)
  end
end

UICarnival22Task.__RefreshTaskSingle = function(self, taskId)
  -- function num : 0_6
  if self._taskItemDic == nil then
    return 
  end
  local taskItem = (self._taskItemDic)[taskId]
  if taskItem ~= nil then
    taskItem:UpdateCarnivalTaskProcess()
  end
end

UICarnival22Task.__OnChangeTask = function(self, taskId, item)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  if PlayerDataCenter.timestamp - (self._lastChangeTm or 0) < self._taskChangeCD then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7123))
    return 
  end
  if (self._carnivalData):GetCarnivalTaskNextTm() < PlayerDataCenter.timestamp then
    return 
  end
  self._lastChangeTm = PlayerDataCenter.timestamp
  ;
  (self._carnivalData):ReqCarnivalSingleTaskRefresh(taskId, function(newTaskId, oriTaskId)
    -- function num : 0_7_0 , upvalues : _ENV, item, self, taskId
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(newTaskId, true)
    item:ChangeCarnivalTaskItem(taskData)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._taskItemDic)[taskId] = nil
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._taskItemDic)[newTaskId] = item
  end
)
end

UICarnival22Task.__OnCompleteTask = function(self, taskId)
  -- function num : 0_8 , upvalues : _ENV, TaskEnum
  if (self._carnivalData):GetCarnivalTaskNextTm() < PlayerDataCenter.timestamp then
    return 
  end
  local taskItem = (self._taskItemDic)[taskId]
  if taskItem == nil then
    return 
  end
  local taskData = taskItem:GetCarnivalTaskData()
  if taskData.state == (TaskEnum.eTaskState).Picked then
    return 
  end
  if not taskData:CheckComplete() then
    return 
  end
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_Activity_Quest_Commit((self._carnivalData):GetActFrameId(), taskId, function()
    -- function num : 0_8_0 , upvalues : self, taskData, _ENV
    self:__TaskAllRefresh()
    local rewards, nums = taskData:GetTaskCfgRewards()
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = (CommonRewardData.CreateCRDataUseList)(rewards, nums)
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_8_0_0 , upvalues : CRData
      if window == nil then
        return 
      end
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

UICarnival22Task.__OnJumpTask = function(self, taskId)
  -- function num : 0_9 , upvalues : TaskEnum, JumpManager
  local taskItem = (self._taskItemDic)[taskId]
  if taskItem == nil then
    return 
  end
  local taskData = taskItem:GetCarnivalTaskData()
  if taskData.state == (TaskEnum.eTaskState).Picked then
    return 
  end
  if taskData:CheckComplete() then
    return 
  end
  local jumpId = (taskData.stcData).jump_id
  if jumpId == 0 then
    return 
  end
  JumpManager:Jump(jumpId, nil, nil, (taskData.stcData).jumpArgs)
end

UICarnival22Task.OnClickTaskIntro = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local carnivalCfg = (self._carnivalData):GetCarnivalMainCfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22InfoWindow, function(win)
    -- function num : 0_10_0 , upvalues : carnivalCfg
    if win == nil then
      return 
    end
    win:InitCarnivalTaskIntroRule(carnivalCfg.task_rule_id)
  end
)
end

UICarnival22Task.OnClickClose = function(self)
  -- function num : 0_11
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UICarnival22Task.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__OnTaskUpteEventCallback)
  MsgCenter:RemoveListener(eMsgEventId.ActivityCarnivalTimePass, self.__UpdateTaskAllCallback)
end

return UICarnival22Task

