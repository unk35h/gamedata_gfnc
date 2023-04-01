-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityHallowmasNetwork = class("ActivityHallowmasNetwork", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityHallowmasNetwork.ctor = function(self)
  -- function num : 0_0
  self._taskRef = {}
  self._expReaward = {}
  self._expAllReward = {}
  self._expBuy = {}
  self._cycleReward = {}
  self._allChieveCommit = {}
end

ActivityHallowmasNetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_RefreshSingleQuest, self, proto_csmsg.SC_ACTIVITY_Halloween2022_RefreshSingleQuest, self.SC_ACTIVITY_Halloween2022_RefreshSingleQuest)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickLevelReward, self, proto_csmsg.SC_ACTIVITY_Halloween2022_PickLevelReward, self.SC_ACTIVITY_Halloween2022_PickLevelReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickAllLevelReward, self, proto_csmsg.SC_ACTIVITY_Halloween2022_PickAllLevelReward, self.SC_ACTIVITY_Halloween2022_PickAllLevelReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_BuyScore, self, proto_csmsg.SC_ACTIVITY_Halloween2022_BuyScore, self.SC_ACTIVITY_Halloween2022_BuyScore)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickCycleReward, self, proto_csmsg.SC_ACTIVITY_Halloween2022_PickCycleReward, self.SC_ACTIVITY_Halloween2022_PickCycleReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_CommitAllAchievement, self, proto_csmsg.SC_ACTIVITY_Halloween2022_CommitAllAchievement, self.SC_ACTIVITY_Halloween2022_CommitAllAchievement)
end

ActivityHallowmasNetwork.CS_ACTIVITY_Halloween2022_RefreshSingleQuest = function(self, actId, taskId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._taskRef).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._taskRef).questId = taskId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_RefreshSingleQuest, proto_csmsg.CS_ACTIVITY_Halloween2022_RefreshSingleQuest, self._taskRef)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_RefreshSingleQuest, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_RefreshSingleQuest)
end

ActivityHallowmasNetwork.SC_ACTIVITY_Halloween2022_RefreshSingleQuest = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_Halloween2022_RefreshSingleQuest error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_RefreshSingleQuest)
    return 
  end
end

ActivityHallowmasNetwork.CS_ACTIVITY_Halloween2022_PickLevelReward = function(self, actId, level, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._expReaward).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._expReaward).level = level
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_PickLevelReward, proto_csmsg.CS_ACTIVITY_Halloween2022_PickLevelReward, self._expReaward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_PickLevelReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickLevelReward)
end

ActivityHallowmasNetwork.SC_ACTIVITY_Halloween2022_PickLevelReward = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Halloween2022_PickLevelReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickLevelReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivityHallowmasNetwork.CS_ACTIVITY_Halloween2022_PickAllLevelReward = function(self, actId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._expAllReward).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_PickAllLevelReward, proto_csmsg.CS_ACTIVITY_Halloween2022_PickAllLevelReward, self._expAllReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_PickAllLevelReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickAllLevelReward)
end

ActivityHallowmasNetwork.SC_ACTIVITY_Halloween2022_PickAllLevelReward = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Halloween2022_PickAllLevelReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickAllLevelReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivityHallowmasNetwork.CS_ACTIVITY_Halloween2022_BuyScore = function(self, actId, count, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._expBuy).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._expBuy).buyCnt = count
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_BuyScore, proto_csmsg.CS_ACTIVITY_Halloween2022_BuyScore, self._expBuy)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_BuyScore, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_BuyScore)
end

ActivityHallowmasNetwork.SC_ACTIVITY_Halloween2022_BuyScore = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_Halloween2022_BuyScore error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_BuyScore)
    return 
  end
end

ActivityHallowmasNetwork.CS_ACTIVITY_Halloween2022_PickCycleReward = function(self, actId, callback)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._cycleReward).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_PickCycleReward, proto_csmsg.CS_ACTIVITY_Halloween2022_PickCycleReward, self._cycleReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_PickCycleReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickCycleReward)
end

ActivityHallowmasNetwork.SC_ACTIVITY_Halloween2022_PickCycleReward = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Halloween2022_PickCycleReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_PickCycleReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivityHallowmasNetwork.CS_ACTIVITY_Halloween2022_CommitAllAchievement = function(self, actId, callback)
  -- function num : 0_12 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._allChieveCommit).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_CommitAllAchievement, proto_csmsg.CS_ACTIVITY_Halloween2022_CommitAllAchievement, self._allChieveCommit)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Halloween2022_CommitAllAchievement, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_CommitAllAchievement)
end

ActivityHallowmasNetwork.SC_ACTIVITY_Halloween2022_CommitAllAchievement = function(self, msg)
  -- function num : 0_13 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_Halloween2022_CommitAllAchievement error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Halloween2022_CommitAllAchievement)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

return ActivityHallowmasNetwork

