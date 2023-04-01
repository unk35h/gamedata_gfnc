-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelDtail = class("UINLevelDtail", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
local cs_UIMnager = CS.UIManager
local cs_Screen = (CS.UnityEngine).Screen
local UINLevelInfgoTypeTog = require("Game.Sector.SectorLevelDetail.UINLevelInfgoTypeTog")
local UINLevelNormalNode = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelNormalNode")
local UINLevelChipNode = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelChipNode")
local UINLevelEnemyNode = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelEnemyNode")
local ChipData = require("Game.PlayerData.Item.ChipData")
local UINStOUnlockConditionItem = require("Game.StrategyOverview.UI.Side.UINStOUnlockConditionItem")
local StageChallengeData = require("Game.StageChallenge.Data.StageChallengeData")
local SectorEnum = require("Game.Sector.SectorEnum")
local FmtEnum = require("Game.Formation.FmtEnum")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local eDetailType = SectorLevelDetailEnum.eDetailType
local eInfoNodeType = SectorLevelDetailEnum.eInfoNodeType
local eTogType = SectorLevelDetailEnum.eTogType
local SpecificHeroDataRuler = require("Game.PlayerData.Hero.SpecificHeroDataRuler")
local util = require("XLua.Common.xlua_util")
local JumpManager = require("Game.Jump.JumpManager")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local PeridicChallengeEnum = require("Game.PeriodicChallenge.PeridicChallengeEnum")
local UINWeeklyChallengeScoreIntro = require("Game.WeeklyChallenge.UINWeeklyChallengeScoreIntro")
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINLevelDtail.OnInit = function(self)
  -- function num : 0_0 , upvalues : eDetailType, _ENV, UINWeeklyChallengeScoreIntro, UINCommonSwitchToggle, UINLevelInfgoTypeTog, UINLevelNormalNode, UINLevelChipNode, UINLevelEnemyNode, eInfoNodeType, UINStOUnlockConditionItem, cs_UIMnager, cs_Screen
  self.detailType = eDetailType.None
  self.__couldNotStatrBattle = false
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.OnClickBattle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GiveUP, self, self.OnCliCkGiveUpLastEp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ViewAvg, self, self.OnCliCkViewAvg)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Blitz, self, self.OnBtnBlitz)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Recomme, self, self.OnClickRecomme)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Challenge, self, self._OnClickChallenge)
  self.weeklyChallengeScoreIntro = (UINWeeklyChallengeScoreIntro.New)()
  ;
  (self.weeklyChallengeScoreIntro):Init((self.ui).logicPreviewNode)
  self._switchChallengeTog = (UINCommonSwitchToggle.New)()
  ;
  (self._switchChallengeTog):Init((self.ui).tog_SwitchChallenge)
  ;
  (self._switchChallengeTog):CommonSwitchTogAutoSetValue(false)
  self._changeChallengeFunc = BindCallback(self, self._OnClickChallengeModeTog)
  self.typeTogPool = (UIItemPool.New)(UINLevelInfgoTypeTog, (self.ui).obj_tog_Type)
  ;
  ((self.ui).obj_tog_Type):SetActive(false)
  self:_ResetInit()
  local NormalInfoNode = (UINLevelNormalNode.New)()
  NormalInfoNode:Init((self.ui).obj_normalNode)
  local ChipInfoNode = (UINLevelChipNode.New)()
  ChipInfoNode:Init((self.ui).obj_chipNode)
  local EnemyInfoNode = (UINLevelEnemyNode.New)()
  EnemyInfoNode:Init((self.ui).obj_enemyNode)
  self.NodeDic = {[eInfoNodeType.LevelNormalInfo] = NormalInfoNode, [eInfoNodeType.LevelChips] = ChipInfoNode, [eInfoNodeType.LevelEnemies] = EnemyInfoNode}
  self.SelectedNode = nil
  self:GenTypeTogs()
  self.__onHasUncompletedEp = BindCallback(self, self.UpdateUncompletedEp)
  ;
  ((self.ui).conditionItem):SetActive(false)
  self.conditionItemPool = (UIItemPool.New)(UINStOUnlockConditionItem, (self.ui).conditionItem)
  ;
  (((self.ui).moveTween).onComplete):AddListener(BindCallback(self, self.__OnMoveTweenComplete))
  ;
  (((self.ui).moveTween).onRewind):AddListener(BindCallback(self, self.__OnMoveTweenRewind))
  local position = Vector2.zero
  position.x = ((((self.ui).moveTween).transform).sizeDelta).x + (cs_UIMnager.Instance).CurNotchValue / 100 * cs_Screen.width
  -- DECOMPILER ERROR at PC170: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).moveTween).transform).anchoredPosition = position
  self.__isShow = false
  self.__OnChipSetUpdate = BindCallback(self, self.OnChipSetUpdate)
  self:SetLevelDetailActIsFinishUI(false)
end

UINLevelDtail.InitLevelDtail = function(self, resloader)
  -- function num : 0_1
  self.__resloader = resloader
end

UINLevelDtail._ResetInit = function(self)
  -- function num : 0_2
  ((self.ui).obj_ChallengeNode):SetActive(false)
end

UINLevelDtail.InitLevelDetailNode = function(self, sectorStageCfg, sectorId, isLocked)
  -- function num : 0_3 , upvalues : eDetailType, _ENV
  self.detailType = eDetailType.Stage
  self:__InitLevelDetailNode(sectorStageCfg, sectorId, isLocked)
  local recommeCtrl = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(recommeCtrl:IsCanReqRecomme((self.stageCfg).id, false))
end

