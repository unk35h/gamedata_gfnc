-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChristmas22Task = class("UIChristmas22Task", UIBaseWindow)
local base = UIBaseWindow
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local titleTypeEnum = {onceTask = 1, dailyTask = 2}
UIChristmas22Task.__SetNodeClass = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._LimitTaskNodeClass = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskNode")
  self._ActTaskNodeClass = require("Game.ActivityChristmas.UI.Task.UINChristmas22ActTaskNode")
  self._pageNodeClass = require("Game.ActivityChristmas.UI.Task.UINChristmasTaskPageItem")
end

UIChristmas22Task.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, titleTypeEnum
  (UIUtil.SetTopStatus)(self, self.OnCloseTaskUI)
  self:__SetNodeClass()
  self._pageItemPool = (UIItemPool.New)(self._pageNodeClass, (self.ui).pageItem)
  ;
  ((self.ui).pageItem):SetActive(false)
  self.__SetPageCallback = BindCallback(self, self.__SetPage)
  self._typeFunc = {[titleTypeEnum.onceTask] = self.__OpenOnceTask, [titleTypeEnum.dailyTask] = self.__OpenDailyTask}
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
end

UIChristmas22Task.InitChristmas22Task = function(self, hallowmasData, closeEvent)
  -- function num : 0_2 , upvalues : _ENV, titleTypeEnum, cs_LayoutRebuilder
  self._hallowmasData = hallowmasData
  self._closeEvent = closeEvent
  ;
  (self._pageItemPool):HideAll()
  local count = (table.count)(titleTypeEnum)
  for i = 1, count do
    local item = (self._pageItemPool):GetOne()
    item:InitChristmasTaskPageItem(i, self.__SetPageCallback)
    item:ShowChristmasTaskPageLine(i ~= count)
  end
  if not IsNull((self.ui).obj_ListNode) then
    (((self.ui).obj_ListNode).transform):SetAsLastSibling()
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).pageList)
  self._reddot = (self._hallowmasData):GetActivityReddot()
  if self._reddot ~= nil then
    self._reddotFunc = BindCallback(self, self.__RefreshReddot)
    RedDotController:AddListener((self._reddot).nodePath, self._reddotFunc)
    self:__RefreshReddot(self._reddot)
  end
  self:__FirstOpenPage()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIChristmas22Task.__FirstOpenPage = function(self)
  -- function num : 0_3 , upvalues : titleTypeEnum
  self:__SetPage(titleTypeEnum.onceTask)
end

UIChristmas22Task.__SetPage = function(self, titleType)
  -- function num : 0_4 , upvalues : _ENV
  if self._titleType == titleType then
    return 
  end
  self._titleType = titleType
  for i,v in ipairs((self._pageItemPool).listItem) do
    v:SetChristmasTaskPageSelect(self._titleType)
  end
  local item = ((self._pageItemPool).listItem)[self._titleType]
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Selected).anchoredPosition = (item.transform).anchoredPosition
  ;
  ((self._typeFunc)[titleType])(self)
end

UIChristmas22Task.__OpenOnceTask = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._dailyNode ~= nil and (self._dailyNode).active then
    (self._dailyNode):Hide()
  else
    ;
    ((self.ui).limitTaskNode):SetActive(false)
  end
  if self._onceNode == nil then
    ((self.ui).actTaskNode):SetActive(true)
    self._onceNode = ((self._ActTaskNodeClass).New)()
    ;
    (self._onceNode):Init((self.ui).actTaskNode)
    ;
    (self._onceNode):InitChristmas22ActTaskNode(self._hallowmasData)
  else
    ;
    (self._onceNode):Show()
  end
  ;
  (self._onceNode):RefillChristmas22ActTaskNode()
  if not IsNull((self.ui).obj_ListNode) then
    ((self.ui).obj_ListNode):SetActive(false)
  end
end

UIChristmas22Task.__OpenDailyTask = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._onceNode ~= nil and (self._onceNode).active then
    (self._onceNode):Hide()
  else
    ;
    ((self.ui).actTaskNode):SetActive(false)
  end
  if self._dailyNode == nil then
    ((self.ui).limitTaskNode):SetActive(true)
    self._dailyNode = ((self._LimitTaskNodeClass).New)()
    ;
    (self._dailyNode):Init((self.ui).limitTaskNode)
    ;
    (self._dailyNode):InitChristmas22LimitTaskNode(self._hallowmasData)
  else
    ;
    (self._dailyNode):Show()
  end
  ;
  (self._dailyNode):RefillChristmas22LimitTaskNode()
  if not IsNull((self.ui).obj_ListNode) then
    ((self.ui).obj_ListNode):SetActive(true)
  end
end

UIChristmas22Task.__RefreshReddot = function(self, reddot)
  -- function num : 0_7 , upvalues : ActivityHallowmasEnum, titleTypeEnum
  local taskRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).DailyTask)
  local achievementRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Achievement)
  local achievementPage = ((self._pageItemPool).listItem)[titleTypeEnum.onceTask]
  if achievementRed:GetRedDotCount() <= 0 then
    achievementPage:SetChristmasTaskPageRed(achievementPage == nil or achievementRed == nil)
    local dailyPage = ((self._pageItemPool).listItem)[titleTypeEnum.dailyTask]
    if taskRed:GetRedDotCount() <= 0 then
      dailyPage:SetChristmasTaskPageRed(dailyPage == nil or taskRed == nil)
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
end

UIChristmas22Task.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_8 , upvalues : titleTypeEnum
  if self._titleType == titleTypeEnum.onceTask then
    (self._onceNode):RefreshChristmas22ActTaskChange(taskData)
  else
    if self._titleType == titleTypeEnum.dailyTask then
      (self._dailyNode):RefreshChristmas22LimitTaskChange(taskData)
    end
  end
end

UIChristmas22Task.OnCloseTaskUI = function(self, tohome)
  -- function num : 0_9
  self:Delete()
  if self._closeEvent ~= nil then
    (self._closeEvent)(tohome)
    self._closeEvent = nil
  end
end

UIChristmas22Task.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  if self._onceNode ~= nil then
    (self._onceNode):Delete()
  end
  if self._dailyNode ~= nil then
    (self._dailyNode):Delete()
  end
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
    self._reddot = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  ;
  (base.OnDelete)(self)
end

return UIChristmas22Task

