-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameTaskDaily = class("UINMiniGameTaskDaily", UIBaseNode)
local base = UIBaseNode
local UINMiniGameTaskDailyItem = require("Game.ActivityHistoryTinyGame.UI.Task.UINMiniGameTaskDailyItem")
local TaskEnum = require("Game.Task.TaskEnum")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
UINMiniGameTaskDaily.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMiniGameTaskDailyItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).down, self, self.OnClickReviewAll)
  self._taskPool = (UIItemPool.New)(UINMiniGameTaskDailyItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self.__OnReviewSingleCallback = BindCallback(self, self.__OnReviewSingle)
  self.__OnRefreshSingleCallback = BindCallback(self, self.__OnRefreshSingle)
  self._taskList = {}
end

UINMiniGameTaskDaily.InitMiniGameTaskDaily = function(self, actTinyData)
  -- function num : 0_1
  self._actTinyData = actTinyData
  self:RefreshMiniGameTaskDaily()
end

UINMiniGameTaskDaily.RefreshMiniGameTaskDaily = function(self)
  -- function num : 0_2 , upvalues : _ENV, TaskEnum
  local dailyIdList = (self._actTinyData):GetTinyGameDailyTaskIds()
  local dailyDic = {}
  ;
  (table.removeall)(self._taskList)
  for i,taskId in ipairs(dailyIdList) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, true)
    dailyDic[taskId] = true
    ;
    (table.insert)(self._taskList, taskData)
  end
  for i,taskId in ipairs(((self._actTinyData):GetTGCfgData()).task_list) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, true)
    ;
    (table.insert)(self._taskList, taskData)
  end
  ;
  (table.sort)(self._taskList, function(a, b)
    -- function num : 0_2_0 , upvalues : TaskEnum, dailyDic
    if a.state ~= b.state then
      if a.state == (TaskEnum.eTaskState).Picked then
        return false
      else
        if b.state == (TaskEnum.eTaskState).Picked then
          return true
        end
      end
    end
    if not dailyDic[a.id] then
      do return dailyDic[a.id] == dailyDic[b.id] or false end
      local aComplect = a:CheckComplete()
      local bComplect = b:CheckComplete()
      if not aComplect or not true then
        do return aComplect == bComplect or false end
        if (a.stcData).order >= (b.stcData).order then
          do return (a.stcData).order == (b.stcData).order end
          do return a.id < b.id end
          -- DECOMPILER ERROR: 3 unprocessed JMP targets
        end
      end
    end
  end
)
  ;
  (self._taskPool):HideAll()
  ;
  (((self.ui).down).gameObject):SetActive(false)
  local receiveCount = 0
  for i,taskData in ipairs(self._taskList) do
    local item = (self._taskPool):GetOne()
    item:InitMiniGameTaskDailyItem(self._actTinyData, taskData, dailyDic[taskData.id], self.__OnReviewSingleCallback, self.__OnRefreshSingleCallback)
    if taskData:CheckComplete() then
      (((self.ui).down).gameObject):SetActive(true)
    end
    if taskData.state == (TaskEnum.eTaskState).Picked then
      receiveCount = receiveCount + 1
    end
  end
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(receiveCount), tostring(#self._taskList))
end

UINMiniGameTaskDaily.OnClickReviewAll = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local ids = {}
  local hasReceive = false
  for i,taskData in ipairs(self._taskList) do
    if taskData:CheckComplete() then
      ids[taskData.id] = true
      hasReceive = true
    end
  end
  if hasReceive then
    local taskNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Task)
    taskNetCtrl:CS_QUEST_OneKeyPick(ids, function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    (self._actTinyData):RefreshHTGTaskReddot(nil, true)
    if not IsNull(self.transform) then
      self:RefreshMiniGameTaskDaily()
    end
  end
)
  end
end

UINMiniGameTaskDaily.__OnReviewSingle = function(self, taskData)
  -- function num : 0_4 , upvalues : _ENV, JumpManager
  if taskData:CheckComplete() then
    local taskCtrl = ControllerManager:GetController(ControllerTypeId.Task)
    taskCtrl:SendCommitQuestReward(taskData, nil, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshMiniGameTaskDaily()
    end
  end
)
  else
    do
      if (taskData.stcData).jump_id ~= nil and (taskData.stcData).jump_id > 0 then
        JumpManager:Jump((taskData.stcData).jump_id, nil, nil, (taskData.stcData).jumpArgs)
      end
    end
  end
end

UINMiniGameTaskDaily.__OnRefreshSingle = function(self, taskData)
  -- function num : 0_5 , upvalues : cs_MessageCommon, _ENV
  if not (self._actTinyData):IsActivityRunning() then
    return 
  end
  local isComplete = taskData:CheckComplete()
  if isComplete then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7502))
    return 
  end
  local refreshTimes = (self._actTinyData):GetTinyGameRefrehTimes()
  local refreshMax = ((self._actTinyData):GetTGCfgData()).daily_task_refresh_max
  if refreshMax <= refreshTimes then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7501))
    return 
  end
  local tip = (string.format)(ConfigData:GetTipContent(7503), tostring(refreshMax - refreshTimes), tostring(refreshMax))
  ;
  (cs_MessageCommon.ShowMessageBox)(tip, function()
    -- function num : 0_5_0 , upvalues : self, taskData, _ENV
    (self._actTinyData):ReqHTGDailyReplace(taskData.id, function()
      -- function num : 0_5_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:RefreshMiniGameTaskDaily()
      end
    end
)
  end
, nil)
end

return UINMiniGameTaskDaily

