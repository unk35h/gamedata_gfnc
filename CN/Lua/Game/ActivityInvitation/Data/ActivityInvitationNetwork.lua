-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityInvitationNetwork = class("ActivityInvitationNetwork", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
local cs_MessageCommon = CS.MessageCommon
ActivityInvitationNetwork.ctor = function(self)
  -- function num : 0_0
  self._registTable = {}
  self._pickTable = {}
end

ActivityInvitationNetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Invitation_Register, self, proto_csmsg.SC_ACTIVITY_Invitation_Register, self.SC_ACTIVITY_Invitation_Register)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Invitation_Pick, self, proto_csmsg.SC_ACTIVITY_Invitation_Pick, self.SC_ACTIVITY_Invitation_Pick)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Invitation_RegisterNtf, self, proto_csmsg.SC_ACTIVITY_Invitation_RegisterNtf, self.SC_ACTIVITY_Invitation_RegisterNtf)
end

ActivityInvitationNetwork.CS_ACTIVITY_Invitation_Register = function(self, actFrameId, code, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._registTable).actLongId = actFrameId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._registTable).invitationCode = code
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_Register, proto_csmsg.CS_ACTIVITY_Invitation_Register, self._registTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_Register, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Invitation_Register)
end

ActivityInvitationNetwork.SC_ACTIVITY_Invitation_Register = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_MessageCommon, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    if msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_LIMIT then
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7707))
    else
      if msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_CODE_PARSE_ERROR or msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_CODE_LEN_ERROR or msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_CODE_NOT_MATCH then
        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7705))
      else
        local err = "SC_ACTIVITY_Invitation_Register error:" .. tostring(msg.ret)
        self:ShowSCErrorMsg(err)
      end
    end
    do
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_Register)
      do return  end
    end
  end
end

ActivityInvitationNetwork.CS_ACTIVITY_Invitation_Pick = function(self, actFrameId, index, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._pickTable).actLongId = actFrameId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._pickTable).rewardIdx = index
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_Pick, proto_csmsg.CS_ACTIVITY_Invitation_Pick, self._pickTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_Pick, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Invitation_Pick)
end

ActivityInvitationNetwork.SC_ACTIVITY_Invitation_Pick = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Invitation_Pick error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_Pick)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivityInvitationNetwork.SC_ACTIVITY_Invitation_RegisterNtf = function(self, msg)
  -- function num : 0_6 , upvalues : _ENV, cs_MessageCommon, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    if msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_LIMIT then
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7707))
    else
      if msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_CODE_PARSE_ERROR or msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_CODE_LEN_ERROR or msg.ret == proto_csmsg_ErrorCode.ACTIVITY_INVITATION_CODE_NOT_MATCH then
        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7705))
      else
        local err = "SC_ACTIVITY_Invitation_RegisterNtf error:" .. tostring(msg.ret)
        self:ShowSCErrorMsg(err)
      end
    end
    do
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Invitation_RegisterNtf)
      do return  end
      ;
      (UIUtil.ShowCommonReward)(msg.rewards)
      MsgCenter:Broadcast(eMsgEventId.InvitationCodeRegister, msg.actLontId)
    end
  end
end

return ActivityInvitationNetwork

