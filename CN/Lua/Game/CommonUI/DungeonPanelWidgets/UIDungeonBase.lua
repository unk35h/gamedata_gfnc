-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonBase = class("UIDungeonBase", UIBaseWindow)
local base = UIBaseWindow
local UIDungeonChapterList = require("Game.CommonUI.DungeonPanelWidgets.UIDungeonChapterList")
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
local UINDungeonMultRateBase = require("Game.CommonUI.DungeonPanelWidgets.UINDungeonMultRateBase")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local FmtEnum = require("Game.Formation.FmtEnum")
local cs_MessageCommon = CS.MessageCommon
local cs_ResLoader = CS.ResLoader
local CS_GSceneManager_Ins = (CS.GSceneManager).Instance
local util = require("XLua.Common.xlua_util")
local JumpManager = require("Game.Jump.JumpManager")
UIDungeonBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.resLoader = (cs_ResLoader.Create)()
  ;
  (UIUtil.SetTopStatus)(self, self.OnBack, table.emptytable)
  self.__onBattleStart = BindCallback(self, self.OnBattleStart)
  self.__onItemClick = BindCallback(self, self.OnSelectItemEvent)
  self.__onDailyLimitUpdate = BindCallback(self, self.OnDailyLimitUpdate)
  MsgCenter:AddListener(eMsgEventId.OnBattleDungeonLimitChange, self.__onDailyLimitUpdate)
  if (self.ui).btn_isDoubleInfo ~= nil then
    (UIUtil.AddButtonListener)((self.ui).btn_isDoubleInfo, self, self.OnClickDungeonDoubleInfo)
  end
  self.dungeonItemDic = {}
  self.selectDungeonData = nil
  self.selectDungeonItem = nil
  self.dungeonTypeUIEnum = nil
  self.__DungeonTimerId = TimerManager:StartTimer(1, self.OnTimerUpdate, self, false, nil, nil)
end

UIDungeonBase.OnShow = function(self)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.OnShow)(self)
  AudioManager:PlayAudioById(1088)
end

UIDungeonBase.InitDungeonType = function(self, dungeonTypeData, selectdungeonId, onBackCallback)
  -- function num : 0_2 , upvalues : _ENV
  self.dungeonTypeData = dungeonTypeData
  self.dungeonDataList = dungeonTypeData:GetDungeonDataList()
  if onBackCallback ~= nil then
    self.onBackCallback = onBackCallback
  end
  self:InitDungeonList()
  if selectdungeonId ~= nil then
    for _,dungeonData in ipairs(self.dungeonDataList) do
      if dungeonData:GetIsUnlock() and dungeonData:GetDungeonId() == selectdungeonId then
        self.selectDungeonData = dungeonData
        break
      end
    end
  end
  do
    if self.selectDungeonData == nil then
      for _,dungeonData in ipairs(self.dungeonDataList) do
        if dungeonData:GetIsUnlock() then
          self.selectDungeonData = dungeonData
          break
        end
      end
    end
    do
      self.selectDungeonItem = (self.dungeonItemDic)[self.selectDungeonData]
      self:ShowDungeonDetail(self.selectDungeonItem)
    end
  end
end

UIDungeonBase.OnDailyLimitUpdate = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for dungeonData,dungeonItem in pairs(self.dungeonItemDic) do
    if dungeonItem ~= nil then
      dungeonData:CleanCacheData()
      dungeonItem:UpdateDailyLimit()
    end
  end
  self:ShowDungeonDetail(self.selectDungeonItem)
end

UIDungeonBase.InitDungeonList = function(self, UIDungeonItemClass)
  -- function num : 0_4 , upvalues : _ENV
  self.dungeonItemPool = (UIItemPool.New)(UIDungeonItemClass, (self.ui).tog_DungeonItem)
  ;
  ((self.ui).tog_DungeonItem):SetActive(false)
  for _,dungeonData in ipairs(self.dungeonDataList) do
    if dungeonData ~= nil then
      local item = (self.dungeonItemPool):GetOne()
      item:InitDungeonItem(dungeonData, self.resLoader, self.__onItemClick)
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.dungeonItemDic)[dungeonData] = item
    end
  end
end

UIDungeonBase.OnSelectItemEvent = function(self, item)
  -- function num : 0_5 , upvalues : _ENV
  (self.selectDungeonItem):OnSelectDisplay(false)
  self.selectDungeonData = item.dungeonData
  self.selectDungeonItem = (self.dungeonItemDic)[self.selectDungeonData]
  local auId = ((item.dungeonData):GetDungeonCfg()).click_audio
  if auId ~= 0 then
    AudioManager:PlayAudioById(auId)
  end
  self:ShowDungeonDetail(item)
end

UIDungeonBase.ShowDungeonDetail = function(self, item)
  -- function num : 0_6 , upvalues : UINDungeonMultRateBase
  if (item.dungeonData):GetIsHaveMultReward() then
    if self.multRateBase == nil then
      self.multRateBase = (UINDungeonMultRateBase.New)()
      ;
      (self.multRateBase):Init((self.ui).isDoubleOrDropUp)
    end
    ;
    (self.multRateBase):Show()
    ;
    (self.multRateBase):InitMultRate(item.dungeonData)
    self:__SetDoubleInfoActive(false)
  else
    if self.multRateBase ~= nil then
      (self.multRateBase):Hide()
    else
      ;
      ((self.ui).isDoubleOrDropUp):SetActive(false)
    end
    self:__SetDoubleInfoActive((item.dungeonData):IsDungeonHasDoubleReward())
  end
  self:InitDungeonStages(item.dungeonData)
  item:OnSelectDisplay(true)
end

UIDungeonBase.__SetDoubleInfoActive = function(self, active)
  -- function num : 0_7
  if (self.ui).btn_isDoubleInfo ~= nil then
    (((self.ui).btn_isDoubleInfo).gameObject):SetActive(active)
  end
end

UIDungeonBase.OnClickDungeonDoubleInfo = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.selectDungeonData == nil then
    return 
  end
  local dungeonCfg = (self.selectDungeonData):GetDungeonCfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_8_0 , upvalues : dungeonCfg
    if window == nil then
      return 
    end
    window:InitDungeonDropInfo(dungeonCfg.ui_type)
  end
)
end

UIDungeonBase.InitDungeonStages = function(self, dungeonData, UIDungeonStageClass)
  -- function num : 0_9 , upvalues : _ENV, UIDungeonChapterList, UINBaseItem
  local resource_top = {}
  for k,v in pairs((dungeonData:GetDungeonCfg()).resource_top) do
    resource_top[k] = v
  end
  ;
  (table.insert)(resource_top, ConstGlobalItem.SKey)
  if not self.active then
    return 
  end
  ;
  (UIUtil.RefreshTopResId)(resource_top)
  if self.chaptersUI == nil then
    self.chaptersUI = (UIDungeonChapterList.New)()
    ;
    (self.chaptersUI):Init((self.ui).levelRewardNode)
  end
  if self.dungeonStageItemPool == nil or self.fstRewardItemPool == nil or self.mbRewardItemPool == nil then
    self.dungeonStageItemPool = (self.chaptersUI):CreatePool(UIDungeonStageClass, UINBaseItem, UINBaseItem)
  end
  ;
  (self.dungeonStageItemPool):HideAll()
  ;
  (self.fstRewardItemPool):HideAll()
  ;
  (self.mbRewardItemPool):HideAll()
  for index,dungeonStageData in ipairs(dungeonData:GetDungeonStageList()) do
    local item = (self.dungeonStageItemPool):GetOne()
    item:InitWithStageData(dungeonStageData, index, self.fstRewardItemPool, self.mbRewardItemPool)
  end
  self:RegularDungeonStageSpace(#(self.dungeonStageItemPool).listItem)
  ;
  (self.chaptersUI):UpdateWithChapterList((self.dungeonStageItemPool).listItem, dungeonData, self.__onBattleStart)
end

local spacingDic = {[6] = 84.5, [8] = 15.5}
UIDungeonBase.RegularDungeonStageSpace = function(self, num)
  -- function num : 0_10 , upvalues : spacingDic
  local space = spacingDic[num]
  if space == nil then
    local a = spacingDic[8] - spacingDic[6] / 2
    local b = spacingDic[6] - a * 6
    space = a * num + b
  end
  do
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.chaptersUI).ui).layout_Level).spacing = space
  end
