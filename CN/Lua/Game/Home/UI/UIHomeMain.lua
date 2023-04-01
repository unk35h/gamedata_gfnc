-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHomeMain = class("UIHomeMain", UIBaseWindow)
local base = UIBaseWindow
local CS_OasisCameraController = CS.OasisCameraController
local CS_CmCoreState = ((CS.Cinemachine).CinemachineCore).Stage
local cs_GameObject = (CS.UnityEngine).GameObject
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_coroutine = require("XLua.Common.cs_coroutine")
local HomeAdjutant = require("Game.Home.HomeAdjutant")
local UINHomeUp = require("Game.Home.UI.UINHomeUp")
local UINHomeLeft = require("Game.Home.UI.UINHomeLeft")
local UINHomeRight = require("Game.Home.UI.UINHomeRight")
local JumpManager = require("Game.Jump.JumpManager")
local COST_TIME_RATE = 0.4
local TOUCH_DIFF = ((UIManager.csUIManager).BackgroundStretchSize).x * 0.3
local L2D_ENTER_X = 5
local PIC_ENTER_X = 10000
local RESET_POS_TIME = 0.2
UIHomeMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_GameObject, CS_OasisCameraController, CS_CmCoreState, HomeAdjutant, UINHomeUp, UINHomeLeft, UINHomeRight, CS_LeanTouch
  self.resloader = ((CS.ResLoader).Create)()
  self.homeController = ControllerManager:GetController(ControllerTypeId.HomeController, true)
  self.fakeCameraHome = (cs_GameObject.Find)("FakeCameraHome")
  local camera = (self.fakeCameraHome):FindComponent(eUnityComponentID.Camera)
  self.__fakeCamera = camera
  self.canvas = (self.__fakeCamera):FindComponent("Canvas", eUnityComponentID.Canvas)
  self:OnScreenSizeChanged(true)
  self.fakeCameraHomeConstraint = (self.fakeCameraHome):GetComponent("PositionConstraint")
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.fakeCameraHomeConstraint).constraintActive = true
  self.fakeCameraHomeConstraintRotation = (self.fakeCameraHome):GetComponent("RotationConstraint")
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.fakeCameraHomeConstraintRotation).constraintActive = true
  self.bind = {}
  ;
  (UIUtil.LuaUIBindingTable)((CS_OasisCameraController.Instance).transform, self.bind)
  self.home2SectorVCBody = ((self.bind).toSectorVHomeCam):GetCinemachineComponent(CS_CmCoreState.Body)
  self.home2OasisCamVCBody = ((self.bind).toOasiaVHomeCam):GetCinemachineComponent(CS_CmCoreState.Body)
  self.__OnAdjutantCompleted = BindCallback(self, self.OnAdjutantCompleted)
  self.homeAdjutant = (HomeAdjutant.New)()
  ;
  (self.homeAdjutant):InitHomeAdjutant(self.bind, (self.bind).emptyHolder, self.__OnAdjutantCompleted)
  self.homeUpNdoe = (UINHomeUp.New)()
  ;
  (self.homeUpNdoe):Init((self.ui).obj_upper)
  ;
  (self.homeUpNdoe):InitHomeUpNode(self)
  self.homeLeftNode = (UINHomeLeft.New)()
  ;
  (self.homeLeftNode):Init((self.ui).obj_left)
  ;
  (self.homeLeftNode):InitHomeLeftNode(self)
  self.homeRightNode = (UINHomeRight.New)()
  ;
  (self.homeRightNode):Init((self.ui).obj_right)
  ;
  (self.homeRightNode):InitHomeRightNode(self)
  local eventTrigger = ((CS.EventTriggerListener).Get)(((self.ui).scrollRect_pageList).gameObject)
  eventTrigger:onBeginDrag("+", BindCallback(self, self.OnBeginDragRight))
  eventTrigger:onEndDrag("+", BindCallback(self, self.OnEndDragRight))
  self.__OnUpdateHome = BindCallback(self, self.OnUpdateHome)
  UpdateManager:AddUpdate(self.__OnUpdateHome)
  if isEditorMode and ((CS.GMController).Instance).battleShortcut and ExplorationManager:HasUncompletedEp() then
    ExplorationManager:ContinueLastExploration()
  end
  GuideManager:TryTriggerGuide(eGuideCondition.FInHome)
  ;
  (self.homeController):OnInitHomeUI()
  self:RefreshHomeMainBg()
  self.__isUnfold = false
  self.__flag = 1
  self.__OnScreenSizeChanged = BindCallback(self, self.OnScreenSizeChanged)
  MsgCenter:AddListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  self.__RefreshHomeMainBgCallback = BindCallback(self, self.RefreshHomeMainBg)
  MsgCenter:AddListener(eMsgEventId.AdjCustomModify, self.__RefreshHomeMainBgCallback)
  MsgCenter:AddListener(eMsgEventId.AdjCustomChange, self.__RefreshHomeMainBgCallback)
  self.__OnFingerDownCallback = BindCallback(self, self.__OnFingerDown)
  self.__OnFingerUpCallback = BindCallback(self, self.__OnFingerUp)
  ;
  (CS_LeanTouch.OnFingerDown)("+", self.__OnFingerDownCallback)
  ;
  (CS_LeanTouch.OnFingerUp)("+", self.__OnFingerUpCallback)
  self._defaultL2dParentPos = (((self.bind).live2DRoot).transform).localPosition
  self._defaultPicParentPos = (((self.bind).heroHolder).transform).localPosition
end

UIHomeMain.OnScreenSizeChanged = function(self, force)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  if (self.homeController):IsNormalState() or force then
    (self.__fakeCamera).enabled = true
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.__fakeCamera).enabled = false
    self:AlignToFakeCamera(self.__fakeCamera, self.__fakeCamera)
    self.__fakeCameraPos = ((self.fakeCameraHome).transform).position
  end
end

UIHomeMain.OnShow = function(self, isFromOasis)
  -- function num : 0_2 , upvalues : _ENV, base
  (self.homeController):OnShowHomeUI(isFromOasis)
  ;
  (self.homeUpNdoe):OnHomeShow()
  ;
  (self.homeLeftNode):OnHomeShow()
  ;
  (self.homeRightNode):OnHomeShow()
  if isFromOasis then
    TimerManager:StartTimer(0.4, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R0 in 'UnsetPending'

    if not IsNull(self.fakeCameraHomeConstraint) then
      (self.fakeCameraHomeConstraint).weight = 1
    end
  end
, nil, true)
  end
  ;
  (((self.ui).scrollRect_pageList).onValueChanged):AddListener(BindCallback(self, self.OnValueChange))
  ;
  (base.OnShow)(self)
end

UIHomeMain.ShowTween = function(self)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).canvasGroup).alpha = 0
  ;
  (((self.ui).canvasGroup):DOFade(1, 0.5)):SetLink(((self.ui).canvasGroup).gameObject)
end

UIHomeMain.m_SetMainCameraEnabled = function(self, enabled)
  -- function num : 0_4 , upvalues : CS_OasisCameraController
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((CS_OasisCameraController.Instance).MainCamera).enabled = enabled
end

UIHomeMain.SetFrom2Home = function(self, from, playReturnHomeCv)
  -- function num : 0_5 , upvalues : _ENV, JumpManager
  if from == AreaConst.Sector or from == AreaConst.FactoryDorm then
    self.__flag = 1
    if ((self.bind).homeToSectorGo).activeInHierarchy then
      (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
      ;
      ((self.bind).homeToSectorGo):SetActive(true)
      ;
      ((self.bind).homeToOasisGo):SetActive(false)
      ;
      ((self.bind).homeToMenuGo):SetActive(false)
      self.__curVCBody = self.home2SectorVCBody
      self:PlaySectorTimeLine(from)
    end
  else
    if from == AreaConst.Oasis then
      self.__flag = -1
      ;
      ((self.bind).homeToSectorGo):SetActive(false)
      ;
      ((self.bind).homeToOasisGo):SetActive(true)
      ;
      ((self.bind).homeToMenuGo):SetActive(false)
      self.__curVCBody = self.home2OasisCamVCBody
      ;
      (self.homeController):ResetHomeMainBg()
    else
      ;
      (self.homeController):ResetHomeMainBg()
    end
  end
  if playReturnHomeCv then
    if JumpManager:IsHaveBack2Home() then
      return 
    end
    if JumpManager.isJumping then
      return 
    end
    if not (self.homeController):TryPlayVoReturnHome() then
      self.__playReturnHomeCv = true
    end
  end
end

UIHomeMain.SetTo = function(self, to)
  -- function num : 0_6 , upvalues : _ENV
  if to == AreaConst.Sector or to == AreaConst.FactoryDorm then
    ((self.bind).homeToSectorGo):SetActive(true)
    ;
    ((self.bind).homeToOasisGo):SetActive(false)
    ;
    ((self.bind).homeToMenuGo):SetActive(false)
    self.__curVCBody = self.home2SectorVCBody
  else
    if to == AreaConst.Oasis then
      ((self.bind).homeToSectorGo):SetActive(false)
      ;
      ((self.bind).homeToOasisGo):SetActive(true)
      ;
      ((self.bind).homeToMenuGo):SetActive(false)
      self.__curVCBody = self.home2OasisCamVCBody
    end
  end
end

UIHomeMain.RefreshHomeMainBg = function(self)
  -- function num : 0_7
  if self.homeController == nil then
    return 
  end
  ;
  (self.homeController):RefreshHomeMainBg()
end

UIHomeMain.OpenOtherWin = function(self)
  -- function num : 0_8
  self:m_SetMainCameraEnabled(false)
  ;
  (self.homeAdjutant):HideBordGirl()
  self:Hide()
end

UIHomeMain.OpenOtherWinWithMainCamera = function(self)
  -- function num : 0_9
  (self.homeAdjutant):HideBordGirl()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvsGroup_root).alpha = 0.3
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvsGroup_root).interactable = false
end

UIHomeMain.OpenOtherCoverWin = function(self)
  -- function num : 0_10
  (self.homeController):OnCoverHomeUI()
end

UIHomeMain.HideBordGirl = function(self)
  -- function num : 0_11
  (self.homeAdjutant):HideBordGirl()
end

UIHomeMain.BackFromOtherWin = function(self)
  -- function num : 0_12 , upvalues : _ENV
  AudioManager:PlayAudioById(1089)
  self:m_SetMainCameraEnabled(true)
  ;
  (self.homeAdjutant):ShowBordGirl()
  self:Show()
end

UIHomeMain.BackFromOtherCoverWin = function(self)
  -- function num : 0_13
  (self.homeController):OnShowHomeUI()
end

UIHomeMain.BackFromOtherWinWithMainCamera = function(self)
  -- function num : 0_14
  (self.homeAdjutant):ShowBordGirl()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvsGroup_root).alpha = 1
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvsGroup_root).interactable = true
end

UIHomeMain.ShowBordGirl = function(self)
  -- function num : 0_15
  (self.homeAdjutant):ShowBordGirl()
end

UIHomeMain.SetHomeShowMainUI = function(self, bool)
  -- function num : 0_16
  if bool then
    (self.homeUpNdoe):Show()
    ;
    (self.homeLeftNode):Show()
    ;
    (self.homeRightNode):Show()
  else
    ;
    (self.homeUpNdoe):Hide()
    ;
    (self.homeLeftNode):Hide()
    ;
    (self.homeRightNode):Hide()
  end
end

UIHomeMain.PlaySectorTimeLine = function(self, from)
  -- function num : 0_17 , upvalues : _ENV, JumpManager
  local timeline = nil
  if from == AreaConst.Sector then
    timeline = (self.bind).sectorPlayableDirector
  else
    timeline = (self.bind).factorydormPlayableDirector
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.homeController).isRewindingBack2HomeTimeLine = true
  self.__tlSectorCo = (TimelineUtil.Rewind)(timeline, function()
    -- function num : 0_17_0 , upvalues : self, _ENV, JumpManager
    self.__tlSectorCo = nil
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.homeController).isRewindingBack2HomeTimeLine = false
    ;
    (self.homeController):ResetHomeMainBg()
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R0 in 'UnsetPending'

    if not JumpManager:TryCallBack2HomeMsgFunc((UIUtil.backStack):Empty()) then
      (self.fakeCameraHomeConstraint).constraintActive = true
    end
  end
)
end

UIHomeMain.PauseEnterTimeLine = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.__tlSectorCo ~= nil then
    (TimelineUtil.StopTlCo)(self.__tlSectorCo)
    self.__tlSectorCo = nil
  end
end

UIHomeMain.PlayEnterTimeLine = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if self.__tlSectorCo ~= nil then
    (TimelineUtil.StopTlCo)(self.__tlSectorCo)
    self.__tlSectorCo = nil
  end
  self:PlaySectorTimeLine(AreaConst.Sector)
end

UIHomeMain.OnBeginDragRight = function(self, go, pointerEvent)
  -- function num : 0_20
  self.__couldUpdateList = false
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  if not (self.fakeCameraHomeConstraint).constraintActive then
    (self.fakeCameraHomeConstraint).constraintActive = true
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.fakeCameraHomeConstraint).weight = 1
end

UIHomeMain.OnEndDragRight = function(self, go, pointerEvent)
  -- function num : 0_21 , upvalues : _ENV, COST_TIME_RATE
  if ((self.ui).scrollRect_pageList).horizontalNormalizedPosition > 0.1 and not self.__isUnfold then
    self.__isUnfold = true
    AudioManager:PlayAudioById(1086)
  else
    if ((self.ui).scrollRect_pageList).horizontalNormalizedPosition < 0.9 and self.__isUnfold then
      self.__isUnfold = false
    end
  end
  self.__couldUpdateList = true
  self.currNPos = ((self.ui).scrollRect_pageList).horizontalNormalizedPosition
  self.passedTime = 0
  if self.__isUnfold then
    self.costTime = (1 - self.currNPos) * COST_TIME_RATE
  else
    self.costTime = self.currNPos * COST_TIME_RATE
  end
end

UIHomeMain.OnValueChange = function(self, _)
  -- function num : 0_22 , upvalues : _ENV
  if IsNull(self.gameObject) then
    return 
  end
  local rate = ((self.ui).scrollRect_pageList).horizontalNormalizedPosition
  ;
  (self.homeAdjutant):HomeRightUnfoldRate(rate)
  self:__vCameraUnfoldRate(rate)
  if self.homeRightNode ~= nil then
    (self.homeRightNode):UpdateHomeRightUnfoldRate(rate)
  end
end

UIHomeMain.OnAdjutantCompleted = function(self)
  -- function num : 0_23
  self:OnValueChange()
  if self.__playReturnHomeCv then
    self.__playReturnHomeCv = nil
    ;
    (self.homeController):TryPlayVoReturnHome()
  end
end

UIHomeMain.OnUpdateHome = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.__couldUpdateList then
    self.passedTime = self.passedTime + Time.deltaTime
    if self.costTime < self.passedTime then
      self:SetIsUnfold(self.__isUnfold)
      return 
    end
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

    if self.__isUnfold then
      ((self.ui).scrollRect_pageList).horizontalNormalizedPosition = self:__GetLerpedNum(self.currNPos, 1, self.passedTime / self.costTime)
    else
      -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).scrollRect_pageList).horizontalNormalizedPosition = self:__GetLerpedNum(self.currNPos, 0, self.passedTime / self.costTime)
    end
  end
end

UIHomeMain.SetIsUnfold = function(self, bool, forceSetCamera)
  -- function num : 0_25
  self.__isUnfold = bool
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if bool then
    ((self.ui).scrollRect_pageList).horizontalNormalizedPosition = 1
  else
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).scrollRect_pageList).horizontalNormalizedPosition = 0
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    if forceSetCamera then
      ((self.fakeCameraHome).transform).position = self.__fakeCameraPos
    end
  end
  self.__couldUpdateList = false
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  if self.__curVCBody ~= nil then
    (self.__curVCBody).m_XDamping = 0.2
  end
  ;
  (self.homeRightNode):OnHomeRightIsUnfold(bool)
end

UIHomeMain.__vCameraUnfoldRate = function(self, rate)
  -- function num : 0_26 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  if self.__curVCBody ~= nil then
    (self.__curVCBody).m_PathOffset = (Vector3.New)(-2 * rate * self.__flag, 0, 0)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.__curVCBody).m_XDamping = 0
  end
end

UIHomeMain.__GetLerpedNum = function(self, sV, eV, rate)
  -- function num : 0_27
  rate = rate - 1
  eV = eV - sV
  return (eV) * ((rate) * (rate) * (rate) * (rate) * (rate) + 1) + sV
end

UIHomeMain.SwitchUnfold = function(self)
  -- function num : 0_28 , upvalues : COST_TIME_RATE, _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  if not (self.fakeCameraHomeConstraint).constraintActive then
    (self.fakeCameraHomeConstraint).constraintActive = true
  end
  self.__isUnfold = not self.__isUnfold
  self.__couldUpdateList = true
  self.currNPos = ((self.ui).scrollRect_pageList).horizontalNormalizedPosition
  self.passedTime = 0
  if self.__isUnfold then
    self.costTime = (1 - self.currNPos) * COST_TIME_RATE
    AudioManager:PlayAudioById(1086)
  else
    self.costTime = self.currNPos * COST_TIME_RATE
  end
  return self.__isUnfold
end

UIHomeMain.__CheckFinger = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if GuideManager.inGuide or self._isAutoMoving or self.__isUnfold then
    return false
  end
  if not (self.homeController):IsNormalState() then
    return 
  end
  if not (self.gameObject).activeInHierarchy or ((self.ui).canvsGroup_root).alpha ~= 1 then
    return false
  end
  if (PlayerDataCenter.allAdjCustomData):HasAdjPresetCount() == 1 then
    return false
  end
  return true
end

UIHomeMain.__OnFingerDown = function(self, finger)
  -- function num : 0_30 , upvalues : CS_coroutine, CS_LeanTouch, _ENV
  if not self:__CheckFinger() then
    return 
  end
  if self._chageCoroutine ~= nil then
    (CS_coroutine.stop)(self._chageCoroutine)
    self._chageCoroutine = nil
  end
  if finger.IsOverGui then
    local raycastResults = (CS_LeanTouch.RaycastGui)(finger.ScreenPosition)
    for i = 0, raycastResults.Count - 1 do
      local raycastResult = raycastResults[i]
      if ((raycastResult.gameObject).transform).parent ~= ((self.bind).heroHolder).transform then
        return 
      end
    end
  end
  do
    self._leanTouchIndex = finger.Index
    self._startScreenPos = finger.ScreenPosition
    self._startL2dOriPos = TransitionScreenPoint(UIManager:GetMainCamera(), ((self.bind).live2DRoot).gameObject, self._startScreenPos)
    self._startPicOriPos = TransitionScreenPoint(UIManager:GetMainCamera(), ((self.bind).heroHolder).gameObject, self._startScreenPos)
  end
end

UIHomeMain.__OnFingerUp = function(self, finger)
  -- function num : 0_31 , upvalues : _ENV, TOUCH_DIFF
  if finger.Index ~= self._leanTouchIndex then
    return 
  end
  self._leanTouchIndex = nil
  self._startL2dOriPos = nil
  self._startPicOriPos = nil
  if not self:__CheckFinger() then
    self._startScreenPos = nil
    self:__AdjHolderReset()
    return 
  end
  local diffX = (finger.ScreenPosition).x - (self._startScreenPos).x
  self._startScreenPos = nil
  local selectAdjId = nil
  local curAdjIndex = (PlayerDataCenter.allAdjCustomData):GetUsingAdjCustomPresetId()
  if TOUCH_DIFF < diffX then
    for i = curAdjIndex - 1, 1, -1 do
      if (PlayerDataCenter.allAdjCustomData):GetAdjCustomPresetData(i) ~= nil then
        selectAdjId = i
        break
      end
    end
    do
      if selectAdjId == nil then
        for i = (ConfigData.game_config).adjCustomTeamMax, curAdjIndex, -1 do
          if (PlayerDataCenter.allAdjCustomData):GetAdjCustomPresetData(i) ~= nil then
            selectAdjId = i
            break
          end
        end
      end
      do
        if diffX < -TOUCH_DIFF then
          for i = curAdjIndex + 1, (ConfigData.game_config).adjCustomTeamMax do
            if (PlayerDataCenter.allAdjCustomData):GetAdjCustomPresetData(i) ~= nil then
              selectAdjId = i
              break
            end
          end
          do
            if selectAdjId == nil then
              for i = 1, curAdjIndex do
                if (PlayerDataCenter.allAdjCustomData):GetAdjCustomPresetData(i) ~= nil then
                  selectAdjId = i
                  break
                end
              end
            end
            do
              if selectAdjId ~= nil then
                self._isAutoMoving = true
                local network = NetworkManager:GetNetwork(NetworkTypeID.AdjCustom)
                network:CS_MainInterface_PresetChange(selectAdjId, function()
    -- function num : 0_31_0 , upvalues : _ENV, self, diffX
    if IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.fakeCameraHomeConstraint).constraintActive = false
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.fakeCameraHomeConstraintRotation).constraintActive = false
    self:__NewAdjChangeEnter(diffX < 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
              end
            end
          end
        end
      end
    end
  end
end

UIHomeMain.__OnFingerDrag = function(self, fingerList)
  -- function num : 0_32
end

UIHomeMain.__NewAdjChangeEnter = function(self, isMoveNextAdj)
  -- function num : 0_33 , upvalues : CS_coroutine, _ENV, L2D_ENTER_X, PIC_ENTER_X
  local ratio = isMoveNextAdj and 1 or -1
  if not (self.homeController).homeCurrAdjutantLoaded then
    (self.homeAdjutant):HideBordGirl()
    self._chageCoroutine = (CS_coroutine.start)(function()
    -- function num : 0_33_0 , upvalues : self, _ENV, ratio, L2D_ENTER_X, PIC_ENTER_X
    while not (self.homeController).homeCurrAdjutantLoaded do
      (coroutine.yield)(nil)
    end
    self._chageCoroutine = nil
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.bind).canvasGroup_heroHolder).alpha = 0
    local l2dvec = (((self.bind).live2DRoot).transform).localPosition
    l2dvec.x = ratio * L2D_ENTER_X
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.bind).live2DRoot).transform).localPosition = l2dvec
    local picvec = (((self.bind).heroHolder).transform).localPosition
    picvec.x = ratio * PIC_ENTER_X
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.bind).heroHolder).transform).localPosition = picvec
    ;
    (self.homeAdjutant):ShowBordGirl()
    self:__AdjHolderReset()
  end
)
  else
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.bind).canvasGroup_heroHolder).alpha = 0
    local l2dvec = (((self.bind).live2DRoot).transform).localPosition
    l2dvec.x = ratio * L2D_ENTER_X
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (((self.bind).live2DRoot).transform).localPosition = l2dvec
    local picvec = (((self.bind).heroHolder).transform).localPosition
    picvec.x = ratio * PIC_ENTER_X
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.bind).heroHolder).transform).localPosition = picvec
    self:__AdjHolderReset()
  end
end

UIHomeMain.__AdjHolderReset = function(self)
  -- function num : 0_34 , upvalues : _ENV, CS_coroutine, RESET_POS_TIME
  local curTime = Time.realtimeSinceStartup
  local l2dPosDiff = self._defaultL2dParentPos - (((self.bind).live2DRoot).transform).localPosition
  local picPosDiff = self._defaultPicParentPos - (((self.bind).heroHolder).transform).localPosition
  local alphaDiff = 1 - ((self.bind).canvasGroup_heroHolder).alpha
  self._chageCoroutine = (CS_coroutine.start)(function()
    -- function num : 0_34_0 , upvalues : _ENV, curTime, RESET_POS_TIME, l2dPosDiff, picPosDiff, alphaDiff, self
    while Time.realtimeSinceStartup < curTime + RESET_POS_TIME do
      local ratio = (Time.realtimeSinceStartup - curTime) / RESET_POS_TIME
      local addtionL2dPos = l2dPosDiff * (1 - ratio)
      local addtionPicPos = picPosDiff * (1 - ratio)
      local addtionAlpha = alphaDiff * (1 - ratio)
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (((self.bind).live2DRoot).transform).localPosition = self._defaultL2dParentPos - addtionL2dPos
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (((self.bind).heroHolder).transform).localPosition = self._defaultPicParentPos - addtionPicPos
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.bind).canvasGroup_heroHolder).alpha = 1 - addtionAlpha
      ;
      (coroutine.yield)(nil)
    end
    do
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (((self.bind).live2DRoot).transform).localPosition = self._defaultL2dParentPos
      -- DECOMPILER ERROR at PC52: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (((self.bind).heroHolder).transform).localPosition = self._defaultPicParentPos
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.bind).canvasGroup_heroHolder).alpha = 1
      self._isAutoMoving = false
      self._chageCoroutine = nil
      -- DECOMPILER ERROR at PC59: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.fakeCameraHomeConstraint).constraintActive = true
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.fakeCameraHomeConstraintRotation).constraintActive = true
    end
  end
)
end

UIHomeMain.GetHomeMainL2dParent = function(self)
  -- function num : 0_35
  return (self.bind).live2DRoot, (self.bind).canvas_canvasGroup
end

UIHomeMain.GetHomeMainPicParent = function(self)
  -- function num : 0_36
  return (self.bind).heroHolder
end

UIHomeMain.OnHide = function(self)
  -- function num : 0_37 , upvalues : _ENV, base
  (self.homeRightNode):OnHomeHide()
  ;
  (self.homeController):OnHideHomeUI()
  ;
  (((self.ui).scrollRect_pageList).onValueChanged):RemoveListener(BindCallback(self, self.OnValueChange))
  ;
  (base.OnHide)(self)
end

UIHomeMain.OnDelete = function(self)
  -- function num : 0_38 , upvalues : _ENV, CS_LeanTouch, CS_coroutine, base
  MsgCenter:RemoveListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  MsgCenter:RemoveListener(eMsgEventId.AdjCustomModify, self.__RefreshHomeMainBgCallback)
  MsgCenter:RemoveListener(eMsgEventId.AdjCustomChange, self.__RefreshHomeMainBgCallback)
  ;
  (CS_LeanTouch.OnFingerDown)("-", self.__OnFingerDownCallback)
  ;
  (CS_LeanTouch.OnFingerUp)("-", self.__OnFingerUpCallback)
  if self._chageCoroutine ~= nil then
    (CS_coroutine.stop)(self._chageCoroutine)
    self._chageCoroutine = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.homeController):OnDeleteHomeUI()
  if self.__tlSectorCo ~= nil then
    (TimelineUtil.StopTlCo)(self.__tlSectorCo)
    self.__tlSectorCo = nil
  end
  if self.homeUpNdoe ~= nil then
    (self.homeUpNdoe):Delete()
  end
  if self.homeLeftNode ~= nil then
    (self.homeLeftNode):Delete()
  end
  if self.homeRightNode ~= nil then
    (self.homeRightNode):Delete()
  end
  if self.homeAdjutant ~= nil then
    (self.homeAdjutant):Delete()
    self.homeAdjutant = nil
  end
  UpdateManager:RemoveUpdate(self.__OnUpdateHome)
  ;
  (base.OnDelete)(self)
end

return UIHomeMain

