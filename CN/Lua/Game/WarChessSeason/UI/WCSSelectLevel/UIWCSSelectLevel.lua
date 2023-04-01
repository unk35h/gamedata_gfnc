-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWCSSelectLevel = class("UIWCSSelectLevel", UIBaseWindow)
local cs_ResLoader = CS.ResLoader
local cs_DoTween = ((CS.DG).Tweening).DOTween
local UINWCSSelectLevelLevelItem = require("Game.WarChessSeason.UI.WCSSelectLevel.UINWCSSelectLevelLevelItem")
local UINWCSSelectLevelDownNode = require("Game.WarChessSeason.UI.WCSSelectLevel.UINWCSSelectLevelDownNode")
UIWCSSelectLevel.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINWCSSelectLevelLevelItem, UINWCSSelectLevelDownNode
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Hide, self, self.__OnClickHide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self.__OnSkip)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ResNode, self, self.OnClickTokenTip)
  self.itemPool = (UIItemPool.New)(UINWCSSelectLevelLevelItem, (self.ui).obj_levelItem)
  ;
  ((self.ui).obj_levelItem):SetActive(false)
  self.downNode = (UINWCSSelectLevelDownNode.New)()
  ;
  (self.downNode):Init((self.ui).obj_down)
  self.__onClickLevelItem = BindCallback(self, self.__OnClickLevelItem)
  self.__doCompleted = false
  if self.__delayEnableClickTimer then
    TimerManager:StopTimer(self.__delayEnableClickTimer)
    self.__delayEnableClickTimer = nil
  end
  self.__delayEnableClickTimer = nil
  self.__seqAniSelectLevel = nil
  self.__seqAniCompleteCurLevel = nil
  self:_InitTweenSequence()
  self.__RefreshScoreAndTokenCallback = BindCallback(self, self.__RefreshScoreAndToken)
  MsgCenter:AddListener(eMsgEventId.WCS_ExtraneouslyRefresh, self.__RefreshScoreAndTokenCallback)
end

UIWCSSelectLevel.InitWCSLevelInfo = function(self, levelList)
  -- function num : 0_1 , upvalues : _ENV
  (self.downNode):RefreshWCSLLevelBar()
  local couldClose = WarChessSeasonManager:GetIsInWCSeasonIsInLobby()
  ;
  (((self.ui).btn_Hide).gameObject):SetActive(couldClose)
  self:__RefreshScoreAndToken()
  self:InitWCSSelectLevel(levelList)
end

UIWCSSelectLevel.InitWCSSelectLevel = function(self, levelList)
  -- function num : 0_2 , upvalues : _ENV
  if levelList == nil then
    return 
  end
  ;
  (self.itemPool):HideAll()
  for _,levelData in ipairs(levelList) do
    local RoomId = levelData.RoomId
    local BuffId = levelData.BuffId
    local serverRewardDic = levelData.itemsNums
    local levelItem = (self.itemPool):GetOne()
    levelItem:InitWCSLevelItem(RoomId, BuffId, self.__onClickLevelItem, self.resloader, serverRewardDic)
  end
end

UIWCSSelectLevel.WCSPlayAniCompleteCurLevel = function(self, completeAction, timeScale)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).tex_Des):SetIndex(0)
  ;
  ((self.ui).obj_main):SetActive(false)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_top).transform).localPosition = (Vector2.New)(0, 133)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.downNode).transform).localPosition = (Vector2.New)(-5.5, -125)
  ;
  ((self.ui).tex_Des):SetIndex(0)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).canvas_resNode).alpha = 0
  ;
  (((self.ui).tex_Score).gameObject):SetActive(false)
  local seq = ((self._tweenSequenceGroup).IconComplete)()
  seq:OnComplete(function()
    -- function num : 0_3_0 , upvalues : completeAction
    if completeAction ~= nil then
      completeAction()
    end
  end
)
  seq:SetLink(self.gameObject)
  if not timeScale then
    timeScale = 1
  end
  seq.timeScale = timeScale
  self.__AniCompleteCurLevel = seq
end

UIWCSSelectLevel.WCSPlayAniSelectLevel = function(self, isNext, completeAction, timeScale)
  -- function num : 0_4 , upvalues : _ENV
  if not timeScale then
    timeScale = 1
  end
  ;
  ((self.ui).tex_Des):SetIndex(1)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).canvas_resNode).alpha = 1
  if not isNext then
    for index,levelItem in ipairs((self.itemPool).listItem) do
      levelItem:WCSSLIPlayFadeTween(index)
    end
    local seq = nil
    seq = ((self._tweenSequenceGroup).ForwardLine)(seq)
    seq:AppendCallback(function()
    -- function num : 0_4_0 , upvalues : self
    (self.downNode):ShowNextTip()
  end
)
    seq:SetLink(self.gameObject)
    seq.timeScale = timeScale
    self.__seqAniSelectLevel = seq
    return 
  end
  do
    local seq = nil
    seq = ((self._tweenSequenceGroup).PopCompleteLevels)(seq)
    seq = ((self._tweenSequenceGroup).ForwardLine)(seq)
    ;
    ((self._tweenSequenceGroup).GotoNextLevel)(seq)
    seq:SetLink(self.gameObject)
    seq.timeScale = timeScale
    self.__seqAniSelectLevel = seq
  end
end

