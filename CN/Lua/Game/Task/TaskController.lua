-- params : ...
-- function num : 0 , upvalues : _ENV
local TaskController = class("TaskController", ControllerBase)
local TaskEnum = require("Game.Task.TaskEnum")
local cs_MessageCommon = CS.MessageCommon
local TaskData = require("Game.Task.Data.TaskData")
TaskController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.allTaskData = PlayerDataCenter.allTaskData
  self.network = NetworkManager:GetNetwork(NetworkTypeID.Task)
  self.showingPageType = nil
  self.showingActiveType = nil
  self.isFrist = true
  self.isDailyCompleteToRefresh = false
  self.allDailyTaskList = {}
  self.AllWeeklyTaskList = {}
  self.TaskOverflowAwardDic = {}
  self.allTimeLimitTask = {}
  self.timeLimitTaskendTime = {}
  self.__OnTaskUpdate = BindCallback(self, self.OnTaskUpdate)
  self.__OnTaskDelete = BindCallback(self, self.OnTaskDelete)
  self.__OnTaskCommit = BindCallback(self, self.OnTaskCommit)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__OnTaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskDelete, self.__OnTaskDelete)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__OnTaskCommit)
  self.isDailyTaskUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_DailyTask)
end

TaskController.AddTimeLimitTask = function(self, taskType, taksList, endTime)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  if (self.allTimeLimitTask)[taskType] == nil then
    (self.allTimeLimitTask)[taskType] = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.timeLimitTaskendTime)[taskType] = endTime or 0
  end
  for _,taskId in pairs(taksList) do
    (table.insert)((self.allTimeLimitTask)[taskType], taskId)
  end
end

TaskController.ReomveTimeLimitTask = function(self, taskType, taskList)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if (self.allTimeLimitTask)[taskType] == nil then
    (self.timeLimitTaskendTime)[taskType] = nil
    return 
  end
  for _,taskId in pairs(taskList) do
    (table.removebyvalue)((self.allTimeLimitTask)[taskType], taskId)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R8 in 'UnsetPending'

    if #(self.allTimeLimitTask)[taskType] == 0 then
      (self.allTimeLimitTask)[taskType] = nil
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.timeLimitTaskendTime)[taskType] = nil
      return 
    end
  end
end

TaskController.SetDailyAndWeeklyLock = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.isDailyTaskUnlock = true
  self:PeriodTaskRedDot()
  local win = UIManager:GetWindow(UIWindowTypeID.Task)
  if win == nil then
    return 
  end
  win:RefreshPages()
end

TaskController.RecvPeriodTaskDetail = function(self, msg)
  -- function num : 0_4 , upvalues : _ENV
  if self.isFrist then
    self:RefreshPeriodData(msg)
    self:PeriodTaskRedDot()
    self.isFrist = false
  else
    self:RefreshPeriodData(msg)
    self:PeriodTaskRedDot()
  end
  MsgCenter:Broadcast(eMsgEventId.PeroidUpdate)
  local win = UIManager:GetWindow(UIWindowTypeID.Task)
  if win == nil or self.showingPageType == nil then
    return 
  end
  win:OnSelectPage(self.showingPageType)
end

TaskController.RefreshPeriodData = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, TaskEnum
  self.allDailyTaskList = msg.daily
  self.AllWeeklyTaskList = msg.weekly
  self.WeeklyChallengeTaskList = msg.weeklyChallenge
  local actPeriodTaskId2ActivityDic = {}
  local activivityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityDic = activivityCtrl:GetActivityFrameDataDic()
  for activityFrameId,activityFrameData in pairs(activityDic) do
    if activityFrameData:GetCouldShowActivity() then
      local actGneralCfg = (ConfigData.activity_general)[activityFrameId]
      if actGneralCfg ~= nil and actGneralCfg.period_quest ~= nil then
        for _,taskId in pairs(actGneralCfg.period_quest) do
          if actPeriodTaskId2ActivityDic[taskId] ~= nil then
            error((string.format)("duplicated taskId for act added periodTask. taskId:%s act1:%s act2:%s", tostring(taskId), tostring(actPeriodTaskId2ActivityDic[taskId]), tostring(activityFrameId)))
          end
          actPeriodTaskId2ActivityDic[taskId] = activityFrameId
        end
      end
    end
  end
  self.actPeriodTaskId2ActivityDic = actPeriodTaskId2ActivityDic
  for typeId,activeDatas in pairs(ConfigData.active) do
    local pointId = (activeDatas[1]).activeId
    local currPoint = PlayerDataCenter:GetItemCount(pointId)
    local neetPoint = 0
    local stateType = nil
    for _,stcData in ipairs(activeDatas) do
      local msgDatas = nil
      if typeId == (TaskEnum.eTaskPeriodType).DailyTask then
        msgDatas = msg.dailyRewards
      else
        if typeId == (TaskEnum.eTaskPeriodType).WeeklyTask then
          msgDatas = msg.weeklyRewarsd
        else
          if typeId == (TaskEnum.eTaskPeriodType).WeeklyChallengeTask then
            msgDatas = msg.weeklyChallengeRewards
          else
            error("eTaskPeriodType is nonexistent,typeId is " .. tostring(typeId))
            return 
          end
        end
      end
      local isReceived = msgDatas[stcData.id]
      neetPoint = stcData.activeNum
      if isReceived then
        stateType = (TaskEnum.eTaskState).Picked
      else
        if neetPoint <= currPoint then
          stateType = (TaskEnum.eTaskState).Completed
        else
          stateType = (TaskEnum.eTaskState).InProgress
        end
      end
      if stateType == nil then
        error("Can\'t confirm period task state")
        return 
      end
      local periodData = (((self.allTaskData).taskPeriodDatas)[typeId])[stcData.id]
      if periodData == nil then
        periodData = {}
        periodData.stcData = stcData
        periodData.stateType = stateType
        -- DECOMPILER ERROR at PC138: Confused about usage of register: R22 in 'UnsetPending'

        ;
        (((self.allTaskData).taskPeriodDatas)[typeId])[stcData.id] = periodData
      else
        local lastState = periodData.stateType
        periodData.stateType = stateType
        if stateType == (TaskEnum.eTaskState).Picked and lastState ~= stateType then
          MsgCenter:Broadcast(eMsgEventId.PeroidCommitComplete, periodData)
        end
      end
    end
  end
end

TaskController.PeriodTaskRedDot = function(self)
  -- function num : 0_6 , upvalues : _ENV, TaskEnum
  if not self.isDailyTaskUnlock then
    return 
  end
  for actionTypeId,_ in pairs(ConfigData.active) do
    local datas = self:GetDatas4Peroid(actionTypeId)
    local completeNum = 0
    for key,value in pairs(datas) do
      if value.stateType == (TaskEnum.eTaskState).Completed then
        completeNum = completeNum + 1
      end
    end
    if actionTypeId == (TaskEnum.eTaskPeriodType).WeeklyChallengeTask then
      (PlayerDataCenter.allTaskData):UpdateWeeklyChallengeRedDot()
    else
      local ok, TaskWindowNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Task)
      if ok then
        local TaskType = self:__ActiveType2TaskType(actionTypeId)
        local taskPageNode = TaskWindowNode:GetChild(TaskType)
        if taskPageNode ~= nil then
          local taskPeriodNode = taskPageNode:AddChildWithPath(actionTypeId, RedDotDynPath.TaskPeriodPath)
          taskPeriodNode:SetRedDotCount(completeNum)
        end
      end
    end
  end
end

TaskController.__ActiveType2TaskType = function(self, activeType)
  -- function num : 0_7 , upvalues : _ENV, TaskEnum
  local taskType = nil
  for type,typeId in pairs(TaskEnum.eTaskPeriodType) do
    if activeType == typeId then
      taskType = (TaskEnum.eTaskType)[type]
    end
  end
  return taskType
end

TaskController.CheckExpiredAndUpdate = function(self)
  -- function num : 0_8
  (self.network):SendQuestPeriodDetail()
end

TaskController.ShowTaskUI = function(self, selectPageTypeId, fromType, openCallback)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Task, function(win)
    -- function num : 0_9_0 , upvalues : _ENV, fromType, openCallback, selectPageTypeId
    if win == nil then
      error("can\'t open Task winodw")
      return 
    end
    win:SetFromWhichUI(fromType)
    if openCallback ~= nil then
      openCallback(win)
    end
    win:RefreshPages()
    if selectPageTypeId ~= nil then
      win:SelectPage(selectPageTypeId)
    end
  end
)
end

TaskController.CloseTaskUI = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.Task)
  if win == nil then
    return 
  end
  win:Delete()
  self.showingPageType = nil
  self.showingActiveType = nil
  self.beforTypeId = nil
end

TaskController.GetPageGroupList = function(self)
  -- function num : 0_11 , upvalues : _ENV, TaskEnum
  local groupList = (table.deepCopy)((ConfigData.game_config).taskTabSort)
  for index,group in ipairs(groupList) do
    group.realIndex = index
  end
  local tryRemoveGroupFunc = function(functionUnlock, typeId, group, typeIndex, groupIndex)
    -- function num : 0_11_0 , upvalues : self, _ENV, groupList
    if not functionUnlock or (self.allTimeLimitTask)[typeId] == nil or #(self.allTimeLimitTask)[typeId] == 0 then
      (table.remove)(group, typeIndex)
      if #group == 0 then
        (table.remove)(groupList, groupIndex)
      end
    end
  end

  for groupIndex = #groupList, 1, -1 do
    local group = groupList[groupIndex]
    for typeIndex = #group, 1, -1 do
      local typeId = group[typeIndex]
      if typeId == (TaskEnum.eTaskType).LargeActivityTask then
        local isLargeActivityUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_LargeActivity)
        tryRemoveGroupFunc(isLargeActivityUnlock, typeId, group, typeIndex, groupIndex)
      else
        do
          do
            if typeId == (TaskEnum.eTaskType).HeroActivityTask then
              local isHeroActivityUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroActivity)
              tryRemoveGroupFunc(isHeroActivityUnlock, typeId, group, typeIndex, groupIndex)
            end
            -- DECOMPILER ERROR at PC57: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC57: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC57: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  return groupList
end

TaskController.GetPageName = function(self, index, subIndex)
  -- function num : 0_12 , upvalues : _ENV
  local taskNames = (ConfigData.game_config).taskNames
  if taskNames == nil then
    error("can\'t read taskNames")
    return "", ""
  end
  local name, name_en = nil, nil
  if subIndex == nil then
    local str = (string.split)(ConfigData:GetTipContent((taskNames[index])[1]), "|")
    name = str[1]
    name_en = str[2]
  else
    do
      do
        local str = (string.split)(ConfigData:GetTipContent((taskNames[index])[subIndex]), "|")
        name = str[1]
        name_en = str[2]
        return name, name_en
      end
    end
  end
end

TaskController.GetIndexOfTaskType = function(self, taskTypeId)
  -- function num : 0_13 , upvalues : _ENV
  for index,subTagIds in ipairs(self:GetPageGroupList()) do
    if (table.contain)(subTagIds, taskTypeId) then
      return subTagIds.realIndex
    end
  end
  return nil
end

TaskController.GetTaskTypeName = function(self, taskTypeId)
  -- function num : 0_14
  local index = self:GetIndexOfTaskType(taskTypeId)
  if index == nil then
    return "", ""
  end
  return self:GetPageName(index)
end

TaskController.GetDatas4Task = function(self, typeId)
  -- function num : 0_15 , upvalues : _ENV, TaskData, TaskEnum
  local CreateDataContainFinished = function(taskList, taskDatas)
    -- function num : 0_15_0 , upvalues : _ENV, TaskData
    local newTaskDatas = {}
    for id,value in pairs(taskDatas) do
      newTaskDatas[id] = value
    end
    for _,id in ipairs(taskList) do
      if newTaskDatas[id] == nil then
        local stcData = (ConfigData.task)[id]
        if stcData == nil then
          error("Cant get task cfg, id = " .. tostring(id))
        else
          if stcData.isShow then
            local taskData = (TaskData.CreatePickedTaskData)(stcData)
            taskData.isPicked = true
            newTaskDatas[id] = taskData
          end
        end
      end
    end
    return newTaskDatas
  end

  local taskDatas = nil
  if typeId == (TaskEnum.eTaskType).DailyTask then
    local taskDatas = ((self.allTaskData).normalTaskDatas)[typeId]
    local newTaskDatas = CreateDataContainFinished(self.allDailyTaskList, taskDatas)
    for taskId,taskData in pairs(newTaskDatas) do
      local actFrameId = (self.actPeriodTaskId2ActivityDic ~= nil and (self.actPeriodTaskId2ActivityDic)[taskId])
      if actFrameId ~= nil then
        taskData:SetBindActFramId(actFrameId)
      end
    end
    return newTaskDatas, self:GetDatas4Peroid((TaskEnum.eTaskPeriodType).DailyTask)
  elseif typeId == (TaskEnum.eTaskType).WeeklyTask then
    local taskDatas = ((self.allTaskData).normalTaskDatas)[typeId]
    local newTaskDatas = CreateDataContainFinished(self.AllWeeklyTaskList, taskDatas)
    for taskId,taskData in pairs(newTaskDatas) do
      local actFrameId = (self.actPeriodTaskId2ActivityDic ~= nil and (self.actPeriodTaskId2ActivityDic)[taskId])
      if actFrameId ~= nil then
        taskData:SetBindActFramId(actFrameId)
      end
    end
    return newTaskDatas, self:GetDatas4Peroid((TaskEnum.eTaskPeriodType).WeeklyTask)
  elseif typeId == (TaskEnum.eTaskType).WeeklyChallengeTask then
    local taskDatas = (self.allTaskData).weeklyChallengeDatas
    local newTaskDatas = CreateDataContainFinished(self.WeeklyChallengeTaskList, taskDatas)
    return newTaskDatas, self:GetDatas4Peroid((TaskEnum.eTaskPeriodType).WeeklyChallengeTask)
  elseif (TaskEnum.IsActivityTask)(typeId) then
    local taskDatas = ((self.allTaskData).timeLimitTaskDataDic)[typeId]
    if (self.allTimeLimitTask)[typeId] ~= nil then
      local newTaskDatas = CreateDataContainFinished((self.allTimeLimitTask)[typeId], taskDatas)
      return newTaskDatas
    end
  else
    taskDatas = ((self.allTaskData).normalTaskDatas)[typeId]
  end
  if not taskDatas then
    do return {} end
    -- DECOMPILER ERROR: 12 unprocessed JMP targets
  end
end

TaskController.GetDatas4Peroid = function(self, activeTypeId)
  -- function num : 0_16
  return ((self.allTaskData).taskPeriodDatas)[activeTypeId]
end

TaskController.GetTaskIds = function(self, typeId, ids, perodicDic)
  -- function num : 0_17 , upvalues : _ENV, TaskEnum
  local taskDatas, peroidDatas = self:GetDatas4Task(typeId)
  for k,v in pairs(taskDatas) do
    if v:CheckComplete() then
      ids[k] = true
    end
  end
  if peroidDatas ~= nil then
    perodicDic[self:TaskType2PeriodType(typeId)] = {}
    for taskId,data in pairs(peroidDatas) do
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R11 in 'UnsetPending'

      if data.stateType == (TaskEnum.eTaskState).Completed then
        (perodicDic[self:TaskType2PeriodType(typeId)])[taskId] = true
      end
    end
  end
  do
    return ids, perodicDic
  end
end

TaskController.SelectTask = function(self, typeId)
  -- function num : 0_18 , upvalues : TaskEnum
  self.showingPageType = typeId
  if typeId == (TaskEnum.eTaskType).DailyTask then
    self.showingActiveType = (TaskEnum.eTaskPeriodType).DailyTask
  else
    if typeId == (TaskEnum.eTaskType).WeeklyTask then
      self.showingActiveType = (TaskEnum.eTaskPeriodType).WeeklyTask
    else
      if typeId == (TaskEnum.eTaskType).WeeklyChallengeTask then
        self.showingActiveType = (TaskEnum.eTaskPeriodType).WeeklyChallengeTask
      else
        self.showingActiveType = nil
      end
    end
  end
end

TaskController.IsChangeTaskType = function(self, typeId)
  -- function num : 0_19 , upvalues : TaskEnum
  if typeId == (TaskEnum.eTaskType).DailyTask or typeId == (TaskEnum.eTaskType).WeeklyTask then
    typeId = (TaskEnum.eTaskType).DailyTask
  end
  if self.beforTypeId ~= typeId then
    self.beforTypeId = typeId
    return true
  end
  return false
end

TaskController.IsPeriodTaskType = function(self, typeId)
  -- function num : 0_20 , upvalues : TaskEnum
  do return typeId == (TaskEnum.eTaskType).SideTask end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

TaskController.TaskType2PeriodType = function(self, taskTypeId)
  -- function num : 0_21 , upvalues : TaskEnum
  if taskTypeId == (TaskEnum.eTaskType).DailyTask then
    return (TaskEnum.eTaskPeriodType).DailyTask
  else
    if taskTypeId == (TaskEnum.eTaskType).WeeklyTask then
      return (TaskEnum.eTaskPeriodType).WeeklyTask
    else
      if taskTypeId == (TaskEnum.eTaskType).WeeklyChallengeTask then
        return (TaskEnum.eTaskPeriodType).WeeklyChallengeTask
      end
    end
  end
end

TaskController.CalTaskRewardsOverflow = function(self, stcTask)
  -- function num : 0_22 , upvalues : _ENV
  local itemTransDic = {}
  for i,v in ipairs(stcTask.rewardIds) do
    local itemCfg = (ConfigData.item)[v]
    local num = 0
    if itemCfg.overflow_type == eItemTransType.actMoneyX then
      num = PlayerDataCenter:GetItemOverflowNum(v, (stcTask.rewardNums)[i])
    end
    if num ~= 0 then
      itemTransDic[v] = num
    end
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.TaskOverflowAwardDic)[stcTask.id] = itemTransDic
end

TaskController.SendCommitQuestReward = function(self, taskData, showCommonReward, callbak)
  -- function num : 0_23 , upvalues : _ENV, cs_MessageCommon
  local containAth = false
  for k,itemId in ipairs((taskData.stcData).rewardIds) do
    local itemCfg = (ConfigData.item)[itemId]
    if itemCfg ~= nil and itemCfg.type == eItemType.Arithmetic then
      containAth = true
      break
    end
  end
  do
    if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
      return 
    end
    self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
    self.isDailyCompleteToRefresh = false
    self:CalTaskRewardsOverflow(taskData.stcData)
    ;
    (self.network):SendCommitQuest(taskData, callbak)
    self._showCommonRewardTaskData = not showCommonReward or taskData
  end
end

