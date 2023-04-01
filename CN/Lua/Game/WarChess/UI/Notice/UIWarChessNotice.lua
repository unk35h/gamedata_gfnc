-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessNotice = class("UIWarChessNotice", base)
local cs_DoTween = ((CS.DG).Tweening).DOTween
local UINWarChessNoticeShowBuff = require("Game.WarChess.UI.Notice.UINWarChessNoticeShowBuff")
local UINWarChessNoticeRewardTip = require("Game.WarChess.UI.Notice.UINWarChessNoticeRewardTip")
UIWarChessNotice.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINWarChessNoticeRewardTip
  self.__isPlaying = false
  self.__playQueue = {}
  ;
  ((self.ui).obj_turnEnd):SetActive(false)
  ;
  ((self.ui).obj_pressureLvUp):SetActive(false)
  ;
  ((self.ui).obj_gameStart):SetActive(false)
  self.showRewardNode = (UINWarChessNoticeRewardTip.New)()
  ;
  (self.showRewardNode):Init((self.ui).obj_rewardNode)
  ;
  (self.showRewardNode):Hide()
  self:__InitDoTween()
end

UIWarChessNotice.__InitDoTween = function(self)
  -- function num : 0_1 , upvalues : _ENV, cs_DoTween
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local turnOverQueue = (cs_DoTween.Sequence)()
  ;
  (((((turnOverQueue:AppendCallback(function()
    -- function num : 0_1_0 , upvalues : self
    ((self.ui).obj_turnEnd):SetActive(true)
  end
)):Join((((self.ui).cg_turn_tipsUILayer):DOFade(0, 0.1)):From())):AppendInterval(1.5)):AppendCallback(function()
    -- function num : 0_1_1 , upvalues : self
    ((self.ui).obj_turnEnd):SetActive(false)
    self:__TryPlayNext()
  end
)):SetAutoKill(false)):Pause()
  self.turnOverQueue = turnOverQueue
  local pressUpgradeQueue = (cs_DoTween.Sequence)()
  ;
  (((((pressUpgradeQueue:AppendCallback(function()
    -- function num : 0_1_2 , upvalues : self
    ((self.ui).obj_pressureLvUp):SetActive(true)
  end
)):Join((((self.ui).cg_press_tipsUILayer):DOFade(0, 0.1)):From())):AppendInterval(1.5)):AppendCallback(function()
    -- function num : 0_1_3 , upvalues : self
    ((self.ui).obj_pressureLvUp):SetActive(false)
    self:__TryPlayNext()
    if self.__afterStressUpCallback ~= nil then
      (self.__afterStressUpCallback)()
      self.__afterStressUpCallback = nil
    end
  end
)):SetAutoKill(false)):Pause()
  self.pressUpgradeQueue = pressUpgradeQueue
  local pressAddQueue = (cs_DoTween.Sequence)()
  ;
  (((((pressAddQueue:AppendCallback(function()
    -- function num : 0_1_4 , upvalues : self
    ((self.ui).obj_pressurePointUp):SetActive(true)
  end
)):Join((((self.ui).cg_pressAdd_tipsUILayer):DOFade(0, 0.1)):From())):AppendInterval(1.5)):AppendCallback(function()
    -- function num : 0_1_5 , upvalues : self
    ((self.ui).obj_pressurePointUp):SetActive(false)
    self:__TryPlayNext()
    if self.__afterStressUpCallback ~= nil then
      (self.__afterStressUpCallback)()
      self.__afterStressUpCallback = nil
    end
  end
)):SetAutoKill(false)):Pause()
  self.pressAddQueue = pressAddQueue
  local turnStartQueue = (cs_DoTween.Sequence)()
  ;
  (((((turnStartQueue:AppendCallback(function()
    -- function num : 0_1_6 , upvalues : _ENV, self, wcCtrl
    MsgCenter:Broadcast(eMsgEventId.WC_TurnStarTweenOver)
    ;
    ((self.ui).obj_turnStart):SetActive(true)
    local turnNum = (wcCtrl.turnCtrl):GetWCTurnNum()
    ;
    ((self.ui).tex_Title):SetIndex(0, tostring(turnNum))
  end
)):Join((((self.ui).cg_turnStart_tipsUILayer):DOFade(0, 0.1)):From())):AppendInterval(1.5)):AppendCallback(function()
    -- function num : 0_1_7 , upvalues : self
    ((self.ui).obj_turnStart):SetActive(false)
    self:__TryPlayNext()
  end
)):SetAutoKill(false)):Pause()
  self.turnStartQueue = turnStartQueue
  local returnPoinQueue = (cs_DoTween.Sequence)()
  ;
  ((((returnPoinQueue:AppendCallback(function()
    -- function num : 0_1_8 , upvalues : self
    ((self.ui).Obj_ReturnPoint):SetActive(true)
    ;
    ((self.ui).tween_ReturnPoint):DOPlayForward()
  end
)):AppendInterval(2.5)):AppendCallback(function()
    -- function num : 0_1_9 , upvalues : self
    ((self.ui).Obj_ReturnPoint):SetActive(false)
    self:__TryPlayNext()
  end
)):SetAutoKill(false)):Pause()
  self.returnPoinQueue = returnPoinQueue
  local getItemQueue = (cs_DoTween.Sequence)()
  ;
  ((((getItemQueue:AppendCallback(function()
    -- function num : 0_1_10 , upvalues : self
    ((self.ui).obj_getPoint):SetActive(true)
  end
)):AppendInterval(1.5)):AppendCallback(function()
    -- function num : 0_1_11 , upvalues : self
    ((self.ui).obj_getPoint):SetActive(false)
    self:__TryPlayNext()
  end
)):SetAutoKill(false)):Pause()
  self.getItemQueue = getItemQueue
  local showRewardQueue = (cs_DoTween.Sequence)()
  ;
  ((((((showRewardQueue:AppendCallback(function()
    -- function num : 0_1_12 , upvalues : self
    (self.showRewardNode):Show()
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (((self.showRewardNode).ui).canvasGroup).alpha = 1
  end
)):Append(((((self.showRewardNode).ui).canvasGroup):DOFade(0, 0.2)):From())):AppendInterval(1)):Append((((self.showRewardNode).ui).canvasGroup):DOFade(0, 0.2))):AppendCallback(function()
    -- function num : 0_1_13 , upvalues : self
    (self.showRewardNode):Hide()
    self:__TryPlayNext()
    if self.__afterShowGetRewardCallback ~= nil then
      (self.__afterShowGetRewardCallback)()
      self.__afterShowGetRewardCallback = nil
    end
  end
)):SetAutoKill(false)):Pause()
  self.showRewardQueue = showRewardQueue
