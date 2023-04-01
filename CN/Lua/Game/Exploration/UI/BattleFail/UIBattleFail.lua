-- params : ...
-- function num : 0 , upvalues : _ENV
local UIBattleFail = class("UIBattleFail", UIBaseWindow)
local base = UIBaseWindow
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
local cs_MessageCommon = CS.MessageCommon
UIBattleFail.OnShow = function(self)
  -- function num : 0_0 , upvalues : base, cs_DoTween, cs_Ease
  (base.OnShow)(self)
  if self.__isIgnoreDelay then
    self.__isIgnoreDelay = false
    return 
  end
  if (self.ui).canvasGroup == nil then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).interactable = false
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = 0
  local winTween = (cs_DoTween.Sequence)()
  winTween:Append(((self.ui).canvasGroup):DOFade(1, 0.1))
  winTween:AppendCallback(function()
    -- function num : 0_0_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).canvasGroup).interactable = true
  end
)
  winTween:SetEase(cs_Ease.Linear)
  winTween:SetDelay(2)
  winTween:SetLink(self.gameObject)
end

UIBattleFail.SetIgnoreDelayFlagOnce = function(self, isIgnoreDelay)
  -- function num : 0_1
  self.__isIgnoreDelay = isIgnoreDelay
end

UIBattleFail.OnInit = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_GiveUp, self, self.__OnClickGiveUp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reload, self, self.__OnClickRestart)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Formation, self, self.__OnClickFormation)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Statistic, self, self.__ShowBattleStatistic)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Continue, self, self.__OnClickContinue)
  local isUnlockBattleExit = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BattleFailExit)
  self._isUnlockBattleExit = isUnlockBattleExit
  if not isUnlockBattleExit then
    (((self.ui).btn_GiveUp).gameObject):SetActive(false)
  end
  ;
  ((self.ui).tex_Fail):SetIndex(0)
end

UIBattleFail.InitBattleFail = function(self, giveUpBattleFunc, restartFunc, statisticFunc)
  -- function num : 0_3 , upvalues : _ENV
  self.giveUpBattleFunc = giveUpBattleFunc
  self.restartFunc = restartFunc
  self.statisticFunc = statisticFunc
  local showLvInfo = false
  local inDailyDungeon = (BattleUtil.IsBattleEnableFormation)()
  if inDailyDungeon then
    (((self.ui).btn_Formation).gameObject):SetActive(true)
    ;
    ((self.ui).tex_Fail):SetIndex(1)
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R6 in 'UnsetPending'

    if BattleDungeonManager.dungeonCtrl ~= nil then
      ((self.ui).tex_LevelCount).text = (LanguageUtil.GetLocaleText)(((BattleDungeonManager.dungeonCtrl).dungeonCfg).name)
    end
    showLvInfo = true
  end
  local isInExploration = ExplorationManager:IsInExploration()
  self.__hasRestartLimit = not isInExploration or ExplorationManager:GetEpModuleId() ~= proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge
  ;
  (((self.ui).tex_RestartCount).gameObject):SetActive(self.__hasRestartLimit)
  if isInExploration then
    showLvInfo = true
  end
  ;
  ((self.ui).obj_levelInfo):SetActive(showLvInfo)
  local sectorStageCfg = ExplorationManager:GetSectorStageCfg()
  do
    if sectorStageCfg ~= nil then
      local roomData = ((ExplorationManager.epCtrl).playerCtrl):GetCurrentRoomData()
      if roomData ~= nil then
        local roomType = roomData.type
        local roomTypeCfg = (ConfigData.exploration_roomtype)[roomType]
        -- DECOMPILER ERROR at PC86: Confused about usage of register: R11 in 'UnsetPending'

        ;
        ((self.ui).tex_LevelCount).text = (LanguageUtil.GetLocaleText)(roomTypeCfg.title)
        if (ExplorationManager.epCtrl):IsCompleteExploration() then
          ((self.ui).tex_Fail):SetIndex(0)
        else
          ((self.ui).tex_Fail):SetIndex(1)
        end
      else
        (((self.ui).tex_LevelCount).gameObject):SetActive(false)
      end
      if self.__hasRestartLimit then
        self.__battleCountLimit = ((ExplorationManager.epCtrl).battleCtrl):GetEpBattleLastCount()
        ;
        ((self.ui).tex_RestartCount):SetIndex(0, tostring(self.__battleCountLimit))
        -- DECOMPILER ERROR at PC133: Confused about usage of register: R9 in 'UnsetPending'

        if self.__battleCountLimit <= 0 then
          ((self.ui).cs_Restart).alpha = 0.4
        else
          -- DECOMPILER ERROR at PC137: Confused about usage of register: R9 in 'UnsetPending'

          ((self.ui).cs_Restart).alpha = 1
        end
      end
    end
    -- DECOMPILER ERROR: 8 unprocessed JMP targets
  end