end

UIDungeonBase.OnBattleStart = function(self, autoBattleCount)
  -- function num : 0_11 , upvalues : _ENV, cs_MessageCommon, JumpManager, CS_GSceneManager_Ins, DungeonInterfaceData
  self.dungeonStageItem = (self.chaptersUI).selectChapterItem
  local dungeonData = self.selectDungeonData
  local dungeonStageData = (self.dungeonStageItem).dungeonStageData
  if dungeonStageData:IsHaveATHReward() and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
    return 
  end
  if dungeonData:GetDungeonPlayLeftLimitNum() == 0 then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.BattleDungeon_DailyLimit))
    return 
  end
  if dungeonStageData:GetIsReach2Limit() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.BattleDungeon_DailyLimit))
    return 
  end
  for id,count in pairs(dungeonStageData:GetNormalCostItemDic()) do
    if id ~= ConstGlobalItem.SKey and count ~= nil and count > 0 then
      local itemNum = PlayerDataCenter:GetItemCount(id)
      if itemNum < count then
        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Item_NotReach))
        return 
      end
    end
  end
  local enterFormationFunc = function()
    -- function num : 0_11_0 , upvalues : _ENV, self
    (ControllerManager:GetController(ControllerTypeId.SectorController)):EnbleSectorUI3D(false)
    UIManager:HideWindow(self.dungeonTypeUIEnum)
    UIManager:HideWindow(UIWindowTypeID.Sector)
  end

  local exitFormationFunc = function()
    -- function num : 0_11_1 , upvalues : _ENV, self
    (ControllerManager:GetController(ControllerTypeId.SectorController)):EnbleSectorUI3D(true)
    UIManager:ShowWindowOnly(self.dungeonTypeUIEnum)
    UIManager:ShowWindowOnly(UIWindowTypeID.Sector)
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
  end

  local startBattleFunc = nil
  startBattleFunc = function(curSelectFormationData, callBack)
    -- function num : 0_11_2 , upvalues : dungeonStageData, _ENV, cs_MessageCommon, JumpManager, dungeonData, self, CS_GSceneManager_Ins, DungeonInterfaceData, startBattleFunc
    if dungeonStageData:IsHaveATHReward() and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
      return 
    end
    if (PlayerDataCenter.stamina):GetCurrentStamina() < dungeonStageData:GetStaminaCost() then
      JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
      return 
    end
    local curSelectFormationId = curSelectFormationData.id
    local formationData = (PlayerDataCenter.formationDic)[curSelectFormationId]
    if formationData == nil then
      return 
    end
    BattleDungeonManager:SaveFormation(formationData)
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetLastFormationId(dungeonData:GetDungeonId(), curSelectFormationId)
    saveUserData:SetLastDungeonStageId(dungeonData:GetDungeonId(), dungeonStageData:GetDungeonStageId())
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    local afterBattleWinEvent = BindCallback(self, self.AfterBattleWin, self.dungeonStageItem, self.selectDungeonItem)
    BattleDungeonManager:InjectBattleWinEvent(afterBattleWinEvent)
    self.__startDungeonBattleTS = PlayerDataCenter.timestamp
    BattleDungeonManager:InjectBattleExitEvent(BindCallback(self, function()
      -- function num : 0_11_2_0 , upvalues : _ENV, self, dungeonData, CS_GSceneManager_Ins
      local loadMatUIFunc = BindCallback(self, function()
        -- function num : 0_11_2_0_0 , upvalues : _ENV, self, dungeonData
        UIManager:ShowWindowAsync(self.dungeonTypeUIEnum, function(window)
          -- function num : 0_11_2_0_0_0 , upvalues : _ENV, self, dungeonData
          if window == nil then
            return 
          end
          local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
          local newDungeonTypeData = (sectorCtrl.dungeonTypeDataDic)[(self.dungeonTypeData).dungeonType]
          window:InitDungeonType(newDungeonTypeData, dungeonData:GetDungeonId(), function(tohome)
            -- function num : 0_11_2_0_0_0_0 , upvalues : sectorCtrl
            sectorCtrl:ResetToNormalState(tohome)
          end
)
          ;
          (UIUtil.CloseOneCover)("loadMatUIFunc")
          local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
          if aftertTeatmentCtrl ~= nil then
            aftertTeatmentCtrl:TeatmentBengin()
          end
        end
)
        self.StartLoadDungeon = false
      end
)
      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      CS_GSceneManager_Ins:LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_11_2_0_1 , upvalues : _ENV, loadMatUIFunc, dungeonData
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        ;
        (UIUtil.AddOneCover)("loadMatUIFunc")
        sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMatUIFunc, nil, dungeonData)
        sectorCtrl:OnEnterPlotOrMateralDungeon()
      end
)
    end
