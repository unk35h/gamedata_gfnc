-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonSectorIINetworkCtrl = class("DungeonSectorIINetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
DungeonSectorIINetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.sendEnterSectorIIDun = {
formInfo = {}
}
  self.dgVerifyEnterTab = {
formInfo = {}
}
  self.dgVerifySettleTab = {}
  self.dgVerifyPreviewScoreTab = {}
end

DungeonSectorIINetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONWINTER_Enter, self, proto_csmsg.SC_DUNGEONWINTER_Enter, self.SC_DUNGEONWINTER_Enter)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONWinterVerify_Enter, self, proto_csmsg.SC_DUNGEONWinterVerify_Enter, self.SC_DUNGEONWinterVerify_Enter)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONWinterVerify_Settle, self, proto_csmsg.SC_DUNGEONWinterVerify_Settle, self.SC_DUNGEONWinterVerify_Settle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONWinterVerify_PreviewScore, self, proto_csmsg.SC_DUNGEONWinterVerify_PreviewScore, self.SC_DUNGEONWinterVerify_PreviewScore)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_WINTERVerify_ScoreShow, self, proto_csmsg.SC_WINTERVerify_ScoreShow, self.SC_WINTERVerify_ScoreShow)
end

DungeonSectorIINetworkCtrl.CS_DUNGEONWINTER_Enter = function(self, dungeonId, formationData, rewardRate, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.sendEnterSectorIIDun).dungeonId = dungeonId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.sendEnterSectorIIDun).rewardRate = rewardRate
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.sendEnterSectorIIDun).formInfo).formationId = formationData.id
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.sendEnterSectorIIDun).formInfo).support = formationData:GetSupportHeroData()
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWINTER_Enter, proto_csmsg.CS_DUNGEONWINTER_Enter, self.sendEnterSectorIIDun)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWINTER_Enter, callback, proto_csmsg_MSG_ID.MSG_SC_DUNGEONWINTER_Enter, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter)
end

DungeonSectorIINetworkCtrl.SC_DUNGEONWINTER_Enter = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_DUNGEONWINTER_Enter error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWINTER_Enter)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

DungeonSectorIINetworkCtrl.CS_DUNGEONWinterVerify_Enter = function(self, dungeonId, formationData, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.dgVerifyEnterTab).dungeonId = dungeonId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.dgVerifyEnterTab).formInfo).formationId = formationData.id
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Enter, proto_csmsg.CS_DUNGEONWinterVerify_Enter, self.dgVerifyEnterTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Enter, callback, proto_csmsg_MSG_ID.MSG_SC_DUNGEONWinterVerify_Enter, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter)
end

DungeonSectorIINetworkCtrl.SC_DUNGEONWinterVerify_Enter = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_DUNGEONWinterVerify_Enter error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Enter)
    return 
  end
end

DungeonSectorIINetworkCtrl.CS_DUNGEONWinterVerify_Settle = function(self, dungeonId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.dgVerifySettleTab).dungeonId = dungeonId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Settle, proto_csmsg.CS_DUNGEONWinterVerify_Settle, self.dgVerifySettleTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Settle, callback, proto_csmsg_MSG_ID.MSG_SC_DUNGEONWinterVerify_Settle, proto_csmsg_MSG_ID.MSG_SC_WINTERVerify_ScoreShow)
end

DungeonSectorIINetworkCtrl.SC_DUNGEONWinterVerify_Settle = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_DUNGEONWinterVerify_Settle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Settle)
      return 
    end
    MsgCenter:Broadcast(eMsgEventId.WinterChallengeSettle)
  end
end

DungeonSectorIINetworkCtrl.MSG_CS_DUNGEONWinterVerify_PreviewScore = function(self, statDic, win, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.dgVerifyPreviewScoreTab).stat = statDic
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.dgVerifyPreviewScoreTab).win = win
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_PreviewScore, proto_csmsg.CS_DUNGEONWinterVerify_PreviewScore, self.dgVerifySettleTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_PreviewScore, callback, proto_csmsg_MSG_ID.MSG_SC_DUNGEONWinterVerify_PreviewScore)
end

DungeonSectorIINetworkCtrl.MSG_SC_DUNGEONWinterVerify_PreviewScore = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_DUNGEONWinterVerify_PreviewScore error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_PreviewScore)
    return 
  end
end

DungeonSectorIINetworkCtrl.SC_ACTIVITYSCTORII_SyncDiff = function(self, msg)
  -- function num : 0_10 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if sectorIICtrl ~= nil then
    sectorIICtrl:UpdSectorIIActivityByDiff(msg)
  end
end

DungeonSectorIINetworkCtrl.SC_WINTERVerify_ScoreShow = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  MsgCenter:Broadcast(eMsgEventId.WinterChallengeScoreShow, msg)
  if cs_WaitNetworkResponse:ContainWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Settle) then
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_DUNGEONWinterVerify_Settle, msg)
  end
end

DungeonSectorIINetworkCtrl.Reset = function(self)
  -- function num : 0_12
end

return DungeonSectorIINetworkCtrl

