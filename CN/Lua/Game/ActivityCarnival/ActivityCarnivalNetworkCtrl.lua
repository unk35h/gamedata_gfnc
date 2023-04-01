-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityCarnivalNetworkCtrl = class("ActivityCarnivalNetworkCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityCarnivalNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self._singleTaskRefTable = {}
  self._singleRewardTable = {}
  self._allRewardTable = {}
  self._timePassTable = {}
  self._cycleReward = {}
end

ActivityCarnivalNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_RefreshQuestSingle, self, proto_csmsg.SC_ACTIVITY_Carnival_RefreshQuestSingle, self.SC_ACTIVITY_Carnival_RefreshQuestSingle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_PickLevelReward, self, proto_csmsg.SC_ACTIVITY_Carnival_PickLevelReward, self.SC_ACTIVITY_Carnival_PickLevelReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_PickAllLevelReward, self, proto_csmsg.SC_ACTIVITY_Carnival_PickAllLevelReward, self.SC_ACTIVITY_Carnival_PickAllLevelReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_RefreshPeriod, self, proto_csmsg.SC_ACTIVITY_Carnival_RefreshPeriod, self.SC_ACTIVITY_Carnival_RefreshPeriod)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_PickCirCleReward, self, proto_csmsg.SC_ACTIVITY_Carnival_PickCirCleReward, self.SC_ACTIVITY_Carnival_PickCirCleReward)
end

ActivityCarnivalNetworkCtrl.CS_ACTIVITY_Carnival_RefreshQuestSingle = function(self, actId, questId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._singleTaskRefTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._singleTaskRefTable).questId = questId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshQuestSingle, proto_csmsg.CS_ACTIVITY_Carnival_RefreshQuestSingle, self._singleTaskRefTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshQuestSingle, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_RefreshQuestSingle)
end

ActivityCarnivalNetworkCtrl.SC_ACTIVITY_Carnival_RefreshQuestSingle = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Carnival_RefreshQuestSingle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshQuestSingle)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshQuestSingle, msg)
  end
end

ActivityCarnivalNetworkCtrl.CS_ACTIVITY_Carnival_PickLevelReward = function(self, actId, level, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._singleRewardTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._singleRewardTable).level = level
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickLevelReward, proto_csmsg.CS_ACTIVITY_Carnival_PickLevelReward, self._singleRewardTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickLevelReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_PickLevelReward)
end

ActivityCarnivalNetworkCtrl.SC_ACTIVITY_Carnival_PickLevelReward = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Carnival_PickLevelReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickLevelReward)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickLevelReward, msg)
  end
end

ActivityCarnivalNetworkCtrl.CS_ACTIVITY_Carnival_PickAllLevelReward = function(self, actId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._allRewardTable).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickAllLevelReward, proto_csmsg.CS_ACTIVITY_Carnival_PickAllLevelReward, self._allRewardTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickAllLevelReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_PickAllLevelReward)
end

ActivityCarnivalNetworkCtrl.SC_ACTIVITY_Carnival_PickAllLevelReward = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Carnival_PickAllLevelReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickAllLevelReward)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickAllLevelReward, msg)
  end
end

ActivityCarnivalNetworkCtrl.CS_ACTIVITY_Carnival_RefreshPeriod = function(self, actId, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._timePassTable).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshPeriod, proto_csmsg.CS_ACTIVITY_Carnival_RefreshPeriod, self._timePassTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshPeriod, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_RefreshPeriod)
end

ActivityCarnivalNetworkCtrl.SC_ACTIVITY_Carnival_RefreshPeriod = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_Carnival_RefreshPeriod error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_RefreshPeriod)
  end
end

ActivityCarnivalNetworkCtrl.CS_ACTIVITY_Carnival_PickCirCleReward = function(self, actId, callback)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._cycleReward).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickCirCleReward, proto_csmsg.CS_ACTIVITY_Carnival_PickCirCleReward, self._cycleReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickCirCleReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Carnival_PickCirCleReward)
end

ActivityCarnivalNetworkCtrl.SC_ACTIVITY_Carnival_PickCirCleReward = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Carnival_PickCirCleReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickCirCleReward)
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Carnival_PickCirCleReward, msg)
  end
end

return ActivityCarnivalNetworkCtrl

