-- params : ...
-- function num : 0 , upvalues : _ENV
WarChessSeasonManager = {}
local WarChessSeasonCtrl = require("Game.WarChessSeason.WarChessSeasonCtrl")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessSeasonSettleHanlder = require("Game.WarChessSeason.WarChessSeasonSettleHanlder")
local cs_MessageCommon = CS.MessageCommon
-- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV, WarChessSeasonSettleHanlder
  self.__wcSeasonCtrl = nil
  self.__wcNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.WarChess)
  self.__isHaveUncompleteWCS = false
  self.__uncompleteWCSData = nil
  self.__wcsSavingDataDic = nil
  self.__WCSLevelNameStr = nil
  self.__WCSLevelIndexStr = nil
  self.__enterNextFloorFormInfo = nil
  self._settleHandler = (WarChessSeasonSettleHanlder.New)()
  self.__passedWarChessSeasonDic = nil
end

-- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetIsInWCSeason = function(self)
  -- function num : 0_1
  return self.__isInWCSeason
end

-- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetIsInWCSeasonNotFirstLevel = function(self)
  -- function num : 0_2
  if self.__isInWCSeason then
    return not (self.__wcSeasonCtrl).isInFirstLobby
  end
end

-- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetIsInWCSeasonIsInLobby = function(self)
  -- function num : 0_3
  if self.__isInWCSeason then
    return (self.__wcSeasonCtrl).isInLobby
  end
end

-- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.InitWCSeasonCtrl = function(self, seasonId, towerId, envId)
  -- function num : 0_4 , upvalues : WarChessSeasonCtrl
  self.__isInWCSeason = true
  self.__wcSeasonCtrl = (WarChessSeasonCtrl.New)(seasonId, towerId, envId)
end

-- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GiveUpLastWarchessSeason = function(self)
  -- function num : 0_5 , upvalues : _ENV, cs_MessageCommon
  local rewardList = nil
  if self.__uncompleteWCSData ~= nil then
    rewardList = (self.__uncompleteWCSData).strengthWinReward
  else
    rewardList = false
  end
  self._stageId = (self.__uncompleteData ~= nil and (self.__uncompleteData).sectorStageId)
  WarChessManager:OpenWCRewardBagSelect(rewardList, function(pickInfo)
    -- function num : 0_5_0 , upvalues : self, cs_MessageCommon, _ENV
    self._stageId = nil
    ;
    (self.__wcNetworkCtrl):CS_WarChess_Quit(pickInfo, function(args)
      -- function num : 0_5_0_0 , upvalues : cs_MessageCommon, _ENV
      local warChessSettleData = (args[0]).data
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8706))
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_5_0_0_0 , upvalues : _ENV, warChessSettleData
        if window ~= nil then
          local CommonRewardData = require("Game.CommonUI.CommonRewardData")
          local CRData = ((CommonRewardData.CreateCRDataUseDic)((warChessSettleData.rewards).stmStorePickRewards)):SetCRNotHandledGreat(true)
          window:AddAndTryShowReward(CRData)
        end
      end
)
    end
)
  end
)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.ExitWarChessClean = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.__isInWCSeason = nil
  self.__isHaveUncompleteWCS = nil
  self.__uncompleteWCSData = nil
  self._addtionData = nil
  if self.__wcSeasonCtrl ~= nil then
    (self.__wcSeasonCtrl):Delete()
    self.__wcSeasonCtrl = nil
  end
  self._techOpenFunc = nil
  self._techRedShowFunc = nil
  MsgCenter:Broadcast(eMsgEventId.WCS_ExitAndClear)
end

-- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.EnterWarChessSeasonBySeasonGroupId = function(self, seasonId, towerId, envId)
  -- function num : 0_7 , upvalues : _ENV
  self:InitWCSeasonCtrl(seasonId, towerId, envId)
  ;
  (self.__wcNetworkCtrl):CS_WarChess_EnterWarChessLobby(seasonId, towerId, true, envId, function(argList)
    -- function num : 0_7_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local lobbyMessage = argList[0]
    self._isFirstEnter = true
    self:CleanOrtherWhenEnter()
    ;
    (self.__wcSeasonCtrl):EnterWCSeasonLobbyByMsg(lobbyMessage)
  end
)
end

