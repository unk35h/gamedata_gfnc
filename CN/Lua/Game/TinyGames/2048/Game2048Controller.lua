-- params : ...
-- function num : 0 , upvalues : _ENV
local Game2048Controller = class("Game2048Controller")
local CS_Input = (CS.UnityEngine).Input
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local Game2048Board = require("Game.TinyGames.2048.Game2048Board")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local tinyGameEnum = require("Game.TinyGames.TinyGameEnum")
local DirVectorMap = {
[1] = {x = 0, y = -1}
, 
[2] = {x = 0, y = 1}
, 
[3] = {x = -1, y = 0}
, 
[4] = {x = 1, y = 0}
}
local Key = 309813
Game2048Controller.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self:SetGame2048Score(0)
  self._gameStarted = false
  self._tinyGameNetwork = NetworkManager:GetNetwork(NetworkTypeID.TinyGame)
end

Game2048Controller.InitGame2048 = function(self, actId, gameId, taskReddotNode, isHistoryOpen, HTGData, isSetBlurBg)
  -- function num : 0_1 , upvalues : _ENV, CS_LeanTouch, Game2048Board
  self._actId = actId
  self._gameId = gameId
  self.__isHistoryOpen = isHistoryOpen
  self.__HTGData = HTGData
  self._onUpdate = BindCallback(self, self.OnUpdate)
  UpdateManager:AddUpdate(self._onUpdate)
  self.__on2048TouchSwipe = BindCallback(self, self.On2048TouchSwipe)
  ;
  (CS_LeanTouch.OnFingerSwipe)("+", self.__on2048TouchSwipe)
  self._board = (Game2048Board.New)()
  self._highestScore = 0
  if self.__isHistoryOpen then
    self._highestScore = (self.__HTGData):UpdateSelfHighScore()
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDay2048, function(window)
    -- function num : 0_1_0 , upvalues : self, taskReddotNode, isSetBlurBg
    self._window2048 = window
    ;
    (self._window2048):Init2048GameWindow(self, self._highestScore, taskReddotNode, self.__isHistoryOpen)
    if isSetBlurBg then
      (self._window2048):SetIniy2048BlurBg()
    end
  end
)
    return 
  end
  ;
  (self._tinyGameNetwork):CS_ActivityGame_2048_SelfRankDetail(self._actId, self._gameId, function(dataList)
    -- function num : 0_1_1 , upvalues : self, _ENV, taskReddotNode, isSetBlurBg
    if dataList.Count <= 0 then
      return 
    end
    local msg = dataList[0]
    self._highestScore = msg.highestScore
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDay2048, function(window)
      -- function num : 0_1_1_0 , upvalues : self, taskReddotNode, isSetBlurBg, _ENV
      self._window2048 = window
      ;
      (self._window2048):Init2048GameWindow(self, self._highestScore, taskReddotNode)
      if isSetBlurBg then
        (self._window2048):SetIniy2048BlurBg()
      end
      TimerManager:StartTimer(1, function()
        -- function num : 0_1_1_0_0 , upvalues : _ENV
        if UIManager:GetWindow(UIWindowTypeID.WhiteDay2048) == nil then
          return 
        end
        local MainCamera = UIManager:GetMainCamera()
        MainCamera.enabled = false
      end
, nil, true, true, true)
    end
)
  end
)
end

Game2048Controller.Get2048ActFramId = function(self)
  -- function num : 0_2
  return self._actId
end

Game2048Controller.Open2048TaskUI = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityFrameEnum
  if self.__isHistoryOpen then
    return 
  end
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = actCtrl:GetActivityFrameData(self._actId)
  if frameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).WhiteDay then
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayTask, function(window)
    -- function num : 0_3_0 , upvalues : _ENV, frameData
    if window == nil then
      return 
    end
    local AWDCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
    local actId = frameData:GetActId()
    local AWDData = AWDCtrl:GetWhiteDayDataByActId(actId)
    window:InitWDTask(AWDCtrl, AWDData)
  end
)
  end
end

Game2048Controller.Set2048CtrlDeleteCallback = function(self, deleteCallback)
  -- function num : 0_4
  self.deleteCallback = deleteCallback
end

Game2048Controller.GetIs2048ActOver = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = actCtrl:GetActivityFrameData(self._actId)
  if frameData == nil or frameData:GetActivityEndTime() < PlayerDataCenter.timestamp then
    return true
  end
  return false
end

Game2048Controller.StartNew2048Game = function(self)
  -- function num : 0_6
  self:SetGame2048Score(0)
  self._gameStarted = true
  ;
  (self._board):InitGame2048Board()
  ;
  (self._window2048):InitNew2048Window()
  self:AddRandomTile()
end

Game2048Controller.Get2048SizeX = function(self)
  -- function num : 0_7
  return (self._board).xCount
end

Game2048Controller.Get2048SizeY = function(self)
  -- function num : 0_8
  return (self._board).yCount
end

Game2048Controller.IsGame2048Started = function(self)
  -- function num : 0_9
  return self._gameStarted
end

Game2048Controller.OnUpdate = function(self)
  -- function num : 0_10
  if not self._gameStarted then
    return 
  end
  self:CheckKeyInput()
end

Game2048Controller.CheckKeyInput = function(self)
  -- function num : 0_11 , upvalues : CS_Input
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
    self:Move2048(dir)
    return true
  end
  return false
end

Game2048Controller.On2048TouchSwipe = function(self, leanFinger)
  -- function num : 0_12 , upvalues : CS_LeanTouch, _ENV
  if not self._gameStarted then
    return 
  end
  local result = (CS_LeanTouch.RaycastGui)(leanFinger.StartScreenPosition)
  if result.Count == 0 then
    return 
  end
  local res = result[0]
  if res.gameObject ~= (self._window2048):GetGame2048Touch() then
    return 
  end
  local screenFrom = leanFinger.StartScreenPosition
  local screenTo = leanFinger.ScreenPosition
  local finalDelta = screenTo - screenFrom
  local dir = 0
  if finalDelta.x < -(math.abs)(finalDelta.y) then
    dir = 3
  else
    if (math.abs)(finalDelta.y) < finalDelta.x then
      dir = 4
    else
      if finalDelta.y < -(math.abs)(finalDelta.x) then
        dir = 2
      else
        if (math.abs)(finalDelta.x) < finalDelta.y then
          dir = 1
        end
      end
    end
  end
  if dir > 0 then
    self:Move2048(dir)
  end
end

Game2048Controller.PrepareTiles = function(self)
  -- function num : 0_13
  for x = 1, (self._board).xCount do
    for y = 1, (self._board).yCount do
      local tile = (self._board):CellContentDirect(x, y)
      if tile ~= nil then
        tile:PrepareTile()
      end
    end
  end
end

Game2048Controller.Move2048 = function(self, dir)
  -- function num : 0_14 , upvalues : DirVectorMap, _ENV
  local dirVector = DirVectorMap[dir]
  if dirVector == nil then
    return 
  end
  self:PrepareTiles()
  local xstart, xend = nil, nil
  local xoffset = 1
  if dirVector.x == 0 then
    xstart = 1
    xend = (self._board).xCount
  else
    if dirVector.x > 0 then
      xstart = (self._board).xCount - 1
      xend = 1
      xoffset = -1
    else
      xstart = 2
      xend = (self._board).xCount
    end
  end
  local ystart, yend = nil, nil
  local yoffset = 1
  if dirVector.y == 0 then
    ystart = 1
    yend = (self._board).yCount
  else
    if dirVector.y > 0 then
      ystart = (self._board).yCount - 1
      yend = 1
      yoffset = -1
    else
      ystart = 2
      yend = (self._board).yCount
    end
  end
  local moved = false
  for x = xstart, xend, xoffset do
    for y = ystart, yend, yoffset do
      local tile = (self._board):CellContentDirect(x, y)
      if tile ~= nil then
        local nextTile, farthestX, farthestY = self:FindFarthestPosition(tile.x, tile.y, dirVector)
        if nextTile ~= nil and nextTile.level == tile.level and not nextTile.merged then
          local mergedTile = ((self._window2048):Get2048TilePool()):GetOne()
          local newLevel = nextTile.level + 1
          mergedTile:Init2048Tile(newLevel, nextTile.x, nextTile.y, (self._window2048):Get2048TilePool(), (self._window2048):Get2048IconByLevel(newLevel))
          mergedTile:SetTileAsMerged(tile, nextTile)
          ;
          (self._board):InsertTile(mergedTile)
          ;
          (self._board):RemoveTile(tile)
          self:TileUpdatePosition(mergedTile)
          tile:UpdateTilePosData(nextTile.x, nextTile.y)
          local oldScore = self:GetGame2048Score()
          self:SetGame2048Score(oldScore + 2 ^ mergedTile.level)
          moved = true
        else
          do
            do
              if farthestX ~= tile.x or farthestY ~= tile.y then
                self:MoveTile(tile, farthestX, farthestY)
                moved = true
              end
              -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  if not moved then
    return 
  end
  AudioManager:PlayAudioById(1206)
  self:AddRandomTile()
  ;
  (self._window2048):Update2048Score(self:GetGame2048Score(), true)
  self:PlayTilesAnimation()
  if not self:MovesAvailable() then
    self:EnterGame2048OverState()
  end
end

Game2048Controller.MovesAvailable = function(self)
  -- function num : 0_15 , upvalues : DirVectorMap
  if (self._board):GetAvailableCellCount() > 0 then
    return true
  end
  for x = 1, (self._board).xCount do
    for y = 1, (self._board).yCount do
      local tile = (self._board):CellContentDirect(x, y)
      if tile ~= nil then
        for dir = 1, 4 do
          local dirVector = DirVectorMap[dir]
          local other = (self._board):CellContent(x + dirVector.x, y + dirVector.y)
          if other ~= nil and other.level == tile.level then
            return true
          end
        end
      end
    end
  end
  return false
end

Game2048Controller.MoveTile = function(self, tile, newX, newY)
  -- function num : 0_16
  (self._board):RemoveTile(tile)
  tile:UpdateTilePosData(newX, newY)
  ;
  (self._board):InsertTile(tile)
end

Game2048Controller.AddRandomTile = function(self)
  -- function num : 0_17
  local ok, x, y = (self._board):RandomAvailableCell()
  if not ok then
    return 
  end
  local level = (self._board):GetRandomNumLevel()
  local tile = ((self._window2048):Get2048TilePool()):GetOne()
  tile:Init2048Tile(level, x, y, (self._window2048):Get2048TilePool(), (self._window2048):Get2048IconByLevel(level))
  ;
  (self._board):InsertTile(tile)
  self:TileUpdatePosition(tile)
  tile:PlayTileCreateAnimation()
end

Game2048Controller.FindFarthestPosition = function(self, originX, originY, dirVector)
  -- function num : 0_18
  local nextCell, farthestX, farthestY = nil, nil, nil
  local x = originX
  local y = originY
  while 1 do
    farthestX = x
    farthestY = y
    x = x + dirVector.x
    y = y + dirVector.y
    if (self._board):WithinBounds(x, y) then
      nextCell = (self._board):CellContentDirect(x, y)
      -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_THEN_STMT

      -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_STMT

    end
  end
  if nextCell == nil then
    return nextCell, farthestX, farthestY
  end
end

Game2048Controller.TileUpdatePosition = function(self, tile)
  -- function num : 0_19
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  (tile.transform).localPosition = ((self._window2048):Get2048BottomCell(tile.x, tile.y)).localPosition
end

Game2048Controller.GetTilePosition = function(self, x, y)
  -- function num : 0_20
  return ((self._window2048):Get2048BottomCell(x, y)).localPosition
end

Game2048Controller.PlayTilesAnimation = function(self)
  -- function num : 0_21
  for x = 1, (self._board).xCount do
    for y = 1, (self._board).yCount do
      local tile = (self._board):CellContentDirect(x, y)
      if tile ~= nil then
        tile:Play2048TileAnimation(self)
      end
    end
  end
end

Game2048Controller.GetGame2048Score = function(self)
  -- function num : 0_22 , upvalues : Key
  return self._score ~ Key
end

Game2048Controller.SetGame2048Score = function(self, score)
  -- function num : 0_23 , upvalues : Key
  self._score = score ~ Key
end

Game2048Controller.EnterGame2048OverState = function(self)
  -- function num : 0_24
  self._gameStarted = false
  local score = self:GetGame2048Score()
  if self.__isHistoryOpen then
    (self.__HTGData):HTGCommonSettle(score)
    local newRecord = false
    if self._highestScore < score then
      self._highestScore = score
      newRecord = true
    end
    ;
    (self._window2048):On2048GameOver(score, self._highestScore, newRecord)
    return 
  end
  do
    ;
    (self._tinyGameNetwork):CS_ActivityGame_2048_Settle(self._actId, self._gameId, score, function()
    -- function num : 0_24_0 , upvalues : score, self
    local newRecord = false
    if self._highestScore < score then
      self._highestScore = score
      newRecord = true
    end
    ;
    (self._window2048):On2048GameOver(score, self._highestScore, newRecord)
  end
)
  end
