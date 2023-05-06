-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunLevelDetail = class("UINDunLevelDetail", UIBaseNode)
local base = UIBaseNode
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local UINLevelInfgoTypeTog = require("Game.Sector.SectorLevelDetail.UINLevelInfgoTypeTog")
local UINDunLevelNormalNode = require("Game.DungeonCenter.LevelUI.UINDunLevelNormalNode")
local UINDunLevelChipSuitNode = require("Game.DungeonCenter.LevelUI.UINDunLevelChipSuitNode")
local UINStOUnlockConditionItem = require("Game.StrategyOverview.UI.Side.UINStOUnlockConditionItem")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
UINDunLevelDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelInfgoTypeTog, DungeonLevelEnum, UINDunLevelNormalNode, UINDunLevelChipSuitNode, UINStOUnlockConditionItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.OnClickDungeonBattle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GiveUP, self, self._OnClickGiveup)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Recomme, self, self.OnClickDungeonRecomme)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AutoBattle, self, self.OnClickDungeonAutoBattle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Unlock, self, self.OnClickUnlock)
  self.typeTogPool = (UIItemPool.New)(UINLevelInfgoTypeTog, (self.ui).obj_tog_Type)
  ;
  ((self.ui).obj_tog_Type):SetActive(false)
  self.__nodeCfg = {
[(DungeonLevelEnum.eDunLevelInfoNodeType).LevelNormalInfo] = {nodeClass = UINDunLevelNormalNode, uiNode = (self.ui).obj_normalNode}
, 
[(DungeonLevelEnum.eDunLevelInfoNodeType).LevelChips] = {nodeClass = UINDunLevelChipSuitNode, uiNode = (self.ui).obj_chipSuitNode}
}
  self.__nodeDic = {}
  self.__togDic = {}
  self.selectedNode = nil
  self.lastDunLevelType = nil
  ;
  ((self.ui).conditionItem):SetActive(false)
  self.conditionItemPool = (UIItemPool.New)(UINStOUnlockConditionItem, (self.ui).conditionItem)
  ;
  (((self.ui).moveTween).onComplete):AddListener(BindCallback(self, self.__OnMoveTweenComplete))
  ;
  (((self.ui).moveTween).onRewind):AddListener(BindCallback(self, self.__OnMoveTweenRewind))
  local position = Vector2.zero
  position.x = ((((self.ui).moveTween).transform).sizeDelta).x + ((CS.UIManager).Instance).CurNotchValue / 100 * ((CS.UnityEngine).Screen).width
  -- DECOMPILER ERROR at PC130: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).moveTween).transform).anchoredPosition = position
  self.__isShow = false
  self._colorNormalBattleImg = ((self.ui).image_battle).color
  self._colorNormalBattleTex = (((self.ui).tex_Battle).text).color
end

UINDunLevelDetail.BindDetailCommonData = function(self, resloader)
  -- function num : 0_1
  self.__resloader = resloader
end

UINDunLevelDetail.InitDunLevelDetailNode = function(self, dunLevelData, isLocked)
  -- function num : 0_2 , upvalues : DungeonLevelEnum, cs_MessageCommon, _ENV
  self.__dunLevelData = dunLevelData
  self.isLocked = isLocked
  self:_UpdPower()
  self:RefreshEnterBattleCost()
  self:_UpdBattleBtn(self.isLocked)
  ;
  ((self.ui).unlockCondition):SetActive(isLocked)
  self.__initedTypeTog = {}
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  if self.lastDunLevelType ~= dungeonType then
    self.lastDunLevelType = dungeonType
    self:GenTypeTogs()
  end
  self:PlayMoveTween(true)
  self:SelectDefaultTog()
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(dunLevelData:HasRecommendFormation())
  self:RefreshDungeonAutoBattleBtn(isLocked)
  self:__RefreshUnLockBtnState()
  if isLocked then
    if dungeonType == (DungeonLevelEnum.DunLevelType).ADC then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8411))
    else
      self:UnlockLevelInfo((self.__dunLevelData):GetSpecialUnlockInfo(), (self.__dunLevelData):GetLevelUnlockConditionCfg())
    end
  end
