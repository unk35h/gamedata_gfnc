-- params : ...
-- function num : 0 , upvalues : _ENV
local AdjCustomNetworkCtrl = class("AdjCustomNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
AdjCustomNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self._renameTable = {}
  self._changeTable = {}
  self._modifyTable = {}
  self._delTable = {}
end

AdjCustomNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetUpdate, self, proto_csmsg.SC_MainInterface_PresetUpdate, self.SC_MainInterface_PresetUpdate)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetRename, self, proto_csmsg.SC_MainInterface_PresetRename, self.SC_MainInterface_PresetRename)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_MainInterface_Detail, self, proto_csmsg.SC_MainInterface_Detail, self.SC_MainInterface_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetChange, self, proto_csmsg.SC_MainInterface_PresetChange, self.SC_MainInterface_PresetChange)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetDel, self, proto_csmsg.SC_MainInterface_PresetDel, self.SC_MainInterface_PresetDel)
end

AdjCustomNetworkCtrl.CS_MainInterface_PresetUpdate = function(self, data, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._modifyTable).data = data
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetUpdate, proto_csmsg.CS_MainInterface_PresetUpdate, self._modifyTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetUpdate, callback, proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetUpdate)
end

AdjCustomNetworkCtrl.SC_MainInterface_PresetUpdate = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:SC_MainInterface_PresetUpdate error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    local data = (self._modifyTable).data
    ;
    (PlayerDataCenter.allAdjCustomData):SetAdjPresetData(data)
    MsgCenter:Broadcast(eMsgEventId.AdjCustomModify, data.id)
  end
end

AdjCustomNetworkCtrl.CS_MainInterface_PresetRename = function(self, id, name, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._renameTable).id = id
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._renameTable).name = name
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetRename, proto_csmsg.CS_MainInterface_PresetRename, self._renameTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetRename, callback, proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetRename)
end

AdjCustomNetworkCtrl.SC_MainInterface_PresetRename = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret == proto_csmsg_ErrorCode.INVALID_CHARACTER_INPUT then
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.name_Illegal))
    return 
  else
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:SC_MainInterface_PresetRename error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
  end
  do
    ;
    (PlayerDataCenter.allAdjCustomData):SetAdjPresetName((self._renameTable).id, (self._renameTable).name)
  end
end

AdjCustomNetworkCtrl.CS_MainInterface_Detail = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_MainInterface_Detail, proto_csmsg.CS_MainInterface_Detail, table.emptytable)
end

AdjCustomNetworkCtrl.SC_MainInterface_Detail = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:SC_MainInterface_Detail error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    ;
    (PlayerDataCenter.allAdjCustomData):InitAdjCustonData(msg.data)
  end
end

AdjCustomNetworkCtrl.CS_MainInterface_PresetChange = function(self, id, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._changeTable).id = id
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetChange, proto_csmsg.CS_MainInterface_PresetChange, self._changeTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetChange, callback, proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetChange)
end

AdjCustomNetworkCtrl.SC_MainInterface_PresetChange = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:SC_MainInterface_PresetChange error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    ;
    (PlayerDataCenter.allAdjCustomData):SetUsingAdjCustomPresetId((self._changeTable).id)
    MsgCenter:Broadcast(eMsgEventId.AdjCustomChange)
  end
end

AdjCustomNetworkCtrl.CS_MainInterface_PresetDel = function(self, id, callback)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._delTable).id = id
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetDel, proto_csmsg.CS_MainInterface_PresetDel, self._delTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_MainInterface_PresetDel, callback, proto_csmsg_MSG_ID.MSG_SC_MainInterface_PresetDel)
end

AdjCustomNetworkCtrl.SC_MainInterface_PresetDel = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:SC_MainInterface_PresetDel error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    ;
    (PlayerDataCenter.allAdjCustomData):DelAdjPreset((self._delTable).id)
    MsgCenter:Broadcast(eMsgEventId.AdjCustomModify, (self._delTable).id)
  end
end

return AdjCustomNetworkCtrl

