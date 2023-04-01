-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsController = class("SmashingPenguinsController", ControllerBase)
local base = ControllerBase
local SmashingPenguinsMapCtrl = require("Game.TinyGames.SmashingPenguins.Ctrl.SmashingPenguinsMapCtrl")
local SmashingPenguinsCamCtrl = require("Game.TinyGames.SmashingPenguins.Ctrl.SmashingPenguinsCamCtrl")
local TinyGameFrameController = require("Game.TinyGames.TinyGameFrameController")
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
local SmashingPenguinsEnum = require("Game.TinyGames.SmashingPenguins.Enum.SmashingPenguinsEnum")
local SmashingPenguinsGameState = SmashingPenguinsEnum.eGameState
local SmashingPenguinsCharacterAnimState = SmashingPenguinsEnum.eCharacterAnimState
local CS_GameObject = (CS.UnityEngine).GameObject
local tinyGameEnum = require("Game.TinyGames.TinyGameEnum")
local EnterGameStateFunc = {[SmashingPenguinsGameState.Init] = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_GameObject, TinyGameFrameController, SmashingPenguinsMapCtrl, SmashingPenguinsCamCtrl
  self.__camMain = UIManager:GetMainCamera()
  self.__lightMain = (CS_GameObject.FindWithTag)(TagConsts.MainLight)
  self.frameCtrl = (TinyGameFrameController.New)()
  self.ctrls = {}
  self.smashingPenguinsMapCtrl = (SmashingPenguinsMapCtrl.New)(self)
  self.smashingPenguinsCamCtrl = (SmashingPenguinsCamCtrl.New)(self)
  self.netWork = NetworkManager:GetNetwork(NetworkTypeID.FlappyBird)
  self.__OnRenderFrameUpdate = BindCallback(self, self.OnRenderFrameUpdate)
  self.__OnLogicFrameUpdate = BindCallback(self, self.OnLogicFrameUpdate)
end
, [SmashingPenguinsGameState.GameReady] = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if IsNull(self.playUI) then
    return 
  end
  ;
  (self.playUI):HideAllRes()
  ;
  (self.playUI):RefreshHighestScore(self.maxScore)
  self:FirstRewardInit()
  if IsNull(self.bgm) then
    self.bgm = AudioManager:PlayAudioById(3301)
  end
  for _,ctrl in ipairs(self.ctrls) do
    ctrl:OnGamePrepare()
  end
  self.lowSpeedFrameCount = 0
  self.isGamePause = false
  self.reGetBombs = {}
  self.getBomb = false
  self.currentScore = 0
  self.logicFrameNum = 0
  self:SetIsAllowShowUseBombBtn(false)
  ;
  (self._mainCharacter):Hide()
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self._mainCharacter).rigidbody).velocity = Vector3.zero
  ;
  (self.smashingPenguinsCamCtrl):FollowTargetPos(self._mainCharacter)
end
, [SmashingPenguinsGameState.GameStart] = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if IsNull(self.playUI) then
    return 
  end
  ;
  (self.playUI):ShowInGameUI()
  ;
  (self.playUI):SetTrackerShow(false)
  ;
  ((self.playUI).gestureGuideImage):SetActive(false)
  for _,ctrl in ipairs(self.ctrls) do
    ctrl:OnGameStart()
  end
  local startMapBlock = (self.smashingPenguinsMapCtrl):GetStartMapBlock(self._mainCharacter, self)
  ;
  (self._mainCharacter):Show()
  ;
  (self._mainCharacter):InitEntityData(self._mainCharacter, self)
  ;
  (self._mainCharacter):SetSmashingPenguinsColliderEnabled(true)
  ;
  (self.frameCtrl):StartRunning(self.__OnLogicFrameUpdate, self.__OnRenderFrameUpdate)
  self:SetIsAllowShowUseBombBtn(true)