UINLevelDtail.__InitLevelDetailNode = function(self, sectorStageCfg, sectorId, isLocked)
  -- function num : 0_4 , upvalues : _ENV, eInfoNodeType
  self.sectorId = sectorId
  self.isLocked = isLocked
  self.stageCfg = sectorStageCfg
  self.challengeId = (self.stageCfg).id
  ;
  ((self.ui).tex_Point):SetIndex(0, tostring((self.stageCfg).cost_strength_num))
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring((self.stageCfg).combat)
  do
    if not isLocked then
      local costId = sectorStageCfg.cost_strength_id
      -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).img_Ticket).sprite = CRH:GetSpriteByItemId(costId, true)
    end
    ;
    (((self.ui).btn_Blitz).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Battle).gameObject):SetActive(not isLocked)
    ;
    ((self.ui).unlockCondition):SetActive(isLocked)
    ;
    (((self.ui).btn_ViewAvg).gameObject):SetActive(false)
    ;
    ((self.ui).obj_togGroup):SetActive(true)
    ;
    ((self.ui).obj_Power):SetActive(true)
    self:_ResetInit()
    self:PlayMoveTween(true)
    self:UpdateUncompletedEp()
    self:SelectDefaultTog(eInfoNodeType.LevelNormalInfo)
    self:InitChipDataQualityDic(self.detailType)
    self:SendChipSet()
    ;
    (((self.ui).logicPreviewNode).gameObject):SetActive(false)
    if isLocked then
      self:_UpdUnlockCondition(sectorStageCfg.pre_condition, sectorStageCfg.pre_para1, sectorStageCfg.pre_para2)
    end
    self:_InitChallengeMode()
  end
end

UINLevelDtail.InitAvgDetail = function(self, avgCfg, playAvgCompleteFunc, sectorId, isLocked)
  -- function num : 0_5 , upvalues : eDetailType, eInfoNodeType
  self.detailType = eDetailType.Avg
  self.avgCfg = avgCfg
  self.sectorId = sectorId
  self.playAvgCompleteFunc = playAvgCompleteFunc
  ;
  (((self.ui).btn_Blitz).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Battle).gameObject):SetActive(false)
  ;
  ((self.ui).unlockCondition):SetActive(false)
  ;
  (((self.ui).btn_GiveUP).gameObject):SetActive(false)
  ;
  (((self.ui).btn_ViewAvg).gameObject):SetActive(not isLocked)
  ;
  ((self.ui).obj_togGroup):SetActive(false)
  ;
  ((self.ui).obj_Power):SetActive(false)
  self:_ResetInit()
  self:PlayMoveTween(true)
  self:ShowNode(eInfoNodeType.LevelNormalInfo)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(false)
  ;
  (((self.ui).logicPreviewNode).gameObject):SetActive(false)
end

UINLevelDtail.InitInfinityLevelDetailNode = function(self, levelData, sectorId)
  -- function num : 0_6 , upvalues : eDetailType, _ENV, eInfoNodeType
  self.detailType = eDetailType.Infinity
  self.levelData = levelData
  self.challengeId = (levelData.cfg).id
  self.sectorId = sectorId
  ;
  ((self.ui).tex_Point):SetIndex(0, tostring(((levelData.cfg).cost_strength_itemNums)[1]))
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring((levelData.cfg).combat)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite()
  ;
  (((self.ui).btn_Blitz).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Battle).gameObject):SetActive(true)
  ;
  ((self.ui).unlockCondition):SetActive(false)
  ;
  (((self.ui).btn_ViewAvg).gameObject):SetActive(false)
  ;
  ((self.ui).obj_togGroup):SetActive(true)
  ;
  ((self.ui).obj_Power):SetActive(true)
  self:_ResetInit()
  self:PlayMoveTween(true)
  self:UpdateUncompletedEp()
  self:SelectDefaultTog(eInfoNodeType.LevelNormalInfo)
  self:InitChipDataQualityDic(self.detailType)
  self:SendChipSet()
  local recommeCtrl = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(recommeCtrl:IsCanReqRecomme(((self.levelData).cfg).id, false))
  ;
  (((self.ui).logicPreviewNode).gameObject):SetActive(false)
end

UINLevelDtail.InitPeriodicChallengeDetailNode = function(self, challengeId, eChallengeType)
  -- function num : 0_7 , upvalues : eDetailType, eInfoNodeType
  self.detailType = eDetailType.PeriodicChallenge
  self.sectorId = challengeId
  self.challengeId = challengeId
  self.eChallengeType = eChallengeType
  self:PlayMoveTween(true)
  self:UpdateUncompletedEp()
  self:SelectDefaultTog(eInfoNodeType.LevelNormalInfo)
  self:InitChipDataQualityDic(self.detailType)
  self:SendChipSet()
  ;
  ((self.ui).tex_Point):SetIndex(0, "0")
  ;
  ((self.ui).obj_RecommendPower):SetActive(false)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(false)
  ;
  (((self.ui).logicPreviewNode).gameObject):SetActive(false)
end

UINLevelDtail.InitWeeklyChallengeDetailNode = function(self, challengeId, isLocked)
  -- function num : 0_8 , upvalues : eDetailType, _ENV, eInfoNodeType
  self.detailType = eDetailType.WeeklyChallenge
  self.sectorId = challengeId
  self.challengeId = challengeId
  self:PlayMoveTween(true)
  if isLocked then
    (((self.ui).btn_Blitz).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Battle).gameObject):SetActive(false)
    ;
    ((self.ui).unlockCondition):SetActive(false)
    ;
    (((self.ui).btn_ViewAvg).gameObject):SetActive(false)
    ;
    (((self.ui).btn_GiveUP).gameObject):SetActive(false)
  else
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite()
    ;
    (((self.ui).btn_Blitz).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Battle).gameObject):SetActive(true)
    ;
    (((self.ui).btn_ViewAvg).gameObject):SetActive(false)
    ;
    (((self.ui).btn_GiveUP).gameObject):SetActive(false)
    self:UpdateUncompletedEp()
  end
  self:SelectDefaultTog(eInfoNodeType.LevelNormalInfo)
  self:InitChipDataQualityDic(self.detailType)
  self:SendChipSet()
  ;
  ((self.ui).tex_Point):SetIndex(0, "0")
  ;
  ((self.ui).obj_RecommendPower):SetActive(false)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(false)
  ;
  (((self.ui).logicPreviewNode).gameObject):SetActive(false)
end

UINLevelDtail.InitWarchessDetailNode = function(self, sectorId, sectroCfg, isLock)
  -- function num : 0_9 , upvalues : eDetailType
  self.detailType = eDetailType.Warchess
  self:__InitLevelDetailNode(sectroCfg, sectorId, isLock)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(false)
end

UINLevelDtail.SetLevelDetailActIsFinishUI = function(self, active)
  -- function num : 0_10
  ((self.ui).obj_btnGroup):SetActive(not active)
  ;
  ((self.ui).obj_isActFinished):SetActive(active)
