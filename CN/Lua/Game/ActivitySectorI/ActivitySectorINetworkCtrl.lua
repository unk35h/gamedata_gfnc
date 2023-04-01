-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySectorINetworkCtrl = class("ActivitySectorINetworkCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivitySectorINetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self._purchaseAdditionalTable = {}
  self._execLotteryTab = {}
  self._nextLotteryRoundTab = {}
end

ActivitySectorINetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_Detail, self, proto_csmsg.SC_ACTIVITYSECTORI_Detail, self.SC_ACTIVITYSECTORI_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_PurchaseAdditionalTimes, self, proto_csmsg.SC_ACTIVITYSECTORI_PurchaseAdditionalTimes, self.SC_ACTIVITYSECTORI_PurchaseAdditionalTimes)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_ExecLottery, self, proto_csmsg.SC_ACTIVITYSECTORI_ExecLottery, self.SC_ACTIVITYSECTORI_ExecLottery)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_NextLotteryRound, self, proto_csmsg.SC_ACTIVITYSECTORI_NextLotteryRound, self.SC_ACTIVITYSECTORI_NextLotteryRound)
end

ActivitySectorINetworkCtrl.CS_ACTIVITYSECTORI_Detail_NOWait = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_Detail, proto_csmsg.CS_ACTIVITYSECTORI_Detail, table.emptytable)
end

ActivitySectorINetworkCtrl.CS_ACTIVITYSECTORI_Detail = function(self, callback)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_Detail, proto_csmsg.CS_ACTIVITYSECTORI_Detail, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_Detail, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_Detail)
end

ActivitySectorINetworkCtrl.SC_ACTIVITYSECTORI_Detail = function(self, msg)
  -- function num : 0_4 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  ;
  (PlayerDataCenter.allActivitySectorIData):UpdateSectorIMsg(msg.data)
end

ActivitySectorINetworkCtrl.CS_ACTIVITYSECTORI_PurchaseAdditionalTimes = function(self, actId, callBack)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._purchaseAdditionalTable).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_PurchaseAdditionalTimes, proto_csmsg.CS_ACTIVITYSECTORI_PurchaseAdditionalTimes, self._purchaseAdditionalTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_PurchaseAdditionalTimes, callBack, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_PurchaseAdditionalTimes)
end

ActivitySectorINetworkCtrl.SC_ACTIVITYSECTORI_PurchaseAdditionalTimes = function(self, msg)
  -- function num : 0_6 , upvalues : _ENV
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITYSECTORI_PurchaseAdditionalTimes error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivitySectorINetworkCtrl.SC_ACTIVITYSECTORI_SyncDiff = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV
  (PlayerDataCenter.allActivitySectorIData):UpdateSectorIMsg(msg.data)
end

ActivitySectorINetworkCtrl.CS_ACTIVITYSECTORI_ExecLottery = function(self, actId, num, callBack)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._execLotteryTab).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._execLotteryTab).num = num
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_ExecLottery, proto_csmsg.CS_ACTIVITYSECTORI_ExecLottery, self._execLotteryTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_ExecLottery, callBack, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_ExecLottery)
end

ActivitySectorINetworkCtrl.SC_ACTIVITYSECTORI_ExecLottery = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITYSECTORI_ExecLottery error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_ExecLottery)
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_ExecLottery, msg)
  end
end

ActivitySectorINetworkCtrl.CS_ACTIVITYSECTORI_NextLotteryRound = function(self, actId, callBack)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._nextLotteryRoundTab).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_NextLotteryRound, proto_csmsg.CS_ACTIVITYSECTORI_NextLotteryRound, self._nextLotteryRoundTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_NextLotteryRound, callBack, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSECTORI_NextLotteryRound)
end

ActivitySectorINetworkCtrl.SC_ACTIVITYSECTORI_NextLotteryRound = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITYSECTORI_NextLotteryRound error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSECTORI_NextLotteryRound)
  end
end

return ActivitySectorINetworkCtrl

