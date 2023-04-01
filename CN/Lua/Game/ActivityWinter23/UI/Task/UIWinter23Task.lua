-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWinter23Task = class("UIWinter23Task", UIBaseWindow)
local base = UIBaseWindow
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local UINSpring23TaskPageItem = require("Game.ActivitySpring.UI.Task.UINSpring23TaskPageItem")
local UINWinter23DailyTask = require("Game.ActivityWinter23.UI.Task.UINWinter23DailyTask")
local UINWinter23TermTask = require("Game.ActivityWinter23.UI.Task.UINWinter23TermTask")
local cs_ResLoader = CS.ResLoader
local UINCommonActivityBG = require("Game.ActivityFrame.UI.UINCommonActivityBG")
local DailyTaskTitle = 4
local TermTaskTitles = {3, 5}
UIWinter23Task.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23TaskPageItem, UINCommonActivityBG, cs_ResLoader
  (UIUtil.SetTopStatus)(self, self.OnCloseTaskUI)
  self._pageItemPool = (UIItemPool.New)(UINSpring23TaskPageItem, (self.ui).pageItem)
  ;
  ((self.ui).pageItem):SetActive(false)
  self.__SetPageCallback = BindCallback(self, self.__SetPage)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self.__RefreshDailyTaskWhenExpireCallback = BindCallback(self, self.__RefreshDailyTaskWhenExpire)
  MsgCenter:AddListener(eMsgEventId.ActivityDailyTaskExpired, self.__RefreshDailyTaskWhenExpireCallback)
  self.__RefreshTermTaskWhenExpireCallback = BindCallback(self, self.__RefreshTermTaskWhenExpire)
  MsgCenter:AddListener(eMsgEventId.ActivityTermTaskExpired, self.__RefreshTermTaskWhenExpireCallback)
  self._actBgNode = (UINCommonActivityBG.New)()
  ;
  (self._actBgNode):Init((self.ui).uI_CommonActivityBG)
  self._resloader = (cs_ResLoader.Create)()
end

UIWinter23Task.InitWinter23Task = function(self, actFrameId, dailyTaskData, termTaskData, closeEvent)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self._dailyTaskData = dailyTaskData
  self._termTaskData = termTaskData
  self._closeEvent = closeEvent
  local frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._frameData = frameCtrl:GetActivityFrameData(actFrameId)
  self._pageOpenFuncMap = {}
  self._pageRedFuncMap = {}
  ;
  (self._pageItemPool):HideAll()
  local firstEnterPageItem = nil
  self._nextTermPageIndex = nil
  if termTaskData ~= nil then
    local count = termTaskData:GetTermTaskStageCount()
    for i = 1, count do
      if PlayerDataCenter.timestamp < termTaskData:GetTermOpenTime(i) then
        self._nextTermPageIndex = i
        break
      end
      firstEnterPageItem = self:__CreateTermPage(i)
    end
  end
  do
    if dailyTaskData ~= nil then
      firstEnterPageItem = self:__CreateDailyPage()
    end
    for k,func in pairs(self._pageRedFuncMap) do
      func()
    end
    ;
    (((self.ui).obj_ListNode).transform):SetAsLastSibling()
    ;
    (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).pageList)
    firstEnterPageItem:OnClickSelect()
    ;
    (self._actBgNode):InitActivityBG(actFrameId, self._resloader)
  end
end

UIWinter23Task.__CreateTermPage = function(self, index, isAddModel)
  -- function num : 0_2 , upvalues : _ENV, TermTaskTitles
  local item = (self._pageItemPool):GetOne()
  local func = BindCallback(self, self.__OpenTermTask, index)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._pageOpenFuncMap)[item] = func
  local redFunc = BindCallback(self, self.__RefreshRedTermTask, item, index)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._pageRedFuncMap)[item] = redFunc
  item:InitChristmasTaskPageItemParam2(TermTaskTitles[index] or 0, 1, self.__SetPageCallback)
  item:ShowChristmasTaskPageLine(true)
  if isAddModel then
    (item.transform):SetSiblingIndex(index)
  end
  return item
end

UIWinter23Task.__CreateDailyPage = function(self)
  -- function num : 0_3 , upvalues : _ENV, DailyTaskTitle
  local item = (self._pageItemPool):GetOne()
  local func = BindCallback(self, self.__OpenDailyTask)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._pageOpenFuncMap)[item] = func
  local redFunc = BindCallback(self, self.__RefreshRedDailyTask, item)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._pageRedFuncMap)[item] = redFunc
  item:InitChristmasTaskPageItemParam2(DailyTaskTitle, 2, self.__SetPageCallback)
  item:ShowChristmasTaskPageLine(false)
  return item
end

UIWinter23Task.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_4 , upvalues : _ENV
  if self._dailyTaskNode ~= nil and (self._dailyTaskNode).active then
    (self._dailyTaskNode):RefreshChristmas22LimitTaskChange(taskData)
  else
    if self._termTaskNode ~= nil and (self._termTaskNode).active then
      (self._termTaskNode):RefreshChristmas22ActTaskChange(taskData)
    end
  end
  if taskData:CheckComplete() then
    for k,func in pairs(self._pageRedFuncMap) do
      func()
    end
  end
