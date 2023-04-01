-- params : ...
-- function num : 0 , upvalues : _ENV
local base = ControllerBase
local ActivitySectorIICtrl = class("ActivitySectorIICtrl", base)
local ActivitySectorIIData = require("Game.ActivitySectorII.ActivitySectorIIData")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local FmtEnum = require("Game.Formation.FmtEnum")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
local CS_GSceneManager_Ins = (CS.GSceneManager).Instance
ActivitySectorIICtrl.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__sectorIINetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.DungeonSectorII)
  self.__SectorIIDataDic = {}
  self.__SectorIIDataSectorIdDic = {}
  self.__onTaskUpdate = BindCallback(self, self.__OnTaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskSyncFinish, self.__onTaskUpdate)
  self.__onDungeonLimitChange = BindCallback(self, self.__OnDungeonLimitChange)
  MsgCenter:AddListener(eMsgEventId.OnBattleDungeonLimitChange, self.__onDungeonLimitChange)
  MsgCenter:AddListener(eMsgEventId.ExplorationExit, self.__onDungeonLimitChange)
  self.__onItemUpdate = BindCallback(self, self.__OnItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__onItemUpdate)
  self.__onDungeonBattleTimeChange = BindCallback(self, self.__OnDungeonBattleTimeChange)
  MsgCenter:AddListener(eMsgEventId.OnBattleDungeonLimitInit, self.__onDungeonBattleTimeChange)
end

ActivitySectorIICtrl.OnSectorIIActivityOpen = function(self, actId)
  -- function num : 0_1 , upvalues : ActivitySectorIIData
  if (self.__SectorIIDataDic)[actId] ~= nil then
    return 
  end
  local actSectorIIData = (ActivitySectorIIData.New)()
  actSectorIIData:InitActSectorIIData(actId)
  local sectorId = actSectorIIData:GetSectorIISectorId()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__SectorIIDataDic)[actId] = actSectorIIData
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__SectorIIDataSectorIdDic)[sectorId] = actSectorIIData
end

ActivitySectorIICtrl.OnSectorIIActivityClose = function(self, actId)
  -- function num : 0_2 , upvalues : _ENV
  local actSectorIIData = (self.__SectorIIDataDic)[actId]
  local sectorId = actSectorIIData:GetSectorIISectorId()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__SectorIIDataDic)[actId] = nil
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__SectorIIDataSectorIdDic)[sectorId] = nil
  if (table.count)(self.__SectorIIDataDic) <= 0 then
    ControllerManager:DeleteController(ControllerTypeId.SectorII)
  end
end

ActivitySectorIICtrl.UpdataSectorIIActivityByMsg = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  for _,elem in pairs(msg) do
    self:UpdataSectorIIActivityBySingleMsg(elem)
  end
end

ActivitySectorIICtrl.UpdataSectorIIActivityBySingleMsg = function(self, elem)
  -- function num : 0_4
  local actId = elem.actId
  local tech = elem.tech
  local bird = elem.bird
  local dungeonSuits = elem.dungeonSuits
  local sectorIIData = self:GetSectorIIDataByActId(actId)
  if sectorIIData == nil then
    return 
  end
  local actTechDataDic = sectorIIData:RefreshAWTechDatas(tech)
  self:InstallAllTechBonus(actTechDataDic)
  sectorIIData:SetSectorIIBirdData(bird)
  sectorIIData:SetSectorIIDungeonSuitData(dungeonSuits)
  sectorIIData:UpdSctIIWinChallengeData(elem.verify)
  sectorIIData:OnSectorIIMsgInitOver()
  sectorIIData:UpdateActFrameDataSingleMsg(elem)
end

ActivitySectorIICtrl.UpdSectorIIActivityByDiff = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV
  local elem = msg.data
  local sectorIIData = self:GetSectorIIDataByActId(elem.actId)
  if sectorIIData == nil then
    error("Cant get sectorIIData, actId:" .. tostring(elem.actId))
    return 
  end
  sectorIIData:UpdSctIIWinChallengeData(elem.verify)
end

ActivitySectorIICtrl.TryEnterSectorIIWin = function(self, sectorId, actId)
  -- function num : 0_6 , upvalues : _ENV
  local sectorIIData = nil
  if sectorId ~= nil then
    sectorIIData = self:GetSectorIIDataBySectorId(sectorId)
    if sectorIIData ~= nil then
      actId = sectorIIData:GetSectorIIActId()
    end
  else
    if actId ~= nil then
      sectorIIData = self:GetSectorIIDataByActId(actId)
    end
  end
  if sectorIIData == nil then
    return false
  end
  local callback = function()
    -- function num : 0_6_0 , upvalues : _ENV, actId
    UIManager:ShowWindowAsync(UIWindowTypeID.ActivityWinterMainMap, function(win)
      -- function num : 0_6_0_0 , upvalues : actId
      if win ~= nil then
        win:InitWAMainMap(actId)
      end
    end
)
  end

  local avgId = sectorIIData:GetSectorIIFirstEnterAvgId()
  if avgId ~= nil and avgId > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed(avgId)
    if not played and sectorIIData:IsActivityRunning() then
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId, callback)
    else
      callback()
    end
  end
  do
    return true
  end
end

ActivitySectorIICtrl._ReturnFromBattle = function(self, actId, dungeonLevelData)
  -- function num : 0_7 , upvalues : _ENV
  local loadMapUIFunc = function()
    -- function num : 0_7_0 , upvalues : _ENV, actId
    UIManager:ShowWindowAsync(UIWindowTypeID.ActivityWinterMainMap, function(window)
      -- function num : 0_7_0_0 , upvalues : _ENV, actId
      if window == nil then
        return 
      end
      window:SetWADungeonCallBack(function()
        -- function num : 0_7_0_0_0 , upvalues : _ENV
        local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
        if aftertTeatmentCtrl ~= nil then
          aftertTeatmentCtrl:TeatmentBengin()
        end
      end
)
      window:InitWAMainMap(actId, true)
      window:OnClickWADungeon()
    end
)
  end

  ;
  (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
    -- function num : 0_7_1 , upvalues : _ENV, loadMapUIFunc, dungeonLevelData, self, actId
    local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
    sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMapUIFunc, nil, dungeonLevelData)
    local SectorIIData = self:GetSectorIIDataByActId(actId)
    SectorIIData:RefreshSectorIIReddot4Dundeon()
  end
)
end

ActivitySectorIICtrl.ReqEnterActSctIIChallengeDg = function(self, dunLevelData)
  -- function num : 0_8 , upvalues : _ENV, DungeonInterfaceData
  local dungeonId = dunLevelData:GetDungeonLevelStageId()
  local actId = (dunLevelData:GetSectorIIActivityData()).actId
  BattleDungeonManager:InjectBattleExitEvent(function()
    -- function num : 0_8_0 , upvalues : self, actId, dunLevelData
    self:_ReturnFromBattle(actId, dunLevelData)
  end
)
  BattleDungeonManager:InjectBattleWinEvent(function()
    -- function num : 0_8_1 , upvalues : _ENV, dungeonId
    PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinterChallenge, dungeonId, false, PlayerDataCenter.timestamp)
  end
)
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastBattleDeployFmtId(proto_csmsg_DungeonType.DungeonType_WinterHard)
  local formationData = (PlayerDataCenter.formationDic)[lastFmtId]
  if formationData == nil then
    formationData = PlayerDataCenter:CreateFormation(lastFmtId)
  end
  BattleDungeonManager:SaveFormation(formationData)
  local interfaceData = (DungeonInterfaceData.CreateSctWinChallengeInterface)(dunLevelData)
  ;
  (self.__sectorIINetworkCtrl):CS_DUNGEONWinterVerify_Enter(dungeonId, formationData, function(dataList)
    -- function num : 0_8_2 , upvalues : _ENV, interfaceData
    if dataList.Count == 0 then
      error("dataList.Count == 0")
      return 
    end
    local NtfEnterMsgData = dataList[0]
    BattleDungeonManager:RealEnterDungeon(NtfEnterMsgData, nil, interfaceData)
    NetworkManager:HandleDiff(NtfEnterMsgData.syncUpdateDiff)
    ControllerManager:DeleteController(ControllerTypeId.SectorController)
  end
)
end

ActivitySectorIICtrl.ReqSettleActSctIIChallengeDg = function(self, sectorIIChallengeDgData, callback)
  -- function num : 0_9 , upvalues : _ENV
  local dungeonId = sectorIIChallengeDgData:GetDungeonLevelStageId()
  local curScore = sectorIIChallengeDgData:GetSctIIChallengeDgScore()
  local yesFunc = function()
    -- function num : 0_9_0 , upvalues : self, dungeonId, callback
    (self.__sectorIINetworkCtrl):CS_DUNGEONWinterVerify_Settle(dungeonId, callback)
  end

  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_9_1 , upvalues : _ENV, curScore, yesFunc
    if win == nil then
      return 
    end
    local msg = (string.format)(ConfigData:GetTipContent(7111), curScore)
    win:ShowTextBoxWithYesAndNo(msg, yesFunc, nil)
  end
)
end

ActivitySectorIICtrl.GetSectorIIDataByActId = function(self, actId)
  -- function num : 0_10
  return (self.__SectorIIDataDic)[actId]
end

ActivitySectorIICtrl.GetSectorIIFirstData = function(self)
  -- function num : 0_11 , upvalues : _ENV
  for i,v in pairs(self.__SectorIIDataDic) do
    do return v end
  end
  return nil
end

ActivitySectorIICtrl.GetSectorIIDataBySectorId = function(self, sectorId)
  -- function num : 0_12
  return (self.__SectorIIDataSectorIdDic)[sectorId]
end

ActivitySectorIICtrl.UpgradeSectorIIActTech = function(self, techData, callback)
  -- function num : 0_13 , upvalues : _ENV
  local actId = techData:GetTechActId()
  local oldLevel = techData:GetCurLevel()
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ActivityTech_Upgrade(techData:GetActFrameId(), techData:GetTechId(), function(args)
    -- function num : 0_13_0 , upvalues : _ENV, self, actId, oldLevel, callback, techData
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local upgradedTechElement = args[0]
    local sectorIIData = self:GetSectorIIDataByActId(actId)
    for i,elemt in ipairs(upgradedTechElement) do
      local techData = sectorIIData:RefreshAWTechData(elemt)
      self:TechLevelUpInstallBonus(techData, oldLevel, techData:GetCurLevel())
    end
    if callback ~= nil then
      callback(techData)
    end
  end
)
end

ActivitySectorIICtrl.InstallAllTechBonus = function(self, ActTechDataDic)
  -- function num : 0_14 , upvalues : _ENV
  for col,techData in pairs(ActTechDataDic) do
    if techData:GetIsTechUnlocked() then
      local techId = techData:GetTechId()
      local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(techData:GetCurLevel())
      for index,logic in ipairs(logicArray) do
        local para1 = para1Array[index]
        local para2 = para2Array[index]
        local para3 = para3Array[index]
        ;
        (PlayerDataCenter.playerBonus):InstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, techId, logic, para1, para2, para3)
      end
    end
  end
end

ActivitySectorIICtrl.TechLevelUpInstallBonus = function(self, techData, oldLevel, curLevel)
  -- function num : 0_15 , upvalues : _ENV
  local techId = techData:GetTechId()
  if oldLevel > 0 then
    local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(oldLevel)
    for index,logic in ipairs(logicArray) do
      local para1 = para1Array[index]
      local para2 = para2Array[index]
      local para3 = para3Array[index]
      ;
      (PlayerDataCenter.playerBonus):UninstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, techId, logic, para1, para2, para3)
    end
  end
  do
    local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(curLevel)
    for index,logic in ipairs(logicArray) do
      local para1 = para1Array[index]
      local para2 = para2Array[index]
      local para3 = para3Array[index]
      ;
      (PlayerDataCenter.playerBonus):InstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, techId, logic, para1, para2, para3)
    end
  end
end

ActivitySectorIICtrl.EnterActSectorIIDungeonFormation = function(self, tmpDungeonLevelData, autoBattleCount)
  -- function num : 0_16 , upvalues : _ENV, DungeonCenterUtil, DungeonInterfaceData, FmtEnum
  local commonBattleFunc = nil
  local judgeIsHaveEnoughTicket = function(dungeonLevelData, judgeReplay)
    -- function num : 0_16_0 , upvalues : _ENV
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
    -- function num : 0_16_1 , upvalues : autoBattleCount, _ENV, tmpDungeonLevelData, DungeonCenterUtil
    if autoBattleCount ~= nil and autoBattleCount > 0 then
      (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(autoBattleCount, false)
      ;
      (BattleDungeonManager.autoCtrl):SetAutoSelectSuitDic(tmpDungeonLevelData:GetLastCompleteSelectedSuitDic())
    end
    ;
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
  end

  local exitFunc = function(fmtId)
    -- function num : 0_16_2 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
  end

  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_16_3 , upvalues : tmpDungeonLevelData, judgeIsHaveEnoughTicket, commonBattleFunc
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
    -- function num : 0_16_4 , upvalues : judgeIsHaveEnoughTicket, _ENV, self, DungeonInterfaceData, startBattleFunc
    if not judgeIsHaveEnoughTicket(dungeonLevelData) then
      return 
    end
    local curSelectFormationId = curSelectFormationData.id
    local formationData = (PlayerDataCenter.formationDic)[curSelectFormationId]
    if formationData == nil then
      return 
    end
    BattleDungeonManager:SaveFormation(formationData)
    BattleDungeonManager:InjectBattleWinEvent(function()
      -- function num : 0_16_4_0 , upvalues : _ENV, dungeonLevelData, curSelectFormationId
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, dungeonLevelData:GetDungeonLevelStageId(), false, PlayerDataCenter.timestamp)
      if not (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
        local interfaceData = BattleDungeonManager.dunInterfaceData
        dungeonLevelData:SaveLastCompleteSelectedSuitDic(interfaceData:GetLastSelectSuit())
        dungeonLevelData:SaveLastCompleteSelectedFormatId(curSelectFormationId)
      end
    end
)
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_16_4_1 , upvalues : dungeonLevelData, self
      local actId = dungeonLevelData:GetDungeonLevelActId()
      self:_ReturnFromBattle(actId, dungeonLevelData)
    end
)
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII, true)
    local stageId = dungeonLevelData:GetDungeonLevelStageId()
    local interfaceData = (DungeonInterfaceData.CreateActSectorIIDungeonInterface)(dungeonLevelData)
    local rewardRate = dungeonLevelData:GetWADunRewardRate()
    if judgeIsHaveEnoughTicket(dungeonLevelData, true) then
      local keyItemId = dungeonLevelData:GetEnterLevelCost()
      local needKey = dungeonLevelData:GetConsumeKeyNum()
      interfaceData:SetDungeonReplayInfo(startBattleFunc, needKey, keyItemId)
    end
    do
      sectorIICtrl:RequestEnterActSectorIIDungeon(stageId, interfaceData, formationData, rewardRate, function()
      -- function num : 0_16_4_2 , upvalues : _ENV, callBack
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
  if autoBattleCount and autoBattleCount > 0 then
    needKey = needKey * autoBattleCount
  end
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = tmpDungeonLevelData:GetDungeonLevelStageId()
  local lastFmtId = tmpDungeonLevelData:GetLastCompleteSelectedFormatId()
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).SectorIIDun, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleTicketItemId(keyItemId)):SetEnterBattleCostTicketNum(needKey)):SetIsShowSupportHolder(true)
  fmtCtrl:EnterFormation()
end

ActivitySectorIICtrl.RequestEnterActSectorIIDungeon = function(self, stageId, interfaceData, formationData, rewardRate, callBack)
  -- function num : 0_17 , upvalues : _ENV
  (self.__sectorIINetworkCtrl):CS_DUNGEONWINTER_Enter(stageId, formationData, rewardRate, function(dataList)
    -- function num : 0_17_0 , upvalues : _ENV, interfaceData, callBack
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
)
end

ActivitySectorIICtrl.GetAfterBattleShowItemDic = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local extrAwardDic = {}
  for activityId,sectorIIData in pairs(self.__SectorIIDataDic) do
    extrAwardDic[sectorIIData:GetSectorIIDunPointId()] = true
    extrAwardDic[sectorIIData:GetSectorIIDunTicketId()] = true
  end
  return extrAwardDic
end

ActivitySectorIICtrl.__OnTaskUpdate = function(self)
  -- function num : 0_19 , upvalues : _ENV
  for activityId,sectorIIData in pairs(self.__SectorIIDataDic) do
    sectorIIData:RefreshSectorIIReddot4Task()
  end
end

ActivitySectorIICtrl.__OnDungeonLimitChange = function(self)
  -- function num : 0_20 , upvalues : _ENV
  for activityId,sectorIIData in pairs(self.__SectorIIDataDic) do
    sectorIIData:RefreshSectorIIReddot4Dundeon()
  end
end

ActivitySectorIICtrl.__OnItemUpdate = function(self)
  -- function num : 0_21 , upvalues : _ENV
  for activityId,sectorIIData in pairs(self.__SectorIIDataDic) do
    sectorIIData:RefreshSectorIIReddot4Tech()
  end
end

ActivitySectorIICtrl.__OnDungeonBattleTimeChange = function(self)
  -- function num : 0_22 , upvalues : _ENV
  self:__OnDungeonLimitChange()
  for activityId,sectorIIData in pairs(self.__SectorIIDataDic) do
    sectorIIData:RefreshAWSectorLevelState()
  end
end

ActivitySectorIICtrl.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.TaskSyncFinish, self.__onTaskUpdate)
  MsgCenter:RemoveListener(eMsgEventId.OnBattleDungeonLimitChange, self.__onDungeonLimitChange)
  MsgCenter:RemoveListener(eMsgEventId.ExplorationExit, self.__onDungeonLimitChange)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__onItemUpdate)
  MsgCenter:RemoveListener(eMsgEventId.OnBattleDungeonLimitInit, self.__onDungeonBattleTimeChange)
  for _,SectorIIData in pairs(self.__SectorIIDataDic) do
    SectorIIData:Delete()
  end
  ;
  (base.OnDelete)(self)
end

return ActivitySectorIICtrl

