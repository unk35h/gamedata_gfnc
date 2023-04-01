-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHalloween22Task = class("UIHalloween22Task", UIBaseWindow)
local base = UIBaseWindow
local cs_MessageCommon = CS.MessageCommon
local cs_UnityEngine = CS.UnityEngine
local util = require("XLua.Common.xlua_util")
local JumpManager = require("Game.Jump.JumpManager")
local UINActivityHalloweenTask = require("Game.ActivityHallowmas.UI.Task.UINActivityHalloweenTask")
UIHalloween22Task.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActivityHalloweenTask
  (UIUtil.SetTopStatus)(self, self.OnCloseHalloweenTask, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickTaskClose)
  self._taskItmePool = (UIItemPool.New)(UINActivityHalloweenTask, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  self._emptyItemList = {(self.ui).emptyItem}
  ;
  ((self.ui).emptyItem):SetActive(false)
  self.__OnExpiredCallback = BindCallback(self, self.__OnExpired)
  MsgCenter:AddListener(eMsgEventId.ActivityHallowmasExpired, self.__OnExpiredCallback)
  self.__TaskUpdateCallback = BindCallback(self, self.__TaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  self.__OnRereshTaskCallback = BindCallback(self, self.__OnRereshTask)
  self.__OnRewardTaskCallback = BindCallback(self, self.__OnRewardTask)
  self.__OnJumpTargetCallback = BindCallback(self, self.__OnJumpTarget)
  self.__DelayShowItemCallback = BindCallback(self, self.__DelayShowItem)
end

UIHalloween22Task.InitHalloweenTask = function(self, hallowmasData)
  -- function num : 0_1
  self._data = hallowmasData
  self:__Refresh()
end

UIHalloween22Task.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV, util
  (self._taskItmePool):HideAll()
  for i,v in ipairs(self._emptyItemList) do
    v:SetActive(false)
  end
  if self._delayItemCO ~= nil then
    (GR.StopCoroutine)(self._delayItemCO)
    self._delayItemCO = nil
  end
  self._delayItemCO = (GR.StartCoroutine)((util.cs_generator)(self.__DelayShowItemCallback))
end

UIHalloween22Task.__DelayShowItem = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_UnityEngine
  local taskids = (self._data):GetHallowmasDailyTaskIds()
  local isCanRef = (self._data):GetHallowmasTaskRefreshTimes() < ((self._data):GetHallowmasMainCfg()).daily_task_refresh_max
  local countMax = #(self.ui).posTr_array
  local existCount = #taskids
  for i,v in ipairs(taskids) do
    if countMax >= i then
      local item = (self._taskItmePool):GetOne()
      do
        local parent = ((self.ui).posTr_array)[i]
        ;
        (item.transform):SetParent(parent)
        -- DECOMPILER ERROR at PC37: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (item.transform).localPosition = Vector3.zero
        item:InitHalloweenTask(v, self.__OnRereshTaskCallback, self.__OnRewardTaskCallback, self.__OnJumpTargetCallback)
        item:RefreshHalloweenRefBtn(isCanRef)
        item:SetHalloweenGhost(i)
        ;
        (coroutine.yield)((cs_UnityEngine.WaitForSeconds)(0.3))
        -- DECOMPILER ERROR at PC56: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC56: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  for i = existCount + 1, countMax do
    local item = (self._emptyItemList)[i - existCount]
    if item == nil then
      item = ((self.ui).emptyItem):Instantiate()
      ;
      (table.insert)(self._emptyItemList, item)
    end
    item:SetActive(true)
    local parent = ((self.ui).posTr_array)[i]
    ;
    (item.transform):SetParent(parent)
    -- DECOMPILER ERROR at PC90: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (item.transform).localPosition = Vector3.zero
    ;
    (coroutine.yield)((cs_UnityEngine.WaitForSeconds)(0.3))
  end
  self._delayItemCO = nil
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIHalloween22Task.__OnRereshTask = function(self, taskData, taskItem)
  -- function num : 0_4 , upvalues : cs_MessageCommon, _ENV
  local curTimes = (self._data):GetHallowmasTaskRefreshTimes()
  local maxTimes = ((self._data):GetHallowmasMainCfg()).daily_task_refresh_max
  local remainTimes = maxTimes - curTimes
  if remainTimes <= 0 then
    return 
  end
  ;
  (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(8703, tostring(remainTimes), tostring(maxTimes)), function()
    -- function num : 0_4_0 , upvalues : self, taskData, taskItem, _ENV
    (self._data):ReqHallowmasRefreshTask(taskData.id, function(newTaskId)
      -- function num : 0_4_0_0 , upvalues : taskItem, self, _ENV
      local index = taskItem:GetHalloweenGhost()
      local newItem = (self._taskItmePool):GetOne()
      local parent = ((self.ui).posTr_array)[index]
      ;
      (newItem.transform):SetParent(parent)
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (newItem.transform).localPosition = Vector3.zero
      newItem:InitHalloweenTask(newTaskId, self.__OnRereshTaskCallback, self.__OnRewardTaskCallback, self.__OnJumpTargetCallback)
      newItem:SetHalloweenGhost(index)
      local isCanRef = (self._data):GetHallowmasTaskRefreshTimes() < ((self._data):GetHallowmasMainCfg()).daily_task_refresh_max
      for i,v in ipairs((self._taskItmePool).listItem) do
        v:RefreshHalloweenRefBtn(isCanRef)
      end
      taskItem:HideHalloweenTween(function()
        -- function num : 0_4_0_0_0 , upvalues : self, taskItem
        (self._taskItmePool):HideOne(taskItem)
      end
)
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
)
  end
, nil)
end

UIHalloween22Task.__OnRewardTask = function(self, taskData, taskItem)
  -- function num : 0_5
  (self._data):ReqHallowmasCommitTask(taskData.id, function()
    -- function num : 0_5_0 , upvalues : taskItem
    taskItem:RefreshHalloweenTaskPicked()
  end
)
end

UIHalloween22Task.__OnJumpTarget = function(self, taskData)
  -- function num : 0_6 , upvalues : JumpManager, _ENV
  local jumpId = (taskData.stcData).jump_id
  local jumpArgs = (taskData.stcData).jumpArgs
  do
    if jumpId == (JumpManager.eJumpTarget).DynActivity and jumpArgs[1] == (self._data):GetActFrameId() then
      local mainUI = UIManager:GetWindow(UIWindowTypeID.Halloween22Main)
      if mainUI ~= nil then
        (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Halloween22Main)
        mainUI:OnClickBattle()
      end
      return 
    end
    if jumpId or 0 > 0 then
      JumpManager:Jump(jumpId, function(jumpCallback)
    -- function num : 0_6_0
    if jumpCallback ~= nil then
      jumpCallback()
    end
  end
, nil, jumpArgs)
    end
  end
end

UIHalloween22Task.__TaskUpdate = function(self, taskData)
  -- function num : 0_7 , upvalues : _ENV
  for i,v in ipairs((self._taskItmePool).listItem) do
    if v:GetHalloweenTaskId() == taskData.id then
      v:RefreshHalloweenTask()
    end
  end
end

UIHalloween22Task.__OnExpired = function(self, actId)
  -- function num : 0_8
  if (self._data):GetActId() == actId then
    self:__Refresh()
  end
end

UIHalloween22Task.OnClickTaskClose = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIHalloween22Task.OnCloseHalloweenTask = function(self)
  -- function num : 0_10
  self:Delete()
end

UIHalloween22Task.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self._delayItemCO ~= nil then
    (GR.StopCoroutine)(self._delayItemCO)
    self._delayItemCO = nil
  end
  ;
  (self._taskItmePool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.ActivityHallowmasExpired, self.__OnExpiredCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  ;
  (base.OnDelete)(self)
end

return UIHalloween22Task

