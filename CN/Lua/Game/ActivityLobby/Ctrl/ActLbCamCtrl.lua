-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityLobby.Ctrl.ActLobbyCtrlBase")
local ActLbCamCtrl = class("ActLbCamCtrl", base)
local CS_RenderManager = CS.RenderManager
local CS_LeanGesture = ((CS.Lean).Touch).LeanGesture
local CS_CmCoreState = ((CS.Cinemachine).CinemachineCore).Stage
local util = require("XLua.Common.xlua_util")
local MoviePlayer = require("Game.ActivityLobby.UI.Main.UIMoviePlayer")
ActLbCamCtrl.ctor = function(self, actLbCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self._hideableEnttDic = {}
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.resloader = ((CS.ResLoader).Create)()
end

ActLbCamCtrl.OnActLbSceneEnter = function(self, bind)
  -- function num : 0_1 , upvalues : base, _ENV, CS_CmCoreState
  (base.OnActLbSceneEnter)(self, bind)
  self._camMain = UIManager:GetMainCamera()
  self._camBind = {}
  ;
  (UIUtil.LuaUIBindingTable)(bind.cam, self._camBind)
  self._sceneBind = {}
  ;
  (UIUtil.LuaUIBindingTable)((self._camBind).sceneBind, self._sceneBind)
  self._vcamMapBody = ((self._camBind).vcam_map):GetCinemachineComponent(CS_CmCoreState.Body)
  self._distance = 0.5
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self._camBind).collider_camRigidbody).center = (Vector3.Temp)(0, 0, (self._camMain).nearClipPlane)
  ;
  ((self._camBind).camRigidbody):SetParent((self._camMain).transform, false)
  local listener = ((CS.ColliderEventListener).Get)(((self._camBind).camRigidbody).gameObject)
  listener:TriggerEnterEvent("+", BindCallback(self, self._OnTriggerEnter))
  listener:TriggerExitEvent("+", BindCallback(self, self._OnTriggerExit))
end

ActLbCamCtrl.ActLbCamOnGesture = function(self, fingerList)
  -- function num : 0_2 , upvalues : CS_LeanGesture, CS_RenderManager, _ENV
  local screenDelta = (CS_LeanGesture.GetScreenDelta)(fingerList) * (CS_RenderManager.Instance).ScreenScaleRatio
  if screenDelta.x ~= 0 or screenDelta.y ~= 0 then
    local deltaX = screenDelta.x * ((self._camBind).camMoveSpeed).x
    local deltaY = screenDelta.y * ((self._camBind).camMoveSpeed).y
    local pos = ((self._camBind).camTarget).position
    pos = pos - ((Quaternion.TempEuler)(0, ((((self._camBind).vcam_map).transform).eulerAngles).y, 0)):MulVec3((Vector3.Temp)(deltaX, 0, deltaY))
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self._camBind).camTarget).position = pos
    self:SetActLbCamFollowTarget(nil)
  end
  do
    local delta = 1 - (CS_LeanGesture.GetPinchScale)(fingerList)
    if delta ~= 0 then
      self._distance = (self._vcamMapBody).m_PathPosition + delta * (self._camBind).camScaleSpeed
      self._distance = (math.clamp)(self._distance, ((self._camBind).camDistanceRange).x, ((self._camBind).camDistanceRange).y)
      -- DECOMPILER ERROR at PC76: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self._vcamMapBody).m_PathPosition = self._distance
      self:_UpdHideUIByCamScale()
    end
  end
end

ActLbCamCtrl.GetAcbLbFollowUIPosOffset = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (math.max)(0, (self._camBind).followUIOffsetFactor * (1 - self._distance - 0.5))
end

