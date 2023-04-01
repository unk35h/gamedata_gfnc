-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UISnakeGame = class("UISnakeGame", base)
local cs_DoTween = ((CS.DG).Tweening).DOTween
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local UINSnakeGameLeft = require("Game.TinyGames.Snake.UI.UINSnakeGameLeft")
UISnakeGame.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSnakeGameLeft, UINBaseItemWithReceived
  (UIUtil.AddButtonListener)((self.ui).btn_BackPause, self, self._OnBtnGamePause)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GiveUp, self, self._OnBtnGiveup)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Continue, self, self._OnBtnContinue)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Retry, self, self._OnBtnRetry)
  self._snakeLeftNode = (UINSnakeGameLeft.New)()
  ;
  (self._snakeLeftNode):Init((self.ui).left)
  ;
  (UIUtil.SetTopStatus)(self, self._OnReturnClick, nil, nil, nil, true)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem, false)
end

UISnakeGame._InitSnakeGameUI = function(self, snakeCtrl)
  -- function num : 0_1
  self._snakeCtrl = snakeCtrl
  self._lastReward = nil
  self:InitSnakeRewardUI()
  ;
  (self._snakeLeftNode):InitSnakeGameLeft(self._snakeCtrl, self)
end

UISnakeGame.RefeshSnakeBestScore = function(self, bestScore, rankIndex)
  -- function num : 0_2
  (self._snakeLeftNode):RefeshSnakeLeftBestScore(bestScore, rankIndex)
end

UISnakeGame.InitSnakeRewardUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local snakeGame = (self._snakeCtrl):GetSnakeGameData()
  local requireScore, isRewarded = snakeGame:GetSnakeRewardState()
  if self._lastReward == isRewarded then
    return 
  end
  self._lastReward = isRewarded
  ;
  ((self.ui).tex_Target):SetIndex(0, tostring(requireScore))
  ;
  (self._rewardPool):HideAll()
  local itemIds, itemNums = snakeGame:GetSnakeGameReward()
  for index,itemId in pairs(itemIds) do
    local itemNum = itemNums[index]
    local rewardItem = (self._rewardPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    rewardItem:InitItemWithCount(itemCfg, itemNum, nil, isRewarded)
  end
end

UISnakeGame.EnterSnakeInitStateUI = function(self)
  -- function num : 0_4
  self:EnterSnakePauseUI(false)
  ;
  ((self.ui).resultNode):SetActive(false)
  ;
  (self._snakeLeftNode):EnterSnakeGameLeftInit()
end

UISnakeGame.InitSnakePlayUI = function(self)
  -- function num : 0_5
  ((self.ui).img_Pause):SetActive(true)
  ;
  ((self.ui).img_Back):SetActive(false)
  ;
  ((self.ui).pausetNode):SetActive(false)
  ;
  ((self.ui).resultNode):SetActive(false)
  ;
  (self._snakeLeftNode):InitSnakeGameLeftPlay()
end

UISnakeGame.InitSnakeEndUI = function(self, score, bestScore, rankIndex)
  -- function num : 0_6 , upvalues : _ENV
  ((self.ui).resultNode):SetActive(true)
  ;
  ((self.ui).img_Pause):SetActive(false)
  ;
  ((self.ui).img_Back):SetActive(true)
  ;
  ((self.ui).pausetNode):SetActive(false)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_NowNumber).text = tostring(score)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_BestNumber).text = tostring((math.max)(score, bestScore))
  ;
  ((self.ui).tex_RankNumber):SetIndex(0, tostring(rankIndex))
  ;
  (self._snakeLeftNode):InitSnakeGameLeftEnd()
  AudioManager:PlayAudioById(1267)
end

UISnakeGame.EnterSnakePauseUI = function(self, active)
  -- function num : 0_7
  ((self.ui).pausetNode):SetActive(active)
end

UISnakeGame.RefreshSnakeScore = function(self, score)
  -- function num : 0_8
  (self._snakeLeftNode):RefreshSnakeLeftScore(score)
end

UISnakeGame.ShowSnakeReadyUI = function(self, callback)
  -- function num : 0_9 , upvalues : _ENV, cs_DoTween
  (UIUtil.AddOneCover)("UISnakeGame")
  ;
  ((self.ui).readyNode):SetActive(true)
  ;
  ((self.ui).tex_Ready):SetIndex(0)
  local seq = (cs_DoTween.Sequence)()
  seq:AppendInterval((self.ui).time_Ready1)
  seq:AppendCallback(function()
    -- function num : 0_9_0 , upvalues : self
    ((self.ui).tex_Ready):SetIndex(1)
  end
)
  seq:AppendInterval((self.ui).time_Ready2)
  seq:OnComplete(function()
    -- function num : 0_9_1 , upvalues : self, _ENV, callback
    self._readySeq = nil
    ;
    (UIUtil.CloseOneCover)("UISnakeGame")
    ;
    ((self.ui).readyNode):SetActive(false)
    if callback ~= nil then
      callback()
    end
  end
)
  seq:SetUpdate(true)
  self._readySeq = seq
end

UISnakeGame._OnBtnGamePause = function(self)
  -- function num : 0_10 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UISnakeGame._OnReturnClick = function(self)
  -- function num : 0_11
  return (self._snakeCtrl):ClickSnakeGameReturn()
end

UISnakeGame._OnBtnGiveup = function(self)
  -- function num : 0_12
  (self._snakeCtrl):ClickSnakeGiveup()
end

UISnakeGame._OnBtnContinue = function(self)
  -- function num : 0_13
  (self._snakeCtrl):ClickSnakeContinue(true)
end

UISnakeGame._OnBtnRetry = function(self)
  -- function num : 0_14
  (self._snakeCtrl):ClickSnakeRetry()
end

UISnakeGame.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  (UIUtil.CloseOneCover)("UISnakeGame")
  if self._readySeq ~= nil then
    self._readySeq = nil
    ;
    (self._readySeq):Kill()
  end
  ;
  (base.OnDelete)(self)
end

return UISnakeGame

