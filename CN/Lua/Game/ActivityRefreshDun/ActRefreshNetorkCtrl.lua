-- params : ...
-- function num : 0 , upvalues : _ENV
local ActRefreshNetorkCtrl = class("ActRefreshNetorkCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActRefreshNetorkCtrl.ctor = function(self)
  -- function num : 0_0
  self._msg = {}
end

ActRefreshNetorkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_FetchOverDay, self, proto_csmsg.SC_ACTIVITY_REFRESHDUNGEON_FetchOverDay, self.SC_ACTIVITY_REFRESHDUNGEON_FetchOverDay)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_SyncDiff, self, proto_csmsg.SC_ACTIVITYSCTORII_SyncDiff, self.SC_ACTIVITYSCTORII_SyncDiff)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh, self, proto_csmsg.SC_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh, self.SC_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_SingleRefresh, self, proto_csmsg.SC_ACTIVITY_REFRESHDUNGEON_SingleRefresh, self.SC_ACTIVITY_REFRESHDUNGEON_SingleRefresh)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_EnterDungeon, self, proto_csmsg.SC_ACTIVITY_REFRESHDUNGEON_EnterDungeon, self.SC_ACTIVITY_REFRESHDUNGEON_EnterDungeon)
end

ActRefreshNetorkCtrl.CS_ACTIVITY_REFRESHDUNGEON_FetchOverDay = function(self, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_FetchOverDay, proto_csmsg.CS_ACTIVITY_REFRESHDUNGEON_FetchOverDay, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_FetchOverDay, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_FetchOverDay)
end

ActRefreshNetorkCtrl.SC_ACTIVITY_REFRESHDUNGEON_FetchOverDay = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_REFRESHDUNGEON_FetchOverDay error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_FetchOverDay)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActRefreshNetorkCtrl.CS_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh = function(self, actId, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._msg).act = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh, proto_csmsg.CS_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh, self._msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh)
end

ActRefreshNetorkCtrl.SC_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_PurchaseRefresh)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActRefreshNetorkCtrl.CS_ACTIVITY_REFRESHDUNGEON_SingleRefresh = function(self, actId, dungeonId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._msg).act = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._msg).dungeonId = dungeonId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_SingleRefresh, proto_csmsg.CS_ACTIVITY_REFRESHDUNGEON_SingleRefresh, self._msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_SingleRefresh, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_SingleRefresh)
end

ActRefreshNetorkCtrl.SC_ACTIVITY_REFRESHDUNGEON_SingleRefresh = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_REFRESHDUNGEON_SingleRefresh error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_SingleRefresh)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActRefreshNetorkCtrl.CS_ACTIVITY_REFRESHDUNGEON_EnterDungeon = function(self, actId, dungeonId, formationData, callback, firstPower, benchPower)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.actId = actId
  msg.dungeonId = dungeonId
  msg.formInfo = {}
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (msg.formInfo).formationId = formationData.id
  msg.startPower = firstPower
  msg.subPower = benchPower
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_EnterDungeon, proto_csmsg.CS_ACTIVITY_REFRESHDUNGEON_EnterDungeon, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_REFRESHDUNGEON_EnterDungeon, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_REFRESHDUNGEON_EnterDungeon, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter)
end

ActRefreshNetorkCtrl.SC_ACTIVITY_REFRESHDUNGEON_EnterDungeon = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_REFRESHDUNGEON_EnterDungeon error:" .. tostring(msg.ret)
      error(err)
      if isGameDev then
        ((CS.MessageCommon).ShowMessageTips)(err)
      end
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Enter)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActRefreshNetorkCtrl.SC_ACTIVITYSCTORII_SyncDiff = function(self, msg)
  -- function num : 0_10 , upvalues : _ENV
  local refreshDunCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
  if refreshDunCtrl ~= nil then
    refreshDunCtrl:UpdataSingleRefreshDunActivity(msg)
  end
end

ActRefreshNetorkCtrl.Reset = function(self)
  -- function num : 0_11
end

return ActRefreshNetorkCtrl

