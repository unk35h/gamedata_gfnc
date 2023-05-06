-- params : ...
-- function num : 0 , upvalues : _ENV
local UISmashingPenguinsMain = class("UISmashingPenguinsMain", UIBaseWindow)
local base = UIBaseWindow
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local SmashingPenguinsCharacterEntity = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsCharacterEntity")
local SmashingPenguinsFakeCharacter = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsFakeCharacter")
local SmashingPenguinsCannonEntity = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsCannonEntity")
local SmashingPenguinsBombEntity = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsBombEntity")
local SmashingPenguinsWallEntity = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsWallEntity")
local SmashingPenguinsWindEntity = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsWindEntity")
local SmashingPenguinsMapBlock = require("Game.TinyGames.SmashingPenguins.Map.SmashingPenguinsMapBlock")
local SmashingPenguinsExplosion = require("Game.TinyGames.SmashingPenguins.Fx.SmashingPenguinsExplosion")
local UINSmashingPenguinsPause = require("Game.TinyGames.SmashingPenguins.UI.UINSmashingPenguinsPause")
local UINSmashingPenguinsResult = require("Game.TinyGames.SmashingPenguins.UI.UINSmashingPenguinsResult")
local SmashingPenguinsMainAnimCtrl = require("Game.TinyGames.SmashingPenguins.SmashingPenguinsMainAnimCtrl")
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
local UINFlappyAwardPanel = require("Game.TinyGames.FlappyBird.UI.UINFlappyAwardPanel")
local UINFlappyGiftItem = require("Game.TinyGames.FlappyBird.UI.UINFlappyGiftItem")
local FirstAwardTitleIndex = 0
UISmashingPenguinsMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_LeanTouch, UINFlappyGiftItem, SmashingPenguinsCharacterEntity, SmashingPenguinsCannonEntity, SmashingPenguinsMapBlock, SmashingPenguinsWindEntity, SmashingPenguinsBombEntity, SmashingPenguinsWallEntity, SmashingPenguinsExplosion, UINSmashingPenguinsResult, UINSmashingPenguinsPause, SmashingPenguinsFakeCharacter
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  self.__OnGestureStartEvent = BindCallback(self, self.__OnGestureStart)
  self.__OnGestureEvent = BindCallback(self, self.__OnGesture)
  self.__OnGestureEndEvent = BindCallback(self, self.__OnGestureEnd)
  ;
  (CS_LeanTouch.OnFingerDown)("+", self.__OnGestureStartEvent)
  ;
  (CS_LeanTouch.OnGesture)("+", self.__OnGestureEvent)
  ;
  (CS_LeanTouch.OnFingerUp)("+", self.__OnGestureEndEvent)
  self.giftPool = (UIItemPool.New)(UINFlappyGiftItem, (self.ui).awardItem)
  ;
  ((self.ui).awardItem):SetActive(false)
  self.mainCharacter = (SmashingPenguinsCharacterEntity.New)()
  ;
  (self.mainCharacter):Init((self.ui).obj_mainCharacter)
  self.cannonPool = (UIItemPool.New)(SmashingPenguinsCannonEntity, (self.ui).obj_cannon)
  ;
  ((self.ui).obj_cannon):SetActive(false)
  self.startMapBlocks = {}
  self.loopMapBlocks = {}
  for iBlockIndex = 1, #(self.ui).array_startMapBlocks do
    local mapBlock = (SmashingPenguinsMapBlock.New)()
    mapBlock:Init(((self.ui).array_startMapBlocks)[iBlockIndex])
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.startMapBlocks)[iBlockIndex] = mapBlock
    mapBlock:Hide()
  end
  for iBlockIndex = 1, #(self.ui).array_loopMapBlocks do
    local mapBlock = (SmashingPenguinsMapBlock.New)()
    mapBlock:Init(((self.ui).array_loopMapBlocks)[iBlockIndex])
    -- DECOMPILER ERROR at PC102: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.loopMapBlocks)[iBlockIndex] = mapBlock
    mapBlock:Hide()
  end
  self.windPool = (UIItemPool.New)(SmashingPenguinsWindEntity, (self.ui).obj_wind)
  ;
  ((self.ui).obj_wind):SetActive(false)
  self.bombPool = (UIItemPool.New)(SmashingPenguinsBombEntity, (self.ui).obj_bomb)
  ;
  ((self.ui).obj_bomb):SetActive(false)
  self.upWallPool = (UIItemPool.New)(SmashingPenguinsWallEntity, (self.ui).obj_upWall)
  ;
  ((self.ui).obj_upWall):SetActive(false)
  self.midWallPool = (UIItemPool.New)(SmashingPenguinsWallEntity, (self.ui).obj_midWall)
  ;
  ((self.ui).obj_midWall):SetActive(false)
  self.downWallPool = (UIItemPool.New)(SmashingPenguinsWallEntity, (self.ui).obj_downWall)
  ;
  ((self.ui).obj_downWall):SetActive(false)
  self.explosionPool = (UIItemPool.New)(SmashingPenguinsExplosion, (self.ui).obj_explosion)
  ;
  ((self.ui).obj_explosion):SetActive(false)
  self.gestureGuideImage = (self.ui).obj_gestureGuide
  ;
  (self.gestureGuideImage):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_start, self, self.OnStartGameBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_guide, self, self.OnShowGuideBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ranking, self, self.OnShowRankBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_return, self, self.OnQuitGameBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_guideBack, self, self.OnHideGuide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_pause, self, self.OnPauseGameBtnClick)
  ;
  (((self.ui).btn_useBomb).onPressDown):AddListener(BindCallback(self, self.OnUseBombBtnClick))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_end, self, self.OnResultBtnClick)
  self.resultNode = (UINSmashingPenguinsResult.New)()
  ;
  (self.resultNode):Init((self.ui).obj_resultNode)
  self.pauseNode = (UINSmashingPenguinsPause.New)()
  ;
  (self.pauseNode):Init((self.ui).obj_pauseNode)
  self.mapBlockHolder = (self.ui).obj_mapBlockHolder
  self.mainGameItems = (self.ui).obj_mainGameItems
  self.tracker = (self.ui).obj_tracker
  self.smashingPenguinsController = ControllerManager:GetController(ControllerTypeId.SmashingPenguins, true)
  ;
  (self.smashingPenguinsController):SetSmashingPenguinsCharacter(self.mainCharacter)
  self.__showAwardFunc = BindCallback(self, self.__ShowAwardPanel)
  self.__hideAwardFunc = BindCallback(self, self.__HideAwardPanel)
  self.fakeCharacter = (SmashingPenguinsFakeCharacter.New)()
  ;
  (self.fakeCharacter):Init((self.ui).obj_fakeCharacter)
  ;
  (self.fakeCharacter):InitEntityData(self.mainCharacter, self.smashingPenguinsController)
  ;
  (self.fakeCharacter):Show()
end

UISmashingPenguinsMain.ShowMainWindow = function(self)
  -- function num : 0_1
  self:SetMainWindowObjShow(true, false, false, false)
  ;
  (self.resultNode):Hide()
  ;
  (self.pauseNode):Hide()
  ;
  ((self.ui).obj_backWall):SetActive(false)
end

UISmashingPenguinsMain.SetMainWindowObjShow = function(self, isMainShow, isStartShow, isEndShow, isGuideShow)
  -- function num : 0_2 , upvalues : SmashingPenguinsMainAnimCtrl
  ((self.ui).obj_main):SetActive(isMainShow)
  ;
  ((self.ui).obj_start):SetActive(isStartShow)
  ;
  ((self.ui).obj_end):SetActive(isEndShow)
  ;
  ((self.ui).obj_guide):SetActive(isGuideShow)
  if isMainShow then
    if self.animCtrl ~= nil then
      (self.animCtrl):Delete()
      self.animCtrl = nil
    end
    self.animCtrl = (SmashingPenguinsMainAnimCtrl.New)(self.fakeCharacter)
    ;
    (self.animCtrl):GetRandomAnimType()
  end
end

UISmashingPenguinsMain.SetGameEndTime = function(self, endTime)
  -- function num : 0_3 , upvalues : _ENV
  local date = TimeUtil:TimestampToDate(endTime)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_time).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