end

UIWarChessNotice.OnWCTurnOver = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (table.insert)(self.__playQueue, function()
    -- function num : 0_2_0 , upvalues : self
    (self.turnOverQueue):Restart()
  end
)
  ;
  (table.insert)(self.__playQueue, function()
    -- function num : 0_2_1 , upvalues : self
    (self.turnStartQueue):Restart()
  end
)
  if not self.__isPlaying then
    self:__TryPlayNext()
  end
end

UIWarChessNotice.OnWCApIncrease = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (table.insert)(self.__playQueue, function()
    -- function num : 0_3_0 , upvalues : self
    (self.returnPoinQueue):Restart()
  end
)
  if not self.__isPlaying then
    self:__TryPlayNext()
  end
end

UIWarChessNotice.OnWCStart = function(self, callBack, stayTime)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_gameStart):SetActive(true)
  local wcLevelCfg = WarChessManager:GetWCLevelCfg()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_GameStartDes).text = (LanguageUtil.GetLocaleText)(wcLevelCfg.victory_long)
  local realCallBack = function()
    -- function num : 0_4_0 , upvalues : self, callBack
    ((self.ui).obj_gameStart):SetActive(false)
    self:Hide()
    if callBack ~= nil then
      callBack()
    end
  end

  if not stayTime then
    stayTime = 1.5
  end
  TimerManager:StopTimer(self.startTimer)
  self.startTimer = TimerManager:StartTimer(stayTime, realCallBack, self, true)
