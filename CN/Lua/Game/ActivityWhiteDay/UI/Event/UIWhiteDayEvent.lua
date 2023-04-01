-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayEvent = class("UIWhiteDayEvent", UIBaseWindow)
local base = UIBaseWindow
local UINWhiteDayEventNode = require("Game.ActivityWhiteDay.UI.Event.UINWhiteDayEventNode")
UIWhiteDayEvent.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWhiteDayEventNode
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickClose)
  self.__onClickClose = BindCallback(self, self.OnClickClose)
  self.eventNode = (UINWhiteDayEventNode.New)()
  ;
  (self.eventNode):Init((self.ui).obj_eventFrame)
end

UIWhiteDayEvent.InitWDEvent = function(self, AWDCtrl, AWDLineData)
  -- function num : 0_1
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
  ;
  (self.eventNode):InitWDEventNode(AWDCtrl, AWDLineData, self.__onClickClose)
end

UIWhiteDayEvent.OnClickClose = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.ReShowTopStatus)()
  self:Hide()
end

UIWhiteDayEvent.OnShow = function(self)
  -- function num : 0_3 , upvalues : base, _ENV
  (base.OnShow)(self)
  ;
  (UIUtil.HideTopStatus)()
end

UIWhiteDayEvent.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UIWhiteDayEvent

