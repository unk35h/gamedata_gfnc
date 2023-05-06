-- params : ...
-- function num : 0 , upvalues : _ENV
local UICarnival22MiniGame = class("UICarnival22MiniGame", UIBaseWindow)
local base = UIBaseWindow
local UINCarnival22Ball = require("Game.ActivityCarnival.UI.CarnivalMiniGame.UINCarnival22Ball")
local UINCarnival22BallEft = require("Game.ActivityCarnival.UI.CarnivalMiniGame.UINCarnival22BallEft")
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_UnityEngine_Time = (CS.UnityEngine).Time
local util = require("XLua.Common.xlua_util")
local cs_MessageCommon = CS.MessageCommon
local UINCarnivalRank = require("Game.ActivityCarnival.UI.CarnivalMiniGame.UINCarnivalRank")
local BORN_INTERVAL = 0.5
local BORN_MAXlEVEL = 5
UICarnival22MiniGame.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCarnival22Ball, UINCarnival22BallEft, CS_LeanTouch, UINCarnivalRank
  (UIUtil.SetTopStatus)(self, self.OnCloseMini, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnClickGameBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self.OnClickRank)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Start, self, self.OnClickPlayGame)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PlayAgain, self, self.OnClickPlayGame)
  self._ballPools = {}
  self._maxLevel = #(self.ui).balls
  for i,obj in ipairs((self.ui).balls) do
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R6 in 'UnsetPending'

    (self._ballPools)[i] = (UIItemPool.New)(UINCarnival22Ball, obj)
  end
  self._ballEftPool = (UIItemPool.New)(UINCarnival22BallEft, (self.ui).uI_Carnival22MiniGame_click)
  ;
  ((self.ui).uI_Carnival22MiniGame_click):SetActive(false)
  local collider2DTrigger = ((CS.ColliderEventListener).Get)((self.ui).line)
  collider2DTrigger:TriggerEnter2DEvent("+", BindCallback(self, self.__VirLineEnter))
  collider2DTrigger:TriggerExit2DEvent("+", BindCallback(self, self.__VirLineExit))
  self.__OnGestureStartEvent = BindCallback(self, self.__OnGestureStart)
  self.__OnGestureEvent = BindCallback(self, self.__OnGesture)
  self.__OnGestureEndEvent = BindCallback(self, self.__OnGestureEnd)
  ;
  (CS_LeanTouch.OnFingerDown)("+", self.__OnGestureStartEvent)
  ;
  (CS_LeanTouch.OnGesture)("+", self.__OnGestureEvent)
  ;
  (CS_LeanTouch.OnFingerUp)("+", self.__OnGestureEndEvent)
  self.__ItemCollidingEvent = BindCallback(self, self.__ItemColliding)
  self.__IEDelayBornNewItemEvent = BindCallback(self, self.__IEDelayBornNewItem)
  self._rankNode = (UINCarnivalRank.New)()
  ;
  (self._rankNode):Init((self.ui).rank)
  ;
  (self._rankNode):Hide()
  ;
  (self._rankNode):BindCarnivalRankFunc(function()
    -- function num : 0_0_0 , upvalues : self
    self._isPause = false
  end
)
  self._isPause = false
end

UICarnival22MiniGame.InitCarnivalMiniGame = function(self, carnivalData, isHistoryOpen, HTGData)
  -- function num : 0_1
  self._carnivalData = carnivalData
  self._gameData = (self._carnivalData):GetCarnivalTinyGame()
  self.__isHistoryOpen = isHistoryOpen
  self.__HTGData = HTGData
  self:__RefreshHistoryScore()
end

UICarnival22MiniGame.__OnStartGame = function(self)
  -- function num : 0_2 , upvalues : _ENV
  AudioManager:PlayAudioById(1225)
  self._isPlaying = true
  self._score = 0
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(self._score)
  ;
  ((self.ui).gameOver):SetActive(false)
  ;
  ((self.ui).gameStart):SetActive(false)
  ;
  ((self.ui).play):SetActive(true)
  self:__Reset()
  self:__TryGenItem()
  self._dowmTimerId = TimerManager:StartTimer(1, self.__CheckFail, self)
end

UICarnival22MiniGame.__OnEndGame = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._isPlaying = false
  self:__Reset()
  ;
  ((self.ui).gameOver):SetActive(true)
  local isNewHistory = (self._gameData):GetWatermeHistoryScore() < self._score
  ;
  ((self.ui).obj_New):SetActive(isNewHistory)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_GameScore).text = tostring(self._score)
  ;
  (self._gameData):UploadWatermelonScore(self._score, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:__RefreshHistoryScore()
    end
  end
)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UICarnival22MiniGame.__Reset = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for i,poll in pairs(self._ballPools) do
    poll:HideAll()
  end
  for i,eft in ipairs((self._ballEftPool).listItem) do
    (eft.transform):SetParent((self.ui).eftPool)
  end
  ;
  (self._ballEftPool):HideAll()
  self._itemGoDic = {}
  self._collisionLineDic = {}
  self._collisioLineCount = 0
  self._waitItem = nil
  self._nextBornTime = 0
  if self._dowmTimerId ~= nil then
    TimerManager:StopTimer(self._dowmTimerId)
    self._dowmTimerId = nil
  end
  if self._ieDelayBornCo ~= nil then
    (GR.StopCoroutine)(self._ieDelayBornCo)
    self._ieDelayBornCo = nil
  end
  self._ballToEftDic = {}
end

UICarnival22MiniGame.__TryGenItem = function(self)
  -- function num : 0_5 , upvalues : _ENV, BORN_MAXlEVEL
  if self._waitItem ~= nil then
    return 
  end
  local index = (math.random)(1, BORN_MAXlEVEL)
  self._waitItem = self:__CreateNewItem(index, Vector3.zero)
  ;
  (self._waitItem):SetRigidBody(false)
end

UICarnival22MiniGame.__OnGestureStart = function(self, finger)
  -- function num : 0_6 , upvalues : _ENV
  if self._isPause then
    return 
  end
  if self._waitItem == nil then
    return 
  end
  local leftX, rightX = self:__GetWallBorder()
  local pos = TransitionScreenPoint(UIManager:GetUICamera(), (self._waitItem).gameObject, finger.ScreenPosition)
  if rightX < pos.x or pos.x < leftX then
    return 
  end
  self._touchIndex = finger.Index
  local itemRadius = (self._waitItem):GetColliderRadius()
  if self._dragLimitX == nil then
    self._dragLimitX = {}
  end
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._dragLimitX).left = leftX + itemRadius
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._dragLimitX).right = rightX - itemRadius
end

UICarnival22MiniGame.__OnGesture = function(self, fingerList)
  -- function num : 0_7 , upvalues : _ENV
  if self._waitItem == nil then
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
      return 
    end
    local pos = TransitionScreenPoint(UIManager:GetUICamera(), (self._waitItem).gameObject, finger.ScreenPosition)
    pos.x = (math.clamp)(pos.x, (self._dragLimitX).left, (self._dragLimitX).right)
    pos.y = (((self._waitItem).transform).localPosition).y
    pos.z = (((self._waitItem).transform).localPosition).z
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self._waitItem).transform).localPosition = pos
  end
end

UICarnival22MiniGame.__OnGestureEnd = function(self, finger)
  -- function num : 0_8 , upvalues : _ENV, CS_UnityEngine_Time, BORN_INTERVAL, util
  if self._touchIndex ~= finger.Index then
    return 
  end
  self._touchIndex = nil
  if self._waitItem == nil then
    return 
  end
  AudioManager:PlayAudioById(1226)
  ;
  (self._waitItem):SetRigidBody(true)
  self._waitItem = nil
  self._nextBornTime = CS_UnityEngine_Time.time + BORN_INTERVAL
  self._ieDelayBornCo = (GR.StartCoroutine)((util.cs_generator)(self.__IEDelayBornNewItemEvent))