end
, [SmashingPenguinsGameState.PrepareToFly] = function(self)
  -- function num : 0_3 , upvalues : _ENV, SmashingPenguinsCharacterAnimState
  (self.playUI):SetTrackerShow(false)
  ;
  ((self.playUI).gestureGuideImage):SetActive(false)
  if self._guideTimer ~= nil then
    TimerManager:StopTimer(self._guideTimer)
    self._guideTimer = nil
  end
  self._guideTimer = TimerManager:StartTimer(3, function()
    -- function num : 0_3_0 , upvalues : self
    if self._currentCannon ~= nil then
      ((self.playUI).gestureGuideImage):SetActive(true)
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (((self.playUI).gestureGuideImage).transform).position = ((self._currentCannon).transform).position
    end
  end
)
  ;
  (self._mainCharacter):SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Cry)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self._mainCharacter).rigidbody).velocity = Vector3.zero
  ;
  (self._mainCharacter):SetSmashingPenguinsColliderEnabled(false)
end
, [SmashingPenguinsGameState.Fly] = function(self)
  -- function num : 0_4
  self:SetIsAllowShowUseBombBtn(true)
  ;
  (self.playUI):SetTrackerShow(false)
  ;
  ((self.playUI).gestureGuideImage):SetActive(false)
end
, [SmashingPenguinsGameState.CharacterDie] = function(self)
  -- function num : 0_5 , upvalues : _ENV, SmashingPenguinsEnum
  if not IsNull(self.bgm) then
    AudioManager:StopAudioByBack(self.bgm)
    self.bgm = nil
  end
  AudioManager:PlayAudioById(1282)
  ;
  (self.playUI):SetTrackerShow(false)
  ;
  ((self.playUI).gestureGuideImage):SetActive(false)
  ;
  (self.frameCtrl):StopRunning()
  if self.playUI == nil then
    return 
  end
  ;
  (self.playUI):OnCharacterDie()
  ;
  (self._mainCharacter):SetSmashingPenguinsAnimState((SmashingPenguinsEnum.eCharacterAnimState).Cry)
end
, [SmashingPenguinsGameState.GameEnd] = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for _,ctrl in ipairs(self.ctrls) do
    ctrl:OnGameEnd()
  end
  if self:GetIsSmashingPenguinsActOver() then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6033))
    local fakeMsg = {}
    fakeMsg.score = self.currentScore
    fakeMsg.beyondProgress = 0
    ;
    (self.playUI):ShowSmashingPenguinsResult(fakeMsg, table.emptytable, self.maxScore, self.hasGettedJoinReward, true)
    return 
  else
    do
      self:__ReqSmashingPenguinsSettle(self.logicFrameNum)
    end
  end
end
}
SmashingPenguinsController.InjectModifyMsgAction = function(self, setMaxScoreAction, setHasGettedJoinRewardAction)
  -- function num : 0_7
  self.__setMaxScore = setMaxScoreAction
  self.__setGettedJoinRewardAction = setHasGettedJoinRewardAction
end

SmashingPenguinsController.SetSmashingPenguinsActEndTime = function(self, endTime)
  -- function num : 0_8
  self.endTime = endTime
end

SmashingPenguinsController.GetIsSmashingPenguinsActOver = function(self)
  -- function num : 0_9 , upvalues : _ENV
  do return self.endTime or 0 <= PlayerDataCenter.timestamp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SmashingPenguinsController.ShowSmashingPenguinUIMain = function(self, activityFwId, miniGameConfigId, hasGettedJoinReward, maxScore, closeCallback)
  -- function num : 0_10 , upvalues : _ENV, SmashingPenguinsGameState
  if self:GetIsSmashingPenguinsActOver() then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6033))
    return 
  end
  AudioManager:RecordCurBgm()
  self.activityFwId = activityFwId
  self.miniGameConfigId = miniGameConfigId
  self.hasGettedJoinReward = hasGettedJoinReward
  self.maxScore = maxScore
  self:SetSmashingPenguinsGameState(SmashingPenguinsGameState.Init)
  ;
  (self.netWork):CS_FlappyBird_ProgressDetail(self.activityFwId, self.miniGameConfigId, function(objList)
    -- function num : 0_10_0 , upvalues : _ENV, self, closeCallback
    if objList.Count <= 0 then
      error("CS_FlappyBird_SelfRankDetail objList.Count:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    self:__InternalShowSmashingPenguinsUI(msg.progress, self.maxScore, closeCallback)
  end
)
end

SmashingPenguinsController.__InternalShowSmashingPenguinsUI = function(self, progress, maxScore, closeCallback)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SmashingPenguins, function(window)
    -- function num : 0_11_0 , upvalues : self, progress, maxScore, closeCallback
    if window ~= nil then
      self:EnableMainCamAndLight(false)
      self.playUI = window
      window:InitSmashingPenguinsMain()
      if progress ~= nil then
        window:ShowSmashingPenguinsProgress(progress, self.miniGameConfigId, self.hasGettedJoinReward)
      end
      window:RefreshHighestScore(maxScore)
      window:SetGameEndTime(self.endTime)
      window:SetCloseCallback(closeCallback)
    end
  end
)
end

