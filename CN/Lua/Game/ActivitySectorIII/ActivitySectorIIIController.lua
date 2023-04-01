-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySectorIIIController = class("ActivitySectorIIIController", ControllerBase)
local base = ControllerBase
local FmtEnum = require("Game.Formation.FmtEnum")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local ActivitySectorIIIData = require("Game.ActivitySectorIII.ActivitySectorIIIData")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
ActivitySectorIIIController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dataDic = {}
  self._OnItemChangeFunc = BindCallback(self, self._OnItemChange)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskChange)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self.__TaskCommitCallback = BindCallback(self, self.__TaskCommit)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__TaskCommitCallback)
  self.__ListenPreCondtion = BindCallback(self, self.ListenPreCondtion)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__ListenPreCondtion)
  self.__ListenAvgPlayed = BindCallback(self, self.ListenAvgPlayed)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__ListenAvgPlayed)
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActivitySectorIIIController.InitSectorIIIData = function(self, msgs)
  -- function num : 0_1 , upvalues : _ENV
  for i,msg in ipairs(msgs) do
    self:UpdateSectorIIIAct(msg)
  end
end

ActivitySectorIIIController.UpdateSectorIIIAct = function(self, msg)
  -- function num : 0_2 , upvalues : ActivitySectorIIIData
  if (self._dataDic)[msg.actId] ~= nil then
    ((self._dataDic)[msg.actId]):UpdateSectorIIIData(msg)
  else
    local data = (ActivitySectorIIIData.New)()
    data:InitSectorIIIData(msg)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._dataDic)[msg.actId] = data
    local expireTm = data:GetSum22TechNextRefreshTime()
    if data:GetActSectorIIIExpireTime() < expireTm then
      expireTm = data:GetActSectorIIIExpireTime()
    end
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), expireTm + 1, self.__ExpireDealCallback)
  end
end

ActivitySectorIIIController.RemoveSectorIIIData = function(self, actId)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivitySectorIIIController.GetSectorIIIAct = function(self, actId)
  -- function num : 0_4
  return (self._dataDic)[actId]
end

ActivitySectorIIIController.GetOneSectorIIIAct = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    do return v end
  end
end

ActivitySectorIIIController.IsHaveSectorIIIAct = function(self)
  -- function num : 0_6 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySectorIIIController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_7 , upvalues : _ENV
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self._dataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  local actFrameNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  actFrameNetwork:CS_ACTIVITY_SingleConcreteInfo(data:GetActFrameId(), function()
    -- function num : 0_7_0 , upvalues : data, self, _ENV
    local expireTm = data:GetSum22TechNextRefreshTime()
    if data:GetActSectorIIIExpireTime() < expireTm then
      expireTm = data:GetActSectorIIIExpireTime()
    end
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), expireTm + 1, self.__ExpireDealCallback)
    MsgCenter:Broadcast(eMsgEventId.ActivitySectorIIIDayTimeout)
  end
)
end

ActivitySectorIIIController.__TaskChange = function(self, taskData)
  -- function num : 0_8 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for k,data in pairs(self._dataDic) do
    data:RefreshSectorIIITaskReddot()
  end
end

ActivitySectorIIIController.__TaskCommit = function(self, taskCfg)
  -- function num : 0_9 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    data:RefreshSectorIIITaskReddot()
  end
end

ActivitySectorIIIController.TryEnterSectorIII = function(self, actId, sectorId, closeCallback)
  -- function num : 0_10 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22Main, function(win)
    -- function num : 0_10_0 , upvalues : data, closeCallback, sectorId
    if win == nil then
      return 
    end
    win:InitSum22Main(data, closeCallback)
    if sectorId ~= nil then
      win:SelectSum22Sector(sectorId)
    end
  end
)
end

ActivitySectorIIIController.ReqSum22RefreshTechSelect = function(self, actId, callBack)
  -- function num : 0_11 , upvalues : _ENV
  self._RefreshTechActId = actId
  self._onRefreshTechFunc = callBack
  if not self._OnSum22RefreshTechSelectFunc then
    self._OnSum22RefreshTechSelectFunc = BindCallback(self, self.OnSum22RefreshTechSelect)
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ActivityTech_Refresh(actId, self._OnSum22RefreshTechSelectFunc)
  end
end

ActivitySectorIIIController.OnSum22RefreshTechSelect = function(self)
  -- function num : 0_12
  if self._onRefreshTechFunc ~= nil then
    (self._onRefreshTechFunc)()
  end
end

ActivitySectorIIIController.ReqSum22TechSelect = function(self, techData, callBack)
  -- function num : 0_13 , upvalues : _ENV
  local actId = techData:GetTechActId()
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ActivityTech_Upgrade(techData:GetActFrameId(), techData:GetTechId(), function(args)
    -- function num : 0_13_0 , upvalues : _ENV, self, actId, callBack, techData
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local upgradedTechElement = args[0]
    local sumData = self:GetSectorIIIAct(actId)
    for i,elemt in ipairs(upgradedTechElement) do
      local techData = sumData:GetSum22TechDataById(elemt.id)
      if techData ~= nil then
        local oldLevel = techData:GetCurLevel()
        techData:UpdateWATechByMsg(elemt)
        local curLevel = techData:GetCurLevel()
        if oldLevel ~= curLevel then
          sumData:Sum22TechLevelUpInstallBonus(techData, oldLevel, curLevel)
        end
      end
    end
    if callBack ~= nil then
      callBack(techData)
    end
  end
)
end

ActivitySectorIIIController.EnterActSectorIIIDungeonFormation = function(self, tmpDungeonLevelData, autoBattleCount)
  -- function num : 0_14 , upvalues : FmtEnum, _ENV, DungeonCenterUtil, DungeonInterfaceData
  local commonBattleFunc = nil
  local fmtModule = (FmtEnum.eFmtFromModule).ActSectorIIIDun
  local forbidSupport = autoBattleCount or 0 > 0
  local judgeIsHaveEnoughTicket = function(dungeonLevelData, judgeReplay)
    -- function num : 0_14_0 , upvalues : _ENV
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

  local enterFunc = function()
    -- function num : 0_14_1 , upvalues : autoBattleCount, _ENV, DungeonCenterUtil
    if autoBattleCount ~= nil and autoBattleCount > 0 then
      (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(autoBattleCount, false)
    end
    ;
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
    UIManager:HideWindow(UIWindowTypeID.ActSum22DunRepeat)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_14_2 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    UIManager:ShowWindowOnly(UIWindowTypeID.ActSum22DunRepeat)
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
  end

  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_14_3 , upvalues : tmpDungeonLevelData, judgeIsHaveEnoughTicket, commonBattleFunc
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
    -- function num : 0_14_4 , upvalues : judgeIsHaveEnoughTicket, _ENV, fmtModule, self, DungeonInterfaceData, startBattleFunc
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
      -- function num : 0_14_4_0 , upvalues : _ENV, dungeonLevelData, curSelectFormationData
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivitySummer22, dungeonLevelData:GetDungeonLevelStageId(), curSelectFormationData.isHaveSupport, PlayerDataCenter.timestamp)
    end
)
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_14_4_1 , upvalues : dungeonLevelData, self
      local actId = dungeonLevelData:GetDungeonLevelActId()
      self:_ReturnFromSectorIIIBattle(actId, dungeonLevelData)
    end
)
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII, true)
    local stageId = dungeonLevelData:GetDungeonLevelStageId()
    local interfaceData = (DungeonInterfaceData.CreateActIIIDunInterface)(dungeonLevelData)
    local actData = dungeonLevelData:GetSectorIIIActivityData()
    local farmDouble = false
    if actData ~= nil then
      farmDouble = actData:SectorIII_IsFarmDouble()
    end
    if judgeIsHaveEnoughTicket(dungeonLevelData, true) then
      local keyItemId = dungeonLevelData:GetEnterLevelCost()
      local needKey = dungeonLevelData:GetConsumeKeyNum()
      interfaceData:SetDungeonReplayInfo(startBattleFunc, needKey, keyItemId)
    end
    do
      sectorIICtrl:RequestEnterActSectorIIIDungeon(stageId, interfaceData, formationData, farmDouble, function()
      -- function num : 0_14_4_2 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
)
    end
  end

  local keyItemId = tmpDungeonLevelData:GetEnterLevelCost()
  local needKey = tmpDungeonLevelData:GetConsumeKeyNum()
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = tmpDungeonLevelData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId(fmtModule)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo(fmtModule, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleTicketItemId(keyItemId)):SetEnterBattleCostTicketNum(needKey)):SetFmtForbidSupport(forbidSupport)
  fmtCtrl:EnterFormation()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySectorIIIController.RequestEnterActSectorIIIDungeon = function(self, stageId, interfaceData, formationData, isDouble, callBack)
  -- function num : 0_15 , upvalues : _ENV
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(stageId, formationData, nil, function(dataList)
    -- function num : 0_15_0 , upvalues : _ENV, interfaceData, callBack
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

ActivitySectorIIIController._ReturnFromSectorIIIBattle = function(self, actId, dungeonLevelData)
  -- function num : 0_16 , upvalues : _ENV
  local actData = self:GetSectorIIIAct(actId)
  if actData == nil then
    return 
  end
  local loadMapUIFunc = function()
    -- function num : 0_16_0 , upvalues : _ENV, actData
    UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22Main, function(win)
      -- function num : 0_16_0_0 , upvalues : actData, _ENV
      if win == nil then
        return 
      end
      win:InitSum22Main(actData, function()
        -- function num : 0_16_0_0_0 , upvalues : _ENV
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        if sectorCtrl ~= nil then
          sectorCtrl:ResetToNormalState(toHome)
          sectorCtrl:PlaySectorBgm()
        end
      end
)
      win:OnClickRepeatLevel()
    end
)
    local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
    if aftertTeatmentCtrl ~= nil then
      aftertTeatmentCtrl:TeatmentBengin()
    end
  end

  ;
  (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
    -- function num : 0_16_1 , upvalues : _ENV, loadMapUIFunc, dungeonLevelData
    local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
    sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMapUIFunc, nil, dungeonLevelData)
  end
)
end

ActivitySectorIIIController._OnItemChange = function(self, itemDic)
  -- function num : 0_17 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    if itemDic[data:GetSectorIIIDunPointId()] ~= nil then
      data:UpdActSum22TechRedDot()
    end
  end
end

ActivitySectorIIIController.ListenPreCondtion = function(self, conditionId)
  -- function num : 0_18 , upvalues : CheckerTypeId, _ENV
  if conditionId == CheckerTypeId.CompleteStage then
    for k,data in pairs(self._dataDic) do
      data:RefreshSectorIIIMapReddot()
    end
  end
end

ActivitySectorIIIController.ListenAvgPlayed = function(self)
  -- function num : 0_19 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    data:RefreshSectorIIIMapReddot()
  end
end

ActivitySectorIIIController.IsHardLevel = function(self, challgeId)
  -- function num : 0_20 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    local mainCfg = data:GetSectorIIIMainCfg()
    if (mainCfg.hard_rank1)[1] == challgeId then
      return true
    end
    if (mainCfg.hard_rank2)[1] == challgeId then
      return true
    end
  end
  return false
end

ActivitySectorIIIController.GetHardLevelRankId = function(self, challgeId)
  -- function num : 0_21 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    local mainCfg = data:GetSectorIIIMainCfg()
    if (mainCfg.hard_rank1)[1] == challgeId then
      return (mainCfg.hard_rank1)[2]
    end
    if (mainCfg.hard_rank2)[1] == challgeId then
      return (mainCfg.hard_rank2)[2]
    end
  end
  return nil
end

ActivitySectorIIIController.GetHardLevelScore = function(self, challgeId)
  -- function num : 0_22 , upvalues : _ENV
  for k,data in pairs(self._dataDic) do
    local hardScores = data:GetActSectorIIIHardDungeonScore()
    if hardScores[challgeId] ~= nil then
      return (hardScores[challgeId]).score
    end
  end
  return 0
end

ActivitySectorIIIController.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__TaskCommitCallback)
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__ListenPreCondtion)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__ListenAvgPlayed)
end

return ActivitySectorIIIController

