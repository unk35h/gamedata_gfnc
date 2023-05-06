-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChristmasEnvTask = class("UIChristmasEnvTask", UIBaseWindow)
local base = UIBaseWindow
local UINChristmasEnvTaskItem = require("Game.ActivityChristmas.UI.ModeSelect.UINChristmasEnvTaskItem")
UIChristmasEnvTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseTask, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReceiveAll, self, self.OnClickGetAllTask)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__OnGetTaskDataCallback = BindCallback(self, self.__OnGetTaskData)
  self.__OnGotoTaskDataCallback = BindCallback(self, self.__OnGotoTaskData)
  self.__RefillFromExternalCallback = BindCallback(self, self.__RefillFromExternal)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self._itemDic = {}
end

UIChristmasEnvTask.InitChristmasEnvTask = function(self, taskIdlist, allGetCallback, singleGetCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._taskIdDic = {}
  for i,v in ipairs(taskIdlist) do
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R9 in 'UnsetPending'

    (self._taskIdDic)[v] = true
  end
  self._allGetCallback = allGetCallback
  self._singleGetCallback = singleGetCallback
  self:__Refill()
end

UIChristmasEnvTask.__Refill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._taskDataList = {}
  local totalCount = 0
  local finishCount = 0
  local isCanGet = false
  for taskId,_ in pairs(self._taskIdDic) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, true)
    ;
    (table.insert)(self._taskDataList, taskData)
    totalCount = totalCount + 1
    if taskData.isPicked then
      finishCount = finishCount + 1
    end
    if not isCanGet then
      isCanGet = taskData:CheckComplete()
    end
  end
  ;
  (table.sort)(self._taskDataList, function(a, b)
    -- function num : 0_2_0
    if a.isPicked ~= b.isPicked then
      return b.isPicked
    end
    local isComplete = a:CheckComplete()
    if isComplete ~= b:CheckComplete() then
      return isComplete
    end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self._taskItemDic = {}
  ;
  ((self.ui).tex_taskCount):SetIndex(0, tostring(finishCount), tostring(totalCount))
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).totalCount = totalCount
  ;
  ((self.ui).loop_scroll):RefreshCells()
  ;
  (((self.ui).btn_ReceiveAll).gameObject):SetActive(isCanGet)
end

UIChristmasEnvTask.__RefillFromExternal = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if not IsNull(self.transform) then
    self:__Refill()
  end
end

UIChristmasEnvTask.SetChristmasEnvTaskTitle = function(self, titleName)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_SkillName).text = titleName
end

UIChristmasEnvTask.__OnNewItem = function(self, go)
  -- function num : 0_5 , upvalues : UINChristmasEnvTaskItem
  local taskItem = (UINChristmasEnvTaskItem.New)()
  taskItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._itemDic)[go] = taskItem
end

UIChristmasEnvTask.__OnChangeItem = function(self, go, index)
  -- function num : 0_6
  local taskItem = (self._itemDic)[go]
  local taskData = (self._taskDataList)[index + 1]
  taskItem:InitChristmasEnvTaskItem(taskData, self.__OnGetTaskDataCallback, self.__OnGotoTaskDataCallback)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._taskItemDic)[taskData.id] = taskItem
end

UIChristmasEnvTask.__OnGetTaskData = function(self, taskData)
  -- function num : 0_7
  if self._singleGetCallback ~= nil then
    (self._singleGetCallback)(taskData.id, self.__RefillFromExternalCallback)
  end
end

UIChristmasEnvTask.__OnGotoTaskData = function(self, taskData)
  -- function num : 0_8 , upvalues : _ENV
  if (taskData.stcData).jump_id ~= nil and (taskData.stcData).jump_id > 0 then
    JumpManager:Jump((taskData.stcData).jump_id, nil, nil, (taskData.stcData).jumpArgs)
  end
end

UIChristmasEnvTask.OnClickGetAllTask = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local list = {}
  for i,v in ipairs(self._taskDataList) do
    if v:CheckComplete() then
      (table.insert)(list, v.id)
    end
  end
  if self._allGetCallback ~= nil then
    (self._allGetCallback)(list, self.__RefillFromExternalCallback)
  end
end

UIChristmasEnvTask.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_10
  if (self._taskIdDic)[taskData.id] == nil then
    return 
  end
  if taskData:CheckComplete() then
    self:__Refill()
    return 
  end
  local item = (self._taskItemDic)[taskData.id]
  if item ~= nil and item:GetEnvTaskId() == taskData.id then
    item:RefreshChristmasEnvTaskItem()
  end
end

UIChristmasEnvTask.OnClickBack = function(self)
  -- function num : 0_11 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIChristmasEnvTask.OnCloseTask = function(self)
  -- function num : 0_12
  self:Delete()
end

UIChristmasEnvTask.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  ;
  (base.OnDelete)(self)
end

return UIChristmasEnvTask

