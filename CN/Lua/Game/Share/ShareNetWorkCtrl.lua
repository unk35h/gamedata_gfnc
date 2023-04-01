-- params : ...
-- function num : 0 , upvalues : _ENV
local ShareNetWorkCtrl = class("ShareNetWorkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ShareNetWorkCtrl.ctor = function(self)
  -- function num : 0_0
  self._shareTab = {}
end

ShareNetWorkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Share, self, proto_csmsg.SC_Share, self.SC_Share)
end

ShareNetWorkCtrl.CS_Share = function(self, shareId, channelId, callBack)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._shareTab).funcId = shareId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._shareTab).sdkId = channelId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Share, proto_csmsg.CS_Share, self._shareTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Share, callBack, proto_csmsg_MSG_ID.MSG_SC_Share)
end

ShareNetWorkCtrl.SC_Share = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= 0 then
      local err = "SC_Share:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Share)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_Share, msg)
  end
end

ShareNetWorkCtrl.Reset = function(self)
  -- function num : 0_4
end

return ShareNetWorkCtrl

