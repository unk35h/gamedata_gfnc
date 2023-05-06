-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityWinter23Controller = class("ActivityWinter23Controller", ControllerBase)
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityWinter23Data = require("Game.ActivityWinter23.Data.ActivityWinter23Data")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local eActInteract23Winter = require("Game.ActivityLobby.Activity.2023Winter.eActInteract")
ActivityWinter23Controller.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.activity_winter23_main)
  ConfigData:LoadDynCfg(eDynConfigData.activity_winter23_chapters)
  ConfigData:LoadDynCfg(eDynConfigData.activity_winter23_difficulty)
  ConfigData:LoadDynCfg(eDynConfigData.activity_lobby_interact_action)
  ConfigData:LoadDynCfg(eDynConfigData.activity_winter23_farm_desc)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_general_env)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_stage_info)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season)
  self._dataDic = {}
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self.__AvgStageChangeCallback = BindCallback(self, self.__AvgStateChange)
  MsgCenter:AddListener(eMsgEventId.OnMainAvgStateChange, self.__AvgStageChangeCallback)
end

ActivityWinter23Controller.AddWinter23 = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum, ActivityWinter23Data
  local frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = frameCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Winter23, msg.actId)
  if frameData == nil or not frameData:IsActivityOpen() then
    return 
  end
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ActivityWinter23Data.New)()
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  data:InitWinter23Data(msg)
  WarChessSeasonManager:RefreshWCSPassedTowerData(data:GetWinter23WarchessSeasonId())
end

ActivityWinter23Controller.UpdateWinter23 = function(self, msg)
  -- function num : 0_2
  if (self._dataDic)[msg.actId] == nil then
    return 
  end
  ;
  ((self._dataDic)[msg.actId]):UpdateWinter23Data(msg)
end

ActivityWinter23Controller.RemoveWinter23 = function(self, actId)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivityWinter23Controller.IsHaveWinter23 = function(self)
  -- function num : 0_4 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityWinter23Controller.GetWinter23Data = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    do return v end
  end
end

ActivityWinter23Controller.GetWinter23DataByActId = function(self, actId)
  -- function num : 0_6
  return (self._dataDic)[actId]
end

ActivityWinter23Controller.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_winter23_main)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_winter23_chapters)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_winter23_difficulty)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby_interact_action)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_winter23_farm_desc)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_general_env)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_stage_info)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.OnMainAvgStateChange, self.__AvgStageChangeCallback)
end

ActivityWinter23Controller.__AvgStateChange = function(self)
  -- function num : 0_8 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    data:RefreshRedWinter23Main()
  end
end

ActivityWinter23Controller.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_9 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for _,data in pairs(self._dataDic) do
    local dailyTaskData = data:GetWinter23DailyTaskData()
    if dailyTaskData ~= nil and dailyTaskData:IsExitInDailyTask(taskData.id) then
      data:RefreshRedWinter23DailyTask()
    else
      local termTaskData = data:GetWinter23TermTaskData()
      if termTaskData:IsExitInTermTask(taskData.id) then
        data:RefreshRedWnter23OnceTask()
      end
    end
  end
end

ActivityWinter23Controller.__ItemUpdate = function(self, _, _, itemDic)
  -- function num : 0_10 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    local techTree = data:GetWinter23TechTree()
    if techTree ~= nil then
      local techTypeCostDic = techTree:GetTechTypeCostDic()
      for itemId,_ in pairs(techTypeCostDic) do
        if itemDic[itemId] ~= nil then
          data:RefreshRedWinter23Tech()
          break
        end
      end
    end
  end
end

ActivityWinter23Controller.OpenWinter23 = function(self, actId, skipStartShow, callback)
  -- function num : 0_11 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  ControllerManager:DeleteController(ControllerTypeId.SectorController)
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl, true)
  local mainActivityId = data:GetActFrameId()
  ctrl:InitActLobbyCtrl(mainActivityId)
  if skipStartShow then
    ctrl:SkipActLbStartShow()
  end
  self._enterCompleteCallback = callback
end