end

UINDunLevelDetail.UnlockLevelInfo = function(self, specialUnlockInfo, ...)
  -- function num : 0_3 , upvalues : _ENV, cs_MessageCommon
  self:_UpdUnlockCondition(specialUnlockInfo, ...)
  if select("#", ...) <= 3 then
    local unLockInfo = (CheckCondition.GetUnlockInfoLua)(...)
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(unLockInfo)
  else
    do
      local unLockInfo = nil
      local firstCon, firstParam1, firstParam2 = select("1", ...)
      if #firstCon > 1 then
        unLockInfo = (CheckCondition.GetUnlockInfoLua)(firstCon, firstParam1, firstParam2)
        unLockInfo = (string.format)(ConfigData:GetTipContent(8708), unLockInfo)
      else
        local speStr = (LanguageUtil.GetLocaleText)(specialUnlockInfo)
        if not (string.IsNullOrEmpty)(speStr) then
          unLockInfo = speStr
        else
          unLockInfo = (CheckCondition.GetUnlockInfoLuaByMany)(...)
          unLockInfo = (string.format)(ConfigData:GetTipContent(8708), unLockInfo)
        end
      end
      do
        ;
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(unLockInfo)
      end
    end
  end
end

UINDunLevelDetail._UpdPower = function(self)
  -- function num : 0_4 , upvalues : DungeonLevelEnum, _ENV
  local dunLevelType = (self.__dunLevelData):GetDungeonLevelType()
  if dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    ((self.ui).obj_Power):SetActive(false)
  else
    ;
    ((self.ui).obj_Power):SetActive(true)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Power).text = tostring((self.__dunLevelData):GetRecommendCombat())
  end
end

UINDunLevelDetail._UpdBattleBtn = function(self, isLocked)
  -- function num : 0_5 , upvalues : DungeonLevelEnum
  local dunLevelType = (self.__dunLevelData):GetDungeonLevelType()
  if dunLevelType ~= (DungeonLevelEnum.DunLevelType).ADC then
    (((self.ui).btn_Battle).gameObject):SetActive(not isLocked)
    ;
    ((self.ui).tex_Battle):SetIndex(0)
  else
    ;
    (((self.ui).btn_Battle).gameObject):SetActive(true)
    ;
    ((self.ui).tex_Battle):SetIndex(4)
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_Battle).text).color = (self.ui).color_lockTex
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).image_battle).color = (self.ui).color_lockImg
  end
  ;
  (((self.ui).btn_GiveUP).gameObject):SetActive(false)
  if isLocked then
    return 
  end
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).tex_Battle).text).color = self._colorNormalBattleTex
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).image_battle).color = self._colorNormalBattleImg
  ;
  ((self.ui).tex_Battle):SetIndex(0)
  if dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    local isFinish, inDungeon = (self.__dunLevelData):GetSctIIChallengeDgStage()
    if inDungeon then
      (((self.ui).btn_GiveUP).gameObject):SetActive(true)
      ;
      ((self.ui).tex_GiveUP):SetIndex(1)
      ;
      ((self.ui).tex_Battle):SetIndex(1)
    end
  end
end

UINDunLevelDetail.GetDungeonLevelData = function(self)
  -- function num : 0_6
  return self.__dunLevelData
end

