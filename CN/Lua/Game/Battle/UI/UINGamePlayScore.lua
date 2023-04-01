-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGamePlayScore = class("UINGamePlayScore", UIBaseNode)
local base = UIBaseNode
local CS_DOTween = ((CS.DG).Tweening).DOTween
local GamePlayScoreType = {Number = 1, Timer = 2, Collect = 3}
UINGamePlayScore.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, GamePlayScoreType
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._defTimeColor = ((self.ui).img_timerNode).color
  self.listScoreNode = {}
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listScoreNode)[GamePlayScoreType.Number] = (self.ui).damageNode
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listScoreNode)[GamePlayScoreType.Timer] = (self.ui).timerNode
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listScoreNode)[GamePlayScoreType.Collect] = (self.ui).collect
  self.listScoreFunc = {}
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listScoreFunc)[GamePlayScoreType.Number] = self.__BattleScoreNumber
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listScoreFunc)[GamePlayScoreType.Timer] = self.__BattleScoreTimer
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listScoreFunc)[GamePlayScoreType.Collect] = self.__BattleCollect
  self.listInitFunc = {}
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.listInitFunc)[GamePlayScoreType.Collect] = self.__InitShowCollect
  self.__ChangeBattleScoreActive = BindCallback(self, self.ChangeBattleScoreActive)
  self.__ChangeBattleScoreValue = BindCallback(self, self.ChangeBattleScoreValue)
  MsgCenter:AddListener(eMsgEventId.ChangeBattleScoreActive, self.__ChangeBattleScoreActive)
  MsgCenter:AddListener(eMsgEventId.ChangeBattleScoreValue, self.__ChangeBattleScoreValue)
  if BattleDungeonManager.dunInterfaceData ~= nil and (BattleDungeonManager.dunInterfaceData):GetIsListen2OverKill() then
    self.__onOverKillValueChange = BindCallback(self, self.__OnOverKillValueChange)
    MsgCenter:AddListener(eMsgEventId.OnOverKillValueChange, self.__onOverKillValueChange)
  end
  self:_InitSequcenceFactory()
end

UINGamePlayScore.SetGamePlayScoreResloader = function(self, resloader)
  -- function num : 0_1
  self.resloader = resloader
end

UINGamePlayScore.StartBattleRacingShow = function(self, battleCtrl, lastFrame)
  -- function num : 0_2 , upvalues : GamePlayScoreType, _ENV
  self:ChangeBattleScoreActive(GamePlayScoreType.Timer, true)
  self._racingTimer = TimerManager:StartTimer(1, (BindCallback(self, self.UpdateRacing, battleCtrl)), nil, false, false, false)
  self._lastRacingFrame = lastFrame
  if lastFrame >= 0 then
    ((self.ui).recordNode):SetActive(true)
    ;
    ((self.ui).text_RecordTime):SetIndex(0, (BattleUtil.FrameToTimeString)(lastFrame, true))
  end
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_timerNode).color = Color.black
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Timer).text = (BattleUtil.FrameToTimeString)(0)
end

UINGamePlayScore.UpdateRacing = function(self, battleCtrl)
  -- function num : 0_3 , upvalues : _ENV
  local frame = battleCtrl.frame
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Timer).text = (BattleUtil.FrameToTimeString)(frame)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  if self._lastRacingFrame >= 0 and self._lastRacingFrame < frame then
    ((self.ui).img_timerNode).color = self._defTimeColor
  end
end

UINGamePlayScore.ChangeBattleScoreActive = function(self, nodeId, active)
  -- function num : 0_4 , upvalues : _ENV
  local node = (self.listScoreNode)[nodeId]
  if node == nil then
    error("not game play score id:" .. tostring(nodeId))
    return 
  end
  if not active then
    active = false
  end
  node:SetActive(active)
  local initFunc = (self.listInitFunc)[nodeId]
  if initFunc ~= nil then
    initFunc(self)
  end
end

UINGamePlayScore.ChangeBattleScoreValue = function(self, nodeId, value)
  -- function num : 0_5 , upvalues : _ENV
  local func = (self.listScoreFunc)[nodeId]
  if func == nil then
    error("not game play score id:" .. tostring(nodeId))
    return 
  end
  if not value then
    value = 0
  end
  func(self, value)
end

UINGamePlayScore.__BattleScoreNumber = function(self, value)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Damage).text = tostring(value)
end

UINGamePlayScore.__BattleScoreTimer = function(self, value)
  -- function num : 0_7 , upvalues : _ENV
  local min = (math.floor)(value / 60)
  local sec = (math.floor)(value % 60)
  local text = (string.format)("%d:%d", min, sec)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Timer).text = tostring(value)
end

