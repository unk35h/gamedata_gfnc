-- params : ...
-- function num : 0 , upvalues : _ENV
local FormationController = class("FormationController", ControllerBase)
local base = ControllerBase
local CS_Input = (CS.UnityEngine).Input
local CS_ResLoader = CS.ResLoader
local CS_Camera = (CS.UnityEngine).Camera
local CS_GameObject = (CS.UnityEngine).GameObject
local CS_MessageCommon = CS.MessageCommon
local CS_Shader = (CS.UnityEngine).Shader
local FmtEnum = require("Game.Formation.FmtEnum")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local EnterFmtData = require("Game.Formation.Data.EnterFmtData")
local util = require("XLua.Common.xlua_util")
local FormationUtil = require("Game.Formation.FormationUtil")
local TaskCheckUtil = require("Game.Task.TaskCheckUtil")
local FormationSceneCtrl = require("Game.Formation.Ctrl.FormationSceneCtrl")
local WCEnum = require("Game.WeeklyChallenge.WCEnum")
FormationController.OnInit = function(self)
  -- function num : 0_0 , upvalues : FormationSceneCtrl, _ENV, CS_ResLoader, CS_Shader
  self.ctrls = {}
  self.fmtSceneCtrl = (FormationSceneCtrl.New)(self)
  self.heroNetwork = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  self.resloader = (CS_ResLoader.Create)()
  self._GlobalCharColorHash = (CS_Shader.PropertyToID)("_GlobalCharColor")
  self:ResetFmtCtrlState()
  self.__TryFixFormatoionCST = BindCallback(self, self.TryFixFormatoionCST)
  self._TryUpdateSupporeDatas = BindCallback(self, self.TryUpdateSupporeDatas)
  self.__UpdateHeroForFmtInfo = BindCallback(self, self._OnUpdateHero)
  self.__FormationHeroChangeFunc = BindCallback(self, self.__FormationHeroChange)
  self.__OnCommendSkillChange = BindCallback(self, self.OnCommendSkillChange)
  self.__OnFmtHeroSkinChange = BindCallback(self, self._OnFmtHeroSkinChange)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__TryFixFormatoionCST)
  MsgCenter:AddListener(eMsgEventId.OnSupportHoreNeedFresh, self._TryUpdateSupporeDatas)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__UpdateHeroForFmtInfo)
  MsgCenter:AddListener(eMsgEventId.OnHeroAthChange, self.__FormationHeroChangeFunc)
  MsgCenter:AddListener(eMsgEventId.HeroTalentLvUp, self.__FormationHeroChangeFunc)
  MsgCenter:AddListener(eMsgEventId.OnCommanderSkillChande, self.__OnCommendSkillChange)
  MsgCenter:AddListener(eMsgEventId.OnHeroSkinChange, self.__OnFmtHeroSkinChange)
end

FormationController.ResetFmtCtrlState = function(self)
  -- function num : 0_1 , upvalues : FmtEnum
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).none
  self.__enterFmtData = nil
  self.__realFmtData = nil
  self.__fmtData = nil
  self.__fmtUI2D = nil
  self._fmtCommanderskillChange = false
  self._fmtIsChange = false
  self._heroChangedIdDic = {}
end

FormationController.GetNewEnterFmtData = function(self)
  -- function num : 0_2 , upvalues : FmtEnum, EnterFmtData
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).parpare
  self.__enterFmtData = (EnterFmtData.New)()
  return self.__enterFmtData
end

FormationController.GetCurEnterFmtData = function(self)
  -- function num : 0_3
  return self.__enterFmtData
end

FormationController.EnterFormation = function(self)
  -- function num : 0_4 , upvalues : FmtEnum, _ENV, CS_Camera, CS_GameObject, util
  if self.__fmtCtrlState ~= (FmtEnum.FmtCtrlSate).parpare then
    error("fmtCtrl state error: not parpare state when enter fromation")
    return 
  end
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).normal
  ;
  (self.__enterFmtData):GenFmtCtrlData()
  self:GenFormationData()
  self:__RegularSupportHeroData(self.__realFmtData)
  self.__fmtData = (self.__realFmtData):DeepCopyFmtData()
  self:_RegularHeroNumLimit()
  self.__mainCam = CS_Camera.main
  self.__lightMain = (CS_GameObject.FindWithTag)(TagConsts.MainLight)
  self.__initCoroutine = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self.__LoadFormationScene)))
end

FormationController.GenFormationData = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local isFixedFmt = (self.__enterFmtData):IsFmtCtrlFiexd()
  do
    if isFixedFmt then
      local fmtId = (self.__enterFmtData):GetFmtCtrlFmtId()
      self.__realFmtData = (PlayerDataCenter.formationDic)[fmtId]
      return 
    end
    local isVirtual = (self.__enterFmtData):IsFmtCtrlVirtualFmtData()
    do
      if isVirtual then
        local virtualFmtData = (self.__enterFmtData):GetFmtCtrlVirtualFmtData()
        self.__realFmtData = virtualFmtData.formation
        return 
      end
      local fmtId = (self.__enterFmtData):GetFmtCtrlFmtId()
      self.__realFmtData = (PlayerDataCenter.formationDic)[fmtId]
      if self.__realFmtData == nil then
        PlayerDataCenter:CreateFormation(fmtId)
        self.__realFmtData = (PlayerDataCenter.formationDic)[fmtId]
      else
        self:CheckAndSyncIllegalCST()
      end
    end
  end
end

FormationController.GetOtherFormationData = function(self, fmtId)
  -- function num : 0_6 , upvalues : _ENV
  local isVirtual = (self.__enterFmtData):IsFmtCtrlVirtualFmtData()
  if isVirtual then
    error("VirtualFmtData not support to get yet")
    return nil
  end
  return (PlayerDataCenter.formationDic)[fmtId]
end

FormationController.__LoadFormationScene = function(self)
  -- function num : 0_7 , upvalues : _ENV, CS_Camera, CS_Shader
  (UIUtil.AddOneCover)("FmtCtrlLoadFormation", SafePack(nil, nil, nil, Color.clear, false))
  local path = PathConsts:GetFormationModelPath("Formation")
  local sceneWait = (self.resloader):LoadABAssetAsyncAwait(path)
  ;
  (coroutine.yield)(sceneWait)
  local go = (sceneWait.Result):Instantiate()
  ;
  (self.fmtSceneCtrl):InitFmtSceneCtrl(go, self.__enterFmtData)
  self:OnEnterFormationScene()
  local enterFunc = (self.__enterFmtData):GetFmtCtrlEnterFunc()
  if enterFunc ~= nil then
    enterFunc()
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Formation, function(win)
    -- function num : 0_7_0 , upvalues : self
    self.__fmtUI2D = win
    win:InitUIFormation(self, self.__enterFmtData)
  end
)
  while self.__fmtUI2D == nil do
    (coroutine.yield)(nil)
  end
  ;
  (self.fmtSceneCtrl):RefreshFmtScene(true)
  local customLight = nil
  if not IsNull(self.__camMain) then
    customLight = (self.__camMain):GetComponent(typeof(CS.CustomLight))
  end
  if IsNull(customLight) then
    customLight = (CS_Camera.main):GetComponent(typeof(CS.CustomLight))
  end
  if not IsNull(customLight) then
    (CS_Shader.SetGlobalColor)(self._GlobalCharColorHash, customLight.CharacterGlobalColor)
    customLight:RefreshCharacterShadow()
    customLight:RefreshCharacterOutline()
  end
  local heroIdList = {}
  for k,heroId in pairs((self.__fmtData):GetFormationHeroDic(true)) do
    (table.insert)(heroIdList, heroId)
  end
  if #heroIdList > 0 then
    local voHeroId = heroIdList[(math.random)(#heroIdList)]
    local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
    cvCtr:PlayCv(voHeroId, ConfigData:GetVoicePointRandom(eVoicePointType.EnterTeam, nil, voHeroId))
  end
  do
    ;
    (UIUtil.CloseOneCover)("FmtCtrlLoadFormation")
    GuideManager:TryTriggerGuide(eGuideCondition.InFormationSpecial)
  end
end

FormationController.SetCouldUseSwitchBtn = function(self, bool)
  -- function num : 0_8
  (self.__fmtUI2D):SetSwitchButtonActive(bool)
end

FormationController.FmtCtrlEnterEditSate = function(self)
  -- function num : 0_9 , upvalues : FmtEnum, _ENV
  if self.__fmtCtrlState == (FmtEnum.FmtCtrlSate).editing then
    return 
  end
  if self.__fmtCtrlState ~= (FmtEnum.FmtCtrlSate).normal then
    error("fmtCtrl state error: not normal state when enter EditSate")
    return 
  end
  if (self.__enterFmtData):IsFmtCtrlVirtualFmtData() then
    self:ShowQuickFormation(nil)
    return 
  end
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).editing
  ;
  (UIUtil.AddOneCover)("FmtCtrlEnterEditSate", SafePack(nil, nil, nil, Color.clear, false))
  ;
  (self.__fmtUI2D):EnterEditorMode()
  ;
  (self.fmtSceneCtrl):PlayTimeLine(function()
    -- function num : 0_9_0 , upvalues : _ENV
    (UIUtil.CloseOneCover)("FmtCtrlEnterEditSate")
  end
, function()
    -- function num : 0_9_1 , upvalues : _ENV, self
    for index,heroEntity in pairs((self.fmtSceneCtrl).heroEntityDic) do
      heroEntity:UpdateInfoPos()
    end
  end
)
  ;
  ((self.fmtSceneCtrl):Get3DUIFormation()):ShowFmtHeroQuickLvUp()
end

FormationController.IsFmtCtrlInEditState = function(self)
  -- function num : 0_10 , upvalues : FmtEnum
  do return self.__fmtCtrlState == (FmtEnum.FmtCtrlSate).editing end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

FormationController.FmtCtrlQuitEditSate = function(self)
  -- function num : 0_11 , upvalues : FmtEnum, _ENV
  if self.__fmtCtrlState ~= (FmtEnum.FmtCtrlSate).editing then
    error("fmtCtrl state error: not editing state when Quit EditSate")
    return 
  end
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).normal
  ;
  (UIUtil.AddOneCover)("FmtCtrlQuitEditSate", SafePack(nil, nil, nil, Color.clear, false))
  ;
  (self.__fmtUI2D):ExitEditorMode()
  ;
  (self.fmtSceneCtrl):RewindTimeLine(function()
    -- function num : 0_11_0 , upvalues : _ENV
    (UIUtil.CloseOneCover)("FmtCtrlQuitEditSate")
  end
, function()
    -- function num : 0_11_1 , upvalues : _ENV, self
    for index,heroEntity in pairs((self.fmtSceneCtrl).heroEntityDic) do
      heroEntity:UpdateInfoPos()
    end
  end
)
  self:ModifyFormation(self.__fmtData)
  ;
  ((self.fmtSceneCtrl):Get3DUIFormation()):ShowFmtHeroQuickLvUp()
end

FormationController.FmtCtrlOnStartDraggingCard = function(self, heroData)
  -- function num : 0_12 , upvalues : FmtEnum, _ENV
  if self.__fmtCtrlState ~= (FmtEnum.FmtCtrlSate).editing then
    error("fmtCtrl state error: not editing state")
    return 
  end
  self.dragingCardHeroData = heroData
  local heroEntity = ((self.fmtSceneCtrl).heroEntityIdDic)[heroData.dataId]
  if heroEntity ~= nil then
    (self.__fmtUI2D):SetFormationFocus(true, (heroEntity.transform).position)
  end
end

FormationController.FmtCtrlOnEndDraggingCard = function(self)
  -- function num : 0_13
  self.dragingCardHeroData = nil
  ;
  (self.__fmtUI2D):SetFormationFocus(false)
end

FormationController.GetOnDragCardHeroData = function(self)
  -- function num : 0_14
  return self.dragingCardHeroData
end

FormationController.ModifyFormation = function(self, formationData, newHeroDic, isForce)
  -- function num : 0_15 , upvalues : FmtEnum, _ENV
  if self.__fmtCtrlState == (FmtEnum.FmtCtrlSate).editing and not isForce then
    return 
  end
  ;
  (self.__realFmtData):ModifyFormationData(formationData, newHeroDic)
  if formationData == nil then
    self.__fmtData = (self.__realFmtData):DeepCopyFmtData()
  end
  self:_RegularHeroNumLimit()
  if not (self.__enterFmtData):IsFmtCtrlVirtualFmtData() then
    (self.heroNetwork):SendFormationFresh((self.__realFmtData).id, (self.__realFmtData):GetFormationHeroDic(true))
  else
    local _, wcType = (self.__enterFmtData):IsWCFormation()
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetLastWeeklyChallengeFmt(wcType, (self.__realFmtData):GetFormationHeroDic(true))
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  end
  do
    self._fmtIsChange = true
  end
end

FormationController.ModifyFormationName = function(self, name)
  -- function num : 0_16
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.__fmtData).name = name
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.__realFmtData).name = name
end

FormationController.OnCurrentFmtChanged = function(self)
  -- function num : 0_17
  (self.__fmtUI2D):RefreshUIAboutCurFmtDat()
end

FormationController.FmtStartBattle = function(self)
  -- function num : 0_18 , upvalues : _ENV, TaskCheckUtil, CS_MessageCommon
  if (self.__enterFmtData):IsFmtChallengeMode() then
    local stgChallengeData = (self.__enterFmtData):GetFmtChallengeModeData()
    for taskId,v in pairs(stgChallengeData:GetStgClgOptionalTaskOpenDic()) do
      local ok, taskDes = TaskCheckUtil:CheckFormationCondition(taskId, self.__fmtData)
      do
        if not ok then
          UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_18_0 , upvalues : _ENV, taskDes
    if win == nil then
      return 
    end
    win:ShowTextBoxWithConfirm(((string.format)(ConfigData:GetTipContent(964), taskDes)), nil)
  end
)
          return 
        end
      end
    end
  end
  do
    local count = 0
    local heroIdList = {}
    local heroIdDic = (self.__fmtData):GetFormationHeroDic()
    for i = 1, (ConfigData.game_config).max_stage_hero do
      if heroIdDic[i] ~= nil and heroIdDic[i] > 0 then
        count = count + 1
        ;
        (table.insert)(heroIdList, heroIdDic[i])
      end
    end
    if (self.__fmtData):GetIsOnlyHaveSupportHero() then
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Formation_OnlyHaveASupportHero))
      return 
    end
    if count < (ConfigData.game_config).min_stage_hero then
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)((string.format)(ConfigData:GetTipContent(TipContent.Sector_HeroNumInsufficient), tostring((ConfigData.game_config).min_stage_hero)))
      return 
    end
    local startFunc = function()
    -- function num : 0_18_1 , upvalues : heroIdList, _ENV, self
    local voHeroId = heroIdList[(math.random)(#heroIdList)]
    local voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.StartBattle, nil, voHeroId)
    local startBattleFunc = (self.__enterFmtData):GetFmtCtrlStartBattleFunc()
    if startBattleFunc ~= nil then
      startBattleFunc(self.__fmtData, function()
      -- function num : 0_18_1_0 , upvalues : self, voHeroId, voiceId
      self:AfterStartBattleExitFormation(voHeroId, voiceId)
    end
)
    end
    ;
    (PlayerDataCenter.supportHeroData):CleanCachedSupportData()
  end

    if (self.__enterFmtData):IsFmtCtrlFiexd() and not (self.__enterFmtData):IsFmtFixedHeroFull(self.__fmtData) then
      UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_18_2 , upvalues : _ENV, startFunc
    if win == nil then
      return 
    end
    win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(392), startFunc, nil)
  end
)
      return 
    end
    startFunc()
  end
end

FormationController.AfterStartBattleExitFormation = function(self, voHeroId, voiceId)
  -- function num : 0_19 , upvalues : _ENV, FmtEnum
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  cvCtr:PlayCv(voHeroId, voiceId)
  if ExplorationManager:IsInTDExp() or BattleDungeonManager:IsInTDDungeon() then
    self:Delete()
    self:OnLeaveFormationScene()
    return 
  end
  local gameType = (self.__enterFmtData):GetFmtCtrlGameType()
  do
    if gameType == (FmtEnum.eFmtGamePlayType).Exploration and ExplorationManager:IsInExploration() then
      local heroResDic = self:__GetFmtReuseHeroResDic()
      ;
      ((ExplorationManager.epCtrl).sceneCtrl):SaveReuseHeroResloader(heroResDic)
    end
    do
      if gameType == (FmtEnum.eFmtGamePlayType).Dungeon and BattleDungeonManager:InBattleDungeon() then
        local heroResDic = self:__GetFmtReuseHeroResDic()
        ;
        ((BattleDungeonManager.dungeonCtrl).sceneCtrl):SaveReuseHeroResloader(heroResDic)
      end
      if gameType == (FmtEnum.eFmtGamePlayType).WarChess then
        self:Delete()
        self:OnLeaveFormationScene()
      end
    end
  end
end

FormationController.__GetFmtReuseHeroResDic = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local heroResDic = {}
  for heroId,heroEntity in pairs((self.fmtSceneCtrl).heroEntityIdDic) do
    local resloader = heroEntity:GetHeroEntityLoadedResloader()
    if resloader ~= nil then
      heroResDic[heroId] = resloader
    end
  end
  return heroResDic
end

FormationController.FmtCtrlSwitchFmt = function(self, fmtId, index)
  -- function num : 0_21 , upvalues : FmtEnum
  if self.__fmtCtrlState == (FmtEnum.FmtCtrlSate).editing then
    self:ModifyFormation(self.__fmtData, nil, true)
  end
  self._fmtIsChange = true
  ;
  (self.__enterFmtData):SetFmtId(fmtId)
  local isReGenFixedFmt = (self.__enterFmtData):TryReGenFixedFmtData(index)
  self:__RegularSupportHeroData(self.__realFmtData)
  self:GenFormationData()
  self:__RegularSupportHeroData(self.__realFmtData)
  self.__fmtData = (self.__realFmtData):DeepCopyFmtData()
  self:_RegularHeroNumLimit()
  if isReGenFixedFmt then
    (self.fmtSceneCtrl):RefreshFmtPlatformIsBanned()
  end
  ;
  (self.__fmtUI2D):RefreshAllUIAboutFmtData()
  ;
  (self.fmtSceneCtrl):RefreshFmtScene(true)
end

FormationController._RegularHeroNumLimit = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local limitHeroNum = (self.__enterFmtData):GetFmtLimitHeroNum()
  if limitHeroNum <= 0 then
    return 
  end
  local isChange = false
  local heroIdxDic = (self.__fmtData):GetFormationHeroDic()
  for idx,heroId in pairs(heroIdxDic) do
    if (self.__enterFmtData):IsFmtPlatformBan(idx) then
      (self.__fmtData):SetHero2Formation(idx, nil)
      isChange = true
    end
  end
  if isChange then
    self:ModifyFormation(self.__fmtData, nil, true)
  end
end

FormationController.__RegularSupportHeroData = function(self, fmtData)
  -- function num : 0_23 , upvalues : FormationUtil
  if (self.__enterFmtData):IsFmtInBattleDeploy() then
    local cacheSupportHeroData = self:GetCacheSelectedSupportHero()
    local curSupportHeroData = (fmtData:GetRealSupportHeroData())
    local cacheHeroUserId = nil
    if cacheSupportHeroData ~= nil and cacheSupportHeroData:GetUserInfo() ~= nil then
      cacheHeroUserId = (cacheSupportHeroData:GetUserInfo()):GetUserUID()
    end
    local curHeroUserId = nil
    if curSupportHeroData ~= nil and curSupportHeroData:GetUserInfo() ~= nil then
      curHeroUserId = (curSupportHeroData:GetUserInfo()):GetUserUID()
    end
    if (curSupportHeroData ~= nil and cacheSupportHeroData ~= nil and curSupportHeroData.dataId ~= cacheSupportHeroData.dataId) or cacheHeroUserId ~= curHeroUserId and cacheHeroUserId ~= nil and curHeroUserId ~= nil then
      fmtData:CleanSupportData()
      if self.__fmtUI2D ~= nil then
        (self.__fmtUI2D):RefreshFmtItemPow(fmtData)
      end
    end
  else
    do
      if fmtData.isHaveSupport then
        fmtData:CleanSupportData()
        if self.__fmtUI2D ~= nil then
          (self.__fmtUI2D):RefreshFmtItemPow(fmtData)
        end
      end
      local officialSupportCfgId = (self.__enterFmtData):GetOfficialSupportCfgId()
      ;
      (FormationUtil.TryCleanIllegalOfficialSupportData)(officialSupportCfgId, fmtData)
    end
  end
end

FormationController.GetLowerEfficiencyTip = function(self, stageId)
  -- function num : 0_24 , upvalues : _ENV, FmtEnum
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg then
    local sectorStage = stageCfg.sector
    local actType, actId, actData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(sectorStage)
    if (FmtEnum.eFmtSpecialSectorTip)[sectorStage] and actData and sectorStage == (FmtEnum.eFmtSpecialSector).Copley then
      return ConfigData:GetTipContent(((FmtEnum.eFmtSpecialSectorTip)[sectorStage])[1])
    end
  end
  do
    return ConfigData:GetTipContent(388)
  end
end

FormationController.GetFmtCtrlFmtData = function(self)
  -- function num : 0_25
  return self.__fmtData
end

FormationController.GetFmtCtrlFmtCSTData = function(self)
  -- function num : 0_26
  local isVirtual = (self.__enterFmtData):IsFmtCtrlVirtualFmtData()
  do
    if isVirtual then
      local virtualFmtData = (self.__enterFmtData):GetFmtCtrlVirtualFmtData()
      return virtualFmtData:GetVirFmtCstData()
    end
    return (self.__fmtData):GetFmtCSTData()
  end
end

FormationController.SetFmtChallengeMode = function(self, isChallengeMode, witchChallengeInfo, callback)
  -- function num : 0_27 , upvalues : _ENV
  local stageId = (self.__enterFmtData):GetFmtCtrlFmtIdStageId()
  if not (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskOpen(stageId) then
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_27_0 , upvalues : _ENV, stageId
    if win == nil then
      return 
    end
    local msg = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskOpenDes(stageId)
    win:ShowTextBoxWithConfirm(msg, nil)
  end
)
    return 
  end
  local stgChallengeData = (self.__enterFmtData):GetFmtChallengeModeData()
  local challengeModeFunc = (self.__enterFmtData):GetFmtChallengeModeChangeFunc()
  local changeModeFunc = function()
    -- function num : 0_27_1 , upvalues : stgChallengeData, isChallengeMode, callback, challengeModeFunc, self
    stgChallengeData:SetStageChallengeOpen(isChallengeMode)
    if callback ~= nil then
      callback()
    end
    if challengeModeFunc ~= nil then
      challengeModeFunc(isChallengeMode)
    end
    ;
    (self.__fmtData):CleanSupportData()
    ;
    (self.fmtSceneCtrl):RefreshFmtScene()
  end

  if isChallengeMode and witchChallengeInfo then
    UIManager:ShowWindowAsync(UIWindowTypeID.FmtChallengeInfo, function(win)
    -- function num : 0_27_2 , upvalues : stgChallengeData, changeModeFunc
    if win == nil then
      return 
    end
    win:InitFmtChallengeInfo(stgChallengeData, changeModeFunc)
  end
)
  else
    changeModeFunc()
  end
end

FormationController.CalculatePower = function(self, formationData)
  -- function num : 0_28 , upvalues : _ENV
  local totalFtPower = 0
  local totalBenchPower = 0
  local heroPower = 0
  local top5Total = 0
  local heroTotalList = {}
  local campCountDic = (table.GetDefaulValueTable)(0)
  for index,heroId in pairs(formationData:GetFormationHeroDic()) do
    if not (self.__enterFmtData):IsFmtPlatformBan(index) then
      local heroData = nil
      if (self.__enterFmtData):IsFmtCtrlVirtualFmtData() then
        local specialRuleGenerator = (self.__enterFmtData):GetFmtCtrlSpecialRuleGenerator()
        heroData = specialRuleGenerator:GetSpecificHeroData(heroId)
      else
        do
          heroData = formationData:GetFormationHeroData(index)
          do
            if heroData ~= nil then
              local campId = heroData.camp
              campCountDic[campId] = campCountDic[campId] + 1
              heroPower = heroData:GetFightingPower()
              if heroPower ~= 0 then
                (table.insert)(heroTotalList, heroPower)
              end
              if (self.__enterFmtData):GetFormationMaxStageNum() < index then
                totalBenchPower = heroPower + totalBenchPower
              else
                totalFtPower = heroPower + totalFtPower
              end
            end
            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  ;
  (table.sort)(heroTotalList, function(a, b)
    -- function num : 0_28_0
    do return b < a end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  for i = 1, #heroTotalList do
    if i <= 5 then
      do
        top5Total = top5Total + heroTotalList[i]
        -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  local commanderPowerTab = {power = totalFtPower}
  local dynPlayerFtPower = (ConfigData.GetFormulaValue)(eFormulaType.Commander, commanderPowerTab)
  dynPlayerFtPower = (math.floor)(dynPlayerFtPower)
  totalFtPower = totalFtPower + dynPlayerFtPower
  top5Total = top5Total + dynPlayerFtPower
  totalFtPower = (math.max)(totalFtPower, 0)
  totalBenchPower = (math.max)(totalBenchPower, 0)
  top5Total = (math.max)(top5Total, 0)
  return totalFtPower, totalBenchPower, campCountDic, top5Total
end

FormationController.GetFmtCtrlResloader = function(self)
  -- function num : 0_29
  return self.resloader
end

FormationController.EnableMainCamAndLight = function(self, enable)
  -- function num : 0_30 , upvalues : _ENV
  if not IsNull(self.__mainCam) then
    ((self.__mainCam).gameObject):SetActive(enable)
  end
  if not IsNull(self.__lightMain) then
    (self.__lightMain):SetActive(enable)
  end
end

FormationController.OnEnterFormationScene = function(self)
  -- function num : 0_31 , upvalues : CS_Input
  self:EnableMainCamAndLight(false)
  self.__multiTouchEnabledBeforeOpen = CS_Input.multiTouchEnabled
  CS_Input.multiTouchEnabled = false
end

FormationController.OnLeaveFormationScene = function(self)
  -- function num : 0_32 , upvalues : CS_Input
  self:EnableMainCamAndLight(true)
  CS_Input.multiTouchEnabled = self.__multiTouchEnabledBeforeOpen
end

FormationController.OnFmtOpenCSTUI = function(self)
  -- function num : 0_33
  (self.fmtSceneCtrl):SetFormationCameraActive(false)
  ;
  (self.__fmtUI2D):Hide()
end

FormationController.OnFmtCloseCSTUI = function(self)
  -- function num : 0_34
  (self.fmtSceneCtrl):SetFormationCameraActive(true)
  ;
  (self.__fmtUI2D):Show()
end

FormationController.SaveFmtCSTChange = function(self, saveData, callback)
  -- function num : 0_35 , upvalues : _ENV, FormationUtil
  local CSTNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.CommanderSkill)
  if CSTNetCtrl == nil then
    return 
  end
  local oldCstData = self:GetFmtCtrlFmtCSTData()
  if not (FormationUtil.CheckCmdSkillChange)(oldCstData, saveData) then
    return 
  end
  local isVirtual = (self.__enterFmtData):IsFmtCtrlVirtualFmtData()
  if isVirtual then
    local virtualFmtData = (self.__enterFmtData):GetFmtCtrlVirtualFmtData()
    virtualFmtData:SetCst(saveData)
    CSTNetCtrl:CS_COMMANDSKILL_FreshSavingTree(saveData.treeId, saveData:GetUsingCmdSkillList(), function()
    -- function num : 0_35_0 , upvalues : self, _ENV, saveData
    local _, wcType = (self.__enterFmtData):IsWCFormation()
    ;
    (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetLastWeeklySkillList(wcType, saveData.treeId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  end
)
  else
    do
      CSTNetCtrl:CS_COMMANDSKILL_SaveFromFormation((self.__fmtData).id, saveData.treeId, saveData:GetUsingCmdSkillList(), function()
    -- function num : 0_35_1 , upvalues : self
    self._fmtCommanderskillChange = true
    self._fmtIsChange = true
  end
)
    end
  end
end

FormationController.OnCommendSkillChange = function(self)
  -- function num : 0_36
  if self.__fmtData == nil then
    return 
  end
  ;
  (self.__fmtData):CopyCST(self.__realFmtData)
  if self.__fmtUI2D ~= nil then
    (self.__fmtUI2D):RefreshFmtCST()
  end
end

FormationController.TryFixFormatoionCST = function(self, conditionId)
  -- function num : 0_37 , upvalues : CheckerTypeId, _ENV
  if conditionId ~= CheckerTypeId.CompleteStage then
    return 
  end
  if not self:CheckAndSyncIllegalCST() then
    return 
  end
  local cstCtrl = ControllerManager:GetController(ControllerTypeId.CommanderSkill)
  if cstCtrl ~= nil then
    cstCtrl:RefreshCmdSkillCtrl((self.__realFmtData):GetFmtCSTData())
  end
  MsgCenter:Broadcast(eMsgEventId.OnCommanderSkillChande)
end

FormationController.CheckAndSyncIllegalCST = function(self)
  -- function num : 0_38 , upvalues : _ENV
  if not (self.__realFmtData):IsIllegalCST(true) then
    return false
  end
  if (self.__enterFmtData):IsFmtCtrlVirtualFmtData() then
    return false
  end
  local cmdSkillData = (self.__realFmtData):GetFmtCSTData()
  local treeId = cmdSkillData.treeId
  local skills = cmdSkillData:GetUsingCmdSkillList()
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.CommanderSkill)):CS_COMMANDSKILL_SaveFromFormation((self.__realFmtData).id, treeId, skills)
  return true
end

FormationController.OnFmtCtrlSelectWCDebuffOver = function(self)
  -- function num : 0_39
  (self.__fmtUI2D):RefreshFmtPower()
end

FormationController.OnFmtCtrlUpdateWCDebuffSelect = function(self, buffIds)
  -- function num : 0_40
  local virtualFmtData = (self.__enterFmtData):GetFmtCtrlVirtualFmtData()
  if virtualFmtData ~= nil then
    if not buffIds then
      virtualFmtData:SetBuffList({})
      local fmtBuffSelect = (self.__enterFmtData):GetPeridicFmtBuffSelect()
      if fmtBuffSelect == nil then
        return 
      end
      fmtBuffSelect:SetFmtBuffSelect(buffIds)
      local permillageAll = fmtBuffSelect:GetFmtBuffCurAddScoreRate()
      local warningTipValue = fmtBuffSelect:GetBuffScoreWarningValue(1)
      ;
      (self.fmtSceneCtrl):SetWarningTipState(warningTipValue <= permillageAll)
      -- DECOMPILER ERROR: 1 unprocessed JMP targets
    end
  end
end

FormationController.TryUpdateSupporeDatas = function(self)
  -- function num : 0_41 , upvalues : _ENV
  local supportHeroData = (self.__fmtData):GetRealSupportHeroData()
  local selectedSupportHero = false
  if (((self.__fmtUI2D).editNode).supportHero).heroData == nil then
    selectedSupportHero = (self.__fmtUI2D).editNode == nil
    if supportHeroData == nil and not selectedSupportHero then
      return 
    end
    local fixCfg = (PlayerDataCenter.supportHeroData):GetCurFormationLevelEffectByAllHero(PlayerDataCenter.heroDic)
    if fixCfg ~= self.__caheFixCfg then
      self.__caheFixCfg = fixCfg
      if supportHeroData ~= nil then
        supportHeroData:UseFixCfg2ChangeSupportorAttr(fixCfg)
      end
      if selectedSupportHero then
        (((self.__fmtUI2D).editNode).supportHero):UpdateFixCfg(fixCfg)
      end
    end
    local supportHeroData = (self.__fmtData):GetSupportHeroData()
    if supportHeroData ~= nil then
      (self.fmtSceneCtrl):RefreshSupportHeroInfo(supportHeroData.formIdx)
    end
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

FormationController.CacheStrangerSupportHeroDic = function(self, allSupportHeroDataDic, nextRefreshTm, friendsBanData, userInfoDic, assistHeroTime)
  -- function num : 0_42 , upvalues : _ENV
  (PlayerDataCenter.supportHeroData):SetCachedSupportData(allSupportHeroDataDic, nextRefreshTm, friendsBanData, userInfoDic, assistHeroTime)
  if self.__selectedSupportHero ~= nil then
    local uid = ((self.__selectedSupportHero):GetUserInfo()):GetUserUID()
    local heroId = (self.__selectedSupportHero).dataId
    if allSupportHeroDataDic[uid] == nil or (allSupportHeroDataDic[uid])[heroId] == nil then
      self:CacheSelectedSupportHero(nil)
      ;
      (self.__fmtData):CleanSupportData()
      if self:IsFmtCtrlInEditState() then
        ((self.__fmtUI2D).editNode):ClearSupportCard()
      end
    end
  end
end

FormationController.GetStrangerSupportHeroDic = function(self)
  -- function num : 0_43 , upvalues : _ENV
  return (PlayerDataCenter.supportHeroData):GetCachedSupportData()
end

FormationController.CacheSelectedSupportHero = function(self, supportHeroData)
  -- function num : 0_44 , upvalues : _ENV
  if (self.__enterFmtData):IsFmtInBattleDeploy() then
    (PlayerDataCenter.dungeonDyncData):CacheDgFmtFriendSupportHeroData(supportHeroData)
  end
  self.__selectedSupportHero = supportHeroData
end

FormationController.GetCacheSelectedSupportHero = function(self)
  -- function num : 0_45 , upvalues : _ENV
  if (self.__enterFmtData):IsFmtInBattleDeploy() then
    return (PlayerDataCenter.dungeonDyncData):GetDgFmtFriendSupportHeroDataCache()
  end
  return self.__selectedSupportHero
end

FormationController.ShowQuickFormation = function(self, heroData)
  -- function num : 0_46 , upvalues : FmtEnum, _ENV
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).editing
  UIManager:ShowWindowAsync(UIWindowTypeID.FormationQuick, function(window)
    -- function num : 0_46_0 , upvalues : self, heroData
    if window ~= nil then
      (self.fmtSceneCtrl):SetFormationCameraActive(false)
      ;
      (self.__fmtUI2D):Hide()
      window:OpenFQCampInfluence((self.__enterFmtData):GetIsOpenedCampInfluence())
      window:InitQuickFmt(self.__fmtData, self, heroData, (self.__enterFmtData):GetFmtCtrlSpecialRuleGenerator())
    end
  end
)
end

FormationController.ExitQuickFormation = function(self, isFmtChanged)
  -- function num : 0_47 , upvalues : _ENV, FmtEnum
  (self.fmtSceneCtrl):SetFormationCameraActive(true)
  UIManager:DeleteWindow(UIWindowTypeID.FormationQuick)
  ;
  (self.__fmtUI2D):Show()
  if isFmtChanged then
    (self.__fmtUI2D):RefreshAllUIAboutFmtData()
    ;
    (self.fmtSceneCtrl):RefreshFmtScene(true)
  end
  self.__fmtCtrlState = (FmtEnum.FmtCtrlSate).normal
end

FormationController.ShowHeroState = function(self, heroData, heroDataList)
  -- function num : 0_48 , upvalues : _ENV
  if heroData == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroState, function(win)
    -- function num : 0_48_0 , upvalues : heroData, heroDataList, self
    if win ~= nil then
      win:InitHeroState(heroData, heroDataList, function()
      -- function num : 0_48_0_0 , upvalues : self
      (self.fmtSceneCtrl):RefreshFmtPlatUIAll()
    end
)
    end
  end
)
end

FormationController.ReqFmtHeroLvUp = function(self, fmtIdx, heroId, targetLevel, notNeedFx)
  -- function num : 0_49 , upvalues : _ENV
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData ~= nil then
    local isCanLevelUp = heroData:GenHeroCanQuickLevelUp()
    if isCanLevelUp then
      (self.heroNetwork):CS_HERO_Upgrade(heroId, targetLevel, function()
    -- function num : 0_49_0 , upvalues : notNeedFx, self, fmtIdx, heroData, _ENV
    if not notNeedFx then
      (self.fmtSceneCtrl):ShowHeroQuickLvUpEffect(fmtIdx)
    end
    ;
    (self.fmtSceneCtrl):RefreshAllQuickLevel()
    ;
    (self.__fmtUI2D):UpdateFmtHeroInfo(heroData)
    AudioManager:PlayAudioById(1126)
    GuideManager:TryTriggerGuide(eGuideCondition.InFormationSpecial)
  end
)
    end
  end
end

FormationController._OnUpdateHero = function(self, heroUpdateIdDic)
  -- function num : 0_50 , upvalues : _ENV
  for heroId,v in pairs(heroUpdateIdDic) do
    self:__FormationHeroChange(heroId)
  end
  ;
  (self.fmtSceneCtrl):OnUpdateHero(heroUpdateIdDic)
  if self.__fmtUI2D ~= nil then
    (self.__fmtUI2D):TryRefreshHeroCards(heroUpdateIdDic, false)
  end
end

FormationController._OnFmtHeroSkinChange = function(self, heroId, skinId)
  -- function num : 0_51
  (self.fmtSceneCtrl):OnSkinChange(heroId, skinId)
  if self.__fmtUI2D ~= nil then
    (self.__fmtUI2D):TryRefreshHeroCards({[heroId] = true}, true)
  end
end

FormationController.__FormationHeroChange = function(self, heroId)
  -- function num : 0_52
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._heroChangedIdDic)[heroId] = true
  self._fmtIsChange = true
end

FormationController.ExitFormation = function(self)
  -- function num : 0_53 , upvalues : _ENV
  local mustInBattle = (self.__enterFmtData):IsFmtInBattleDeploy(true)
  if mustInBattle and self._fmtIsChange then
    local heroChangedIdDic = {}
    for index,heroId in pairs((self.__fmtData).data) do
      if (self._heroChangedIdDic)[heroId] then
        heroChangedIdDic[heroId] = true
      end
    end
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)):CS_BATTLE_FormationFresh(self.__fmtData, self._fmtCommanderskillChange, heroChangedIdDic, function(objList)
    -- function num : 0_53_0 , upvalues : self
    self:_OnBattleFmtChange(objList)
  end
)
  else
    do
      self:RealExitFormation()
    end
  end
end

FormationController.RealExitFormation = function(self)
  -- function num : 0_54
  local exitFunc = (self.__enterFmtData):GetFmtCtrlExitFunc()
  if exitFunc ~= nil then
    exitFunc((self.__fmtData).id)
  end
  self:Delete()
  self:OnLeaveFormationScene()
end

FormationController._OnBattleFmtChange = function(self, objList)
  -- function num : 0_55 , upvalues : _ENV
  if objList.Count ~= 1 then
    error("objList.Count error:" .. tostring(objList.Count))
    return 
  end
  local msg = objList[0]
  local curBattleSceneCtrl = (BattleUtil.GetCurSceneCtrl)()
  local dynPlayer = ((BattleUtil.GetCurDynPlayer)())
  local treeId = nil
  if self.__fmtData ~= nil then
    treeId = (self.__fmtData).cstId
  end
  dynPlayer:InitPlayerSkill(msg.commandSkill, treeId)
  local addHeroList, newHeroList, removeHeroList = dynPlayer:ChangeDynPlayerHeroList((msg.roleSync).enter, (msg.roleSync).quit, (msg.roleSync).change)
  ;
  (UIUtil.AddOneCover)("_OnBattleFmtChange", SafePack(nil, nil, nil, Color.clear, false))
  local epWindow = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if epWindow ~= nil then
    epWindow:ReInitDungeonHeroList(dynPlayer)
  end
  curBattleSceneCtrl:ChangeEpHeroModel(removeHeroList, addHeroList, function()
    -- function num : 0_55_0 , upvalues : _ENV, self
    (UIUtil.CloseOneCover)("_OnBattleFmtChange")
    self:RealExitFormation()
  end
)
end

FormationController.CheckFormationHero = function(self, newHeroDic)
  -- function num : 0_56 , upvalues : _ENV
  local posMax = ConfigData:GetFormationHeroCount()
  for pos,_ in pairs(newHeroDic) do
    if posMax < pos then
      error("formation error")
      return false
    end
  end
  return true
end

FormationController.UpdateFormationHero = function(self, newHeroDic)
  -- function num : 0_57 , upvalues : _ENV
  if newHeroDic == nil then
    return false
  end
  if not self:CheckFormationHero(newHeroDic) then
    return false
  end
  local isChange = false
  local oldHeroDic = (self.__fmtData):GetFormationHeroDic()
  if (table.count)(newHeroDic) == (table.count)(oldHeroDic) then
    for key,value in pairs(newHeroDic) do
      if value ~= oldHeroDic[key] then
        isChange = true
        break
      end
    end
  else
    do
      isChange = true
      if isChange then
        self:ModifyFormation(nil, newHeroDic, true)
        ;
        (self.__fmtUI2D):RefreshUIAboutCurFmtDat()
        ;
        (self.fmtSceneCtrl):RefreshFmtScene(self.curFormation)
      end
      return isChange
    end
  end
end

FormationController.OnDelete = function(self)
  -- function num : 0_58 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__TryFixFormatoionCST)
  MsgCenter:RemoveListener(eMsgEventId.OnSupportHoreNeedFresh, self._TryUpdateSupporeDatas)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__UpdateHeroForFmtInfo)
  MsgCenter:RemoveListener(eMsgEventId.OnHeroAthChange, self.__FormationHeroChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.HeroTalentLvUp, self.__FormationHeroChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.OnCommanderSkillChande, self.__OnCommendSkillChange)
  MsgCenter:RemoveListener(eMsgEventId.OnHeroSkinChange, self.__OnFmtHeroSkinChange)
  ;
  (UIUtil.CloseAllCover)()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.__initCoroutine ~= nil then
    (GR.StopCoroutine)(self.__initCoroutine)
  end
  for _,ctrl in pairs(self.ctrls) do
    ctrl:OnDelete()
  end
  ;
  (base.OnDelete)(self)
end

return FormationController

