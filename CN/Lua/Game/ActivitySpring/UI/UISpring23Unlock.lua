-- params : ...
-- function num : 0 , upvalues : _ENV
local UISpring23Unlock = class("UISpring23Unlock", UIBaseWindow)
local base = UIBaseWindow
local ActCommonEnum = require("Game.Common.Activity.ActCommonEnum")
local eActInteract23Spring = require("Game.ActivityLobby.Activity.2023Spring.eActInteract")
UISpring23Unlock.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseUnlock)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickJump)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.OnClickBG)
end

UISpring23Unlock.InitSpring23Unlock = function(self, unlockInfo, callback)
  -- function num : 0_1
  self._unlockInfo = unlockInfo
  self._callback = callback
  self._unlockList = (self._unlockInfo):GetActUnlockInfoList()
  self._index = 0
  self:ShowNext()
end

UISpring23Unlock.ShowNext = function(self)
  -- function num : 0_2 , upvalues : ActCommonEnum, _ENV
  self._index = self._index + 1
  local unlockElemt = (self._unlockList)[self._index]
  if unlockElemt.unlockType == (ActCommonEnum.ActUnlockType).Env then
    local envCfg = (ConfigData.activity_spring_advanced_env)[unlockElemt.unlockId]
    local envName = nil
    if envCfg ~= nil then
      envName = (LanguageUtil.GetLocaleText)(envCfg.env_name)
    else
      envName = ""
    end
    ;
    ((self.ui).tex_Unlock):SetIndex(0, envName)
    ;
    (((self.ui).tex_UnlockExtra).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Check).gameObject):SetActive(true)
    self:__PlayTween()
  else
    do
      if unlockElemt.unlockType == (ActCommonEnum.ActUnlockType).AVGAllPlayed then
        ((self.ui).tex_Unlock):SetIndex(1)
        ;
        (((self.ui).tex_UnlockExtra).gameObject):SetActive(true)
        ;
        (((self.ui).btn_Check).gameObject):SetActive(false)
        self:__PlayTween()
      else
        self:OnClickBG()
      end
    end
  end
end

UISpring23Unlock.__PlayTween = function(self)
  -- function num : 0_3
  if self._tweenCanvas ~= nil then
    (self._tweenCanvas):Rewind()
    ;
    (self._tweenCanvas):PlayForward()
    ;
    (self._tweenDes):Rewind()
    ;
    (self._tweenDes):PlayForward()
    ;
    (self._tweenDesExtra):Rewind()
    ;
    (self._tweenDesExtra):PlayForward()
    return 
  end
  self._tweenCanvas = ((((self.ui).noticeObj):DOFade(0, 0.7)):From()):SetAutoKill(false)
  self._tweenDes = (((((self.ui).tex_Unlock).transform):DOLocalMoveY(20, 0.7)):SetRelative(true)):SetAutoKill(false)
  self._tweenDesExtra = (((((self.ui).tex_UnlockExtra).transform):DOLocalMoveY(20, 0.7)):SetRelative(true)):SetAutoKill(false)
end

UISpring23Unlock.OnClickJump = function(self)
  -- function num : 0_4 , upvalues : _ENV, eActInteract23Spring
  (UIUtil.OnClickBack)()
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if ctrl ~= nil then
    (ctrl.actLbIntrctCtrl):InvokeActLbEntity((eActInteract23Spring.eLbIntrctEntityId).EnvSelect)
  end
end

UISpring23Unlock.OnClickBG = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._index < #self._unlockList then
    self:ShowNext()
  else
    ;
    (UIUtil.OnClickBack)()
  end
end

UISpring23Unlock.OnCloseUnlock = function(self)
  -- function num : 0_6
  (self._unlockInfo):ClearActUnlockInfo()
  if self._tweenCanvas ~= nil then
    (self._tweenCanvas):Kill()
    ;
    (self._tweenDes):Kill()
    ;
    (self._tweenDesExtra):Kill()
  end
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

return UISpring23Unlock