SmashingPenguinsController.EnableMainCamAndLight = function(self, enable)
  -- function num : 0_12 , upvalues : _ENV
  if not IsNull(self.__camMain) then
    ((self.__camMain).gameObject):SetActive(enable)
  end
  if not IsNull(self.__lightMain) then
    (self.__lightMain):SetActive(enable)
  end
end

SmashingPenguinsController.FirstRewardInit = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local rewardList = ((ConfigData.flappy_bird)[self.miniGameConfigId]).firstAwards
  self.itemTransDic = {}
  self.firstRewardDic = {}
  for i,v in pairs(rewardList) do
    local itemCfg = (ConfigData.item)[v.itemId]
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.firstRewardDic)[v.itemId] = v.count
    if itemCfg.overflow_type == eItemTransType.actMoneyX then
      local num = PlayerDataCenter:GetItemOverflowNum(v.itemId, v.count)
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R9 in 'UnsetPending'

      if num ~= 0 then
        (self.itemTransDic)[v.itemId] = num
      end
    end
  end
end

SmashingPenguinsController.GetSmashingPenguinsCharacter = function(self)
  -- function num : 0_14
  return self._mainCharacter
end

SmashingPenguinsController.SetSmashingPenguinsCharacter = function(self, characterEntity)
  -- function num : 0_15
  self._mainCharacter = characterEntity
end

SmashingPenguinsController.GetSmashingPenguinsCannon = function(self)
  -- function num : 0_16
  return self._currentCannon
end

SmashingPenguinsController.SetSmashingPenguinsCannon = function(self, cannon)
  -- function num : 0_17 , upvalues : _ENV
  self._currentCannon = cannon
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._mainCharacter).canLookAtDir = true
  ;
  (self._mainCharacter):LookAtDir(Vector3.left, true)
end

SmashingPenguinsController.GetSmashingPenguinsGameState = function(self)
  -- function num : 0_18
  return self._currentGameState
end

SmashingPenguinsController.SetSmashingPenguinsGameState = function(self, newState)
  -- function num : 0_19 , upvalues : EnterGameStateFunc
  if self._currentGameState == newState then
    return 
  end
  self._currentGameState = newState
  if EnterGameStateFunc[newState] ~= nil then
    (EnterGameStateFunc[newState])(self)
  end
end

SmashingPenguinsController.ClearSmashingPenguinsGameState = function(self)
  -- function num : 0_20
  if (self.frameCtrl):GetIsRunning() then
    (self.frameCtrl):StopRunning()
  end
  self._currentGameState = nil
end

SmashingPenguinsController.ReadySmashingPenguins = function(self)
  -- function num : 0_21 , upvalues : SmashingPenguinsGameState
  self:SetSmashingPenguinsGameState(SmashingPenguinsGameState.GameReady)
end

SmashingPenguinsController.StartSmashingPenguins = function(self)
  -- function num : 0_22 , upvalues : SmashingPenguinsGameState
  self:SetSmashingPenguinsGameState(SmashingPenguinsGameState.GameStart)
end

SmashingPenguinsController.RestartSmashingPenguins = function(self)
  -- function num : 0_23
  if (self.frameCtrl):GetIsRunning() then
    (self.frameCtrl):StopRunning()
  end
  self:ReadySmashingPenguins()
  self:StartSmashingPenguins()
end

SmashingPenguinsController.EndSmashingPenguins = function(self)
  -- function num : 0_24 , upvalues : SmashingPenguinsGameState
  self:SetSmashingPenguinsGameState(SmashingPenguinsGameState.CharacterDie)
end

SmashingPenguinsController.SmashingPenguinsResult = function(self)
  -- function num : 0_25 , upvalues : SmashingPenguinsGameState
  self:SetSmashingPenguinsGameState(SmashingPenguinsGameState.GameEnd)
end