end

Game2048Controller.NormalExitGame2048 = function(self)
  -- function num : 0_25 , upvalues : _ENV
  if self.__isHistoryOpen then
    return 
  end
  local MainCamera = UIManager:GetMainCamera()
  if not IsNull(MainCamera) then
    MainCamera.enabled = true
  end
end

Game2048Controller.Exit2048AndSettlement = function(self)
  -- function num : 0_26 , upvalues : _ENV
  self._gameStarted = false
  local score = self:GetGame2048Score()
  if self.__isHistoryOpen then
    (self.__HTGData):HTGCommonSettle(score)
    return 
  end
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = actFrameCtrl:GetActivityFrameData(self._actId)
  if frameData ~= nil and frameData:IsInRuningState() then
    (self._tinyGameNetwork):CS_ActivityGame_2048_Settle(self._actId, self._gameId, score, nil)
  end
  self:NormalExitGame2048()
end

Game2048Controller.EnterGame2048Rank = function(self)
  -- function num : 0_27 , upvalues : _ENV, tinyGameEnum
  local LocalFunc_Enter = function()
    -- function num : 0_27_0 , upvalues : _ENV, self, tinyGameEnum
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDay2048Rank, function(window)
      -- function num : 0_27_0_0 , upvalues : self, _ENV, tinyGameEnum
      if window == nil then
        return 
      end
      local mineGrade, allFriendData = nil, nil
      if self.__isHistoryOpen then
        local rankData = (self.__HTGData):GetHTGRankData()
        allFriendData = rankData.allFriendData
        mineGrade = rankData.mineGrade
        window:SetBestScore((self.__HTGData):GetHTGHistoryHighScore())
      else
        do
          mineGrade = self:__CreateMine2048Grade()
          if not self:__GetFriend2048Data() then
            allFriendData = {}
          end
          ;
          (table.insert)(allFriendData, mineGrade)
          self:__SortRank2048Data(allFriendData)
          local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
          do
            local hisBestScore = activityFrameCtrl:GetTinyGameHistoryHighScore((tinyGameEnum.eType).game2048)
            window:SetBestScore(hisBestScore)
            window:Refresh2048RankingData(allFriendData, mineGrade)
          end
        end
      end
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

Game2048Controller.__CreateMine2048Grade = function(self)
  -- function num : 0_28 , upvalues : _ENV
  if self.mineGrade == nil then
    self.mineGrade = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.mineGrade).name = PlayerDataCenter:GetSelfName()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.mineGrade).uid = PlayerDataCenter:GetSelfId()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.mineGrade).score = self._highestScore
  return self.mineGrade
end

Game2048Controller.__GetFriend2048Data = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return nil
  end
  local friendsData = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendsData == nil or #friendsData <= 0 then
    return nil
  end
  local all2048Grades = {}
  for _,v in ipairs(friendsData) do
    local eachFriendGrade = {}
    eachFriendGrade.name = v:GetUserName()
    eachFriendGrade.score = 0
    eachFriendGrade.uid = v:GetUserUID()
    local game2048Data = v:GetFriend2048Data()
    if game2048Data ~= nil and game2048Data.gameId == self._gameId then
      eachFriendGrade.score = game2048Data.score
    end
    ;
    (table.insert)(all2048Grades, eachFriendGrade)
  end
  return all2048Grades
end

Game2048Controller.__SortRank2048Data = function(self, allFriendData)
  -- function num : 0_30 , upvalues : _ENV
  if #allFriendData > 1 then
    (table.sort)(allFriendData, function(a, b)
    -- function num : 0_30_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  end
end

Game2048Controller.Delete = function(self)
  -- function num : 0_31 , upvalues : _ENV, CS_LeanTouch
  if self.deleteCallback ~= nil then
    (self.deleteCallback)()
  end
  UpdateManager:RemoveUpdate(self._onUpdate)
  ;
  (CS_LeanTouch.OnFingerSwipe)("-", self.__on2048TouchSwipe)
end

return Game2048Controller

