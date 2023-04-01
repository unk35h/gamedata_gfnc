-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySectorIIINetwork = class("ActivitySectorIIINetwork", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivitySectorIIINetwork.ctor = function(self)
  -- function num : 0_0
  self._taskSingleTable = {}
end

ActivitySectorIIINetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Summer2022_RefreshQuest, self, proto_csmsg.SC_ACTIVITY_Summer2022_RefreshQuest, self.SC_ACTIVITY_Summer2022_RefreshQuest)
end

ActivitySectorIIINetwork.CS_ACTIVITY_Summer2022_RefreshQuest = function(self, actId, taskId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._taskSingleTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._taskSingleTable).questId = taskId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Summer2022_RefreshQuest, proto_csmsg.CS_ACTIVITY_Summer2022_RefreshQuest, self._taskSingleTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Summer2022_RefreshQuest, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Summer2022_RefreshQuest)
end

ActivitySectorIIINetwork.SC_ACTIVITY_Summer2022_RefreshQuest = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_Summer2022_RefreshQuest error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Summer2022_RefreshQuest)
    return 
  end
end

return ActivitySectorIIINetwork

