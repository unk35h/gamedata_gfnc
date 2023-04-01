-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessNetworkCtrl = class("WarChessNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
local cs_MessageCommon = CS.MessageCommon
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
WarChessNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.singleStartMsg = {}
  self.freshFmtMsg = {
identify = {}
, 
formInfo = {}
, fromFormationIdx = nil}
  self.teamMoveMsg = {
identify = {}
, 
wcPos = {}
}
  self.teamInteractMsg = {
identify = {}
, wcPos = nil, entityCat = nil, interactionId = nil}
  self.turnOverMsg = {wid = nil}
  self._battleSelectAlg = {
identify = {}
}
  self.storeBuyChipMsg = {identify = nil, idx = nil, tid = nil}
  self.storeBuyBuffMsg = {identify = nil, idx = nil}
  self.storeRefreshMsg = {identify = nil}
  self.storeExchangeMsg = {identify = nil, costItemId = nil}
  self.storeSaleMsg = {identify = nil, algId = nil, tid = nil}
  self.treasureSelectMsg = {identify = nil, index = nil, tid = nil}
  self.storeQuitMsg = {identify = nil}
  self.rewardBrief = {warChessConfigId = nil}
  self.resetMsg = {wid = nil, backRound = nil}
  self.exChangeMsg = {
identify = {}
, 
identifyEnd = {}
}
  self.rescueMsg = {identify = nil, heroes = nil, fromFormationIdx = nil, powerNum = nil}
end

WarChessNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_SingleStart, self, proto_csmsg.SC_WarChess_SingleStart, self.SC_WarChess_SingleStart)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_FreshFormation, self, proto_csmsg.SC_WarChess_FreshFormation, self.SC_WarChess_FreshFormation)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Deploy, self, proto_csmsg.SC_WarChess_Deploy, self.SC_WarChess_Deploy)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_GameStart, self, proto_csmsg.SC_WarChess_GameStart, self.SC_WarChess_GameStart)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_MoveTo, self, proto_csmsg.SC_WarChess_MoveTo, self.SC_WarChess_MoveTo)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Interact, self, proto_csmsg.SC_WarChess_Interact, self.SC_WarChess_Interact)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_Settle, self, proto_csmsg.SC_WarChess_BattleSystem_Settle, self.SC_WarChess_BattleSystem_Settle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_Quit, self, proto_csmsg.SC_WarChess_BattleSystem_Quit, self.SC_WarChess_BattleSystem_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_SelectAlg, self, proto_csmsg.SC_WarChess_BattleSystem_SelectAlg, self.SC_WarChess_BattleSystem_SelectAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_DropAlg, self, proto_csmsg.SC_WarChess_BattleSystem_DropAlg, self.SC_WarChess_BattleSystem_DropAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_RefreshAlg, self, proto_csmsg.SC_WarChess_BattleSystem_RefreshAlg, self.SC_WarChess_BattleSystem_RefreshAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BroadCastOver, self, proto_csmsg.SC_WarChess_BroadCastOver, self.SC_WarChess_BroadCastOver)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_RoundStartSingle, self, proto_csmsg.SC_WarChess_RoundStartSingle, self.SC_WarChess_RoundStartSingle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_SelectAlg, self, proto_csmsg.SC_WarChess_StoreSystem_SelectAlg, self.SC_WarChess_StoreSystem_SelectAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_Quit, self, proto_csmsg.SC_WarChess_StoreSystem_Quit, self.SC_WarChess_StoreSystem_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_Sale, self, proto_csmsg.SC_WarChess_StoreSystem_Sale, self.SC_WarChess_StoreSystem_SaleAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_Refresh, self, proto_csmsg.SC_WarChess_StoreSystem_Refresh, self.SC_WarChess_StoreSystem_Refresh)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_ExchangeItem, self, proto_csmsg.SC_WarChess_StoreSystem_ExchangeItem, self.SC_WarChess_StoreSystem_ExchangeItem)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_SelectBuff, self, proto_csmsg.SC_WarChess_StoreSystem_SelectBuff, self.SC_WarChess_StoreSystem_SelectBuff)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BoxSystem_SelectAlg, self, proto_csmsg.SC_WarChess_BoxSystem_SelectAlg, self.SC_WarChess_BoxSystem_SelectAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BoxSystem_DropAlg, self, proto_csmsg.SC_WarChess_BoxSystem_DropAlg, self.SC_WarChess_BoxSystem_DropAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BoxSystem_RefreshAlg, self, proto_csmsg.SC_WarChess_BoxSystem_RefreshAlg, self.SC_WarChess_BoxSystem_RefreshAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_EventSystem_Select, self, proto_csmsg.SC_WarChess_EventSystem_Select, self.SC_WarChess_EventSystem_Select)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_AlgDiscardSystem_Select, self, proto_csmsg.SC_WarChess_AlgDiscardSystem_Select, self.SC_WarChess_AlgDiscardSystem_Select)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_AlgDiscardSystem_Quit, self, proto_csmsg.SC_WarChess_AlgDiscardSystem_Quit, self.SC_WarChess_AlgDiscardSystem_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_AlgDiscardSystem_PurchaseAlgLimit, self, proto_csmsg.SC_WarChess_AlgDiscardSystem_PurchaseAlgLimit, self.SC_WarChess_AlgDiscardSystem_PurchaseAlgLimit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_RayCastSystem_Start, self, proto_csmsg.SC_WarChess_RayCastSystem_Start, self.SC_WarChess_RayCastSystem_Start)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_RayCastSystem_Quit, self, proto_csmsg.SC_WarChess_RayCastSystem_Quit, self.SC_WarChess_RayCastSystem_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_SelectTeamForAlgSystem_Select, self, proto_csmsg.SC_WarChess_SelectTeamForAlgSystem_Select, self.SC_WarChess_SelectTeamForAlgSystem_Select)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_SelectTeamForAlgSystem_Quit, self, proto_csmsg.SC_WarChess_SelectTeamForAlgSystem_Quit, self.SC_WarChess_SelectTeamForAlgSystem_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_JumpSystemData_Start, self, proto_csmsg.SC_WarChess_JumpSystemData_Start, self.SC_WarChess_JumpSystemData_Start)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_JumpSystemData_Quit, self, proto_csmsg.SC_WarChess_JumpSystemData_Quit, self.SC_WarChess_JumpSystemData_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_JumpSystemData_Move, self, proto_csmsg.SC_WarChess_JumpSystemData_Move, self.SC_WarChess_JumpSystemData_Move)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_StartSystem, self, proto_csmsg.SC_WarChess_StartSystem, self.SC_WarChess_StartSystem)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_OverSystem, self, proto_csmsg.SC_WarChess_OverSystem, self.SC_WarChess_OverSystem)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_SwitchingSystem, self, proto_csmsg.SC_WarChess_SwitchingSystem, self.SC_WarChess_SwitchingSystem)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_BroadCastSync, self, proto_csmsg.SC_WarChess_BroadCastSync, self.SC_WarChess_BroadCastSync)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Quit, self, proto_csmsg.SC_WarChess_Quit, self.SC_WarChess_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Settle, self, proto_csmsg.SC_WarChess_Settle, self.SC_WarChess_Settle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Brief_Detail, self, proto_csmsg.SC_WarChess_Brief_Detail, self.SC_WarChess_Brief_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Detail, self, proto_csmsg.SC_WarChess_Detail, self.SC_WarChess_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_UniqueRewardBrief, self, proto_csmsg.SC_WarChess_UniqueRewardBrief, self.SC_WarChess_UniqueRewardBrief)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_ResetTheRound, self, proto_csmsg.SC_WarChess_ResetTheRound, self.SC_WarChess_ResetTheRound)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_EnterWarChessLobby, self, proto_csmsg.SC_WarChess_EnterWarChessLobby, self.SC_WarChess_EnterWarChessLobby)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_WarChessExchangePos, self, proto_csmsg.SC_WarChess_WarChessExchangePos, self.SC_WarChess_WarChessExchangePos)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteract, self, proto_csmsg.SC_WarChess_GlobalInteract, self.SC_WarChess_GlobalInteract)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_GetSeasonBackup, self, proto_csmsg.SC_WarChess_GetSeasonBackup, self.SC_WarChess_GetSeasonBackup)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_SetSeasonBackup, self, proto_csmsg.SC_WarChess_SetSeasonBackup, self.SC_WarChess_SetSeasonBackup)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_SeasonBackupChoice, self, proto_csmsg.SC_WarChess_SeasonBackupChoice, self.SC_WarChess_SeasonBackupChoice)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Event_FreshFormation, self, proto_csmsg.SC_WarChess_Event_FreshFormation, self.SC_WarChess_Event_FreshFormation)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_Event_StrategySelect, self, proto_csmsg.SC_WarChess_Event_StrategySelect, self.SC_WarChess_Event_StrategySelect)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteractTrigger, self, proto_csmsg.SC_WarChess_GlobalInteractTrigger, self.SC_WarChess_GlobalInteractTrigger)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_AvgOver, self, proto_csmsg.SC_WarChess_AvgOver, self.SC_WarChess_AvgOver)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChessSeasonRecord, self, proto_csmsg.SC_WarChessSeasonRecord, self.SC_WarChessSeasonRecord)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_OverReward_SelectAlg, self, proto_csmsg.SC_WarChess_OverReward_SelectAlg, self.SC_WarChess_OverReward_SelectAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_OverReward_DropAlg, self, proto_csmsg.SC_WarChess_OverReward_DropAlg, self.SC_WarChess_OverReward_DropAlg)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WarChess_OverReward_RefreshAlg, self, proto_csmsg.SC_WarChess_OverReward_RefreshAlg, self.SC_WarChess_OverReward_RefreshAlg)
end