ActLbCamCtrl._UpdHideUIByCamScale = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local hideUI = (self._vcamMapBody).m_PathPosition <= (self._camBind).hideUICamDistance
  if self._isHideUI == hideUI then
    return 
  end
  self._isHideUI = hideUI
  local uiRootCanvasGroup = UIManager:GetUIRootCanvasGroup()
  uiRootCanvasGroup.interactable = not hideUI
  if self._hideAllUITween == nil then
    self._hideAllUITween = ((uiRootCanvasGroup:DOFade(0, 1)):SetAutoKill(false)):OnComplete(function()
    -- function num : 0_4_0 , upvalues : _ENV
    ((UIManager.UICanvas).gameObject):SetActive(false)
  end
)
  end
  if hideUI then
    (self._hideAllUITween):PlayForward()
  else
    ((UIManager.UICanvas).gameObject):SetActive(true)
    ;
    (self._hideAllUITween):PlayBackwards()
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

ActLbCamCtrl.SetActLbCamFollowTarget = function(self, tarTransform)
  -- function num : 0_5
  self._camTargetParent = tarTransform
end

ActLbCamCtrl._UpdCamTargetPos = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._camBind == nil then
    return 
  end
  local curPos = ((self._camBind).camTarget).position
  if not IsNull(self._camTargetParent) then
    curPos = (self._camTargetParent).position
  end
  do
    if curPos ~= self._lastCamTargetPos then
      local bound = ((self.actLbCtrl):GetActLbCfg()).cam_bound
      curPos.x = (math.clamp)(curPos.x, bound[1], bound[3])
      curPos.z = (math.clamp)(curPos.z, bound[2], bound[4])
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self._camBind).camTarget).position = curPos
    end
    self._lastCamTargetPos = curPos
  end
end

ActLbCamCtrl._OnCamChange = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._camMain == nil then
    return 
  end
  local curCamPos = ((self._camMain).transform).position
  if self._lastCamPos == curCamPos then
    return 
  end
  self._lastCamPos = curCamPos
  ;
  ((self.actLbCtrl).actLbIntrctCtrl):InvokeActLbCamChange()
  local lbFollowInfoWin = UIManager:GetWindow(UIWindowTypeID.ActLbFollowInfo)
  if lbFollowInfoWin then
    lbFollowInfoWin:UpdActLbFollowInfo()
  end
end

ActLbCamCtrl.OnLbCamUpdate = function(self)
  -- function num : 0_8
  self:_UpdCamTargetPos()
end

ActLbCamCtrl.OnLbCamLateUpdate = function(self)
  -- function num : 0_9
  self:_OnCamChange()
end

ActLbCamCtrl.ActLbPlayStartShowTimeLine = function(self, skipTlImediate)
  -- function num : 0_10 , upvalues : _ENV
  if IsNull((self._sceneBind).tl_Start) then
    self:_OnStartShowEnd()
    return 
  end
  if skipTlImediate then
    self:_EndStartShowTl()
    self:_OnStartShowEnd()
    return 
  end
  local continueWindow = UIManager:ShowWindow(UIWindowTypeID.ClickContinue)
  continueWindow:InitContinue(function()
    -- function num : 0_10_0 , upvalues : self
    self:_SkipStartShowTl()
  end
)
  local uiRootCanvasGroup = UIManager:GetUIRootCanvasGroup()
  uiRootCanvasGroup.alpha = 0
  local fadeInDuration = 1
  local delayTime = (math.max)(((self._sceneBind).tl_Start).duration - fadeInDuration, 0)
  self._uiRootFadeTween = (uiRootCanvasGroup:DOFade(1, fadeInDuration)):SetDelay(delayTime)
  self._startTlCo = (TimelineUtil.Play)((self._sceneBind).tl_Start, function()
    -- function num : 0_10_1 , upvalues : self, _ENV
    self._startTlCo = nil
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    self:_OnStartShowEnd()
  end
, false, true)
end

ActLbCamCtrl.PlayOpeningMovie = function(self, moviePath, fadeStartTime, fadeKeepTime)
  -- function num : 0_11 , upvalues : _ENV, MoviePlayer
  if not (string.IsNullOrEmpty)(moviePath) then
    local moviePath = PathConsts:GetActivityOpenVedio(moviePath)
    if self.moviePlayer == nil then
      local movieObj = (self.resloader):LoadABAsset(PathConsts:GetUIPrefabPath("UI_MoviePlayer"))
      if not IsNull(movieObj) then
        local movieGO = movieObj:Instantiate()
        self.moviePlayer = MoviePlayer:New()
        ;
        (self.moviePlayer):Init(movieGO)
      end
    end
    do
      ;
      (self.moviePlayer):PlayMovie(moviePath, nil, 1, false, nil)
      ;
      (self.moviePlayer):SetMovieFade(fadeStartTime, fadeKeepTime)
    end
  end
end

ActLbCamCtrl._SkipStartShowTl = function(self)
  -- function num : 0_12
  if self._startTlCo then
    self._startTlCo = nil
    self:_EndStartShowTl()
    ;
    (self._uiRootFadeTween):Kill(true)
  end
end

ActLbCamCtrl._EndStartShowTl = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if IsNull((self._sceneBind).tl_Start) then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self._sceneBind).tl_Start).time = ((self._sceneBind).tl_Start).duration
  ;
  ((self._sceneBind).tl_Start):Evaluate()
  if self.moviePlayer ~= nil then
    (self.moviePlayer):CloseMoviePlayer()
    self.moviePlayer = nil
  end
end

ActLbCamCtrl._OnStartShowEnd = function(self)
  -- function num : 0_14 , upvalues : _ENV, util
  self._startShowCo = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self._CoOnStartShowEnd)))
end

ActLbCamCtrl._CoOnStartShowEnd = function(self)
  -- function num : 0_15 , upvalues : _ENV
  self._startShowCo = nil
  local mainWin = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  while mainWin == nil do
    (coroutine.yield)(nil)
    mainWin = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  end
  mainWin:TryActLbGuide(function()
    -- function num : 0_15_0 , upvalues : _ENV
    GuideManager:TryTriggerGuide(eGuideCondition.InActLobby)
  end
)
  ;
  ((self.actLbCtrl).actLbIntrctCtrl):InvokeActLbStartShowEndCoFunc()
  self:_UpdHideUIByCamScale()
end

ActLbCamCtrl.AddLbCamHideableEntt = function(self, gameObject, entt)
  -- function num : 0_16
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._hideableEnttDic)[gameObject] = entt
end

ActLbCamCtrl._OnTriggerEnter = function(self, collider)
  -- function num : 0_17
  local entt = (self._hideableEnttDic)[collider.gameObject]
  if entt == nil then
    return 
  end
  entt:HideLbEnttRenderer(true)
end

ActLbCamCtrl._OnTriggerExit = function(self, collider)
  -- function num : 0_18
  local entt = (self._hideableEnttDic)[collider.gameObject]
  if entt == nil then
    return 
  end
  entt:HideLbEnttRenderer(false)
end

ActLbCamCtrl.Delete = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if self._startTlCo then
    (TimelineUtil.StopTlCo)(self._startTlCo)
    self._startTlCo = nil
    ;
    (self._uiRootFadeTween):Kill()
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.moviePlayer ~= nil then
    (self.moviePlayer):CloseMoviePlayer()
    self.moviePlayer = nil
  end
  if self._startShowCo ~= nil then
    (GR.StopCoroutine)(self._startShowCo)
    self._startShowCo = nil
  end
  if self._hideAllUITween ~= nil then
    (self._hideAllUITween):Kill()
  end
  local uiRootCanvasGroup = UIManager:GetUIRootCanvasGroup()
  uiRootCanvasGroup.interactable = true
  uiRootCanvasGroup.alpha = 1
  ;
  ((UIManager.UICanvas).gameObject):SetActive(true)
end

return ActLbCamCtrl