UINDunLevelDetail._UpdUnlockCondition = function(self, specialUnlockInfo, ...)
  -- function num : 0_7 , upvalues : _ENV
  local unlockInfoList, isNeedFormat = nil, nil
  if select("#", ...) <= 3 then
    unlockInfoList = (CheckCondition.GetUnlockAndInfoList)(...)
  else
    local firstCon, firstParam1, firstParam2 = select("1", ...)
    if #firstCon > 1 then
      unlockInfoList = (CheckCondition.GetUnlockAndInfoList)(firstCon, firstParam1, firstParam2)
      isNeedFormat = true
    else
      unlockInfoList = (CheckCondition.GetUnlockAndInfoListByMany)(...)
      local speStr = (LanguageUtil.GetLocaleText)(specialUnlockInfo)
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R8 in 'UnsetPending'

      if not (string.IsNullOrEmpty)(speStr) then
        (unlockInfoList[1]).lockReason = speStr
      else
        isNeedFormat = true
      end
    end
  end
  do
    ;
    (self.conditionItemPool):HideAll()
    for k,condition in ipairs(unlockInfoList) do
      local conditionItem = (self.conditionItemPool):GetOne()
      local lockInfo = condition.lockReason
      if isNeedFormat then
        lockInfo = (string.format)(ConfigData:GetTipContent(8708), lockInfo)
      end
      conditionItem:InitStOUnlockConditionItem(condition.unlock, lockInfo)
    end
  end
end

