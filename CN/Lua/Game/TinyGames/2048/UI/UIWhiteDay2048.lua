-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDay2048 = class("UIWhiteDay2048", UIBaseWindow)
local base = UIBaseWindow
local UIN2048Tile = require("Game.TinyGames.2048.UI.UIN2048Tile")
UIWhiteDay2048.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIN2048Tile
  (UIUtil.SetTopStatus)(self, self._OnCloseReturn)
  ;
  (UIUtil.SetTopOnlyShowReturn)(true)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnGameCompleteClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Start, self, self._OnGameStartClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self._OnGameRankClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self._OnGameTaskClick)
  self.__tilePool = (UIItemPool.New)(UIN2048Tile, (self.ui).tileItem, false)
  self.__resloader = ((CS.ResLoader).Create)()
end

UIWhiteDay2048.Init2048GameWindow = function(self, gameCtrl, highestScore, taskReddotNode, isHistoryOpen)
  -- function num : 0_1 , upvalues : _ENV
  self.__gameCtrl = gameCtrl
  self.__taskReddotNode = taskReddotNode
  self.__isHistoryOpen = isHistoryOpen
  if self.__isHistoryOpen then
    (((self.ui).btn_Task).gameObject):SetActive(false)
  end
  self.__bottomItems = {}
  for x = 1, (self.__gameCtrl):Get2048SizeX() do
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R9 in 'UnsetPending'

    (self.__bottomItems)[x] = {}
  end
  for y = 1, (self.__gameCtrl):Get2048SizeY() do
    for x = 1, (self.__gameCtrl):Get2048SizeX() do
      local obj = ((self.ui).bottom_item):Instantiate()
      if isEditorMode then
        obj.name = (string.format)("(%d,%d)", x, y)
      end
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R14 in 'UnsetPending'

      ;
      ((self.__bottomItems)[x])[y] = obj.transform
    end
  end
  ;
  ((self.ui).bottom_item):SetActive(false)
  self.__gameIconAtlas = {}
  local atlas = (self.__resloader):LoadABAsset(PathConsts:GetAtlasAssetPath("UI_WhiteDay2048Icon"))
  for i = 1, 12 do
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R10 in 'UnsetPending'

    (self.__gameIconAtlas)[i] = (AtlasUtil.GetResldSprite)(atlas, "WD2048Icon_" .. tostring(i))
  end
  self:Reset2048UIState(false)
  -- DECOMPILER ERROR at PC94: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_HighestScore).text = tostring(highestScore)
  self:__InitWDTaskReddot()
end

UIWhiteDay2048.SetIniy2048BlurBg = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_background).color = (self.ui).color_blur
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).blur_background).enabled = true
end

UIWhiteDay2048.Reset2048UIState = function(self, gameStart)
  -- function num : 0_3
  (((self.ui).btn_Start).gameObject):SetActive(not gameStart)
  ;
  ((self.ui).bottomCover):SetActive(gameStart)
  ;
  (((self.ui).btn_Confirm).gameObject):SetActive(gameStart)
  ;
  ((self.ui).readyNode):SetActive(not gameStart)
  self:Update2048Score(0)
end

UIWhiteDay2048.InitNew2048Window = function(self)
  -- function num : 0_4
  (self.__tilePool):HideAll()
  self:Reset2048UIState(true)
end

UIWhiteDay2048.Update2048Score = function(self, score, isGetScore)
  -- function num : 0_5 , upvalues : _ENV
  local scoreStr = tostring(score)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  if ((self.ui).tex_CurrentScore).text ~= scoreStr then
    ((self.ui).tex_CurrentScore).text = scoreStr
    if isGetScore then
      AudioManager:PlayAudioById(1207)
    end
  end
end

UIWhiteDay2048.Get2048TilePool = function(self)
  -- function num : 0_6
  return self.__tilePool
end

UIWhiteDay2048.Get2048BottomCell = function(self, x, y)
  -- function num : 0_7
  return ((self.__bottomItems)[x])[y]
