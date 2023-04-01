-- params : ...
-- function num : 0 , upvalues : _ENV
local SpecWeaponNetwork = class("SpecWeaponNetwork", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
SpecWeaponNetwork.ctor = function(self)
  -- function num : 0_0
  self._sendTable = {}
  self._sendLvTable = {}
end

SpecWeaponNetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_SpecWeapon_Unlock, self, proto_csmsg.SC_SpecWeapon_Unlock, self.SC_SpecWeapon_Unlock)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_SpecWeapon_Step, self, proto_csmsg.SC_SpecWeapon_Step, self.SC_SpecWeapon_Step)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_SpecWeapon_Upgrade, self, proto_csmsg.SC_SpecWeapon_Upgrade, self.SC_SpecWeapon_Upgrade)
end

SpecWeaponNetwork.CS_SpecWeapon_Unlock = function(self, id, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._sendTable).id = id
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Unlock, proto_csmsg.CS_SpecWeapon_Unlock, self._sendTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Unlock, callback, proto_csmsg_MSG_ID.MSG_SC_SpecWeapon_Unlock)
end

SpecWeaponNetwork.SC_SpecWeapon_Unlock = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_SpecWeapon_Unlock error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Unlock)
    return 
  end
end

SpecWeaponNetwork.CS_SpecWeapon_Step = function(self, id, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._sendTable).id = id
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Step, proto_csmsg.CS_SpecWeapon_Step, self._sendTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Step, callback, proto_csmsg_MSG_ID.MSG_SC_SpecWeapon_Step)
end

SpecWeaponNetwork.SC_SpecWeapon_Step = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_SpecWeapon_Step error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Step)
    return 
  end
end

SpecWeaponNetwork.CS_SpecWeapon_Upgrade = function(self, id, targetLevel, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._sendLvTable).id = id
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._sendLvTable).targetLv = targetLevel
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Upgrade, proto_csmsg.CS_SpecWeapon_Upgrade, self._sendLvTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Upgrade, callback, proto_csmsg_MSG_ID.MSG_SC_SpecWeapon_Upgrade)
end

SpecWeaponNetwork.SC_SpecWeapon_Upgrade = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_SpecWeapon_Upgrade error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_SpecWeapon_Upgrade)
    return 
  end
end

return SpecWeaponNetwork

