-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityHeroGrowController = class("ActivityHeroGrowController", ControllerBase)
local base = ControllerBase
local ActivityHeroGrow = require("Game.ActivityHeroGrow.ActivityHeroGrow")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local FmtEnum = require("Game.Formation.FmtEnum")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
ActivityHeroGrowController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._dataDic = {}
  self.__isFirst = true
  self.__TaskChangeCallback = BindCallback(self, self.__TaskChange)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self.__TaskCommitCallback = BindCallback(self, self.__TaskCommit)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__TaskCommitCallback)
  self.__OnItemChangeFunc = BindCallback(self, self.__OnItemChange)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemChangeFunc)
  self.__ListenPreCondtionFunc = BindCallback(self, self.__ListenPreCondtion)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__ListenPreCondtionFunc)
end

ActivityHeroGrowController.InitHeroGrow = function(self)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  if activityFrameCtrl == nil then
    error(" activityFrameCtrl is NIL ")
    return 
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  self._dataDic = {}
  for k,cfg in pairs(ConfigData.activity_hero) do
    local actId = cfg.id
    local id = activityFrameCtrl:GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).HeroGrow, actId)
    if id ~= nil then
      local actInfo = activityFrameCtrl:GetActivityFrameData(id)
      self:InitHeroGrowByAct(actInfo)
    end
  end
end

ActivityHeroGrowController.InitHeroGrowByAct = function(self, actInfo)
  -- function num : 0_2 , upvalues : ActivityHeroGrow
  if actInfo == nil or not actInfo:GetCouldShowActivity() then
    return 
  end
  local actId = actInfo:GetActId()
  if (self._dataDic)[actId] ~= nil then
    return 
  end
  local data = (ActivityHeroGrow.New)()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._dataDic)[actId] = data
  data:InitHeroGrowData(actInfo)
end

ActivityHeroGrowController.UpdateHeroGrow = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  self._activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  if self._activityFrameCtrl == nil then
    error(" activityFrameCtrl is NIL ")
    return 
  end
  for _,singleMsg in ipairs(msg) do
    self:UpdateHeroGrowSingle(singleMsg)
  end
  self.__isFirst = false
end

ActivityHeroGrowController.UpdateHeroGrowSingle = function(self, singleMsg)
  -- function num : 0_4 , upvalues : _ENV, ActivityFrameEnum, ActivityHeroGrow
  if self._activityFrameCtrl == nil then
    self._activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  end
  if self._activityFrameCtrl == nil then
    error(" activityFrameCtrl is NIL ")
    return 
  end
  local actId = singleMsg.actId
  local id = (self._activityFrameCtrl):GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).HeroGrow, actId)
  if id == nil then
    error("heroGrow activity is NIL " .. tostring(actId))
    return 
  end
  local actInfo = (self._activityFrameCtrl):GetActivityFrameData(id)
  if actInfo == nil then
    error("heroGrow activity is NIL " .. tostring(actId))
    return 
  end
  local data = (self._dataDic)[actId]
  if data == nil then
    data = (ActivityHeroGrow.New)()
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self._dataDic)[actId] = data
    data:InitHeroGrowData(actInfo)
  end
  data:UpdateHeroGrowData(singleMsg, self.__isFirst)
end

ActivityHeroGrowController.GetHeroGrowActivity = function(self, actId)
  -- function num : 0_5
  local actHeroData = (self._dataDic)[actId]
  if actHeroData == nil or not (actHeroData.actInfo):GetCouldShowActivity() then
    return nil
  end
  return actHeroData
end

ActivityHeroGrowController.GetHeroGrowActivityNoExchange = function(self, actId)
  -- function num : 0_6
  local actHeroData = (self._dataDic)[actId]
  if actHeroData == nil then
    return nil
  end
  if not actHeroData:IsActivityRunning() and not (actHeroData.actInfo):CanPreviewNoExchange() then
    return nil
  end
  return actHeroData
end

ActivityHeroGrowController.RefreshHeroGrowStateDailyFlush = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    if (data.actInfo):IsActivityOpen() then
      data:RefreshHeroGrowStateDailyFlush()
    end
  end
  MsgCenter:Broadcast(eMsgEventId.HeroGrowActivityTimePass)
end

ActivityHeroGrowController.GetHeroGrowDataBySectorId = function(self, sectorId)
  -- function num : 0_8 , upvalues : _ENV
  local actId = ((ConfigData.activity_hero).sectorMapping)[sectorId]
  if actId == nil then
    return nil, nil, false, false
  end
  local data = self:GetHeroGrowActivity(actId)
  if data == nil then
    return actId, nil, false, false
  end
  return actId, data, data:IsActivityRunning(), data:IsActivityOpen()
end

ActivityHeroGrowController.IsHeroGrowChallengeStage = function(self, sectorStageId)
  -- function num : 0_9 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[sectorStageId]
  if stageCfg == nil then
    return nil, false, false
  end
  return self:IsHeroGrowChallengeSector(stageCfg.sector)
end

ActivityHeroGrowController.IsHeroGrowChallengeSector = function(self, sectorId)
  -- function num : 0_10 , upvalues : _ENV
  local actId, actData, isRuning, isOpening = self:GetHeroGrowDataBySectorId(sectorId)
  if actId == nil then
    return nil, false, false
  end
  if actData == nil or not actData:GetHeroGrowCfg() then
    local activityHeroCfg = (ConfigData.activity_hero)[actId]
  end
  local isChallenge = activityHeroCfg ~= nil and activityHeroCfg.rechallenge_stage == sectorId
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroActivity) then
    return actId, isChallenge, false
  end
  if not isRuning then
    local canFight = not isChallenge
  end
  do return actId, isChallenge, canFight end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

ActivityHeroGrowController.OpenHeroGrowUI = function(self, heroGrowData, enterFunc, backCallback, selectSector, callback)
  -- function num : 0_11 , upvalues : SectorStageDetailHelper, _ENV
  local actId = heroGrowData:GetActId()
  local isVer2 = heroGrowData:IsHeroGrowVer2()
  local heroGrowCfg = heroGrowData:GetHeroGrowCfg()
  if selectSector ~= nil then
    if not (SectorStageDetailHelper.IsSectorNoCollide)(selectSector) then
      selectSector = nil
    else
      if heroGrowCfg.main_stage ~= selectSector and not heroGrowData:IsActivityRunning() then
        selectSector = nil
      end
    end
  end
  if not isVer2 then
    UIManager:ShowWindowAsync(UIWindowTypeID.CharacterDungeon, function(window)
    -- function num : 0_11_0 , upvalues : heroGrowData, enterFunc, backCallback, selectSector, callback
    if window == nil then
      return 
    end
    window:InitCharactorDungeonMain(heroGrowData, enterFunc, backCallback)
    if selectSector ~= nil then
      window:OnEnterHeroGrowSector(selectSector)
    end
    if callback ~= nil then
      callback()
    end
  end
)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.CharDunVer2, function(window)
    -- function num : 0_11_1 , upvalues : heroGrowData, enterFunc, backCallback, selectSector, callback
    if window == nil then
      return 
    end
    window:InitCharacterDungeon(heroGrowData, enterFunc, backCallback)
    if selectSector ~= nil then
      window:OnEnterCharDunSector(selectSector)
    end
    if callback ~= nil then
      callback()
    end
  end
)
  end
end

ActivityHeroGrowController.EnterHeroGrowDugeon = function(self, tmpDungeonLevelData, autoBattleCount)
  -- function num : 0_12 , upvalues : FmtEnum, _ENV, DungeonCenterUtil, DungeonInterfaceData
  local commonBattleFunc = nil
  local fmtModule = (FmtEnum.eFmtFromModule).HeroGrow
  local forbidSupport = autoBattleCount or 0 > 0
  local keyItemId = tmpDungeonLevelData:GetEnterLevelCost()
  local needKey = tmpDungeonLevelData:GetConsumeKeyNum()
  local judgeIsHaveEnoughTicket = function(dungeonLevelData, judgeReplay)
    -- function num : 0_12_0 , upvalues : _ENV
    local keyItemId = dungeonLevelData:GetEnterLevelCost()
    local needKey = dungeonLevelData:GetConsumeKeyNum()
    if judgeReplay then
      needKey = needKey * 2
    end
    if PlayerDataCenter:GetItemCount(keyItemId) < needKey then
      if judgeReplay then
        return false
      end
      local costItemName = dungeonLevelData:GetEnterLevelCostItemName()
      local actName = dungeonLevelData:GetDungeonActName()
      ;
      ((CS.MessageCommon).ShowMessageTips)((string.format)(ConfigData:GetTipContent(7101), costItemName, actName, costItemName))
      return false
    end
    do
      return true
    end
  end

  if autoBattleCount ~= nil and autoBattleCount > 0 then
    (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(autoBattleCount, false)
  end
  local enterFunc = function()
    -- function num : 0_12_1 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
    UIManager:HideWindow(UIWindowTypeID.SectorLevel)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_12_2 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    UIManager:ShowWindowOnly(UIWindowTypeID.SectorLevel)
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
  end

  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_12_3 , upvalues : tmpDungeonLevelData, judgeIsHaveEnoughTicket, commonBattleFunc
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = tmpDungeonLevelData
    end
    if not judgeIsHaveEnoughTicket(dungeonLevelData) then
      return 
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_12_4 , upvalues : judgeIsHaveEnoughTicket, _ENV, fmtModule, self, DungeonInterfaceData, startBattleFunc, needKey, keyItemId
    if not judgeIsHaveEnoughTicket(dungeonLevelData) then
      return 
    end
    local curSelectFormationId = curSelectFormationData.id
    local formationData = (PlayerDataCenter.formationDic)[curSelectFormationId]
    if formationData == nil then
      return 
    end
    BattleDungeonManager:SaveFormation(formationData)
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetLastFromModuleFmtId(fmtModule, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    BattleDungeonManager:InjectBattleWinEvent(function()
      -- function num : 0_12_4_0 , upvalues : _ENV, dungeonLevelData, curSelectFormationData
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroActivity, dungeonLevelData:GetDungeonLevelStageId(), curSelectFormationData.isHaveSupport, PlayerDataCenter.timestamp)
    end
)
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_12_4_1 , upvalues : dungeonLevelData, self
      local actId = dungeonLevelData:GetDungeonHeroGrowActId()
      self:__ReturnFromheroGrowBattle(actId, dungeonLevelData)
    end
)
    local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow, true)
    local stageId = dungeonLevelData:GetDungeonLevelStageId()
    local interfaceData = (DungeonInterfaceData.CreateHeroGrowInterface)(dungeonLevelData)
    interfaceData:SetDungeonReplayInfo(startBattleFunc, needKey, keyItemId)
    local farmDouble = false
    heroGrowCtrl:RequestEnterActSectorIIIDungeon(stageId, interfaceData, formationData, farmDouble, function()
      -- function num : 0_12_4_2 , upvalues : _ENV, dungeonLevelData, self, stageId, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      local actId = dungeonLevelData:GetDungeonHeroGrowActId()
      local data = (self._dataDic)[actId]
      if data ~= nil then
        data:SetHeroGrowDungeonBattle(stageId)
      end
      if callBack ~= nil then
        callBack()
      end
    end
)
  end

  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = tmpDungeonLevelData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId(fmtModule)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo(fmtModule, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleTicketItemId(keyItemId)):SetEnterBattleCostTicketNum(needKey)):SetFmtForbidSupport(forbidSupport)
  fmtCtrl:EnterFormation()
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ActivityHeroGrowController.RequestEnterActSectorIIIDungeon = function(self, stageId, interfaceData, formationData, isDouble, callBack)
  -- function num : 0_13 , upvalues : _ENV
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(stageId, formationData, nil, function(dataList)
    -- function num : 0_13_0 , upvalues : _ENV, interfaceData, callBack
    if dataList.Count == 0 then
      return 
    end
    local NtfEnterMsgData = dataList[0]
    BattleDungeonManager:RealEnterDungeon(NtfEnterMsgData, nil, interfaceData)
    NetworkManager:HandleDiff(NtfEnterMsgData.syncUpdateDiff)
    if callBack ~= nil then
      callBack()
    end
  end
, isDouble)
end

ActivityHeroGrowController.__ReturnFromheroGrowBattle = function(self, actId, dungeonLevelData)
  -- function num : 0_14 , upvalues : _ENV
  local actData = (self._dataDic)[actId]
  if actData == nil then
    return 
  end
  local loadMapUIFunc = function()
    -- function num : 0_14_0 , upvalues : _ENV, actData
    UIManager:ShowWindowAsync(UIWindowTypeID.CharDunVer2, function(win)
      -- function num : 0_14_0_0 , upvalues : _ENV, actData
      if win == nil then
        return 
      end
      win:SetCharDunSectorCallback(function()
        -- function num : 0_14_0_0_0 , upvalues : _ENV
        local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
        if aftertTeatmentCtrl ~= nil then
          aftertTeatmentCtrl:TeatmentBengin()
        end
      end
)
      win:InitCharacterDungeon(actData, function(sectorId, difficuty, stageCfg, extraCloseFunc, enterOverCallback)
        -- function num : 0_14_0_0_1 , upvalues : _ENV
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        if sectorCtrl ~= nil then
          sectorCtrl:__EnterSectorLevel(sectorId, difficuty, stageCfg, extraCloseFunc, enterOverCallback)
        end
      end
, function()
        -- function num : 0_14_0_0_2 , upvalues : _ENV
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        if sectorCtrl ~= nil then
          sectorCtrl:ResetToNormalState(false)
          sectorCtrl:PlaySectorBgm()
        end
      end
)
      win:OnEnterCharDunSector((actData:GetHeroGrowCfg()).main_stage)
    end
)
  end

  ;
  (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
    -- function num : 0_14_1 , upvalues : _ENV, loadMapUIFunc, dungeonLevelData
    local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
    sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMapUIFunc, nil, dungeonLevelData)
  end
)
end

ActivityHeroGrowController.RemoveHeroGrow = function(self, actId)
  -- function num : 0_15
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivityHeroGrowController.IsHaveHeroGrow = function(self)
  -- function num : 0_16 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHeroGrowController.__TaskChange = function(self, taskData)
  -- function num : 0_17 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for k,data in pairs(self._dataDic) do
    local taskDic = ((ConfigData.activity_hero).allTaskCollect)[k]
    if taskDic ~= nil and taskDic[taskData.id] ~= nil then
      data:RefreshHeroGrowDailyTaskComReddot()
    end
  end
end

ActivityHeroGrowController.__TaskCommit = function(self, taskCfg)
  -- function num : 0_18 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    local taskDic = ((ConfigData.activity_hero).allTaskCollect)[k]
    if taskDic ~= nil and taskDic[taskCfg.id] ~= nil then
      data:RefreshHeroGrowDailyTaskComReddot()
    end
  end
end

ActivityHeroGrowController.__OnItemChange = function(self, itemUpdate)
  -- function num : 0_19 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    local itemId = data:GetHeroGrowCostId()
    if itemUpdate[itemId] ~= nil then
      data:RefreshHeroGrowLvRewrdReddot()
    end
  end
end

ActivityHeroGrowController.__ListenPreCondtion = function(self, conditionId)
  -- function num : 0_20 , upvalues : CheckerTypeId, _ENV
  if conditionId == CheckerTypeId.CompleteStage or conditionId == CheckerTypeId.ActivityTask then
    for k,data in pairs(self._dataDic) do
      data:RefreshHeroGrowChallengeNewReddot()
    end
  end
end

ActivityHeroGrowController.OnDelete = function(self)
  -- function num : 0_21 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__TaskCommitCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__ListenPreCondtionFunc)
end

return ActivityHeroGrowController

