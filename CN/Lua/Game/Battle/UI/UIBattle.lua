-- params : ...
-- function num : 0 , upvalues : _ENV
local UIBattle = class("UIBattle", UIBaseWindow)
local base = UIBaseWindow
local cs_MessageCommon = CS.MessageCommon
local cs_InputUtility = CS.InputUtility
local UINGamePlayScore = require("Game.Battle.UI.UINGamePlayScore")
local FmtEnum = require("Game.Formation.FmtEnum")
local UINBtnCommanderSkill = require("Game.Formation.UI.2DFormation.UINBtnCommanderSkill")
local util = require("XLua.Common.xlua_util")
local UINBattleDeployChipEft = require("Game.Battle.UI.UINBattleDeployChipEft")
local BattleUtil = require("Game.Battle.BattleUtil")
local FormationUtil = require("Game.Formation.FormationUtil")
local UINAutoModuleSwitch = require("Game.Exploration.UI.AutoMode.UINAutoModuleSwitch")
local EpCommonUtil = require("Game.Exploration.Util.EpCommonUtil")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
UIBattle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINGamePlayScore, BattleUtil, ExplorationEnum, EpCommonUtil, UINAutoModuleSwitch, UINBtnCommanderSkill, UINBattleDeployChipEft
  self.resLoader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Pause, self, self.__OnClickPauseTd)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SpeedUP, self, self.__OnClickSpeedUP)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BattleStart, self, self.__OnClickBattleStart)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.__OnClickBreakDeploy)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Auto, self, self.__OnAutoBattleClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Retreat, self, self.__OnClickRetreat)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Formation, self, self.__OnClickEnterFmt)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PauseNormal, self, self._OnClickPauseNormal)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Setting, self, self._OnClickSetting)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HideUI, self, self.__OnClickHideUIState)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowUI, self, self.__OnClickShowUIState)
  self:__TranslateUIPos()
  self.__callWaveComingAction = BindCallback(self, self.__CallWaveComing)
  MsgCenter:AddListener(eMsgEventId.WaveComing, self.__callWaveComingAction)
  self.__OnChipChangeEvent = BindCallback(self, self.__OnChipChange)
  MsgCenter:AddListener(eMsgEventId.OnEpChipListChange, self.__OnChipChangeEvent)
  self.isSpeedUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_PlaySpeed)
  self.isAutoBattleUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_AutoBattle)
  self.gameplayScore = (UINGamePlayScore.New)()
  ;
  (self.gameplayScore):Init((self.ui).gamePlayScore)
  ;
  (self.gameplayScore):SetGamePlayScoreResloader(self.resLoader)
  self.__haveOverclock = false
  self.__supportAutoEp = false
  self.__supoortRepickChip = false
  local isInTDBattle = (BattleUtil.IsInTDBattle)()
  if ExplorationManager:IsInExploration() then
    if ((ExplorationManager.epCtrl).overclockCtrl):IsLevelHasOverclock() and not isInTDBattle then
      (((self.ui).btn_Overclock).gameObject):SetActive(true)
      self.__haveOverclock = true
      ;
      (UIUtil.AddButtonListener)((self.ui).btn_Overclock, self, self.OnBtnOverclockClicked)
    end
    if ExplorationManager:IsSectorNewbee() then
      self.isAutoBattleUnlock = false
    end
    if (ExplorationManager.epCtrl):GetSupportAutoEpType() == (ExplorationEnum.eAutoEpSwitchType).Battle and (EpCommonUtil.IsSupportEpAutoMode)() then
      self.__supportAutoEp = true
      ;
      ((self.ui).autoModuleNode):SetActive(true)
      self.__autoSwitchNode = (UINAutoModuleSwitch.New)()
      ;
      (self.__autoSwitchNode):Init((self.ui).autoModuleNode)
      local autoCtrl = (ExplorationManager.epCtrl).autoCtrl
      if autoCtrl:IsDefaultAutoEp() or autoCtrl:IsAutoModeRunning() then
        (self.__autoSwitchNode):RefreshAutoModeState(true, true)
      end
    else
      do
        ;
        ((self.ui).autoModuleNode):SetActive(false)
        if BattleDungeonManager:InBattleDungeon() and (BattleDungeonManager.dungeonCtrl):DungeonAbleSelectChip() then
          self.__supoortRepickChip = true
          ;
          (((self.ui).btn_Repick).gameObject):SetActive(true)
          ;
          (UIUtil.AddButtonListener)((self.ui).btn_Repick, self, self.OnBtnRepickChip)
        end
        if isInTDBattle then
          self.isAutoBattleUnlock = false
        end
        self:ShowCurLvInfoUI()
        self.btnCstItem = (UINBtnCommanderSkill.New)()
        ;
        (self.btnCstItem):Init((self.ui).btn_CommanderSkill)
        self.__OnClickCstItem = BindCallback(self, self.OnClickCstItem)
        ;
        (self.btnCstItem):InitBtnCommanderSkill(self.resLoader, self.__OnClickCstItem)
        self.__OnSendCstChange = BindCallback(self, self.OnSendCstChange)
        self._SaveCftChangeFunc = BindCallback(self, self._SaveCftChange)
        self.deployChipEftPool = (UIItemPool.New)(UINBattleDeployChipEft, (self.ui).obj_ChipEft)
        ;
        ((self.ui).obj_ChipEft):SetActive(false)
        self.isShowingHeroInfo = false
        local isEnemyDetailUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_EnemyDetail)
        self:OnEnemyDetailUnlock(isEnemyDetailUnlock)
        self.battleController = ((CS.BattleManager).Instance).CurBattleController
      end
    end
  end
end

UIBattle.__TranslateUIPos = function(self)
  -- function num : 0_1 , upvalues : BattleUtil
  if not (BattleUtil.IsInTDBattle)() then
    return 
  end
  ;
  ((self.ui).btn_BattleStartTrans):SetAnchoredPosition(((self.ui).tdOffset).x, (((self.ui).btn_BattleStartTrans).anchoredPosition).y)
end

UIBattle.InitUIBattle = function(self, breakBattleFunc)
  -- function num : 0_2 , upvalues : _ENV
  self.breakBattleFunc = breakBattleFunc
  local isUnlockBattleExit = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BattleExit)
  if not isUnlockBattleExit then
    (((self.ui).btn_Retreat).gameObject):SetActive(false)
  end
  self.cs_battleCtrl = ((CS.BattleManager).Instance).CurBattleController
end

UIBattle.InitUIBattleDeploy = function(self, onlyDeploy, startBattleFunc, savaDeployFunc, getDeployAliveRoleCount, heroList)
  -- function num : 0_3 , upvalues : _ENV
  self.startBattleFunc = startBattleFunc
  self.savaDeployFunc = savaDeployFunc
  self.getDeployAliveRoleCount = getDeployAliveRoleCount
  self.deployCsHeroList = heroList
  ;
  (((self.ui).btn_Back).gameObject):SetActive(onlyDeploy)
  self:__SwitchUIState(false)
  if onlyDeploy then
    (((self.ui).btn_BattleStart).gameObject):SetActive(false)
  end
  ;
  (((self.ui).btn_SpeedUP).gameObject):SetActive(self.isSpeedUnlock)
  local speedIndex = 1
  if PlayerDataCenter.playerId > 0 then
    self._userDataCfg = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    if self._userDataCfg ~= nil then
      speedIndex = (self._userDataCfg):GetBattleSpeed()
    end
  end
  self.curSpeedIndex = speedIndex
  ;
  ((self.ui).img_Speed):SetIndex(self.curSpeedIndex - 1)
  ;
  ((self.ui).tex_Speed):SetIndex(self.curSpeedIndex - 1)
  ;
  (((self.ui).tog_Auto).gameObject):SetActive(self.isAutoBattleUnlock)
  local autoBattle = self._userDataCfg and (self._userDataCfg):GetIsAutoBattle() or false
  if not autoBattle then
    if BattleDungeonManager:InBattleDungeon() then
      autoBattle = (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode()
    end
    if autoBattle then
      self._isTempAuto = true
    end
  end
  -- DECOMPILER ERROR at PC96: Confused about usage of register: R8 in 'UnsetPending'

  if self.isAutoBattleUnlock and autoBattle then
    ((self.ui).tog_Auto).isOn = true
  else
    -- DECOMPILER ERROR at PC100: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).tog_Auto).isOn = false
  end
  self._isTempAuto = nil
  self:TryShowCstChange()
  self:TryRefreshAutoInfo()
  TimerManager:StopTimer(self._StartChipEftTimer)
  self._StartChipEftTimer = TimerManager:StartTimer(1, self.StartChipEft, self, true, true)
  ;
  (((self.ui).btn_HideUI).gameObject):SetActive(false)
  ;
  (((self.ui).btn_ShowUI).gameObject):SetActive(false)
  ;
  ((self.ui).frame):SetActive(true)
end

UIBattle.InitUIBattleRunning = function(self, pauseFunc, speedUpFunc, autoBattleFunc, autoBattleUltFunc, autoBattleUltMaxEnergyFunc, battleUIStateFunc)
  -- function num : 0_4
  self.pauseFunc = pauseFunc
  self.speedUpFunc = speedUpFunc
  self.autoBattleFunc = autoBattleFunc
  self.autoUltFunc = autoBattleUltFunc
  self.autoUltMaxEnergy = autoBattleUltMaxEnergyFunc
  self.battleUIStateFunc = battleUIStateFunc
  self:OnSpeedUpChange(((self.ui).speedArray)[self.curSpeedIndex])
  self:OnAutoBattleChange(((self.ui).tog_Auto).isOn)
  self:__SwitchUIState(true)
  self:CloseCstChange()
  self:EndChipEft()
  self.deployCsHeroList = nil
  ;
  (((self.ui).btn_HideUI).gameObject):SetActive(true)
  ;
  (((self.ui).btn_ShowUI).gameObject):SetActive(false)
end

UIBattle.ChangeStartBattleBtnText = function(self, index)
  -- function num : 0_5
  ((self.ui).tex_BattleStart):SetIndex(index)
end

UIBattle.__SwitchUIState = function(self, isBattleStart)
  -- function num : 0_6 , upvalues : BattleUtil, _ENV
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  local inTdBattle = (BattleUtil.IsInTDBattle)()
  if isBattleStart then
    ((self.ui).obj_pauseGroup):SetActive(not inTdBattle)
    ;
    (((self.ui).btn_Pause).gameObject):SetActive(not isBattleStart or inTdBattle)
    ;
    (((self.ui).btn_BattleStart).gameObject):SetActive(not isBattleStart)
    if (BattleUtil.IsBattleEnableFormation)() then
      (((self.ui).btn_Formation).gameObject):SetActive(not isBattleStart)
    end
    do
      if (BattleUtil.BattleAbleSelectChipSuit)() then
        local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
        if stateInfoWin ~= nil then
          (stateInfoWin.chipList):ShowDungeonChipListSuitSelectBtn(not isBattleStart)
        end
      end
      if self.__haveOverclock then
        (((self.ui).btn_Overclock).gameObject):SetActive(not isBattleStart)
      end
      if self.__supoortRepickChip then
        (((self.ui).btn_Repick).gameObject):SetActive(not isBattleStart)
      end
      if self.__supportAutoEp then
        ((self.ui).autoModuleNode):SetActive(not isBattleStart)
      end
    end
  end
end

UIBattle.HidePauseButton = function(self)
  -- function num : 0_7
  (((self.ui).btn_Pause).gameObject):SetActive(false)
  ;
  ((self.ui).obj_pauseGroup):SetActive(false)
end

UIBattle.SetBattleStartActive = function(self, active)
  -- function num : 0_8
  (((self.ui).btn_BattleStart).gameObject):SetActive(active)
end

UIBattle.SetBattleCanvasRaycast = function(self, active)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).canvasGroup).blocksRaycasts = active
end

UIBattle.TryClickBattlePause = function(self)
  -- function num : 0_10
  if not self:_TryTdBattlePause() then
    return self:_TryNormalBattlePause()
  end
end

UIBattle.TrySmallBattlePause = function(self)
  -- function num : 0_11 , upvalues : BattleUtil, cs_InputUtility
  do
    if self:_TryTdBattlePause() then
      local isPause = (BattleUtil.IsBattleInPause)()
      return isPause
    end
    do
      if (((self.ui).btn_PauseNormal).gameObject).activeInHierarchy and (cs_InputUtility.UIClickable)((((self.ui).btn_PauseNormal).targetGraphic).rectTransform) then
        local isPause = (BattleUtil.IsBattleInPause)()
        if not isPause then
          self:_OnBattlePauseChange(true)
          return true
        end
      end
      return false
    end
  end
end

UIBattle.TryCancelBattlePause = function(self)
  -- function num : 0_12 , upvalues : BattleUtil, _ENV, cs_InputUtility
  local isPause = (BattleUtil.IsBattleInPause)()
  if not isPause then
    return false
  end
  local pauseWindow = UIManager:GetWindow(UIWindowTypeID.BattlePause)
  if pauseWindow ~= nil and pauseWindow.active then
    pauseWindow:Hide()
    self:_OnBattlePauseChange(false)
    return true
  end
  if (((self.ui).btn_PauseNormal).gameObject).activeInHierarchy and (cs_InputUtility.UIClickable)((((self.ui).btn_PauseNormal).targetGraphic).rectTransform) then
    self:_OnBattlePauseChange(false)
    return true
  end
  return false
end

UIBattle._TryNormalBattlePause = function(self)
  -- function num : 0_13 , upvalues : cs_InputUtility
  if (((self.ui).btn_PauseNormal).gameObject).activeInHierarchy and (cs_InputUtility.UIClickable)((((self.ui).btn_PauseNormal).targetGraphic).rectTransform) then
    self:_OnClickSetting()
    return true
  end
  return false
end

UIBattle._TryTdBattlePause = function(self)
  -- function num : 0_14 , upvalues : cs_InputUtility
  if (((self.ui).btn_Pause).gameObject).activeInHierarchy and (cs_InputUtility.UIClickable)((((self.ui).btn_Pause).targetGraphic).rectTransform) then
    self:__OnClickPauseTd()
    return true
  end
  return false
end

UIBattle.__OnClickPauseTd = function(self)
  -- function num : 0_15
  self:_OnBattlePauseChange(true)
end

UIBattle._OnClickPauseNormal = function(self)
  -- function num : 0_16 , upvalues : BattleUtil
  local isPause = (BattleUtil.IsBattleInPause)()
  self:_OnBattlePauseChange(not isPause)
end

UIBattle._OnBattlePauseChange = function(self, pause)
  -- function num : 0_17 , upvalues : _ENV, BattleUtil
  if self.pauseFunc ~= nil then
    (self.pauseFunc)(pause)
  end
  local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  ;
  (((self.ui).btn_HideUI).gameObject):SetActive(not pause)
  if pause then
    AudioManager:PlayAudioById(1081)
    local win = UIManager:GetWindow(UIWindowTypeID.BattleCrazyMode)
    if win ~= nil then
      win:OnBattlePause()
    end
    if (BattleUtil.IsInTDBattle)() then
      self:_ShowBattlePauseWin()
    else
      ;
      ((self.ui).obj_pauseNode):SetActive(true)
      if stateInfoWin then
        stateInfoWin:PlayPopChipList()
      end
    end
  else
    do
      if not (BattleUtil.IsInTDBattle)() then
        ((self.ui).obj_pauseNode):SetActive(false)
        if stateInfoWin then
          stateInfoWin:PlayPushChipList()
        end
      end
      do
        local win = UIManager:GetWindow(UIWindowTypeID.BattleCrazyMode)
        if win ~= nil then
          win:OnBattleContinue()
        end
        ;
        ((self.ui).img_PauseNormalIcon):SetIndex(pause and 1 or 0)
      end
    end
  end
end

UIBattle._ShowBattlePauseWin = function(self)
  -- function num : 0_18 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.BattlePause, function(win)
    -- function num : 0_18_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    win:InitBattlePause(function()
      -- function num : 0_18_0_0 , upvalues : _ENV
      AudioManager:PlayAudioById(1082)
      if WarChessManager:GetIsInWarChess() then
        WarChessManager:TryExitWCBattle()
        return 
      end
      BattleDungeonManager:RetreatDungeon()
    end
, function()
      -- function num : 0_18_0_1 , upvalues : _ENV
      BattleDungeonManager:RestartDungeon()
    end
, function()
      -- function num : 0_18_0_2 , upvalues : self
      self:_OnBattlePauseChange(false)
    end
)
  end
)
end

UIBattle._OnClickSetting = function(self)
  -- function num : 0_19 , upvalues : BattleUtil
  self:_ShowBattlePauseWin()
  local isPause = (BattleUtil.IsBattleInPause)()
  if not isPause then
    self:_OnBattlePauseChange(true)
  end
end

UIBattle.__OnClickSpeedUP = function(self)
  -- function num : 0_20
  if self.isSpeedUnlock then
    self.curSpeedIndex = self.curSpeedIndex % #(self.ui).speedArray + 1
    local speed = ((self.ui).speedArray)[self.curSpeedIndex]
    if self._userDataCfg ~= nil then
      (self._userDataCfg):SetBattleSpeed(self.curSpeedIndex)
    end
    ;
    ((self.ui).img_Speed):SetIndex(self.curSpeedIndex - 1)
    ;
    ((self.ui).tex_Speed):SetIndex(self.curSpeedIndex - 1)
    self:OnSpeedUpChange(speed)
  end
end

UIBattle.OnSpeedUpChange = function(self, curSpeed)
  -- function num : 0_21
  if self.speedUpFunc ~= nil then
    (self.speedUpFunc)(curSpeed)
  end
end

UIBattle.__OnAutoBattleClick = function(self, value)
  -- function num : 0_22
  if self._userDataCfg ~= nil and not self._isTempAuto then
    (self._userDataCfg):SetIsAutoBattle(value)
  end
  ;
  ((self.ui).img_Auto):SetIndex(value and 1 or 0)
  self:OnAutoBattleChange(value)
end

UIBattle.OnAutoBattleChange = function(self, value)
  -- function num : 0_23 , upvalues : _ENV
  if self.autoBattleFunc ~= nil then
    (self.autoBattleFunc)(value)
  end
  local isAutoBattleMode = false
  if BattleDungeonManager:InBattleDungeon() then
    isAutoBattleMode = (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode()
  end
  if isAutoBattleMode and self.autoUltFunc ~= nil then
    (self.autoUltFunc)(value)
    if self.autoUltMaxEnergy ~= nil then
      (self.autoUltMaxEnergy)(value)
    end
  end
end

UIBattle.OnBtnOverclockClicked = function(self)
  -- function num : 0_24 , upvalues : _ENV
  self:HideMonsterOrNeutralRoleInfo()
  ;
  ((ExplorationManager.epCtrl).overclockCtrl):ShowEpOverclockUI(true)
end

UIBattle.SetOverclockHighlight = function(self, active)
  -- function num : 0_25
  ((self.ui).fx_Overclock):SetActive(active)
end

UIBattle.OnBtnRepickChip = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if self._isTempAuto then
    return 
  end
  self:HideMonsterOrNeutralRoleInfo()
  if BattleDungeonManager:InBattleDungeon() and (BattleDungeonManager.dungeonCtrl):DungeonAbleSelectChip() then
    (BattleDungeonManager.dungeonCtrl):DungeonRestartSelectChip()
  end
end

UIBattle.__OnClickEnterFmt = function(self)
  -- function num : 0_27 , upvalues : _ENV, FormationUtil, BattleUtil
  if BattleDungeonManager.dunInterfaceData == nil then
    return 
  end
  self:EndChipEft()
  local fromModule = (BattleDungeonManager.dunInterfaceData):GetDgItfFmtFromModule()
  if fromModule == nil then
    error("fromModule == nil")
    return 
  end
  local moduleId = (FormationUtil.GetModuleIdByFmtFromModule)(fromModule)
  if moduleId == nil then
    return 
  end
  local enterFunc = function()
    -- function num : 0_27_0 , upvalues : _ENV, self
    UIManager:HideWindow(UIWindowTypeID.Battle)
    UIManager:HideWindow(UIWindowTypeID.BattleSkillModule)
    UIManager:HideWindow(UIWindowTypeID.DungeonStateInfo)
    UIManager:HideWindow(UIWindowTypeID.EpChipSuit)
    ;
    (UIManager.csUIManager):HideWindow(typeof(CS.UI_CharacterInfoWindow))
    ;
    ((self.cs_battleCtrl).fsm):ChangeState((CS.eBattleState).End)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_27_1 , upvalues : _ENV, moduleId, self, BattleUtil
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetLastBattleDeployFmtId(moduleId, fmtId)
    UIManager:ShowWindowOnly(UIWindowTypeID.Battle)
    UIManager:ShowWindowOnly(UIWindowTypeID.BattleSkillModule)
    UIManager:ShowWindowOnly(UIWindowTypeID.DungeonStateInfo)
    UIManager:ShowWindowOnly(UIWindowTypeID.EpChipSuit)
    ;
    (UIManager.csUIManager):ShowWindow(typeof(CS.UI_CharacterInfoWindow))
    ;
    (self.cs_battleCtrl):RestartBattle()
    local curBattleSceneCtrl = (BattleUtil.GetCurSceneCtrl)()
    curBattleSceneCtrl:DeleteChangeEpHeroOldModel()
  end

  local fmtCtrl = (ControllerManager:GetController(ControllerTypeId.Formation, true))
  local stageId, startBattleFunc = nil, nil
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastBattleDeployFmtId(moduleId)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo(fromModule, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetFmtCtrlIsInBattleFmt(true)
  fmtCtrl:EnterFormation()
end

UIBattle.__OnClickBattleStart = function(self)
  -- function num : 0_28 , upvalues : _ENV, BattleUtil, cs_MessageCommon
  UIManager:HideWindow(UIWindowTypeID.TDProcessView)
  if (BattleUtil.IsInTDBattle)() then
    self:OnTDBattleStart()
    return 
  end
  if self.getDeployAliveRoleCount ~= nil then
    local roleNum = (self.getDeployAliveRoleCount)()
    if roleNum <= 0 then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Battle_noBattleRole))
    else
      if (BattleUtil.IsBattleEnableFormation)() then
        PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
      end
      ;
      (BattleUtil.TryRunAfterClickBattleCallback)(function()
    -- function num : 0_28_0 , upvalues : self
    self:RealStartBattle()
  end
)
    end
  end
end

UIBattle.OnTDBattleStart = function(self)
  -- function num : 0_29
  self:RealStartBattle()
end

UIBattle.RealStartBattle = function(self)
  -- function num : 0_30 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.EpChipSuit)
  if self.startBattleFunc ~= nil and (self.battleController).LoadedBattleMapObj then
    (self.startBattleFunc)()
    AudioManager:PlayAudioById(1000)
    local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
    if stateInfoWin then
      stateInfoWin:PlayPushChipList()
    end
  end
end

UIBattle.HideRetreatAndCampBondBtn = function(self)
  -- function num : 0_31
  (((self.ui).btn_Retreat).gameObject):SetActive(false)
end

UIBattle.__OnClickBreakDeploy = function(self)
  -- function num : 0_32
  if self.savaDeployFunc ~= nil then
    (self.savaDeployFunc)(true)
    self:__BreakBattle()
  end
end

UIBattle.__BreakBattle = function(self)
  -- function num : 0_33
  if self.breakBattleFunc ~= nil then
    (self.breakBattleFunc)()
  end
end

UIBattle.GetBattleCstNode = function(self)
  -- function num : 0_34
  return self.btnCstItem
end

UIBattle.GetBattleCmderSkillByIndex = function(self, index)
  -- function num : 0_35
  return (self.btnCstItem):GetCmderSkillItemByIndex(index)
end

UIBattle.TryShowCstChange = function(self)
  -- function num : 0_36 , upvalues : BattleUtil, _ENV
  if not (BattleUtil.IsAllowCstChangeShowMoudle)() then
    (self.btnCstItem):Hide()
    return 
  end
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  local skills = {}
  for i,data in ipairs(dynPlayer.playerOriginSkillList) do
    (table.insert)(skills, data.dataId)
  end
  ;
  (table.sort)(skills)
  local isFixedCst = (BattleUtil.TryGetFixedCstSkills)()
  ;
  (self.btnCstItem):Show()
  ;
  (self.btnCstItem):RefreshCstByIdAndList(dynPlayer:GetCSTId(), skills, isFixedCst)
end

UIBattle.CloseCstChange = function(self)
  -- function num : 0_37
  (self.btnCstItem):Hide()
end

UIBattle.OnClickCstItem = function(self, cstTreeData)
  -- function num : 0_38 , upvalues : BattleUtil, cs_MessageCommon, _ENV
  local isFixedCst = (BattleUtil.TryGetFixedCstSkills)()
  if isFixedCst then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.CstFixed))
    return 
  end
  UIManager:HideWindow(UIWindowTypeID.EpChipSuit)
  self:HideMonsterOrNeutralRoleInfo()
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  local cstCtrl = ControllerManager:GetController(ControllerTypeId.CommanderSkill, true)
  cstCtrl:InitCmdSkillCtrl(cstTreeData, self.__OnSendCstChange, self._SaveCftChangeFunc)
end

UIBattle._SaveCftChange = function(self, savingData)
  -- function num : 0_39 , upvalues : BattleUtil, _ENV, FormationUtil
  local isChange = false
  local newCstId = savingData.treeId
  local newSkills = savingData:GetUsingCmdSkillList()
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer:GetCSTId() ~= newCstId then
    isChange = true
  else
    local oldSkillDis = {}
    for i,dynSkillData in ipairs(dynPlayer.playerOriginSkillList) do
      oldSkillDis[dynSkillData.dataId] = true
    end
    if dynPlayer.playerExtraSkillDic ~= nil then
      for skillId,skillLevel in pairs(dynPlayer.playerExtraSkillDic) do
        oldSkillDis[skillId] = nil
      end
    end
    do
      for i,skillId in ipairs(newSkills) do
        if oldSkillDis[skillId] == nil then
          isChange = true
          break
        end
      end
      do
        if not isChange then
          return 
        end
        local networkCallback = function()
    -- function num : 0_39_0 , upvalues : _ENV, newSkills, dynPlayer, newCstId, self
    local skillDic = {}
    for i,skillId in ipairs(newSkills) do
      skillDic[skillId] = 1
    end
    if dynPlayer.playerExtraSkillDic ~= nil then
      for skillId,skillLevel in pairs(dynPlayer.playerExtraSkillDic) do
        skillDic[skillId] = skillLevel
      end
    end
    do
      dynPlayer:InitPlayerSkill(skillDic, newCstId)
      ;
      (self.btnCstItem):RefreshCstByIdAndList(newCstId, newSkills)
      PlayerDataCenter:UpdCstData(newCstId, newSkills)
    end
  end

        if (BattleUtil.IsBattleEnableFormation)() then
          local fromModule = (BattleDungeonManager.dunInterfaceData):GetDgItfFmtFromModule()
          if fromModule == nil then
            error("fromModule == nil")
            return 
          end
          local moduleId = (FormationUtil.GetModuleIdByFmtFromModule)(fromModule)
          local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastBattleDeployFmtId(moduleId)
          local skillNet = NetworkManager:GetNetwork(NetworkTypeID.CommanderSkill)
          skillNet:CS_COMMANDSKILL_SaveFromFormation(lastFmtId, newCstId, newSkills, networkCallback)
        else
          do
            if BattleDungeonManager:InBattleDungeon() then
              local formationData = BattleDungeonManager:GetFormation()
              if formationData == nil then
                return 
              end
              local skillNet = NetworkManager:GetNetwork(NetworkTypeID.CommanderSkill)
              skillNet:CS_COMMANDSKILL_SaveFromFormation(formationData.id, newCstId, newSkills, networkCallback)
            else
              do
                local exploraNet = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
                exploraNet:CS_EXPLORATION_BATTLE_RefreshCommandSkillTree(newCstId, newSkills, networkCallback)
              end
            end
          end
        end
      end
    end
  end
end

UIBattle.OnSendCstChange = function(self)
  -- function num : 0_40 , upvalues : _ENV
  UIManager:ShowWindowOnly(UIWindowTypeID.EpChipSuit)
end