UINGamePlayScore.__BattleCollect = function(self, value)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_CollectNum).text = tostring(FormatNum(value / 10)) .. "%"
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_CollectBar).fillAmount = value / 1000
end

UINGamePlayScore.__InitShowCollect = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local bdCtrl = BattleDungeonManager:GetDungeonCtrl()
  if bdCtrl == nil then
    return 
  end
  local dungeonStageCfg = (ConfigData.battle_dungeon)[bdCtrl.dungeonId]
  local play_para, wave_battlesCfg, curWaveCfg = nil, nil, nil
  if dungeonStageCfg ~= nil then
    play_para = dungeonStageCfg.play_para
  end
  if play_para ~= nil then
    wave_battlesCfg = (ConfigData.wave_battles)[play_para]
  end
  if wave_battlesCfg ~= nil then
    curWaveCfg = wave_battlesCfg[((bdCtrl.sceneCtrl).sceneWave).cur]
  end
  if curWaveCfg == nil then
    return 
  end
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_CollectName).text = (LanguageUtil.GetLocaleText)(curWaveCfg.bar_text)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_CollectIcon).sprite = CRH:GetSprite(curWaveCfg.bar_icon)
end

UINGamePlayScore.__OnOverKillValueChange = function(self, value, isEnd)
  -- function num : 0_10 , upvalues : _ENV
  if not ((self.ui).overKill).activeSelf then
    ((self.ui).overKill):SetActive(true)
    local prefab = (self.resloader):LoadABAsset("FX/UI_effct/OverKill/FXP_UINChipItemDetail_up.prefab")
    self.__overKillEffect = prefab:Instantiate(((self.ui).overKill).transform)
  end
  do
    if self.__overKillColor == nil then
      self.__overKillColor = (Color.New)(0.7, 0.7, 0.7, 1)
    end
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Damage).text = tostring(value)
    ;
    ((self.ui).img_OverKillBottom):DOKill()
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_OverKillBottom).color = Color.white
    ;
    ((self.ui).img_OverKillBottom):DOColor(self.__overKillColor, 0.5)
  end
end

UINGamePlayScore._InitSequcenceFactory = function(self)
  -- function num : 0_11
  self.__tweenTransMidToUp = self:__ScoreMoveMidToUpTween()
  self.__tweenTransUpToMid = self:__ScoreMoveUpToMidTween()
end

UINGamePlayScore.__ScoreMoveMidToUpTween = function(self, seq)
  -- function num : 0_12 , upvalues : CS_DOTween, _ENV
  if not seq then
    seq = (CS_DOTween.Sequence)()
  end
  local rect_list = (self.ui).rect_list
  local localPos = rect_list.localPosition
  ;
  (((((seq:Append(rect_list:DOLocalMove((Vector2.New)(localPos.x, localPos.y - 20), 0))):Append(rect_list:DOLocalMove((Vector2.New)(localPos.x, localPos.y + 130), 0.5))):SetAutoKill(false)):SetUpdate(true)):Pause()):SetLink(rect_list.gameObject)
  return seq
end

UINGamePlayScore.__ScoreMoveUpToMidTween = function(self, seq)
  -- function num : 0_13 , upvalues : CS_DOTween, _ENV
  if not seq then
    seq = (CS_DOTween.Sequence)()
  end
  local rect_list = (self.ui).rect_list
  local localPos = rect_list.localPosition
  ;
  (((((seq:Append(rect_list:DOLocalMove((Vector2.New)(localPos.x, localPos.y + 130), 0))):Append(rect_list:DOLocalMove((Vector2.New)(localPos.x, localPos.y - 20), 0.5))):SetAutoKill(false)):SetUpdate(true)):Pause()):SetLink(rect_list.gameObject)
  return seq
end

UINGamePlayScore.PlaySeqMidToUp = function(self)
  -- function num : 0_14
  if self.__tweenTransMidToUp then
    (self.__tweenTransMidToUp):Restart()
  end
end

UINGamePlayScore.PlaySeqUpToMid = function(self)
  -- function num : 0_15
  if self.__tweenTransUpToMid then
    (self.__tweenTransUpToMid):Restart()
  end
end

UINGamePlayScore.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.ChangeBattleScoreActive, self.__ChangeBattleScoreActive)
  MsgCenter:RemoveListener(eMsgEventId.ChangeBattleScoreValue, self.__ChangeBattleScoreValue)
  if self.__onOverKillValueChange ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.OnOverKillValueChange, self.__onOverKillValueChange)
  end
  ;
  ((self.ui).img_OverKillBottom):DOKill()
  TimerManager:StopTimer(self._racingTimer)
  ;
  (self.__tweenTransMidToUp):Kill()
  ;
  (self.__tweenTransUpToMid):Kill()
  ;
  (base.OnDelete)(self)
end

return UINGamePlayScore