end

UIWarChessNotice.OnWCStressUpgrade = function(self, stressCfg, addNum, afterPlayCallback, aniTimeScale)
  -- function num : 0_5 , upvalues : _ENV
  if not aniTimeScale then
    aniTimeScale = 1
  end
  if stressCfg ~= nil then
    (table.insert)(self.__playQueue, 1, function()
    -- function num : 0_5_0 , upvalues : self, _ENV, stressCfg, aniTimeScale
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).tex_pressureTitle).text = (LanguageUtil.GetLocaleText)(stressCfg.name)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).tex_pressureLevelDes).text = (LanguageUtil.GetLocaleText)(stressCfg.describe)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.pressUpgradeQueue).timeScale = aniTimeScale
    ;
    (self.pressUpgradeQueue):Restart()
  end
)
  end
  if addNum ~= nil then
    (table.insert)(self.__playQueue, 1, function()
    -- function num : 0_5_1 , upvalues : self, afterPlayCallback, _ENV, addNum, aniTimeScale
    self.__afterStressUpCallback = afterPlayCallback
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).tex_pressurePoint).text = "+" .. tostring(addNum)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.pressAddQueue).timeScale = aniTimeScale
    ;
    (self.pressAddQueue):Restart()
  end
)
  end
  if not self.__isPlaying then
    self:__TryPlayNext()
  end
end

UIWarChessNotice.OnWCGetDeployPoint = function(self, itemId, itemNum)
  -- function num : 0_6 , upvalues : _ENV
  (table.insert)(self.__playQueue, 1, function()
    -- function num : 0_6_0 , upvalues : _ENV, itemId, self, itemNum
    local itemName = ConfigData:GetItemName(itemId)
    ;
    ((self.ui).tex_GetItemDse):SetIndex(0, itemName, tostring(itemNum))
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_ItemIcon).sprite = CRH:GetSpriteByItemId(itemId)
    ;
    (self.getItemQueue):Restart()
  end
)
  if not self.__isPlaying then
    self:__TryPlayNext()
  end
end

UIWarChessNotice.WCShowGetReward = function(self, itemId, itemNum, itemAddNum, isLimitFull, afterPlayCallback, aniTimeScale)
  -- function num : 0_7
  (self.showRewardNode):RefreshWCRewardNotice(itemId, itemNum, itemAddNum, isLimitFull)
  self.__afterShowGetRewardCallback = afterPlayCallback
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  if aniTimeScale then
    (self.showRewardQueue).timeScale = aniTimeScale
  else
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.showRewardQueue).timeScale = 1
  end
  ;
  (self.showRewardQueue):Restart()
end

UIWarChessNotice.__TryPlayNext = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if #self.__playQueue > 0 and not WarChessManager.isWCFinish then
    self.__isPlaying = true
    local func = (table.remove)(self.__playQueue, 1)
    func()
  else
    do
      self.__isPlaying = false
      self:Hide()
    end
  end
end

UIWarChessNotice.ForceHideWindow = function(self)
  -- function num : 0_9
  self.__isPlaying = false
  self:Hide()
end

UIWarChessNotice.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.turnOverQueue ~= nil then
    (self.turnOverQueue):Kill()
  end
  if self.pressUpgradeQueue ~= nil then
    (self.pressUpgradeQueue):Kill()
  end
  if self.turnStartQueue ~= nil then
    (self.turnStartQueue):Kill()
  end
  if self.returnPoinQueue ~= nil then
    (self.returnPoinQueue):Kill()
  end
  if self.showRewardQueue ~= nil then
    (self.showRewardQueue):Kill()
  end
  if self.getItemQueue ~= nil then
    (self.getItemQueue):Kill()
  end
  if self.pressAddQueue ~= nil then
    (self.pressAddQueue):Kill()
  end
  TimerManager:StopTimer(self.startTimer)
end

return UIWarChessNotice

