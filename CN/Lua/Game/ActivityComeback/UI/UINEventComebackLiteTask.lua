-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackTask = require("Game.ActivityComeback.UI.UINEventComebackTask")
local UINEventComebackLiteTask = class("UINEventComebackLiteTask", UINEventComebackTask)
local base = UINEventComebackTask
local UINEventComebackTaskTitle = require("Game.ActivityComeback.UI.UINEventComebackTaskTitle")
local UINEventComebackTaskItem = require("Game.ActivityComeback.UI.UINEventComebackTaskItem")
local TaskEnum = require("Game.Task.TaskEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
UINEventComebackLiteTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventComebackTaskTitle, UINEventComebackTaskItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._titlePool = (UIItemPool.New)(UINEventComebackTaskTitle, (self.ui).title)
  ;
  ((self.ui).title):SetActive(false)
  self._itemPool = (UIItemPool.New)(UINEventComebackTaskItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent(7408)
  self.__OnReceiveTaskCallback = BindCallback(self, self.__OnReceiveTask)
  self.__TaskUpdateCallback = BindCallback(self, self.__TaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  self.__RefreshCallback = BindCallback(self, self.__Refresh)
  MsgCenter:AddListener(eMsgEventId.ActivityTaskUpdate, self.__RefreshCallback)
end

return UINEventComebackLiteTask

