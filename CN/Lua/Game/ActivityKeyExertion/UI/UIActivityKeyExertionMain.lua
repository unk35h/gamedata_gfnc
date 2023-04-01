-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActivityKeyExertionMain = class("UIActivityKeyExertionMain", UIBaseWindow)
local base = UIBaseWindow
local UINActivityKeyExertionTask = require("Game.ActivityKeyExertion.UI.Task.UINActivityKeyExertionTask")
local UINLogicPreviewNode = require("Game.ActivityKeyExertion.UI.Preview.UINLogicPreviewNode")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local JumpManager = require("Game.Jump.JumpManager")
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UIActivityKeyExertionMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, JumpManager
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  self.__TaskUpdateCallback = BindCallback(self, self.__TaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.ActivityKeyExertionTokenNumChange, self._OnItemChangeFunc)
  self.__OnRewardTaskCallback = BindCallback(self, self.__OnRewardTask)
  self.__RefreshCallback = BindCallback(self, self.__Refresh)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.__ShowLogicPreviewNode)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self.TryOpenPackage)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Tip, self, self.__ShowGuideTip)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  self._lastCouldUseItemJump = JumpManager.couldUseItemJump
  JumpManager.couldUseItemJump = false
end

UIActivityKeyExertionMain.InitKeyExertionMain = function(self, keyExertionData)
  -- function num : 0_1 , upvalues : _ENV, UINBaseItemWithReceived
  self._data = keyExertionData
  self._actId = keyExertionData:GetActId()
  self._controller = ControllerManager:GetController(ControllerTypeId.ActivityKeyExertion, true)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._timerId = TimerManager:StartTimer(5, self.__RefreshTime, self)
  ;
  ((self.ui).tex_Title):SetIndex(0, ((self._data).actInfo).name)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (self._data):GetKeyExertionActivityDes()
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_mainDes).text = (self._data):GetKeyExertionMainDes()
  local tokenId = (self._data):GetKeyExertionTokenId()
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_tokenImage).sprite = CRH:GetSpriteByItemId(tokenId)
  local mainRewardIds, mainRewardNums = (self._data):GetKeyExertionMainReward()
  for iIndex,vRewardId in ipairs(mainRewardIds) do
    local rewardNum = mainRewardNums[iIndex]
    local rewardItem = (UINBaseItemWithReceived.New)()
    rewardItem:Init(((self.ui).rewardItem):Instantiate(((self.ui).rewardList).transform))
    rewardItem:InitItemWithCount((ConfigData.item)[vRewardId], rewardNum)
    rewardItem:Show()
  end
  self:InitKeyExertionTask()
  self:__Refresh()
end

UIActivityKeyExertionMain.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).tex_PackageCount):SetIndex(0, tostring((self._data):GetKeyExertionOpenedPackageNum()))
  ;
  ((self.ui).tex_TokenCount):SetIndex(0, tostring((self._data):GetKeyExertionPackageFragmentNum()), tostring((self._data):GetKeyExertionPackageFragmentMaxNum()))
  self:__RefreshOpenPackageButton()
  self:__RefreshTime()
end

UIActivityKeyExertionMain.__ShowLogicPreviewNode = function(self)
  -- function num : 0_3 , upvalues : UINLogicPreviewNode
  if not self._previewNode then
    self._previewNode = (UINLogicPreviewNode.New)()
    ;
    (self._previewNode):Init((self.ui).logicPreviewNode)
  end
  local allrewardIds, allrewardNums = (self._data):GetKeyExertionAllReward()
  ;
  (self._previewNode):InitLogicPreviewNode(allrewardIds, allrewardNums, (self._data):GetKeyExertionAllRewardDes())
  ;
  (self._previewNode):Show()
end

UIActivityKeyExertionMain.__ShowGuideTip = function(self)
  -- function num : 0_4 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_4_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent(((self._data):GetKeyExertionMainCfg()).task_rule_id), (ConfigData:GetTipContent(((self._data):GetKeyExertionMainCfg()).task_rule_title)), nil, true)
  end
)
end

UIActivityKeyExertionMain.InitKeyExertionTask = function(self)
  -- function num : 0_5 , upvalues : UINActivityKeyExertionTask
  self._currentTaskItem = (UINActivityKeyExertionTask.New)()
  ;
  (self._currentTaskItem):Init((self.ui).task)
  ;
  (self._currentTaskItem):InitActivityKeyExertionTask((self._data):GetKeyExertionCurrentTaskId(), self.__OnRewardTaskCallback)
end

UIActivityKeyExertionMain.__OnRewardTask = function(self, taskData, taskItem)
  -- function num : 0_6
  (self._controller):ReqKeyExertionCommitTask(self._actId, taskData.id, function()
    -- function num : 0_6_0 , upvalues : taskItem
    taskItem:RefreshKeyExertionTaskPicked()
  end
)
end

UIActivityKeyExertionMain.__TaskUpdate = function(self, taskData)
  -- function num : 0_7
  if (self._currentTaskItem):GetActivityKeyExertionId() == taskData.id then
    (self._currentTaskItem):RefreshKeyExertionTask()
  end
end

UIActivityKeyExertionMain.__ItemUpdate = function(self, tokenId)
  -- function num : 0_8
  if tokenId == (self._data):GetKeyExertionTokenId() then
    self:__Refresh()
  end
end

UIActivityKeyExertionMain.__RefreshOpenPackageButton = function(self)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).btn_Get).interactable = (self._data):CanKeyExertionOpenPackage()
end

UIActivityKeyExertionMain.TryOpenPackage = function(self)
  -- function num : 0_10
  if (self._data):CanKeyExertionOpenPackage() then
    (self._controller):ReqKeyExertionOpenPackage(self._actId, self.__RefreshCallback)
  end
end

UIActivityKeyExertionMain.__RefreshTime = function(self)
  -- function num : 0_11 , upvalues : _ENV, ActivityFrameUtil
  if self._endTime or 0 < PlayerDataCenter.timestamp then
    local startTimeTable = TimeUtil:TimestampToDate((self._data):GetActivityBornTime(), false, true)
    ;
    ((self.ui).tex_Time0):SetIndex(0, (string.format)("%02d/%02d", startTimeTable.month, startTimeTable.day), (string.format)("%02d:%02d", startTimeTable.hour, startTimeTable.sec))
    local endTimeTable = TimeUtil:TimestampToDate((self._data):GetActivityEndTime(), false, true)
    ;
    ((self.ui).tex_Time1):SetIndex(0, (string.format)("%02d/%02d", endTimeTable.month, endTimeTable.day), (string.format)("%02d:%02d", endTimeTable.hour, endTimeTable.sec))
    self._endTime = (self._data):GetActivityEndTime()
  end
  do
    local countdownStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._endTime)
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Day).text = countdownStr
    if diff < 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UIActivityKeyExertionMain.BackAction = function(self)
  -- function num : 0_12
  self:Delete()
end

UIActivityKeyExertionMain.OnClickClose = function(self)
  -- function num : 0_13 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIActivityKeyExertionMain.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, JumpManager, base
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  MsgCenter:RemoveListener(eMsgEventId.ActivityKeyExertionTokenNumChange, self._OnItemChangeFunc)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  JumpManager.couldUseItemJump = self._lastCouldUseItemJump
  ;
  (base.OnDelete)(self)
end

return UIActivityKeyExertionMain