end

UICarnival22MiniGame.__VirLineEnter = function(self, other)
  -- function num : 0_9 , upvalues : CS_UnityEngine_Time
  local ball = (self._itemGoDic)[other.gameObject]
  if ball == nil or (self._collisionLineDic)[ball] ~= nil then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._collisionLineDic)[ball] = CS_UnityEngine_Time.time
  self._collisioLineCount = self._collisioLineCount + 1
end

UICarnival22MiniGame.__VirLineExit = function(self, other)
  -- function num : 0_10
  local ball = (self._itemGoDic)[other.gameObject]
  if ball == nil then
    return 
  end
  if (self._collisionLineDic)[ball] == nil then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._collisionLineDic)[ball] = nil
  self._collisioLineCount = self._collisioLineCount - 1
end

UICarnival22MiniGame.__ItemColliding = function(self, item, other)
  -- function num : 0_11 , upvalues : _ENV
  if (self._itemGoDic)[item.gameObject] == nil then
    return 
  end
  local otherItem = (self._itemGoDic)[other.gameObject]
  if otherItem == nil then
    return 
  end
  local nowId = item:GetWaltermelonType()
  if self._maxLevel <= nowId or nowId ~= otherItem:GetWaltermelonType() then
    return 
  end
  local nowPos = nil
  local itemSpeed = item:GetRigidSpeed()
  local otherSpeed = otherItem:GetRigidSpeed()
  if itemSpeed.sqrMagnitude < otherSpeed.sqrMagnitude then
    nowPos = (item.transform).localPosition
  else
    nowPos = (otherItem.transform).localPosition
  end
  nowPos.y = nowPos.y - item:GetColliderRadius()
  self:__CleatOldItem(item)
  self:__CleatOldItem(otherItem)
  local newItem = self:__CreateNewItem(nowId + 1, nowPos)
  newItem:SetRigidBody(true)
  AudioManager:PlayAudioById(1227)
  self:__ShowCollidingEft(nowId + 1, newItem)
  self._score = self._score + (self._gameData):GetWatermeScore(nowId + 1)
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(self._score)
end

UICarnival22MiniGame.__CleatOldItem = function(self, item)
  -- function num : 0_12
  self:__VirLineExit(item.gameObject)
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._itemGoDic)[item.gameObject] = nil
  local pool = (self._ballPools)[item:GetWaltermelonType()]
  pool:HideOne(item)
  local eft = (self._ballToEftDic)[item]
  if eft == nil then
    return 
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._ballToEftDic)[item] = nil
  if (eft.transform):IsChildOf(item.transform) then
    self:__CycleCollidingEft(eft)
  end
end

UICarnival22MiniGame.__CreateNewItem = function(self, waltermelonType, pos)
  -- function num : 0_13
  local newItem = ((self._ballPools)[waltermelonType]):GetOne()
  ;
  (newItem.transform):SetParent(((self.ui).imgHolder).transform)
  newItem:InitWaltermelonItem(waltermelonType, self.__ItemCollidingEvent)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._itemGoDic)[newItem.gameObject] = newItem
  pos.y = pos.y + newItem:GetColliderRadius()
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (newItem.transform).localPosition = pos
  return newItem
end

UICarnival22MiniGame.__CheckFail = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self._waitDelEfts == nil then
    self._waitDelEfts = {}
  else
    ;
    (table.removeall)(self._waitDelEfts)
  end
  for i,eft in ipairs((self._ballEftPool).listItem) do
    if eft:IsBallEftFnish() then
      (table.insert)(self._waitDelEfts, eft)
    end
  end
  for i,eft in ipairs(self._waitDelEfts) do
    self:__CycleCollidingEft(eft)
  end
  if self._collisioLineCount == 0 then
    return 
  end
  for item,_ in pairs(self._collisionLineDic) do
    if (item:GetRigidSpeed()).sqrMagnitude >= 0.001 then
      return 
    end
  end
  self:__OnEndGame()