end

UINLevelDtail.GenTypeTogs = function(self)
  -- function num : 0_11 , upvalues : _ENV, eTogType
  (self.typeTogPool):HideAll()
  for index,infoNodeTypeId in ipairs(eTogType) do
    do
      local togItem = (self.typeTogPool):GetOne()
      local isLast = index == #eTogType
      togItem:InitTog(infoNodeTypeId, isLast, function()
    -- function num : 0_11_0 , upvalues : self, infoNodeTypeId, isLast
    self:ShowNode(infoNodeTypeId)
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R0 in 'UnsetPending'

    if isLast then
      ((self.ui).img_lastTog).color = (self.ui).color_white
    else
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.ui).img_lastTog).color = (self.ui).color_black
    end
  end
)
    end
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINLevelDtail.SelectDefaultTog = function(self, infoNodeTypeId)
  -- function num : 0_12 , upvalues : _ENV
  for _,item in ipairs((self.typeTogPool).listItem) do
    if item.infoNodeTypeId == infoNodeTypeId then
      if ((item.ui).tog_Type).isOn then
        self:ShowNode(infoNodeTypeId)
        break
      end
      -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((item.ui).tog_Type).isOn = true
      break
    end
  end
end

UINLevelDtail.ShowNode = function(self, infoNodeTypeId)
  -- function num : 0_13 , upvalues : _ENV
  for typeId,NodeItem in pairs(self.NodeDic) do
    if infoNodeTypeId == typeId then
      NodeItem:Show()
      NodeItem:InitInfoNode(self, self.chipDataQualityDic, self.__resloader)
      self.SelectedNode = NodeItem
    else
      NodeItem:Hide()
    end
  end
end

UINLevelDtail.RefreshDtailNormalNode = function(self)
  -- function num : 0_14 , upvalues : eInfoNodeType
  local node = (self.NodeDic)[eInfoNodeType.LevelNormalInfo]
  if node ~= nil and node.active then
    node:InitInfoNode(self, self.chipDataQualityDic, self.__resloader)
  end
end

UINLevelDtail.ShowWeeklyScoreIntro = function(self)
  -- function num : 0_15
  (self.weeklyChallengeScoreIntro):Show()
  ;
  (self.weeklyChallengeScoreIntro):InitWeeklyScoreIntro(self.challengeId)
end

UINLevelDtail.InitChipDataQualityDic = function(self, detailType)
  -- function num : 0_16 , upvalues : SectorLevelDetailEnum, _ENV, SectorStageDetailHelper, ChipData
  local moduleId = nil
  if detailType == (SectorLevelDetailEnum.eDetailType).Stage then
    moduleId = proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration
  else
    if detailType == (SectorLevelDetailEnum.eDetailType).Infinity then
      moduleId = proto_csmsg_SystemFunctionID.SystemFunctionID_Endless
    else
      if detailType == (SectorLevelDetailEnum.eDetailType).PeriodicChallenge then
        moduleId = proto_csmsg_SystemFunctionID.SystemFunctionID_DailyChallenge
      else
        if detailType == (SectorLevelDetailEnum.eDetailType).WeeklyChallenge then
          moduleId = proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge
        else
          if detailType == (SectorLevelDetailEnum.eDetailType).Warchess then
            moduleId = proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess
          end
        end
      end
    end
  end
  local chip_dic = (SectorStageDetailHelper.GetChipPreviewByEpModuleId)(moduleId, self.challengeId, self.eChallengeType)
  self.chipDataQualityDic = {}
  local chipData = nil
  for itemId,v in pairs(chip_dic) do
    local level = nil
    if type(v) == "number" then
      level = v
    end
    chipData = (ChipData.NewChipForLocal)(itemId, level)
    if detailType == (SectorLevelDetailEnum.eDetailType).WeeklyChallenge then
      chipData.isLock = false
    else
      chipData.isLock = true
    end
    -- DECOMPILER ERROR at PC76: Confused about usage of register: R11 in 'UnsetPending'

    if (self.chipDataQualityDic)[chipData:GetQuality()] == nil then
      (self.chipDataQualityDic)[chipData:GetQuality()] = {}
      ;
      (table.insert)((self.chipDataQualityDic)[chipData:GetQuality()], chipData)
    else
      ;
      (table.insert)((self.chipDataQualityDic)[chipData:GetQuality()], chipData)
    end
  end
end

UINLevelDtail.OnChipSetUpdate = function(self, chipSetTab)
  -- function num : 0_17 , upvalues : _ENV
  for _,list in pairs(self.chipDataQualityDic) do
    for index,chipData in ipairs(list) do
      if chipSetTab[chipData.dataId] ~= nil then
        chipData.isLock = false
      end
    end
  end
end

UINLevelDtail.SendChipSet = function(self)
  -- function num : 0_18 , upvalues : _ENV
  self.networkContrl = NetworkManager:GetNetwork(NetworkTypeID.Sector)
  ;
  (self.networkContrl):SendChipSet()
end

UINLevelDtail.UpdateUncompletedEp = function(self)
  -- function num : 0_19 , upvalues : eDetailType, SectorStageDetailHelper, _ENV, eInfoNodeType
  if self.detailType ~= eDetailType.Stage and self.detailType ~= eDetailType.Infinity and self.detailType ~= eDetailType.PeriodicChallenge and self.detailType ~= eDetailType.WeeklyChallenge and self.detailType ~= eDetailType.Warchess then
    return 
  end
  self._playMoudle = 0
  if self.detailType == eDetailType.PeriodicChallenge or self.detailType == eDetailType.WeeklyChallenge then
    self._playMoudle = (SectorStageDetailHelper.PlayMoudleType).Ep
  else
    self._playMoudle = (SectorStageDetailHelper.SectorPlayMoudle)(self.sectorId)
  end
  if self._playMoudle == 0 then
    if isGameDev then
      error("playMoudle not find")
    end
    return 
  end
  self.__lastEpStateCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)(self._playMoudle)
  self:RefreshBattleButton()
  self:ShowNode(eInfoNodeType.LevelNormalInfo)
  if self.detailType == eDetailType.Stage or self.detailType == eDetailType.Warchess then
    self:_InitChallengeMode()
  end
end

UINLevelDtail.RefreshEpBattleButton = function(self)
  -- function num : 0_20 , upvalues : _ENV, SectorStageDetailHelper
  ((self.ui).obj_point):SetActive(false)
  if ExplorationManager:WaitGetLastRoomEpRewardBag() then
    (((self.ui).btn_GiveUP).gameObject):SetActive(false)
    ;
    ((self.ui).tex_Battle):SetIndex(3)
  else
    local isUnlockBattleExit = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BattleExit)
    local _, _, _, canFloorOver = (SectorStageDetailHelper.HasUnCompleteStage)(self._playMoudle)
    if isUnlockBattleExit then
      (((self.ui).btn_GiveUP).gameObject):SetActive(not canFloorOver)
      ;
      ((self.ui).tex_Battle):SetIndex(1)
    end
  end
end

UINLevelDtail.RefreshBattleButton = function(self)
  -- function num : 0_21 , upvalues : eDetailType, _ENV, SectorStageDetailHelper
  if self.__lastEpStateCfg == nil then
    (((self.ui).btn_GiveUP).gameObject):SetActive(false)
    ;
    ((self.ui).obj_point):SetActive(true)
    if self.detailType == eDetailType.Infinity then
      local infinittLevelId = ((self.levelData).cfg).id
      if (PlayerDataCenter.infinityData):IsInfinityDungeonCompleted(infinittLevelId) then
        ((self.ui).tex_Battle):SetIndex(2)
        if FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_EndlessAuto) then
          (((self.ui).btn_Blitz).gameObject):SetActive(true)
        end
      else
        if (PlayerDataCenter.infinityData):GetInfinityDungeonProcess(infinittLevelId) ~= nil then
          ((self.ui).tex_Battle):SetIndex(2)
        else
          ;
          ((self.ui).tex_Battle):SetIndex(0)
        end
      end
    else
      do
        ;
        ((self.ui).tex_Battle):SetIndex(0)
        if self._playMoudle == (SectorStageDetailHelper.PlayMoudleType).Ep then
          self:RefreshEpBattleButton()
        else
          if self._playMoudle == (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess then
            local _, _, mouldId, canFloorOver = (SectorStageDetailHelper.HasUnCompleteStage)(self._playMoudle)
            if mouldId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
              self:RefreshEpBattleButton()
            else
              ;
              (((self.ui).btn_GiveUP).gameObject):SetActive(false)
              ;
              ((self.ui).tex_Battle):SetIndex(1)
            end
          else
            do
              ;
              (((self.ui).btn_GiveUP).gameObject):SetActive(false)
              ;
              ((self.ui).tex_Battle):SetIndex(1)
            end
          end
        end
      end
    end
  end
end

UINLevelDtail.OnClickBattle = function(self)
  -- function num : 0_22 , upvalues : _ENV, SectorStageDetailHelper, util
  if self.__couldNotStatrBattle then
    return 
  end
  if self.__lastEpStateCfg ~= nil then
    if ExplorationManager:WaitGetLastRoomEpRewardBag() then
      ExplorationManager:GiveUpLastExploration()
    else
      if self.__customEnterFmtCallback ~= nil then
        (self.__customEnterFmtCallback)(nil)
      end
      if self.__customBattleStartCallback then
        (self.__customBattleStartCallback)()
      end
      ;
      (SectorStageDetailHelper.ContinueUncompleteStage)(self._playMoudle)
    end
    return 
  end
  self._enterFmtCo = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self.__EnterFormationCo)))
end

UINLevelDtail.__EnterFormationCo = function(self)
  -- function num : 0_23 , upvalues : eDetailType, _ENV, SectorEnum
  local waitMsgBox = false
  local staminaOk = true
  local hasShopDrop = false
  if self.detailType == eDetailType.Stage then
    hasShopDrop = (self.stageCfg).hasShopDrop
  else
    if self.detailType == eDetailType.Infinity then
      hasShopDrop = ((self.levelData).cfg).hasShopDrop
    end
  end
  if hasShopDrop then
    local curStamina = (PlayerDataCenter.stamina):GetCurrentStamina()
    if curStamina < (ConfigData.game_config).staminaWarnNum then
      waitMsgBox = true
      staminaOk = false
      local staminaCeiling = (PlayerDataCenter.stamina):GetStaminaCeiling()
      local msg = (string.format)(ConfigData:GetTipContent(751), curStamina, staminaCeiling)
      local msgWindow = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
      msgWindow:ShowTextBoxWithYesAndNo(msg, function()
    -- function num : 0_23_0 , upvalues : waitMsgBox, staminaOk
    waitMsgBox = false
    staminaOk = true
  end
, function()
    -- function num : 0_23_1 , upvalues : waitMsgBox
    waitMsgBox = false
  end
)
    end
  end
  do
    while waitMsgBox do
      (coroutine.yield)(nil)
    end
    if not staminaOk then
      self._enterFmtCo = nil
      return 
    end
    local infinity50Ok = true
    if self.detailType == eDetailType.Infinity then
      local levelData = self.levelData
      if levelData.isUnlock and not levelData.isComplete and (levelData.cfg).index % SectorEnum.InfinityGroup ~= 0 and (PlayerDataCenter.cacheSaveData):GetEnableConfirmInfinityNot50() then
        infinity50Ok = false
        waitMsgBox = true
        local msgWindow = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
        msgWindow:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(375), function()
    -- function num : 0_23_2 , upvalues : infinity50Ok, waitMsgBox
    infinity50Ok = true
    waitMsgBox = false
  end
, function()
    -- function num : 0_23_3 , upvalues : waitMsgBox
    waitMsgBox = false
  end
)
        msgWindow:ShowDontRemindTog(function(isOn)
    -- function num : 0_23_4 , upvalues : _ENV
    (PlayerDataCenter.cacheSaveData):SetEnableConfirmInfinityNot50(not isOn)
  end
)
      end
    end
    do
      while waitMsgBox do
        (coroutine.yield)(nil)
      end
      if not infinity50Ok then
        self._enterFmtCo = nil
        return 
      end
      self:__EnterBattleFormation()
      self._enterFmtCo = nil
    end
  end
end