, self.selectItemId))
    local interfaceData = (DungeonInterfaceData.CreateDefaultBattleInterface)()
    interfaceData:BindDungeonStageData(dungeonStageData, startBattleFunc)
    interfaceData:SetDIDExtraDrop(self:GetDgDropBuffActive())
    interfaceData:SetAutoDecompose(self:GetDecomposeActive())
    local firstPower, benchPower = nil, nil
    local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, false)
    if fmtCtrl ~= nil then
      firstPower = fmtCtrl:CalculatePower(formationData)
    end
    BattleDungeonManager:RequestEnterDungeon(((self.dungeonStageItem).cfg).id, formationData, interfaceData, function()
      -- function num : 0_11_2_1 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
, firstPower, benchPower)
  end

  local firstEnterStartBattleFunc = function(curSelectFormationData, callBack)
    -- function num : 0_11_3 , upvalues : dungeonStageData, _ENV, cs_MessageCommon, startBattleFunc
    if dungeonStageData:IsHaveATHReward() and (ConfigData.game_config).athMaxNum - (ConfigData.game_config).athSpaceNotEnoughNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
      (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(145), function()
      -- function num : 0_11_3_0 , upvalues : startBattleFunc, curSelectFormationData, callBack
      startBattleFunc(curSelectFormationData, callBack)
    end
, nil)
    else
      startBattleFunc(curSelectFormationData, callBack)
    end
  end

  self:EnterFormation(dungeonData, enterFormationFunc, exitFormationFunc, firstEnterStartBattleFunc, autoBattleCount)
end

UIDungeonBase.SetDgDropBuffActive = function(self, dungeonType, active)
  -- function num : 0_12 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetDungeonDropBuffActive(dungeonType, active)
end

UIDungeonBase.GetDgDropBuffActive = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local dungeonCfg = (self.selectDungeonData):GetDungeonCfg()
  local dungeonType = dungeonCfg.dungeon_type
  local dropId = ((ConfigData.battle_dungeon_period_drop).dgTypeDic)[dungeonCfg.dungeon_type]
  if dropId == nil then
    return false
  end
  local dropCfg = (ConfigData.battle_dungeon_period_drop)[dropId]
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleGlobalDailyFlush, 0)
  if counterElem ~= nil then
    local nextExpiredTm = counterElem.nextExpiredTm
    local lastResetTm = saveUserData:GetDungeonDropBuffLastResetTm()
    if lastResetTm < nextExpiredTm then
      saveUserData:SetDungeonDropBuffLastResetTm(nextExpiredTm)
      saveUserData:SetDungeonDropBuffActive(dungeonType, false)
    end
  end
  do
    local useNum = (ControllerManager:GetController(ControllerTypeId.TimePass)):GetDungeonPeriodDropTimes(dropCfg.save_id)
    local remainNum = dropCfg.drop_times - useNum
    if remainNum <= 0 then
      return false
    end
    return saveUserData:GetDungeonDropBuffActive(dungeonType)
  end
