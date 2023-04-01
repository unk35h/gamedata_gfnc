-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityWhiteDaySceneCtrl = class("ActivityWhiteDaySceneCtrl")
local DormEnum = require("Game.Dorm.DormEnum")
local cs_QualitySettings = (CS.UnityEngine).QualitySettings
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_LeanGesture = ((CS.Lean).Touch).LeanGesture
local CS_Animator = (CS.UnityEngine).Animator
local defaultScenePartStateId = (CS_Animator.StringToHash)("Working_1")
ActivityWhiteDaySceneCtrl.ctor = function(self, AWDCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  self.__onGesture = BindCallback(self, self.OnGesture)
  self.__onFingerTap = BindCallback(self, self.OnFingerTap)
  self.__update__handle = BindCallback(self, self.OnUpdate)
end

ActivityWhiteDaySceneCtrl.OnEnterWhiteDayScene = function(self, AWDData)
  -- function num : 0_1 , upvalues : _ENV, cs_QualitySettings, DormEnum, CS_LeanTouch
  local objBinder = (((CS.UnityEngine).GameObject).Find)("ObjectBinder")
  if IsNull(objBinder) then
    error("scene not find ObjectBinder")
    return 
  end
  self._factoryAnimationConfig = require("SpecialConfig.WhiteValentineFactoryAnimationConfig")
  self._enterScene = true
  self._cameraControl = false
  ;
  ((CS.RenderManager).Instance):SetUnityShadow(true)
  self.__oldShadowDistance = cs_QualitySettings.shadowDistance
  cs_QualitySettings.shadowDistance = DormEnum.DormShadowDistance
  ;
  (CS_LeanTouch.OnGesture)("+", self.__onGesture)
  ;
  (CS_LeanTouch.OnFingerTap)("+", self.__onFingerTap)
  UpdateManager:AddUpdate(self.__update__handle)
  self.bind = {}
  ;
  (UIUtil.LuaUIBindingTable)(objBinder, self.bind)
  self._factoryParts = {}
  for lineId,lineData in pairs(AWDData:GetWDFactoryLineDataDic()) do
    if lineData:GetIsInProduction() then
      self:AddWDBindRole(lineId, lineData:GetWDLDAssistHeroID())
    end
  end
end

ActivityWhiteDaySceneCtrl.AddWDBindRole = function(self, lineId, heroId)
  -- function num : 0_2 , upvalues : _ENV, CS_Animator, defaultScenePartStateId
  if not self._enterScene then
    return 
  end
  local part = (self._factoryParts)[lineId]
  if part ~= nil then
    if part.heroId == heroId then
      return 
    end
    DestroyUnityObject(part.heroGameObject)
    ;
    (part.resloader):Put2Pool()
  end
  if heroId == nil then
    return 
  end
  part = {resloader = ((CS.ResLoader).Create)(), heroId = heroId}
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._factoryParts)[lineId] = part
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  local resName = heroData:GetResModelName()
  local workId = 1
  local cfg1 = (self._factoryAnimationConfig)[resName]
  do
    if cfg1 ~= nil then
      local wid = cfg1[lineId]
      if wid ~= nil then
        workId = wid
      end
    end
    ;
    (part.resloader):LoadABAssetAsync(PathConsts:GetCharacterDormModelPath(resName), function(prefab)
    -- function num : 0_2_0 , upvalues : _ENV, self, lineId, part, workId, CS_Animator, defaultScenePartStateId
    if IsNull(prefab) then
      return 
    end
    local go = prefab:Instantiate(((self.bind).list_RoleBindPoint)[lineId])
    part.heroGameObject = go
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (go.transform).localPosition = Vector3.zero
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (go.transform).localScale = Vector3.one
    local animator = go:FindComponent(eUnityComponentID.Animator)
    if not IsNull(animator) then
      animator:Play("whiteaction" .. tostring(lineId))
    end
    local scenePartAni = ((self.bind).list_FactoryAni)[lineId]
    local scenePartAniName = "Working_" .. tostring(workId)
    local stateid = (CS_Animator.StringToHash)(scenePartAniName)
    local hasState = scenePartAni:HasState(0, stateid)
    if hasState then
      scenePartAni:Play(stateid, 0, 0)
    else
      scenePartAni:Play(defaultScenePartStateId, 0, 0)
    end
  end
)
  end
end

ActivityWhiteDaySceneCtrl.RemoveWDBindRole = function(self, lineId)
  -- function num : 0_3 , upvalues : _ENV
  if not self._enterScene then
    return 
  end
  local part = (self._factoryParts)[lineId]
  if part ~= nil then
    DestroyUnityObject(part.heroGameObject)
    ;
    (part.resloader):Put2Pool()
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._factoryParts)[lineId] = nil
  local scenePartAni = ((self.bind).list_FactoryAni)[lineId]
  scenePartAni:Play("Stop_Idle", 0, 0)
end