UINLevelDtail.IsRunningEnterFmtCo = function(self)
  -- function num : 0_24
  do return self._enterFmtCo ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINLevelDtail.SetDetailNodeCustomEnterFmtCallback = function(self, callback)
  -- function num : 0_25
  self.__customEnterFmtCallback = callback
end

UINLevelDtail.SetDetailNodeExBattleStartCallback = function(self, callback)
  -- function num : 0_26
  self.__customBattleStartCallback = callback
end

UINLevelDtail.SetDetailNodeSelectCanEnterCallback = function(self, callback)
  -- function num : 0_27
  self.__selectCanEnterCallback = callback
end

UINLevelDtail.__EnterBattleFormation = function(self)
  -- function num : 0_28 , upvalues : eDetailType, _ENV, cs_MessageCommon, JumpManager, FmtEnum, SpecificHeroDataRuler
  local enterFunc = function()
    -- function num : 0_28_0 , upvalues : self, eDetailType, _ENV, cs_MessageCommon, JumpManager, FmtEnum, SpecificHeroDataRuler
    do
      if self.detailType == eDetailType.Warchess then
        local costId = (self.stageCfg).cost_strength_id
        if PlayerDataCenter:GetItemCount(costId) < (self.stageCfg).cost_strength_num then
          (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(165))
          return 
        end
        if self.__customEnterFmtCallback ~= nil then
          (self.__customEnterFmtCallback)(nil)
        end
        if self.__customBattleStartCallback then
          (self.__customBattleStartCallback)()
        end
        WarChessManager:EnterWarChessBySectorStageId((self.stageCfg).id, self._stgChallengeData)
        if self._stgChallengeData ~= nil then
          (self._stgChallengeData):TrySaveStgChallengeTask()
        end
        return 
      end
      local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
      fmtCtrl:ResetFmtCtrlState()
      local enterFmtData = fmtCtrl:GetNewEnterFmtData()
      if self.__customEnterFmtCallback ~= nil then
        (self.__customEnterFmtCallback)(enterFmtData)
      end
      local enterFunc = function()
      -- function num : 0_28_0_0 , upvalues : _ENV
      UIManager:HideWindow(UIWindowTypeID.Sector)
      UIManager:HideWindow(UIWindowTypeID.SectorLevel)
      UIManager:HideWindow(UIWindowTypeID.SectorLevelDetail)
      UIManager:HideWindow(UIWindowTypeID.DailyChallenge)
      UIManager:HideWindow(UIWindowTypeID.ActivityWinterMainMap)
    end

      local exitFunc = function()
      -- function num : 0_28_0_1 , upvalues : _ENV, self
      UIManager:ShowWindowOnly(UIWindowTypeID.Sector)
      UIManager:ShowWindowOnly(UIWindowTypeID.SectorLevel)
      UIManager:ShowWindowOnly(UIWindowTypeID.SectorLevelDetail)
      UIManager:ShowWindowOnly(UIWindowTypeID.DailyChallenge)
      UIManager:ShowWindowOnly(UIWindowTypeID.ActivityWinterMainMap)
      if self._stgChallengeData ~= nil then
        (self._switchChallengeTog):SetCommonSwitchToggleValue((self._stgChallengeData):IsStageChallengeOpen())
        self:_UpdClgRewardNumPrewview()
      end
    end

      local startBattleFunc = function(curSelectFormationData, callBack)
      -- function num : 0_28_0_2 , upvalues : self, eDetailType, _ENV, JumpManager, enterFmtData, fmtCtrl, cs_MessageCommon
      if self.__customBattleStartCallback then
        (self.__customBattleStartCallback)()
      end
      local curSelectFormationId = curSelectFormationData.id
      if self.detailType == eDetailType.Stage and (PlayerDataCenter.stamina):GetCurrentStamina() < (self.stageCfg).cost_strength_num then
        JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
        return 
      else
        if self.detailType == eDetailType.Infinity and (PlayerDataCenter.stamina):GetCurrentStamina() < (((self.levelData).cfg).cost_strength_itemNums)[1] then
          JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
          return 
        else
        end
      end
      if (self.detailType ~= eDetailType.PeriodicChallenge or self.detailType == eDetailType.PeriodicChallenge) then
        local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
        local isFixedFmt = enterFmtData:IsFmtCtrlFiexd()
        if self.detailType == eDetailType.Stage then
          local stgChallengeData = enterFmtData:GetFmtChallengeModeData()
          local isChallengeMode = (stgChallengeData ~= nil and stgChallengeData:IsStageChallengeOpen())
          local challengeTaskIdList = isChallengeMode and stgChallengeData:GetStgClgOptionalTaskOpenList() or nil
          local isEzModel = (#(self.stageCfg).assist_buff > 0 and not isChallengeMode)
          if isEzModel then
            local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass, true)
            do
              local failEpCounter = timePassCtrl:getCounterElemData(proto_object_CounterModule.CounterModuleEplFailTimes, (self.stageCfg).id)
              isEzModel = failEpCounter ~= nil and (ConfigData.game_config).ezModeTarget <= failEpCounter.times
            end
          end
          if isEzModel then
            local totalFtPower, totalBenchPower = fmtCtrl:CalculatePower(curSelectFormationData)
            ;
            (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(391), function()
        -- function num : 0_28_0_2_0 , upvalues : _ENV, self, curSelectFormationId, callBack, curSelectFormationData, totalFtPower, totalBenchPower
        ExplorationManager:ReqEnterExploration((self.stageCfg).id, curSelectFormationId, proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration, true, callBack, (curSelectFormationData:GetSupportHeroData()), nil, nil, totalFtPower, totalBenchPower)
      end
, function()
        -- function num : 0_28_0_2_1 , upvalues : _ENV, self, curSelectFormationId, callBack, curSelectFormationData, totalFtPower, totalBenchPower
        ExplorationManager:ReqEnterExploration((self.stageCfg).id, curSelectFormationId, proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration, false, callBack, (curSelectFormationData:GetSupportHeroData()), nil, nil, totalFtPower, totalBenchPower)
      end
)
          else
            local totalFtPower, totalBenchPower = fmtCtrl:CalculatePower(curSelectFormationData)
            ExplorationManager:ReqEnterExploration((self.stageCfg).id, curSelectFormationId, proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration, false, callBack, curSelectFormationData:GetSupportHeroData(), isChallengeMode, challengeTaskIdList, totalFtPower, totalBenchPower)
          end
          if stgChallengeData ~= nil then
            stgChallengeData:TrySaveStgChallengeTask()
          end
        elseif self.detailType == eDetailType.Infinity then
          local totalFtPower, totalBenchPower = fmtCtrl:CalculatePower(curSelectFormationData)
          ExplorationManager:ReqEnterExploration(((self.levelData).cfg).id, curSelectFormationId, proto_csmsg_SystemFunctionID.SystemFunctionID_Endless, false, callBack, (curSelectFormationData:GetSupportHeroData()), nil, nil, totalFtPower, totalBenchPower)
        elseif self.detailType == eDetailType.PeriodicChallenge then
          ExplorationManager:ReqEnterChallengeExploration(curSelectFormationId, callBack)
        elseif self.detailType == eDetailType.WeeklyChallenge then
          local totalFtPower, totalBenchPower = fmtCtrl:CalculatePower((enterFmtData:GetFmtCtrlVirtualFmtData()).formation)
          ExplorationManager:ReqEnterWeeklyExploration(self.challengeId, enterFmtData:GetFmtCtrlVirtualFmtData(), callBack, totalFtPower, totalBenchPower)
        end
        if self.detailType == eDetailType.WeeklyChallenge then
          local _, wcType = enterFmtData:IsWCFormation()
          saveUserData:SetLastWeeklyChallengeFmt(wcType, ((enterFmtData:GetFmtCtrlVirtualFmtData()).formation).data)
        elseif not isFixedFmt and self.stageCfg then
          saveUserData:SetLastFormationId(self.sectorId, curSelectFormationId, (self.stageCfg).id)
          PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
          -- DECOMPILER ERROR: 18 unprocessed JMP targets
        end
      end
    end

      if self.stageCfg then
        local lastFmtId = ((PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFormationId(self.sectorId, (self.stageCfg).id))
        local chipDataList = nil
        if self.chipDataQualityDic ~= nil and (table.count)(self.chipDataQualityDic) > 0 then
          chipDataList = {}
          for k,v in pairs(self.chipDataQualityDic) do
            for i,chipData in ipairs(v) do
              (table.insert)(chipDataList, chipData)
            end
          end
        end
        do
          if self.detailType == eDetailType.Stage then
            (((enterFmtData:SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).SectorLevel, (self.stageCfg).id, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum((self.stageCfg).cost_strength_num)):SetFmtCtrlChipDataList(chipDataList)
            if (PlayerDataCenter.sectorAchievementDatas):HasStageChallengeTask((self.stageCfg).id) then
              if not self._SetChallengeModeFunc then
                self._SetChallengeModeFunc = BindCallback(self, self._SetChallengeModeOpen)
                enterFmtData:SetFmtCtrlChallengeData(true, self._SetChallengeModeFunc, self._stgChallengeData)
                fmtCtrl:EnterFormation()
                if self.detailType == eDetailType.Infinity then
                  local staminaCost = (((self.levelData).cfg).cost_strength_itemNums)[1]
                  ;
                  (((enterFmtData:SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).Infinity, ((self.levelData).cfg).id, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(staminaCost)):SetFmtCtrlChipDataList(chipDataList)
                  fmtCtrl:EnterFormation()
                else
                  do
                    if self.detailType == eDetailType.PeriodicChallenge then
                      local challengeCfg = (ConfigData.daily_challenge)[self.challengeId]
                      local specificHeroDataRuler = (SpecificHeroDataRuler.ctorWithChallengeCfg)(challengeCfg)
                      ;
                      (((((enterFmtData:SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).PeriodicChallenge, nil, lastFmtId)):SetSpecificHeroDataRuler(specificHeroDataRuler)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(0)):SetFmtCtrlChipDataList(chipDataList)):SetIsOpenChangeFmt(false)
                      fmtCtrl:EnterFormation()
                    else
                      do
                        if self.detailType == eDetailType.WeeklyChallenge then
                          local weeklyData = ((PlayerDataCenter.allWeeklyChallengeData).dataDic)[self.challengeId]
                          local challengeCfg = weeklyData.cfg
                          local specificHeroDataRuler = (SpecificHeroDataRuler.ctorWithWeeklyChallengeCfg)(challengeCfg, weeklyData)
                          local fmtBuffSelectData = weeklyData:GetFmtBuffSelectData()
                          ;
                          ((((((((enterFmtData:SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).WeeklyChallenge, weeklyData.id, lastFmtId)):SetSpecificHeroDataRuler(specificHeroDataRuler)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(0)):SetFmtCtrlChipDataList(chipDataList)):SetIsOpenChangeFmt(false)):SetIsOpenBuffSelect(true)):SetPeridicFmtBuffSelect(fmtBuffSelectData)):SetIsShowTotalPow(false)
                          fmtCtrl:EnterFormation()
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  if self.__selectCanEnterCallback then
    (self.__selectCanEnterCallback)((self.stageCfg).id, enterFunc)
    return 
  end
  enterFunc()
end

UINLevelDtail.OnCliCkGiveUpLastEp = function(self)
  -- function num : 0_29 , upvalues : SectorStageDetailHelper
  (SectorStageDetailHelper.GiveupStageLevel)(self._playMoudle)
end

UINLevelDtail.OnCliCkViewAvg = function(self)
  -- function num : 0_30 , upvalues : _ENV, eInfoNodeType
  if self.__couldNotStatrBattle then
    return 
  end
  ;
  (UIUtil.OnClickBack)()
  local playFunc = function()
    -- function num : 0_30_0 , upvalues : _ENV, self, eInfoNodeType
    (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg((self.avgCfg).script_id, (self.avgCfg).id, function()
      -- function num : 0_30_0_0 , upvalues : _ENV, self, eInfoNodeType
      (AvgUtil.ShowMainCamera)(true)
      if IsNull(self.transform) then
        return 
      end
      ;
      (self.playAvgCompleteFunc)()
      self:ShowNode(eInfoNodeType.LevelNormalInfo)
    end
)
    ;
    (AvgUtil.ShowMainCamera)(false)
  end

  local popTipId = self:TryGetAvgTip()
  if popTipId or 0 > 0 then
    ((CS.MessageCommon).ShowMessageBox)(ConfigData:GetTipContent(popTipId), function()
    -- function num : 0_30_1 , upvalues : playFunc
    playFunc()
  end
, nil)
  else
    playFunc()
  end
end

UINLevelDtail.TryGetAvgTip = function(self)
  -- function num : 0_31 , upvalues : _ENV, ExplorationEnum
  local stageId = (self.avgCfg).set_place
  local popTipId = nil
  if stageId == nil then
    return nil
  end
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil then
    return nil
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  if stageCfg.difficulty == (ExplorationEnum.eDifficultType).Hard and avgPlayCtrl:IsAvgUnlock((self.avgCfg).id) and not avgPlayCtrl:IsAvgPlayed((self.avgCfg).id) then
    if avgPlayCtrl:IsPlayedAllMainAvg(stageCfg.sector, (ExplorationEnum.eDifficultType).Normal, (self.avgCfg).id) ~= 0 then
      return TipContent.HardAVG_Tip
    else
      if avgPlayCtrl:IsPlayedAllMainAvg(stageCfg.sector, stageCfg.difficulty, (self.avgCfg).id) ~= 0 then
        return TipContent.NormalAVG_Tip
      end
    end
  end
  if stageCfg.difficulty == (ExplorationEnum.eDifficultType).Normal and avgPlayCtrl:IsAvgUnlock((self.avgCfg).id) and not avgPlayCtrl:IsAvgPlayed((self.avgCfg).id) and avgPlayCtrl:IsPlayedAllMainAvg(stageCfg.sector, stageCfg.difficulty, (self.avgCfg).id, true) ~= 0 then
    return TipContent.NormalAVG_Tip
  end
  return nil
end

UINLevelDtail.OnBtnBlitz = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local costId1 = (((self.levelData).cfg).cost_strength_itemIds)[1]
  local costNum1 = (((self.levelData).cfg).cost_strength_itemNums)[1]
  local costId2, costNum2 = nil, nil
  local extraCondition = true
  if ((self.levelData).cfg).blitz_cost_id ~= nil then
    costId2 = ((self.levelData).cfg).blitz_cost_id
    costNum2 = ((self.levelData).cfg).blitz_cost_num
    extraCondition = costNum2 <= PlayerDataCenter:GetItemCount(costId2)
  end
  if costNum1 <= (PlayerDataCenter.stamina):GetCurrentStamina() and extraCondition then
    local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    if costId2 ~= nil then
      local msg = (string.format)(ConfigData:GetTipContent(290), ConfigData:GetItemName(costId1) .. "," .. ConfigData:GetItemName(costId2))
      window:ShowItemCost2(msg, costId1, costNum1, costId2, costNum2, function()
    -- function num : 0_32_0 , upvalues : _ENV, self
    (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_BLITZ_Blitz(((self.levelData).cfg).id)
  end
)
    else
      local msg = (string.format)(ConfigData:GetTipContent(290), ConfigData:GetItemName(costId1))
      window:ShowItemCost(msg, costId1, costNum1, function()
    -- function num : 0_32_1 , upvalues : _ENV, self
    (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_BLITZ_Blitz(((self.levelData).cfg).id)
  end
)
    end
  else
    local msg = (string.format)(ConfigData:GetTipContent(252))
    local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    if costId2 ~= nil then
      window:ShowItemCost2Confirm(msg, costId1, costNum1, costId2, costNum2)
    else
      window:ShowItemCostConfirm(msg, costId1, costNum1)
    end
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINLevelDtail.OnClickRecomme = function(self)
  -- function num : 0_33 , upvalues : _ENV, eDetailType
  local recommeCtrl = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
  if self.detailType == eDetailType.Stage then
    recommeCtrl:ReqRecommeFormationNew((self.stageCfg).id, false)
  else
    recommeCtrl:ReqRecommeFormationNew(((self.levelData).cfg).id, false)
  end
end

UINLevelDtail.GetNLevelDetailWidthAndDuration = function(self)
  -- function num : 0_34
  return ((self.transform).sizeDelta).x, ((self.ui).moveTween).duration
end

UINLevelDtail.PlayMoveTween = function(self, isShow)
  -- function num : 0_35 , upvalues : _ENV, eDetailType
  if isShow then
    if self.__isHiding then
      ((self.ui).moveTween):DORewind()
    end
    if self.__isShow then
      return 
    end
    UIManager:ShowWindow(UIWindowTypeID.SectorLevelDetail)
    self.__isShow = true
    ;
    ((self.ui).moveTween):DOPlayForward()
    if self.detailType == eDetailType.Stage then
      AudioManager:PlayAudioById(1033)
    else
      if self.detailType == eDetailType.Avg then
        AudioManager:PlayAudioById(1035)
      end
    end
  else
    ;
    ((self.ui).moveTween):DOPlayBackwards()
    self.__isHiding = true
    if self.detailType == eDetailType.Stage then
      AudioManager:PlayAudioById(1034)
    else
      if self.detailType == eDetailType.Avg then
        AudioManager:PlayAudioById(1036)
      end
    end
  end
  ;
  (UIUtil.AddOneCover)("LevelDetailTween")
end

UINLevelDtail.__OnMoveTweenComplete = function(self)
  -- function num : 0_36 , upvalues : _ENV
  (UIUtil.CloseOneCover)("LevelDetailTween")
  if (self.SelectedNode).ForceRefresh ~= nil then
    (self.SelectedNode):ForceRefresh()
  end
end

UINLevelDtail.__OnMoveTweenRewind = function(self)
  -- function num : 0_37 , upvalues : _ENV
  (UIUtil.CloseOneCover)("LevelDetailTween")
  self.__isHiding = false
  UIManager:HideWindow(UIWindowTypeID.SectorLevelDetail)
  self.__isShow = false
end

UINLevelDtail._UpdUnlockCondition = function(self, ...)
  -- function num : 0_38 , upvalues : _ENV
  local unlockInfoList = (CheckCondition.GetUnlockAndInfoList)(...)
  ;
  (self.conditionItemPool):HideAll()
  for k,condition in ipairs(unlockInfoList) do
    local conditionItem = (self.conditionItemPool):GetOne()
    conditionItem:InitStOUnlockConditionItem(condition.unlock, condition.lockReason)
  end
end

UINLevelDtail._InitChallengeMode = function(self)
  -- function num : 0_39 , upvalues : _ENV, StageChallengeData
  self._stgChallengeData = nil
  if self.__lastEpStateCfg ~= nil or self.isLocked then
    return 
  end
  if not (PlayerDataCenter.sectorAchievementDatas):HasStageChallengeTask((self.stageCfg).id) then
    return 
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_LockChallenge).enabled = not (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskOpen((self.stageCfg).id)
  local sectorCfg = (ConfigData.sector)[(self.stageCfg).sector]
  ;
  ((self.ui).obj_ChallengeNode):SetActive(true)
  self._stgChallengeData = (StageChallengeData.Create)((self.stageCfg).id)
  local isChallengeMode = false
  do
    if (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskOpen((self.stageCfg).id) then
      local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      isChallengeMode = saveUserData:GetChallengeStageSwitch((self.stageCfg).id)
    end
    ;
    (self._stgChallengeData):SetStageChallengeOpen(isChallengeMode)
    ;
    (self._switchChallengeTog):InitCommonSwitchToggle(isChallengeMode, self._changeChallengeFunc)
    self:_ShowChallengeTask(isChallengeMode, self.stageCfg)
    self:RefreshBattleButton()
    self:_UpdClgRewardNumPrewview()
  end
end

UINLevelDtail._OnClickChallenge = function(self)
  -- function num : 0_40 , upvalues : _ENV
  if self:_CheckChallegeIsNotOpen() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.FmtChallengeInfo, function(win)
    -- function num : 0_40_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitFmtChallengeInfo(self._stgChallengeData, function()
      -- function num : 0_40_0_0 , upvalues : self
      if (self._stgChallengeData):IsStageChallengeOpen() then
        self:_UpdClgRewardNumPrewview()
        return 
      end
      self:_SetChallengeModeOpen(true)
    end
)
  end
)
end

UINLevelDtail._CheckChallegeIsNotOpen = function(self)
  -- function num : 0_41 , upvalues : _ENV
  if not (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskOpen((self.stageCfg).id) then
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_41_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    local msg = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskOpenDes((self.stageCfg).id)
    win:ShowTextBoxWithConfirm(msg, nil)
  end
)
    return true
  end
  return false
end

UINLevelDtail._OnClickChallengeModeTog = function(self, isChallengeMode)
  -- function num : 0_42 , upvalues : _ENV
  if self:_CheckChallegeIsNotOpen() then
    return 
  end
  self:_SetChallengeModeOpen(isChallengeMode)
  if isChallengeMode then
    UIManager:ShowWindowAsync(UIWindowTypeID.FmtChallengeInfo, function(win)
    -- function num : 0_42_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitFmtChallengeInfo(self._stgChallengeData, function()
      -- function num : 0_42_0_0 , upvalues : self
      self:_UpdClgRewardNumPrewview()
    end
)
  end
)
  end
end

UINLevelDtail._SetChallengeModeOpen = function(self, isChallengeMode)
  -- function num : 0_43
  if (self._stgChallengeData):IsStageChallengeOpen() == isChallengeMode then
    return 
  end
  ;
  (self._stgChallengeData):SetStageChallengeOpen(isChallengeMode)
  ;
  (self._switchChallengeTog):SetCommonSwitchToggleValue(isChallengeMode)
  self:_ShowChallengeTask(isChallengeMode, self.stageCfg)
  self:RefreshBattleButton()
  self:_UpdClgRewardNumPrewview()
end

UINLevelDtail.LvDetailIsChallengeMode = function(self)
  -- function num : 0_44
  if self._stgChallengeData then
    return (self._stgChallengeData):IsStageChallengeOpen()
  end
end

UINLevelDtail._ShowChallengeTask = function(self, isChallengeMode, stageCfg)
  -- function num : 0_45 , upvalues : eInfoNodeType
  local node = (self.NodeDic)[eInfoNodeType.LevelNormalInfo]
  if node ~= nil then
    node:ShowLvNormalChallengeTask(isChallengeMode, stageCfg)
  end
end

UINLevelDtail.SetShowAdditionBuffList = function(self, buffList)
  -- function num : 0_46
  self.__additionalBuffList = buffList
end

UINLevelDtail.GetShowAdditionBuffList = function(self)
  -- function num : 0_47
  return self.__additionalBuffList
end

UINLevelDtail._UpdClgRewardNumPrewview = function(self)
  -- function num : 0_48 , upvalues : _ENV
  if self._stgChallengeData == nil then
    return 
  end
  local rewardNum = (self._stgChallengeData):GetStgChallengeTaskRewardNum()
  if rewardNum > 0 then
    ((self.ui).obj_ClgReward):SetActive(true)
    ;
    ((self.ui).tex_ClgRewardNum):SetIndex(0, tostring(rewardNum))
  else
    ;
    ((self.ui).obj_ClgReward):SetActive(false)
  end
end

UINLevelDtail.OnShow = function(self)
  -- function num : 0_49 , upvalues : base, _ENV
  (base.OnShow)(self)
  if self.__addListener then
    return 
  end
  MsgCenter:AddListener(eMsgEventId.OnHasUncompletedEp, self.__onHasUncompletedEp)
  MsgCenter:AddListener(eMsgEventId.SectorChipSet, self.__OnChipSetUpdate)
  self.__addListener = true
end

UINLevelDtail.OnHide = function(self)
  -- function num : 0_50 , upvalues : _ENV
  (UIUtil.CloseOneCover)("LevelDetailTween")
  if not self.__addListener then
    return 
  end
  MsgCenter:RemoveListener(eMsgEventId.OnHasUncompletedEp, self.__onHasUncompletedEp)
  MsgCenter:RemoveListener(eMsgEventId.SectorChipSet, self.__OnChipSetUpdate)
  self.__addListener = false
end

UINLevelDtail.OnDelete = function(self)
  -- function num : 0_51 , upvalues : _ENV, base
  for _,NodeItem in pairs(self.NodeDic) do
    NodeItem:Delete()
  end
  if self._enterFmtCo ~= nil then
    (GR.StopCoroutine)(self._enterFmtCo)
    self._enterFmtCo = nil
  end
  ;
  (self._switchChallengeTog):Delete()
  ;
  (self.conditionItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINLevelDtail

