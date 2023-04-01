-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameTask = class("UINMiniGameTask", UIBaseNode)
local base = UIBaseNode
local UINMiniGameTag = require("Game.ActivityHistoryTinyGame.UI.Task.UINMiniGameTag")
local UINMiniGameTaskDaily = require("Game.ActivityHistoryTinyGame.UI.Task.UINMiniGameTaskDaily")
local UINMiniGameTaskActive = require("Game.ActivityHistoryTinyGame.UI.Task.UINMiniGameTaskActive")
local ActivityHTGEnum = require("Game.ActivityHistoryTinyGame.ActivityHTGEnum")
local tagCount = 2
UINMiniGameTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMiniGameTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._tagPool = (UIItemPool.New)(UINMiniGameTag, (self.ui).pageItem)
  ;
  ((self.ui).pageItem):SetActive(false)
  self.__ListenTaskExpiredCallback = BindCallback(self, self.__ListenTaskExpired)
  self.__ListenActiveCallback = BindCallback(self, self.__ListenActive)
  self.__ListenTaskUpdateCallback = BindCallback(self, self.__ListenTaskUpdate)
  MsgCenter:AddListener(eMsgEventId.ActivityTinyGameTaskExpired, self.__ListenTaskExpiredCallback)
  MsgCenter:AddListener(eMsgEventId.ActivityTinyGameActive, self.__ListenActiveCallback)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__ListenTaskUpdateCallback)
  self.__OnClickTagCallback = BindCallback(self, self.__OnClickTag)
  ;
  ((self.ui).taskNode):SetActive(false)
  ;
  ((self.ui).cupNode):SetActive(false)
  self.__RefreshActivityDotCallback = BindCallback(self, self.__RefreshActivityDot)
end

UINMiniGameTask.InitMiniGameTask = function(self, actTinyData)
  -- function num : 0_1 , upvalues : _ENV
  self._actTinyData = actTinyData
  for i = 1, 2 do
    local item = (self._tagPool):GetOne()
    item:InitMiniGameTag(i, self.__OnClickTagCallback)
  end
  self:__RefreshActive()
  self:__OnClickTag(1)
  if self._reddot == nil then
    self._reddot = (self._actTinyData):GetActivityReddot()
    RedDotController:AddListener((self._reddot).nodePath, self.__RefreshActivityDotCallback)
    self:__RefreshActivityDot()
  end
end

UINMiniGameTask.__OnClickTag = function(self, index)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._tagPool).listItem) do
    v:RefreshTagState(index)
  end
  if index == 1 then
    self:__OpenDailyTask()
  else
    if index == 2 then
      self:__OpenActiveTask()
    end
  end
end

UINMiniGameTask.__OpenDailyTask = function(self)
  -- function num : 0_3 , upvalues : UINMiniGameTaskDaily
  if self._taskActiveNode ~= nil then
    (self._taskActiveNode):Hide()
  end
  if self._taskDailyNode == nil then
    ((self.ui).taskNode):SetActive(true)
    self._taskDailyNode = (UINMiniGameTaskDaily.New)()
    ;
    (self._taskDailyNode):Init((self.ui).taskNode)
    ;
    (self._taskDailyNode):InitMiniGameTaskDaily(self._actTinyData)
  else
    ;
    (self._taskDailyNode):Show()
    ;
    (self._taskDailyNode):RefreshMiniGameTaskDaily()
  end
end

UINMiniGameTask.__OpenActiveTask = function(self)
  -- function num : 0_4 , upvalues : UINMiniGameTaskActive
  if self._taskDailyNode ~= nil then
    (self._taskDailyNode):Hide()
  end
  if self._taskActiveNode == nil then
    ((self.ui).cupNode):SetActive(true)
    self._taskActiveNode = (UINMiniGameTaskActive.New)()
    ;
    (self._taskActiveNode):Init((self.ui).cupNode)
    ;
    (self._taskActiveNode):InitMiniGameTaskActive(self._actTinyData)
  else
    ;
    (self._taskActiveNode):Show()
    ;
    (self._taskActiveNode):RefreshMiniGameTaskActive()
  end
end

UINMiniGameTask.__RefreshActive = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local level = ((self._actTinyData):GetActiveLevel())
  local needPoint, hasPoint = nil, nil
  local curlevelCfg = ((self._actTinyData):GetTGActiveCfg())[level + 1]
  if curlevelCfg ~= nil then
    needPoint = curlevelCfg.need_point
    hasPoint = (self._actTinyData):GetTinyGameActive()
  else
    needPoint = (self._actTinyData):GetTGMaxActive()
    hasPoint = needPoint
  end
  hasPoint = (math.min)(hasPoint, needPoint)
  needPoint = (math.max)(1, needPoint)
  ;
  ((self.ui).tex_Lvl):SetIndex(0, tostring(level))
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).slider).value = hasPoint / needPoint
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(hasPoint), tostring(needPoint))
end

UINMiniGameTask.__ListenActive = function(self)
  -- function num : 0_6
  self:__RefreshActive()
  if self._taskActiveNode ~= nil and (self._taskActiveNode).active then
    (self._taskActiveNode):RefreshMiniGameTaskActive()
  end
end

UINMiniGameTask.__ListenTaskExpired = function(self)
  -- function num : 0_7
  if self._taskDailyNode ~= nil and (self._taskDailyNode).active then
    (self._taskDailyNode):RefreshMiniGameTaskDaily()
  end
end

UINMiniGameTask.__ListenTaskUpdate = function(self)
  -- function num : 0_8
  if self._taskDailyNode ~= nil and (self._taskDailyNode).active then
    (self._taskDailyNode):RefreshMiniGameTaskDaily()
  end
end

UINMiniGameTask.__RefreshActivityDot = function(self)
  -- function num : 0_9 , upvalues : ActivityHTGEnum
  local taskReddot = (self._reddot):GetChild((ActivityHTGEnum.eActivityReddot).Task)
  local activeReddot = (self._reddot):GetChild((ActivityHTGEnum.eActivityReddot).Active)
  ;
  (((self._tagPool).listItem)[1]):SetHTGTaskTagDot(taskReddot ~= nil and taskReddot:GetRedDotCount() > 0)
  ;
  (((self._tagPool).listItem)[2]):SetHTGTaskTagDot(activeReddot ~= nil and activeReddot:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINMiniGameTask.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.ActivityTinyGameTaskExpired, self.__ListenTaskExpiredCallback)
  MsgCenter:RemoveListener(eMsgEventId.ActivityTinyGameActive, self.__ListenActiveCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__ListenTaskUpdateCallback)
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self.__RefreshActivityDotCallback)
  end
end

return UINMiniGameTask