UINDunLevelDetail.GenTypeTogs = function(self)
  -- function num : 0_8 , upvalues : DungeonLevelEnum, _ENV
  (self.typeTogPool):HideAll()
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  local nodeTypeList = (DungeonLevelEnum.nodeTyps)[dungeonType]
  for index,infoNodeType in ipairs(nodeTypeList) do
    do
      do
        if (self.__nodeDic)[infoNodeType] == nil then
          local nodeCfg = (self.__nodeCfg)[infoNodeType]
          local nodeItem = ((nodeCfg.nodeClass).New)()
          nodeItem:Init(nodeCfg.uiNode)
          nodeItem:Hide()
          nodeItem:BindDunLevelResloader(self.__resloader)
          -- DECOMPILER ERROR at PC30: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (self.__nodeDic)[infoNodeType] = nodeItem
        end
        do
          local togItem = (self.typeTogPool):GetOne()
          local isLast = index == #nodeTypeList
          togItem:InitTog(infoNodeType, isLast, function()
    -- function num : 0_8_0 , upvalues : self, infoNodeType, isLast
    self:ShowPageNode(infoNodeType)
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
          -- DECOMPILER ERROR at PC45: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (self.__togDic)[infoNodeType] = togItem
        end
        -- DECOMPILER ERROR at PC48: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  for infoNodeType,nodeCfg in pairs(self.__nodeCfg) do
    local infoNodeType, nodeCfg = nil
    infoNodeType = self.__nodeDic
    infoNodeType = infoNodeType[l_0_8_13]
    if infoNodeType == nil then
      infoNodeType = l_0_8_14.uiNode
      infoNodeType, nodeCfg = infoNodeType:SetActive, infoNodeType
      infoNodeType(nodeCfg, false)
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINDunLevelDetail.ShowPageNode = function(self, infoNodeType)
  -- function num : 0_9 , upvalues : _ENV
  for typeId,NodeItem in pairs(self.__nodeDic) do
    if infoNodeType == typeId then
      if self.SelectedNode ~= nil then
        (self.SelectedNode):Hide()
      end
      NodeItem:Show()
      -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

      if (self.__initedTypeTog)[typeId] == nil then
        (self.__initedTypeTog)[typeId] = true
        NodeItem:InitDungeonInfoNode(self)
      end
      self.SelectedNode = NodeItem
      break
    end
  end
end

UINDunLevelDetail.SelectDefaultTog = function(self)
  -- function num : 0_10 , upvalues : DungeonLevelEnum
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  local nodeTypeList = (DungeonLevelEnum.nodeTyps)[dungeonType]
  local firshNodeType = nodeTypeList[1]
  local togItem = (self.__togDic)[firshNodeType]
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((togItem.ui).tog_Type).isOn = false
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((togItem.ui).tog_Type).isOn = true
end

UINDunLevelDetail.RefreshEnterBattleCost = function(self)
  -- function num : 0_11 , upvalues : _ENV, DungeonLevelEnum
  local dunLevelType = (self.__dunLevelData):GetDungeonLevelType()
  if (self.__dunLevelData):IsDunCustomTicket() then
    local costId = (self.__dunLevelData):GetEnterLevelCost()
    local costItemCfg = (ConfigData.item)[costId]
    local sprite = CRH:GetSpriteByItemConfig(costItemCfg, true)
    ;
    ((self.ui).obj_img_Key):SetActive(false)
    ;
    (((self.ui).img_EnterBattleCost).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_EnterBattleCost).sprite = sprite
    ;
    ((self.ui).tex_Point):SetIndex(0, tostring((self.__dunLevelData):GetConsumeKeyNum()))
  else
    do
      if dunLevelType == (DungeonLevelEnum.DunLevelType).ADC then
        ((self.ui).obj_point):SetActive(false)
      else
        local costId = (self.__dunLevelData):GetEnterLevelCost()
        if costId == ConstGlobalItem.SKey then
          ((self.ui).obj_img_Key):SetActive(true)
          ;
          (((self.ui).img_EnterBattleCost).gameObject):SetActive(false)
        else
          ;
          ((self.ui).obj_img_Key):SetActive(false)
          ;
          (((self.ui).img_EnterBattleCost).gameObject):SetActive(true)
          local costItemCfg = (ConfigData.item)[costId]
          local sprite = CRH:GetSpriteByItemConfig(costItemCfg, true)
          -- DECOMPILER ERROR at PC94: Confused about usage of register: R5 in 'UnsetPending'

          ;
          ((self.ui).img_EnterBattleCost).sprite = sprite
        end
        do
          ;
          ((self.ui).tex_Point):SetIndex(0, tostring((self.__dunLevelData):GetConsumeKeyNum()))
        end
      end
    end
  end
end

UINDunLevelDetail.RefreshDungeonAutoBattleBtn = function(self, isLocked)
  -- function num : 0_12 , upvalues : DungeonLevelEnum, _ENV
  if isLocked then
    (((self.ui).btn_AutoBattle).gameObject):SetActive(false)
    return 
  end
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  if dungeonType == (DungeonLevelEnum.DunLevelType).Tower then
    local dunTowerCtrl = ControllerManager:GetController(ControllerTypeId.DungeonTower)
    if dunTowerCtrl ~= nil then
      local showAuto, unlock = dunTowerCtrl:GetDungonTowerAutoBattleInfo(self.__dunLevelData)
      ;
      (((self.ui).btn_AutoBattle).gameObject):SetActive(showAuto)
      ;
      ((self.ui).img_AutoMask):SetActive(not unlock)
      return 
    end
  else
    do
      if dungeonType == (DungeonLevelEnum.DunLevelType).SectorII or dungeonType == (DungeonLevelEnum.DunLevelType).SectorIII or dungeonType == (DungeonLevelEnum.DunLevelType).HeroGrow or dungeonType == (DungeonLevelEnum.DunLevelType).Season or dungeonType == (DungeonLevelEnum.DunLevelType).SeasonI then
        local showAuto = (self.__dunLevelData):GetCouldShowAutoPlay()
        local isUnlock = (self.__dunLevelData):GetIsLevelCompleteNoSup()
        ;
        (((self.ui).btn_AutoBattle).gameObject):SetActive(showAuto)
        ;
        ((self.ui).img_AutoMask):SetActive(not isUnlock)
        return 
      end
      do
        ;
        (((self.ui).btn_AutoBattle).gameObject):SetActive(false)
      end
    end
  end
end

UINDunLevelDetail.RefreshNormalNodeReward = function(self)
  -- function num : 0_13 , upvalues : DungeonLevelEnum
  if (self.__nodeDic)[(DungeonLevelEnum.eDunLevelInfoNodeType).LevelNormalInfo] ~= nil then
    ((self.__nodeDic)[(DungeonLevelEnum.eDunLevelInfoNodeType).LevelNormalInfo]):RefreshDLevelReward()
  end
end

UINDunLevelDetail.__RefreshUnLockBtnState = function(self)
  -- function num : 0_14 , upvalues : DungeonLevelEnum, _ENV
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  if dungeonType ~= (DungeonLevelEnum.DunLevelType).ADC then
    (((self.ui).btn_Unlock).gameObject):SetActive(false)
    return 
  end
  if (self.__dunLevelData):IsADCDungeonLevelUnlock() then
    (((self.ui).btn_Unlock).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).btn_Unlock).gameObject):SetActive(true)
  local unlockItemId, unlockItemCount = (self.__dunLevelData):GetADCDunUnlockItemAndCount()
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_unlock_Ticket).sprite = CRH:GetSpriteByItemId(unlockItemId, true)
  ;
  ((self.ui).tex_unlock_Point):SetIndex(0, tostring(unlockItemCount))