SmashingPenguinsController.OnExitSmashingPenguins = function(self)
  -- function num : 0_26 , upvalues : _ENV
  self:EnableMainCamAndLight(true)
  if not IsNull(self.bgm) then
    AudioManager:StopAudioByBack(self.bgm)
    self.bgm = nil
  end
  if not IsNull(self.dragAudio) then
    AudioManager:StopAudioByBack(self.dragAudio)
    self.dragAudio = nil
  end
  AudioManager:ResumeLastBgm()
  if (self.frameCtrl):GetIsRunning() then
    (self.frameCtrl):StopRunning()
  end
  if self._guideTimer ~= nil then
    TimerManager:StopTimer(self._guideTimer)
    self._guideTimer = nil
  end
  self:Delete()
end

SmashingPenguinsController.ReqShowRanking = function(self)
  -- function num : 0_27
  self:__ReqShowRanking()
end

SmashingPenguinsController.OnGestureStart = function(self, finger)
  -- function num : 0_28 , upvalues : SmashingPenguinsEnum, _ENV
  if self.isGamePause then
    self.dragStartPos = nil
    return 
  end
  if self._currentGameState ~= (SmashingPenguinsEnum.eGameState).PrepareToFly then
    self.dragStartPos = nil
    return 
  end
  if self._mainCharacter == nil or self._currentCannon == nil then
    self.dragStartPos = nil
    return 
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._mainCharacter).canLookAtDir = true
  local pos = TransitionScreenPoint(UIManager:GetUICamera(), (self._mainCharacter).gameObject, finger.ScreenPosition)
  local leftX, rightX, downY, upY = (self._mainCharacter):GetLocalUnityBorder()
  if rightX < pos.x or pos.x < leftX or upY < pos.y or pos.y < downY then
    return 
  end
  ;
  ((self.playUI).gestureGuideImage):SetActive(false)
  self.dragAudio = AudioManager:PlayAudioById(1276)
  self._touchIndex = finger.Index
  self.dragStartPos = ((self._mainCharacter).transform).localPosition
  self.dragEndPos = nil
end

SmashingPenguinsController.OnGesture = function(self, fingerList)
  -- function num : 0_29 , upvalues : SmashingPenguinsEnum, _ENV, SmashingPenguinsConfig
  if self.isGamePause then
    self.dragStartPos = nil
    return 
  end
  if self._currentGameState ~= (SmashingPenguinsEnum.eGameState).PrepareToFly then
    self.dragStartPos = nil
    return 
  end
  if self._mainCharacter == nil or self._currentCannon == nil then
    self.dragStartPos = nil
    return 
  end
  local finger = nil
  for i = 0, fingerList.Count - 1 do
    local item = fingerList[i]
    if item.Index == self._touchIndex then
      finger = item
      break
    end
  end
  do
    if finger == nil then
      self.dragStartPos = nil
      return 
    end
    if self._guideTimer ~= nil then
      TimerManager:ResetTimer(self._guideTimer)
    end
    local pos = TransitionScreenPoint(UIManager:GetUICamera(), (self._mainCharacter).gameObject, finger.ScreenPosition)
    local fireVector = self.dragStartPos - pos
    local dragPower = (Vector2.Magnitude)(fireVector)
    do
      if SmashingPenguinsConfig.MaxCannonDragRange < dragPower then
        local dragDir = (Vector2.Normalize)(fireVector)
        fireVector = (Vector2.New)(dragDir.x * SmashingPenguinsConfig.MaxCannonDragRange, dragDir.y * SmashingPenguinsConfig.MaxCannonDragRange)
      end
      ;
      (self._mainCharacter):LookAtDir(fireVector, true)
      ;
      (self._currentCannon):LookAtDir(fireVector)
      ;
      (self._currentCannon):UpdateCannonLine(((self._mainCharacter).transform).position)
      -- DECOMPILER ERROR at PC95: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self._mainCharacter).transform).localPosition = self.dragStartPos - fireVector
    end
  end
end

