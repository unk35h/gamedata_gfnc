-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityHallowmasController = class("ActivityHallowmasController", ControllerBase)
local ActivityHallowmasData = require("Game.ActivityHallowmas.ActivityHallowmasData")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local FmtEnum = require("Game.Formation.FmtEnum")
local JumpManager = require("Game.Jump.JumpManager")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local HallowmasActIdEnum = {hallowmas = 1, christmas = 2}
ActivityHallowmasController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dataDic = {}
  ConfigData:LoadDynCfg(eDynConfigData.activity_hallowmas_exp)
  ConfigData:LoadDynCfg(eDynConfigData.activity_hallowmas_stage_info)
  ConfigData:LoadDynCfg(eDynConfigData.activity_hallowmas_name)
  ConfigData:LoadDynCfg(eDynConfigData.activity_hallowmas_achievement)
  ConfigData:LoadDynCfg(eDynConfigData.activity_hallowmas_general_env)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self.__AvgCompleteCallback = BindCallback(self, self.__AvgComplete)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__AvgCompleteCallback)
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActivityHallowmasController.InitHallowmas = function(self, msgs)
  -- function num : 0_1 , upvalues : _ENV
  for _,msg in ipairs(msgs) do
    self:AddHallowmas(msg)
  end
end

ActivityHallowmasController.AddHallowmas = function(self, msg)
  -- function num : 0_2 , upvalues : ActivityHallowmasData
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ActivityHallowmasData.New)()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  data:InitHallowmasData(msg)
  local expireTm = data:GetHallowmasExpiredTm()
  if expireTm < data:GetTaskInitTaskTime() then
    expireTm = data:GetTaskInitTaskTime()
  end
  ;
  (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), expireTm + 1, self.__ExpireDealCallback)
end

ActivityHallowmasController.UpdateHallowmas = function(self, msg)
  -- function num : 0_3
  if (self._dataDic)[msg.actId] == nil then
    return 
  end
  ;
  ((self._dataDic)[msg.actId]):UpdateHallowmasData(msg)
end

ActivityHallowmasController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_4 , upvalues : _ENV
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self._dataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  local actFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  actFrameNet:CS_ACTIVITY_SingleConcreteInfo(data:GetActFrameId(), function(objList)
    -- function num : 0_4_0 , upvalues : data, self, activityFrameId, _ENV
    local msg = objList[0]
    if msg ~= nil and msg.activityHalloween ~= nil then
      data:UpdateHallowmasData(msg.activityHalloween)
      ;
      (self._frameCtrl):AddActivityDataUpdateTimeListen(activityFrameId, data:GetHallowmasExpiredTm() + 1, self.__ExpireDealCallback)
    end
    MsgCenter:Broadcast(eMsgEventId.ActivityHallowmasExpired, data:GetActId())
  end
)
end

ActivityHallowmasController.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_5 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for _,data in pairs(self._dataDic) do
    local taskIdDic = data:GetHallowmasDailyTaskIdDic()
    if taskIdDic ~= nil and taskIdDic[taskData.id] ~= nil then
      data:RefreshHallowmasRedDailyTask(taskData)
    else
      local achienementCfg = data:GetHallowmasAchievementCfg()
      if achienementCfg[taskData.id] ~= nil then
        data:RefreshHallowmasRedAchievement(taskData)
      else
        local envId = ((ConfigData.activity_hallowmas_general_env).taskEnvDic)[taskData.id]
        if envId ~= nil then
          data:RefreshHallowmasRedRedEnvTask(taskData)
        end
      end
    end
  end
end

ActivityHallowmasController.__ItemUpdate = function(self, _, _, itemDic)
  -- function num : 0_6 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    if itemDic[data:GetHallowmasScoreItemId()] ~= nil then
      data:RefreshHallowmasRedExp()
      data:RefreshHallowmasRedSectorAvg()
    end
    local techTree = data:GetHallowmasTechTree()
    if techTree ~= nil then
      local techTypeCostDic = techTree:GetTechTypeCostDic()
      for itemId,_ in pairs(techTypeCostDic) do
        if itemDic[itemId] ~= nil then
          data:RefreshHallowmasRedTech()
          break
        end
      end
    end
  end
end

ActivityHallowmasController.__AvgComplete = function(self, avgId)
  -- function num : 0_7 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    if data:IsHallowmasSectorAvg(avgId) then
      data:RefreshHallowmasRedSectorAvg()
    end
  end
end

ActivityHallowmasController.OpenHallowmas = function(self, actId, enterFunc, backCallback, selectSector, callback)
  -- function num : 0_8 , upvalues : HallowmasActIdEnum, _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  if actId == HallowmasActIdEnum.hallowmas then
    UIManager:ShowWindowAsync(UIWindowTypeID.Halloween22Main, function(window)
    -- function num : 0_8_0 , upvalues : data, enterFunc, backCallback, selectSector, callback
    if window == nil then
      return 
    end
    window:InitHalloween22(data, enterFunc, backCallback)
    if selectSector or 0 > 0 then
      window:EnterHallowmasSector(selectSector)
    end
    if callback ~= nil then
      callback()
    end
  end
)
  else
    if actId == HallowmasActIdEnum.christmas then
      UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Main, function(window)
    -- function num : 0_8_1 , upvalues : data, enterFunc, backCallback, selectSector, callback
    if window == nil then
      return 
    end
    window:InitChristmas22Main(data, enterFunc, backCallback)
    if selectSector or 0 > 0 then
      window:EnterChristmas22Sector(selectSector)
    end
    if callback ~= nil then
      callback()
    end
  end
)
    end
  end
end

ActivityHallowmasController.EnterSeasonDugeon = function(self, tmpDungeonLevelData, autoBattleCount)
  -- function num : 0_9 , upvalues : FmtEnum, _ENV, JumpManager, DungeonCenterUtil, DungeonInterfaceData
  local commonBattleFunc = nil
  local fmtModule = (FmtEnum.eFmtFromModule).Season
  local forbidSupport = autoBattleCount or 0 > 0
  local keyItemId = tmpDungeonLevelData:GetEnterLevelCost()
  local needKey = tmpDungeonLevelData:GetConsumeKeyNum()
  local judgeIsHaveEnoughTicket = function(dungeonLevelData, judgeReplay)
    -- function num : 0_9_0 , upvalues : _ENV, JumpManager
    local keyItemId = dungeonLevelData:GetEnterLevelCost()
    local needKey = dungeonLevelData:GetConsumeKeyNum()
    if judgeReplay then
      needKey = needKey * 2
    end
    if PlayerDataCenter:GetItemCount(keyItemId) < needKey then
      if judgeReplay then
        return false
      end
      JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
      return false
    end
    return true
  end

  if autoBattleCount ~= nil and autoBattleCount > 0 then
    (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(autoBattleCount, false)
  end
  local enterFunc = function()
    -- function num : 0_9_1 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
    UIManager:HideWindow(UIWindowTypeID.Christmas22Repeat)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_9_2 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    UIManager:ShowWindowOnly(UIWindowTypeID.Christmas22Repeat)
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
  end

  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_9_3 , upvalues : tmpDungeonLevelData, judgeIsHaveEnoughTicket, commonBattleFunc
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
    -- function num : 0_9_4 , upvalues : judgeIsHaveEnoughTicket, _ENV, fmtModule, self, DungeonInterfaceData, startBattleFunc, needKey, keyItemId
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
      -- function num : 0_9_4_0 , upvalues : _ENV, dungeonLevelData, curSelectFormationData
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason, dungeonLevelData:GetDungeonLevelStageId(), curSelectFormationData.isHaveSupport, PlayerDataCenter.timestamp)
    end
)
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_9_4_1 , upvalues : dungeonLevelData, self
      local actId = dungeonLevelData:GetSeasonId()
      self:__ReturnFromSeasonBattle(actId, dungeonLevelData)
    end
)
    local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas, true)
    local stageId = dungeonLevelData:GetDungeonLevelStageId()
    local interfaceData = (DungeonInterfaceData.CreateActSeasonDunInterface)(dungeonLevelData)
    interfaceData:SetDungeonReplayInfo(startBattleFunc, needKey, keyItemId)
    local farmDouble = false
    seasonCtrl:RequestEnterActSeasonDungeon(stageId, interfaceData, formationData, farmDouble, function()
      -- function num : 0_9_4_2 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
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

ActivityHallowmasController.RequestEnterActSeasonDungeon = function(self, stageId, interfaceData, formationData, isDouble, callBack)
  -- function num : 0_10 , upvalues : _ENV
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(stageId, formationData, nil, function(dataList)
    -- function num : 0_10_0 , upvalues : _ENV, interfaceData, callBack
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

ActivityHallowmasController.__ReturnFromSeasonBattle = function(self, actId, dungeonLevelData)
  -- function num : 0_11 , upvalues : _ENV
  local actData = (self._dataDic)[actId]
  if actData == nil then
    return 
  end
  local loadMapUIFunc = function()
    -- function num : 0_11_0 , upvalues : _ENV, actData
    UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Main, function(win)
      -- function num : 0_11_0_0 , upvalues : _ENV, actData
      if win == nil then
        return 
      end
      win:SetXMasDunSectorCallback(function()
        -- function num : 0_11_0_0_0 , upvalues : _ENV
        local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
        if aftertTeatmentCtrl ~= nil then
          aftertTeatmentCtrl:TeatmentBengin()
        end
      end
)
      win:InitChristmas22Main(actData, function(sectorId, difficuty, stageCfg, extraCloseFunc, enterOverCallback)
        -- function num : 0_11_0_0_1 , upvalues : _ENV
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        if sectorCtrl ~= nil then
          sectorCtrl:__EnterSectorLevel(sectorId, difficuty, stageCfg, extraCloseFunc, enterOverCallback)
        end
      end
, function()
        -- function num : 0_11_0_0_2 , upvalues : _ENV
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        if sectorCtrl ~= nil then
          sectorCtrl:ResetToNormalState(false)
          sectorCtrl:PlaySectorBgm()
        end
      end
)
      win:OnClickDungeon()
    end
)
  end

  ;
  (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
    -- function num : 0_11_1 , upvalues : _ENV, loadMapUIFunc, dungeonLevelData
    local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
    sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMapUIFunc, nil, dungeonLevelData)
  end
)
end

ActivityHallowmasController.EnterhallowmasSeason = function(self, actId, diffculty, envId)
  -- function num : 0_12 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  if not data:IsActivityRunning() then
    return 
  end
  local stageInfoCfgs = data:GetHallowmasStageInfoCfg()
  local stageInfoCfg = stageInfoCfgs[diffculty]
  if stageInfoCfg == nil then
    return 
  end
  if envId ~= nil then
    if not data:IsHallowmasEnvDiffcultyExist(envId, diffculty) and isGameDev then
      error("env diff no mapping, envId:" .. tostring(envId) .. " diffId:" .. tostring(diffculty) .. " actId:" .. tostring(actId))
    end
    return 
  end
  local towerId = stageInfoCfg.season_id
  local seasonId = (data:GetHallowmasMainCfg()).warchess_season_id
  WarChessSeasonManager:EnterWarChessSeasonBySeasonGroupId(seasonId, towerId, envId or 0)
  self:__SetHallowmasWarChessSeasonData(data, stageInfoCfg)
end

ActivityHallowmasController.ArchivehallowmasSeason = function(self, archive)
  -- function num : 0_13 , upvalues : _ENV
  local data, cfg = self:__GetActStageCfgByTowerId(archive.warChessTowerId)
  if cfg ~= nil then
    WarChessSeasonManager:ReadWCSSavingData(archive.warChessSeasonbackUpId)
    self:__SetHallowmasWarChessSeasonData(data, cfg)
  end
end

ActivityHallowmasController.ContinuehallowmasSeason = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local isUnComplete, wcdata = WarChessSeasonManager:GetUncompleteWCSData()
  if not isUnComplete then
    return 
  end
  local data, cfg = self:__GetActStageCfgByTowerId(wcdata.towerId)
  if cfg ~= nil then
    WarChessSeasonManager:WCSReconnect()
    self:__SetHallowmasWarChessSeasonData(data, cfg)
  end
end

ActivityHallowmasController.__SetHallowmasWarChessSeasonData = function(self, hallowmasData, stageInfoCfg)
  -- function num : 0_15 , upvalues : HallowmasActIdEnum, _ENV
  local addtionData = hallowmasData:GetHallowmasSeasonAddtion()
  addtionData:SetSeasonCompleteFloor(stageInfoCfg.floor_id)
  local envId = (hallowmasData:GetHallowmasEnvIdByDifficultyId(stageInfoCfg.difficulty_id))
  local seasonHighesScore = nil
  if envId ~= -1 then
    seasonHighesScore = hallowmasData:GetHallowmasEnvScore(envId)
  else
    seasonHighesScore = hallowmasData:GetHallowmasHighestScore()
  end
  addtionData:SetSeasonHighesScore(seasonHighesScore)
  addtionData:SetSeasonRecommendPower(stageInfoCfg.combat)
  if hallowmasData:GetActId() == HallowmasActIdEnum.christmas then
    addtionData:SetSeasonSaveUIType(UIWindowTypeID.WCSSavingPanel_Christmas22)
  else
    if hallowmasData:GetActId() == HallowmasActIdEnum.hallowmas then
      addtionData:SetSeasonSaveUIType(UIWindowTypeID.WCSSavingPanel_Halloween22)
    end
  end
  WarChessSeasonManager:SetSeasonAddtionData(addtionData)
  WarChessSeasonManager:SetWarChessSeasonName((LanguageUtil.GetLocaleText)(stageInfoCfg.difficulty_name))
end

ActivityHallowmasController.RemoveHallowmas = function(self, id)
  -- function num : 0_16
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[id] = nil
end

ActivityHallowmasController.IsHaveHallowmas = function(self)
  -- function num : 0_17 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityHallowmasController.GetHallowmasData = function(self, id)
  -- function num : 0_18
  return (self._dataDic)[id]
end

ActivityHallowmasController.__GetActStageCfgByTowerId = function(self, towerId)
  -- function num : 0_19 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    local stageInfoCfgs = v:GetHallowmasStageInfoCfg()
    for i,cfg in pairs(stageInfoCfgs) do
      if cfg.season_id == towerId then
        return v, cfg
      end
    end
  end
  return nil, nil
end

ActivityHallowmasController.Delete = function(self)
  -- function num : 0_20 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_hallowmas_exp)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_hallowmas_stage_info)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_hallowmas_name)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_hallowmas_achievement)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_hallowmas_general_env)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__AvgCompleteCallback)
end

return ActivityHallowmasController