end

UINDunLevelDetail.OnClickDungeonBattle = function(self)
  -- function num : 0_15
  self:__EnterDungeonBattle()
end

local enterDunFunc = {[(DungeonLevelEnum.DunLevelType).Tower] = function(self, isAutoBattle)
  -- function num : 0_16 , upvalues : _ENV
  local dunTowerCtrl = ControllerManager:GetController(ControllerTypeId.DungeonTower)
  if dunTowerCtrl ~= nil then
    dunTowerCtrl:EnterDungeonTowerFormation(self.__dunLevelData, isAutoBattle)
  end
end
, [(DungeonLevelEnum.DunLevelType).SectorII] = function(self, autoBattleCount)
  -- function num : 0_17 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if sectorIICtrl ~= nil then
    sectorIICtrl:EnterActSectorIIDungeonFormation(self.__dunLevelData, autoBattleCount)
  end
end
, [(DungeonLevelEnum.DunLevelType).SectorIIChallenge] = function(self, isAutoBattle)
  -- function num : 0_18 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if sectorIICtrl ~= nil then
    sectorIICtrl:ReqEnterActSctIIChallengeDg(self.__dunLevelData)
  end
end
, [(DungeonLevelEnum.DunLevelType).AprilFool] = function(self, isAutoBattle)
  -- function num : 0_19 , upvalues : _ENV
  local ARDCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
  if ARDCtrl ~= nil then
    ARDCtrl:EnterARDDungeonFormation(self.__dunLevelData)
  end
end
, [(DungeonLevelEnum.DunLevelType).Carnival] = function(self, isAutoBattle)
  -- function num : 0_20 , upvalues : _ENV
  local carnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
  if carnivalCtrl ~= nil then
    carnivalCtrl:OnEnterCarnivalChallenge(self.__dunLevelData)
  end
end
, [(DungeonLevelEnum.DunLevelType).ADC] = function(self, isAutoBattle)
  -- function num : 0_21 , upvalues : cs_MessageCommon, _ENV
  if not (self.__dunLevelData):IsADCDungeonLevelUnlock() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8411))
    return 
  end
  local adcCtrl = ControllerManager:GetController(ControllerTypeId.ActivityDailyChallenge)
  adcCtrl:EnterADCDungeon(self.__dunLevelData)
end
, [(DungeonLevelEnum.DunLevelType).SectorIII] = function(self, autoBattleCount)
  -- function num : 0_22 , upvalues : _ENV
  local sectorIIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII)
  if sectorIIICtrl ~= nil then
    sectorIIICtrl:EnterActSectorIIIDungeonFormation(self.__dunLevelData, autoBattleCount)
  end
end
, [(DungeonLevelEnum.DunLevelType).HeroGrow] = function(self, autoBattleCount)
  -- function num : 0_23 , upvalues : _ENV
  local heroGrowCtr = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
  if heroGrowCtr ~= nil then
    heroGrowCtr:EnterHeroGrowDugeon(self.__dunLevelData, autoBattleCount)
  end
end
, [(DungeonLevelEnum.DunLevelType).Season] = function(self, autoBattleCount)
  -- function num : 0_24 , upvalues : _ENV
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
  if seasonCtrl ~= nil then
    seasonCtrl:EnterSeasonDugeon(self.__dunLevelData, autoBattleCount)
  end
end
, [(DungeonLevelEnum.DunLevelType).Spring] = function(self, autoBattleCount)
  -- function num : 0_25 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl ~= nil then
    springCtrl:OnEnterSpringChallenge(self.__dunLevelData)
  end
end
, [(DungeonLevelEnum.DunLevelType).SeasonI] = function(self, autoBattleCount)
  -- function num : 0_26 , upvalues : _ENV
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if seasonCtrl ~= nil then
    seasonCtrl:OnEnterActSeasonChallenge(self.__dunLevelData, autoBattleCount)
  end
end
}
UINDunLevelDetail.__EnterDungeonBattle = function(self)
  -- function num : 0_27 , upvalues : enterDunFunc, _ENV
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  local func = enterDunFunc[dungeonType]
  if func == nil then
    error("no enter dungeon func type:" .. tostring(dungeonType))
    return 
  end
  func(self)
end

UINDunLevelDetail.OnClickDungeonAutoBattle = function(self)
  -- function num : 0_28 , upvalues : DungeonLevelEnum, enterDunFunc, cs_MessageCommon, _ENV, JumpManager
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  if dungeonType == (DungeonLevelEnum.DunLevelType).Tower then
    (enterDunFunc[(DungeonLevelEnum.DunLevelType).Tower])(self, true)
  else
    if dungeonType == (DungeonLevelEnum.DunLevelType).SectorII or dungeonType == (DungeonLevelEnum.DunLevelType).SectorIII or dungeonType == (DungeonLevelEnum.DunLevelType).HeroGrow or dungeonType == (DungeonLevelEnum.DunLevelType).Season or dungeonType == (DungeonLevelEnum.DunLevelType).SeasonI then
      if not (self.__dunLevelData):GetIsLevelCompleteNoSup() then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7102))
        return 
      end
      if not (self.__dunLevelData):GetIsCouldPlayOnce() then
        local itemId = (self.__dunLevelData):GetEnterLevelCost()
        if itemId == ConstGlobalItem.SKey then
          JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
          return 
        end
        local itemName = (self.__dunLevelData):GetEnterLevelCostItemName()
        local actName = (self.__dunLevelData):GetDungeonActName()
        local str = (string.format)(ConfigData:GetTipContent(7104), itemName, actName, itemName)
        ;
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(str)
        return 
      end
      do
        UIManager:CreateWindowAsync(UIWindowTypeID.BattleAutoMode, function(window)
    -- function num : 0_28_0 , upvalues : self, enterDunFunc
    if window == nil then
      return 
    end
    window:InitSectorIIDunAutoSet(self.__dunLevelData, function(autoCount)
      -- function num : 0_28_0_0 , upvalues : self, enterDunFunc
      local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
      local func = enterDunFunc[dungeonType]
      if func ~= nil then
        func(self, autoCount)
      end
    end
)
  end
)
      end
    end
  end
end

UINDunLevelDetail.OnClickDungeonRecomme = function(self)
  -- function num : 0_29 , upvalues : _ENV
  local recommeCtrl = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
  recommeCtrl:ReqDunRecommeFormation((self.__dunLevelData):GetDungeonLevelStageId(), false)
end