SmashingPenguinsController.OnGestureEnd = function(self, finger)
  -- function num : 0_30 , upvalues : _ENV, SmashingPenguinsEnum, SmashingPenguinsConfig
  if not IsNull(self.dragAudio) then
    AudioManager:StopAudioByBack(self.dragAudio)
    self.dragAudio = nil
  end
  if self.isGamePause then
    self.dragStartPos = nil
    return 
  end
  if self._currentGameState ~= (SmashingPenguinsEnum.eGameState).PrepareToFly then
    self.dragStartPos = nil
    return 
  end
  if self._mainCharacter == nil or self._currentCannon == nil then
    self.dragStartPos = nil
    return 
  end
  if self._touchIndex ~= finger.Index then
    self.dragStartPos = nil
    return 
  end
  self._touchIndex = nil
  local pos = TransitionScreenPoint(UIManager:GetUICamera(), (self._mainCharacter).gameObject, finger.ScreenPosition)
  self.dragEndPos = pos
  if not IsNull(self.dragStartPos) and not IsNull(self.dragEndPos) then
    (self._currentCannon):UpdateCannonLine(((self._currentCannon).transform).position)
    local force = self.dragStartPos - self.dragEndPos
    local forceDir = force.normalized
    local forcePower = force.magnitude
    if SmashingPenguinsConfig.MinCannonDragRange <= forcePower then
      AudioManager:PlayAudioById(1277)
      ;
      (self.smashingPenguinsCamCtrl):SetFollowLimit(((self._currentCannon).transform).position, ((self._mainCharacter).transform).position)
      ;
      (self._mainCharacter):AddForceToSmashingPenguinsCharacter(forceDir, forcePower * SmashingPenguinsConfig.FirePowerMultiple, SmashingPenguinsConfig.MaxFirePower)
      self:SetSmashingPenguinsGameState((SmashingPenguinsEnum.eGameState).Fly)
      ;
      (self._currentCannon):SetConnonIsUsed()
      self._currentCannon = nil
      ;
      (self._mainCharacter):SetSmashingPenguinsUseGravity(true)
      ;
      (self._mainCharacter):SetSmashingPenguinsColliderEnabled(true)
      if self._guideTimer ~= nil then
        TimerManager:StopTimer(self._guideTimer)
        self._guideTimer = nil
      end
      ;
      ((self.playUI).gestureGuideImage):SetActive(false)
    else
      -- DECOMPILER ERROR at PC125: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self._mainCharacter).transform).position = ((self._currentCannon).transform).position
      ;
      (self._mainCharacter):LookAtDir(Vector3.left, true)
    end
  end
end

SmashingPenguinsController.OnRenderFrameUpdate = function(self, timeRate)
  -- function num : 0_31 , upvalues : SmashingPenguinsEnum, _ENV
  if self.isGamePause then
    return 
  end
  if self._currentGameState == (SmashingPenguinsEnum.eGameState).Fly and not IsNull(self._mainCharacter) then
    (self._mainCharacter):LookAtDir(((self._mainCharacter).rigidbody).velocity)
    ;
    (self.smashingPenguinsCamCtrl):FollowTargetPos(self._mainCharacter)
    ;
    (self.playUI):SetTrackerPos(((self._mainCharacter).transform).position)
  else
    if self._currentGameState == (SmashingPenguinsEnum.eGameState).PrepareToFly and not IsNull(self._currentCannon) then
      (self.smashingPenguinsCamCtrl):FollowTargetPos(self._currentCannon)
    end
  end
end

SmashingPenguinsController.OnLogicFrameUpdate = function(self, logicFrameNum)
  -- function num : 0_32 , upvalues : _ENV, SmashingPenguinsEnum, SmashingPenguinsConfig
  self.logicFrameNum = logicFrameNum
  if IsNull(self.playUI) then
    return 
  end
  ;
  (self.playUI):OnUpdateInGameUI()
  if self._currentGameState ~= (SmashingPenguinsEnum.eGameState).Fly or IsNull(self._mainCharacter) then
    return 
  end
  if self.isGamePause then
    return 
  end
  local characterLocalPosition = (((self.playUI).mapBlockHolder).transform):InverseTransformPoint(((self._mainCharacter).transform).position)
  local currentVelocity = ((self._mainCharacter).rigidbody).velocity
  self.currentScore = (math.floor)(-characterLocalPosition.x * SmashingPenguinsConfig.DistanceScoreMultiple)
  self.currentScore = (math.clamp)(self.currentScore, 0, self.currentScore)
  if (self._mainCharacter).isMovingToCannon then
    return 
  end
  if currentVelocity.x > 0 and SmashingPenguinsConfig.MaxXPos < characterLocalPosition.x then
    currentVelocity.x = -currentVelocity.x
  end
  if currentVelocity.y > 0 and SmashingPenguinsConfig.MaxYPos < characterLocalPosition.y then
    currentVelocity.y = -currentVelocity.y
  end
  -- DECOMPILER ERROR at PC78: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._mainCharacter).rigidbody).velocity = currentVelocity
  if SmashingPenguinsConfig.MinYPosShowTracker < characterLocalPosition.y then
    (self.playUI):SetTrackerShow(true)
  else
    ;
    (self.playUI):SetTrackerShow(false)
  end
  local sqrtSpeed = currentVelocity.sqrMagnitude
  local maxSqrtSpeed = (Mathf.Pow)(SmashingPenguinsConfig.MaxSpeed, 2)
  -- DECOMPILER ERROR at PC105: Confused about usage of register: R6 in 'UnsetPending'

  if maxSqrtSpeed < sqrtSpeed then
    ((self._mainCharacter).rigidbody).velocity = currentVelocity.normalized * SmashingPenguinsConfig.MaxSpeed
    currentVelocity = ((self._mainCharacter).rigidbody).velocity
    sqrtSpeed = maxSqrtSpeed
  end
  -- DECOMPILER ERROR at PC116: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._mainCharacter).canLookAtDir = SmashingPenguinsConfig.MinSqrtSpeedKeepDir < sqrtSpeed
  -- DECOMPILER ERROR at PC123: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._mainCharacter).canPlayCollisionAudio = SmashingPenguinsConfig.MinSqrtSpeedPlayCollisionAudio < sqrtSpeed
  ;
  (self._mainCharacter):UpdateSmashingPenguinsAnimState()
  if sqrtSpeed < SmashingPenguinsConfig.MinSqrtSpeedKeepRoll then
    (self._mainCharacter):SetSmashingPenguinsAnimState((SmashingPenguinsEnum.eCharacterAnimState).Cry)
    -- DECOMPILER ERROR at PC136: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self._mainCharacter).canPlayRollAnim = false
  else
    -- DECOMPILER ERROR at PC139: Confused about usage of register: R6 in 'UnsetPending'

    (self._mainCharacter).canPlayRollAnim = true
  end
  if sqrtSpeed < SmashingPenguinsConfig.MinSqrtSpeedKeepAlive then
    self.lowSpeedFrameCount = self.lowSpeedFrameCount + 1
    if SmashingPenguinsConfig.MaxLogicFrameNumSpeedKeepAlive < self.lowSpeedFrameCount then
      self:EndSmashingPenguins()
    end
  else
    self.lowSpeedFrameCount = 0
  end
  if characterLocalPosition.y < SmashingPenguinsConfig.MinYPosKeepAlive then
    self:EndSmashingPenguins()
  end
  ;
  (self.smashingPenguinsMapCtrl):UpdateSmashingPenguinsMapBlocks(self._mainCharacter, self)
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

SmashingPenguinsController.SetSmashingPenguinsGamePause = function(self, isPause)
  -- function num : 0_33 , upvalues : _ENV
  if self.isGamePause == isPause then
    return 
  end
  self.isGamePause = isPause
  if isPause then
    local gamePauseData = {}
    self.gamePauseData = gamePauseData
    gamePauseData.characterVelocity = ((self._mainCharacter).rigidbody).velocity
    gamePauseData.characterGravityScale = ((self._mainCharacter).rigidbody).gravityScale
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self._mainCharacter).rigidbody).velocity = Vector2.zero
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self._mainCharacter).rigidbody).gravityScale = 0
  else
    do
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self._mainCharacter).rigidbody).velocity = (self.gamePauseData).characterVelocity
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self._mainCharacter).rigidbody).gravityScale = (self.gamePauseData).characterGravityScale
      self.gamePauseData = nil
    end
  end
end

SmashingPenguinsController.ReGetBomb = function(self, bombEntity)
  -- function num : 0_34
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.reGetBombs)[bombEntity] = true
end

SmashingPenguinsController.RemoveReGetBomb = function(self, bombEntity)
  -- function num : 0_35
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.reGetBombs)[bombEntity] = nil
end

SmashingPenguinsController.GetBomb = function(self)
  -- function num : 0_36 , upvalues : _ENV
  AudioManager:PlayAudioById(1275)
  self.getBomb = true
  self:SetIsAllowShowUseBombBtn(true)