end

UIWhiteDay2048.Get2048IconByLevel = function(self, level)
  -- function num : 0_8 , upvalues : _ENV
  level = (math.clamp)(level, 1, 12)
  return (self.__gameIconAtlas)[level]
end

UIWhiteDay2048.GetGame2048Touch = function(self)
  -- function num : 0_9
  return (self.ui).gameTouch
end

UIWhiteDay2048.On2048GameOver = function(self, score, highestScore, newRecord)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDay2048Score, function(window)
    -- function num : 0_10_0 , upvalues : self, score, newRecord, _ENV
    if window == nil then
      return 
    end
    window:InitGame2048Score(self.__gameCtrl, score, newRecord, self)
    AudioManager:PlayAudioById(1205)
  end
)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_HighestScore).text = tostring(highestScore)
end

UIWhiteDay2048._OnGameStartClicked = function(self)
  -- function num : 0_11 , upvalues : _ENV
  AudioManager:PlayAudioById(1204)
  ;
  (self.__gameCtrl):StartNew2048Game()
end

UIWhiteDay2048._OnGameCompleteClick = function(self)
  -- function num : 0_12 , upvalues : _ENV
  ((CS.MessageCommon).ShowMessageBox)(ConfigData:GetTipContent(7205), function()
    -- function num : 0_12_0 , upvalues : self
    (self.__gameCtrl):EnterGame2048OverState()
  end
, nil)
end

UIWhiteDay2048._OnGameRankClick = function(self)
  -- function num : 0_13
  (self.__gameCtrl):EnterGame2048Rank()
end

UIWhiteDay2048._OnGameTaskClick = function(self)
  -- function num : 0_14
  (self.__gameCtrl):Open2048TaskUI()
end

UIWhiteDay2048.__InitWDTaskReddot = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.__taskReddotNode == nil then
    return 
  end
  if self.__refresnTaskReddot == nil then
    self.__refresnTaskReddot = function(node)
    -- function num : 0_15_0 , upvalues : self
    ((self.ui).obj_task_redDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

  end
  RedDotController:AddListener((self.__taskReddotNode).nodePath, self.__refresnTaskReddot)
  ;
  (self.__refresnTaskReddot)(self.__taskReddotNode)
end

UIWhiteDay2048.__RemoveWDTaskReddot = function(self)
  -- function num : 0_16 , upvalues : _ENV
  if self.__taskReddotNode == nil then
    return 
  end
  RedDotController:RemoveListener((self.__taskReddotNode).nodePath, self.__refresnTaskReddot)
  self.__refresnTaskReddot = nil
end

UIWhiteDay2048._OnCloseReturn = function(self, isBackHome)
  -- function num : 0_17 , upvalues : _ENV
  if (self.__gameCtrl):IsGame2048Started() then
    if (self.__gameCtrl):GetIs2048ActOver() or isBackHome then
      (self.__gameCtrl):Exit2048AndSettlement()
      self:Delete()
      return 
    end
    ;
    ((CS.MessageCommon).ShowMessageBox)(ConfigData:GetTipContent(7200), function()
    -- function num : 0_17_0 , upvalues : self, _ENV
    (self.__gameCtrl):Exit2048AndSettlement()
    self:Delete()
    ;
    (UIUtil.PopFromBackStackByUiTab)(self)
  end
, nil)
    return false
  else
    ;
    (self.__gameCtrl):NormalExitGame2048()
    self:Delete()
  end
end

UIWhiteDay2048.OnDelete = function(self)
  -- function num : 0_18 , upvalues : base
  (self.__gameCtrl):Delete()
  self.__gameCtrl = nil
  if self.__resloader ~= nil then
    (self.__resloader):Put2Pool()
    self.__resloader = nil
  end
  self:__RemoveWDTaskReddot()
  ;
  (base.OnDelete)(self)
end

return UIWhiteDay2048