UINDunLevelDetail._OnClickGiveup = function(self)
  -- function num : 0_30 , upvalues : DungeonLevelEnum, _ENV
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  if dungeonType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
    if sectorIICtrl ~= nil then
      sectorIICtrl:ReqSettleActSctIIChallengeDg(self.__dunLevelData, function(objList)
    -- function num : 0_30_0 , upvalues : self, _ENV
    self:_UpdBattleBtn(self.isLocked)
    if objList.Count <= 0 then
      error("CS_DUNGEONWinterVerify_Settle objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    local showRewardFunc = function()
      -- function num : 0_30_0_0 , upvalues : _ENV, msg
      (UIUtil.ReShowTopStatus)()
      if (table.count)(msg.rewards) > 0 then
        UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_30_0_0_0 , upvalues : _ENV, msg
        if window == nil then
          return 
        end
        local CommonRewardData = require("Game.CommonUI.CommonRewardData")
        local CRData = (CommonRewardData.CreateCRDataUseDic)(msg.rewards)
        window:AddAndTryShowReward(CRData)
      end
)
      end
    end

    local historyMaxScore = (self.__dunLevelData):GetSctIIChallengeDgMaxScore()
    UIManager:ShowWindowAsync(UIWindowTypeID.WCDebuffResult, function(window)
      -- function num : 0_30_0_1 , upvalues : msg, historyMaxScore, showRewardFunc, _ENV
      if window == nil then
        return 
      end
      window:InitWinChallengeScoreShow(msg, false, historyMaxScore, showRewardFunc)
      ;
      (UIUtil.HideTopStatus)()
    end
)
  end
)
    end
  end
end

UINDunLevelDetail.OnClickUnlock = function(self)
  -- function num : 0_31 , upvalues : DungeonLevelEnum, _ENV
  local dungeonType = (self.__dunLevelData):GetDungeonLevelType()
  if dungeonType == (DungeonLevelEnum.DunLevelType).ADC then
    (self.__dunLevelData):ReqADCDunUnlock(function()
    -- function num : 0_31_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:_UpdBattleBtn(false)
      self:__RefreshUnLockBtnState()
    end
  end
)
  end
end

UINDunLevelDetail.GetDNLevelDetailWidthAndDuration = function(self)
  -- function num : 0_32
  return ((self.transform).sizeDelta).x, ((self.ui).moveTween).duration
end

UINDunLevelDetail.PlayMoveTween = function(self, isShow)
  -- function num : 0_33 , upvalues : _ENV
  if isShow then
    if self.__isShow then
      return 
    end
    self.__isShow = true
    ;
    ((self.ui).moveTween):DOPlayForward()
    AudioManager:PlayAudioById(1033)
  else
    ;
    ((self.ui).moveTween):DOPlayBackwards()
    AudioManager:PlayAudioById(1034)
  end
  ;
  (UIUtil.AddOneCover)("DLevelDetailTween")
end

UINDunLevelDetail.__OnMoveTweenComplete = function(self)
  -- function num : 0_34 , upvalues : _ENV
  (UIUtil.CloseOneCover)("DLevelDetailTween")
end

UINDunLevelDetail.__OnMoveTweenRewind = function(self)
  -- function num : 0_35 , upvalues : _ENV
  (UIUtil.CloseOneCover)("DLevelDetailTween")
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  UIManager:HideWindow(UIWindowTypeID.DungeonLevelDetail)
  self.__isShow = false
end

UINDunLevelDetail.OnShow = function(self)
  -- function num : 0_36 , upvalues : base
  (base.OnShow)(self)
end

UINDunLevelDetail.OnHide = function(self)
  -- function num : 0_37 , upvalues : _ENV
  (UIUtil.CloseOneCover)("DLevelDetailTween")
end

UINDunLevelDetail.OnDelete = function(self)
  -- function num : 0_38 , upvalues : _ENV, base
  if self.__nodeDic ~= nil then
    for k,v in pairs(self.__nodeDic) do
      v:Delete()
    end
    self.__nodeDic = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINDunLevelDetail

