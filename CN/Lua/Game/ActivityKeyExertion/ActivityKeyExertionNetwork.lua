-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityKeyExertionNetwork = class("ActivityKeyExertionNetwork", NetworkCtrlBase)
local base = NetworkCtrlBase
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityKeyExertionNetwork.ctor = function(self)
  -- function num : 0_0
  self._taskRef = {}
end

ActivityKeyExertionNetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_KeyExertion_PickAllReward, self, proto_csmsg.SC_ACTIVITY_KeyExertion_PickAllReward, self.SC_ACTIVITY_KeyExertion_PickAllReward)
end

ActivityKeyExertionNetwork.CS_ACTIVITY_KeyExertion_PickAllReward = function(self, actId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._taskRef).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_KeyExertion_PickAllReward, proto_csmsg.CS_ACTIVITY_KeyExertion_PickAllReward, self._taskRef)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_KeyExertion_PickAllReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_KeyExertion_PickAllReward)
end

ActivityKeyExertionNetwork.SC_ACTIVITY_KeyExertion_PickAllReward = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_KeyExertion_PickAllReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_KeyExertion_PickAllReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

return ActivityKeyExertionNetwork

