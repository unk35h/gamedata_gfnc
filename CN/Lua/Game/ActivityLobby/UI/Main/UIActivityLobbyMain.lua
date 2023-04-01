-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIActivityLobbyMain = class("UIActivityLobbyMain", base)
local UINActLbInteract = require("Game.ActivityLobby.UI.Main.Interact.UINActLbInteract")
local UINActLbQuickEntrance = require("Game.ActivityLobby.UI.Main.QuickEntrance.UINActLbQuickEntrance")
local UINResourceGroup = require("Game.CommonUI.ResourceGroup.UINResourceGroup")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
UIActivityLobbyMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActLbInteract, UINActLbQuickEntrance, UINResourceGroup
  (UIUtil.AddButtonListener)((self.ui).btn_View, self, self._OnClickHideUI)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_QuickEntrance, self, self._OnClickQuickEntrance)
  ;
  (UIUtil.SetTopStatus)(self, self._OnClickReturn)
  ;
  ((self.ui).joystick):onTouchMove("+", BindCallback(self, self._OnJoyStickMove))
  ;
  ((self.ui).joystick):onTouchUp("+", BindCallback(self, self._OnJoyStickUp))
  self.actLbIntrctNode = (UINActLbInteract.New)()
  ;
  (self.actLbIntrctNode):Init((self.ui).interactNode)
  self.quickEntranceNode = (UINActLbQuickEntrance.New)()
  ;
  (self.quickEntranceNode):Init((self.ui).quickEntranceList)
  ;
  (self.quickEntranceNode):Hide()
  self._resourceGroup = (UINResourceGroup.New)()
  ;
  (self._resourceGroup):Init((self.ui).gameResourceGroup)
end

UIActivityLobbyMain.InitActLobbyMain = function(self, actLbCtrl)
  -- function num : 0_1 , upvalues : _ENV, GuidePicture
  self._actLbCtrl = actLbCtrl
  local actLbCfg = actLbCtrl:GetActLbCfg()
  self._actLbCfg = actLbCfg
  ;
  (self._resourceGroup):SetResourceIds(actLbCfg.top_res)
  if actLbCfg.guide_id > 0 then
    (UIUtil.SetTopStateInfoFunc)(self, function()
    -- function num : 0_1_0 , upvalues : GuidePicture, actLbCfg
    (GuidePicture.OpenGuidePicture)(actLbCfg.guide_id, nil)
  end
)
  end
  self._actFrameData = (ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)):GetActivityFrameData(actLbCfg.act_id)
  if self._actFrameData then
    TimerManager:StopTimer(self._timerId)
    self._timerId = TimerManager:StartTimer(1, self.__TimerCountdown, self)
    self:__TimerCountdown()
  end
end

UIActivityLobbyMain.TryActLbGuide = function(self, callback)
  -- function num : 0_2 , upvalues : GuidePicture
  -- DECOMPILER ERROR at PC8: Unhandled construct in 'MakeBoolean' P1

  if not (self._actLbCtrl):IsFirstEnterActLb() and callback ~= nil then
    callback()
  end
  do return  end
  local actLbCfg = (self._actLbCtrl):GetActLbCfg()
  if actLbCfg.guide_id > 0 then
    (GuidePicture.OpenGuidePicture)(actLbCfg.guide_id, callback)
  else
    if callback ~= nil then
      callback()
    end
  end
end

UIActivityLobbyMain.__TimerCountdown = function(self)
  -- function num : 0_3 , upvalues : ActivityFrameUtil, _ENV
  local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._actFrameData)
  local dayStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(expireTime)
  if diff < 0 then
    TimerManager:StopTimer(self._timerId)
  end
  local followWin = UIManager:GetWindow(UIWindowTypeID.ActLbFollowInfo)
  do
    if followWin then
      local infoItem = followWin:GetActLbFollowInfoItem((self._actLbCfg).time_obj)
      if infoItem then
        infoItem:UpdActLbEntiInfoItemActTimer(title, timeStr, dayStr)
      end
    end
    ;
    (self.quickEntranceNode):UpdActLbQuickEntranceActTimer(title, timeStr, dayStr)
  end
end

UIActivityLobbyMain.SetActLbMainJoyStickFunc = function(self, joystickMoveAction, joystickUpAction)
  -- function num : 0_4
  self.__joyStickMoveAction = joystickMoveAction
  self.__joystickUpAction = joystickUpAction
end

UIActivityLobbyMain._OnJoyStickMove = function(self, moveData)
  -- function num : 0_5
  if self.__joyStickMoveAction ~= nil then
    (self.__joyStickMoveAction)(moveData)
  end
end

UIActivityLobbyMain._OnJoyStickUp = function(self)
  -- function num : 0_6
  if self.__joystickUpAction ~= nil then
    (self.__joystickUpAction)()
  end
end

UIActivityLobbyMain._OnClickQuickEntrance = function(self)
  -- function num : 0_7
  local actionList = ((self._actLbCtrl).actLbIntrctCtrl):GetActLbQuickEntranceActionList()
  ;
  (self.quickEntranceNode):InitLbQuickEntrance(actionList)
end

UIActivityLobbyMain._OnClickHideUI = function(self)
  -- function num : 0_8
  (self._actLbCtrl):ShowActLbUI(false)
end

UIActivityLobbyMain._OnClickReturn = function(self, toHome)
  -- function num : 0_9 , upvalues : ActLbUtil
  (ActLbUtil.ExitActivityLobby)(toHome)
end

UIActivityLobbyMain.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  TimerManager:StopTimer(self._timerId)
  ;
  (self.actLbIntrctNode):Delete()
  ;
  (self.quickEntranceNode):Delete()
  ;
  (self._resourceGroup):Delete()
  ;
  (base.OnDelete)(self)
end

return UIActivityLobbyMain