end

UIDungeonBase.SetDecomposeActive = function(self, active)
  -- function num : 0_14 , upvalues : _ENV
  if self:GetDecomposeActive() ~= active then
    (PlayerDataCenter.gameSettingData):SetGSSetting(GameSettingConsts.autoDecoAth, active)
  end
end

UIDungeonBase.GetDecomposeActive = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local setting = (PlayerDataCenter.gameSettingData):GetSetting()
  if setting == nil then
    return false
  end
  return setting[GameSettingConsts.autoDecoAth] or false
end

UIDungeonBase.EnterFormation = function(self, dungeonData, enterFormationFunc, exitFormationFunc, startBattleFunc, autoBattleCount)
  -- function num : 0_16 , upvalues : _ENV, FmtEnum
  local forbidSupport = autoBattleCount or 0 > 0
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFormationId(dungeonData:GetDungeonId())
  if autoBattleCount or 0 > 0 then
    (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(autoBattleCount)
  end
  fmtCtrl:ResetFmtCtrlState()
  ;
  ((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).MaterialDungeon, ((self.dungeonStageItem).cfg).id, lastFmtId)):SetFmtCtrlCallback(enterFormationFunc, exitFormationFunc, startBattleFunc)):SetEnterBattleCostTicketNum((self.dungeonStageItem).costStrengthNum)):SetFmtForbidSupport(forbidSupport)
  fmtCtrl:EnterFormation()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIDungeonBase.AfterBattleWin = function(self, dungeonStageItem, selectDungeonItem, hasSupport)
  -- function num : 0_17 , upvalues : _ENV
  PlayerDataCenter:LocallyAddDungeonLimit((selectDungeonItem.dungeonData):GetDungeonId(), dungeonStageItem.chapterId, hasSupport, self.__startDungeonBattleTS)
  ;
  (self.dungeonTypeData):UpdateDungeonAndStageUnlock()
end

UIDungeonBase.OnTimerUpdate = function(self)
  -- function num : 0_18
  if self.multRateBase ~= nil and (self.multRateBase).active then
    (self.multRateBase):UpdateLeftTime()
  end
end

UIDungeonBase.OnBack = function(self, toHome)
  -- function num : 0_19 , upvalues : base
  if self.onBackCallback ~= nil then
    (self.onBackCallback)(toHome)
  end
  ;
  (base.Delete)(self)
end

UIDungeonBase.OnDelete = function(self)
  -- function num : 0_20 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnBattleDungeonLimitChange, self.__onDailyLimitUpdate)
  if self.__DungeonTimerId ~= nil then
    TimerManager:StopTimer(self.__DungeonTimerId)
    self.__DungeonTimerId = nil
  end
  if self.__loadDungeonCoroutine ~= nil and self.StartLoadDungeon then
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    ;
    (GR.StopCoroutine)(self.__loadDungeonCoroutine)
    self.StartLoadDungeon = false
    self.__loadDungeonCoroutine = nil
  end
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
  end
  if self.chaptersUI ~= nil then
    (self.chaptersUI):Delete()
  end
  PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  local saveDataController = ControllerManager:GetController(ControllerTypeId.Setting, true)
  saveDataController:TryReqSaveGameSettingData()
  ;
  (base.OnDelete)(self)
end

return UIDungeonBase

