-- params : ...
-- function num : 0 , upvalues : _ENV
local ActRefreshDunController = class("ActRefreshDunController", ControllerBase)
local base = ControllerBase
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActRefreshDunData = require("Game.ActivityRefreshDun.Data.ActRefreshDunData")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local FmtEnum = require("Game.Formation.FmtEnum")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
ActRefreshDunController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self.refreshDunNetWork = NetworkManager:GetNetwork(NetworkTypeID.RefreshDun)
  self.__ARDDataDic = {}
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon)
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon_hero)
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon_dun)
  self.__onTaskUpdate = BindCallback(self, self.__OnTaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskSyncFinish, self.__onTaskUpdate)
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActRefreshDunController.OnRefreshDunActivityOpen = function(self, actId)
  -- function num : 0_1 , upvalues : ActRefreshDunData
  if (self.__ARDDataDic)[actId] ~= nil then
    return 
  end
  local ARDData = (ActRefreshDunData.New)(actId)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__ARDDataDic)[actId] = ARDData
end

ActRefreshDunController.OnRefreshDunActivityClose = function(self, actId)
  -- function num : 0_2 , upvalues : _ENV
  local ARDData = (self.__ARDDataDic)[actId]
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__ARDDataDic)[actId] = nil
  if (table.count)(self.__ARDDataDic) <= 0 then
    ControllerManager:DeleteController(ControllerTypeId.ActRefreshDungeon)
  end
end

ActRefreshDunController.UpdataSingleRefreshDunActivity = function(self, msg)
  -- function num : 0_3
  if msg == nil then
    return 
  end
  local actId = msg.actId
  local ARDData = self:GetRefreshDunDataByActId(actId)
  if ARDData == nil then
    return 
  end
  ARDData:UpdateARDByMsg(msg)
  ;
  (self._frameCtrl):AddActivityDataUpdateTimeListen(ARDData:GetActFrameId(), ARDData:GetARDExpiredTm() + 1, self.__ExpireDealCallback)
end

ActRefreshDunController.UpdateAllRefreshDunActivity = function(self, msgs)
  -- function num : 0_4 , upvalues : _ENV
  if msgs == nil then
    return 
  end
  for _,msg in pairs(msgs) do
    self:UpdataSingleRefreshDunActivity(msg)
  end
end

ActRefreshDunController.GetRefreshDunDataByActId = function(self, actId)
  -- function num : 0_5
  return (self.__ARDDataDic)[actId]
end

ActRefreshDunController.TryOpenRefreshDun = function(self, actId, allLoadOverCallabck)
  -- function num : 0_6 , upvalues : _ENV
  if actId == nil then
    return false
  end
  local ARDData = self:GetRefreshDunDataByActId(actId)
  if ARDData == nil then
    return false
  end
  if UIManager:GetWindow(UIWindowTypeID.AprilFool) ~= nil then
    if allLoadOverCallabck ~= nil then
      allLoadOverCallabck()
    end
    return 
  end
  local openFunc = function()
    -- function num : 0_6_0 , upvalues : ARDData, _ENV, self, allLoadOverCallabck
    if ARDData == nil or not ARDData:IsActivityOpen() then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.AprilFool, function(win)
      -- function num : 0_6_0_0 , upvalues : ARDData, _ENV, self, allLoadOverCallabck
      if ARDData == nil or not ARDData:IsActivityOpen() then
        (UIUtil.ReturnHome)()
        return 
      end
      if win ~= nil then
        win:InitAprilFoolMain(self, ARDData)
      end
      if allLoadOverCallabck ~= nil then
        allLoadOverCallabck()
      end
      GuideManager:TryTriggerGuide(eGuideCondition.ActAprilFool)
    end
)
  end

  local avgId = ARDData:GetARDAvgId()
  if avgId ~= nil and avgId > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed(avgId)
    if not played and ARDData:IsActivityOpen() then
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId, openFunc)
    else
      openFunc()
    end
  else
    do
      openFunc()
      return true
    end
  end
end

ActRefreshDunController.ARDBuyReset = function(self, actId, callback)
  -- function num : 0_7
  (self.refreshDunNetWork):CS_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh(actId, callback)
end

ActRefreshDunController.ARDDunRefresh = function(self, actId, dungeonId, callback)
  -- function num : 0_8
  (self.refreshDunNetWork):CS_ACTIVITY_REFRESHDUNGEON_SingleRefresh(actId, dungeonId, callback)
end

ActRefreshDunController.ARDDunDayPass = function(self, callback)
  -- function num : 0_9
  (self.refreshDunNetWork):CS_ACTIVITY_REFRESHDUNGEON_FetchOverDay(callback)
end

ActRefreshDunController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_10 , upvalues : _ENV
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self.__ARDDataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  self:ARDDunDayPass(function()
    -- function num : 0_10_0 , upvalues : _ENV, self, activityFrameId, data
    local aprilFoolWin = UIManager:GetWindow(UIWindowTypeID.AprilFool)
    if aprilFoolWin ~= nil then
      aprilFoolWin:RefreshAprilFoolMain()
    end
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(activityFrameId, data:GetARDExpiredTm() + 1, self.__ExpireDealCallback)
  end
)
end

ActRefreshDunController.EnterARDDungeonFormation = function(self, ARDDunData)
  -- function num : 0_11 , upvalues : DungeonCenterUtil, _ENV, FmtEnum, DungeonInterfaceData
  local enterFunc = function()
    -- function num : 0_11_0 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
    UIManager:HideWindow(UIWindowTypeID.AprilFool)
  end

  local exitFunc = function(fmtId)
    -- function num : 0_11_1 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    UIManager:ShowWindowOnly(UIWindowTypeID.AprilFool)
  end

  local commonBattleFunc = nil
  local nextBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_11_2 , upvalues : _ENV, commonBattleFunc
    if dinterfaceData == nil then
      error("dungeon interface data is null,can\'t to next level")
      return 
    end
    local dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    if dungeonLevelData == nil then
      error("dungeon tower level data is null,can\'t to next level")
      return 
    end
    local nextDunLevelData = dungeonLevelData:GetNextTowerLevelData()
    commonBattleFunc(curSelectFormationData, callBack, nextDunLevelData)
  end

  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_11_3 , upvalues : ARDDunData, commonBattleFunc
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = ARDDunData
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_11_4 , upvalues : _ENV, FmtEnum, DungeonInterfaceData
    local actId = (dungeonLevelData.ARDData):GetActId()
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
    saveUserData:SetLastFromModuleFmtId((FmtEnum.eFmtFromModule).ARDDun, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_11_4_0 , upvalues : _ENV, actId
      local OpenFunc = function()
        -- function num : 0_11_4_0_0 , upvalues : _ENV, actId
        (UIUtil.CloseOneCover)("loadMatUIFunc")
        local ARDCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
        local couldOpen = ARDCtrl:TryOpenRefreshDun(actId)
        if not couldOpen then
          return 
        end
        local ARDData = ARDCtrl:GetRefreshDunDataByActId(actId)
        if ARDData ~= nil then
          ARDData:ARDRefreshAvgReddot()
        end
      end

      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_11_4_0_1 , upvalues : _ENV, OpenFunc
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        ;
        (UIUtil.AddOneCover)("loadMatUIFunc")
        sectorCtrl:SetFrom(AreaConst.DungeonBattle, OpenFunc)
        sectorCtrl:OnEnterActivity()
      end
)
    end
)
    local ARDCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
    local interfaceData = (DungeonInterfaceData.CreateARDDungeonInterface)(dungeonLevelData)
    interfaceData:SetAfterClickBattleFunc(function(callback)
      -- function num : 0_11_4_1 , upvalues : dungeonLevelData, _ENV
      local avgId = dungeonLevelData:GetARDDAvgId()
      local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
      local played = avgPlayCtrl:IsAvgPlayed(avgId)
      if not played then
        (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId, callback)
      else
        callback()
      end
    end
)
    local firstPower, benchPower = nil, nil
    local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, false)
    if fmtCtrl ~= nil then
      firstPower = fmtCtrl:CalculatePower(formationData)
    end
    ARDCtrl:RequestEnterARDDungeon(interfaceData, formationData, function()
      -- function num : 0_11_4_2 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
, firstPower, benchPower)
  end

  local needKey = ARDDunData:GetConsumeKeyNum()
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local stageId = ARDDunData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId((FmtEnum.eFmtFromModule).ARDDun)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).ARDDun, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(needKey)
  fmtCtrl:EnterFormation()
end

ActRefreshDunController.RequestEnterARDDungeon = function(self, interfaceData, formationData, callBack, firstPower, benchPower)
  -- function num : 0_12 , upvalues : _ENV
  local dungeonLevelData = interfaceData:GetIDungeonLevelData()
  local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
  local actId = (dungeonLevelData.ARDData):GetActId()
  ;
  (self.refreshDunNetWork):CS_ACTIVITY_REFRESHDUNGEON_EnterDungeon(actId, dungeonId, formationData, function(dataList)
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
, firstPower, benchPower)
end

ActRefreshDunController.__OnTaskUpdate = function(self)
  -- function num : 0_13 , upvalues : _ENV
  for _,ARDData in pairs(self.__ARDDataDic) do
    ARDData:ARDRefreshTaskReddot()
  end
end

ActRefreshDunController.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, eDynConfigData
  MsgCenter:RemoveListener(eMsgEventId.TaskSyncFinish, self.__onTaskUpdate)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon_hero)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon_dun)
end

return ActRefreshDunController