ActivityWinter23Controller.RunEnterCompleteFunc = function(self)
  -- function num : 0_12
  if self._enterCompleteCallback then
    (self._enterCompleteCallback)()
  end
end

ActivityWinter23Controller.OpenWinter23Obj = function(self, objId)
  -- function num : 0_13 , upvalues : _ENV
  (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActLobbyMain, false)
  if objId ~= nil then
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
    ;
    (ctrl.actLbIntrctCtrl):InvokeActLbEntity(objId)
    objId = nil
  end
end

ActivityWinter23Controller.IsWinter23Sector = function(self, sectorId)
  -- function num : 0_14 , upvalues : _ENV
  for actId,AWTData in pairs(self._dataDic) do
    if AWTData:IsWinter23Sector(sectorId) then
      return true, AWTData
    end
  end
  return false
end

ActivityWinter23Controller.TryEnterWTSector = function(self, sectorId, successCallback)
  -- function num : 0_15
  local isWDSector, AWTData = self:IsWinter23Sector(sectorId)
  do
    if isWDSector and AWTData:IsActivityRunning() then
      local actId = AWTData:GetActId()
      self:OpenWinter23(actId, true, successCallback)
      return true
    end
    return false
  end
end

ActivityWinter23Controller.TryEnterWT23Season = function(self, seasonId, successCallback)
  -- function num : 0_16 , upvalues : _ENV
  for actId,AWTData in pairs(self._dataDic) do
    do
      do
        if AWTData:GetWinter23WarchessSeasonId() == seasonId and AWTData:IsActivityRunning() then
          local actId = AWTData:GetActId()
          self:OpenWinter23(actId, true, successCallback)
          return true
        end
        do break end
        -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  return false
end

ActivityWinter23Controller.GetIsFirstEnterMainEp = function(self)
  -- function num : 0_17
  local winter23Data = self:GetWinter23Data()
  local isNotFirstFlag = winter23Data:GetLastWinter23MainSector()
  return not isNotFirstFlag
end

ActivityWinter23Controller.ReEnterWinter23MainEp = function(self, sectorId, callback)
  -- function num : 0_18
  local winter23Data = self:GetWinter23Data()
  if sectorId == winter23Data:GetWarChessGreenHandSectorId() then
    self:EnterGreenHandWarChessSeasonLevels(sectorId, callback)
    return 
  end
  if not self.sectorId then
    self:SetWinter23MainInfo(sectorId, false, callback)
  end
  self:EnterWinter23MainEp(self.sectorId, self.repeatLevel, self.closeCallback, self.chapterId)
end

ActivityWinter23Controller.SetWinter23MainInfo = function(self, sector, isRepeat, closeCallback, isNeedRefreshChapter)
  -- function num : 0_19
  self.sectorId = sector
  self.repeatLevel = isRepeat
  self.closeCallback = closeCallback
  if isNeedRefreshChapter then
    self.chapterId = nil
  end
end

ActivityWinter23Controller.EnterWinter23MainEp = function(self, sectorId, isRepeat, closeCallback, chapterId)
  -- function num : 0_20 , upvalues : _ENV
  local winter23Data = self:GetWinter23Data()
  local winter23MainCfg = winter23Data:GetWinter23Cfg()
  self:SetWinter23MainInfo(sectorId, isRepeat, closeCallback)
  local levelList = nil
  if self.repeatLevel then
    levelList = self:_GetLevelListByRepeatId()
  else
    if chapterId then
      levelList = self:GetLevelListByChapterId(chapterId)
    else
      levelList = self:GetLevelListByChapterId()
    end
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevel, function(window)
    -- function num : 0_20_0 , upvalues : self, levelList, closeCallback, _ENV
    if window == nil then
      return 
    end
    window:SetSpecialState(self.repeatLevel)
    window:SetSpecialLevelList(levelList)
    window:InitSectorLevel(self.sectorId, closeCallback, 1)
    window:SetCustomExBattleStartCallback(function()
      -- function num : 0_20_0_0 , upvalues : _ENV, self
      ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
      if self.nowStageId then
        self:SendRecordEnterInterface()
      end
    end
)
    window:SetSelectCanEnterCallback(BindCallback(self, self.GiveSelectIsEnterStage))
  end
)
end

ActivityWinter23Controller.EnterGreenHandWarChessSeasonLevels = function(self, sectorId, closeCallback)
  -- function num : 0_21 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevel, function(window)
    -- function num : 0_21_0 , upvalues : sectorId, closeCallback, _ENV
    if window == nil then
      return 
    end
    window:InitSectorLevel(sectorId, closeCallback, 1, nil, nil, nil, nil)
    window:SetCustomEnterFmtCallback(function()
      -- function num : 0_21_0_0 , upvalues : _ENV
      ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    end
)
  end
)
end

ActivityWinter23Controller.EnterWinter23WarChessSeasonLevelSelect = function(self, closeCallback)
  -- function num : 0_22 , upvalues : _ENV
  local winter23Data = self:GetWinter23Data()
  UIManager:ShowWindowAsync(UIWindowTypeID.WCSModeSelect, function(window)
    -- function num : 0_22_0 , upvalues : winter23Data, _ENV, self, closeCallback
    if window == nil then
      return 
    end
    local seasonId = winter23Data:GetWinter23WarchessSeasonId()
    local loadSavingDataCallback = BindCallback(self, self.Winter32WCSLoadSaving)
    local startNewWCSCallback = BindCallback(self, self.EnterWinter23WarChessSeason)
    window:InitWCSModeSelect(seasonId, loadSavingDataCallback, startNewWCSCallback, closeCallback)
  end
)
end

ActivityWinter23Controller.EnterWinter23WarChessSeason = function(self, stageInfoCfg, envId)
  -- function num : 0_23 , upvalues : _ENV
  local winter23Data = self:GetWinter23Data()
  if not winter23Data:IsActivityRunning() then
    return 
  end
  local towerId = stageInfoCfg.season_id
  local seasonId = winter23Data:GetWinter23WarchessSeasonId()
  ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
  WarChessSeasonManager:EnterWarChessSeasonBySeasonGroupId(seasonId, towerId, envId or 0)
  self:__SetWinter23EnterrChessSeasonData(winter23Data, stageInfoCfg, seasonId, envId)
end

ActivityWinter23Controller.Winter32WCSLoadSaving = function(self, archive)
  -- function num : 0_24 , upvalues : _ENV
  local winter23Data = self:GetWinter23Data()
  local seasonId = winter23Data:GetWinter23WarchessSeasonId()
  local towerId = archive.warChessTowerId
  local stageInfoCfg = WarChessSeasonManager:GetWCSStageInfoByTowerId(seasonId, towerId)
  local envCfg = WarChessSeasonManager:GetWCSEnvIdByTowerId(seasonId, towerId)
  if stageInfoCfg ~= nil then
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    WarChessSeasonManager:ReadWCSSavingData(archive.warChessSeasonbackUpId)
    self:__SetWinter23EnterrChessSeasonData(winter23Data, stageInfoCfg, seasonId, envCfg.id)
  end
end

ActivityWinter23Controller.ContinuehallowmasSeason = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local isUnComplete, wcsdata = WarChessSeasonManager:GetUncompleteWCSData()
  if not isUnComplete then
    return 
  end
  local winter23Data = self:GetWinter23Data()
  local seasonId = winter23Data:GetWinter23WarchessSeasonId()
  local towerId = wcsdata.towerId
  local stageInfoCfg = WarChessSeasonManager:GetWCSStageInfoByTowerId(seasonId, towerId)
  local envCfg = WarChessSeasonManager:GetWCSEnvIdByTowerId(seasonId, towerId)
  if stageInfoCfg ~= nil then
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    WarChessSeasonManager:WCSReconnect()
    self:__SetWinter23EnterrChessSeasonData(winter23Data, stageInfoCfg, seasonId, envCfg.id)
  end
end

ActivityWinter23Controller.__SetWinter23EnterrChessSeasonData = function(self, winter23Data, stageInfoCfg, seasonId, envId)
  -- function num : 0_26 , upvalues : _ENV
  local addtionData = winter23Data:GetHallowmasSeasonAddtion()
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
  end
end

ActivityWinter23Controller.ChangeWinter23MainEpChapter = function(self, chapterId)
  -- function num : 0_27 , upvalues : _ENV
  local levelList = self:GetLevelListByChapterId(chapterId)
  local sectorLevelWin = UIManager:GetWindow(UIWindowTypeID.SectorLevel)
  if sectorLevelWin then
    sectorLevelWin:SetSpecialState(false)
    sectorLevelWin:SetSpecialLevelList(levelList)
    sectorLevelWin:ChangeSectorDifficulty(1, self.sectorId)
  end
end

ActivityWinter23Controller.EnterWinter23MainEpRepeat = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local levelList = self:_GetLevelListByRepeatId()
  local sectorLevelWin = UIManager:GetWindow(UIWindowTypeID.SectorLevel)
  if sectorLevelWin then
    sectorLevelWin:SetSpecialState(true)
    sectorLevelWin:SetSpecialLevelList(levelList)
    sectorLevelWin:ChangeSectorDifficulty(1, self.sectorId)
  end
end

ActivityWinter23Controller.ChangeWinter23MainEpRepeat = function(self, chapterId)
  -- function num : 0_29 , upvalues : _ENV
  if self.repeatLevel then
    self.repeatLevel = false
  else
    self.repeatLevel = true
  end
  local detailWin = UIManager:GetWindow(UIWindowTypeID.SectorLevelDetail)
  if detailWin and detailWin.active then
    (UIUtil.OnClickBackByUiTab)(self)
  end
  self:_FinEnterMainEp(chapterId)
  return self.repeatLevel
end

ActivityWinter23Controller.ChangeWinter23MainEpSector = function(self, sectorId, chapterId)
  -- function num : 0_30 , upvalues : _ENV
  self:SelectDiffClient(sectorId)
  if sectorId and sectorId == self.sectorId then
    return 
  end
  self.sectorId = sectorId
  local detailWin = UIManager:GetWindow(UIWindowTypeID.SectorLevelDetail)
  if detailWin and detailWin.active then
    (UIUtil.OnClickBackByUiTab)(self)
  end
  self:_FinEnterMainEp(chapterId)
end

ActivityWinter23Controller._FinEnterMainEp = function(self, chapterId)
  -- function num : 0_31
  if self.repeatLevel then
    self:EnterWinter23MainEpRepeat()
  else
    self:ChangeWinter23MainEpChapter(chapterId)
  end
end

ActivityWinter23Controller.GetLevelListByChapterId = function(self, chapterId)
  -- function num : 0_32 , upvalues : _ENV
  local winter23Data = self:GetWinter23Data()
  local winter23Chapters = winter23Data:GetChaptersCfg()
  local levelList = {}
  if not chapterId then
    chapterId = self:GetLastUnCompleteChapter()
  end
  chapterId = (math.clamp)(chapterId, 1, 999)
  self.chapterId = chapterId
  for i,v in pairs(((winter23Chapters[self.sectorId])[chapterId]).stage_id) do
    (table.insert)(levelList, v)
  end
  return levelList
end

ActivityWinter23Controller._GetLevelListByRepeatId = function(self)
  -- function num : 0_33
  local winter23Data = self:GetWinter23Data()
  return winter23Data:GetRepeatStageList(self.sectorId)
end

ActivityWinter23Controller.GetNowChapterId = function(self)
  -- function num : 0_34
  return self.chapterId or 1
end

ActivityWinter23Controller.GetLastUnCompleteChapter = function(self)
  -- function num : 0_35 , upvalues : SectorStageDetailHelper, _ENV
  local winter23Data = self:GetWinter23Data()
  local winter23Chapters = winter23Data:GetChaptersCfg()
  local lastChapterId = 1
  local playMoudle = (SectorStageDetailHelper.SectorPlayMoudle)(self.sectorId)
  self.__lastEpStateCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)(playMoudle)
  for chapterId,cfg in pairs(winter23Chapters[self.sectorId]) do
    if #cfg.stage_id ~= 0 then
      lastChapterId = chapterId
      for _,levelId in pairs(cfg.stage_id) do
        local stageCfg = (ConfigData.sector_stage)[levelId]
        if (not (PlayerDataCenter.sectorStage):IsStageComplete(levelId) and not stageCfg.is_special) or self.__lastEpStateCfg and (self.__lastEpStateCfg).id == levelId then
          return lastChapterId
        end
      end
      do
        -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  return lastChapterId
end

ActivityWinter23Controller.RecordNowStageId = function(self, stageId)
  -- function num : 0_36
  self.nowStageId = stageId
end

ActivityWinter23Controller.SendRecordEnterInterface = function(self)
  -- function num : 0_37 , upvalues : _ENV
  local interfaceId = self.repeatLevel and 2 or 1
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_Client_Enter_Interface(interfaceId, self.nowStageId)
end

ActivityWinter23Controller.GiveSelectIsEnterStage = function(self, stageId, callback)
  -- function num : 0_38 , upvalues : _ENV, eActInteract23Winter
  local winter23Data = self:GetWinter23Data()
  if winter23Data:IsNotRepeatStageAndComplete(stageId) and (PlayerDataCenter.cacheSaveData):GetEnableActivityWinter23NoRepeatTip() then
    local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    local actLongId = winter23Data:GetActFrameId()
    local repeatName = (LanguageUtil.GetLocaleText)((((ConfigData.activity_lobby_interact_action)[actLongId])[(eActInteract23Winter.eLbIntrctActionId).Repeat]).obj_func_name)
    local msg = (string.format)(ConfigData:GetTipContent(7130), repeatName)
    window:ShowTextBoxWithYesAndNo(msg, function()
    -- function num : 0_38_0 , upvalues : callback
    callback()
  end
)
    window:ShowDontRemindTog(function(isOn)
    -- function num : 0_38_1 , upvalues : _ENV
    (PlayerDataCenter.cacheSaveData):SetEnableActivityWinter23NoRepeatTip(not isOn)
  end
)
  else
    do
      callback()
    end
  end
end

ActivityWinter23Controller.SetActWin23TipMode = function(self, isTipRepeat)
  -- function num : 0_39
  self.isTipRepeat = isTipRepeat
end

ActivityWinter23Controller.GetActWin23NameAndMode = function(self)
  -- function num : 0_40
  local actName, tipName = nil, nil
  if self.isTipRepeat then
    actName = self:GetActWin23NameAndRepeatMode()
  else
    -- DECOMPILER ERROR at PC11: Overwrote pending register: R2 in 'AssignReg'

    actName = self:GetActWin23NameAndMainMode()
  end
  return actName, tipName
end

ActivityWinter23Controller.GetActWin23NameAndMainMode = function(self)
  -- function num : 0_41 , upvalues : _ENV, eActInteract23Winter
  local actData = self:GetWinter23Data()
  local actLongId = actData:GetActFrameId()
  local mainName = (LanguageUtil.GetLocaleText)((((ConfigData.activity_lobby_interact_action)[actLongId])[(eActInteract23Winter.eLbIntrctActionId).Main]).obj_func_name)
  return (LanguageUtil.GetLocaleText)(actData:GetActivityName()), mainName
end

ActivityWinter23Controller.GetActWin23NameAndRepeatMode = function(self)
  -- function num : 0_42 , upvalues : _ENV, eActInteract23Winter
  local actData = self:GetWinter23Data()
  local actLongId = actData:GetActFrameId()
  local repeatName = (LanguageUtil.GetLocaleText)((((ConfigData.activity_lobby_interact_action)[actLongId])[(eActInteract23Winter.eLbIntrctActionId).Repeat]).obj_func_name)
  return (LanguageUtil.GetLocaleText)(actData:GetActivityName()), repeatName
end

ActivityWinter23Controller.SelectDiffClient = function(self, sectorId)
  -- function num : 0_43
  local actData = self:GetWinter23Data()
  actData:SetWinter23ClientRecordSector(sectorId)
end

return ActivityWinter23Controller

