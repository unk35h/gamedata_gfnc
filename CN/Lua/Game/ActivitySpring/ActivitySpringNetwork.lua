-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySpringNetwork = class("ActivitySpringNetwork", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivitySpringNetwork.ctor = function(self)
  -- function num : 0_0
  self._interactTable = {}
end

ActivitySpringNetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Spring_Interact, self, proto_csmsg.SC_ACTIVITY_Spring_Interact, self.SC_ACTIVITY_Spring_Interact)
end

ActivitySpringNetwork.CS_ACTIVITY_Spring_Interact = function(self, actId, interactId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._interactTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._interactTable).interactId = interactId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Spring_Interact, proto_csmsg.CS_ACTIVITY_Spring_Interact, self._interactTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Spring_Interact, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Spring_Interact)
end

ActivitySpringNetwork.SC_ACTIVITY_Spring_Interact = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Spring_Interact error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Spring_Interact)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Spring_Interact, msg)
  end
end

return ActivitySpringNetwork