-- DECOMPILER ERROR at PC39: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.CleanOrtherWhenEnter = function(self)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

  (self.__wcSeasonCtrl).WCS3DUINode = nil
  UIManager:DeleteAllWindow()
  ControllerManager:DeleteController(ControllerTypeId.SectorController)
end

-- DECOMPILER ERROR at PC42: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSCtrl = function(self)
  -- function num : 0_9
  return self.__wcSeasonCtrl
end

-- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSSeasonTowerID = function(self)
  -- function num : 0_10
  if self.__uncompleteWCSData ~= nil then
    return (self.__uncompleteWCSData).towerId
  end
  return (self.__wcSeasonCtrl):GetWCSTowerId()
end

-- DECOMPILER ERROR at PC48: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.IsInWCS = function(self)
  -- function num : 0_11
  do return self.__wcSeasonCtrl ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC51: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSSeasonCfg = function(self)
  -- function num : 0_12
  return (self.__wcSeasonCtrl):GetWCSSeasonCfg()
end

-- DECOMPILER ERROR at PC54: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSSeasonId = function(self)
  -- function num : 0_13
  return (self.__wcSeasonCtrl):GetWCSSeasonId()
end

-- DECOMPILER ERROR at PC57: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCHighesScore = function(self)
  -- function num : 0_14
  if self._addtionData == nil then
    return 0
  end
  return (self._addtionData):GetSeasonHighesScore()
end

-- DECOMPILER ERROR at PC60: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSRecommendPower = function(self)
  -- function num : 0_15
  if self._addtionData == nil then
    return 0
  end
  return (self._addtionData):GetSeasonRecommendPower()
end

-- DECOMPILER ERROR at PC63: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SetWCSEnterNextFloorTeamInfo = function(self, info)
  -- function num : 0_16
  self.__enterNextFloorFormInfo = info
end

-- DECOMPILER ERROR at PC66: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSEnterNextFloorTeamInfo = function(self)
  -- function num : 0_17
  return self.__enterNextFloorFormInfo
end

-- DECOMPILER ERROR at PC69: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SetWarChessSeasonName = function(self, name, indexStr)
  -- function num : 0_18
  self.__WCSLevelNameStr = name
  self.__WCSLevelIndexStr = indexStr
end

-- DECOMPILER ERROR at PC72: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SetOutSideInfo2WCManager = function(self)
  -- function num : 0_19 , upvalues : _ENV
  ((self.__wcSeasonCtrl):WCSGetFloor())
  local floorIndex = nil
  local indexStr = nil
  if self.__WCSLevelIndexStr ~= nil then
    (string.format)(self.__WCSLevelIndexStr, tostring(floorIndex))
  else
    indexStr = "Level " .. tostring(floorIndex)
  end
  WarChessManager:SetLevelNameAndIndex(self.__WCSLevelNameStr or "???", indexStr)
  WarChessManager:SetWCRecommendPower(self:GetWCSRecommendPower())
end

-- DECOMPILER ERROR at PC75: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.WarChessSeasonEnterDoor = function(self, wcLevelId, envBuffData, levelPressAddNum)
  -- function num : 0_20 , upvalues : eWarChessEnum, _ENV
  local SingleStart = function()
    -- function num : 0_20_0 , upvalues : self, eWarChessEnum, wcLevelId, _ENV, envBuffData, levelPressAddNum
    self._isFirstEnter = false
    local warChessType = (eWarChessEnum.eBriefDetailType).season
    ;
    (self.__wcNetworkCtrl):CS_WarChess_SingleStart(wcLevelId, nil, nil, warChessType, function(argList)
      -- function num : 0_20_0_0 , upvalues : _ENV, self, envBuffData, levelPressAddNum
      if argList.Count ~= 1 then
        error("argList.Count error:" .. tostring(argList.Count))
        return 
      end
      local warChessMsg = argList[0]
      WarChessManager:ExitWarChessClean()
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.__wcSeasonCtrl).__formMsg = warChessMsg.forms
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.__wcSeasonCtrl).warChessSeasonFloor = warChessMsg.warChessSeasonFloor
      ;
      ((UIManager:ShowWindow(UIWindowTypeID.CommonMask)):InitCommonMask(Color.black)):CommonMaskFadeIn(0.3, function()
        -- function num : 0_20_0_0_0 , upvalues : self, warChessMsg, _ENV, envBuffData, levelPressAddNum
        self:CleanOrtherWhenEnter()
        ;
        (self.__wcSeasonCtrl):WCSSetSurWCSRoomData(warChessMsg.RoomData)
        WarChessSeasonManager:SetOutSideInfo2WCManager()
        self:SetWCSEnterNextFloorTeamInfo(warChessMsg.forms)
        WarChessManager:EnterWarChessByOutMsg(warChessMsg)
        local wcCtrl = WarChessManager:GetWarChessCtrl()
        ;
        (wcCtrl.palySquCtrl):SetWCSLevelBuff(envBuffData)
        ;
        (wcCtrl.palySquCtrl):SetWCSLevelPressAdd(levelPressAddNum)
        -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

        ;
        (self.__wcSeasonCtrl).isInLobby = false
        -- DECOMPILER ERROR at PC32: Confused about usage of register: R1 in 'UnsetPending'

        ;
        (self.__wcSeasonCtrl).isInFirstLobby = false
      end
)
    end
)
  end

  if self:GetIsInWCSeasonIsInLobby() then
    (self.__wcNetworkCtrl):CS_WarChess_Settle(nil, function()
    -- function num : 0_20_1 , upvalues : SingleStart
    SingleStart()
  end
)
    return 
  end
  SingleStart()