UIWCSSelectLevel.__RefreshScoreAndToken = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local wcsCtrl = WarChessSeasonManager:GetWCSCtrl()
  local totalScore = wcsCtrl:WCSGetTotalScore()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(totalScore)
  ;
  ((self.ui).tex_ScoreName):SetIndex(1)
  local addData = WarChessSeasonManager:GetSeasonAddtionData()
  if addData == nil then
    return 
  end
  local tokenId = addData:GetSeasonScoreToken()
  if tokenId == nil then
    return 
  end
  local tokenNum, tokenCapacity = addData:GetSeasonScore()
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenNum).text = tostring(tokenNum) .. "/" .. tostring(tokenCapacity)
  ;
  ((self.ui).obj_Limit):SetActive(tokenCapacity <= tokenNum)
  local itemCfg = (ConfigData.item)[tokenId]
  if itemCfg == nil then
    error("token item not exist:" .. tostring(tokenId))
    return 
  end
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenIcon).sprite = CRH:GetSprite(itemCfg.icon)
  ;
  ((self.ui).tex_TokenName):SetIndex(0, (LanguageUtil.GetLocaleText)(itemCfg.name))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWCSSelectLevel.__OnClickLevelItem = function(self, item)
  -- function num : 0_6 , upvalues : _ENV
  local wcLevelId = item:GetRougeDoorId()
  local envBuffData = item:GetWCSRougeBuffData()
  local levelPressAddNum = item:GetWCSPressAddNum()
  WarChessSeasonManager:WarChessSeasonEnterDoor(wcLevelId, envBuffData, levelPressAddNum)
end

UIWCSSelectLevel.OnClickTokenTip = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local addtion = WarChessSeasonManager:GetSeasonAddtionData()
  if addtion == nil then
    return 
  end
  local callback = addtion:GetSelectLevelTokenCallback()
  if callback ~= nil then
    callback()
  end
end

UIWCSSelectLevel._InitTweenSequence = function(self)
  -- function num : 0_8 , upvalues : cs_DoTween, _ENV
  self._tweenSequenceGroup = {ForwardLine = function(seq)
    -- function num : 0_8_0 , upvalues : self
    return (self.downNode):StartWCSSDownBarLineTween(seq)
  end
, IconComplete = function(seq)
    -- function num : 0_8_1 , upvalues : self
    return (self.downNode):StartWCSSLDownBarCurZoomTween(seq)
  end
, GotoNextLevel = function(seq)
    -- function num : 0_8_2 , upvalues : cs_DoTween, self, _ENV
    if seq == nil then
      seq = (cs_DoTween.Sequence)()
    end
    ;
    ((((seq:AppendInterval(0.5)):AppendCallback(function()
      -- function num : 0_8_2_0 , upvalues : self, _ENV, seq
      ((self.ui).obj_main):SetActive(true)
      ;
      ((self.ui).tex_Des):SetIndex(1)
      ;
      (self.downNode):ShowNextTip()
      ;
      (((self.ui).tex_Score).gameObject):SetActive(true)
      for index,levelItem in ipairs((self.itemPool).listItem) do
        levelItem:WCSSLIPlayFadeTween(index)
        if self.__doCompleted then
          levelItem:SetClickEnable(false)
        end
      end
      if self.__doCompleted then
        if self.__delayEnableClickTimer then
          TimerManager:StopTimer(self.__delayEnableClickTimer)
          self.__delayEnableClickTimer = nil
        end
        self.__delayEnableClickTimer = TimerManager:StartTimer(0.5 * (1 / seq.timeScale), function()
        -- function num : 0_8_2_0_0 , upvalues : _ENV, self
        for _,levelItem in ipairs((self.itemPool).listItem) do
          levelItem:SetClickEnable(true)
        end
        TimerManager:StopTimer(self.__delayEnableClickTimer)
        self.__delayEnableClickTimer = nil
      end
, self, true)
      end
    end
)):Append((((self.ui).obj_top).transform):DOLocalMove((Vector2.New)(0, 450), 0.5))):Join(((self.downNode).transform):DOLocalMove((Vector2.New)(-5.5, -507), 0.5))):Join(((self.ui).canvas_resNode):DOFade(1, 0.5))
    return seq
  end
, PopCompleteLevels = function(seq)
    -- function num : 0_8_3 , upvalues : self
    return (self.downNode):StartWCSSLDownNodePlayPopHideLevelTween(seq)
  end
}
end

UIWCSSelectLevel.__OnClickHide = function(self)
  -- function num : 0_9
  self:Delete()
end

UIWCSSelectLevel.__OnSkip = function(self)
  -- function num : 0_10
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  if self.__seqAniSelectLevel then
    (self.__seqAniSelectLevel).timeScale = 10000
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  if self.__seqAniCompleteCurLevel then
    (self.__seqAniCompleteCurLevel).timeScale = 10000
  end
  self.__doCompleted = true
end

UIWCSSelectLevel.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WCS_ExtraneouslyRefresh, self.__RefreshScoreAndTokenCallback)
  if self.__delayEnableClickTimer then
    TimerManager:StopTimer(self.__delayEnableClickTimer)
    self.__delayEnableClickTimer = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (((self.ui).obj_top).transform):DOKill()
  ;
  ((self.downNode).transform):DOKill()
  ;
  (self.itemPool):DeleteAll()
  self.__seqAniSelectLevel = nil
  self.__seqAniCompleteCurLevel = nil
  ;
  (base.OnDelete)(self)
end

return UIWCSSelectLevel

