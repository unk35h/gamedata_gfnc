-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyResult = class("UINFlappyResult", UIBaseNode)
local base = UIBaseNode
local RankingItem = require("Game.TinyGames.FlappyBird.UI.UINRankingItem")
local FlappyBirdAudioConfig = require("Game.TinyGames.FlappyBird.Config.FlappyBirdAudioConfig")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UINFlappyResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, RankingItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.rankingItemPool = (UIItemPool.New)(RankingItem, (self.ui).rankingItem)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Restart, self, self.OnBack)
end

UINFlappyResult.InjectRestartAction = function(self, back2Start)
  -- function num : 0_1
  self.__back2Start = back2Start
end

UINFlappyResult.OnBack = function(self)
  -- function num : 0_2 , upvalues : _ENV, FlappyBirdAudioConfig
  AudioManager:PlayAudioById(FlappyBirdAudioConfig.OnClickButton)
  if self.__back2Start ~= nil then
    (self.__back2Start)()
  end
  self:Hide()
end

UINFlappyResult.RefreshScore = function(self, score, bydRatio, isHistoryOpen, isRemaster)
  -- function num : 0_3 , upvalues : _ENV
  if not score then
    score = 0
  end
  if not bydRatio then
    bydRatio = 0
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(score)
  ;
  ((self.ui).barGroup):SetActive((not isHistoryOpen and not isRemaster))
  if not isHistoryOpen and not isRemaster then
    ((self.ui).tex_Result):SetIndex(0, tostring(bydRatio / 100))
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).bar).value = bydRatio / 10000
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINFlappyResult.RefreshResultRank = function(self, resultRankData, mineGrade)
  -- function num : 0_4 , upvalues : _ENV
  (self.rankingItemPool):HideAll()
  if resultRankData == nil then
    return 
  end
  for index,v in ipairs(resultRankData) do
    local item = (self.rankingItemPool):GetOne()
    local isMine = mineGrade == v
    item:InitWithRankData(v, v.grade_index, isMine)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINFlappyResult.OnShow = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnShow)(self)
  self:__InitFlappyResultTween()
end

UINFlappyResult.__InitFlappyResultTween = function(self)
  -- function num : 0_6 , upvalues : cs_DoTween
  if self.resultSeq ~= nil then
    (self.resultSeq):Restart()
    return 
  end
  local seq = (cs_DoTween.Sequence)()
  seq:Append((((self.ui).rect_ranking):DOLocalMoveY(0, 0.6)):From())
  seq:Join((((self.ui).fade):DOFade(0, 0.35)):From())
  seq:SetAutoKill(false)
  self.resultSeq = seq
end

UINFlappyResult.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
  if self.resultSeq ~= nil then
    (self.resultSeq):Kill()
    self.resultSeq = nil
  end
  ;
  (self.rankingItemPool):DeleteAll()
end

return UINFlappyResult

