-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySeasonController = class("ActivitySeasonController", ControllerBase)
local ActivitySeasonData = require("Game.ActivitySeason.Data.ActivitySeasonData")
local eActInteractSeason = require("Game.ActivityLobby.Activity.Season.eActInteract")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local ActivitySeasonEnum = require("Game.ActivitySeason.ActivitySeasonEnum")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local FmtEnum = require("Game.Formation.FmtEnum")
local JumpManager = require("Game.Jump.JumpManager")
ActivitySeasonController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dataDic = {}
  ConfigData:LoadDynCfg(eDynConfigData.activity_season_main)
  ConfigData:LoadDynCfg(eDynConfigData.activity_season_reward)
  ConfigData:LoadDynCfg(eDynConfigData.activity_lobby_interact_action)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_general_env)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_stage_info)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season)
  ConfigData:LoadDynCfg(eDynConfigData.activity_season_battle_ex)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self.__AvgCompleteCallback = BindCallback(self, self.__AvgComplete)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__AvgCompleteCallback)
  self.__OnWarChessSeasonRecordCallback = BindCallback(self, self.__OnWarChessSeasonRecord)
  MsgCenter:AddListener(eMsgEventId.WCS_WarChessSeasonRecord, self.__OnWarChessSeasonRecordCallback)
end

ActivitySeasonController.InitSeasons = function(self, msgs)
  -- function num : 0_1 , upvalues : _ENV
  for _,msg in ipairs(msgs) do
    self:AddSeason(msg)
  end
end

ActivitySeasonController.AddSeason = function(self, msg)
  -- function num : 0_2 , upvalues : ActivitySeasonData, _ENV
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ActivitySeasonData.New)()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  data:InitSeasonData(msg)
  WarChessSeasonManager:RefreshWCSPassedTowerData(data:GetSeasonId())
end

ActivitySeasonController.UpdateSeasons = function(self, msg)
  -- function num : 0_3
  if (self._dataDic)[msg.actId] == nil then
    return 
  end
  ;
  ((self._dataDic)[msg.actId]):UpdateSeasonData(msg)
end

ActivitySeasonController.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_4 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for _,data in pairs(self._dataDic) do
    local dailyTaskData = data:GetSeasonDailyTaskData()
    if dailyTaskData ~= nil and dailyTaskData:IsExitInDailyTask(taskData.id) then
      data:RefreshRedSeasonDailyTask()
    else
      local termTaskData = data:GetSeasonTermTaskData()
      if termTaskData:IsExitInTermTask(taskData.id) then
        data:RefreshRedSeasonOnceTask()
      end
    end
  end
end

ActivitySeasonController.__ItemUpdate = function(self, _, _, itemDic)
  -- function num : 0_5 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    local techTree = data:GeSeasonTechTree()
    if techTree ~= nil then
      local techTypeCostDic = techTree:GetTechTypeCostDic()
      for itemId,_ in pairs(techTypeCostDic) do
        if itemDic[itemId] ~= nil then
          data:RefreshRedSeasonTech()
          break
        end
      end
    end
  end
end

ActivitySeasonController.__AvgComplete = function(self, avgId)
  -- function num : 0_6 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    if data:IsSeasonSectorAvg(avgId) then
      data:RefreshRedSeasonMainStory()
    end
  end
end

ActivitySeasonController.__OnWarChessSeasonRecord = function(self, seasonId)
  -- function num : 0_7 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    if data:GetSeasonId() == seasonId then
      data:UpdateSeasonUnlockRepeat()
    end
  end
end

ActivitySeasonController.OpenSeason = function(self, actId, skipStartShow, callback)
  -- function num : 0_8 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return false
  end
  ControllerManager:DeleteController(ControllerTypeId.SectorController)
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl, true)
  local mainActivityId = (data:GetSeasonMainCfg()).activity_general_id
  ctrl:InitActLobbyCtrl(mainActivityId)
  if skipStartShow then
    ctrl:SkipActLbStartShow()
  end
  self._enterCompleteCallback = callback
  return true
end

ActivitySeasonController.ShowSeasonBonus = function(self, closeCallback)
  -- function num : 0_9 , upvalues : _ENV
  local currentData = self:GetSeasonData()
  if currentData == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActivitySeasonBonus, function(window)
    -- function num : 0_9_0 , upvalues : currentData, closeCallback
    if window == nil then
      return 
    end
    window:InitActivitySeasonBouns(currentData)
    window:SetCloseCallback(closeCallback)
  end
)
end

ActivitySeasonController.OpenSeasonObj = function(self, objId)
  -- function num : 0_10 , upvalues : _ENV
  if self:GetSeasonData() == nil then
    return 
  end
  ;
  (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActLobbyMain, false)
  if objId ~= nil then
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
    do
      if ctrl ~= nil then
        (ctrl.actLbIntrctCtrl):InvokeActLbEntity(objId)
      else
        local actId = (self:GetSeasonData()):GetActId()
        self:OpenSeason(actId, true, function()
    -- function num : 0_10_0 , upvalues : ctrl, _ENV, objId
    ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
    ;
    (ctrl.actLbIntrctCtrl):InvokeActLbEntity(objId)
  end
)
      end
    end
  end
end

ActivitySeasonController.OnEnterActSeasonChallenge = function(self, dungenLevel, autoBattleCount)
  -- function num : 0_11 , upvalues : _ENV, JumpManager, FmtEnum, eActInteractSeason, DungeonInterfaceData
  if autoBattleCount ~= nil and autoBattleCount > 0 then
    (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(autoBattleCount, false)
  end
  local enterFunc = function()
    -- function num : 0_11_0 , upvalues : _ENV
    UIManager:HideWindow(UIWindowTypeID.DungeonLevelDetail)
    UIManager:HideWindow(UIWindowTypeID.CommonActivityRepeatDungeon)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_11_1 , upvalues : _ENV
    UIManager:ShowWindowOnly(UIWindowTypeID.DungeonLevelDetail, true)
    UIManager:ShowWindowOnly(UIWindowTypeID.CommonActivityRepeatDungeon)
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
  end

  local commonBattleFunc = nil
  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_11_2 , upvalues : dungenLevel, commonBattleFunc
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = dungenLevel
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_11_3 , upvalues : _ENV, JumpManager, FmtEnum, self, eActInteractSeason, DungeonInterfaceData, startBattleFunc
    local needKey = dungeonLevelData:GetConsumeKeyNum()
    local keyItemId = dungeonLevelData:GetEnterLevelCost()
    if PlayerDataCenter:GetItemCount(keyItemId) < needKey then
      JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina, nil, nil, {needKey - PlayerDataCenter:GetItemCount(keyItemId)})
      return 
    end
    local curSelectFormationId = curSelectFormationData.id
    local formationData = (PlayerDataCenter.formationDic)[curSelectFormationId]
    if formationData == nil then
      return 
    end
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    BattleDungeonManager:SaveFormation(formationData)
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetLastFromModuleFmtId((FmtEnum.eFmtFromModule).ActSeasonDun, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    BattleDungeonManager:InjectBattleWinEvent(function()
      -- function num : 0_11_3_0 , upvalues : dungeonLevelData, _ENV
      local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason, dungeonId, false, PlayerDataCenter.timestamp)
    end
)
    local seasonData = self:GetSeasonData()
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_11_3_1 , upvalues : _ENV, seasonData, self, eActInteractSeason
      local OpenFunc = function()
        -- function num : 0_11_3_1_0 , upvalues : _ENV, seasonData, self, eActInteractSeason
        (UIUtil.CloseOneCover)("loadMatUIFunc")
        local actId = seasonData:GetActId()
        self:OpenSeason(actId, true, function()
          -- function num : 0_11_3_1_0_0 , upvalues : seasonData, _ENV, eActInteractSeason, self
          if seasonData:IsActivityRunning() then
            local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
            if ctrl ~= nil then
              (ctrl.actLbIntrctCtrl):InvokeActLbEntity((eActInteractSeason.eLbIntrctEntityId).Repeat)
              self:SetIgnoreUnlockWinOnce()
            end
          end
        end
)
      end

      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_11_3_1_1 , upvalues : _ENV, seasonData, OpenFunc
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        if seasonData:IsActivityOpen() then
          (UIUtil.AddOneCover)("loadMatUIFunc")
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, OpenFunc)
          sectorCtrl:OnEnterActivity()
        else
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, function()
          -- function num : 0_11_3_1_1_0 , upvalues : sectorCtrl
          sectorCtrl:ResetToNormalState(false)
        end
)
        end
      end
)
    end
)
    local seasonCtr = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
    local interfaceData = (DungeonInterfaceData.CreateSpringDungeonInterface)(dungeonLevelData)
    interfaceData:SetAfterClickBattleFunc(function(callback)
      -- function num : 0_11_3_2
      callback()
    end
)
    interfaceData:SetDungeonReplayInfo(startBattleFunc, needKey, keyItemId)
    seasonCtr:__ReqDungeonBattle(interfaceData, formationData, function()
      -- function num : 0_11_3_3 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
)
  end

  local needKey = dungenLevel:GetConsumeKeyNum()
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = dungenLevel:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId((FmtEnum.eFmtFromModule).ActSeasonDun)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).ActSeasonDun, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(needKey)
  fmtCtrl:EnterFormation()
