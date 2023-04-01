-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityCarnivalController = class("ActivityCarnivalController", ControllerBase)
local base = ControllerBase
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
local ActivityCarnivalData = require("Game.ActivityCarnival.ActivityCarnivalData")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local FmtEnum = require("Game.Formation.FmtEnum")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
ActivityCarnivalController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dataDic = {}
  self.__PreconditionCallback = BindCallback(self, self.__Precondition)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__PreconditionCallback)
  self.__AvgPlayedCallBack = BindCallback(self, self.__AvgPlayed)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__AvgPlayedCallBack)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskChange)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self.__TaskCommitCallback = BindCallback(self, self.__TaskCommit)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__TaskCommitCallback)
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActivityCarnivalController.InitAllCarnival = function(self, msgs)
  -- function num : 0_1 , upvalues : _ENV
  for i,msg in ipairs(msgs) do
    self:AddCarnivalAct(msg)
  end
end

ActivityCarnivalController.AddCarnivalAct = function(self, msg)
  -- function num : 0_2 , upvalues : ActivityCarnivalData
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ActivityCarnivalData.New)()
  data:InitActivityCarnival(msg)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  ;
  (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), data:GetCarnivalTaskNextTm() + 1, self.__ExpireDealCallback)
end

ActivityCarnivalController.UpdateCarnivalAct = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  if (self._dataDic)[msg.actId] == nil then
    return 
  end
  ;
  ((self._dataDic)[msg.actId]):UpdateCarnival(msg)
  MsgCenter:Broadcast(eMsgEventId.ActivityCarnivalTimePass)
end

ActivityCarnivalController.RemoveCarnivalAct = function(self, actId)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivityCarnivalController.__Precondition = function(self, precondition)
  -- function num : 0_5 , upvalues : _ENV
  for _,carnivalData in pairs(self._dataDic) do
    carnivalData:CalCarnivalEnvByCondition(precondition)
    carnivalData:CalCarnivalStageAndAvgState(precondition)
  end
end

ActivityCarnivalController.__AvgPlayed = function(self, avgId)
  -- function num : 0_6 , upvalues : _ENV
  for _,carnivalData in pairs(self._dataDic) do
    carnivalData:CalCarnivalAvgState(avgId)
  end
end

ActivityCarnivalController.__TaskChange = function(self, taskData)
  -- function num : 0_7 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for _,data in pairs(self._dataDic) do
    local questDic = data:GetCarnivalTask()
    if questDic[taskData.id] ~= nil then
      data:UpdateCarnivalTaskReddot()
    end
  end
end

ActivityCarnivalController.__TaskCommit = function(self, taskCfg)
  -- function num : 0_8 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    local questDic = data:GetCarnivalTask()
    if questDic[taskCfg.id] ~= nil then
      data:UpdateCarnivalTaskReddot()
    end
  end
end

ActivityCarnivalController.GetCarnivalAct = function(self, actId)
  -- function num : 0_9
  return (self._dataDic)[actId]
end

ActivityCarnivalController.IsHaveCarnivalAct = function(self)
  -- function num : 0_10 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityCarnivalController.GetTheLastCarnival = function(self)
  -- function num : 0_11 , upvalues : _ENV
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

ActivityCarnivalController.GetCarnivalDataBySectorId = function(self, sectorId)
  -- function num : 0_12 , upvalues : _ENV
  local actId = ((ConfigData.activity_carnival).sectorMapping)[sectorId]
  if actId == nil then
    return nil, nil, nil, nil
  end
  local data = (self._dataDic)[actId]
  if data == nil then
    return actId, nil, false, false
  end
  return actId, data, data:IsActivityRunning(), data:IsActivityOpen()
end

ActivityCarnivalController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_13 , upvalues : _ENV, ActivityCarnivalEnum
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self._dataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  local actCarnivalNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.ActivityCarnival)
  actCarnivalNetCtrl:CS_ACTIVITY_Carnival_RefreshPeriod(data:GetActId(), function()
    -- function num : 0_13_0 , upvalues : _ENV, data, ActivityCarnivalEnum, self, activityFrameId
    if UIManager:GetWindow(UIWindowTypeID.Carnival22Task) ~= nil then
      return 
    end
    local reddot = data:GetActivityReddot()
    if reddot == nil then
      return 
    end
    local childReddot = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).TaskPeriod)
    childReddot:SetRedDotCount(1)
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(activityFrameId, data:GetCarnivalTaskNextTm() + 1, self.__ExpireDealCallback)
  end
)
end

