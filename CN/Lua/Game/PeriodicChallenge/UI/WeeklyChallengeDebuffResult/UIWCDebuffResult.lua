-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWCDebuffResult = class("UIWCDebuffResult", UIBaseWindow)
local base = UIBaseWindow
local UINWCDebuffResultItem = require("Game.PeriodicChallenge.UI.WeeklyChallengeDebuffResult.UINWCDebuffResultItem")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local cs_Ease = ((CS.DG).Tweening).Ease
local cs_Dotween = ((CS.DG).Tweening).DOTween
UIWCDebuffResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCDebuffResultItem
  self.protoLayer = nil
  self.scoreGainRate = nil
  self.scoreRate = nil
  self.historyMaxScore = 0
  self.curScore = 0
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Retry, self, self.__OnClickReChallenge)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NextStep, self, self.__OnClickContinue)
  self.resultItemPool = (UIItemPool.New)(UINWCDebuffResultItem, (self.ui).obj_debuffResultItem)
  ;
  ((self.ui).obj_debuffResultItem):SetActive(false)
  ;
  ((self.ui).obj_NewRecord):SetActive(false)
end

UIWCDebuffResult.InitWCDebuffResult = function(self, scoreShow, isWin, continueCallback)
  -- function num : 0_1 , upvalues : _ENV, ExplorationEnum
  self.elemDataDic = scoreShow.show
  self.curScore = scoreShow.score
  ;
  ((self.ui).tex_NextStep):SetIndex(1)
  ;
  ((self.ui).tex_Title):SetIndex(0)
  local dungeonId = ExplorationManager:GetEpDungeonId()
  self.wcData = (PlayerDataCenter.allWeeklyChallengeData):GetWeeklyChallengeDataByDungeonId(dungeonId)
  self.historyMaxScore = (self.wcData):GetCurrentMaxScore()
  self.protoLayer = (Mathf.Floor)(scoreShow.buffRateFix / 100)
  self.scoreGainRate = scoreShow.buffRateFix
  self.scoreRate = (scoreShow.baseRate + 1000) / 1000
  if self.wcData == nil then
    self.isHaveRankList = false
  else
    self.isHaveRankList = (self.wcData):GetIsHaveRankList()
  end
  if not ExplorationManager:IsInTDExp() or not (ExplorationEnum.epScoreStatisticsType).TowerStatistics then
    self.statisticsType = (ExplorationEnum.epScoreStatisticsType).NormalStatistics
    self.continueCallback = continueCallback
    self:__RefreshUI(isWin)
  end
end

UIWCDebuffResult._AddCanvasTween = function(self, canvasGroup, index)
  -- function num : 0_2 , upvalues : cs_Ease
  local tween = (((canvasGroup:DOFade(0, 0.3)):SetDelay(index * 0.12)):SetEase(cs_Ease.InCirc)):From()
  return tween
end

UIWCDebuffResult.InitWinChallengeScoreShow = function(self, msg, isWin, historyMaxScore, continueCallback)
  -- function num : 0_3 , upvalues : _ENV, cs_Dotween
  self.continueCallback = continueCallback
  local elemDataDic = msg.show
  ;
  ((self.ui).tex_Title):SetIndex(1)
  ;
  ((self.ui).tex_NextStep):SetIndex(1)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

  if isWin then
    ((self.ui).img_ResultBG).color = (self.ui).color_win
  else
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_ResultBG).color = (self.ui).color_loss
  end
  ;
  (((self.ui).cg_debuffConditon).gameObject):SetActive(false)
  ;
  (((self.ui).cg_scoreRatio).gameObject):SetActive(false)
  ;
  (((self.ui).cg_NewRecord).gameObject):SetActive(false)
  ;
  (((self.ui).cg_ThisRecord).gameObject):SetActive(true)
  ;
  ((self.ui).tex_historyMaxPoint):SetIndex(0, tostring(historyMaxScore))
  local index = 1
  local sequece = (cs_Dotween.Sequence)()
  self._showSequence = sequece
  local addFadeTween = function(canvasGroup)
    -- function num : 0_3_0 , upvalues : self, index, sequece
    local tween = self:_AddCanvasTween(canvasGroup, index)
    index = index + 1
    sequece:Insert(0, tween)
  end

  local elemDataList = {}
  for _,resultItemData in pairs(elemDataDic) do
    (table.insert)(elemDataList, resultItemData)
  end
  ;
  (table.sort)(elemDataList, function(a, b)
    -- function num : 0_3_1
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local itemCount = 0
  for i,resultItemData in ipairs(elemDataList) do
    if resultItemData.id ~= 3 or resultItemData.param ~= 0 then
      itemCount = itemCount + 1
      local resultItem = (self.resultItemPool):GetOne()
      resultItem:InitWinChallengeScoreResultItem(resultItemData)
      if itemCount <= 12 then
        addFadeTween((resultItem.ui).cg_debuffResultItem)
      end
    end
  end
  -- DECOMPILER ERROR at PC110: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).tex_NewPoint).text = tostring(msg.score)
  addFadeTween((self.ui).cg_ThisRecord)
  addFadeTween((self.ui).tex_NewPoint)
  addFadeTween((self.ui).cg_btn_NextStep)
  sequece:SetUpdate(true)
end

UIWCDebuffResult.InitWarchessSeasonResult = function(self, msg, historyMaxScore, isWin, continueCallback)
  -- function num : 0_4 , upvalues : _ENV
  self.continueCallback = continueCallback
  ;
  ((self.ui).tex_Title):SetIndex(2)
  ;
  ((self.ui).tex_NextStep):SetIndex(1)
  ;
  (((self.ui).cg_debuffConditon).gameObject):SetActive(false)
  ;
  (((self.ui).cg_scoreRatio).gameObject):SetActive(false)
  local curScore = msg ~= nil and msg.totalScore or 0
  local isNew = historyMaxScore < curScore
  historyMaxScore = (math.max)(curScore, historyMaxScore)
  ;
  (((self.ui).cg_NewRecord).gameObject):SetActive(isNew)
  ;
  (((self.ui).cg_ThisRecord).gameObject):SetActive(not isNew)
  ;
  ((self.ui).tex_historyMaxPoint):SetIndex(0, tostring(historyMaxScore))
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_NewPoint).text = tostring(curScore)
  local resultIds = (ConfigData.warchess_season_score_show).sortList
  if msg == nil or not msg.scoreDetail then
    local scoreDetail = table.emptytable
  end
  ;
  (self.resultItemPool):HideAll()
  for _,resultid in ipairs(resultIds) do
    local cfg = (ConfigData.warchess_season_score_show)[resultid]
    local resultItemData = scoreDetail[resultid]
    if cfg.need_show or resultItemData ~= nil and resultItemData.value > 0 then
      local resultItem = (self.resultItemPool):GetOne()
      resultItem:InitWarchessSeasonResultItem(cfg, scoreDetail[resultid])
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UIWCDebuffResult.__RefreshUI = function(self, isWin)
  -- function num : 0_5 , upvalues : _ENV, cs_Dotween
  local resultBG_Material = ((self.ui).img_ResultBG).material
  resultBG_Material:SetFloat("_Decoloration", 0)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  if isWin then
    ((self.ui).img_ResultBG).color = (self.ui).color_win
  else
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_ResultBG).color = (self.ui).color_loss
  end
  if self.isHaveRankList then
    (((self.ui).tex_historyMaxPoint).gameObject):SetActive(true)
    ;
    ((self.ui).tex_historyMaxPoint):SetIndex(0, tostring(self.historyMaxScore))
  else
    ;
    (((self.ui).tex_historyMaxPoint).gameObject):SetActive(false)
  end
  self.protoLayer = self.protoLayer > 0 and self.protoLayer or 0
  ;
  ((self.ui).tex_Layer):SetIndex(0, tostring(self.protoLayer))
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Gain).text = tostring(self.scoreGainRate / 10) .. "%"
  local isNewRecord = self:__IsNewRecord()
  ;
  ((self.ui).obj_scoreRatio):SetActive(self.scoreRate ~= 1)
  ;
  ((self.ui).tex_ScoureRatio):SetIndex(0, tostring(self.scoreRate))
  -- DECOMPILER ERROR at PC93: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_NewPoint).text = tostring(self.curScore)
  for scoreId,cfg in pairs(ConfigData.weekly_challenge_score) do
    -- DECOMPILER ERROR at PC119: Confused about usage of register: R9 in 'UnsetPending'

    if cfg.const_show and (table.contain)(cfg.type, self.statisticsType) then
      if (self.elemDataDic)[scoreId] == nil then
        (self.elemDataDic)[scoreId] = {id = scoreId, score = 0, param = 0, isconst = true}
      else
        -- DECOMPILER ERROR at PC123: Confused about usage of register: R9 in 'UnsetPending'

        ((self.elemDataDic)[scoreId]).isconst = true
      end
    end
  end
  local index = 1
  local sequece = (cs_Dotween.Sequence)()
  local addFadeTween = function(canvasGroup)
    -- function num : 0_5_0 , upvalues : self, index, sequece
    local tween = self:_AddCanvasTween(canvasGroup, index)
    index = index + 1
    sequece:Insert(0, tween)
  end

  local elemDataList = {}
  for _,resultItemData in pairs(self.elemDataDic) do
    if resultItemData.id ~= 18 then
      (table.insert)(elemDataList, resultItemData)
    end
  end
  ;
  (table.sort)(elemDataList, function(a, b)
    -- function num : 0_5_1
    if a.isconst ~= b.isconst then
      return a.isconst
    end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  if (self.elemDataDic)[18] ~= nil then
    (table.insert)(elemDataList, 1, (self.elemDataDic)[18])
  end
  ;
  (self.resultItemPool):HideAll()
  local itemCount = 0
  for i,resultItemData in ipairs(elemDataList) do
    if resultItemData.id ~= 19 or resultItemData.param ~= 0 then
      itemCount = itemCount + 1
      local resultItem = (self.resultItemPool):GetOne()
      resultItem:InitResultItem(resultItemData, itemCount)
      if itemCount <= 12 then
        addFadeTween((resultItem.ui).cg_debuffResultItem)
      end
    end
  end
  addFadeTween((self.ui).cg_debuffConditon)
  addFadeTween((self.ui).cg_total)
  if ((self.ui).obj_scoreRatio).activeInHierarchy then
    addFadeTween((self.ui).cg_scoreRatio)
  end
  if self.isHaveRankList and isNewRecord then
    sequece:InsertCallback(index * 0.12, function()
    -- function num : 0_5_2 , upvalues : self
    ((self.ui).obj_NewRecord):SetActive(true)
  end
)
    addFadeTween((self.ui).cg_NewRecord)
  end
  addFadeTween((self.ui).tex_NewPoint)
  addFadeTween((self.ui).cg_btn_NextStep)
  self._showSequence = sequece
  -- DECOMPILER ERROR: 9 unprocessed JMP targets
end

UIWCDebuffResult.__OnClickContinue = function(self)
  -- function num : 0_6
  self:Delete()
  if self.continueCallback ~= nil then
    (self.continueCallback)()
  end
end

UIWCDebuffResult.__OnClickReChallenge = function(self)
  -- function num : 0_7
  if self.reChallengeFunc ~= nil then
    (self.reChallengeFunc)()
  end
end

UIWCDebuffResult.__IsNewRecord = function(self)
  -- function num : 0_8
  do return self.historyMaxScore or 0 < self.curScore or 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWCDebuffResult.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  if self._showSequence ~= nil then
    (self._showSequence):Kill()
    self._showSequence = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWCDebuffResult

