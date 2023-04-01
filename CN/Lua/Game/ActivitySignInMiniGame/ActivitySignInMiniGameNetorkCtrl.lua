-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySignInMiniGameNetorkCtrl = class("ActivitySignInMiniGameNetorkCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivitySignInMiniGameNetorkCtrl.ctor = function(self)
  -- function num : 0_0
  self._msg = {}
  self._signTab = {}
  self._cartoonTab = {}
end

ActivitySignInMiniGameNetorkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_SignMiniGame_Sign, self, proto_csmsg.SC_ACTIVITY_SignMiniGame_Sign, self.SC_ACTIVITY_SignMiniGame_Sign)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_SignMiniGame_PlayCartoon, self, proto_csmsg.SC_ACTIVITY_SignMiniGame_PlayCartoon, self.SC_ACTIVITY_SignMiniGame_PlayCartoon)
end

ActivitySignInMiniGameNetorkCtrl.CS_ACTIVITY_SignMiniGame_Sign = function(self, actId, emojiId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._signTab).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._signTab).emojiId = emojiId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_Sign, proto_csmsg.CS_ACTIVITY_SignMiniGame_Sign, self._signTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_Sign, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_SignMiniGame_Sign)
end

ActivitySignInMiniGameNetorkCtrl.SC_ACTIVITY_SignMiniGame_Sign = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_SignMiniGame_Sign error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_Sign)
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_Sign, msg)
  end
end

ActivitySignInMiniGameNetorkCtrl.CS_ACTIVITY_SignMiniGame_PlayCartoon = function(self, actId, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._cartoonTab).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_PlayCartoon, proto_csmsg.CS_ACTIVITY_SignMiniGame_PlayCartoon, self._cartoonTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_PlayCartoon, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_SignMiniGame_PlayCartoon)
end

ActivitySignInMiniGameNetorkCtrl.SC_ACTIVITY_SignMiniGame_PlayCartoon = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_SignMiniGame_PlayCartoon error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SignMiniGame_PlayCartoon)
  end
end

return ActivitySignInMiniGameNetorkCtrl