WarChessNetworkCtrl.CS_WarChess_SingleStart = function(self, stageId, challengeMode, challengeQuests, warChessType, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R6 in 'UnsetPending'

  (self.singleStartMsg).warChessId = stageId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.singleStartMsg).challengeMode = challengeMode
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.singleStartMsg).challengeQuests = challengeQuests
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.singleStartMsg).warChessType = warChessType
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_SingleStart, proto_csmsg.CS_WarChess_SingleStart, self.singleStartMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SingleStart, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_SingleStart)
end

WarChessNetworkCtrl.SC_WarChess_SingleStart = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_SingleStart error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SingleStart)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_SingleStart, msg.warChess)
  end
end

WarChessNetworkCtrl.CS_WarChess_FreshFormation = function(self, wid, tid, formationId, fromFormationIdx, power, officeAssist, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R8 in 'UnsetPending'

  ((self.freshFmtMsg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.freshFmtMsg).identify).tid = tid
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.freshFmtMsg).formInfo).formationId = formationId
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.freshFmtMsg).fromFormationIdx = fromFormationIdx
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.freshFmtMsg).powerNum = power
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.freshFmtMsg).assist = officeAssist
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_FreshFormation, proto_csmsg.CS_WarChess_FreshFormation, self.freshFmtMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_FreshFormation, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_FreshFormation)
end

WarChessNetworkCtrl.SC_WarChess_FreshFormation = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_FreshFormation error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_FreshFormation)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_Deploy = function(self, wid, tid, wcPos, entityCat, interactionId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R7 in 'UnsetPending'

  ((self.teamInteractMsg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.teamInteractMsg).identify).tid = tid
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.teamInteractMsg).wcPos = wcPos
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.teamInteractMsg).entityCat = entityCat
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.teamInteractMsg).interactionId = interactionId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Deploy, proto_csmsg.CS_WarChess_Deploy, self.teamInteractMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Deploy, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Deploy)
end

WarChessNetworkCtrl.SC_WarChess_Deploy = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_Deploy error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Deploy, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Deploy, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_GameStart = function(self, msg, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_GameStart, proto_csmsg.CS_WarChess_GameStart, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_GameStart, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_GameStart)
end

WarChessNetworkCtrl.SC_WarChess_GameStart = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_GameStart error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_GameStart, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_GameStart, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_MoveTo = function(self, wid, tid, gridData, callback)
  -- function num : 0_10 , upvalues : WarChessHelper, _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R5 in 'UnsetPending'

  ((self.teamMoveMsg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.teamMoveMsg).identify).tid = tid
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.teamMoveMsg).wcPos).gid = gridData:GetWCGridBFId()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.teamMoveMsg).wcPos).pos = (WarChessHelper.Pos2Coordination)(gridData:GetGridLogicPos())
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_MoveTo, proto_csmsg.CS_WarChess_MoveTo, self.teamMoveMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_MoveTo, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_MoveTo)
end

WarChessNetworkCtrl.SC_WarChess_MoveTo = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_MoveTo error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_MoveTo, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_MoveTo, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_Interact = function(self, wid, tid, wcPos, entityCat, interactionId, callback)
  -- function num : 0_12 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R7 in 'UnsetPending'

  ((self.teamInteractMsg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.teamInteractMsg).identify).tid = tid
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.teamInteractMsg).wcPos = wcPos
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.teamInteractMsg).entityCat = entityCat
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.teamInteractMsg).interactionId = interactionId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Interact, proto_csmsg.CS_WarChess_Interact, self.teamInteractMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Interact, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Interact)
end

WarChessNetworkCtrl.SC_WarChess_Interact = function(self, msg)
  -- function num : 0_13 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_Interact error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Interact, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Interact, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_BattleSystem_Settle = function(self, sendMsg, callback)
  -- function num : 0_14 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Settle, proto_csmsg.CS_WarChess_BattleSystem_Settle, sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Settle, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_Settle)
end

WarChessNetworkCtrl.SC_WarChess_BattleSystem_Settle = function(self, msg)
  -- function num : 0_15 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_BattleSystem_Settle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Settle, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Settle, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_BattleSystem_Quit = function(self, identify, callback)
  -- function num : 0_16 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {identify = identify}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Quit, proto_csmsg.CS_WarChess_BattleSystem_Quit, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_Quit)
end

WarChessNetworkCtrl.SC_WarChess_BattleSystem_Quit = function(self, msg)
  -- function num : 0_17 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_BattleSystem_Quit error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Quit, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_Quit, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_BattleSystem_SelectAlg = function(self, wid, tid, idx, stid, callback)
  -- function num : 0_18 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R6 in 'UnsetPending'

  ((self._battleSelectAlg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._battleSelectAlg).identify).tid = tid
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._battleSelectAlg).idx = idx
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._battleSelectAlg).tid = stid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_SelectAlg, proto_csmsg.CS_WarChess_BattleSystem_SelectAlg, self._battleSelectAlg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_SelectAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_SelectAlg)
end

WarChessNetworkCtrl.SC_WarChess_BattleSystem_SelectAlg = function(self, msg)
  -- function num : 0_19 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_BattleSystem_SelectAlg error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_SelectAlg)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_BattleSystem_DropAlg = function(self, wid, tid, callback)
  -- function num : 0_20 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R4 in 'UnsetPending'

  ((self._battleSelectAlg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._battleSelectAlg).identify).tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_DropAlg, proto_csmsg.CS_WarChess_BattleSystem_DropAlg, self._battleSelectAlg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_DropAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_DropAlg)
end

WarChessNetworkCtrl.SC_WarChess_BattleSystem_DropAlg = function(self, msg)
  -- function num : 0_21 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_BattleSystem_DropAlg error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_DropAlg)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_BattleSystem_RefreshAlg = function(self, wid, tid, callback)
  -- function num : 0_22 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R4 in 'UnsetPending'

  ((self._battleSelectAlg).identify).wid = wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._battleSelectAlg).identify).tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_RefreshAlg, proto_csmsg.CS_WarChess_BattleSystem_RefreshAlg, self._battleSelectAlg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_RefreshAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BattleSystem_RefreshAlg)
end

WarChessNetworkCtrl.SC_WarChess_BattleSystem_RefreshAlg = function(self, msg)
  -- function num : 0_23 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_BattleSystem_RefreshAlg error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_RefreshAlg)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BattleSystem_RefreshAlg, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_StoreSystem_SelectAlg = function(self, identify, idx, tid, callback)
  -- function num : 0_24 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.storeBuyChipMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.storeBuyChipMsg).idx = idx
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.storeBuyChipMsg).tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_SelectAlg, proto_csmsg.CS_WarChess_StoreSystem_SelectAlg, self.storeBuyChipMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_SelectAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_SelectAlg)
end

WarChessNetworkCtrl.SC_WarChess_StoreSystem_SelectAlg = function(self, msg)
  -- function num : 0_25 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_StoreSystem_SelectAlg error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_StoreSystem_SaleAlg = function(self, identify, chipID, tid, callback)
  -- function num : 0_26 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.storeSaleMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.storeSaleMsg).algId = chipID
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.storeSaleMsg).tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Sale, proto_csmsg.CS_WarChess_StoreSystem_Sale, self.storeSaleMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Sale, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_Sale)
end

WarChessNetworkCtrl.SC_WarChess_StoreSystem_SaleAlg = function(self, msg)
  -- function num : 0_27 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_StoreSystem_Sale error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_StoreSystem_Refresh = function(self, identify, callback)
  -- function num : 0_28 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.storeRefreshMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Refresh, proto_csmsg.CS_WarChess_StoreSystem_Refresh, self.storeRefreshMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Refresh, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_Refresh)
end

WarChessNetworkCtrl.SC_WarChess_StoreSystem_Refresh = function(self, msg)
  -- function num : 0_29 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_StoreSystem_Refresh error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Refresh, nil)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Refresh, msg.storeSystemData)
  end
end

WarChessNetworkCtrl.CS_WarChess_StoreSystem_ExchangeItem = function(self, identify, itemId, callback)
  -- function num : 0_30 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.storeExchangeMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.storeExchangeMsg).costItemId = itemId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_ExchangeItem, proto_csmsg.CS_WarChess_StoreSystem_ExchangeItem, self.storeExchangeMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_ExchangeItem, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_ExchangeItem)
end

WarChessNetworkCtrl.SC_WarChess_StoreSystem_ExchangeItem = function(self, msg)
  -- function num : 0_31 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_StoreSystem_ExchangeItem error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_ExchangeItem, nil)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_ExchangeItem, msg.costItemid)
  end
end

WarChessNetworkCtrl.CS_WarChess_StoreSystem_SelectBuff = function(self, identify, idx, callback)
  -- function num : 0_32 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.storeBuyBuffMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.storeBuyBuffMsg).idx = idx
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_SelectBuff, proto_csmsg.CS_WarChess_StoreSystem_SelectBuff, self.storeBuyBuffMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_SelectBuff, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_SelectBuff)
end

WarChessNetworkCtrl.SC_WarChess_StoreSystem_SelectBuff = function(self, msg)
  -- function num : 0_33 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_StoreSystem_SelectBuff error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_SelectBuff)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_StoreSystem_Quit = function(self, identify, callback)
  -- function num : 0_34 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.storeQuitMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Quit, proto_csmsg.CS_WarChess_StoreSystem_Quit, self.storeQuitMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_StoreSystem_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_StoreSystem_Quit)
end

WarChessNetworkCtrl.SC_WarChess_StoreSystem_Quit = function(self, msg)
  -- function num : 0_35 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_StoreSystem_Quit error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_BoxSystem_SelectAlg = function(self, identify, index, tid, callback)
  -- function num : 0_36 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.treasureSelectMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.treasureSelectMsg).index = index
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.treasureSelectMsg).tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_SelectAlg, proto_csmsg.CS_WarChess_BoxSystem_SelectAlg, self.treasureSelectMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_SelectAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BoxSystem_SelectAlg)
end

WarChessNetworkCtrl.SC_WarChess_BoxSystem_SelectAlg = function(self, msg)
  -- function num : 0_37 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_BoxSystem_SelectAlg error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_BoxSystem_RefreshAlg = function(self, identify, callback)
  -- function num : 0_38 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.treasureSelectMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_RefreshAlg, proto_csmsg.CS_WarChess_BoxSystem_RefreshAlg, self.treasureSelectMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_RefreshAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BoxSystem_RefreshAlg)
end

WarChessNetworkCtrl.SC_WarChess_BoxSystem_RefreshAlg = function(self, msg)
  -- function num : 0_39 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_BoxSystem_RefreshAlg error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_RefreshAlg, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_BoxSystem_DropAlg = function(self, identify, callback)
  -- function num : 0_40 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.treasureSelectMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_DropAlg, proto_csmsg.CS_WarChess_BoxSystem_DropAlg, self.treasureSelectMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_DropAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_BoxSystem_DropAlg)
end

WarChessNetworkCtrl.SC_WarChess_BoxSystem_DropAlg = function(self, msg)
  -- function num : 0_41 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_BoxSystem_DropAlg error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_BoxSystem_RefreshAlg, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_EventSystem_Select = function(self, identify, index, callback)
  -- function num : 0_42 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.treasureSelectMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.treasureSelectMsg).index = index
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_EventSystem_Select, proto_csmsg.CS_WarChess_EventSystem_Select, self.treasureSelectMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_EventSystem_Select, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_EventSystem_Select)
end

WarChessNetworkCtrl.SC_WarChess_EventSystem_Select = function(self, msg)
  -- function num : 0_43 , upvalues : _ENV
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_EventSystem_Select error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    if msg.eventSystemData ~= nil then
      local wcCtrl = WarChessManager:GetWarChessCtrl()
      if wcCtrl ~= nil then
        (wcCtrl.eventCtrl):EnterNextWCEvent(msg.eventSystemData)
      end
    end
  end
end

WarChessNetworkCtrl.CS_WarChess_AlgDiscardSystem_Select = function(self, identify, tid, algId, callback)
  -- function num : 0_44 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  msg.tid = tid
  msg.algId = algId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_AlgDiscardSystem_Select, proto_csmsg.CS_WarChess_AlgDiscardSystem_Select, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_AlgDiscardSystem_Select, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_AlgDiscardSystem_Select)
end

WarChessNetworkCtrl.SC_WarChess_AlgDiscardSystem_Select = function(self, msg)
  -- function num : 0_45 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_AlgDiscardSystem_Select error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_AlgDiscardSystem_Quit = function(self, identify, callback)
  -- function num : 0_46 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_AlgDiscardSystem_Quit, proto_csmsg.CS_WarChess_AlgDiscardSystem_Quit, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_AlgDiscardSystem_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_AlgDiscardSystem_Quit)
end

WarChessNetworkCtrl.SC_WarChess_AlgDiscardSystem_Quit = function(self, msg)
  -- function num : 0_47 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_AlgDiscardSystem_Quit error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_AlgDiscardSystem_PurchaseAlgLimit = function(self, identify, tid, callback)
  -- function num : 0_48 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  msg.tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_AlgDiscardSystem_PurchaseAlgLimit, proto_csmsg.CS_WarChess_AlgDiscardSystem_PurchaseAlgLimit, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_AlgDiscardSystem_PurchaseAlgLimit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_AlgDiscardSystem_PurchaseAlgLimit)
end

WarChessNetworkCtrl.SC_WarChess_AlgDiscardSystem_PurchaseAlgLimit = function(self, msg)
  -- function num : 0_49 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_AlgDiscardSystem_PurchaseAlgLimit error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_RayCastSystem_Start = function(self, identify, callback)
  -- function num : 0_50 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Start, proto_csmsg.CS_WarChess_RayCastSystem_Start, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Start, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_RayCastSystem_Start)
end

WarChessNetworkCtrl.SC_WarChess_RayCastSystem_Start = function(self, msg)
  -- function num : 0_51 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_RayCastSystem_Start error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Start, false)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Start, true)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Start, msg.raySystemData)
  end
end

WarChessNetworkCtrl.CS_WarChess_RayCastSystem_Quit = function(self, identify, callback)
  -- function num : 0_52 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Quit, proto_csmsg.CS_WarChess_RayCastSystem_Quit, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_RayCastSystem_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_RayCastSystem_Quit)
end

WarChessNetworkCtrl.SC_WarChess_RayCastSystem_Quit = function(self, msg)
  -- function num : 0_53 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_RayCastSystem_Quit error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_SelectTeamForAlgSystem_Select = function(self, identify, tid, idx, callback)
  -- function num : 0_54 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.storeBuyChipMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.storeBuyChipMsg).tid = tid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.storeBuyChipMsg).idx = idx
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_SelectTeamForAlgSystem_Select, proto_csmsg.CS_WarChess_SelectTeamForAlgSystem_Select, self.storeBuyChipMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SelectTeamForAlgSystem_Select, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_SelectTeamForAlgSystem_Select)
end

WarChessNetworkCtrl.SC_WarChess_SelectTeamForAlgSystem_Select = function(self, msg)
  -- function num : 0_55 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_SelectTeamForAlgSystem_Select error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_SelectTeamForAlgSystem_Select, msg.remainAlgList)
  end
end

WarChessNetworkCtrl.CS_WarChess_SelectTeamForAlgSystem_Quit = function(self, identify, callback)
  -- function num : 0_56 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.storeQuitMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_SelectTeamForAlgSystem_Quit, proto_csmsg.CS_WarChess_SelectTeamForAlgSystem_Quit, self.storeQuitMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SelectTeamForAlgSystem_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_SelectTeamForAlgSystem_Quit)
end

WarChessNetworkCtrl.SC_WarChess_SelectTeamForAlgSystem_Quit = function(self, msg)
  -- function num : 0_57 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_SelectTeamForAlgSystem_Quit error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_JumpSystemData_Start = function(self, identify, dir, movePos, callback)
  -- function num : 0_58 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {identify = identify, dir = dir, movePos = movePos}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Start, proto_csmsg.CS_WarChess_JumpSystemData_Start, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Start, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_JumpSystemData_Start)
end

WarChessNetworkCtrl.SC_WarChess_JumpSystemData_Start = function(self, msg)
  -- function num : 0_59 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_JumpSystemData_Start error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Start, false)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Start, msg)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Start, true)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Start, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_JumpSystemData_Quit = function(self, identify, callback)
  -- function num : 0_60 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.storeQuitMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Quit, proto_csmsg.CS_WarChess_JumpSystemData_Quit, self.storeQuitMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_JumpSystemData_Quit)
end

WarChessNetworkCtrl.SC_WarChess_JumpSystemData_Quit = function(self, msg)
  -- function num : 0_61 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_JumpSystemData_Quit error:" .. tostring(msg.ret)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_JumpSystemData_Move = function(self, identify, callback)
  -- function num : 0_62 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.storeQuitMsg).identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Move, proto_csmsg.CS_WarChess_JumpSystemData_Move, self.storeQuitMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_JumpSystemData_Move, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_JumpSystemData_Move, proto_csmsg_MSG_ID.MSG_SC_WarChess_BroadCastSync)
end

WarChessNetworkCtrl.SC_WarChess_JumpSystemData_Move = function(self, msg)
  -- function num : 0_63 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_JumpSystemData_Move error:" .. tostring(msg.ret)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_RoundStartSingle = function(self, wid, callback)
  -- function num : 0_64 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.turnOverMsg).wid = wid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_RoundStartSingle, proto_csmsg.CS_WarChess_RoundStartSingle, self.turnOverMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_RoundStartSingle, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_RoundStartSingle)
end

WarChessNetworkCtrl.SC_WarChess_RoundStartSingle = function(self, msg)
  -- function num : 0_65 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_RoundStartSingle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RoundStartSingle, false)
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RoundStartSingle, 0)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RoundStartSingle, true)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_RoundStartSingle, msg.roundId)
  end
end

WarChessNetworkCtrl.SC_WarChess_StartSystem = function(self, msg)
  -- function num : 0_66 , upvalues : _ENV, eWarChessEnum
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil then
    wcCtrl:OnWCSystemChange((eWarChessEnum.eSystemOpCat).open, (msg.systemState).cat, msg.identify, msg.systemState)
  end
end

WarChessNetworkCtrl.SC_WarChess_OverSystem = function(self, msg)
  -- function num : 0_67 , upvalues : _ENV, eWarChessEnum
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil then
    wcCtrl:OnWCSystemChange((eWarChessEnum.eSystemOpCat).close, msg.cat)
  end
end

WarChessNetworkCtrl.SC_WarChess_SwitchingSystem = function(self, msg)
  -- function num : 0_68 , upvalues : _ENV, eWarChessEnum
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil then
    wcCtrl:OnWCSystemChange((eWarChessEnum.eSystemOpCat).switch, (msg.systemState).cat, msg.identify, msg.systemState)
  end
end

WarChessNetworkCtrl.SC_WarChess_BroadCastSync = function(self, msg)
  -- function num : 0_69 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil then
    wcCtrl:OnWCSync(msg.sync)
  end
end

WarChessNetworkCtrl.SC_WarChess_BroadCastOver = function(self, msg)
  -- function num : 0_70 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil then
    local castOverData = msg.seasonData
    WarChessManager:WarchesFinish(msg.win, castOverData)
  end
end

WarChessNetworkCtrl.CS_WarChess_Quit = function(self, pickInfo, callback)
  -- function num : 0_71 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {pickInfo = pickInfo}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Quit, proto_csmsg.CS_WarChess_Quit, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Quit, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Quit)
end

WarChessNetworkCtrl.SC_WarChess_Quit = function(self, msg)
  -- function num : 0_72 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "MSG_SC_WarChess_Quit error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Quit, msg)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

WarChessNetworkCtrl.CS_WarChess_Settle = function(self, selectedRewardInfo, callback)
  -- function num : 0_73 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {identify = nil, pickInfo = selectedRewardInfo}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Settle, proto_csmsg.CS_WarChess_Settle, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Settle, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Settle)
end

WarChessNetworkCtrl.SC_WarChess_Settle = function(self, msg)
  -- function num : 0_74 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_Settle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Settle, msg)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

WarChessNetworkCtrl.CS_WarChess_Brief_Detail = function(self, callback)
  -- function num : 0_75 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Brief_Detail, proto_csmsg.CS_WarChess_Brief_Detail, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Brief_Detail, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Brief_Detail)
end

WarChessNetworkCtrl.SC_WarChess_Brief_Detail = function(self, msg)
  -- function num : 0_76 , upvalues : cs_WaitNetworkResponse, _ENV
  cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Brief_Detail, msg)
end

WarChessNetworkCtrl.CS_WarChess_Detail = function(self, warChessType, callback)
  -- function num : 0_77 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.warChessType = warChessType
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Detail, proto_csmsg.CS_WarChess_Detail, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Detail, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Detail)
end

WarChessNetworkCtrl.SC_WarChess_Detail = function(self, msg)
  -- function num : 0_78 , upvalues : cs_WaitNetworkResponse, _ENV
  cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_Detail, msg)
end

WarChessNetworkCtrl.CS_WarChess_UniqueRewardBrief = function(self, warchessId, callback)
  -- function num : 0_79 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.rewardBrief).warChessConfigId = warchessId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_UniqueRewardBrief, proto_csmsg.CS_WarChess_UniqueRewardBrief, self.rewardBrief)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_UniqueRewardBrief, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_UniqueRewardBrief)
end

WarChessNetworkCtrl.SC_WarChess_UniqueRewardBrief = function(self, msg)
  -- function num : 0_80 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_UniqueRewardBrief error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_UniqueRewardBrief, msg.records)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

WarChessNetworkCtrl.CS_WarChess_ResetTheRound = function(self, wid, backRound, callback)
  -- function num : 0_81 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.resetMsg).wid = wid
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.resetMsg).backRound = backRound
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_ResetTheRound, proto_csmsg.CS_WarChess_ResetTheRound, self.resetMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_ResetTheRound, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_ResetTheRound)
end

WarChessNetworkCtrl.SC_WarChess_ResetTheRound = function(self, msg)
  -- function num : 0_82 , upvalues : _ENV
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_ResetTheRound error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    if wcCtrl ~= nil then
      wcCtrl:WarChessApplyTimeRewind(msg.warChess)
    end
  end
end

WarChessNetworkCtrl.CS_WarChess_EnterWarChessLobby = function(self, warChessSeasonId, warChessTowerId, newStart, envId, callback)
  -- function num : 0_83 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.warChessSeasonId = warChessSeasonId
  msg.warChessTowerId = warChessTowerId
  msg.newStart = newStart
  msg.environmentId = envId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_EnterWarChessLobby, proto_csmsg.CS_WarChess_EnterWarChessLobby, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_EnterWarChessLobby, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_EnterWarChessLobby)
end

WarChessNetworkCtrl.SC_WarChess_EnterWarChessLobby = function(self, msg)
  -- function num : 0_84 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_EnterWarChessLobby error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_EnterWarChessLobby, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_WarChessExchangePos = function(self, s_wid, s_tid, t_wid, t_tid, callback)
  -- function num : 0_85 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R6 in 'UnsetPending'

  ((self.exChangeMsg).identify).wid = s_wid
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.exChangeMsg).identify).tid = s_tid
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.exChangeMsg).identifyEnd).wid = t_wid
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.exChangeMsg).identifyEnd).tid = t_tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_WarChessExchangePos, proto_csmsg.CS_WarChess_WarChessExchangePos, self.exChangeMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_WarChessExchangePos, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_WarChessExchangePos)
end

WarChessNetworkCtrl.SC_WarChess_WarChessExchangePos = function(self, msg)
  -- function num : 0_86 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "MSG_CS_WarChess_WarChessExchangePos error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_WarChessExchangePos)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_GlobalInteract = function(self, identify, eventPoolId, callback)
  -- function num : 0_87 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  msg.eventPoolId = eventPoolId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_GlobalInteract, proto_csmsg.CS_WarChess_GlobalInteract, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_GlobalInteract, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteract)
end

WarChessNetworkCtrl.SC_WarChess_GlobalInteract = function(self, msg)
  -- function num : 0_88 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "MSG_CS_WarChess_GlobalInteract error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_GlobalInteract)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_GetSeasonBackup = function(self, callback)
  -- function num : 0_89 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_GetSeasonBackup, proto_csmsg.CS_WarChess_GetSeasonBackup, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_GetSeasonBackup, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_GetSeasonBackup)
end

WarChessNetworkCtrl.SC_WarChess_GetSeasonBackup = function(self, msg)
  -- function num : 0_90 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None and msg.ret ~= proto_csmsg_ErrorCode.WARCHESS_NOT_SEASON_BACKUP then
      local err = "MSG_CS_WarChess_GetSeasonBackup error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_GetSeasonBackup)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_GetSeasonBackup, msg.backUpData)
  end
end

WarChessNetworkCtrl.CS_WarChess_SeasonBackupChoice = function(self, index, callback)
  -- function num : 0_91 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {warChessSeasonbackUpId = index}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_SeasonBackupChoice, proto_csmsg.CS_WarChess_SeasonBackupChoice, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SeasonBackupChoice, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_SeasonBackupChoice)
end

WarChessNetworkCtrl.SC_WarChess_SeasonBackupChoice = function(self, msg)
  -- function num : 0_92 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "MSG_CS_WarChess_SeasonBackupChoice error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SeasonBackupChoice)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_SeasonBackupChoice, msg.warChess)
  end
end

WarChessNetworkCtrl.CS_WarChess_SetSeasonBackup = function(self, index, callback)
  -- function num : 0_93 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {warChessSeasonbackUpId = index}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_SetSeasonBackup, proto_csmsg.CS_WarChess_SetSeasonBackup, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SetSeasonBackup, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_SetSeasonBackup)
end

WarChessNetworkCtrl.SC_WarChess_SetSeasonBackup = function(self, msg)
  -- function num : 0_94 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "MSG_CS_WarChess_SetSeasonBackup error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_SetSeasonBackup)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_SetSeasonBackup)
  end
end

WarChessNetworkCtrl.CS_WarChess_Event_FreshFormation = function(self, identify, heroes, fromFormationIdx, powerNum, cancel, callback)
  -- function num : 0_95 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R7 in 'UnsetPending'

  (self.rescueMsg).identify = identify
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.rescueMsg).heroes = heroes
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.rescueMsg).fromFormationIdx = fromFormationIdx
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.rescueMsg).powerNum = powerNum
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.rescueMsg).cancel = cancel or false
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Event_FreshFormation, proto_csmsg.CS_WarChess_Event_FreshFormation, self.rescueMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Event_FreshFormation, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Event_FreshFormation)
end

WarChessNetworkCtrl.SC_WarChess_Event_FreshFormation = function(self, msg)
  -- function num : 0_96 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "MSG_CS_WarChess_Event_FreshFormation error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Event_FreshFormation)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_Event_StrategySelect = function(self, identify, indexStrategyKey, rewardMapKey, tid, callback)
  -- function num : 0_97 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  msg.indexStrategyKey = indexStrategyKey
  msg.rewardMapKey = rewardMapKey
  msg.tid = tid
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_Event_StrategySelect, proto_csmsg.CS_WarChess_Event_StrategySelect, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Event_StrategySelect, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_Event_StrategySelect)
end

WarChessNetworkCtrl.SC_WarChess_Event_StrategySelect = function(self, msg)
  -- function num : 0_98 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "CS_WarChess_Event_StrategySelect error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_Event_StrategySelect)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChess_GlobalInteractTrigger = function(self, identify, callback)
  -- function num : 0_99 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.identify = identify
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_GlobalInteractTrigger, proto_csmsg.CS_WarChess_GlobalInteractTrigger, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_GlobalInteractTrigger, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteractTrigger)
end

WarChessNetworkCtrl.SC_WarChess_GlobalInteractTrigger = function(self, msg)
  -- function num : 0_100 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    if msg.ret == proto_csmsg_ErrorCode.WARCHESS_GLOBAL_TRIGGER_ITEM_NOT_ENOUGH then
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteractTrigger, false)
      return 
    end
    local err = "SC_WarChess_GlobalInteractTrigger error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteractTrigger)
    return 
  end
  do
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_SC_WarChess_GlobalInteractTrigger, true)
  end
end

WarChessNetworkCtrl.CS_WarChess_AvgOver = function(self, avgId, agvType, callback)
  -- function num : 0_101 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.avgId = avgId
  msg.agvType = agvType
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_AvgOver, proto_csmsg.CS_WarChess_AvgOver, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_AvgOver, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_AvgOver)
end

WarChessNetworkCtrl.SC_WarChess_AvgOver = function(self, msg)
  -- function num : 0_102 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_WarChess_AvgOver error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_AvgOver)
    return 
  end
end

WarChessNetworkCtrl.CS_WarChessSeasonRecord = function(self, warChessSeasonId, callback)
  -- function num : 0_103 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {warChessSeasonId = warChessSeasonId}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChessSeasonRecord, proto_csmsg.CS_WarChessSeasonRecord, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChessSeasonRecord, callback, proto_csmsg_MSG_ID.MSG_SC_WarChessSeasonRecord)
end

WarChessNetworkCtrl.SC_WarChessSeasonRecord = function(self, msg)
  -- function num : 0_104 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChessSeasonRecord error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChessSeasonRecord)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChessSeasonRecord, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_OverReward_SelectAlg = function(self, identify, idx, tid, callback)
  -- function num : 0_105 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {identify = identify, idx = idx, tid = tid}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_SelectAlg, proto_csmsg.CS_WarChess_OverReward_SelectAlg, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_SelectAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_OverReward_SelectAlg)
end

WarChessNetworkCtrl.SC_WarChess_OverReward_SelectAlg = function(self, msg)
  -- function num : 0_106 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_OverReward_SelectAlg error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_SelectAlg)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_SelectAlg, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_OverReward_DropAlg = function(self, identify, callback)
  -- function num : 0_107 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {identify = identify}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_DropAlg, proto_csmsg.CS_WarChess_OverReward_DropAlg, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_DropAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_OverReward_DropAlg)
end

WarChessNetworkCtrl.SC_WarChess_OverReward_DropAlg = function(self, msg)
  -- function num : 0_108 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_OverReward_DropAlg error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_DropAlg)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_DropAlg, msg)
  end
end

WarChessNetworkCtrl.CS_WarChess_OverReward_RefreshAlg = function(self, identify, callback)
  -- function num : 0_109 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {identify = identify}
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_RefreshAlg, proto_csmsg.CS_WarChess_OverReward_RefreshAlg, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_RefreshAlg, callback, proto_csmsg_MSG_ID.MSG_SC_WarChess_OverReward_RefreshAlg)
end

WarChessNetworkCtrl.SC_WarChess_OverReward_RefreshAlg = function(self, msg)
  -- function num : 0_110 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_WarChess_OverReward_RefreshAlg error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_RefreshAlg)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_WarChess_OverReward_RefreshAlg, msg)
  end
end

WarChessNetworkCtrl.Reset = function(self)
  -- function num : 0_111
end

return WarChessNetworkCtrl