UIBattle.StartChipEft = function(self)
  -- function num : 0_41 , upvalues : BattleUtil, _ENV
  self._chipEftDic = nil
  if self.deployCsHeroList == nil then
    return 
  end
  ;
  (self.deployChipEftPool):HideAll()
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer == nil then
    return 
  end
  self._chipEftDic = {}
  local dungeonStateUI = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonStateUI == nil or not dungeonStateUI.active or not (dungeonStateUI.chipList).active then
    return 
  end
  for i = 1, (self.deployCsHeroList).Count do
    local csCharactor = (self.deployCsHeroList)[i - 1]
    local dynHero = csCharactor.character
    local ownedChips = dynHero:GetOwnedChips()
    if ownedChips ~= nil and not (table.IsEmptyTable)(ownedChips) then
      local skills = {}
      for chipData,_ in pairs(ownedChips) do
        if (chipData.chipBattleData).skillDataList ~= nil and #(chipData.chipBattleData).skillDataList > 0 then
          for _,skillData in ipairs((chipData.chipBattleData).skillDataList) do
            if skillData:GetSkillTag() == eSkillTag.passiveSkill then
              (table.insert)(skills, skillData)
            end
          end
        end
      end
      if #skills ~= 0 then
        local item = (self.deployChipEftPool):GetOne()
        local lsObject = csCharactor.lsObject
        if lsObject ~= nil and not IsNull(lsObject.transform) then
          local lineStartPos = (dungeonStateUI.chipList):GetEftLineStartPos()
          lineStartPos = (self.transform):InverseTransformPoint(lineStartPos)
          item:StartEft(skills, lineStartPos, lsObject, self.resLoader)
          -- DECOMPILER ERROR at PC113: Confused about usage of register: R14 in 'UnsetPending'

          ;
          (self._chipEftDic)[dynHero.dataId] = item
        end
      end
    end
  end
  if #(self.deployChipEftPool).listItem > 0 then
    (dungeonStateUI.chipList):PlayDepolyEft()
  end
end

UIBattle.ResetSkillEft = function(self)
  -- function num : 0_42 , upvalues : _ENV
  if self._chipEftDic == nil or self.deployCsHeroList == nil then
    return 
  end
  for i = 1, (self.deployCsHeroList).Count do
    local csCharactor = (self.deployCsHeroList)[i - 1]
    local dynHero = csCharactor.character
    local item = (self._chipEftDic)[dynHero.dataId]
    local ownedChips = dynHero:GetOwnedChips()
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R9 in 'UnsetPending'

    -- DECOMPILER ERROR at PC33: Unhandled construct in 'MakeBoolean' P1

    if (ownedChips == nil or (table.count)(ownedChips) == 0) and item ~= nil then
      (self._chipEftDic)[dynHero.dataId] = nil
      ;
      (self.deployChipEftPool):HideOne(item)
    end
    local skills = {}
    for chipData,_ in pairs(ownedChips) do
      if (chipData.chipBattleData).skillDataList ~= nil and #(chipData.chipBattleData).skillDataList > 0 then
        for _,skillData in ipairs((chipData.chipBattleData).skillDataList) do
          if skillData:GetSkillTag() == eSkillTag.passiveSkill then
            (table.insert)(skills, skillData)
          end
        end
      end
    end
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R10 in 'UnsetPending'

    -- DECOMPILER ERROR at PC80: Unhandled construct in 'MakeBoolean' P1

    if #skills == 0 and item ~= nil then
      (self._chipEftDic)[dynHero.dataId] = nil
      ;
      (self.deployChipEftPool):HideOne(item)
    end
    if item ~= nil then
      item:ResetSkillsEft(skills)
    else
      local item = (self.deployChipEftPool):GetOne()
      local lsObject = csCharactor.lsObject
      if lsObject ~= nil and not IsNull(lsObject.transform) then
        item:ResetEftState(skills, lsObject, self.resLoader)
        item:PlayHeroChipShow()
        -- DECOMPILER ERROR at PC112: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (self._chipEftDic)[dynHero.dataId] = item
      end
    end
  end
end

UIBattle.EndChipEft = function(self)
  -- function num : 0_43 , upvalues : _ENV
  TimerManager:StopTimer(self._StartChipEftTimer)
  ;
  (self.deployChipEftPool):HideAll()
  local dungeonStateUI = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonStateUI ~= nil and dungeonStateUI.active and (dungeonStateUI.chipList).active then
    (dungeonStateUI.chipList):StopDepolyEft()
  end
end

UIBattle.__OnChipChange = function(self)
  -- function num : 0_44
  self:ResetSkillEft()
end

UIBattle.__OnClickRetreat = function(self)
  -- function num : 0_45 , upvalues : _ENV
  if ExplorationManager:IsInExploration() and ((ExplorationManager.epCtrl).battleCtrl):IsBattleBeforeRunning() then
    ((ExplorationManager.epCtrl).autoCtrl):DisableEpAutoMode()
  end
  if BattleDungeonManager:InBattleDungeon() then
    local isDungeonAuto = (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode()
  end
  if isDungeonAuto then
    (BattleDungeonManager.autoCtrl):AutoBreak(true)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.BattlePause, function(win)
    -- function num : 0_45_0 , upvalues : _ENV, isDungeonAuto
    if win == nil then
      return 
    end
    win:InitBattlePause(function()
      -- function num : 0_45_0_0 , upvalues : _ENV
      if WarChessManager:GetIsInWarChess() then
        WarChessManager:TryExitWCBattle()
      end
      BattleDungeonManager:RetreatDungeon()
      AudioManager:PlayAudioById(1082)
    end
, nil, function()
      -- function num : 0_45_0_1 , upvalues : isDungeonAuto, _ENV
      if isDungeonAuto then
        (BattleDungeonManager.autoCtrl):AutoBreak(false)
      end
    end
)
    win:SetAboutBattleUIActive(false)
  end
)
end

UIBattle.ShowHeroRoleInfo = function(self, hero)
  -- function num : 0_46 , upvalues : _ENV
  if self.isShowEnemyDetail then
    self:HideMonsterOrNeutralRoleInfo()
  end
  self.isShowingHeroInfo = true
  ;
  (UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)):ShowHero(hero)
end

UIBattle.ShowHeroRoleInfoBattleRunning = function(self, entity)
  -- function num : 0_47 , upvalues : _ENV
  if self.isShowEnemyDetail then
    self:HideMonsterOrNeutralRoleInfo()
  end
  local win = UIManager:ShowWindow(UIWindowTypeID.DungeonInfoDetail)
  win:ShowHeroDetailInBattle(entity)
  win:SetSwitchBtnActive(false)
end

UIBattle.ShowMonsterOrNeutralRoleInfoBattleRunning = function(self, entity)
  -- function num : 0_48 , upvalues : _ENV
  local heroCopy = DeepCopy(entity.character)
  heroCopy:CopyAttrFromBattleCharacterEntity(entity)
  self:ShowMonsterOrNeutralRoleInfo(entity.battleRoleView, heroCopy)
end

UIBattle.ShowSummonRoleInfoBattleRunning = function(self, entity)
  -- function num : 0_49 , upvalues : _ENV
  local dynSummoner = entity.summoner
  if self.__lastEntityView ~= nil and self.__lastEntityView ~= entity.battleRoleView then
    (self.__lastEntityView):ShowViewTag(false)
    self.__lastEntityView = nil
  end
  self.isShowEnemyDetail = true
  UIManager:ShowWindowAsync(UIWindowTypeID.BattleEnemyDetail, function(window)
    -- function num : 0_49_0 , upvalues : self, entity, dynSummoner
    self.__lastEntityView = entity.battleRoleView
    window:InitBattleSummonerDetail(dynSummoner, entity)
    ;
    (self.__lastEntityView):ShowViewTag(true)
  end
)
  if not self.SettedTopStatus then
    (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
    self.SettedTopStatus = true
  end
end

UIBattle.ShowMonsterOrNeutralRoleInfo = function(self, battleCharacterView, monsterOrNeutral)
  -- function num : 0_50 , upvalues : _ENV
  if self.__lastEntityView ~= nil and self.__lastEntityView ~= battleCharacterView then
    (self.__lastEntityView):ShowViewTag(false)
    self.__lastEntityView = nil
  end
  if not self.onEnemyDetailUnlock then
    return 
  end
  if self.battleCharacterViewList ~= nil then
    for _,view in ipairs(self.battleCharacterViewList) do
      view:ShowNewArrow(false)
    end
    self.battleCharacterViewList = nil
  end
  local isNew = battleCharacterView.isNew
  if isNew then
    self.battleCharacterViewList = {}
    ;
    (table.insert)(self.battleCharacterViewList, battleCharacterView)
    local enemyList = ((((ExplorationManager.epCtrl).battleCtrl).battleCtrl).EnemyTeamController).battleOriginRoleList
    for i = 0, enemyList.Count - 1 do
      local enemy = enemyList[i]
      if enemy.roleDataId == monsterOrNeutral.dataId then
        (table.insert)(self.battleCharacterViewList, enemy.battleRoleView)
      end
    end
    local neutralList = ((((ExplorationManager.epCtrl).battleCtrl).battleCtrl).NeutralTeamController).battleOriginRoleList
    for i = 0, neutralList.Count - 1 do
      local neutral = neutralList[i]
      if neutral.roleDataId == monsterOrNeutral.dataId then
        (table.insert)(self.battleCharacterViewList, neutral.battleRoleView)
      end
    end
  end
  do
    self.isShowEnemyDetail = true
    UIManager:ShowWindowAsync(UIWindowTypeID.BattleEnemyDetail, function(window)
    -- function num : 0_50_0 , upvalues : self, battleCharacterView, monsterOrNeutral, isNew
    if self.isShowEnemyDetail then
      battleCharacterView:ShowViewTag(true)
      self.__lastEntityView = battleCharacterView
      window:InitBattleEnemyDetail(monsterOrNeutral, isNew, battleCharacterView.characterEntity)
    else
      battleCharacterView:ShowViewTag(false)
      window:Hide()
    end
  end
)
    if not self.SettedTopStatus then
      (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
      self.SettedTopStatus = true
    end
  end
end

UIBattle.HideHeroRoleInfo = function(self)
  -- function num : 0_51
  self.isShowingHeroInfo = false
end

UIBattle.BackAction = function(self)
  -- function num : 0_52 , upvalues : _ENV
  self.SettedTopStatus = false
  if not self.onEnemyDetailUnlock then
    return 
  end
  if self.battleCharacterViewList ~= nil then
    for _,view in ipairs(self.battleCharacterViewList) do
      view:ShowNewArrow(false)
    end
    self.battleCharacterViewList = nil
  end
  self.isShowEnemyDetail = false
  if self.__lastEntityView ~= nil then
    (self.__lastEntityView):ShowViewTag(false)
    self.__lastEntityView = nil
  end
  UIManager:HideWindow(UIWindowTypeID.BattleEnemyDetail)
end

UIBattle.HideMonsterOrNeutralRoleInfo = function(self)
  -- function num : 0_53 , upvalues : _ENV
  if self.SettedTopStatus then
    (UIUtil.OnClickBack)()
  end
end

UIBattle.IsRoleInfoShow = function(self)
  -- function num : 0_54
  if not self.isShowingHeroInfo then
    return self.isShowEnemyDetail
  end
end

UIBattle.SetEpChipListUIActive = function(self, active)
  -- function num : 0_55 , upvalues : _ENV
  if active then
    local win = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
    if win ~= nil then
      win:Show()
      win:SetHeroListActive(false)
      win:SetHeroListHpBar(false)
      win:SetMoneyActive(false)
      win:SetSaveMoneyActive(false)
    end
  else
    do
      local win = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
      if win ~= nil then
        win:SetHeroListActive(true)
        win:SetHeroListHpBar(true)
        win:SetMoneyActive(true)
        win:SetSaveMoneyActive(true)
        win:Hide()
      end
    end
  end
end

UIBattle.OnEnemyDetailUnlock = function(self, active)
  -- function num : 0_56
  self.onEnemyDetailUnlock = active
end

UIBattle.TryRefreshAutoInfo = function(self)
  -- function num : 0_57 , upvalues : _ENV
  if not BattleDungeonManager:InBattleDungeon() or not (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
    ((self.ui).battleAutoNow):SetActive(false)
    return 
  end
  local battleCount = (BattleDungeonManager.autoCtrl):GetBattleCount() + 1
  local totalCount = (BattleDungeonManager.autoCtrl):GetTotalDungeonAutoCount()
  ;
  ((self.ui).battleAutoNow):SetActive(true)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Count_BattleAuto).text = (string.format)("%d/%d", battleCount, totalCount)
end

UIBattle.OnHide = function(self)
  -- function num : 0_58 , upvalues : base, _ENV
  (base.OnHide)(self)
  self:EndChipEft()
  local win = UIManager:GetWindow(UIWindowTypeID.BattleCrazyMode)
  if win ~= nil then
    win:Hide()
  end
end

UIBattle.__CallWaveComing = function(self, index)
  -- function num : 0_59
  if (self.ui).img_WaveWarning ~= nil and (self.ui).tween_WaveWarning ~= nil and (self.ui).text_WaveWarning ~= nil then
    ((self.ui).img_WaveWarning):SetIndex(index)
    ;
    ((self.ui).text_WaveWarning):SetIndex(index)
    ;
    ((self.ui).tween_WaveWarning):DORestart()
  end
end

UIBattle.ShowCurLvInfoUI = function(self)
  -- function num : 0_60 , upvalues : _ENV, BattleUtil
  (((self.ui).obj_currLevel).gameObject):SetActive(false)
  self:_ShowCurEpProgress()
  if ExplorationManager:IsInExploration() then
    (((self.ui).obj_currLevel).gameObject):SetActive(true)
    ;
    ((self.ui).tex_LvName):SetIndex(0)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_Level).text = tostring(ExplorationManager:GetCurLevelIndex() + 1) .. "/" .. tostring(ExplorationManager:GetLevelCount())
    return 
  end
  local towerLvName, LvNum = (BattleUtil.TryGetDungeonLvTowerLvInfo)()
  if towerLvName ~= nil then
    (((self.ui).obj_currLevel).gameObject):SetActive(true)
    ;
    ((self.ui).tex_LvName):SetIndex(1, towerLvName)
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Level).text = tostring(LvNum)
  end