end

-- DECOMPILER ERROR at PC78: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.WarChessSeasonEnterLobby = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local wcSeasonId = (self.__wcSeasonCtrl):GetWCSSeasonId()
  local wcTowerId = (self.__wcSeasonCtrl):GetWCSTowerId()
  local envId = ((self.__wcSeasonCtrl):GetWCEnvCfg()).id
  ;
  (self.__wcNetworkCtrl):CS_WarChess_EnterWarChessLobby(wcSeasonId, wcTowerId, false, envId, function(argList)
    -- function num : 0_21_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local lobbyMessage = argList[0]
    self:CleanOrtherWhenEnter()
    WarChessManager:ExitWarChessClean()
    WarChessSeasonManager:SetWCSEnterNextFloorTeamInfo((lobbyMessage.backLobbyReMainData).forms)
    ;
    ((UIManager:ShowWindow(UIWindowTypeID.CommonMask)):InitCommonMask(Color.black)):CommonMaskFadeIn(0.3, function()
      -- function num : 0_21_0_0 , upvalues : self, lobbyMessage
      (self.__wcSeasonCtrl):EnterWCSeasonLobbyByMsg(lobbyMessage)
      -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.__wcSeasonCtrl).isInLobby = true
    end
)
  end
)
end

-- DECOMPILER ERROR at PC81: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.OnWCSceneLoadOver = function(self)
  -- function num : 0_22 , upvalues : _ENV, eWarChessEnum
  if self:GetIsInWCSeasonNotFirstLevel() then
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    if wcCtrl.state == (eWarChessEnum.eWarChessState).deploy then
      (wcCtrl.curState):WCAutoDeploy()
      ;
      (wcCtrl.curState):WCStartPlay()
    end
  end
end

-- DECOMPILER ERROR at PC84: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.OnWCEnterPlayState = function(self)
  -- function num : 0_23 , upvalues : _ENV, eWarChessEnum
  if self.__wcSeasonCtrl ~= nil and (self.__wcSeasonCtrl).__formMsg ~= nil then
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    ;
    (wcCtrl.teamCtrl):WCReaddAllChipData((self.__wcSeasonCtrl).__formMsg)
    local BattlePlayerDiff = {}
    local teamStateDic = {}
    for _,fInfo in pairs((self.__wcSeasonCtrl).__formMsg) do
      local isDead = fInfo.teamState & (eWarChessEnum.eWCTeamState).Die > 0
      if not isDead then
        BattlePlayerDiff[fInfo.teamUid] = fInfo.player
      end
      teamStateDic[fInfo.teamUid] = fInfo.teamState
    end
    ;
    (wcCtrl.teamCtrl):WCUpdateTeamState(teamStateDic)
    ;
    (wcCtrl.teamCtrl):UpdateWCCommander(BattlePlayerDiff)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).__formMsg = nil
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC87: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SetUncompleteWCSData = function(self, isHave, briefMsg)
  -- function num : 0_24
  self.__isHaveUncompleteWCS = isHave
  if isHave then
    if briefMsg == nil then
      self.__isHaveUncompleteWCS = false
      return 
    end
    local seasonId = briefMsg.seasonId
    local towerId = briefMsg.towerId
    local levelId = briefMsg.warchessId
    local floorId = briefMsg.floorId
    local isInWarChessLobby = briefMsg.isInWarChessLobby
    local strengthWinReward = briefMsg.strengthWinReward
    if self.__uncompleteWCSData == nil then
      self.__uncompleteWCSData = {}
    end
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__uncompleteWCSData).seasonId = seasonId
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__uncompleteWCSData).towerId = towerId
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__uncompleteWCSData).levelId = levelId
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__uncompleteWCSData).floorId = floorId
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__uncompleteWCSData).isInWarChessLobby = isInWarChessLobby
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__uncompleteWCSData).strengthWinReward = strengthWinReward
  else
    do
      self.__uncompleteWCSData = nil
    end
  end
end

-- DECOMPILER ERROR at PC90: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetUncompleteWCSData = function(self)
  -- function num : 0_25
  return self.__isHaveUncompleteWCS, self.__uncompleteWCSData
end

-- DECOMPILER ERROR at PC93: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.WCSReconnect = function(self)
  -- function num : 0_26 , upvalues : eWarChessEnum, _ENV
  local warChessType = (eWarChessEnum.eBriefDetailType).season
  ;
  (self.__wcNetworkCtrl):CS_WarChess_Detail(warChessType, function(argList)
    -- function num : 0_26_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local warChessMsg = argList[0]
    local wcSeasonId = (self.__uncompleteWCSData).seasonId
    local wcTowerId = (self.__uncompleteWCSData).towerId
    local envId = (warChessMsg.data).seasonEnvId
    self:InitWCSeasonCtrl(wcSeasonId, wcTowerId, envId)
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).isInFirstLobby = ((self.__uncompleteWCSData).floorId == 1 and (self.__uncompleteWCSData).isInWarChessLobby)
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).isInLobby = (self.__uncompleteWCSData).isInWarChessLobby
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).warChessSeasonFloor = (self.__uncompleteWCSData).floorId
    self:CleanOrtherWhenEnter()
    self._isFirstEnter = true
    if (self.__wcSeasonCtrl).isInLobby then
      local lobbyMessage = {RoomData = (warChessMsg.data).NextRoomData, backLobbyReMainData = warChessMsg.data}
      ;
      (self.__wcSeasonCtrl):WCSSetSurWCSRoomData(nil)
      ;
      (self.__wcSeasonCtrl):EnterWCSeasonLobbyByMsg(lobbyMessage, true)
    else
      (self.__wcSeasonCtrl):WCSSetSurWCSRoomData((warChessMsg.data).RoomData)
      WarChessSeasonManager:SetOutSideInfo2WCManager()
      WarChessManager:EnterWarChessByOutMsg(warChessMsg.data, true)
    end
    self:SetUncompleteWCSData(false)
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
end

-- DECOMPILER ERROR at PC96: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.WCSSettle = function(self, isWin, settleMsg, WCResultFunc)
  -- function num : 0_27
  local nextWarChessLobby = settleMsg.nextWarChessLobby
  local nextRooms = settleMsg.RoomData
  local seasonSettle = nextWarChessLobby or (nextRooms ~= nil and #nextRooms > 0)
  if seasonSettle then
    (self._settleHandler):EnterWarchessLevel(isWin, settleMsg, WCResultFunc)
  else
    (self._settleHandler):EnterWarchessSeason(isWin, settleMsg, WCResultFunc)
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC99: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SyncWCSSavingData = function(self, callback)
  -- function num : 0_28 , upvalues : _ENV
  (self.__wcNetworkCtrl):CS_WarChess_GetSeasonBackup(function(args)
    -- function num : 0_28_0 , upvalues : _ENV, self, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local saveMsgDatas = args[0]
    self.__wcsSavingDataDic = {}
    for _,WarChessSeasonElem in pairs(saveMsgDatas) do
      local index = WarChessSeasonElem.warChessSeasonbackUpId
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.__wcsSavingDataDic)[index] = WarChessSeasonElem
    end
    if callback ~= nil then
      callback()
    end
  end
)
end

-- DECOMPILER ERROR at PC102: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSSavingData = function(self)
  -- function num : 0_29
  return self.__wcsSavingDataDic
end