end

UIBattleFail.InitWCBattleFail = function(self, battleName, giveUpBattleFunc, continueFunc, restartFunc, statisticFunc)
  -- function num : 0_4
  self.giveUpBattleFunc = giveUpBattleFunc
  self.continueFunc = continueFunc
  self.restartFunc = restartFunc
  self.statisticFunc = statisticFunc
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelCount).text = battleName
  ;
  (((self.ui).tex_RetreatTips).gameObject):SetActive(true)
  ;
  (((self.ui).btn_Continue).gameObject):SetActive(true)
  ;
  (((self.ui).tex_RestartCount).gameObject):SetActive(false)
  ;
  ((self.ui).tex_Fail):SetIndex(1)
end

UIBattleFail.SetBattleGiveupAcitve = function(self, active)
  -- function num : 0_5
  if active then
    (((self.ui).btn_GiveUp).gameObject):SetActive(self._isUnlockBattleExit)
  end
end

UIBattleFail.SetBattleFailEnterFmtFunc = function(self, enterFmtFunc)
  -- function num : 0_6
  self.enterFmtFunc = enterFmtFunc
end

UIBattleFail.__OnClickGiveUp = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.giveUpBattleFunc ~= nil then
    (self.giveUpBattleFunc)()
  end
  AudioManager:PlayAudioById(1082)
  self:Delete()
end

UIBattleFail.__OnClickRestart = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.__hasRestartLimit and self.__battleCountLimit <= 0 then
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(171))
    return 
  end
  AudioManager:PlayAudioById(1084)
  if self.restartFunc ~= nil then
    (self.restartFunc)()
    self:Hide()
  end
  UIManager:DeleteWindow(UIWindowTypeID.BattleCrazyMode)
  UIManager:DeleteWindow(UIWindowTypeID.RichIntro)
end

UIBattleFail.__OnClickFormation = function(self)
  -- function num : 0_9 , upvalues : _ENV, cs_MessageCommon
  local applyFunc = function()
    -- function num : 0_9_0 , upvalues : self, _ENV
    if self.enterFmtFunc ~= nil then
      (self.enterFmtFunc)()
    end
    self:Hide()
    UIManager:DeleteWindow(UIWindowTypeID.BattleCrazyMode)
    UIManager:DeleteWindow(UIWindowTypeID.RichIntro)
  end

  local inDailyDungeon = (BattleUtil.IsInDailyDungeon)()
  do
    if inDailyDungeon and FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_DailyDungeonQuick) then
      local battleDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
      if not PlayerDataCenter:IsDungeonModuleOpenQuick(battleDyncElem.moduleId) and not battleDyncElem:IsFailInDgBattle() then
        (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(9308), function()
    -- function num : 0_9_1 , upvalues : applyFunc
    applyFunc()
  end
, nil)
        return 
      end
    end
    applyFunc()
  end
end

UIBattleFail.__ShowBattleStatistic = function(self)
  -- function num : 0_10
  if self.statisticFunc ~= nil then
    (self.statisticFunc)()
  end
end

UIBattleFail.__OnClickContinue = function(self)
  -- function num : 0_11
  if self.continueFunc ~= nil then
    (self.continueFunc)()
  end
end

UIBattleFail.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnDelete)(self)
  self.__isIgnoreDelay = false
end

return UIBattleFail

