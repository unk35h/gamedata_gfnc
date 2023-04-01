-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGameDamieSettle = class("UIGameDamieSettle", UIBaseNode)
local base = UIBaseNode
local RankingItem = require("Game.TinyGames.FlappyBird.UI.UINRankingItem")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UIGameDamieSettle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, RankingItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.rankingItemPool = (UIItemPool.New)(RankingItem, (self.ui).rankingItem)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Restart, self, self.OnBack)
end

UIGameDamieSettle.InjectRestartAction = function(self, back2Start)
  -- function num : 0_1
  self.__back2Start = back2Start
end

UIGameDamieSettle.OnBack = function(self)
  -- function num : 0_2
  if self.__back2Start ~= nil then
    (self.__back2Start)()
  end
  self:Hide()
end

UIGameDamieSettle.RefreshScore = function(self, score, bydRatio, isNew)
  -- function num : 0_3 , upvalues : _ENV
  if not score then
    score = 0
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(score)
  ;
  ((self.ui).img_NewScore):SetActive(isNew or false)
end

UIGameDamieSettle.RefreshDamieResultRank = function(self, resultRankData, mineGrade)
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

UIGameDamieSettle.OnShow = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnShow)(self)
  self:__InitFlappyResultTween()
end

UIGameDamieSettle.__InitFlappyResultTween = function(self)
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

UIGameDamieSettle.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
  if self.resultSeq ~= nil then
    (self.resultSeq):Kill()
    self.resultSeq = nil
  end
  ;
  (self.rankingItemPool):DeleteAll()
end

return UIGameDamieSettle

