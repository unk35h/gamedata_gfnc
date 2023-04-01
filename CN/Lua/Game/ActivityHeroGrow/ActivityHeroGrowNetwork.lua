-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityHeroGrowNetwork = class("ActivityHeroGrowNetwork", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityHeroGrowNetwork.ctor = function(self)
  -- function num : 0_0
  self._dailyTaskFullReward = {}
  self._singleTokenReward = {}
  self._allTokeonReward = {}
  self._dailyTaskAllReward = {}
end

ActivityHeroGrowNetwork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_DailyTaskFullReward, self, proto_csmsg.SC_ACTIVITYSectorHero_DailyTaskFullReward, self.SC_ACTIVITYSectorHero_DailyTaskFullReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_SingleTokenReward, self, proto_csmsg.SC_ACTIVITYSectorHero_SingleTokenReward, self.SC_ACTIVITYSectorHero_SingleTokenReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_AllTokenReward, self, proto_csmsg.SC_ACTIVITYSectorHero_AllTokenReward, self.SC_ACTIVITYSectorHero_AllTokenReward)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_DailyTaskAllReward, self, proto_csmsg.SC_ACTIVITYSectorHero_DailyTaskAllReward, self.SC_ACTIVITYSectorHero_DailyTaskAllReward)
end

ActivityHeroGrowNetwork.CS_ACTIVITYSectorHero_DailyTaskFullReward = function(self, actId, day, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._dailyTaskFullReward).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._dailyTaskFullReward).day = day
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_DailyTaskFullReward, proto_csmsg.CS_ACTIVITYSectorHero_DailyTaskFullReward, self._dailyTaskFullReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_DailyTaskFullReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_DailyTaskFullReward)
end

ActivityHeroGrowNetwork.SC_ACTIVITYSectorHero_DailyTaskFullReward = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITYSectorHero_DailyTaskFullReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_DailyTaskFullReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.reward)
  end
end

ActivityHeroGrowNetwork.CS_ACTIVITYSectorHero_SingleTokenReward = function(self, actId, tokenRewardLv, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._singleTokenReward).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._singleTokenReward).tokenRewardLv = tokenRewardLv
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_SingleTokenReward, proto_csmsg.CS_ACTIVITYSectorHero_SingleTokenReward, self._singleTokenReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_SingleTokenReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_SingleTokenReward)
end

ActivityHeroGrowNetwork.SC_ACTIVITYSectorHero_SingleTokenReward = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITYSectorHero_SingleTokenReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_SingleTokenReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.reward)
  end
end

ActivityHeroGrowNetwork.CS_ACTIVITYSectorHero_AllTokenReward = function(self, actId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._allTokeonReward).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_AllTokenReward, proto_csmsg.CS_ACTIVITYSectorHero_AllTokenReward, self._allTokeonReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_AllTokenReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_AllTokenReward)
end

ActivityHeroGrowNetwork.SC_ACTIVITYSectorHero_AllTokenReward = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITYSectorHero_AllTokenReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_AllTokenReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.reward)
  end
end

ActivityHeroGrowNetwork.CS_ACTIVITYSectorHero_DailyTaskAllReward = function(self, actId, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._dailyTaskAllReward).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_DailyTaskAllReward, proto_csmsg.CS_ACTIVITYSectorHero_DailyTaskAllReward, self._dailyTaskAllReward)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITYSectorHero_DailyTaskAllReward, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_DailyTaskAllReward)
end

ActivityHeroGrowNetwork.SC_ACTIVITYSectorHero_DailyTaskAllReward = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITYSectorHero_DailyTaskAllReward error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_SC_ACTIVITYSectorHero_DailyTaskAllReward)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.reward)
  end
end

return ActivityHeroGrowNetwork