end

UISmashingPenguinsMain.InitSmashingPenguinsMain = function(self)
  -- function num : 0_4
  self:ShowMainWindow()
  ;
  (self.smashingPenguinsController):ReadySmashingPenguins()
end

UISmashingPenguinsMain.OnStartGameBtnClick = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if (self.smashingPenguinsController):GetIsSmashingPenguinsActOver() then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6033))
    return 
  end
  self:__HideAwardPanel()
  ;
  (self.smashingPenguinsController):StartSmashingPenguins()
  if self.animCtrl ~= nil then
    (self.animCtrl):Delete()
    self.animCtrl = nil
  end
  ;
  ((self.ui).obj_backWall):SetActive(true)
end

UISmashingPenguinsMain.SetCloseCallback = function(self, callback)
  -- function num : 0_6
  self.closeCallback = callback
end

UISmashingPenguinsMain.HideAllRes = function(self)
  -- function num : 0_7
  for iBlockIndex = 1, #self.startMapBlocks do
    ((self.startMapBlocks)[iBlockIndex]):Hide()
  end
  for iBlockIndex = 1, #self.loopMapBlocks do
    ((self.loopMapBlocks)[iBlockIndex]):Hide()
  end
  ;
  (self.cannonPool):HideAll()
  ;
  (self.windPool):HideAll()
  ;
  (self.bombPool):HideAll()
  ;
  (self.upWallPool):HideAll()
  ;
  (self.midWallPool):HideAll()
  ;
  (self.downWallPool):HideAll()
  ;
  (self.explosionPool):HideAll()
end

UISmashingPenguinsMain.ShowInGameUI = function(self)
  -- function num : 0_8
  self:SetMainWindowObjShow(false, true, false, false)
  self:__HideAwardPanel()
end

UISmashingPenguinsMain.OnShowGuideBtnClick = function(self)
  -- function num : 0_9
  self:__HideAwardPanel()
  self:SetMainWindowObjShow(false, false, false, true)
end

UISmashingPenguinsMain.OnHideGuide = function(self)
  -- function num : 0_10
  self:SetMainWindowObjShow(true, false, false, false)
end

UISmashingPenguinsMain.ShowSmashingPenguinsProgress = function(self, progress, birdId, hasGettedJoinReward)
  -- function num : 0_11 , upvalues : _ENV
  local strProcess = tostring(progress / 100)
  ;
  ((self.ui).tex_Rate):SetIndex(0, strProcess)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_tatalRate).text = strProcess .. "%"
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).bar).value = progress / 10000
  self:InitGlobleAwards(progress, birdId)
  self.hasGettedJoinReward = hasGettedJoinReward
  if not hasGettedJoinReward then
    self:__ShowFirstAwardPanel(birdId)
  end
  self:ShowProgressObj()
end

UISmashingPenguinsMain.ShowProgressObj = function(self)
  -- function num : 0_12
  ((self.ui).objProgress):SetActive(self.hasGettedJoinReward)
end