-- DECOMPILER ERROR at PC105: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SaveWCSSavingData = function(self, index, callback)
  -- function num : 0_30 , upvalues : _ENV
  (self.__wcNetworkCtrl):CS_WarChess_SetSeasonBackup(index, function()
    -- function num : 0_30_0 , upvalues : callback, _ENV, self
    if callback ~= nil then
      callback()
    end
    if isGameDev then
      print("<color=green>SAVE COMPLETE</color>")
    end
    self:SyncWCSSavingData(function()
      -- function num : 0_30_0_0 , upvalues : _ENV
      MsgCenter:Broadcast(eMsgEventId.WCS_SavingDataRefresh)
    end
)
  end
)
end

-- DECOMPILER ERROR at PC108: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.ReadWCSSavingData = function(self, index)
  -- function num : 0_31 , upvalues : _ENV
  local savingData = (self.__wcsSavingDataDic)[index]
  if savingData == nil then
    error("saving data not exist")
    return 
  end
  ;
  (self.__wcNetworkCtrl):CS_WarChess_SeasonBackupChoice(index, function(args)
    -- function num : 0_31_0 , upvalues : _ENV, savingData, self
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local warChessMsg = args[0]
    local inWarChessLobby = savingData.inWarChessLobby
    local floorId = savingData.warChessSeasonFloor
    local seasonId = savingData.warChessSeasonId
    local towerId = savingData.warChessTowerId
    local envId = warChessMsg.seasonEnvId
    self:InitWCSeasonCtrl(seasonId, towerId, envId)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).isInFirstLobby = (floorId == 1 and inWarChessLobby)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).isInLobby = inWarChessLobby
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__wcSeasonCtrl).warChessSeasonFloor = floorId
    self:CleanOrtherWhenEnter()
    if (self.__wcSeasonCtrl).isInLobby then
      local lobbyMessage = {RoomData = warChessMsg.NextRoomData, backLobbyReMainData = warChessMsg}
      ;
      (self.__wcSeasonCtrl):WCSSetSurWCSRoomData(nil)
      ;
      (self.__wcSeasonCtrl):EnterWCSeasonLobbyByMsg(lobbyMessage, true)
    else
      (self.__wcSeasonCtrl):WCSSetSurWCSRoomData(warChessMsg.RoomData)
      WarChessSeasonManager:SetOutSideInfo2WCManager()
      WarChessManager:EnterWarChessByOutMsg(warChessMsg, true)
    end
    self:SetUncompleteWCSData(false)
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
end

-- DECOMPILER ERROR at PC111: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SetSeasonAddtionData = function(self, seasonAddtionData)
  -- function num : 0_32
  self._addtionData = seasonAddtionData
end

-- DECOMPILER ERROR at PC114: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetSeasonAddtionData = function(self)
  -- function num : 0_33
  return self._addtionData
end

-- DECOMPILER ERROR at PC117: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.IsFirstSeasonEnter = function(self)
  -- function num : 0_34
  return self._isFirstEnter
end

-- DECOMPILER ERROR at PC120: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSEnvCfgList = function(self, seasonId)
  -- function num : 0_35 , upvalues : _ENV
  local wcsCfg = (ConfigData.warchess_season)[seasonId]
  local envCfgList = {}
  if wcsCfg == nil then
    error("wcsCfg not exist,seasonId:" .. tostring(seasonId))
    return nil
  end
  for _,envId in ipairs(wcsCfg.env_id) do
    local envCfg = (ConfigData.warchess_season_general_env)[envId]
    if envCfg == nil then
      error("wcs envCfg not exist, envId:" .. tostring(envId))
    else
      ;
      (table.insert)(envCfgList, envCfg)
    end
  end
  return envCfgList
end

-- DECOMPILER ERROR at PC123: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetEnvCfgBySeasonAndDiff = function(self, seasonId, diffId)
  -- function num : 0_36 , upvalues : _ENV
  local envCfg = nil
  local envCfgList = WarChessSeasonManager:GetWCSEnvCfgList(seasonId)
  for _,_envCfg in ipairs(envCfgList) do
    if (table.contain)(_envCfg.difficulty_id, diffId) then
      envCfg = _envCfg
      break
    end
  end
  do
    return envCfg
  end
end

-- DECOMPILER ERROR at PC126: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSEnvIsUnlock = function(self, envId)
  -- function num : 0_37 , upvalues : _ENV
  if self._tempEnvUnlockEncDic ~= nil and (self._tempEnvUnlockEncDic)[envId] then
    return true
  end
  local envCfg = (ConfigData.warchess_season_general_env)[envId]
  if envCfg == nil then
    return false
  end
  if envCfg.preConditionsNum == 0 then
    if self._tempEnvUnlockEncDic == nil then
      self._tempEnvUnlockEncDic = {}
    end
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._tempEnvUnlockEncDic)[envId] = true
    return true
  end
  for i,v in ipairs(envCfg.preConditions) do
    if (CheckCondition.CheckLua)(v[1], v[2], v[3]) then
      if self._tempEnvUnlockEncDic == nil then
        self._tempEnvUnlockEncDic = {}
      end
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self._tempEnvUnlockEncDic)[envId] = true
      return true
    end
  end
  return false
end

-- DECOMPILER ERROR at PC129: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSTowerList = function(self, seasonId, envId)
  -- function num : 0_38 , upvalues : _ENV
  if envId == nil or envId == 0 then
    return (ConfigData.warchess_season_stage_info)[seasonId]
  end
  local envCfg = (ConfigData.warchess_season_general_env)[envId]
  local difficulty_id = envCfg.difficulty_id
  local stageInfoCfgs = {}
  local all_stageInfoCfgs = (ConfigData.warchess_season_stage_info)[seasonId]
  for _,diffId in ipairs(difficulty_id) do
    local cfg = all_stageInfoCfgs[diffId]
    if all_stageInfoCfgs[diffId] ~= nil then
      (table.insert)(stageInfoCfgs, cfg)
    end
  end
  return stageInfoCfgs
end

-- DECOMPILER ERROR at PC132: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSStageInfoByDiffId = function(self, seasonId, diffId)
  -- function num : 0_39 , upvalues : _ENV
  local stageInfoCfgs = WarChessSeasonManager:GetWCSTowerList(seasonId)
  local stageInfoCfg = stageInfoCfgs[diffId]
  if stageInfoCfg ~= nil then
    return stageInfoCfg
  end
  return nil
end

-- DECOMPILER ERROR at PC135: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSStageInfoByTowerId = function(self, seasonId, towerId)
  -- function num : 0_40 , upvalues : _ENV
  local stageInfoCfgs = WarChessSeasonManager:GetWCSTowerList(seasonId)
  for diff,stageInfoCfg in pairs(stageInfoCfgs) do
    if stageInfoCfg.season_id == towerId then
      return stageInfoCfg
    end
  end
  return nil
end

-- DECOMPILER ERROR at PC138: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.TryWcSsBuffSelect = function(self)
  -- function num : 0_41 , upvalues : _ENV
  if not self:IsInWCS() then
    return 
  end
  local towerId = (self.__wcSeasonCtrl):GetWCSTowerId()
  local seasonId = (self.__wcSeasonCtrl):GetWCSSeasonId()
  local stageInfoCfg = self:GetWCSStageInfoByTowerId(seasonId, towerId)
  if stageInfoCfg == nil then
    return 
  end
  local unlockBuffIdDic = (self.__wcSeasonCtrl):GetWCSInitUnlockDic()
  if (table.IsEmptyTable)(unlockBuffIdDic) then
    return 
  end
  local buffList = {}
  local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
  for _,buffId in pairs(stageInfoCfg.initial_protocol_all) do
    local wcsBuffData = (WarChessBuffData.CrearteBuffById)(buffId)
    ;
    (table.insert)(buffList, wcsBuffData)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_41_0 , upvalues : buffList, unlockBuffIdDic
    win:InitEpBuffSelect(buffList, unlockBuffIdDic)
  end
)
end

-- DECOMPILER ERROR at PC141: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSEnvIdByTowerId = function(self, seasonId, towerId)
  -- function num : 0_42 , upvalues : _ENV
  local stageInfoCfg = WarChessSeasonManager:GetWCSStageInfoByTowerId(seasonId, towerId)
  if stageInfoCfg == nil then
    return nil
  end
  local diffId = stageInfoCfg.difficulty_id
  local envCfg = WarChessSeasonManager:GetEnvCfgBySeasonAndDiff(seasonId, diffId)
  return envCfg
end