end

UIWinter23Task.__RefreshDailyTaskWhenExpire = function(self, frameId)
  -- function num : 0_5
  if self._frameData ~= nil and frameId == (self._frameData):GetActivityFrameId() and self._dailyTaskNode ~= nil then
    (self._dailyTaskNode):RefillChristmas22LimitTaskNode()
  end
end

UIWinter23Task.__RefreshTermTaskWhenExpire = function(self, frameId)
  -- function num : 0_6 , upvalues : _ENV
  if self._frameData ~= nil and frameId == (self._frameData):GetActivityFrameId() and self._nextTermPageIndex ~= nil then
    local count = (self._termTaskData):GetTermTaskStageCount()
    local start = self._nextTermPageIndex
    self._nextTermPageIndex = nil
    for i = start, count do
      if PlayerDataCenter.timestamp < (self._termTaskData):GetTermOpenTime(i) then
        self._nextTermPageIndex = i
        break
      end
      self:__CreateTermPage(i, true)
    end
  end
end

UIWinter23Task.__SetPage = function(self, titleType, item)
  -- function num : 0_7 , upvalues : _ENV
  if self._selectItem == item then
    return 
  end
  local reddotFunc = (self._pageRedFuncMap)[item]
  local openFunc = (self._pageOpenFuncMap)[item]
  if openFunc ~= nil and openFunc(reddotFunc) then
    for i,v in ipairs((self._pageItemPool).listItem) do
      v:SetChristmasTaskPageSelectFlag(v == item)
    end
    self._selectItem = item
    local pos = ((self.ui).img_Selected).anchoredPosition
    pos.y = ((item.transform).anchoredPosition).y
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_Selected).anchoredPosition = pos
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIWinter23Task.__OpenDailyTask = function(self, reddotFunc)
  -- function num : 0_8 , upvalues : UINWinter23DailyTask
  if self._termTaskNode ~= nil then
    (self._termTaskNode):Hide()
  else
    ;
    ((self.ui).actTaskNode):SetActive(false)
  end
  if self._dailyTaskNode == nil then
    ((self.ui).limitTaskNode):SetActive(true)
    self._dailyTaskNode = (UINWinter23DailyTask.New)()
    ;
    (self._dailyTaskNode):Init((self.ui).limitTaskNode)
    ;
    (self._dailyTaskNode):InitWinter23LimitTaskNode(self._dailyTaskData, self._frameData)
  else
    ;
    (self._dailyTaskNode):Show()
  end
  ;
  (self._dailyTaskNode):RefillChristmas22LimitTaskNode()
  ;
  (self._dailyTaskNode):BindWinter23DailyTaskOperFunc(reddotFunc)
  ;
  ((self.ui).obj_ListNode):SetActive(true)
  return true
end

UIWinter23Task.__RefreshRedDailyTask = function(self, pageItem)
  -- function num : 0_9
  pageItem:SetChristmasTaskPageRed((self._dailyTaskData ~= nil and (self._dailyTaskData):IsExistDailyCompleteTask()))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWinter23Task.__OpenTermTask = function(self, term, reddotFunc)
  -- function num : 0_10 , upvalues : _ENV, UINWinter23TermTask
  if PlayerDataCenter.timestamp < (self._termTaskData):GetTermOpenTime(term) then
    return false
  end
  if self._dailyTaskNode ~= nil then
    (self._dailyTaskNode):Hide()
  else
    ;
    (self.limitTaskNode):SetActive(false)
  end
  if self._termTaskNode == nil then
    ((self.ui).actTaskNode):SetActive(true)
    self._termTaskNode = (UINWinter23TermTask.New)()
    ;
    (self._termTaskNode):Init((self.ui).actTaskNode)
  else
    ;
    (self._termTaskNode):Show()
  end
  ;
  (self._termTaskNode):InitChristmas22ActTaskNode(self._termTaskData, term)
  ;
  (self._termTaskNode):RefillChristmas22ActTaskNode()
  ;
  (self._termTaskNode):BindWinter23TermTaskOperFunc(reddotFunc)
  ;
  ((self.ui).obj_ListNode):SetActive(false)
  return true
end

UIWinter23Task.__RefreshRedTermTask = function(self, pageItem, term)
  -- function num : 0_11
  pageItem:SetChristmasTaskPageRed((self._termTaskData ~= nil and (self._termTaskData):IsExistTermCompleteTaskInTerm(term)))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWinter23Task.OnCloseTaskUI = function(self, tohome)
  -- function num : 0_12
  self:Delete()
  if self._closeEvent ~= nil then
    (self._closeEvent)(tohome)
    self._closeEvent = nil
  end
end

UIWinter23Task.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  if self._termTaskNode ~= nil then
    (self._termTaskNode):Delete()
  end
  if self._dailyTaskNode ~= nil then
    (self._dailyTaskNode):Delete()
  end
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.ActivityDailyTaskExpired, self.__RefreshDailyTaskWhenExpireCallback)
  ;
  (base.OnDelete)(self)
end

return UIWinter23Task