ActivityCarnivalController.TryCarnivalOpenUI = function(self, actId, enterSectorFunc, backFunc, callback)
  -- function num : 0_14 , upvalues : _ENV
  local carnivalData = (self._dataDic)[actId]
  if carnivalData == nil then
    return false
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22Main, function(window)
    -- function num : 0_14_0 , upvalues : carnivalData, enterSectorFunc, backFunc, callback
    if window == nil then
      return 
    end
    window:InitCarnivalMain(carnivalData, enterSectorFunc, backFunc)
    if callback ~= nil then
      callback(window)
    end
  end
)
  return true
end

ActivityCarnivalController.OnEnterCarnivalChallenge = function(self, carnivalDungeonData)
  -- function num : 0_15 , upvalues : DungeonCenterUtil, _ENV, FmtEnum, DungeonInterfaceData
  local enterFunc = function()
    -- function num : 0_15_0 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
    UIManager:HideWindow(UIWindowTypeID.Carnival22Main)
    UIManager:HideWindow(UIWindowTypeID.Carnival22Challenge)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_15_1 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    UIManager:ShowWindowOnly(UIWindowTypeID.Carnival22Main)
    UIManager:ShowWindowOnly(UIWindowTypeID.Carnival22Challenge)
  end

  local commonBattleFunc = nil
  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_15_2 , upvalues : carnivalDungeonData, commonBattleFunc
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = carnivalDungeonData
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_15_3 , upvalues : _ENV, FmtEnum, self, DungeonInterfaceData
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
    saveUserData:SetLastFromModuleFmtId((FmtEnum.eFmtFromModule).CarnivalDungeon, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    BattleDungeonManager:InjectBattleWinEvent(function()
      -- function num : 0_15_3_0 , upvalues : dungeonLevelData, _ENV
      local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
      PlayerDataCenter:LocallyAddDungeonLimit(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityCarnival, dungeonId, false, PlayerDataCenter.timestamp)
    end
)
    local carnivalData = self:GetTheLastCarnival()
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_15_3_1 , upvalues : _ENV, carnivalData, self
      local OpenFunc = function()
        -- function num : 0_15_3_1_0 , upvalues : _ENV, carnivalData, self
        (UIUtil.CloseOneCover)("loadMatUIFunc")
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        local actId = carnivalData:GetActId()
        self:TryCarnivalOpenUI(actId, sectorCtrl.__EnterSectorLevelFunc, sectorCtrl.__ResetToNormalState, function(win)
          -- function num : 0_15_3_1_0_0 , upvalues : carnivalData
          if carnivalData:IsActivityRunning() then
            win:OnClickHardDungeon()
          end
        end
)
      end

      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_15_3_1_1 , upvalues : _ENV, carnivalData, OpenFunc
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        if carnivalData:IsActivityOpen() then
          (UIUtil.AddOneCover)("loadMatUIFunc")
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, OpenFunc)
          sectorCtrl:OnEnterActivity()
        else
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, function()
          -- function num : 0_15_3_1_1_0 , upvalues : sectorCtrl
          sectorCtrl:ResetToNormalState(false)
        end
)
        end
      end
)
    end
)
    local ARDCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
    local interfaceData = (DungeonInterfaceData.CreateCarnivalDungeonInterface)(dungeonLevelData)
    interfaceData:SetAfterClickBattleFunc(function(callback)
      -- function num : 0_15_3_2
      callback()
    end
)
    ARDCtrl:__ReqDungeonBattle(interfaceData, formationData, function()
      -- function num : 0_15_3_3 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
)
  end

  local needKey = carnivalDungeonData:GetConsumeKeyNum()
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = carnivalDungeonData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId((FmtEnum.eFmtFromModule).CarnivalDungeon)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).CarnivalDungeon, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(needKey)
  fmtCtrl:EnterFormation()
end

ActivityCarnivalController.__ReqDungeonBattle = function(self, interfaceData, formationData, callBack)
  -- function num : 0_16 , upvalues : _ENV
  local dungeonLevelData = interfaceData:GetIDungeonLevelData()
  local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(dungeonId, formationData, nil, function(dataList)
    -- function num : 0_16_0 , upvalues : _ENV, interfaceData, callBack
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

ActivityCarnivalController.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__PreconditionCallback)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__AvgPlayedCallBack)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__TaskCommitCallback)
end

return ActivityCarnivalController

