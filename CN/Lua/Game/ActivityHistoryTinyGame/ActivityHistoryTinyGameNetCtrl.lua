-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityHistoryTinyGameNetCtrl = class("ActivityHistoryTinyGameNetCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityHistoryTinyGameNetCtrl.ctor = function(self)
  -- function num : 0_0
  self._refreshSingleTable = {}
  self._refreshAllTable = {}
  self._rewardTable = {}
end

ActivityHistoryTinyGameNetCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_RefreshQuestSingle, self, proto_csmsg.SC_ACTIVITY_TinyGame_RefreshQuestSingle, self.SC_ACTIVITY_TinyGame_RefreshQuestSingle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_RefreshQuestAll, self, proto_csmsg.SC_ACTIVITY_TinyGame_RefreshQuestAll, self.SC_ACTIVITY_TinyGame_RefreshQuestAll)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_GetActiveReward, self, proto_csmsg.SC_ACTIVITY_TinyGame_GetActiveReward, self.SC_ACTIVITY_TinyGame_GetActiveReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_ActiveDiff, self, proto_csmsg.SC_ACTIVITY_TinyGame_ActiveDiff, self.SC_ACTIVITY_TinyGame_ActiveDiff)
end

ActivityHistoryTinyGameNetCtrl.CS_ACTIVITY_TinyGame_RefreshQuestSingle = function(self, actId, taskId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._refreshSingleTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._refreshSingleTable).toReplaceTaskId = taskId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestSingle, proto_csmsg.CS_ACTIVITY_TinyGame_RefreshQuestSingle, self._refreshSingleTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestSingle, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_RefreshQuestSingle)
end

ActivityHistoryTinyGameNetCtrl.SC_ACTIVITY_TinyGame_RefreshQuestSingle = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_TinyGame_RefreshQuestSingle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestSingle)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestSingle, msg)
  end
end

ActivityHistoryTinyGameNetCtrl.CS_ACTIVITY_TinyGame_RefreshQuestAll = function(self, actId, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._refreshAllTable).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestAll, proto_csmsg.CS_ACTIVITY_TinyGame_RefreshQuestAll, self._refreshAllTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestAll, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_RefreshQuestAll)
end

ActivityHistoryTinyGameNetCtrl.SC_ACTIVITY_TinyGame_RefreshQuestAll = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_TinyGame_RefreshQuestAll error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestAll)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_RefreshQuestAll, msg)
  end
end

ActivityHistoryTinyGameNetCtrl.CS_ACTIVITY_TinyGame_GetActiveReward = function(self, actId, all, active, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self._rewardTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._rewardTable).all = all
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._rewardTable).active = active
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_GetActiveReward, proto_csmsg.CS_ACTIVITY_TinyGame_GetActiveReward, self._rewardTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_GetActiveReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TinyGame_GetActiveReward)
end

ActivityHistoryTinyGameNetCtrl.SC_ACTIVITY_TinyGame_GetActiveReward = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_TinyGame_GetActiveReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_GetActiveReward)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TinyGame_GetActiveReward, msg)
  end
end

ActivityHistoryTinyGameNetCtrl.SC_ACTIVITY_TinyGame_ActiveDiff = function(self, msg)
  -- function num : 0_8 , upvalues : _ENV
  local tinyCtrl = ControllerManager:GetController(ControllerTypeId.HistoryTinyGameActivity)
  if tinyCtrl == nil then
    return 
  end
  local data = tinyCtrl:GetOneHTGData()
  if data == nil then
    return 
  end
  data:UpdateHTGActive(msg.active)
  MsgCenter:Broadcast(eMsgEventId.ActivityTinyGameActive)
end

return ActivityHistoryTinyGameNetCtrl

