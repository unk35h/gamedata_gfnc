-- params : ...
-- function num : 0 , upvalues : _ENV
local TinyGameNetworkCtrl = class("TinyGameNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
TinyGameNetworkCtrl.ctor = function(self)
  -- function num : 0_0
end

TinyGameNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityGame_2048_Settle, self, proto_csmsg.SC_ActivityGame_2048_Settle, self.SC_ActivityGame_2048_Settle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityGame_2048_SelfRankDetail, self, proto_csmsg.SC_ActivityGame_2048_SelfRankDetail, self.SC_ActivityGame_2048_SelfRankDetail)
end

TinyGameNetworkCtrl.CS_ActivityGame_2048_Settle = function(self, actId, gameId, score, action)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  local sendMsg = {}
  sendMsg.actLongId = actId
  sendMsg.gameId = gameId
  sendMsg.score = score
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_Settle, proto_csmsg.CS_ActivityGame_2048_Settle, sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_Settle, action, proto_csmsg_MSG_ID.MSG_SC_ActivityGame_2048_Settle)
end

TinyGameNetworkCtrl.SC_ActivityGame_2048_Settle = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_Settle)
    local err = "TinyGameNetworkCtrl:SC_ActivityGame_2048_Settle error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
  do
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

TinyGameNetworkCtrl.CS_ActivityGame_2048_SelfRankDetail = function(self, actId, gameId, action)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  local sendMsg = {}
  sendMsg.actLongId = actId
  sendMsg.gameId = gameId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_SelfRankDetail, proto_csmsg.CS_ActivityGame_2048_SelfRankDetail, sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_SelfRankDetail, action, proto_csmsg_MSG_ID.MSG_SC_ActivityGame_2048_SelfRankDetail)
end

TinyGameNetworkCtrl.SC_ActivityGame_2048_SelfRankDetail = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_SelfRankDetail)
    local err = "TinyGameNetworkCtrl:SC_ActivityGame_2048_SelfRankDetail error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
  do
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ActivityGame_2048_SelfRankDetail, msg)
  end
end

TinyGameNetworkCtrl.Reset = function(self)
  -- function num : 0_6
end

return TinyGameNetworkCtrl