end

SmashingPenguinsController.SetIsAllowShowUseBombBtn = function(self, isAllow)
  -- function num : 0_37 , upvalues : _ENV, SmashingPenguinsEnum
  if IsNull(self.playUI) then
    return 
  end
  if isAllow and self.getBomb and self._currentGameState == (SmashingPenguinsEnum.eGameState).Fly then
    (self.playUI):SetUseBombBtnShow(true)
    return 
  end
  ;
  (self.playUI):SetUseBombBtnShow(false)
end

SmashingPenguinsController.UseSmashingPenguinsBomb = function(self)
  -- function num : 0_38 , upvalues : SmashingPenguinsEnum, _ENV, SmashingPenguinsConfig, SmashingPenguinsCharacterAnimState
  if self.isGamePause or self.isMovingToCannon or self._currentGameState ~= (SmashingPenguinsEnum.eGameState).Fly then
    return 
  end
  if not self.getBomb then
    return 
  end
  if IsNull(self.playUI) then
    return 
  end
  AudioManager:PlayAudioById(1280)
  local explosion = ((self.playUI).explosionPool):GetOne()
  explosion:InitSmashingPenguinsExplosion()
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (explosion.transform).position = ((self._mainCharacter).transform).position
  local force = (Vector2.New)((SmashingPenguinsConfig.BombForce).x, (SmashingPenguinsConfig.BombForce).y)
  local forceDir = force.normalized
  local forcePower = force.magnitude
  local velocity = ((self._mainCharacter).rigidbody).velocity
  if velocity.x > 0 then
    velocity.x = velocity.x * (SmashingPenguinsConfig.VelocityMultipleBeforeBomb).x
  end
  if velocity.y < 0 then
    velocity.y = velocity.y * (SmashingPenguinsConfig.VelocityMultipleBeforeBomb).y
  end
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._mainCharacter).rigidbody).velocity = velocity
  ;
  (self._mainCharacter):AddForceToSmashingPenguinsCharacter(forceDir, forcePower)
  ;
  (self._mainCharacter):SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Roll)
  for bombEntity,canPick in pairs(self.reGetBombs) do
    if not bombEntity.isUsed and canPick then
      bombEntity:SetBombGotten()
      return 
    end
  end
  if not (table.IsEmptyTable)(self.reGetBombs) then
    error("炸弹未清空！")
    self.reGetBombs = {}
  end
  self.getBomb = false
  self:SetIsAllowShowUseBombBtn(false)
end

SmashingPenguinsController.__ReqSmashingPenguinsSettle = function(self, logicFrameNum)
  -- function num : 0_39 , upvalues : _ENV
  local combineArg = self.currentScore
  ;
  (self.netWork):CS_FlappyBird_Settle(self.activityFwId, self.miniGameConfigId, self.currentScore, logicFrameNum, combineArg, function(objList)
    -- function num : 0_39_0 , upvalues : _ENV, self
    if objList.Count <= 0 then
      error("CS_FlappyBird_Settle objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    self:__ShowFirstReward(msg)
    local mineGrade = self:__CreateMineGrade(msg)
    if not self:__GetFriendBirdData() then
      local allFriendData = {}
    end
    ;
    (table.insert)(allFriendData, mineGrade)
    self:__SortFriendData(allFriendData)
    local finalData = self:__GetResultFriendRankingData(allFriendData, mineGrade)
    if not self.hasGettedJoinReward and msg.rewards ~= nil and (table.count)(msg.rewards) > 0 then
      self.hasGettedJoinReward = true
      if self.__setGettedJoinRewardAction ~= nil then
        (self.__setGettedJoinRewardAction)(true)
      end
    end
    ;
    (self.playUI):ShowSmashingPenguinsResult(msg, finalData, mineGrade, self.hasGettedJoinReward)
  end
)
end

SmashingPenguinsController.__ShowFirstReward = function(self, msg)
  -- function num : 0_40 , upvalues : _ENV
  if msg.rewards ~= nil and (table.count)(msg.rewards) > 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_40_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = ((CommonRewardData.CreateCRDataUseDic)(self.firstRewardDic)):SetCRNotHandledGreat(true)
    CRData:SetCRItemTransDic(self.itemTransDic)
    window:AddAndTryShowReward(CRData)
  end
)
  end
