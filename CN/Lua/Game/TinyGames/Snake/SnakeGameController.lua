-- params : ...
-- function num : 0 , upvalues : _ENV
local SnakeGameController = class("SnakeGameController")
local SnakeGameConfig = require("Game.TinyGames.Snake.Config.SnakeGameConfig")
local SnakeHead = require("Game.TinyGames.Snake.Entity.SnakeHead")
local SnakeBody = require("Game.TinyGames.Snake.Entity.SnakeBody")
local CS_Input = (CS.UnityEngine).Input
local util = require("XLua.Common.xlua_util")
local TinyGameUtil = require("Game.TinyGames.TinyGameUtil")
local Key = 673312
local SnakeGameState = {Inited = 0, Play = 1, End = 2, Pause = 3, Ready = 4}
local SnakeDataType = {Empty = 0, Snake = 1, Food = 2, Obstacle = 3}
SnakeGameController.ctor = function(self, actData, isHistoryOpen, HTGData)
  -- function num : 0_0 , upvalues : _ENV, SnakeBody
  self.__actData = actData
  self.__snakeGame = actData:GetActTinyGameData()
  self.__isHistoryOpen = isHistoryOpen
  self.__HTGData = HTGData
  self.sComRes = {}
  self:GenHeroIdList()
  self._snakeBodyPool = (CommonPool.New)(function()
    -- function num : 0_0_0 , upvalues : self, SnakeBody
    local go = ((self.sComRes).snakeBodyPrefab):Instantiate(self._entityRoot)
    local snake = (SnakeBody.New)(go)
    local heroId = self:GetRandomHeroId()
    snake:SetSnakeSkin(heroId)
    return snake
  end
, function(snake)
    -- function num : 0_0_1
    snake:ResetSnakeAnimator()
    snake:SetSnakeActive(false)
    return true
  end
)
end

SnakeGameController.GenHeroIdList = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.heroIdList = {}
  local heroDataTable = ConfigData.hero_data
  for key,value in pairs(heroDataTable) do
    (table.insert)(self.heroIdList, key)
  end
end

SnakeGameController.GetRandomHeroId = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.heroIdList ~= nil then
    local index = (math.random)(1, #self.heroIdList)
    local heroId = (self.heroIdList)[index]
    return heroId
  end
  do
    return 1001
  end
end

SnakeGameController.BindSnakeExitEvent = function(self, exitEvent)
  -- function num : 0_3
  self._exitEvent = exitEvent
end

SnakeGameController.GetSnakeActEndTime = function(self)
  -- function num : 0_4
  return (self.__actData):GetActivityEndTime()
end

SnakeGameController.GetSnakeRuleId = function(self)
  -- function num : 0_5
  return (self.__snakeGame):GetSnakeRuleId()
end

SnakeGameController.GetSnakeGameData = function(self)
  -- function num : 0_6
  return self.__snakeGame
end

SnakeGameController.GetGameSnakeScore = function(self)
  -- function num : 0_7 , upvalues : Key
  return self._score ~ Key
end

SnakeGameController.SetGameSnakeScore = function(self, score)
  -- function num : 0_8 , upvalues : Key
  self._score = score ~ Key
end

SnakeGameController.EnterSnakeGame = function(self)
  -- function num : 0_9 , upvalues : _ENV, SnakeGameConfig, SnakeHead, util
  (NetworkManager.luaNetworkAgent):AddLogoutAutoDelete(self)
  self.comResloader = ((CS.ResLoader).Create)()
  UIManager:DeleteAllWindow()
  local preLoadFunc = function()
    -- function num : 0_9_0 , upvalues : _ENV, SnakeGameConfig, self, SnakeHead
    local headPath = nil
    if (PlayerDataCenter.inforData):GetSex() then
      headPath = PathConsts:GetTinyGamePrefabPath(SnakeGameConfig.SnakeHeadPrefab)
    else
      headPath = PathConsts:GetTinyGamePrefabPath(SnakeGameConfig.SnakeHeadBoyPrefab)
    end
    local headPrefabWait = (self.comResloader):LoadABAssetAsyncAwait(headPath)
    local bodyPrefabWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetTinyGamePrefabPath(SnakeGameConfig.SnakeBodyPrefab))
    local eatEffectWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetWarChessEffectPrefabPath("FXP_jiuyuan_end"))
    local foodEffectWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetWarChessEffectPrefabPath("FXP_jiuyuan_loop"))
    ;
    (coroutine.yield)(headPrefabWait)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.sComRes).snakeHeadPrefab = headPrefabWait.Result
    ;
    (coroutine.yield)(bodyPrefabWait)
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.sComRes).snakeBodyPrefab = bodyPrefabWait.Result
    ;
    (coroutine.yield)(eatEffectWait)
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.sComRes).eatEffectPrefab = eatEffectWait.Result
    ;
    (coroutine.yield)(foodEffectWait)
    -- DECOMPILER ERROR at PC70: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.sComRes).foodEffectPrefab = foodEffectWait.Result
    self._entityRoot = (((CS.UnityEngine).GameObject)("ObjectRoot")).transform
    -- DECOMPILER ERROR at PC86: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self._entityRoot).transform).localPosition = (Vector3.New)(0, -0.5, 0)
    local headGo = ((self.sComRes).snakeHeadPrefab):Instantiate(self._entityRoot)
    self._snakeHead = (SnakeHead.New)(headGo)
    ;
    (self._snakeHead):SetSnakeActive(headGo)
    self._eatEffect = ((self.sComRes).eatEffectPrefab):Instantiate()
    self._foodEffect = ((self.sComRes).foodEffectPrefab):Instantiate()
    ;
    (self._eatEffect):SetActive(false)
    ;
    (self._foodEffect):SetActive(false)
    UIManager:ShowWindowAsync(UIWindowTypeID.SnakeGame)
    repeat
      (coroutine.yield)(nil)
      self.snakeWindow = UIManager:GetWindow(UIWindowTypeID.SnakeGame)
    until self.snakeWindow
  end

  ControllerManager:DeleteController(ControllerTypeId.SectorController)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).SnakeGame, function(ok)
    -- function num : 0_9_1 , upvalues : self
    self:ShowSnakeGameMain()
  end
