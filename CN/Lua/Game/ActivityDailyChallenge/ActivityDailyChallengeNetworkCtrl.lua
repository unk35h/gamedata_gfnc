-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityDailyChallengeNetworkCtrl = class("ActivityDailyChallengeNetworkCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityDailyChallengeNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self._refreshItemTable = {}
  self._receivePointTable = {}
  self._unlockDungeonTable = {}
end

ActivityDailyChallengeNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DailyChallenge_RefreshUnlockItem, self, proto_csmsg.SC_ACTIVITY_DailyChallenge_RefreshUnlockItem, self.SC_ACTIVITY_DailyChallenge_RefreshUnlockItem)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DailyChallenge_GetPointReward, self, proto_csmsg.SC_ACTIVITY_DailyChallenge_GetPointReward, self.SC_ACTIVITY_DailyChallenge_GetPointReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DailyChallenge_UnlockDungeon, self, proto_csmsg.SC_ACTIVITY_DailyChallenge_UnlockDungeon, self.SC_ACTIVITY_DailyChallenge_UnlockDungeon)
end

ActivityDailyChallengeNetworkCtrl.CS_ACTIVITY_DailyChallenge_RefreshUnlockItem = function(self, actId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._refreshItemTable).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_RefreshUnlockItem, proto_csmsg.CS_ACTIVITY_DailyChallenge_RefreshUnlockItem, self._refreshItemTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_RefreshUnlockItem, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DailyChallenge_RefreshUnlockItem)
end

ActivityDailyChallengeNetworkCtrl.SC_ACTIVITY_DailyChallenge_RefreshUnlockItem = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_DailyChallenge_RefreshUnlockItem error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_RefreshUnlockItem)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_RefreshUnlockItem, msg)
  end
end

ActivityDailyChallengeNetworkCtrl.CS_ACTIVITY_DailyChallenge_GetPointReward = function(self, actId, score, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._receivePointTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._receivePointTable).score = score
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_GetPointReward, proto_csmsg.CS_ACTIVITY_DailyChallenge_GetPointReward, self._receivePointTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_GetPointReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DailyChallenge_GetPointReward)
end

ActivityDailyChallengeNetworkCtrl.SC_ACTIVITY_DailyChallenge_GetPointReward = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_DailyChallenge_GetPointReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_GetPointReward)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_GetPointReward, msg)
  end
end

ActivityDailyChallengeNetworkCtrl.CS_ACTIVITY_DailyChallenge_UnlockDungeon = function(self, actId, dungeonId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._unlockDungeonTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._unlockDungeonTable).dungeonId = dungeonId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_UnlockDungeon, proto_csmsg.CS_ACTIVITY_DailyChallenge_UnlockDungeon, self._unlockDungeonTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_UnlockDungeon, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DailyChallenge_UnlockDungeon)
end

ActivityDailyChallengeNetworkCtrl.SC_ACTIVITY_DailyChallenge_UnlockDungeon = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_DailyChallenge_UnlockDungeon error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_UnlockDungeon)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DailyChallenge_UnlockDungeon, msg)
  end
end

return ActivityDailyChallengeNetworkCtrl