end

UICarnival22MiniGame.__IEDelayBornNewItem = function(self)
  -- function num : 0_15 , upvalues : CS_UnityEngine_Time, _ENV
  while CS_UnityEngine_Time.time < self._nextBornTime do
    (coroutine.yield)(nil)
  end
  self:__TryGenItem()
  self._ieDelayBornCo = nil
end

UICarnival22MiniGame.__GetWallBorder = function(self)
  -- function num : 0_16
  if self._leftWallLimitX == nil then
    self._leftWallLimitX = ((((self.ui).wall_left).transform).localPosition).x - (((self.ui).wall_left).rect).x
  end
  if self._rightWallLimitX == nil then
    self._rightWallLimitX = ((((self.ui).wall_right).transform).localPosition).x + (((self.ui).wall_right).rect).x
  end
  return self._leftWallLimitX, self._rightWallLimitX
end

UICarnival22MiniGame.__ShowCollidingEft = function(self, index, ball)
  -- function num : 0_17 , upvalues : _ENV
  local item = (self._ballEftPool):GetOne()
  item:InitBallEft(index)
  ;
  (item.transform):SetParent(ball.transform)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (item.transform).anchoredPosition = Vector2.zero
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._ballToEftDic)[ball] = item
end

UICarnival22MiniGame.__CycleCollidingEft = function(self, item)
  -- function num : 0_18
  (self._ballEftPool):HideOne(item)
  ;
  (item.transform):SetParent((self.ui).eftPool)
end

UICarnival22MiniGame.__RefreshHistoryScore = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local history = (self._gameData):GetWatermeHistoryScore()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_HighScoure).text = tostring(history)
end

UICarnival22MiniGame.OnClickPlayGame = function(self)
  -- function num : 0_20
  self:__OnStartGame()
end

UICarnival22MiniGame.OnClickRank = function(self)
  -- function num : 0_21 , upvalues : _ENV
  self._isPause = true
  local LocalFunc_Enter = function()
    -- function num : 0_21_0 , upvalues : self
    local allFriend, mine = (self._gameData):GetWatermeRank()
    ;
    (self._rankNode):Show()
    ;
    (self._rankNode):InitCarnivalRank(allFriend, mine)
    if self.__isHistoryOpen then
      (self._rankNode):SetBestScore((self.__HTGData):GetHTGHistoryHighScore())
    end
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

UICarnival22MiniGame.OnClickGameBack = function(self)
  -- function num : 0_22 , upvalues : _ENV, cs_MessageCommon
  if not self._isPlaying then
    (UIUtil.OnClickBackByUiTab)(self)
    return 
  end
  self._isPause = true
  ;
  (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(7200), function()
    -- function num : 0_22_0 , upvalues : self, _ENV
    (self._gameData):UploadWatermelonScore(self._score)
    ;
    (UIUtil.OnClickBackByUiTab)(self)
  end
, function()
    -- function num : 0_22_1 , upvalues : self
    self._isPause = false
  end
)
end

UICarnival22MiniGame.OnCloseMini = function(self)
  -- function num : 0_23
  self:Delete()
end

UICarnival22MiniGame.OnDelete = function(self)
  -- function num : 0_24 , upvalues : base, _ENV, CS_LeanTouch
  (base.OnDelete)(self)
  if self._dowmTimerId ~= nil then
    TimerManager:StopTimer(self._dowmTimerId)
    self._dowmTimerId = nil
  end
  if self._ieDelayBornCo ~= nil then
    (GR.StopCoroutine)(self._ieDelayBornCo)
    self._ieDelayBornCo = nil
  end
  ;
  (CS_LeanTouch.OnFingerDown)("-", self.__OnGestureStartEvent)
  ;
  (CS_LeanTouch.OnGesture)("-", self.__OnGestureEvent)
  ;
  (CS_LeanTouch.OnFingerUp)("-", self.__OnGestureEndEvent)
end

return UICarnival22MiniGame