, (util.cs_generator)(preLoadFunc))
end

SnakeGameController.ShowSnakeGameMain = function(self)
  -- function num : 0_10 , upvalues : _ENV, SnakeGameState
  if self.snakeWindow == nil then
    return 
  end
  AudioManager:PlayAudioById(3342)
  self._state = SnakeGameState.Inited
  self:__InitSnakeRankInfo()
  ;
  (self.snakeWindow):_InitSnakeGameUI(self)
  ;
  (self.snakeWindow):RefeshSnakeBestScore((self._mineGrade).score, self._rankIndex)
  ;
  (self.snakeWindow):EnterSnakeInitStateUI()
  self._onUpdate = BindCallback(self, self.OnUpdate)
  UpdateManager:AddUpdate(self._onUpdate)
end

SnakeGameController.StartSnakeGame = function(self)
  -- function num : 0_11 , upvalues : SnakeGameState, _ENV, SnakeGameConfig, SnakeDataType
  if self._state ~= SnakeGameState.Inited then
    return 
  end
  ;
  (self.snakeWindow):InitSnakePlayUI()
  self._state = SnakeGameState.Ready
  local seed = (math.random)(100, CommonUtil.Int32Max)
  if isGameDev then
    print("snake seed:" .. tostring(seed))
  end
  self._random = (CS.FixRandom)(seed)
  self._worldData = {}
  for i = 0, SnakeGameConfig.GWorldSizeX - 1 do
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

    (self._worldData)[i] = (table.GetDefaulValueTable)(0)
  end
  self._snakeDir = SnakeGameConfig.PlayerInitDir
  self._lastSnakeDir = self._snakeDir
  self._logicTime = 0
  self._logicInterval = SnakeGameConfig.SnakeInitTime
  self._curLogicInterval = self._logicInterval
  self._isQuickMove = false
  self._foodEntitys = {}
  self:SetGameSnakeScore(0)
  self._snakeEntitys = {}
  ;
  (self._snakeHead):DirectSetSnakePosDir(SnakeGameConfig.PlayerInitPosX, SnakeGameConfig.PlayerInitPosZ, self._snakeDir)
  ;
  (self._snakeHead):SetSnakeActive(true)
  ;
  (self._snakeHead):ResetSnakeAnimator()
  ;
  (self._snakeHead):PlaySnakeStartAni()
  -- DECOMPILER ERROR at PC80: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._snakeEntitys)[1] = self._snakeHead
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self._worldData)[(self._snakeHead).x])[(self._snakeHead).z] = SnakeDataType.Snake
  for i = 1, SnakeGameConfig.PlayerInitLength do
    local rdir = (SnakeGameConfig.DirResverMap)[self._snakeDir]
    local dirVector = (SnakeGameConfig.DirVectorMap)[rdir]
    if dirVector ~= nil then
      local head = self._snakeHead
      local x = head.x + dirVector.x * i
      local y = head.z + dirVector.y * i
      local snakeBody = (self._snakeBodyPool):PoolGet()
      snakeBody:SetSnakeActive(true)
      snakeBody:DirectSetSnakePosDir(x, y, self._snakeDir)
      snakeBody:PlaySnakeStartAni()
      ;
      (table.insert)(self._snakeEntitys, snakeBody)
      -- DECOMPILER ERROR at PC130: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self._worldData)[x])[y] = SnakeDataType.Snake
    end
  end
  self:_GenSnakeFood()
  ;
  (self.snakeWindow):ShowSnakeReadyUI(function()
    -- function num : 0_11_0 , upvalues : self, SnakeGameState
    self._state = SnakeGameState.Play
  end
)
end

SnakeGameController._GenSnakeFood = function(self)
  -- function num : 0_12 , upvalues : _ENV, SnakeDataType
  local success, x, z = self:_GenEmptyPoint()
  if not success then
    self:_EndSnakeGame()
    return false
  end
  local snakeBody = (self._snakeBodyPool):PoolGet()
  snakeBody:SetSnakeActive(true)
  snakeBody:DirectSetSnakePosDir(x, z, (math.random)(1, 4))
  local k = x << 16 | z
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._foodEntitys)[k] = snakeBody
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._worldData)[x])[z] = SnakeDataType.Food
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._foodEffect).transform).localPosition = (Vector3.New)(-x, 0, z)
  ;
  (self._foodEffect):SetActive(true)
  return true
end

SnakeGameController._GenEmptyPoint = function(self)
  -- function num : 0_13 , upvalues : SnakeGameConfig
  local lastCount = SnakeGameConfig.GWorldPointCount - #self._snakeEntitys
  if lastCount <= 0 then
    return false
  end
  ;
  ((self._random):RandUInt(0, lastCount))
  local index = nil
  local x, z = nil, nil
  local ci = 0
  for rx = 0, SnakeGameConfig.GWorldSizeX - 1 do
    for rz = 0, SnakeGameConfig.GWorldSizeZ - 1 do
      if ((self._worldData)[rx])[rz] == 0 then
        if ci == index then
          return true, rx, rz
        else
          ci = ci + 1
        end
      end
    end
  end
  return false
end

SnakeGameController.OnUpdate = function(self)
  -- function num : 0_14 , upvalues : CS_Input, _ENV, SnakeGameState
  if (CS_Input.GetKeyUp)("escape") then
    (UIUtil.OnClickBackByUiTab)(self)
  end
  if self._state ~= SnakeGameState.Play then
    return 
  end
  self:CheckKeyInput()
  self._logicTime = self._logicTime + Time.deltaTime
  if self._curLogicInterval <= self._logicTime then
    self._curLogicInterval = self._logicInterval
    if self._isQuickMove then
      for k,snake in pairs(self._snakeEntitys) do
        snake:ResetSnakeFastForward()
      end
      self._isQuickMove = false
    end
    self._logicTime = 0
    self:_MoveSnake()
  end
end

SnakeGameController.CheckKeyInput = function(self)
  -- function num : 0_15 , upvalues : CS_Input
  if not CS_Input.anyKeyDown then
    return false
  end
  local dir = 0
  if (CS_Input.GetKeyDown)("up") then
    dir = 1
  else
    if (CS_Input.GetKeyDown)("down") then
      dir = 2
    else
      if (CS_Input.GetKeyDown)("left") then
        dir = 3
      else
        if (CS_Input.GetKeyDown)("right") then
          dir = 4
        end
      end
    end
  end
  if dir > 0 then
    return self:TryChangeSnakeDir(dir)
  end
  return false
end

SnakeGameController.TryChangeSnakeDir = function(self, dir)
  -- function num : 0_16 , upvalues : SnakeGameState, SnakeGameConfig, _ENV
  if self._state ~= SnakeGameState.Play then
    return 
  end
  if (SnakeGameConfig.DirResverMap)[dir] == self._lastSnakeDir then
    return false
  end
  if self._snakeDir == dir then
    return false
  end
  self._snakeDir = dir
  if not self._isQuickMove and not self:_IsNextDirDeaded(dir) and self._lastSnakeDir ~= dir then
    self._curLogicInterval = self._logicInterval * SnakeGameConfig.QuickDirRatio
    self._isQuickMove = true
    if self._logicTime < self._curLogicInterval then
      for k,snake in pairs(self._snakeEntitys) do
        snake:SetSnakeQuick(SnakeGameConfig.QuickDirTimeScale)
      end
    end
  end
  do
    return true
  end
end

SnakeGameController._IsNextDirDeaded = function(self, dir)
  -- function num : 0_17 , upvalues : SnakeGameConfig, SnakeDataType
  local dirVector = (SnakeGameConfig.DirVectorMap)[dir]
  if dirVector == nil then
    return false
  end
  local head = (self._snakeEntitys)[1]
  if head == nil then
    return false
  end
  local nextx = head.x + dirVector.x
  local nexty = head.z + dirVector.y
  local dataType = nil
  if nextx >= 0 and nextx < SnakeGameConfig.GWorldSizeX and nexty >= 0 and nexty < SnakeGameConfig.GWorldSizeZ then
    dataType = ((self._worldData)[nextx])[nexty]
  end
  if dataType == SnakeDataType.Empty or dataType == SnakeDataType.Food then
    return false
  end
  return true
end

SnakeGameController._MoveSnake = function(self)
  -- function num : 0_18 , upvalues : SnakeGameConfig, _ENV, SnakeDataType
  local dirVector = (SnakeGameConfig.DirVectorMap)[self._snakeDir]
  if dirVector == nil then
    return 
  end
  local head = (self._snakeEntitys)[1]
  if head == nil then
    return 
  end
  self._lastSnakeDir = self._snakeDir
  local nextx = head.x + dirVector.x
  local nexty = head.z + dirVector.y
  local dataType = nil
  if nextx >= 0 and nextx < SnakeGameConfig.GWorldSizeX and nexty >= 0 and nexty < SnakeGameConfig.GWorldSizeZ then
    dataType = ((self._worldData)[nextx])[nexty]
  end
  AudioManager:PlayAudioById(1265)
  if dataType == SnakeDataType.Empty then
    self:_MoveSnakeStep(nextx, nexty, self._snakeDir)
    return 
  else
    if dataType == SnakeDataType.Food then
      (self._eatEffect):SetActive(false)
      ;
      (self._eatEffect):SetActive(true)
      -- DECOMPILER ERROR at PC66: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self._eatEffect).transform).localPosition = (Vector3.New)(-nextx, 0, nexty)
      local newInterval = SnakeGameConfig.SnakeInitTime - (SnakeGameConfig.SnakeInitTime - SnakeGameConfig.SnakeMinTime) * (math.min)(1, (#self._snakeEntitys - SnakeGameConfig.PlayerInitLength) / SnakeGameConfig.SnakeIncreaseNumber)
      local isNewSpeed = self._logicInterval ~= newInterval
      self._logicInterval = newInterval
      self._curLogicInterval = self._logicInterval
      local snakeTail = (self._snakeEntitys)[#self._snakeEntitys]
      local tailX, tailZ = snakeTail.x, snakeTail.z
      local tailDir = snakeTail.esdir
      self:_MoveSnakeStep(nextx, nexty, self._snakeDir)
      local k = nextx << 16 | nexty
      local snakeBody = (self._foodEntitys)[k]
      -- DECOMPILER ERROR at PC110: Confused about usage of register: R14 in 'UnsetPending'

      if snakeBody ~= nil then
        (self._foodEntitys)[k] = nil
        snakeBody:DirectSetSnakePosDir(tailX, tailZ, tailDir)
        snakeBody:PlaySnakeStartAni()
        ;
        (table.insert)(self._snakeEntitys, snakeBody)
        -- DECOMPILER ERROR at PC126: Confused about usage of register: R14 in 'UnsetPending'

        ;
        ((self._worldData)[tailX])[tailZ] = SnakeDataType.Snake
      end
      AudioManager:PlayAudioById(1266)
      if not self:_GenSnakeFood() then
        (self._foodEffect):SetActive(false)
        self:_EndSnakeGame()
        return 
      end
      local newScore = self:GetGameSnakeScore() + 1
      self:SetGameSnakeScore(newScore)
      ;
      (self.snakeWindow):RefreshSnakeScore(newScore)
      if isNewSpeed then
        self:_RefreshSnakeAniSpeed()
      end
      return 
    end
  end
  self:_EndSnakeGame()
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

SnakeGameController._MoveSnakeStep = function(self, nextx, nexty, dir)
  -- function num : 0_19 , upvalues : SnakeDataType, _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ((self._worldData)[nextx])[nexty] = SnakeDataType.Snake
  for _,snake in pairs(self._snakeEntitys) do
    local x, z = snake.x, snake.z
    local d = snake.esdir
    snake:MoveSnakeEntity(nextx, nexty, self._logicInterval)
    snake:RotateSnakeDir(dir, self._logicInterval)
    nextx = x
    dir = d
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._worldData)[nextx])[nexty] = nil
end

SnakeGameController._RefreshSnakeAniSpeed = function(self)
  -- function num : 0_20 , upvalues : SnakeGameConfig, _ENV
  local aniPower = SnakeGameConfig.SnakeInitTime / SnakeGameConfig.SnakeMinTime - 1
  local numRatio = (math.min)(1, (#self._snakeEntitys - 1 - SnakeGameConfig.PlayerInitLength) / SnakeGameConfig.SnakeIncreaseNumber)
  local animatorSpeed = 1 + aniPower * numRatio
  for k,snake in pairs(self._snakeEntitys) do
    snake:SetSnakeAniSpeed(animatorSpeed)
  end
end

SnakeGameController._EndSnakeGame = function(self)
  -- function num : 0_21 , upvalues : SnakeGameState, _ENV, SnakeGameConfig
  if self._state == SnakeGameState.End then
    return 
  end
  self._state = SnakeGameState.End
  for k,snake in pairs(self._snakeEntitys) do
    snake:SnakeEntityDead()
  end
  ;
  (UIUtil.AddOneCover)("SnakeGame")
  self._endTimer = TimerManager:StartTimer(SnakeGameConfig.EndWaitTime, self.__RealEndSnakeGame, self, true)
end

SnakeGameController.__RealEndSnakeGame = function(self)
  -- function num : 0_22 , upvalues : _ENV
  self._endTimer = nil
  ;
  (UIUtil.CloseOneCover)("SnakeGame")
  local score = self:GetGameSnakeScore()
  local isOverBest, isReward = self:__RefreshSnakeMaxScore(score)
  ;
  (self.snakeWindow):InitSnakeEndUI(score, (self.__snakeGame):GetTinyGameHistoryScore(), self._rankIndex)
  ;
  (self.__snakeGame):UploadTinyGameScore(score, function()
    -- function num : 0_22_0 , upvalues : isOverBest, self, isReward, _ENV
    if isOverBest then
      (self.snakeWindow):RefeshSnakeBestScore((self._mineGrade).score, self._rankIndex)
      ;
      (self.snakeWindow):InitSnakeRewardUI()
    end
    if isReward then
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_22_0_0 , upvalues : _ENV, self
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = (CommonRewardData.CreateCRDataUseList)((self.__snakeGame):GetSnakeGameReward())
      window:AddAndTryShowReward(CRData)
    end
)
    end
  end
)
end

SnakeGameController.__RefreshSnakeMaxScore = function(self, score)
  -- function num : 0_23 , upvalues : TinyGameUtil
  local isNewHistory = (self.__snakeGame):GetTinyGameHistoryScore() < score
  if not isNewHistory then
    return false, false
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._mineGrade).score = score
  self._rankIndex = (TinyGameUtil.SortTinyGameRankDatas)(self._allFriendRanks, self._mineGrade)
  local joinScore, isReward = (self.__snakeGame):GetSnakeRewardState()
  local ableReward = not isReward and joinScore <= score
  do return true, ableReward end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

SnakeGameController._RecycleSnakeEntityState = function(self)
  -- function num : 0_24 , upvalues : _ENV
  (self._snakeHead):SetSnakeActive(false)
  for i = 2, #self._snakeEntitys do
    local snakeBody = (self._snakeEntitys)[i]
    ;
    (self._snakeBodyPool):PoolPut(snakeBody)
  end
  for _,foodBody in pairs(self._foodEntitys) do
    (self._snakeBodyPool):PoolPut(foodBody)
  end
  ;
  (self._eatEffect):SetActive(false)
  ;
  (self._foodEffect):SetActive(false)
end

SnakeGameController.__InitSnakeRankInfo = function(self)
  -- function num : 0_25 , upvalues : TinyGameUtil
  local allFriendRanks, mineGrade = (self.__snakeGame):GetTinyGameRankInfo()
  self._mineGrade = mineGrade
  self._allFriendRanks = allFriendRanks
  self._rankIndex = (TinyGameUtil.SortTinyGameRankDatas)(self._allFriendRanks, self._mineGrade)
end

SnakeGameController.__EnterSnakeRank = function(self)
  -- function num : 0_26 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SnakeGameRank, function(window)
    -- function num : 0_26_0 , upvalues : self
    if window == nil then
      return 
    end
    window:RefreshSnakeGameRank(self._allFriendRanks, self._mineGrade, self._rankIndex)
  end
)
end

SnakeGameController.ClickSnakeRank = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if (PlayerDataCenter.friendDataCenter):IsExpireFriendData() then
    local friendNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Friend)
    friendNetCtrl:CS_FRIEND_RefreshFriend(function()
    -- function num : 0_27_0 , upvalues : self
    self:__InitSnakeRankInfo()
    ;
    (self.snakeWindow):RefeshSnakeBestScore((self._mineGrade).score, self._rankIndex)
    self:__EnterSnakeRank()
  end
)
  else
    do
      self:__EnterSnakeRank()
    end
  end
end

SnakeGameController.ClickSnakeGameReturn = function(self)
  -- function num : 0_28 , upvalues : SnakeGameState, _ENV
  if self._state == SnakeGameState.Inited then
    self:ExitTinySnakeGame()
    return true
  else
    if self._state == SnakeGameState.Play then
      self._state = SnakeGameState.Pause
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

      ;
      (Time.unity_time).timeScale = 0
      ;
      (self.snakeWindow):EnterSnakePauseUI(true)
    else
      if self._state == SnakeGameState.End then
        self:_RecycleSnakeEntityState()
        ;
        (self.snakeWindow):EnterSnakeInitStateUI()
        self._state = SnakeGameState.Inited
      end
    end
  end
  return false
end

SnakeGameController.ClickSnakeContinue = function(self, showReady)
  -- function num : 0_29 , upvalues : SnakeGameState, _ENV
  if self._state ~= SnakeGameState.Pause then
    return 
  end
  ;
  (self.snakeWindow):EnterSnakePauseUI(false)
  if showReady then
    (self.snakeWindow):ShowSnakeReadyUI(function()
    -- function num : 0_29_0 , upvalues : self, SnakeGameState, _ENV
    self._state = SnakeGameState.Play
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (Time.unity_time).timeScale = 1
  end
)
  else
    self._state = SnakeGameState.Play
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (Time.unity_time).timeScale = 1
  end
end

SnakeGameController.ClickSnakeGiveup = function(self)
  -- function num : 0_30 , upvalues : SnakeGameState
  if self._state ~= SnakeGameState.Pause then
    return 
  end
  self:ClickSnakeContinue()
  self:_EndSnakeGame()
end

SnakeGameController.ClickSnakeRetry = function(self)
  -- function num : 0_31 , upvalues : SnakeGameState, _ENV
  if self._state ~= SnakeGameState.Pause and self._state ~= SnakeGameState.End then
    return 
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (Time.unity_time).timeScale = 1
  self:_RecycleSnakeEntityState()
  ;
  (self.snakeWindow):EnterSnakeInitStateUI()
  self._state = SnakeGameState.Inited
  self:StartSnakeGame()
end

SnakeGameController.ExitTinySnakeGame = function(self)
  -- function num : 0_32 , upvalues : _ENV
  (NetworkManager.luaNetworkAgent):RemoveLogoutAutoDelete(self)
  UIManager:DeleteAllWindow()
  if self._exitEvent ~= nil then
    (self._exitEvent)()
  end
  self:Delete()
end

SnakeGameController.Delete = function(self)
  -- function num : 0_33
  self:OnDelete()
end

SnakeGameController.OnDelete = function(self)
  -- function num : 0_34 , upvalues : _ENV
  if self.comResloader ~= nil then
    (self.comResloader):Put2Pool()
    self.comResloader = nil
  end
  if self._endTimer ~= nil then
    TimerManager:StopTimer(self._endTimer)
    self._endTimer = nil
  end
  self.snakeWindow = nil
  UpdateManager:RemoveUpdate(self._onUpdate)
end

return SnakeGameController