TaskController.OnTaskCommit = function(self, stcTask)
  -- function num : 0_24 , upvalues : _ENV, TaskEnum
  local taskWindow = UIManager:GetWindow(UIWindowTypeID.Task)
  local isSector = (self.allTaskData):IsSectorType(stcTask.type)
  if isSector == true then
    return 
  end
  local isWeeklyChallenge = (self.allTaskData):IsWeeklyChallengeType(stcTask.type)
  if isWeeklyChallenge then
    (self.network):SendQuestPeriodDetail()
    return 
  end
  if self.showingPageType == stcTask.type and taskWindow ~= nil then
    taskWindow:OnSelectPage(self.showingPageType)
    if stcTask.type == (TaskEnum.eTaskType).DailyTask or stcTask.type == (TaskEnum.eTaskType).WeeklyTask then
      taskWindow:OnDailyWeeklyTaskComplete()
    end
  end
  if stcTask.type ~= (TaskEnum.eTaskType).MainTask and stcTask.type ~= (TaskEnum.eTaskType).SideTask then
    if ((TaskEnum.IsActivityTask)(stcTask.type) and stcTask.type == (TaskEnum.eTaskType).DailyTask) or stcTask.type == (TaskEnum.eTaskType).WeeklyTask then
      self.isDailyCompleteToRefresh = true
      ;
      (self.network):SendQuestPeriodDetail()
      if taskWindow ~= nil then
        return 
      end
    else
      if self._showCommonRewardTaskData == nil or (self._showCommonRewardTaskData).stcData ~= stcTask then
        return 
      end
    end
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_24_0 , upvalues : _ENV, stcTask, self
    if window == nil then
      return 
    end
    local taskStepCfg = (ConfigData.taskStep)[stcTask.id]
    if taskStepCfg ~= nil then
      for stepIndex,stepCfg in ipairs(taskStepCfg) do
        local rewardTips = (string.format)(ConfigData:GetTipContent(360), self:GetTaskTypeName(stcTask.type), (LanguageUtil.GetLocaleText)(stcTask.task_intro), stepCfg.finish_value, stepCfg.finish_value)
        local CommonRewardData = require("Game.CommonUI.CommonRewardData")
        local CRData = (((CommonRewardData.CreateCRDataUseList)(stcTask.rewardIds, stcTask.rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot)):SetCRRewardTips(rewardTips)
        CRData:SetCRItemTransDic((self.TaskOverflowAwardDic)[stcTask.id])
        window:AddAndTryShowReward(CRData)
        do return  end
      end
    end
  end
)
end

TaskController.OnTaskUpdate = function(self, taskData)
  -- function num : 0_25 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.Task)
  if win == nil then
    return 
  end
  local isSector = (self.allTaskData):IsSectorType((taskData.stcData).type)
  if isSector == true then
    return 
  end
  self.isDailyCompleteToRefresh = false
  if self.showingPageType == (taskData.stcData).type then
    win:OnSelectPage(self.showingPageType)
  end
end

TaskController.OnTaskDelete = function(self, id)
  -- function num : 0_26 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.Task)
  local stcTask = (ConfigData.task)[id]
  if win == nil or stcTask == nil then
    return 
  end
  local isSector = (self.allTaskData):IsSectorType(stcTask.type)
  if isSector == true then
    return 
  end
  self.isDailyCompleteToRefresh = false
  if self.showingPageType == stcTask.type then
    win:OnSelectPage(self.showingPageType)
  end
end

TaskController.SendCommitTaskPeriod = function(self, index, showingActiveType)
  -- function num : 0_27 , upvalues : _ENV
  if showingActiveType == nil then
    return 
  end
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  ;
  (self.network):SendQuestPeriodRewardPicked(index, showingActiveType, function()
    -- function num : 0_27_0 , upvalues : self, _ENV, showingActiveType, index
    (self.network):SendQuestPeriodDetail()
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_27_0_0 , upvalues : _ENV, showingActiveType, index, self
      if window == nil then
        return 
      end
      local activeCfg = ((ConfigData.active)[showingActiveType])[index]
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = ((CommonRewardData.CreateCRDataUseList)(activeCfg.rewardIds, activeCfg.rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

TaskController.SendCommitTaskPeriodArray = function(self, indexDic, showingActiveType)
  -- function num : 0_28 , upvalues : _ENV
  if showingActiveType == nil then
    return 
  end
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  local next = function()
    -- function num : 0_28_0 , upvalues : _ENV, self
    (table.remove)(self.__waitPickPreodic, 1)
    if #self.__waitPickPreodic > 0 then
      ((self.__waitPickPreodic)[1])()
    end
  end

  local netFunc = function()
    -- function num : 0_28_1 , upvalues : self, indexDic, showingActiveType, next, _ENV
    (self.network):CS_QUESTPERIOD_RewardOnePicked(indexDic, showingActiveType, function(dataList)
      -- function num : 0_28_1_0 , upvalues : self, next, _ENV
      (self.network):SendQuestPeriodDetail()
      if dataList.Count <= 0 then
        next()
        return 
      end
      local reward = dataList[0]
      if reward ~= nil and (table.count)(reward) > 0 then
        local rewardIds = {}
        do
          local rewardCounts = {}
          for id,count in pairs(reward) do
            (table.insert)(rewardIds, id)
            ;
            (table.insert)(rewardCounts, count)
          end
          UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_28_1_0_0 , upvalues : _ENV, rewardIds, rewardCounts
        if window == nil then
          return 
        end
        local CommonRewardData = require("Game.CommonUI.CommonRewardData")
        local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIds, rewardCounts)
        window:AddAndTryShowReward(CRData)
      end
)
        end
      end
      do
        next()
      end
    end
)
  end

  if self.__waitPickPreodic == nil then
    self.__waitPickPreodic = {}
  end
  ;
  (table.insert)(self.__waitPickPreodic, netFunc)
  if #self.__waitPickPreodic == 1 then
    netFunc()
  end
end

TaskController.IsDailyCompleteToRefresh = function(self)
  -- function num : 0_29
  if self.isDailyCompleteToRefresh then
    return not self.isFrist
  end
end

TaskController.IsCompleteAllDailyTaskOrFinshPeroid = function(self)
  -- function num : 0_30 , upvalues : _ENV, TaskEnum
  local trueComplete = (table.count)(((self.allTaskData).normalTaskDatas)[(TaskEnum.eTaskType).DailyTask]) <= 0
  if trueComplete then
    return true
  end
  local PeriodComplete = true
  local periodDataList = self:GetDatas4Peroid((TaskEnum.eTaskPeriodType).DailyTask)
  for _,data in pairs(periodDataList) do
    if data.stateType ~= (TaskEnum.eTaskState).Picked then
      PeriodComplete = false
      break
    end
  end
  if PeriodComplete then
    return true
  end
  local taskDatas = ((self.allTaskData).normalTaskDatas)[(TaskEnum.eTaskType).DailyTask]
  if taskDatas == nil then
    return true
  end
  for _,taskData in pairs(taskDatas) do
    local unlock = true
    if (taskData.stcData).open_condition ~= nil and (taskData.stcData).open_condition > 0 then
      unlock = FunctionUnlockMgr:ValidateUnlock((taskData.stcData).open_condition)
    end
    if unlock and not taskData.isPicked then
      return false
    end
  end
  do return true end
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

TaskController.SendOneKeyPick = function(self, ids, backAction)
  -- function num : 0_31
  (self.network):CS_QUEST_OneKeyPick(ids, backAction)
end

TaskController.GetAllRewards = function(self, taskIds)
  -- function num : 0_32 , upvalues : _ENV
  local ids = {}
  local perodicDic = {}
  for idx,taskId in ipairs(taskIds) do
    ids = self:GetTaskIds(taskId, ids, perodicDic)
  end
  return ids, perodicDic
end

TaskController.OnDelete = function(self)
  -- function num : 0_33 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__OnTaskUpdate)
  MsgCenter:RemoveListener(eMsgEventId.TaskDelete, self.__OnTaskDelete)
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__OnTaskCommit)
end

return TaskController