end

ActivitySeasonController.__ReqDungeonBattle = function(self, interfaceData, formationData, callBack)
  -- function num : 0_12 , upvalues : _ENV
  local dungeonLevelData = interfaceData:GetIDungeonLevelData()
  local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(dungeonId, formationData, nil, function(dataList)
    -- function num : 0_12_0 , upvalues : _ENV, interfaceData, callBack
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

ActivitySeasonController.EnterGreenHandWarChessSeasonLevels = function(self, sectorId, closeCallback)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevel, function(window)
    -- function num : 0_13_0 , upvalues : sectorId, closeCallback, _ENV
    if window == nil then
      return 
    end
    window:InitSectorLevel(sectorId, closeCallback, 1, nil, nil, nil, nil)
    window:SetCustomEnterFmtCallback(function()
      -- function num : 0_13_0_0 , upvalues : _ENV
      ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    end
)
  end
)
end

ActivitySeasonController.EnterCommonSeasonWarChessSeasonLevelSelect = function(self, closeCallback)
  -- function num : 0_14 , upvalues : _ENV
  local seasonData = self:GetSeasonData()
  UIManager:ShowWindowAsync(UIWindowTypeID.WCSModeSelect, function(window)
    -- function num : 0_14_0 , upvalues : seasonData, _ENV, self, closeCallback
    if window == nil then
      return 
    end
    local seasonId = seasonData:GetSeasonId()
    local loadSavingDataCallback = BindCallback(self, self.CommonSeasonWCSLoadSaving)
    local startNewWCSCallback = BindCallback(self, self.EnterCommonSeasonWarChessSeason)
    window:InitWCSModeSelect(seasonId, loadSavingDataCallback, startNewWCSCallback, closeCallback)
  end
)
end

ActivitySeasonController.EnterCommonSeasonWarChessSeason = function(self, stageInfoCfg, envId)
  -- function num : 0_15 , upvalues : _ENV
  local seasonData = self:GetSeasonData()
  if not seasonData:IsActivityRunning() then
    return 
  end
  local towerId = stageInfoCfg.season_id
  local seasonId = seasonData:GetSeasonId()
  ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
  WarChessSeasonManager:EnterWarChessSeasonBySeasonGroupId(seasonId, towerId, envId or 0)
  self:__SetEnterrChessSeasonData(seasonData, stageInfoCfg, seasonId, envId)
end

ActivitySeasonController.CommonSeasonWCSLoadSaving = function(self, archive)
  -- function num : 0_16 , upvalues : _ENV
  local seasonData = self:GetSeasonData()
  local seasonId = seasonData:GetSeasonId()
  local towerId = archive.warChessTowerId
  local stageInfoCfg = WarChessSeasonManager:GetWCSStageInfoByTowerId(seasonId, towerId)
  local envCfg = WarChessSeasonManager:GetWCSEnvIdByTowerId(seasonId, towerId)
  if stageInfoCfg ~= nil then
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    WarChessSeasonManager:ReadWCSSavingData(archive.warChessSeasonbackUpId)
    self:__SetEnterrChessSeasonData(seasonData, stageInfoCfg, seasonId, envCfg.id)
  end
end

ActivitySeasonController.ContinueSeason = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local isUnComplete, wcsdata = WarChessSeasonManager:GetUncompleteWCSData()
  if not isUnComplete then
    return 
  end
  local seasonData = self:GetSeasonData()
  local seasonId = seasonData:GetSeasonId()
  local towerId = wcsdata.towerId
  local stageInfoCfg = WarChessSeasonManager:GetWCSStageInfoByTowerId(seasonId, towerId)
  local envCfg = WarChessSeasonManager:GetWCSEnvIdByTowerId(seasonId, towerId)
  if stageInfoCfg ~= nil then
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    WarChessSeasonManager:WCSReconnect()
    self:__SetEnterrChessSeasonData(seasonData, stageInfoCfg, seasonId, envCfg.id)
  end
end

ActivitySeasonController.__SetEnterrChessSeasonData = function(self, seasonData, stageInfoCfg, seasonId, envId)
  -- function num : 0_18 , upvalues : _ENV, eActInteractSeason, ActivitySeasonEnum
  local addtionData = seasonData:GetSeasonAddtion()
  addtionData:SetSeasonCompleteFloor(stageInfoCfg.floor_id)
  addtionData:SetSeasonRecommendPower(stageInfoCfg.combat)
  addtionData:SetSeasonCompleteFloorTip(ConfigData:GetTipContent(8701))
  do
    if seasonId and envId then
      local maxNum = WarChessSeasonManager:GetWCSPassedEnvMaxNum(seasonId, envId)
      addtionData:SetSeasonHighesScore(maxNum)
    end
    WarChessSeasonManager:SetSeasonAddtionData(addtionData)
    WarChessSeasonManager:SetWarChessSeasonName((LanguageUtil.GetLocaleText)(stageInfoCfg.difficulty_name))
    WarChessSeasonManager:SetSeasonTechJumpFunc(function()
    -- function num : 0_18_0 , upvalues : self, eActInteractSeason
    self:OpenSeasonObj((eActInteractSeason.eLbIntrctEntityId).Tech)
  end
, function()
    -- function num : 0_18_1 , upvalues : seasonData, ActivitySeasonEnum
    local reddot = seasonData:GetActivityReddot()
    if reddot == nil then
      return false
    end
    local techReddot = reddot:GetChild((ActivitySeasonEnum.reddotType).Tech)
    if techReddot == nil then
      return false
    end
    do return techReddot:GetRedDotCount() > 0 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  end
end

ActivitySeasonController.SetIgnoreUnlockWinOnce = function(self)
  -- function num : 0_19
  self.ignoreUnlockWinOnce = true
end

ActivitySeasonController.TryOpenUnlockWin = function(self, seasonData)
  -- function num : 0_20 , upvalues : _ENV, ActLbUtil, eActInteractSeason
  local unlockInfo = seasonData:GetSeasonUnlockInfo()
  if unlockInfo ~= nil and unlockInfo:IsExistActUnlockInfo() then
    UIManager:ShowWindowAsync(UIWindowTypeID.ActivitySeasonUnlcok, function(win)
    -- function num : 0_20_0 , upvalues : ActLbUtil, unlockInfo, eActInteractSeason
    if win == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    win:InitSpring23Unlock(unlockInfo, function()
      -- function num : 0_20_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
    win:BindSeasonUnlockFunc((eActInteractSeason.eUnlockIntrctFunc)[(eActInteractSeason.eLbIntrctEntityId).MainStory], (eActInteractSeason.eIntrctFuncs)[(eActInteractSeason.eLbIntrctActionId).MainStory], (eActInteractSeason.eUnlockIntrctFunc)[(eActInteractSeason.eLbIntrctEntityId).Repeat], (eActInteractSeason.eIntrctFuncs)[(eActInteractSeason.eLbIntrctActionId).Repeat])
  end
)
  end
end

ActivitySeasonController.RunEnterCompleteFunc = function(self)
  -- function num : 0_21
  if self._enterCompleteCallback then
    (self._enterCompleteCallback)()
  end
  if not self.ignoreUnlockWinOnce then
    self:TryOpenUnlockWin(self:GetSeasonData())
  else
    self.ignoreUnlockWinOnce = false
  end
end

ActivitySeasonController.RemoveSeason = function(self, id)
  -- function num : 0_22
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[id] = nil
end

ActivitySeasonController.IsHaveSeason = function(self)
  -- function num : 0_23 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySeasonController.GetSeasonData = function(self)
  -- function num : 0_24 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    do return v end
  end
end

ActivitySeasonController.GetSeasonDataByActId = function(self, id)
  -- function num : 0_25
  return (self._dataDic)[id]
end

ActivitySeasonController.Delete = function(self)
  -- function num : 0_26 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_season_main)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_season_reward)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby_interact_action)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_general_env)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_stage_info)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_season_battle_ex)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__AvgCompleteCallback)
  MsgCenter:RemoveListener(eMsgEventId.WCS_WarChessSeasonRecord, self.__OnWarChessSeasonRecordCallback)
end

return ActivitySeasonController

