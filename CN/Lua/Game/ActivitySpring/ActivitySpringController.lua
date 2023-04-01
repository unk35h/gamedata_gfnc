-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySpringController = class("ActivitySpringController", ControllerBase)
local JumpManager = require("Game.Jump.JumpManager")
local ActivitySpringData = require("Game.ActivitySpring.Data.ActivitySpringData")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local FmtEnum = require("Game.Formation.FmtEnum")
local eActInteract23Spring = require("Game.ActivityLobby.Activity.2023Spring.eActInteract")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local cs_MessageCommon = CS.MessageCommon
ActivitySpringController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dataDic = {}
  self._storyDic = {}
  self.__AvgCompleteCallback = BindCallback(self, self.__AvgComplete)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__AvgCompleteCallback)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self.__PreConditionCallback = BindCallback(self, self.__PreCondition)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__PreConditionCallback)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_main)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_advanced_env)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_difficulty)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_difficulty_catalog)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_level)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_level_detail)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_main_story)
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_interact_info)
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActivitySpringController.InitAllSpring = function(self, msgs)
  -- function num : 0_1 , upvalues : _ENV
  for _,msg in ipairs(msgs) do
    self:AddSpring(msg)
  end
end

ActivitySpringController.AddSpring = function(self, msg)
  -- function num : 0_2 , upvalues : ActivityFrameEnum, ActivitySpringData
  local frameData = (self._frameCtrl):GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Spring, msg.actId)
  if frameData == nil or not frameData:IsActivityOpen() then
    return 
  end
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ActivitySpringData.New)()
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  data:InitSpringData(msg)
  if frameData:IsInRuningState() then
    (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), data:GetSpringDailyTaskExpireTime() + 1, self.__ExpireDealCallback)
  end
end

ActivitySpringController.UpdateSpring = function(self, msg)
  -- function num : 0_3
  if (self._dataDic)[msg.actId] == nil then
    return 
  end
  ;
  ((self._dataDic)[msg.actId]):UpdateSpringData(msg)
end

ActivitySpringController.RemoveSpring = function(self, actId)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivitySpringController.__AvgComplete = function(self, avgId)
  -- function num : 0_5 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    data:CalSpringAvgState(avgId)
    data:RefreshSpringUnlockAvgPlayed()
  end
end

ActivitySpringController.OpenSpring = function(self, actId, skipStartShow, callback)
  -- function num : 0_6 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  ControllerManager:DeleteController(ControllerTypeId.SectorController)
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl, true)
  local mainActivityId = (data:GetSpringMainCfg()).activity_id
  ctrl:InitActLobbyCtrl(mainActivityId)
  if skipStartShow then
    ctrl:SkipActLbStartShow()
  end
  self._enterCompleteCallback = callback
end

ActivitySpringController.Spirng23OpenObj = function(self, ObjId)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActLobbyMain, false)
  if ObjId ~= nil then
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
    ;
    (ctrl.actLbIntrctCtrl):InvokeActLbEntity(ObjId)
    ObjId = nil
  end
end

ActivitySpringController.EnterSpringEp = function(self, data, envId, diffculty, index)
  -- function num : 0_8 , upvalues : _ENV, JumpManager, cs_MessageCommon, FmtEnum
  if data == nil then
    return 
  end
  local envCfg = (ConfigData.activity_spring_advanced_env)[envId]
  local stageId = (envCfg.stage_id)[index]
  if stageId == nil then
    error("env and diff can\'t confirm stage")
    return 
  end
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local enterFunc = function()
    -- function num : 0_8_0 , upvalues : _ENV
    UIManager:HideWindow(UIWindowTypeID.Spring23Main)
    UIManager:HideWindow(UIWindowTypeID.Spring23LevelModSelect)
  end

  local exitFunc = function()
    -- function num : 0_8_1 , upvalues : _ENV
    UIManager:ShowWindowOnly(UIWindowTypeID.Spring23Main)
    UIManager:ShowWindowOnly(UIWindowTypeID.Spring23LevelModSelect)
  end

  local startBattleFunc = function(curSelectFormationData, callBack)
    -- function num : 0_8_2 , upvalues : _ENV, stageCfg, JumpManager, cs_MessageCommon, fmtCtrl, stageId, saveUserData, FmtEnum
    if (PlayerDataCenter.stamina):GetCurrentStamina() < stageCfg.cost_strength_num then
      JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Sector_LackOfStamina))
      return 
    end
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    local totalFtPower, totalBenchPower = fmtCtrl:CalculatePower(curSelectFormationData)
    local curSelectFormationId = curSelectFormationData.id
    ;
    (PlayerDataCenter.sectorStage):SetSelectSectorId(stageCfg.sector)
    ExplorationManager:ReqEnterExploration(stageId, curSelectFormationId, proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration, false, callBack, curSelectFormationData:GetSupportHeroData(), false, nil, totalFtPower, totalBenchPower)
    saveUserData:SetLastFromModuleFmtId((FmtEnum.eFmtFromModule).SpringEp, curSelectFormationId)
  end

  local lastFmtId = saveUserData:GetLastFromModuleFmtId((FmtEnum.eFmtFromModule).SpringEp)
  fmtCtrl:ResetFmtCtrlState()
  ;
  ((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).SpringEp, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleTicketItemId(stageCfg.cost_strength_id)):SetEnterBattleCostTicketNum(stageCfg.cost_strength_num)
  fmtCtrl:EnterFormation()
end

ActivitySpringController.OnEnterSpringChallenge = function(self, springDungeonData)
  -- function num : 0_9 , upvalues : _ENV, JumpManager, FmtEnum, eActInteract23Spring, DungeonInterfaceData
  local enterFunc = function()
    -- function num : 0_9_0 , upvalues : _ENV
    UIManager:HideWindow(UIWindowTypeID.DungeonLevelDetail)
    UIManager:HideWindow(UIWindowTypeID.Spring23Challenge)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_9_1 , upvalues : _ENV
    UIManager:ShowWindowOnly(UIWindowTypeID.DungeonLevelDetail, true)
    UIManager:ShowWindowOnly(UIWindowTypeID.Spring23Challenge)
  end

  local commonBattleFunc = nil
  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_9_2 , upvalues : _ENV, springDungeonData, commonBattleFunc
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = springDungeonData
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_9_3 , upvalues : _ENV, JumpManager, FmtEnum, self, eActInteract23Spring, DungeonInterfaceData
    local needKey = dungeonLevelData:GetConsumeKeyNum()
    if (PlayerDataCenter.stamina):GetCurrentStamina() < needKey then
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
    saveUserData:SetLastFromModuleFmtId((FmtEnum.eFmtFromModule).Spring, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    BattleDungeonManager:InjectBattleWinEvent(function()
      -- function num : 0_9_3_0 , upvalues : dungeonLevelData, _ENV
      local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivitySpring, dungeonId, false, PlayerDataCenter.timestamp)
    end
)
    local springData = self:GetTheLastSpring()
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_9_3_1 , upvalues : _ENV, springData, self, eActInteract23Spring
      local OpenFunc = function()
        -- function num : 0_9_3_1_0 , upvalues : _ENV, springData, self, eActInteract23Spring
        (UIUtil.CloseOneCover)("loadMatUIFunc")
        local actId = springData:GetActId()
        self:OpenSpring(actId, true, function()
          -- function num : 0_9_3_1_0_0 , upvalues : springData, _ENV, eActInteract23Spring
          if springData:IsActivityRunning() then
            local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
            if ctrl ~= nil then
              (ctrl.actLbIntrctCtrl):InvokeActLbEntity((eActInteract23Spring.eLbIntrctEntityId).HardLevel)
            end
          end
        end
)
      end

      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_9_3_1_1 , upvalues : _ENV, springData, OpenFunc
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        if springData:IsActivityOpen() then
          (UIUtil.AddOneCover)("loadMatUIFunc")
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, OpenFunc)
          sectorCtrl:OnEnterActivity()
        else
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, function()
          -- function num : 0_9_3_1_1_0 , upvalues : sectorCtrl
          sectorCtrl:ResetToNormalState(false)
        end
)
        end
      end
)
    end
)
    local SpringCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
    local interfaceData = (DungeonInterfaceData.CreateSpringDungeonInterface)(dungeonLevelData)
    interfaceData:SetAfterClickBattleFunc(function(callback)
      -- function num : 0_9_3_2
      callback()
    end
)
    SpringCtrl:__ReqDungeonBattle(interfaceData, formationData, function()
      -- function num : 0_9_3_3 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
)
  end

  local needKey = springDungeonData:GetConsumeKeyNum()
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = springDungeonData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId((FmtEnum.eFmtFromModule).Spring)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).Spring, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(needKey)
  fmtCtrl:EnterFormation()
end

ActivitySpringController.__ReqDungeonBattle = function(self, interfaceData, formationData, callBack)
  -- function num : 0_10 , upvalues : _ENV
  local dungeonLevelData = interfaceData:GetIDungeonLevelData()
  local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(dungeonId, formationData, nil, function(dataList)
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
)
end

ActivitySpringController.RunEnterCompleteFunc = function(self)
  -- function num : 0_11
  if self._enterCompleteCallback then
    (self._enterCompleteCallback)()
  end
end

ActivitySpringController.IsHaveSpring = function(self)
  -- function num : 0_12 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySpringController.GetTheLastSpring = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local res = nil
  for k,v in pairs(self._dataDic) do
    if res == nil then
      res = v
    else
      if res:GetActivityBornTime() < v:GetActivityBornTime() then
        res = v
      end
    end
  end
  return res
end

ActivitySpringController.GetFirstSpringData = function(self)
  -- function num : 0_14
  return (self._dataDic)[1]
end

ActivitySpringController.GetSpringData = function(self, id)
  -- function num : 0_15
  return (self._dataDic)[id]
end

ActivitySpringController.CheckCostIsEnough = function(self, actId, interactId)
  -- function num : 0_16
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  local storyData = data:GetSpringStoryData()
  local costNum = ((self._dataDic)[actId]):GetInteractCostNum()
  return storyData:CostIsEnough(costNum, interactId)
end

ActivitySpringController.CheckAndTalk = function(self, actId, heroId, successCallback)
  -- function num : 0_17 , upvalues : cs_MessageCommon, _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  local storyData = data:GetSpringStoryData()
  local interactCfg, cantTalk = storyData:GetNowCfgByHeroId(heroId)
  if cantTalk then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)((string.format)(ConfigData:GetTipContent(9101)))
    if successCallback then
      successCallback()
    end
    return false
  end
  local costIsEnough = self:CheckCostIsEnough(actId, interactCfg.id)
  if not costIsEnough then
    local itemCfg = (ConfigData.item)[data:GetInteractCostId()]
    local costName = (LanguageUtil.GetLocaleText)(itemCfg.name)
    local tip = (string.format)(ConfigData:GetTipContent(9103), costName)
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(tip)
    if successCallback then
      successCallback()
    end
    return false
  end
  do
    local isLongTail = storyData:IsLongTail(interactCfg.id)
    if isLongTail then
      if (PlayerDataCenter.cacheSaveData):GetEnableActivitySpringLongTailConfirm() then
        local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
        local heroCfg = (ConfigData.hero_data)[interactCfg.interact_character]
        local msg = (string.format)(ConfigData:GetTipContent(9104), (LanguageUtil.GetLocaleText)(heroCfg.name))
        window:ShowTextBoxWithYesAndNo(msg, function()
    -- function num : 0_17_0 , upvalues : storyData, interactCfg, data, successCallback
    storyData:FinishTalk(interactCfg.id, function()
      -- function num : 0_17_0_0 , upvalues : data, successCallback
      data:RefreshSpringUnlockEnv(nil, true)
      if successCallback ~= nil then
        successCallback()
      end
    end
)
  end
, function()
    -- function num : 0_17_1 , upvalues : successCallback
    if successCallback then
      successCallback()
    end
  end
)
        window:ShowDontRemindTog(function(isOn)
    -- function num : 0_17_2 , upvalues : _ENV
    (PlayerDataCenter.cacheSaveData):SetEnableActivitySpringLongTailConfirm(not isOn)
  end
)
      else
        do
          storyData:FinishTalk(interactCfg.id, function()
    -- function num : 0_17_3 , upvalues : data, successCallback
    data:RefreshSpringUnlockEnv(nil, true)
    if successCallback ~= nil then
      successCallback()
    end
  end
)
          storyData:FinishTalk(interactCfg.id, function()
    -- function num : 0_17_4 , upvalues : data, successCallback
    data:RefreshSpringUnlockEnv(nil, true)
    if successCallback ~= nil then
      successCallback()
    end
  end
)
          return true
        end
      end
    end
  end
end

ActivitySpringController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_18 , upvalues : _ENV
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self._dataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  local net = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  net:CS_ACTIVITY_RefreshQuestDaily(activityFrameId, function(args)
    -- function num : 0_18_0 , upvalues : _ENV, data, self
    if (args == nil or args.Count == 0) and isGameDev then
      error("args.Count == 0")
    end
    local msg = args[0]
    data:AddSpringRefDailyTask(msg.taskIds, msg.nextFreshTime)
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), data:GetSpringDailyTaskExpireTime() + 1, self.__ExpireDealCallback)
    MsgCenter:Broadcast(eMsgEventId.ActivitySpringTaskExpired)
  end
)
end

ActivitySpringController.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_19 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for _,data in pairs(self._dataDic) do
    local dailyTaskIds = data:GetSpringRefreshTaskIds()
    if (table.contain)(dailyTaskIds, taskData.id) then
      data:RefreshRedDailyTask()
    else
      local onceTaskIds = data:GetSpringOnceTskIds()
      if (table.contain)(onceTaskIds, taskData.id) then
        data:RefreshRedOnceTask()
      end
    end
  end
end

ActivitySpringController.__ItemUpdate = function(self, _, _, itemDic)
  -- function num : 0_20 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    local techTree = data:GetSpringTechTree()
    if techTree ~= nil then
      local techTypeCostDic = techTree:GetTechTypeCostDic()
      for itemId,_ in pairs(techTypeCostDic) do
        if itemDic[itemId] ~= nil then
          data:RefreshRedSpringTech()
          break
        end
      end
    end
    do
      do
        data:RefreshRedTalk()
        -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

ActivitySpringController.__PreCondition = function(self, precondition)
  -- function num : 0_21 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    data:RefreshSpringUnlockEnv(precondition)
  end
end

ActivitySpringController.Delete = function(self)
  -- function num : 0_22 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_main)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_advanced_env)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_difficulty)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_difficulty_catalog)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_level)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_level_detail)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_main_story)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_interact_info)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__AvgCompleteCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__PreConditionCallback)
end

return ActivitySpringController