ActivityWhiteDaySceneCtrl.GetWDFactoryLineUIPos = function(self, lineId)
  -- function num : 0_4 , upvalues : _ENV
  if not self._enterScene then
    return Vector2.zero
  end
  local bindPoint = ((self.bind).list_RoleBindPoint)[lineId]
  local offset = ((self.bind).list_UIOffset)[lineId]
  if IsNull(bindPoint) or offset == nil then
    return Vector2.zero
  end
  local x, y = UIManager:World2UIPositionOut(bindPoint)
  local pos = (Vector2.New)(offset.x + x, offset.y + y)
  return pos
end

ActivityWhiteDaySceneCtrl.OnGesture = function(self, fingerList)
  -- function num : 0_5 , upvalues : _ENV, CS_LeanGesture
  if not (UIUtil.CheckTopIsWindow)(UIWindowTypeID.WhiteDay) then
    return 
  end
  if self._resumeTimerId ~= nil then
    return 
  end
  for i = fingerList.Count - 1, 0, -1 do
    if (fingerList[i]).StartedOverGui then
      fingerList:RemoveAt(i)
    end
  end
  if fingerList.Count == 0 then
    return 
  end
  local screenScaleRatio = ((CS.RenderManager).Instance).ScreenScaleRatio
  if not self._cameraControl then
    local vec1 = (CS_LeanGesture.GetStartScreenCenter)(fingerList)
    local vec2 = (CS_LeanGesture.GetScreenCenter)(fingerList)
    local distance = (Vector2.Distance)(vec1, vec2)
    if (self.bind).distance_control < distance then
      self:EnterWDCameraControlMode()
    else
      return 
    end
  end
  do
    local delta = (CS_LeanGesture.GetScreenDelta)(fingerList) * screenScaleRatio
    ;
    ((CS.DormCameraController).Instance):DormRoomViewRotate(delta)
  end
end

ActivityWhiteDaySceneCtrl.OnUpdate = function(self)
  -- function num : 0_6 , upvalues : _ENV, CS_LeanTouch, CS_LeanGesture
  if not (UIUtil.CheckTopIsWindow)(UIWindowTypeID.WhiteDay) then
    return 
  end
  if not self._cameraControl then
    return 
  end
  local fingers = (CS_LeanTouch.GetFingers)(true, false)
  local pinch = (CS_LeanGesture.GetPinchScale)(fingers, (self.bind).dormRoomWheel) - 1
  ;
  ((CS.DormCameraController).Instance):DormRoomViewDistance(-pinch * 3)
end

ActivityWhiteDaySceneCtrl.OnFingerTap = function(self, leanFinger)
  -- function num : 0_7 , upvalues : _ENV
  if not (UIUtil.CheckTopIsWindow)(UIWindowTypeID.WhiteDay) then
    return 
  end
  if not self._cameraControl then
    return 
  end
  if not leanFinger.IsOverGui and not leanFinger.StartedOverGui then
    self:ExitWDCameraControlMode()
  end
end

ActivityWhiteDaySceneCtrl.EnterWDCameraControlMode = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self._cameraControl = true
  ;
  ((CS.DormCameraController).Instance):ResetDormRoomView()
  ;
  ((self.bind).va_Room):SetActive(true)
  ;
  ((self.bind).va_Normal):SetActive(false)
  local window = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
  if window ~= nil then
    window:SetWDCanvasGroupState(false)
  end
  ;
  (UIUtil.HideTopStatus)()
end

ActivityWhiteDaySceneCtrl.ExitWDCameraControlMode = function(self)
  -- function num : 0_9 , upvalues : _ENV
  self._cameraControl = false
  ;
  ((self.bind).va_Normal):SetActive(true)
  ;
  ((self.bind).va_Room):SetActive(false)
  self._resumeTimerId = TimerManager:StartTimer(0.5, function()
    -- function num : 0_9_0 , upvalues : self, _ENV
    self._resumeTimerId = nil
    if not self._enterScene then
      return 
    end
    local window = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
    if window ~= nil then
      window:SetWDCanvasGroupState(true)
    end
    ;
    (UIUtil.ReShowTopStatus)()
  end
, nil, true)
end

ActivityWhiteDaySceneCtrl.OnExitWhiteDayScene = function(self)
  -- function num : 0_10 , upvalues : _ENV, cs_QualitySettings, CS_LeanTouch
  if not self._enterScene then
    return 
  end
  self._enterScene = false
  ;
  ((CS.RenderManager).Instance):SetUnityShadow(false)
  if self.__oldShadowDistance ~= nil then
    cs_QualitySettings.shadowDistance = self.__oldShadowDistance
    self.__oldShadowDistance = nil
  end
  ;
  (CS_LeanTouch.OnGesture)("-", self.__onGesture)
  ;
  (CS_LeanTouch.OnFingerTap)("-", self.__onFingerTap)
  UpdateManager:RemoveUpdate(self.__update__handle)
  for _,part in pairs(self._factoryParts) do
    (part.resloader):Put2Pool()
  end
  self._factoryParts = nil
  self.bind = nil
end

ActivityWhiteDaySceneCtrl.Delete = function(self)
  -- function num : 0_11
  self:OnExitWhiteDayScene()
end

return ActivityWhiteDaySceneCtrl