UISmashingPenguinsMain.InitGlobleAwards = function(self, progress, birdId)
  -- function num : 0_13 , upvalues : _ENV
  local fbConfig = (ConfigData.flappy_bird)[birdId]
  if fbConfig == nil then
    error("找不到对应的flappy bird 配置，birdid:" .. tostring(birdId))
    return 
  end
  ;
  (self.giftPool):HideAll()
  if fbConfig.progress_precent == nil or #fbConfig.progress_precent <= 0 then
    return 
  end
  local totalWidth = (((self.ui).awardItemRoot).rect).width
  for i = 1, #fbConfig.progress_precent do
    local curPercent = (fbConfig.progress_precent)[i]
    local giftItem = (self.giftPool):GetOne()
    giftItem:InjectAwardData(fbConfig, self.__showAwardFunc, i)
    giftItem:UpdatePosAndTips(progress, curPercent, totalWidth)
  end
end

UISmashingPenguinsMain.__ShowFirstAwardPanel = function(self, birdId)
  -- function num : 0_14 , upvalues : _ENV, FirstAwardTitleIndex
  local fbConfig = (ConfigData.flappy_bird)[birdId]
  if fbConfig == nil then
    error("找不到对应的flappy bird 配置，birdid:" .. tostring(birdId))
    return 
  end
  self:__ShowAwardPanel(fbConfig.firstAwards, fbConfig, FirstAwardTitleIndex, (self.ui).firstAwardPanelRoot)
end

UISmashingPenguinsMain.__ShowAwardPanel = function(self, awards, fbConfig, titleTextIndex, rootTrans)
  -- function num : 0_15 , upvalues : UINFlappyAwardPanel, _ENV
  if self.awardPanel == nil then
    self.awardPanel = (UINFlappyAwardPanel.New)()
    ;
    (self.awardPanel):Init((self.ui).awardView)
  end
  if titleTextIndex > 0 then
    (((self.ui).btn_awardPanelBack).gameObject):SetActive(true)
  end
  if not IsNull(rootTrans) then
    ((self.awardPanel).transform):SetParent(rootTrans, false)
  end
  ;
  (self.awardPanel):ShowAwardList(awards, fbConfig, titleTextIndex)
  ;
  (self.awardPanel):Show()
end

UISmashingPenguinsMain.__HideAwardPanel = function(self)
  -- function num : 0_16
  if self.awardPanel == nil or not (self.awardPanel).active then
    return 
  end
  if not self.hasGettedJoinReward then
    return 
  else
    ;
    (((self.ui).btn_awardPanelBack).gameObject):SetActive(false)
  end
  ;
  (self.awardPanel):Hide()
end

UISmashingPenguinsMain.RefreshHighestScore = function(self, maxScore)
  -- function num : 0_17 , upvalues : _ENV
  if maxScore == nil then
    return 
  end
  ;
  (((self.ui).cur_textScore).gameObject):SetActive(true)
  ;
  ((self.ui).cur_textScore):SetIndex(0, tostring(maxScore))
end

UISmashingPenguinsMain.OnShowRankBtnClick = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if (self.smashingPenguinsController):GetIsSmashingPenguinsActOver() then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6033))
    return 
  end
  self:__HideAwardPanel()
  self:SetMainWindowObjShow(false, false, false, false)
  ;
  (self.smashingPenguinsController):ReqShowRanking()
  ;
  ((self.ui).obj_backWall):SetActive(false)
end

UISmashingPenguinsMain.BackAction = function(self)
  -- function num : 0_19
  (self.smashingPenguinsController):ClearSmashingPenguinsGameState()
  ;
  (self.smashingPenguinsController):OnExitSmashingPenguins()
  if self.animCtrl ~= nil then
    (self.animCtrl):Delete()
    self.animCtrl = nil
  end
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self:Delete()
end

UISmashingPenguinsMain.OnQuitGameBtnClick = function(self)
  -- function num : 0_20 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UISmashingPenguinsMain.OnPauseGameBtnClick = function(self)
  -- function num : 0_21
  (self.smashingPenguinsController):SetSmashingPenguinsGamePause(true)
  self:SetMainWindowObjShow(false, false, false, false)
  ;
  (self.pauseNode):Show()
  ;
  (self.pauseNode):InitSmashingPenguinsPause(self.smashingPenguinsController)
end

UISmashingPenguinsMain.OnContinueGame = function(self)
  -- function num : 0_22
  self:SetMainWindowObjShow(false, true, false, false)
end

UISmashingPenguinsMain.ShowSmashingPenguinsResult = function(self, respMsg, resultRankData, mineGrade, hasGettedJoinReward, isHideBar)
  -- function num : 0_23
  self.hasGettedJoinReward = hasGettedJoinReward
  self:ShowProgressObj()
  self:__HideAwardPanel()
  ;
  (self.resultNode):Show()
  ;
  (self.resultNode):InitSmashingPenguinsResult(self.smashingPenguinsController)
  ;
  (self.resultNode):RefreshScore(respMsg.score, respMsg.beyondProgress, isHideBar)
  ;
  (self.resultNode):RefreshResultRank(resultRankData, mineGrade)
end

UISmashingPenguinsMain.OnResultBtnClick = function(self)
  -- function num : 0_24
  (self.smashingPenguinsController):SmashingPenguinsResult()
  self:SetMainWindowObjShow(false, false, false, false)
end

UISmashingPenguinsMain.SetDragCannonGuideShow = function(self, isShow)
  -- function num : 0_25
  ((self.ui).obj_gestureGuide):SetActive(isShow == true)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UISmashingPenguinsMain.SetUseBombGuideShow = function(self, isShow)
  -- function num : 0_26
  ((self.ui).obj_bombGuide):SetActive(isShow == true)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UISmashingPenguinsMain.SetUseBombBtnShow = function(self, isShow)
  -- function num : 0_27
  ((self.ui).obj_bombUIGroup):SetActive(isShow)
end

UISmashingPenguinsMain.OnUseBombBtnClick = function(self)
  -- function num : 0_28
  (self.smashingPenguinsController):UseSmashingPenguinsBomb()
end

UISmashingPenguinsMain.OnUpdateInGameUI = function(self)
  -- function num : 0_29 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_inGameScore).text = tostring((self.smashingPenguinsController).currentScore)
end

UISmashingPenguinsMain.SetTrackerShow = function(self, isShow)
  -- function num : 0_30
  (self.tracker):SetActive(isShow == true)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UISmashingPenguinsMain.SetTrackerPos = function(self, WorldPos)
  -- function num : 0_31
  local characterLocalUiPosition = (((self.ui).obj_start).transform):InverseTransformPoint(WorldPos)
  local trackerLocalPos = ((self.tracker).transform).localPosition
  trackerLocalPos.x = characterLocalUiPosition.x
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.tracker).transform).localPosition = trackerLocalPos
end

UISmashingPenguinsMain.OnCharacterDie = function(self)
  -- function num : 0_32
  self:SetMainWindowObjShow(false, false, true, false)
end

UISmashingPenguinsMain.__OnGestureStart = function(self, finger)
  -- function num : 0_33
  (self.smashingPenguinsController):OnGestureStart(finger)
end

UISmashingPenguinsMain.__OnGesture = function(self, fingerList)
  -- function num : 0_34
  (self.smashingPenguinsController):OnGesture(fingerList)
end

UISmashingPenguinsMain.__OnGestureEnd = function(self, finger)
  -- function num : 0_35
  (self.smashingPenguinsController):OnGestureEnd(finger)
end

UISmashingPenguinsMain.OnDelete = function(self)
  -- function num : 0_36 , upvalues : base
  (base.OnDelete)(self)
  ;
  (self.cannonPool):DeleteAll()
  ;
  (self.windPool):DeleteAll()
  ;
  (self.bombPool):DeleteAll()
  ;
  (self.upWallPool):DeleteAll()
  ;
  (self.midWallPool):DeleteAll()
  ;
  (self.downWallPool):DeleteAll()
  ;
  (self.explosionPool):DeleteAll()
  ;
  (self.giftPool):DeleteAll()
end

return UISmashingPenguinsMain

