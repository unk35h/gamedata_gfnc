-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFlappyRanking = class("UIFlappyRanking", UIBaseWindow)
local base = UIBaseWindow
local RankingItem = require("Game.TinyGames.FlappyBird.UI.UINRankingItem")
local FlappyBirdAudioConfig = require("Game.TinyGames.FlappyBird.Config.FlappyBirdAudioConfig")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UIFlappyRanking.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Restart, self, self.HideAndBack)
  self.itemDic = {}
  self:__InitFlappyRankingTween()
end

UIFlappyRanking.RefreshRankingData = function(self, allFriendData, mineGrade, isHistoryOpen, isRemaster)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).obj_top):SetActive((not isHistoryOpen and not isRemaster))
  if not isHistoryOpen and not isRemaster then
    ((self.ui).maxBydProgress):SetIndex(0, tostring(mineGrade.bydProgress / 100))
  end
  if allFriendData == nil or mineGrade == nil then
    return 
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(mineGrade.score)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_UserName).text = mineGrade.name
  self.allFriendDataList = allFriendData
  if #self.allFriendDataList <= 1 then
    (((self.ui).tips).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tips).text = ConfigData:GetTipContent(7106)
  else
    (((self.ui).tips).gameObject):SetActive(false)
  end
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).scroll).onChangeItem = BindCallback(self, self.__OnChangeItem, mineGrade)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).scroll).totalCount = #self.allFriendDataList
  ;
  ((self.ui).scroll):RefillCells()
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UIFlappyRanking.SetBestScore = function(self, bestScore)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).tex_BestScore).gameObject):SetActive(true)
  ;
  ((self.ui).tex_BestScore):SetIndex(0, tostring(bestScore))
end

UIFlappyRanking.__OnChangeItem = function(self, mineGrade, go, index)
  -- function num : 0_3
  local item = (self.itemDic)[go]
  local itemData = (self.allFriendDataList)[index + 1]
  local isMine = mineGrade == itemData
  item:InitWithRankData(itemData, index + 1, isMine)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIFlappyRanking.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : RankingItem
  local item = (RankingItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UIFlappyRanking.HideAndBack = function(self)
  -- function num : 0_5 , upvalues : _ENV, FlappyBirdAudioConfig
  AudioManager:PlayAudioById(FlappyBirdAudioConfig.OnClickButton)
  local fbMainWin = UIManager:GetWindow(UIWindowTypeID.FlappyBird)
  if fbMainWin ~= nil then
    fbMainWin:SetMainUIShow(true)
    fbMainWin:SetMainPageTween(true)
  end
  self:Delete()
end

UIFlappyRanking.__InitFlappyRankingTween = function(self)
  -- function num : 0_6 , upvalues : cs_DoTween
  if self.rankingSeq ~= nil then
    (self.rankingSeq):Restart()
    return 
  end
  local seq = (cs_DoTween.Sequence)()
  seq:Append((((self.ui).fade_rank):DOFade(0, 0.6)):From())
  seq:Join(((((self.ui).fade_rank).transform):DOAnchorPosY(-100, 0.6)):From())
  seq:SetAutoKill(false)
  self.rankingSeq = seq
end

UIFlappyRanking.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  if self.rankingSeq ~= nil then
    (self.rankingSeq):Kill()
    self.rankingSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIFlappyRanking

