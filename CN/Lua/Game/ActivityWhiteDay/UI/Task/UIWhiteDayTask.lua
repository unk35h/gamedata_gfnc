-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayTask = class("UIWhiteDayTask", UIBaseWindow)
local base = UIBaseWindow
local ActivityWhiteDayEnum = require("Game.ActivityWhiteDay.ActivityWhiteDayEnum")
local UINWhiteDayTaskItem = require("Game.ActivityWhiteDay.UI.Task.UINWhiteDayTaskItem")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
UIWhiteDayTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWhiteDayTaskItem
  self.__IsEndLess = true
  self.taskItemPool = (UIItemPool.New)(UINWhiteDayTaskItem, (self.ui).obj_taskItem)
  ;
  ((self.ui).obj_taskItem):SetActive(false)
  self.__onCompleteTask = BindCallback(self, self.__OnCompleteTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, nil, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, nil, UIUtil.OnClickBack)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_EndlessTask, self, self.__OnEndlessTaskTogValueChange)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Task, self, self.__OnTaskTogValueChange)
end

UIWhiteDayTask.InitWDTask = function(self, AWDCtrl, AWDData)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  self.AWDData = AWDData
  self.__IsEndLess = true
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tog_Task).isOn = true
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tog_EndlessTask).isOn = true
  if self.taskTimerId ~= nil then
    TimerManager:StopTimer(self.taskTimerId)
    self.taskTimerId = nil
  end
  self.taskTimerId = TimerManager:StartTimer(1, self.RefreshWDTaskRefreshTime, self, false, nil, true)
  self:__InitWDTaskReddot()
  local cfg = (self.AWDData):GetWDCfg()
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name_endlessTask).text = (LanguageUtil.GetLocaleText)(cfg.endless_task_title)
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name_task).text = (LanguageUtil.GetLocaleText)(cfg.task_title)
end

UIWhiteDayTask.RefreshWDTaskList = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).obj_time):SetActive(self.__IsEndLess)
  self:RefreshWDTaskRefreshTime()
  local taskList, taskId2IndexDic = nil, nil
  if self.__IsEndLess then
    taskList = {}
    ;
    (table.insertto)(taskList, (self.AWDData):GetWDEndlessTaskList())
    ;
    (table.insertto)(taskList, (self.AWDData):GetWDEndlessTaskFinishedList())
    taskId2IndexDic = {}
    for index,taskId in ipairs(taskList) do
      taskId2IndexDic[taskId] = index
    end
  else
    do
      taskList = (self.AWDData):GetWDTaskList()
      ;
      (table.sort)(taskList, function(taskIdA, taskIdB)
    -- function num : 0_2_0 , upvalues : _ENV, self, taskId2IndexDic
    local stateA, stateB = nil, nil
    local taskDataA = ((PlayerDataCenter.allTaskData).taskDatas)[taskIdA]
    local taskDataB = ((PlayerDataCenter.allTaskData).taskDatas)[taskIdB]
    if taskDataA ~= nil then
      if taskDataA:CheckComplete() then
        stateA = 1
      else
        stateA = 2
      end
    else
      stateA = 3
    end
    if taskDataB ~= nil then
      if taskDataB:CheckComplete() then
        stateB = 1
      else
        stateB = 2
      end
    else
      stateB = 3
    end
    if self.__IsEndLess then
      local isMultA = (self.AWDData):GetWDIsEndlessTaskMultReward(taskId2IndexDic[taskIdA])
      if isMultA then
        stateA = stateA - 0.5
      end
      local isMultB = (self.AWDData):GetWDIsEndlessTaskMultReward(taskId2IndexDic[taskIdB])
      if isMultB then
        stateB = stateB - 0.5
      end
    end
    do
      if taskIdA >= taskIdB then
        do return stateA ~= stateB end
        do return stateA < stateB end
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
)
      ;
      (self.taskItemPool):HideAll()
      for index,taskId in ipairs(taskList) do
        if taskId ~= 0 then
          local isMult, multText, multRate = nil, nil, nil
          if self.__IsEndLess then
            isMult = (self.AWDData):GetWDIsEndlessTaskMultReward(taskId2IndexDic[taskId])
          end
          local taskItem = (self.taskItemPool):GetOne()
          taskItem:InitWDTaskItem(self.AWDCtrl, taskId, isMult, multText, multRate, self.__IsEndLess, self.__onCompleteTask)
        end
      end
    end
  end
end

UIWhiteDayTask.__OnTaskTogValueChange = function(self, bool)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if bool then
    ((self.ui).img_Buttom_Task).color = (self.ui).color_select
    self.__IsEndLess = false
    self:RefreshWDTaskList()
  else
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Buttom_Task).color = (self.ui).color_notSelect
  end
end

UIWhiteDayTask.__OnEndlessTaskTogValueChange = function(self, bool)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if bool then
    ((self.ui).img_Buttom_EndlessTask).color = (self.ui).color_select
    self.__IsEndLess = true
    self:RefreshWDTaskList()
  else
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Buttom_EndlessTask).color = (self.ui).color_notSelect
  end
end

UIWhiteDayTask.RefreshWDTaskRefreshTime = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if not self.__IsEndLess then
    return 
  end
  local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleValentineEndlessQuestRefreshTime, (self.AWDData):GetActId())
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  if counterElem ~= nil and PlayerDataCenter.timestamp < counterElem.nextExpiredTm then
    ((self.ui).tex_Time).text = TimeUtil:TimestampToTime(counterElem.nextExpiredTm - PlayerDataCenter.timestamp)
    return 
  end
end

UIWhiteDayTask.__OnCompleteTask = function(self, taskItem)
  -- function num : 0_6 , upvalues : _ENV, CommonRewardData
  local isMult = taskItem.isMult
  local multRate = taskItem.multRate
  local rewardNums = (taskItem.taskCfg).rewardNums
  local rewardIds = (taskItem.taskCfg).rewardIds
  local showReward = function()
    -- function num : 0_6_0 , upvalues : _ENV, isMult, rewardNums, multRate, CommonRewardData, rewardIds, self
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_6_0_0 , upvalues : isMult, _ENV, rewardNums, multRate, CommonRewardData, rewardIds
      if window == nil then
        return 
      end
      local nums = nil
      if isMult then
        nums = {}
        for index,value in ipairs(rewardNums) do
          nums[index] = (math.floor)(value * (multRate / 100 + 1))
        end
      else
        do
          nums = rewardNums
          local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIds, nums)
          window:AddAndTryShowReward(CRData)
        end
      end
    end
)
    self:RefreshWDTaskList()
  end

  -- DECOMPILER ERROR at PC18: Unhandled construct in 'MakeBoolean' P1

  if not taskItem.isEndless and taskItem.taskData ~= nil then
    (self.AWDCtrl):WDTaskCommit(self.AWDData, taskItem.taskData, showReward)
  end
  ;
  (self.AWDCtrl):WDEndlessTaskCommit(self.AWDData, taskItem.taskId, showReward)
end

UIWhiteDayTask.__InitWDTaskReddot = function(self)
  -- function num : 0_7 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, commonNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task, (ActivityWhiteDayEnum.redDotType).commonTask)
  if isOk then
    if self.__refresnTaskReddot == nil then
      self.__refresnTaskReddot = function(node)
    -- function num : 0_7_0 , upvalues : self
    ((self.ui).obj_RedDot_Task):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(commonNode.nodePath, self.__refresnTaskReddot)
    ;
    (self.__refresnTaskReddot)(commonNode)
  end
  local isOk, endlessNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task, (ActivityWhiteDayEnum.redDotType).endlesstask)
  if isOk then
    if self.__refresnEndlessTaskReddot == nil then
      self.__refresnEndlessTaskReddot = function(node)
    -- function num : 0_7_1 , upvalues : self
    ((self.ui).obj_RedDot_EndlessTask):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(endlessNode.nodePath, self.__refresnEndlessTaskReddot)
    ;
    (self.__refresnEndlessTaskReddot)(endlessNode)
  end
end

UIWhiteDayTask.__RemoveWDTaskReddot = function(self)
  -- function num : 0_8 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, commonnode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task, (ActivityWhiteDayEnum.redDotType).commonTask)
  if isOk then
    RedDotController:RemoveListener(commonnode.nodePath, self.__refresnTaskReddot)
  end
  local isOk, endlessNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task, (ActivityWhiteDayEnum.redDotType).endlesstask)
  if isOk then
    RedDotController:RemoveListener(endlessNode.nodePath, self.__refresnEndlessTaskReddot)
  end
  self.__refresnTaskReddot = nil
  self.__refresnEndlessTaskReddot = nil
end

UIWhiteDayTask.__OnClickClose = function(self)
  -- function num : 0_9
  self:__RemoveWDTaskReddot()
  self:Delete()
end

UIWhiteDayTask.OnShow = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  (UIUtil.SetTopStatus)(self, self.__OnClickClose, nil, nil, nil, true)
  ;
  (base.OnShow)(self)
end

UIWhiteDayTask.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self.taskTimerId ~= nil then
    TimerManager:StopTimer(self.taskTimerId)
    self.taskTimerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWhiteDayTask

