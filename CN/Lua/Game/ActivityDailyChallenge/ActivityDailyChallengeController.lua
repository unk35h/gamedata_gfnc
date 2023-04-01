-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityDailyChallengeController = class("ActivityDailyChallengeController", ControllerBase)
local base = ControllerBase
local ADCData = require("Game.ActivityDailyChallenge.ActivityDailyChallengeData")
local ADCDungeonLevelData = require("Game.ActivityDailyChallenge.ADCDungeonLevelData")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local FmtEnum = require("Game.Formation.FmtEnum")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
local PeridicFmtBuffSelectData = require("Game.PeriodicChallenge.PeridicFmtBuffSelectData")
ActivityDailyChallengeController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._dataDic = {}
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActivityDailyChallengeController.AddADC = function(self, msg)
  -- function num : 0_1 , upvalues : ADCData
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ADCData.New)()
  data:InitADCData(msg)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  ;
  (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), data:GetADCKeyItemRecure() + 1, self.__ExpireDealCallback)
end

ActivityDailyChallengeController.UpdateADC = function(self, msg)
  -- function num : 0_2
  local data = (self._dataDic)[msg.actId]
  if data == nil then
    return 
  end
  data:UpdateADCData(msg)
end

ActivityDailyChallengeController.RemoveADC = function(self, actId)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivityDailyChallengeController.GetADC = function(self, actId)
  -- function num : 0_4
  return (self._dataDic)[actId]
end

ActivityDailyChallengeController.HasLiveADC = function(self)
  -- function num : 0_5 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityDailyChallengeController.GetADCOnce = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    do return v end
  end
  return nil
end

ActivityDailyChallengeController.RefreshADCDailyFlush = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    v:RefreshADCDailyFlush()
  end
end

ActivityDailyChallengeController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_8 , upvalues : _ENV
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self._dataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  local ADCNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityDailyChallenge)
  ADCNet:CS_ACTIVITY_DailyChallenge_RefreshUnlockItem(data:GetActId(), function(args)
    -- function num : 0_8_0 , upvalues : _ENV, data, self, activityFrameId
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    data:UpdateADCKeyItemMsg(msg)
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(activityFrameId, data:GetADCKeyItemRecure() + 1, self.__ExpireDealCallback)
  end
)
end

ActivityDailyChallengeController.TryADCOpenUI = function(self, actId, backFunc, callback)
  -- function num : 0_9 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EventDaliyChallenge, function(win)
    -- function num : 0_9_0 , upvalues : data, backFunc, callback
    if win == nil then
      return 
    end
    win:InitADCMain(data, backFunc)
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityDailyChallengeController.EnterADCDungeon = function(self, ADCDungeonLevelData)
  -- function num : 0_10 , upvalues : _ENV, DungeonCenterUtil, FmtEnum, DungeonInterfaceData
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local enterFunc = function()
    -- function num : 0_10_0 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
    UIManager:HideWindow(UIWindowTypeID.EventDaliyChallenge)
  end

  local exitFunc = function()
    -- function num : 0_10_1 , upvalues : DungeonCenterUtil, _ENV
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
    UIManager:ShowWindowOnly(UIWindowTypeID.EventDaliyChallenge)
  end

  local commonBattleFunc = nil
  local startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_10_2 , upvalues : ADCDungeonLevelData, commonBattleFunc
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = ADCDungeonLevelData
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_10_3 , upvalues : _ENV, FmtEnum, ADCDungeonLevelData, self, fmtCtrl, DungeonInterfaceData
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
    saveUserData:SetLastFromModuleFmtId((FmtEnum.eFmtFromModule).ADCDungeon, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    local adcData = ADCDungeonLevelData:GetDungeonADCData()
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_10_3_0 , upvalues : _ENV, adcData, self
      local OpenFunc = function()
        -- function num : 0_10_3_0_0 , upvalues : _ENV, adcData, self
        (UIUtil.CloseOneCover)("loadMatUIFunc")
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
        local actId = adcData:GetActId()
        self:TryADCOpenUI(actId, function()
          -- function num : 0_10_3_0_0_0 , upvalues : sectorCtrl
          sectorCtrl:ResetToNormalState(false)
        end
)
      end

      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_10_3_0_1 , upvalues : _ENV, adcData, OpenFunc
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        if adcData:IsActivityOpen() then
          (UIUtil.AddOneCover)("loadMatUIFunc")
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, OpenFunc)
          sectorCtrl:OnEnterActivity()
        else
          sectorCtrl:SetFrom(AreaConst.DungeonBattle, function()
          -- function num : 0_10_3_0_1_0 , upvalues : sectorCtrl
          sectorCtrl:ResetToNormalState(false)
        end
)
        end
      end
)
    end
)
    local peridicFmtBuffSelect = (fmtCtrl:GetCurEnterFmtData()):GetPeridicFmtBuffSelect()
    local interfaceData = (DungeonInterfaceData.CreateADCDungeonInterface)(dungeonLevelData, peridicFmtBuffSelect:GetFmtBuffCurAddScoreRate())
    interfaceData:SetAfterClickBattleFunc(function(callback)
      -- function num : 0_10_3_1
      callback()
    end
)
    self:__ReqDungeonBattle(interfaceData, peridicFmtBuffSelect, formationData, function()
      -- function num : 0_10_3_2 , upvalues : _ENV, callBack
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
)
  end

  local needKey = ADCDungeonLevelData:GetConsumeKeyNum()
  local stageId = ADCDungeonLevelData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId((FmtEnum.eFmtFromModule).ADCDungeon)
  local fmtBuffSelectData = (ADCDungeonLevelData:GetDungeonADCData()):GetADCBuffSelectData(stageId)
  fmtCtrl:ResetFmtCtrlState()
  ;
  (((((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).ADCDungeon, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(needKey)):SetIsOpenBuffSelect(fmtBuffSelectData ~= nil)):SetPeridicFmtBuffSelect(fmtBuffSelectData)):SetIsShowTotalPow(false)):SetIsOpenBuffWhenEnter(true)
  fmtCtrl:EnterFormation()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityDailyChallengeController.__ReqDungeonBattle = function(self, interfaceData, fmtBuffSelectData, formationData, callBack)
  -- function num : 0_11 , upvalues : _ENV
  local dungenLevelData = interfaceData:GetIDungeonLevelData()
  local dungeonId = (dungenLevelData:GetDungeonLevelStageId())
  local buff = nil
  if fmtBuffSelectData ~= nil and fmtBuffSelectData:GetFmtBuffSelect() ~= nil then
    local buffIds = fmtBuffSelectData:GetFmtBuffSelect()
    buff = {}
    for _,buffId in ipairs(buffIds) do
      buff[buffId] = true
    end
  end
  do
    local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
    activityFrameNet:CS_ACTIVITY_DUNGEON_GeneralEnter(dungeonId, formationData, buff, function(dataList)
    -- function num : 0_11_0 , upvalues : _ENV, interfaceData, callBack
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
end

ActivityDailyChallengeController.OnDelete = function(self)
  -- function num : 0_12
end

return ActivityDailyChallengeController