end

UIBattle._ShowCurEpProgress = function(self)
  -- function num : 0_61 , upvalues : _ENV, BattleUtil
  ((self.ui).obj_curDefRate):SetActive(false)
  if not ExplorationManager:IsInExplorationTD() and not (BattleUtil.IsSpecialTDMode)() and not ExplorationManager:IsInExplorationLight() and not (BattleUtil.IsInGuardBattle)() then
    return 
  end
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  local opDetail = dynPlayer:GetOperatorDetail()
  if opDetail ~= nil then
    local x, y = (ExplorationManager.Coordination2Pos)(opDetail.curPostion)
    local maxDepth = ((ExplorationManager.epCtrl).mapData).maxMapColNumber
    if maxDepth ~= nil then
      ((self.ui).obj_curDefRate):SetActive(true)
      local strX = tostring(x)
      local strMaxDepth = tostring(maxDepth)
      -- DECOMPILER ERROR at PC57: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_curDefRate).text = strX .. "/" .. strMaxDepth
    end
  end
end

UIBattle.__OnClickHideUIState = function(self)
  -- function num : 0_62 , upvalues : _ENV
  if self.battleUIStateFunc ~= nil then
    (self.battleUIStateFunc)(false)
  end
  ;
  (self.gameplayScore):Hide()
  UIManager:HideWindow(UIWindowTypeID.BattleDPS)
  UIManager:HideWindow(UIWindowTypeID.BattleCrazyMode)
  UIManager:HideWindow(UIWindowTypeID.BattleSkillModule)
  UIManager:HideWindow(UIWindowTypeID.DungeonStateInfo)
  ;
  (((self.ui).btn_HideUI).gameObject):SetActive(false)
  ;
  (((self.ui).btn_ShowUI).gameObject):SetActive(true)
  ;
  ((self.ui).frame):SetActive(false)
end

UIBattle.__OnClickShowUIState = function(self)
  -- function num : 0_63 , upvalues : _ENV
  if self.battleUIStateFunc ~= nil then
    (self.battleUIStateFunc)(true)
  end
  ;
  (self.gameplayScore):Show()
  UIManager:ShowWindow(UIWindowTypeID.BattleDPS)
  UIManager:ShowWindow(UIWindowTypeID.BattleCrazyMode)
  UIManager:ShowWindow(UIWindowTypeID.BattleSkillModule)
  UIManager:ShowWindow(UIWindowTypeID.DungeonStateInfo)
  ;
  (((self.ui).btn_HideUI).gameObject):SetActive(true)
  ;
  (((self.ui).btn_ShowUI).gameObject):SetActive(false)
  ;
  ((self.ui).frame):SetActive(true)
end

UIBattle.OnDelete = function(self)
  -- function num : 0_64 , upvalues : _ENV, base
  TimerManager:StopTimer(self._StartChipEftTimer)
  MsgCenter:RemoveListener(eMsgEventId.WaveComing, self.__callWaveComingAction)
  MsgCenter:RemoveListener(eMsgEventId.OnEpChipListChange, self.__OnChipChangeEvent)
  UIManager:DeleteWindow(UIWindowTypeID.BattleCrazyMode)
  if self.gameplayScore ~= nil then
    (self.gameplayScore):OnDelete()
    self.gameplayScore = nil
  end
  self.deployCsHeroList = nil
  if self._userDataCfg ~= nil then
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  end
  local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if stateInfoWin then
    stateInfoWin:PlayPopChipList()
  end
  ;
  (self.deployChipEftPool):DeleteAll()
  UIManager:DeleteWindow(UIWindowTypeID.BattleEnemyDetail)
  if self.__autoSwitchNode ~= nil then
    (self.__autoSwitchNode):Delete()
  end
  self.breakBattleFunc = nil
  self.__lastEntityView = nil
  self.cs_battleCtrl = nil
  self.startBattleFunc = nil
  self.savaDeployFunc = nil
  self.getDeployAliveRoleCount = nil
  self.pauseFunc = nil
  self.speedUpFunc = nil
  self.autoBattleFunc = nil
  self.autoUltFunc = nil
  self.autoUltMaxEnergy = nil
  self.battleController = nil
  ;
  (base.OnDelete)(self)
end

return UIBattle

