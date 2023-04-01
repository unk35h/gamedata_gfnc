-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIActivityLimitTask = class("UIActivityLimitTask", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local UINActivityStarUpTask = require("Game.ActivityStarUp.UI.UINActivityStarUpTask")
local cs_Resloader = CS.ResLoader
UIActivityLimitTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_Resloader, _ENV
  self._resloader = (cs_Resloader.Create)()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.taskItemDic = {}
end

UIActivityLimitTask.InitActivityLimitTask = function(self, actId)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  local actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = actFrameCtr:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).ActvtLimitTask, actId)
  local actLimitTaskCtrl = ControllerManager:GetController(ControllerTypeId.ActivityTaskLimit)
  if actLimitTaskCtrl == nil then
    error("No actLimitTaskCtrl")
    return 
  end
  local actLimiTaskData = actLimitTaskCtrl:GetCurActLimitTaskData()
  if actLimiTaskData:GetActLimitTaskFrameData() ~= activityFrameData then
    error("actLimiTaskData:GetActLimitTaskFrameData() ~= activityFrameData")
    return 
  end
  self._actLimiTaskData = actLimiTaskData
  self._activityFrameData = activityFrameData
  local actTaskLimitCfg = actLimiTaskData.actTaskLimitCfg
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(activityFrameData.name)
  local endTs = activityFrameData:GetActivityEndTime()
  local date = TimeUtil:TimestampToDate(endTs)
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_EndTime).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
  local remainTs = endTs - PlayerDataCenter.timestamp
  local remainDay = (math.ceil)(remainTs / 60 / 60 / 24)
  ;
  ((self.ui).tex_LastTime):SetIndex(0, tostring(remainDay))
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(actTaskLimitCfg.description)
  local bgPath = PathConsts:GetActLimitTaskPic(actTaskLimitCfg.bg_path)
  -- DECOMPILER ERROR at PC89: Confused about usage of register: R12 in 'UnsetPending'

  ;
  ((self.ui).img_bg).enabled = false
  ;
  (self._resloader):LoadABAssetAsync(bgPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_bg).texture = texture
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_bg).enabled = true
  end
)
  local heroPath = PathConsts:GetActLimitTaskPic(actTaskLimitCfg.img_hero_path)
  -- DECOMPILER ERROR at PC101: Confused about usage of register: R13 in 'UnsetPending'

  ;
  ((self.ui).img_Hero).enabled = false
  ;
  (self._resloader):LoadABAssetAsync(heroPath, function(texture)
    -- function num : 0_1_1 , upvalues : _ENV, self
    if IsNull(texture) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Hero).texture = texture
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Hero).enabled = true
  end
)
  self:_InitTaskData()
end

UIActivityLimitTask._InitTaskData = function(self)
  -- function num : 0_2
  self._taskDataList = (self._actLimiTaskData):GetActLimitTaskDataList()
  self:_SortTaskData()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).totalCount = #self._taskDataList
  ;
  ((self.ui).scrollRect):RefillCells()
  self:_UpdHeadUI()
end

UIActivityLimitTask._SortTaskData = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (table.sort)(self._taskDataList, function(a, b)
    -- function num : 0_3_0
    if a.state ~= b.state then
      if a:IsPickedTaskReward() then
        return false
      else
        if b:IsPickedTaskReward() then
          return true
        end
      end
    end
    local aComplect = a:CheckComplete()
    local bComplect = b:CheckComplete()
    if aComplect ~= bComplect then
      return aComplect
    end
    if (a.stcData).order >= (b.stcData).order then
      do return (a.stcData).order == (b.stcData).order end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
end

UIActivityLimitTask.__OnNewItem = function(self, go)
  -- function num : 0_4 , upvalues : UINActivityStarUpTask
  local item = (UINActivityStarUpTask.New)()
  item:Init(go)
  item:SetActLimitTaskShowCommonReward()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.taskItemDic)[go] = item
end

UIActivityLimitTask.__OnChangeItem = function(self, go, index)
  -- function num : 0_5 , upvalues : _ENV
  local item = (self.taskItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local taskData = (self._taskDataList)[index + 1]
  item:InitItem(taskData)
  local isNew = (self._actLimiTaskData):IsActLimitTaskShowNew(taskData)
  item:UpdActLimitTaskIsNew(isNew)
end

UIActivityLimitTask.OnUIActLimitTaskUpdate = function(self, taskData, isNewTask)
  -- function num : 0_6 , upvalues : _ENV
  if not (self._actLimiTaskData):IsActLimitTask((taskData.stcData).type) then
    return 
  end
  if isNewTask then
    (table.insert)(self._taskDataList, taskData)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).scrollRect).totalCount = #self._taskDataList
  end
  self:_SortTaskData()
  if self._updTimer == nil then
    self._updTimer = TimerManager:StartTimer(1, self._UpdScrollRect, self, true, true)
  end
end

UIActivityLimitTask.OnUIActLimitTaskRemove = function(self, taskId)
  -- function num : 0_7 , upvalues : _ENV
  for k,taskData in ipairs(self._taskDataList) do
    if taskData.id == taskId then
      (table.remove)(self._taskDataList, k)
      break
    end
  end
  do
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).scrollRect).totalCount = #self._taskDataList
    if self._updTimer == nil then
      self._updTimer = TimerManager:StartTimer(1, self._UpdScrollRect, self, true, true)
    end
  end
end

UIActivityLimitTask._UpdScrollRect = function(self)
  -- function num : 0_8
  self:_UpdHeadUI()
  ;
  ((self.ui).scrollRect):RefreshCells()
  self._updTimer = nil
end

UIActivityLimitTask._UpdHeadUI = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local compolectCount = 0
  local hasNew = false
  local newTaskDic = nil
  for k,taskData in ipairs(self._taskDataList) do
    if (self._actLimiTaskData):IsActLimitTaskShowNew(taskData) then
      hasNew = true
      if not newTaskDic then
        newTaskDic = {}
      end
      newTaskDic[taskData.id] = taskData
    end
    if taskData:IsPickedTaskReward() then
      compolectCount = compolectCount + 1
    end
  end
  self:_UpdNewTaskRead()
  self._lastNewTaskDic = newTaskDic
  ;
  ((self.ui).obj_New):SetActive(hasNew)
  ;
  ((self.ui).obj_Head):SetActive(not hasNew)
  ;
  ((self.ui).tex_TaskNum):SetIndex(0, tostring(compolectCount), tostring(#self._taskDataList))
end

UIActivityLimitTask._UpdNewTaskRead = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self._lastNewTaskDic ~= nil then
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityTaskLimit)
    if ctrl ~= nil then
      ctrl:UpdActLimitTaskRedDot()
    end
  end
end

UIActivityLimitTask.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  TimerManager:StopTimer(self._updTimer)
  if self._lastNewTaskDic ~= nil then
    for k,taskData in pairs(self._lastNewTaskDic) do
      local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      userData:SetActLimitNewTaskReddot(taskData.id)
    end
  end
  do
    self:_UpdNewTaskRead()
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    ;
    (base.OnDelete)(self)
  end
end

return UIActivityLimitTask

