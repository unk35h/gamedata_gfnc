-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonTowerNetworkCtrl = class("DungeonTowerNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
DungeonTowerNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.sendEnterTower = {
formInfo = {}
}
  self.sendRacingPick = {}
  self.sendHeroPass = {}
end

DungeonTowerNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_Detail, self, proto_csmsg.SC_DUNGEONTOWER_Detail, self.SC_DUNGEONTOWER_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_Enter, self, proto_csmsg.SC_DUNGEONTOWER_Enter, self.SC_DUNGEONTOWER_Enter)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_Pick, self, proto_csmsg.SC_DUNGEONTOWER_Pick, self.SC_DUNGEONTOWER_Pick)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_RacingRankSelfDetail, self, proto_csmsg.SC_DUNGEONTOWER_RacingRankSelfDetail, self.SC_DUNGEONTOWER_RacingRankSelfDetail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_HeroPassDetail, self, proto_csmsg.SC_DUNGEONTOWER_HeroPassDetail, self.SC_DUNGEONTOWER_HeroPassDetail)
end

DungeonTowerNetworkCtrl.CS_DUNGEONTOWER_Detail = function(self)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Detail, proto_csmsg.CS_DUNGEONTOWER_Detail, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Detail, proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_Detail)
end

DungeonTowerNetworkCtrl.SC_DUNGEONTOWER_Detail = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  (PlayerDataCenter.dungeonTowerSData):InitTowerServerData(msg.towerData)
end

DungeonTowerNetworkCtrl.CS_DUNGEONTOWER_Enter = function(self, towerId, floorId, formationData, callBack, starting, substitute)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R7 in 'UnsetPending'

  (self.sendEnterTower).towerId = towerId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.sendEnterTower).floorId = floorId
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.sendEnterTower).formInfo).formationId = formationData.id
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.sendEnterTower).starting = starting
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.sendEnterTower).substitute = substitute
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Enter, proto_csmsg.CS_DUNGEONTOWER_Enter, self.sendEnterTower)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Enter, callBack, proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_Enter, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter)
end

DungeonTowerNetworkCtrl.SC_DUNGEONTOWER_Enter = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "DungeonTowerNetworkCtrl:SC_DUNGEONTOWER_Enter error:" .. tostring(msg.ret)
    error(err)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Enter)
  end
end

DungeonTowerNetworkCtrl.CS_DUNGEONTOWER_Pick = function(self, towerId, rewardId, callBack)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.sendRacingPick).towerId = towerId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.sendRacingPick).rewardId = rewardId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Pick, proto_csmsg.CS_DUNGEONTOWER_Pick, self.sendRacingPick)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Pick, callBack, proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_Pick)
end

DungeonTowerNetworkCtrl.SC_DUNGEONTOWER_Pick = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "DungeonTowerNetworkCtrl:SC_DUNGEONTOWER_Pick error:" .. tostring(msg.ret)
    error(err)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_Pick)
  end
end

DungeonTowerNetworkCtrl.CS_DUNGEONTOWER_RacingRankSelfDetail = function(self, callBack)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_RacingRankSelfDetail, proto_csmsg.CS_DUNGEONTOWER_RacingRankSelfDetail, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_RacingRankSelfDetail, callBack, proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_RacingRankSelfDetail)
end

DungeonTowerNetworkCtrl.SC_DUNGEONTOWER_RacingRankSelfDetail = function(self, msg)
  -- function num : 0_9 , upvalues : cs_WaitNetworkResponse, _ENV
  cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_RacingRankSelfDetail, msg)
end

DungeonTowerNetworkCtrl.CS_DUNGEONTOWER_HeroPassDetail = function(self, towerId, floorId, callBack)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.sendHeroPass).towerId = towerId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.sendHeroPass).floorId = floorId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_HeroPassDetail, proto_csmsg.CS_DUNGEONTOWER_HeroPassDetail, self.sendHeroPass)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_HeroPassDetail, callBack, proto_csmsg_MSG_ID.MSG_SC_DUNGEONTOWER_HeroPassDetail)
end

DungeonTowerNetworkCtrl.SC_DUNGEONTOWER_HeroPassDetail = function(self, msg)
  -- function num : 0_11 , upvalues : cs_WaitNetworkResponse, _ENV
  cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_DUNGEONTOWER_HeroPassDetail, msg)
end

DungeonTowerNetworkCtrl.Reset = function(self)
  -- function num : 0_12
end

return DungeonTowerNetworkCtrl

