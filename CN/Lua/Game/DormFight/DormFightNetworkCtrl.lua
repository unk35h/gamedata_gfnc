-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightNetworkCtrl = class("DormFightNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
DormFightNetworkCtrl.ctor = function(self)
  -- function num : 0_0
end

DormFightNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_FIGHT_CreateRoomNtf, self, proto_csmsg.SC_FIGHT_CreateRoomNtf, self.SC_FIGHT_CreateRoomNtf)
end

DormFightNetworkCtrl.CS_PVP_Test_CreateRoom = function(self, mode)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  local sendMsg = {}
  sendMsg.op = mode
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_PVP_Test_CreateRoom, proto_csmsg.CS_PVP_Test_CreateRoom, sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_PVP_Test_CreateRoom, proto_csmsg_MSG_ID.MSG_SC_FIGHT_CreateRoomNtf)
end

DormFightNetworkCtrl.SC_FIGHT_CreateRoomNtf = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "DormFightNetworkCtrl:SC_FIGHT_CreateRoomNtf error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_PVP_Test_CreateRoom)
      return 
    end
    local dormFightCtrl = ControllerManager:GetController(ControllerTypeId.DormFight, true)
    if dormFightCtrl ~= nil then
      dormFightCtrl:RecvPvpCreateRoom(msg)
    end
  end
end

return DormFightNetworkCtrl

