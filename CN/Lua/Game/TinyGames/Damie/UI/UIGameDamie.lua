-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGameDamie = class("UIGameDamie", UIBaseWindow)
local base = UIBaseWindow
local cs_Tweening = (CS.DG).Tweening
local cs_DoTween = cs_Tweening.DOTween
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
local DamieCharaItem = require("Game.TinyGames.Damie.UI.UIDamieCharaItem")
local EfcItem = require("Game.TinyGames.Damie.UI.UIDamieEfcItem")
local DamieRanking = require("Game.TinyGames.Damie.UI.UIGameDamieRanking")
local DamieSettle = require("Game.TinyGames.Damie.UI.UIGameDamieSettle")
local DamiePause = require("Game.TinyGames.Damie.UI.UIGameDamiePause")
local DamieConfig = require("Game.TinyGames.Damie.Config.DamieConfig")
local BossId = DamieConfig.BossId
local BossRemainTime = DamieConfig.BossRemainTime
local SpecialBossRemainTime = DamieConfig.SpecialBossRemainTime
local BossMaxPressedCount = DamieConfig.BossMaxPressedCount
local BossBornScoreTag = DamieConfig.BossBornScoreTag
local TotalTime = DamieConfig.TotalTime
local TimerInterval = DamieConfig.TimerInterval
local StepState = DamieConfig.StepState
local StepTime = DamieConfig.StepTime
local CharaConfig = DamieConfig.CharaConfig
local BonusTimeArg = DamieConfig.BonusTimeArg
local CharaVoSheetName = DamieConfig.CharaVoSheetName
UIGameDamie.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, StepState, EfcItem, DamieConfig
  self.netWork = NetworkManager:GetNetwork(NetworkTypeID.GameDamie)
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickDamieBack, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Start, self, self.__SwitchToStart)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self.__TryShowRanking)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Pause, self, self.__PauseGame)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.__ShowInfo)
  self:__InitCharaItem()
  self.grade = {score = 0, allTime = 0}
  self.__stepState = StepState.first
  self.__aliveCharaCount = 0
  self.casterItemIntarval = 1
  self.efcPool = (UIItemPool.New)(EfcItem, (self.ui).pressEfc)
  self.__reStartGame = BindCallback(self, self.__ReStartGame)
  self.__resumeAction = BindCallback(self, self.__Resume2Game)
  self.__exitAction = BindCallback(self, self.__Back2Main)
  self.__isPlaying = false
  -- DECOMPILER ERROR at PC84: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_Pause).interactable = false
  self.__stopProgressInGame = false
  self.__curBossTag = 1
  self.__lastBornedScore = 0
  -- DECOMPILER ERROR at PC91: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).endTime).text = DamieConfig.ActivityEndTime
end

UIGameDamie.__IsAllDie = function(self)
  -- function num : 0_1
  do return self.__aliveCharaCount <= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIGameDamie.InitDamieWithData = function(self, activityFwId, gameId, maxScore, isHistoryOpen, HTGData)
  -- function num : 0_2
  self.__activityFwId = activityFwId
  self.__gameId = gameId
  self.__highestScore = maxScore
  self.__isHistoryOpen = isHistoryOpen
  self.__HTGData = HTGData
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R6 in 'UnsetPending'

  if self.__isHistoryOpen then
    ((self.ui).endTime).text = HTGData:GetPlayEndTimeStr()
  end
end

UIGameDamie.InjectExitAction = function(self, onExit)
  -- function num : 0_3
  self.__onExit = onExit
end

UIGameDamie.__SwitchToStart = function(self)
  -- function num : 0_4
  self:__EnterGame()
end

UIGameDamie.__EnterGame = function(self)
  -- function num : 0_5 , upvalues : _ENV
  AudioManager:PlayAudioById(1217)
  ;
  ((self.ui).gaming_node):SetActive(true)
  ;
  ((self.ui).main_node):SetActive(false)
  self:__ShowGameScore((self.grade).score)
  self:__CountDownTipStart(BindCallback(self, self.__GameRun))
end

UIGameDamie.__GameRun = function(self)
  -- function num : 0_6 , upvalues : _ENV, TotalTime, TimerInterval
  AudioManager:PlayAudioById(1217)
  self.__isPlaying = true
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_Pause).interactable = true
  self.internalCastIndex = 0
  self.curProgressTime = TotalTime
  self.accTime = 0
  self.totalTimerId = TimerManager:StartTimer(TimerInterval, BindCallback(self, self.__ProgressTimeCb))
end

UIGameDamie.__PauseGame = function(self)
  -- function num : 0_7 , upvalues : _ENV, DamiePause
  if not self.__isPlaying then
    return 
  end
  Time:SetTimeScale(0)
  if self.__pauseUI == nil then
    self.__pauseUI = (DamiePause.New)()
    ;
    (self.__pauseUI):Init((self.ui).ui_pause)
  end
  ;
  (self.__pauseUI):Show()
  ;
  (self.__pauseUI):ShowScore((self.grade).score)
  ;
  (self.__pauseUI):InjectPauseAction(self.__resumeAction, self.__reStartGame, self.__exitAction)
end

UIGameDamie.__Back2Main = function(self)
  -- function num : 0_8
  self:__ResetGameState()
  ;
  ((self.ui).gaming_node):SetActive(false)
  ;
  ((self.ui).main_node):SetActive(true)
  self:__ResetTimeScale()
end

UIGameDamie.__ResetTimeScale = function(self)
  -- function num : 0_9 , upvalues : _ENV
  Time:SetTimeScale(1)
end

UIGameDamie.__Resume2Game = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if not self.__isPlaying then
    self:__ResetTimeScale()
    return 
  end
  self.__isPlaying = false
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_Pause).interactable = false
  self:__CountDownTipStart(BindCallback(self, self.__InternalResume), true)
end

UIGameDamie.__InternalResume = function(self)
  -- function num : 0_11
  self.__isPlaying = true
  self:__ResetTimeScale()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_Pause).interactable = true
end

UIGameDamie.__ReStartGame = function(self)
  -- function num : 0_12
  self:__ResetTimeScale()
  self:__ResetGameState()
  self:__EnterGame()
end

UIGameDamie.__ResetGameState = function(self)
  -- function num : 0_13 , upvalues : StepState, TotalTime
  self.__isPlaying = false
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_Pause).interactable = false
  if self.colorSeq ~= nil then
    (self.colorSeq):Kill()
    self.colorSeq = nil
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).progress_img).color = (self.ui).normalColor
  self:__StopCountDown()
  self:__StopProgressTimer()
  self:__StopInternalCastTimer()
  self:__HideAllEfcItem()
  self:__HideRemainItem()
  self.__stepState = StepState.first
  self.__aliveCharaCount = 0
  self.accTime = 0
  self.curProgressTime = TotalTime
  self.casterItemIntarval = 1
  self.__curPerCastInterval = nil
  self.internalCastIndex = 0
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.grade).score = 0
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).progress_img).fillAmount = 1
  self.__stopProgressInGame = false
  self.__curBossTag = 1
  self.__lastBornedScore = 0
end

UIGameDamie.__ShowGameScore = function(self, value)
  -- function num : 0_14 , upvalues : _ENV
  ((self.ui).tex_Score):SetIndex(0, tostring(value))
end

UIGameDamie.__AddScore = function(self, score)
  -- function num : 0_15
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  (self.grade).score = (self.grade).score + score
  self:__ShowGameScore((self.grade).score)
end

UIGameDamie.__ShowInfo = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)((ConfigData.game_config).gameDamieGuideInfoPic, nil)
end

UIGameDamie.__ProgressTimeCb = function(self)
  -- function num : 0_17 , upvalues : TimerInterval, TotalTime
  local curInterval = TimerInterval
  if self.__stopProgressInGame then
    curInterval = 0
  end
  self.curProgressTime = self.curProgressTime - curInterval
  self.accTime = self.accTime + curInterval
  local progress = self.curProgressTime / TotalTime
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).progress_img).fillAmount = progress
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  if self.curProgressTime <= 0 then
    ((self.ui).progress_img).fillAmount = 0
    self:__StopProgressTimer()
    self:__GameOver()
    return 
  end
  self:__HandleStepStateAndCaster(curInterval)
end

UIGameDamie.__HandleStepStateAndCaster = function(self, curInterval)
  -- function num : 0_18 , upvalues : CharaConfig, _ENV
  self:__HandleState()
  if not self:__IsAllDie() or self.internalCastIndex > 0 then
    return 
  end
  self.casterItemIntarval = self.casterItemIntarval + curInterval
  if self:__CheckBossBorn() then
    self:__CasterBossItem()
    self:__HideAllEfcItem()
    self.casterItemIntarval = 0
    return 
  end
  local cfg = CharaConfig[self.__stepState]
  if self.__curCasterInterval == nil then
    self.__curCasterInterval = self:__GetCasterInterval()
    self.__curPerCastInterval = 0
    if cfg.perCastInterval ~= nil then
      self.__curPerCastInterval = (cfg.perCastInterval)[(math.random)(1, #cfg.perCastInterval)]
    end
  end
  if self.__curCasterInterval <= self.casterItemIntarval then
    self:__HideAllEfcItem()
    self:__HandleCaster(cfg.casterMaxCount, self.__curPerCastInterval)
    self.casterItemIntarval = 0
    self.__curPerCastInterval = nil
    self.__curCasterInterval = nil
  end
end

UIGameDamie.__CheckBossBorn = function(self)
  -- function num : 0_19 , upvalues : BossBornScoreTag, _ENV
  local tagCount = #BossBornScoreTag
  if tagCount < self.__curBossTag then
    return 
  end
  local tagScore = BossBornScoreTag[self.__curBossTag]
  if tagScore <= (self.grade).score - self.__lastBornedScore then
    self.__lastBornedScore = (self.grade).score
    self.__curBossTag = (math.min)(self.__curBossTag + 1, tagCount)
    return true
  end
  return false
end

UIGameDamie.__GameOver = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local score = (self.grade).score
  self:__ResetGameState()
  if self.__isHistoryOpen then
    (self.__HTGData):HTGCommonSettle(score, function(tinyGameCenterElem)
    -- function num : 0_20_0 , upvalues : self
    self:__ShowSettleUI({Count = 1, [0] = tinyGameCenterElem})
  end
)
    return 
  end
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actFrameData = actCtrl:GetActivityFrameData(self.__activityFwId)
  if actFrameData ~= nil and actFrameData:IsActivityOpen() then
    (self.netWork):CS_ACTIVITY_REFRESHDUNGEON_DamieSettle(self.__activityFwId, self.__gameId, score, BindCallback(self, self.__ShowSettleUI))
  else
    self:OnClickDamieBack()
  end
end

UIGameDamie.__ShowSettleUI = function(self, objList)
  -- function num : 0_21 , upvalues : _ENV, DamieSettle
  if objList.Count <= 0 then
    error("CS_ACTIVITY_REFRESHDUNGEON_DamieSettle objList.Count error:" .. tostring(objList.Count))
    return 
  end
  local msg = objList[0]
  if self.__uiSettle == nil then
    self.__uiSettle = (DamieSettle.New)()
    ;
    (self.__uiSettle):Init((self.ui).gameOver)
  end
  AudioManager:PlayAudioById(1218)
  ;
  (self.__uiSettle):Show()
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.grade).score = msg.score
  local isNew = self.__highestScore or 0 < (self.grade).score
  self.__highestScore = msg.highestScore
  ;
  (self.__uiSettle):RefreshScore((self.grade).score, isNew)
  local allFriendsData, mineGrade = nil, nil
  if self.__isHistoryOpen then
    local rankData = (self.__HTGData):GetHTGRankData()
    allFriendsData = rankData.allFriendData
    mineGrade = rankData.mineGrade
  else
    if not self:__GetFriendDamieData() then
      allFriendsData = {}
    end
    mineGrade = self:__CreateMineDamieGrade((self.grade).score)
    ;
    (table.insert)(allFriendsData, mineGrade)
    self:__SortRankDamieData(allFriendsData)
  end
  local finalData = self:__GetResultFriendRankingData(allFriendsData, mineGrade)
  ;
  (self.__uiSettle):RefreshDamieResultRank(finalData, mineGrade)
  ;
  (self.__uiSettle):InjectRestartAction(self.__exitAction)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIGameDamie.__GetResultFriendRankingData = function(self, allFriendData, mineGrade)
  -- function num : 0_22 , upvalues : _ENV
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

UIGameDamie.__GetCasterInterval = function(self)
  -- function num : 0_23 , upvalues : CharaConfig, StepState, _ENV
  local cfg = CharaConfig[self.__stepState]
  if self.__stepState == StepState.first or self.__stepState == StepState.fourth or self.__stepState == StepState.fifth then
    return cfg.interval
  else
    local intervalIndex = (math.random)(1, #cfg.interval)
    return (cfg.interval)[intervalIndex]
  end
end

UIGameDamie.__HandleState = function(self)
  -- function num : 0_24 , upvalues : StepState, _ENV, StepTime
  if self.__stepState == StepState.fifth then
    return 
  end
  for index,time in ipairs(StepTime) do
    if self.accTime <= time then
      self.__stepState = index
      return 
    end
  end
  self.__stepState = StepState.fifth
end

UIGameDamie.__HideRemainItem = function(self)
  -- function num : 0_25 , upvalues : _ENV
  if (self.itemBoss).active then
    (self.itemBoss):Hide()
    ;
    ((self.itemBoss).transform):SetParent((self.ui).charaPool, false)
  end
  for _,pool in ipairs(self.itemPools) do
    for t,item in ipairs(pool.listItem) do
      (item.transform):SetParent((self.ui).charaPool, false)
    end
    pool:HideAll()
  end
end

UIGameDamie.__StopProgressTimer = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if self.totalTimerId == nil then
    return 
  end
  TimerManager:StopTimer(self.totalTimerId)
  self.totalTimerId = nil
end

UIGameDamie.__CountDownTipStart = function(self, action, unscaled)
  -- function num : 0_27 , upvalues : _ENV
  self.countDownIndex = 0
  ;
  (((self.ui).tex_Time).gameObject):SetActive(true)
  ;
  ((self.ui).tex_Time):SetIndex(self.countDownIndex)
  self.countDownTimerId = TimerManager:StartTimer(1, (BindCallback(self, self.__CountDownCb, action)), nil, false, false, unscaled or false)
end

UIGameDamie.__CountDownCb = function(self, action)
  -- function num : 0_28
  self.countDownIndex = self.countDownIndex + 1
  if self.countDownIndex >= 3 then
    if action ~= nil then
      action()
    end
    self:__StopCountDown()
    ;
    (((self.ui).tex_Time).gameObject):SetActive(false)
    return 
  end
  ;
  ((self.ui).tex_Time):SetIndex(self.countDownIndex)
end

UIGameDamie.__StopCountDown = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self.countDownTimerId == nil then
    return 
  end
  TimerManager:StopTimer(self.countDownTimerId)
  self.countDownTimerId = nil
end

UIGameDamie.__InitCharaItem = function(self)
  -- function num : 0_30 , upvalues : _ENV, DamieCharaItem
  local charaItems = (self.ui).charaItems
  self.itemPools = {}
  for k,v in ipairs(charaItems) do
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

    (self.itemPools)[k] = (UIItemPool.New)(DamieCharaItem, v)
  end
  self.__posArray = {1, 2, 3, 4, 5, 6, 7, 8}
  self.__itemArray = {}
  for i = 1, #charaItems do
    (table.insert)(self.__itemArray, i)
  end
  self.itemBoss = (DamieCharaItem.New)()
  ;
  (self.itemBoss):Init((self.ui).obj_BossPic)
end

UIGameDamie.__CasterBossItem = function(self)
  -- function num : 0_31 , upvalues : BossId, BossRemainTime, BossMaxPressedCount, _ENV
  if self.itemBoss == nil then
    return 
  end
  ;
  (self.itemBoss):Show()
  ;
  (self.itemBoss):InitWithData(BossId, BossRemainTime, BossMaxPressedCount)
  ;
  (self.itemBoss):InjectPressFunc(BindCallback(self, self.__OnBossItemPresses, 1, self.itemBoss))
  ;
  (self.itemBoss):InjectRecycleItemFunc(BindCallback(self, self.__OnRecycleItem, self.itemBoss))
  self:__RandomArray(self.__posArray)
  local posIndex = (self.__posArray)[1]
  local posRoot = ((self.ui).pos_roots)[posIndex]
  ;
  ((self.itemBoss).transform):SetParent(posRoot, false)
  ;
  (self.itemBoss):Active()
  self.__stopProgressInGame = true
  self.__aliveCharaCount = self.__aliveCharaCount + 1
end

UIGameDamie.__GetItem = function(self, id, existTime)
  -- function num : 0_32 , upvalues : _ENV
  local pool = (self.itemPools)[id]
  local item = pool:GetOne()
  item:InitWithData(id, existTime)
  item:InjectPressFunc(BindCallback(self, self.__OnNormalItemPressed, 1, item))
  item:InjectRecycleItemFunc(BindCallback(self, self.__OnRecycleItem, item))
  return item
end

UIGameDamie.__OnNormalItemPressed = function(self, score, item)
  -- function num : 0_33
  if not self.__isPlaying then
    return false
  end
  self:__AddScore(score)
  local efcItem = (self.efcPool):GetOne()
  ;
  (efcItem.transform):SetParent((item.transform).parent, false)
  efcItem:UpdateScore(1, item.dataId)
  efcItem:Active()
  self:__OnHitAudioPlay(item:GetDamieCharaItemHeroId())
  return true
end

UIGameDamie.__OnBossItemPresses = function(self, score, item, remainPressedCount)
  -- function num : 0_34 , upvalues : SpecialBossRemainTime, _ENV
  if not self.__isPlaying then
    return false
  end
  self:__AddScore(score)
  item:UpdateScoreGetted(score)
  item:UpdateExistTime(SpecialBossRemainTime)
  item:CheckAndActiveExtraState(true)
  if self.bossEfcItem == nil then
    self.bossEfcItem = (self.efcPool):GetOne()
  end
  ;
  ((self.bossEfcItem).transform):SetParent((item.transform).parent, false)
  ;
  (self.bossEfcItem):UpdateScore(item.scoreGetted, item.dataId)
  AudioManager:PlayAudioById(1214)
  if remainPressedCount <= 0 then
    return true
  end
  return false
end

UIGameDamie.__HideAllEfcItem = function(self)
  -- function num : 0_35 , upvalues : _ENV
  for _,v in ipairs((self.efcPool).listItem) do
    (v.transform):SetParent((self.ui).charaPool, false)
  end
  self.bossEfcItem = nil
  ;
  (self.efcPool):HideAll()
end

UIGameDamie.__OnRecycleItem = function(self, item, id)
  -- function num : 0_36 , upvalues : BossId, BonusTimeArg, _ENV, TotalTime
  self.__aliveCharaCount = self.__aliveCharaCount - 1
  ;
  (item.transform):SetParent((self.ui).charaPool, false)
  if id == BossId then
    self.__stopProgressInGame = false
    self.curProgressTime = self.curProgressTime + item.scoreGetted * BonusTimeArg
    self.curProgressTime = (math.min)(self.curProgressTime, TotalTime)
    self:__ShowProgressEfc()
    item:Hide()
    return 
  end
  local pool = (self.itemPools)[id]
  pool:HideOne(item)
end

UIGameDamie.__ShowProgressEfc = function(self)
  -- function num : 0_37 , upvalues : _ENV, cs_DoTween, cs_Tweening, cs_DoTweenLoopType
  if self.colorSeq ~= nil then
    (self.colorSeq):Kill()
  end
  AudioManager:PlayAudioById(1215)
  self.colorSeq = (cs_DoTween.Sequence)()
  ;
  (self.colorSeq):Append((((((self.ui).progress_img):DOColor((self.ui).specialColor, 0.3)):SetUpdate(true)):SetEase((cs_Tweening.Ease).OutQuad)):SetAutoKill(false))
  ;
  (self.colorSeq):Join((((((self.ui).progress_img).transform):DOPunchPosition((Vector3.New)(20, 0, 20), 0.2, 10)):SetEase((cs_Tweening.Ease).InQuad)):SetLoops(2, cs_DoTweenLoopType.Yoyo))
  ;
  (self.colorSeq):AppendCallback(function()
    -- function num : 0_37_0 , upvalues : self, _ENV
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).progress_img).color = (self.ui).normalColor
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (((self.ui).progress_img).transform).localPosition = Vector3.zero
  end
)
end

UIGameDamie.__HandleCaster = function(self, maxCount, perCasteInterval)
  -- function num : 0_38 , upvalues : _ENV
  local posCount = maxCount
  if maxCount > 1 then
    posCount = (math.random)(1, maxCount)
  end
  self:__RandomArray(self.__posArray)
  self:__RandomArray(self.__itemArray)
  if not perCasteInterval then
    perCasteInterval = 0
  end
  if perCasteInterval <= 0 then
    for i = 1, posCount do
      self:__InternalCastItem(i)
    end
  else
    do
      self.internalCastIndex = 1
      self:__InternalCastItem(self.internalCastIndex)
      self.internalCastTimeId = TimerManager:StartTimer(perCasteInterval, BindCallback(self, self.__CasteByInterval, maxCount))
    end
  end
end

UIGameDamie.__CasteByInterval = function(self, maxCount)
  -- function num : 0_39
  self.internalCastIndex = self.internalCastIndex + 1
  self:__InternalCastItem(self.internalCastIndex)
  if maxCount <= self.internalCastIndex then
    self:__StopInternalCastTimer()
  end
end

UIGameDamie.__StopInternalCastTimer = function(self)
  -- function num : 0_40 , upvalues : _ENV
  self.internalCastIndex = 0
  if self.internalCastTimeId == nil then
    return 
  end
  TimerManager:StopTimer(self.internalCastTimeId)
  self.internalCastTimeId = nil
end

UIGameDamie.__InternalCastItem = function(self, randomIdex)
  -- function num : 0_41
  local curId = nil
  if #self.__itemArray < randomIdex then
    curId = (self.__itemArray)[#self.__itemArray]
  else
    curId = (self.__itemArray)[randomIdex]
  end
  local existTime = self:__GetExistTime()
  local item = self:__GetItem(curId, existTime)
  local curPosId = (self.__posArray)[randomIdex]
  local posRoot = ((self.ui).pos_roots)[curPosId]
  ;
  (item.transform):SetParent(posRoot, false)
  item:Active()
  item:Show()
  self.__aliveCharaCount = self.__aliveCharaCount + 1
end

UIGameDamie.__GetExistTime = function(self)
  -- function num : 0_42 , upvalues : StepState, CharaConfig, _ENV
  if self.__stepState == StepState.first or self.__stepState == StepState.fifth then
    return (CharaConfig[self.__stepState]).remainTime
  else
    local index = (math.random)(1, 2)
    return ((CharaConfig[self.__stepState]).remainTime)[index]
  end
end

UIGameDamie.__RandomArray = function(self, array)
  -- function num : 0_43 , upvalues : _ENV
  local length = #array
  for i = 1, length do
    local index_tmp = (math.random)(i, length)
    if index_tmp ~= i then
      local temp = array[i]
      array[i] = array[index_tmp]
      array[index_tmp] = temp
    end
  end
end

UIGameDamie.__TryShowRanking = function(self)
  -- function num : 0_44 , upvalues : _ENV, DamieRanking
  local LocalFunc_Enter = function()
    -- function num : 0_44_0 , upvalues : self, _ENV, DamieRanking
    local allFriendsData, mineGrade, bestGrade = nil, nil, nil
    if self.__isHistoryOpen then
      local rankData = (self.__HTGData):GetHTGRankData()
      allFriendsData = rankData.allFriendData
      mineGrade = rankData.mineGrade
      bestGrade = (self.__HTGData):GetHTGHistoryHighScore()
    else
      do
        if not self:__GetFriendDamieData() then
          allFriendsData = {}
        end
        mineGrade = self:__CreateMineDamieGrade(self.__highestScore or 0)
        ;
        (table.insert)(allFriendsData, mineGrade)
        self:__SortRankDamieData(allFriendsData)
        bestGrade = self.__highestScore or 0
        if self.__uiDamieRanking == nil then
          self.__uiDamieRanking = (DamieRanking.New)()
          ;
          (self.__uiDamieRanking):Init((self.ui).rank)
        end
        ;
        (self.__uiDamieRanking):Show()
        ;
        (self.__uiDamieRanking):RefreshDamieRankingData(allFriendsData, mineGrade)
        ;
        (self.__uiDamieRanking):SetBestScore(bestGrade)
      end
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

UIGameDamie.__GetFriendDamieData = function(self)
  -- function num : 0_45 , upvalues : _ENV
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return nil
  end
  local friendsData = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendsData == nil or #friendsData <= 0 then
    return nil
  end
  local allGrades = {}
  for _,v in ipairs(friendsData) do
    local eachFriendGrade = {}
    eachFriendGrade.name = v:GetUserName()
    eachFriendGrade.score = 0
    eachFriendGrade.uid = v:GetUserUID()
    local gameDamieData = v:GetFriendDamieData()
    if gameDamieData ~= nil and gameDamieData.gameId == self.__gameId then
      eachFriendGrade.score = gameDamieData.score
    end
    ;
    (table.insert)(allGrades, eachFriendGrade)
  end
  return allGrades
end

UIGameDamie.__CreateMineDamieGrade = function(self, highestScore)
  -- function num : 0_46 , upvalues : _ENV
  if self.mineGrade == nil then
    self.mineGrade = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).name = PlayerDataCenter:GetSelfName()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).uid = PlayerDataCenter:GetSelfId()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).score = highestScore
  return self.mineGrade
end

UIGameDamie.__SortRankDamieData = function(self, allFriendData)
  -- function num : 0_47 , upvalues : _ENV
  if #allFriendData > 1 then
    (table.sort)(allFriendData, function(a, b)
    -- function num : 0_47_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  end
end

UIGameDamie.__OnHitAudioPlay = function(self, characterId)
  -- function num : 0_48 , upvalues : _ENV, CharaVoSheetName
  local dunHeroCfg = (ConfigData.activity_refresh_dungeon_hero)[characterId]
  if dunHeroCfg == nil then
    error("Cant get activity_refresh_dungeon_hero cfg, heroId : " .. tostring(characterId))
    return 
  end
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  local _, cueName = cvCtr:GetSheetNameAndCueName(characterId, dunHeroCfg.voice_id)
  if cueName == nil then
    return 
  end
  AudioManager:PlayAudio(cueName, CharaVoSheetName, eAudioSourceType.VoiceSource)
end

UIGameDamie.OnClickDamieBack = function(self)
  -- function num : 0_49
  self:Delete()
  if self.__onExit ~= nil then
    (self.__onExit)()
    self.__onExit = nil
  end
end

UIGameDamie.OnDelete = function(self)
  -- function num : 0_50 , upvalues : _ENV, CharaVoSheetName
  self:__ResetGameState()
  AudioManager:RemoveCueSheet(CharaVoSheetName)
  ;
  (self.itemBoss):Delete()
  for _,pool in ipairs(self.itemPools) do
    pool:DeleteAll()
  end
  self.itemPools = nil
  ;
  (self.efcPool):DeleteAll()
  if self.colorSeq ~= nil then
    (self.colorSeq):Kill()
    self.colorSeq = nil
  end
end

return UIGameDamie

