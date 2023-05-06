-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySeasonNetworkController = class("ActivitySeasonNetworkController", NetworkCtrlBase)
local base = NetworkCtrlBase
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivitySeasonNetworkController.ctor = function(self)
  -- function num : 0_0
  self._pickRef = {}
end

ActivitySeasonNetworkController.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickLevelReward, self, proto_csmsg.SC_ACTIVITY_Season_PickLevelReward, self.SC_ACTIVITY_Season_PickLevelReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickCirCleReward, self, proto_csmsg.SC_ACTIVITY_Season_PickCirCleReward, self.SC_ACTIVITY_Season_PickCirCleReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickAllLevelReward, self, proto_csmsg.SC_ACTIVITY_Season_PickAllLevelReward, self.SC_ACTIVITY_Season_PickAllLevelReward)
end

ActivitySeasonNetworkController.CS_ACTIVITY_Season_PickLevelReward = function(self, actId, level, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._pickRef).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._pickRef).level = level
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Season_PickLevelReward, proto_csmsg.CS_ACTIVITY_Season_PickLevelReward, self._pickRef)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Season_PickLevelReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickLevelReward)
end

ActivitySeasonNetworkController.SC_ACTIVITY_Season_PickLevelReward = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Season_PickLevelReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickLevelReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivitySeasonNetworkController.CS_ACTIVITY_Season_PickCirCleReward = function(self, actId, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._pickRef).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._pickRef).level = nil
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Season_PickCirCleReward, proto_csmsg.CS_ACTIVITY_Season_PickCirCleReward, self._pickRef)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Season_PickCirCleReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickCirCleReward)
end

ActivitySeasonNetworkController.SC_ACTIVITY_Season_PickCirCleReward = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Season_PickCirCleReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickCirCleReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivitySeasonNetworkController.CS_ACTIVITY_Season_PickAllLevelReward = function(self, actId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._pickRef).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._pickRef).level = nil
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Season_PickAllLevelReward, proto_csmsg.CS_ACTIVITY_Season_PickAllLevelReward, self._pickRef)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Season_PickAllLevelReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickAllLevelReward)
end

ActivitySeasonNetworkController.SC_ACTIVITY_Season_PickAllLevelReward = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Season_PickAllLevelReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Season_PickAllLevelReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

return ActivitySeasonNetworkController