-- DECOMPILER ERROR at PC144: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSTowerIsUnlock = function(self, seasonId, diffId)
  -- function num : 0_43 , upvalues : _ENV
  local stageInfoCfgs = WarChessSeasonManager:GetWCSTowerList(seasonId)
  local stageInfoCfg = stageInfoCfgs[diffId]
  if stageInfoCfg == nil then
    return false
  end
  if stageInfoCfg.preConditionsNum == 0 then
    return true
  end
  for i,v in ipairs(stageInfoCfg.preConditions) do
    if (CheckCondition.CheckLua)(v[1], v[2], v[3]) then
      return true
    end
  end
  return false
end

-- DECOMPILER ERROR at PC147: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSSaveNum = function(self, seasonId)
  -- function num : 0_44 , upvalues : _ENV
  local wcsCfg = (ConfigData.warchess_season)[seasonId]
  if wcsCfg == nil then
    error("wcsCfg not exist,seasonId:" .. tostring(seasonId))
    return 0
  end
  return wcsCfg.max_save
end

-- DECOMPILER ERROR at PC150: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSPassedTower = function(self)
  -- function num : 0_45
  if self.__passedWarChessSeasonDic == nil then
    self.__passedWarChessSeasonDic = {}
  end
  return self.__passedWarChessSeasonDic
end

-- DECOMPILER ERROR at PC153: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWCSPassedEnvMaxNum = function(self, seasonId, envId)
  -- function num : 0_46
  local towerRecord = self:GetWCSPassedTower()
  if not towerRecord or not towerRecord[seasonId] then
    local seasonRecord = {}
  end
  local maxNum = seasonRecord.envRecord and (seasonRecord.envRecord)[envId] and ((seasonRecord.envRecord)[envId]).high or 0
  return maxNum
end

-- DECOMPILER ERROR at PC156: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.RefreshWCSPassedTowerData = function(self, seasonId)
  -- function num : 0_47 , upvalues : _ENV
  (self.__wcNetworkCtrl):CS_WarChessSeasonRecord(seasonId, function(args)
    -- function num : 0_47_0 , upvalues : _ENV, self
    if args.Count == 0 then
      error("RefreshWCSPassedTowerData error")
      return 
    end
    local msg = args[0]
    local seasonRecord = msg.seasonRecord
    self.__passedWarChessSeasonDic = {}
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    if seasonRecord ~= nil then
      (self.__passedWarChessSeasonDic)[seasonRecord.seasonId] = seasonRecord
      MsgCenter:Broadcast(eMsgEventId.WCS_WarChessSeasonRecord, seasonRecord.seasonId)
    end
  end
)
end

-- DECOMPILER ERROR at PC159: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWcSSpItemByLogicType = function(self, spcialLogicType)
  -- function num : 0_48 , upvalues : _ENV
  local wcSSpItemCfg = self:GetWcSSpItemConfigByLogicType()
  if wcSSpItemCfg == nil then
    return nil, nil
  end
  if spcialLogicType ~= nil and wcSSpItemCfg.logic_type ~= spcialLogicType then
    return nil, nil
  end
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local itemId = (wcSSpItemCfg.param)[4]
  local parm = (wcSSpItemCfg.param)[3]
  local itemCount = (wcCtrl.backPackCtrl):GetWCItemNum(itemId)
  return itemId, itemCount, parm
end

-- DECOMPILER ERROR at PC162: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetWcSSpItemConfigByLogicType = function(self, spcialLogicType)
  -- function num : 0_49 , upvalues : _ENV
  if not self:IsInWCS() then
    return nil, nil
  end
  local wcSeasonCfg = (self.__wcSeasonCtrl):GetWCSSeasonCfg()
  if wcSeasonCfg.warchess_item == nil then
    return nil, nil
  end
  return (ConfigData.warchess_season_item)[wcSeasonCfg.warchess_item]
end

-- DECOMPILER ERROR at PC165: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.SetSeasonTechJumpFunc = function(self, func, redShowFunc)
  -- function num : 0_50
  self._techOpenFunc = func
  self._techRedShowFunc = redShowFunc
end

-- DECOMPILER ERROR at PC168: Confused about usage of register: R4 in 'UnsetPending'

WarChessSeasonManager.GetSeasonTechJumpFunc = function(self)
  -- function num : 0_51
  return self._techOpenFunc, self._techRedShowFunc
end

return WarChessSeasonManager