end

SmashingPenguinsController.__GetFriendBirdData = function(self)
  -- function num : 0_41 , upvalues : _ENV, tinyGameEnum
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return nil
  end
  local friendsData = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendsData == nil or #friendsData <= 0 then
    return nil
  end
  local allBirdGrades = {}
  for _,v in ipairs(friendsData) do
    local eachFriendGrade = {}
    eachFriendGrade.name = v:GetUserName()
    eachFriendGrade.score = 0
    eachFriendGrade.uid = v:GetUserUID()
    local frindPenguinsData = v:GetFriendPenguinsData(self.miniGameConfigId)
    if frindPenguinsData ~= nil and frindPenguinsData.gameId == self.miniGameConfigId and frindPenguinsData.gameCat == (tinyGameEnum.eType).penguins then
      eachFriendGrade.score = frindPenguinsData.score
    end
    ;
    (table.insert)(allBirdGrades, eachFriendGrade)
  end
  return allBirdGrades
end

SmashingPenguinsController.__GetResultFriendRankingData = function(self, allFriendData, mineGrade)
  -- function num : 0_42 , upvalues : _ENV
  local finalData = {}
  for index,v in ipairs(allFriendData) do
    v.grade_index = index
    if v == mineGrade then
      if index > 1 then
        (table.insert)(finalData, allFriendData[index - 1])
      end
      ;
      (table.insert)(finalData, v)
      local tempIndex = index
      while 1 do
        while 1 do
          if #finalData < 3 then
            tempIndex = tempIndex + 1
            if tempIndex <= #allFriendData then
              do
                local tempData = allFriendData[tempIndex]
                tempData.grade_index = tempIndex
                ;
                (table.insert)(finalData, tempData)
                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
        return finalData
      end
      return finalData
    end
  end
  return finalData
end

SmashingPenguinsController.__ReqShowRanking = function(self)
  -- function num : 0_43 , upvalues : _ENV
  local LocalFunc_Enter = function()
    -- function num : 0_43_0 , upvalues : self, _ENV
    (self.netWork):CS_FlappyBird_SelfRankDetail(self.activityFwId, self.miniGameConfigId, function(objList)
      -- function num : 0_43_0_0 , upvalues : _ENV, self
      if objList.Count <= 0 then
        error("CS_FlappyBird_SelfRankDetail objList.Count error:" .. tostring(objList.Count))
        return 
      end
      local msg = objList[0]
      local mineGrade = self:__CreateMineGrade(msg)
      if not self:__GetFriendBirdData() then
        local allFriendData = {}
      end
      ;
      (table.insert)(allFriendData, mineGrade)
      self:__SortFriendData(allFriendData)
      UIManager:ShowWindowAsync(UIWindowTypeID.SmashingPenguinsRanking, function(window)
        -- function num : 0_43_0_0_0 , upvalues : allFriendData, mineGrade
        window:RefreshRankingData(allFriendData, mineGrade)
      end
)
    end
)
  end

  if (PlayerDataCenter.friendDataCenter):IsExpireFriendData() then
    local friendNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Friend)
    friendNetCtrl:CS_FRIEND_RefreshFriend(LocalFunc_Enter)
  else
    do
      LocalFunc_Enter()
    end
  end
end

SmashingPenguinsController.__SortFriendData = function(self, allFriendData)
  -- function num : 0_44 , upvalues : _ENV
  if #allFriendData > 1 then
    (table.sort)(allFriendData, function(a, b)
    -- function num : 0_44_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  end
end

SmashingPenguinsController.__CreateMineGrade = function(self, msg)
  -- function num : 0_45 , upvalues : _ENV
  if self.mineGrade == nil then
    self.mineGrade = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).name = PlayerDataCenter:GetSelfName()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).uid = PlayerDataCenter:GetSelfId()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  if msg == nil then
    (self.mineGrade).score = 0
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mineGrade).bydProgress = 0
  else
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mineGrade).score = msg.highestScore or 0
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mineGrade).bydProgress = msg.beyondProgress or 0
    self.maxScore = msg.highestScore
    if self.__setMaxScore ~= nil then
      (self.__setMaxScore)(msg.highestScore)
    end
  end
  return self.mineGrade
end

return SmashingPenguinsController

