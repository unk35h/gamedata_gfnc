-- params : ...
-- function num : 0 , upvalues : _ENV
local UIBattlePause = class("UIBattlePause", UIBaseWindow)
local base = UIBaseWindow
local SectorEnum = require("Game.Sector.SectorEnum")
local DungeonConst = require("Game.BattleDungeon.DungeonConst")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local cs_MessageCommon = CS.MessageCommon
UIBattlePause.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_GiveUp, self, self.__OnClickGiveUp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reload, self, self.__OnClickRestart)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GoOn, self, self.__OnClickContinue)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Setting, self, self.__OnClickSetting)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Interrupt, self, self.__OnClickInterrupt)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RestartEp, self, self.__OnClickRestartEp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Intro, self, self.__OnClickIntro)
  local isUnlockBattleExit = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BattleExit)
  if not isUnlockBattleExit then
    (((self.ui).btn_GiveUp).gameObject):SetActive(false)
  end
  ;
  ((self.ui).tex_GiveupDes):SetIndex(0)
end

UIBattlePause.InitBattlePause = function(self, giveUpBattleFunc, restartFunc, pauseFunc)
  -- function num : 0_1 , upvalues : _ENV, eWarChessEnum
  (UIUtil.SetTopStatus)(self, self.OnContinue, nil, nil, nil, true)
  self.giveUpBattleFunc = giveUpBattleFunc
  self.restartFunc = restartFunc
  self.pauseFunc = pauseFunc
  ;
  (((self.ui).btn_Intro).gameObject):SetActive(false)
  local isInExploration = ExplorationManager:IsInExploration()
  self.__hasRestartLimit = not isInExploration or ExplorationManager:GetEpModuleId() ~= proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge
  if not isInExploration then
    ((self.ui).obj_levelInfo):SetActive(WarChessManager:GetIsInWarChess())
    ;
    (((self.ui).tex_RestartCount).gameObject):SetActive(self.__hasRestartLimit)
    local supportInterrupt = (BattleUtil.IsSupportInterruptPlay)()
    ;
    (((self.ui).btn_Interrupt).gameObject):SetActive(supportInterrupt)
    local enableRestartEpFloor = isInExploration and ((ExplorationManager:GetCurLevelIndex() < 1 or ((ExplorationManager.epCtrl).battleCtrl):IsBattleBeforeRunning()) and not ((ExplorationManager.epCtrl):GetCurrentRoomData()):IsStartRoom())
    ;
    (((self.ui).btn_RestartEp).gameObject):SetActive(enableRestartEpFloor)
    if enableRestartEpFloor then
      local usedNum = ((ExplorationManager.epCtrl).mapData):GetEpFloorRestartTimes()
      local remainNum = (math.max)((ConfigData.game_config).epFloorRestartLimitNum - usedNum, 0)
      ;
      ((self.ui).tex_RestartEpCount):SetIndex(0, tostring(remainNum))
      self._restartEpLimit = remainNum <= 0
      -- DECOMPILER ERROR at PC129: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.ui).cs_RestartEp).alpha = self._restartEpLimit and 0.4 or 1
    end
    local sectorStageCfg = ExplorationManager:GetSectorStageCfg()
    do
      if sectorStageCfg ~= nil then
        local msg = nil
        if sectorStageCfg.endlessCfg ~= nil then
          msg = ConfigData:GetEndlessInfoMsg(sectorStageCfg.endlessCfg, (sectorStageCfg.endlessCfg).index * 10)
        elseif sectorStageCfg.challengeCfg ~= nil then
          local moduleId = ExplorationManager:GetEpModuleId()
          msg = ConfigData:GetChallengeInfoMsg(moduleId)
        else
          msg = ConfigData:GetSectorInfoMsg(sectorStageCfg.sector, sectorStageCfg.num, sectorStageCfg.difficulty)
        end
        -- DECOMPILER ERROR at PC169: Confused about usage of register: R9 in 'UnsetPending'

        ;
        ((self.ui).tex_LevelCount).text = msg
        -- DECOMPILER ERROR at PC176: Confused about usage of register: R9 in 'UnsetPending'

        ;
        ((self.ui).tex_LevelName).text = (LanguageUtil.GetLocaleText)(sectorStageCfg.name)
        if self.__hasRestartLimit then
          self.__battleCountLimit = ((ExplorationManager.epCtrl).battleCtrl):GetEpBattleLastCount()
          ;
          ((self.ui).tex_RestartCount):SetIndex(0, tostring(self.__battleCountLimit))
          -- DECOMPILER ERROR at PC199: Confused about usage of register: R9 in 'UnsetPending'

          if self.__battleCountLimit <= 0 then
            ((self.ui).cs_Restart).alpha = 0.4
          else
            -- DECOMPILER ERROR at PC203: Confused about usage of register: R9 in 'UnsetPending'

            ((self.ui).cs_Restart).alpha = 1
          end
        end
        if (ExplorationManager.epCtrl):IsCompleteExploration() then
          ((self.ui).tex_GiveupDes):SetIndex(1)
        else
          ((self.ui).tex_GiveupDes):SetIndex(0)
        end
      end
      if isInExploration and ((ExplorationManager.epCtrl).battleCtrl):IsCloseReloadSupport() then
        self:SetAboutBattleUIActive(false)
      else
        self:SetAboutBattleUIActive(true)
      end
      ;
      (self.transform):SetAsLastSibling()
      if BattleDungeonManager:InBattleDungeon() then
        local isInDungeonAuto = (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode()
      end
      ;
      (((self.ui).tex_GiveupAutoDes).gameObject):SetActive(isInDungeonAuto)
      if isInDungeonAuto then
        ((self.ui).tex_GiveupAutoDes):SetIndex(0)
      end
      if (BattleUtil.IsInWinterChallengeDungeon)() then
        self:SetBtPauseWinChanllenge()
      end
      local isInTDBattle = (BattleUtil.IsInTDBattle)()
      if isInTDBattle and not (BattleUtil.IsSpecialTDMode)() then
        self:SetBattlePauseIntro((ConfigData.game_config).TDTipsIntroduceId)
      elseif (BattleUtil.IsInDailyDungeon)() then
        self:SetBattlePauseIntro(PicTipsConsts.DailyDungeon)
      end
      if WarChessManager:GetIsInWarChess() then
        local wcCtrl = WarChessManager:GetWarChessCtrl()
        local couldEscapeFromBattle = true
        if wcCtrl:GetWCSurSubSystemCat() == (eWarChessEnum.eSystemCat).battle then
          couldEscapeFromBattle = (wcCtrl.battleCtrl):GetWCAllowRetreatBattle()
        end
        ;
        (((self.ui).btn_GiveUp).gameObject):SetActive(couldEscapeFromBattle)
        local name, index = WarChessManager:GetLevelNameAndIndex()
        -- DECOMPILER ERROR at PC324: Confused about usage of register: R14 in 'UnsetPending'

        ;
        ((self.ui).tex_LevelCount).text = index
        -- DECOMPILER ERROR at PC327: Confused about usage of register: R14 in 'UnsetPending'

        ;
        ((self.ui).tex_LevelName).text = name
      end
      -- DECOMPILER ERROR: 25 unprocessed JMP targets
    end
  end
end

UIBattlePause.SetBattlePauseIntro = function(self, introId)
  -- function num : 0_2
  self._introId = introId
  if introId > 0 then
    (((self.ui).btn_Intro).gameObject):SetActive(true)
  end
end

UIBattlePause.SetBtPauseWinChanllenge = function(self)
  -- function num : 0_3 , upvalues : _ENV, DungeonConst
  self:SetBtPauseReturn2HomeFunc(function()
    -- function num : 0_3_0 , upvalues : _ENV
    BattleDungeonManager:InjectBattleExitEvent(nil)
    BattleDungeonManager:RetreatDungeon()
  end
, true)
  ;
  (((self.ui).tex_CurScore).gameObject):SetActive(true)
  ;
  ((self.ui).tex_GiveupDes):SetIndex(2)
  ;
  (((self.ui).tex_GiveupAutoDes).gameObject):SetActive(true)
  ;
  ((self.ui).tex_GiveupAutoDes):SetIndex(1)
  local dgLevelData = (BattleDungeonManager.dunInterfaceData):GetIDungeonLevelData()
  local score = dgLevelData:GetSctIIChallengeDgScore()
  ;
  ((self.ui).tex_CurScore):SetIndex(0, tostring(score))
  self._customeGiveUpBattleFunc = function()
    -- function num : 0_3_1 , upvalues : _ENV, dgLevelData, self, DungeonConst
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
    if sectorIICtrl == nil then
      return 
    end
    sectorIICtrl:ReqSettleActSctIIChallengeDg(dgLevelData, function()
      -- function num : 0_3_1_0 , upvalues : _ENV, self, DungeonConst
      local dgBattleCtrl = BattleDungeonManager:GetDungeonCtrl()
      if dgBattleCtrl == nil then
        error("dgBattleCtrl == nil")
        self:_GiveUp()
        return 
      end
      ;
      (dgBattleCtrl.battleCtrl):DgTryAddWinterChallengeScoreShow()
      local giveUpFunc = self.giveUpBattleFunc
      dgBattleCtrl:AddDungeonLogic((DungeonConst.LogicType).ExitDungeon, nil, function()
        -- function num : 0_3_1_0_0 , upvalues : giveUpFunc, _ENV
        if giveUpFunc then
          giveUpFunc()
        end
        AudioManager:PlayAudioById(1082)
      end
)
      dgBattleCtrl:StartRunNextLogic()
      self:Delete()
    end
)
  end

end

UIBattlePause.__OnClickGiveUp = function(self)
  -- function num : 0_4
  if self._customeGiveUpBattleFunc ~= nil then
    (self._customeGiveUpBattleFunc)()
    return 
  end
  self:_GiveUp()
end

UIBattlePause._GiveUp = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.giveUpBattleFunc ~= nil then
    (self.giveUpBattleFunc)()
  end
  AudioManager:PlayAudioById(1082)
end

UIBattlePause.__OnClickRestart = function(self)
  -- function num : 0_6 , upvalues : cs_MessageCommon, _ENV
  if self.__hasRestartLimit and self.__battleCountLimit <= 0 then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(171))
    return 
  end
  AudioManager:StopSource(eAudioSourceType.VoiceSource)
  AudioManager:PlayAudioById(1084)
  if self.restartFunc ~= nil then
    (self.restartFunc)()
    self:Hide()
  end
  UIManager:DeleteWindow(UIWindowTypeID.BattleCrazyMode)
  UIManager:DeleteWindow(UIWindowTypeID.RichIntro)
  local win = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if win ~= nil then
    win:StopUseChipEffect()
  end
  ;
  (UIUtil.PopFromBackStackByUiTab)(self)
end

UIBattlePause.__OnClickRestartEp = function(self)
  -- function num : 0_7 , upvalues : cs_MessageCommon, _ENV
  if self._restartEpLimit then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(764))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_7_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(198), function()
      -- function num : 0_7_0_0 , upvalues : _ENV, self
      (UIUtil.PopFromBackStackByUiTab)(self)
      ExplorationManager:ReqRestartEpFloor()
    end
)
  end
)
end

UIBattlePause.OnContinue = function(self)
  -- function num : 0_8 , upvalues : _ENV
  AudioManager:PlayAudioById(1083)
  if self.pauseFunc ~= nil then
    (self.pauseFunc)(false)
  end
  self:Hide()
end

UIBattlePause.__OnClickContinue = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIBattlePause.__OnClickSetting = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Setting, function(win)
    -- function num : 0_10_0 , upvalues : _ENV
    if win ~= nil then
      win:InitSettingByFrom(UIWindowTypeID.BattlePause)
    end
  end
)
end

UIBattlePause.SetBtPauseReturn2HomeFunc = function(self, return2HomeFunc, forceOpen)
  -- function num : 0_11
  self.return2HomeFunc = return2HomeFunc
  if forceOpen then
    (((self.ui).btn_Interrupt).gameObject):SetActive(true)
  end
end

UIBattlePause.__OnClickInterrupt = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.return2HomeFunc ~= nil then
    (self.return2HomeFunc)()
    return 
  end
  if not ExplorationManager:IsInExploration() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_12_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(197), function()
      -- function num : 0_12_0_0 , upvalues : _ENV, self
      (UIUtil.PopFromBackStackByUiTab)(self)
      ExplorationManager:ExitExploration((Consts.SceneName).Main)
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R0 in 'UnsetPending'

      if (Time.unity_time).timeScale ~= 1 then
        (Time.unity_time).timeScale = 1
      end
    end
)
  end
)
end

UIBattlePause.__OnClickIntro = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)(self._introId, nil)
end

UIBattlePause.SetAboutBattleUIActive = function(self, active)
  -- function num : 0_14
  (((self.ui).btn_Reload).gameObject):SetActive(active)
  ;
  (((self.ui).tex_RestartCount).gameObject):SetActive(not self.__hasRestartLimit or active)
end

UIBattlePause.OnDelete = function(self)
  -- function num : 0_15 , upvalues : base
  (base.OnDelete)(self)
  self.giveUpBattleFunc = nil
  self.restartFunc = nil
  self.pauseFunc = nil
end

return UIBattlePause

