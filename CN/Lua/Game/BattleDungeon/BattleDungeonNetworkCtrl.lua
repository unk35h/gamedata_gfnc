-- params : ...
-- function num : 0 , upvalues : _ENV
local BattleDungeonNetworkCtrl = class("BattleDungeonNetworkCtrl", NetworkCtrlBase)
local DungeonConst = require("Game.BattleDungeon.DungeonConst")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
BattleDungeonNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.sendChipSelect = {}
  self.sendEnterChapter = {
formInfo = {}
}
  self.batlleFmtRefreshTab = {
formInfo = {}
}
  self.selectChipGroupTab = {}
  self.cstChangeTable = {}
  self.chipSelect = {}
  self._dailyDungeonQuick = {}
end

BattleDungeonNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter, self, proto_csmsg.SC_BATTLE_NtfEnter, self.SC_BATTLE_NtfEnter)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfWaveStep, self, proto_csmsg.SC_BATTLE_NtfWaveStep, self.SC_BATTLE_NtfWaveStep)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfOverRewards, self, proto_csmsg.SC_BATTLE_NtfOverRewards, self.SC_BATTLE_NtfOverRewards)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfMonsterData, self, proto_csmsg.SC_BATTLE_NtfMonsterData, self.SC_BATTLE_NtfMonsterData)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfAlgData, self, proto_csmsg.SC_BATTLE_NtfAlgData, self.SC_BATTLE_NtfAlgData)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfAlgDiff, self, proto_csmsg.SC_BATTLE_NtfAlgDiff, self.SC_BATTLE_NtfAlgDiff)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_BattleSettle, self, proto_csmsg.SC_BATTLE_BattleSettle, self.SC_BATTLE_BattleSettle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_AlgSelect, self, proto_csmsg.SC_BATTLE_AlgSelect, self.SC_BATTLE_AlgSelect)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_StartBattleWithForm, self, proto_csmsg.SC_BATTLE_StartBattleWithForm, self.SC_BATTLE_StartBattleWithForm)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_Quit, self, proto_csmsg.SC_BATTLE_Quit, self.SC_BATTLE_Quit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_Restart, self, proto_csmsg.SC_BATTLE_Restart, self.SC_BATTLE_Restart)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEON_STATIC_Detail, self, proto_csmsg.SC_DUNGEON_STATIC_Detail, self.SC_DUNGEON_STATIC_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_DungeonEnter, self, proto_csmsg.SC_BATTLE_DungeonEnter, self.SC_BATTLE_DungeonEnter)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_AlgGiveUp, self, proto_csmsg.SC_BATTLE_AlgGiveUp, self.SC_BATTLE_AlgGiveUp)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DUNGEON_Dync_Detail, self, proto_csmsg.SC_DUNGEON_Dync_Detail, self.SC_DUNGEON_Dync_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_FormationFresh, self, proto_csmsg.SC_BATTLE_FormationFresh, self.SC_BATTLE_FormationFresh)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_SelectChipGroup, self, proto_csmsg.SC_BATTLE_SelectChipGroup, self.SC_BATTLE_SelectChipGroup)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLE_OpeningAlgSelect, self, proto_csmsg.SC_BATTLE_OpeningAlgSelect, self.SC_BATTLE_OpeningAlgSelect)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_DailyDungeon_Quick, self, proto_csmsg.SC_DailyDungeon_Quick, self.SC_DailyDungeon_Quick)
end

BattleDungeonNetworkCtrl.SC_BATTLE_NtfWaveStep = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV, DungeonConst
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  BattleDungeonManager:AddDungeonLogic((DungeonConst.LogicType).SceneStep, msg.wave)
end

BattleDungeonNetworkCtrl.SC_BATTLE_NtfMonsterData = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, DungeonConst
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  BattleDungeonManager:AddDungeonLogic((DungeonConst.LogicType).BattleStep, msg)
end

BattleDungeonNetworkCtrl.SC_BATTLE_NtfOverRewards = function(self, msg)
  -- function num : 0_4 , upvalues : _ENV, DungeonConst
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  local getATH = {}
  if msg.syncUpdateDiff ~= nil and (msg.syncUpdateDiff).ath ~= nil then
    for key,sthEle in pairs(((msg.syncUpdateDiff).ath).updateAth) do
      getATH[sthEle.uid] = sthEle.uid
    end
  end
  do
    msg.getATH = getATH
    BattleDungeonManager:AddDungeonLogic((DungeonConst.LogicType).OverRewards, msg)
  end
end

BattleDungeonNetworkCtrl.SC_BATTLE_NtfAlgData = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, DungeonConst
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  BattleDungeonManager:AddDungeonLogic((DungeonConst.LogicType).ChipStep, msg)
end

BattleDungeonNetworkCtrl.CS_BATTLE_AlgSelect = function(self, idx, callBack)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.sendChipSelect).idx = idx
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_AlgSelect, proto_csmsg.CS_BATTLE_AlgSelect, self.sendChipSelect)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_AlgSelect, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_AlgSelect)
end

BattleDungeonNetworkCtrl.SC_BATTLE_AlgSelect = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_AlgSelect error:" .. tostring(msg.ret)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    error(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_AlgSelect)
    return 
  end
end

BattleDungeonNetworkCtrl.SC_BATTLE_NtfAlgDiff = function(self, msg)
  -- function num : 0_8 , upvalues : _ENV
  local diffData = msg.diff
  MsgCenter:Broadcast(eMsgEventId.OnChipDataDiff, diffData)
end

BattleDungeonNetworkCtrl.CS_BATTLE_BattleSettle = function(self, sendMsg, callBack)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_BattleSettle, proto_csmsg.CS_BATTLE_BattleSettle, sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_BattleSettle, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_BattleSettle, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfOverRewards)
end

BattleDungeonNetworkCtrl.SC_BATTLE_BattleSettle = function(self, msg)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_BattleSettle error:" .. tostring(msg.ret)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    error(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_BattleSettle)
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_StartBattleWithForm = function(self, sendMsg, callBack)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_StartBattleWithForm, proto_csmsg.CS_BATTLE_StartBattleWithForm, sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_StartBattleWithForm, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_StartBattleWithForm)
end

BattleDungeonNetworkCtrl.SC_BATTLE_StartBattleWithForm = function(self, msg)
  -- function num : 0_12 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_StartBattleWithForm error:" .. tostring(msg.ret)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    error(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_StartBattleWithForm)
    return 
  else
    do
      cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_BATTLE_StartBattleWithForm, msg.seed)
    end
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_Quit = function(self, callBack)
  -- function num : 0_13 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_Quit, proto_csmsg.CS_BATTLE_Quit, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_Quit, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_Quit)
end

BattleDungeonNetworkCtrl.SC_BATTLE_Quit = function(self, msg)
  -- function num : 0_14 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_Quit error:" .. tostring(msg.ret)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    error(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_Quit)
    return 
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_Restart = function(self, callBack)
  -- function num : 0_15 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_Restart, proto_csmsg.CS_BATTLE_Restart, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_Restart, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_Restart)
end

BattleDungeonNetworkCtrl.SC_BATTLE_Restart = function(self, msg)
  -- function num : 0_16 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_Restart error:" .. tostring(msg.ret)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    error(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_Restart)
    return 
  end
end

BattleDungeonNetworkCtrl.CS_DUNGEON_STATIC_Detail = function(self, callBack)
  -- function num : 0_17 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEON_STATIC_Detail, proto_csmsg.CS_DUNGEON_STATIC_Detail, {})
  if callBack ~= nil then
    cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEON_STATIC_Detail, callBack, proto_csmsg_MSG_ID.MSG_SC_DUNGEON_STATIC_Detail)
  end
end

BattleDungeonNetworkCtrl.SC_DUNGEON_STATIC_Detail = function(self, msg)
  -- function num : 0_18 , upvalues : _ENV
  PlayerDataCenter:UpdateDungeonBattleTimes(msg)
  MsgCenter:Broadcast(eMsgEventId.OnBattleDungeonLimitChange)
  MsgCenter:Broadcast(eMsgEventId.OnBattleDungeonLimitInit)
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
end

BattleDungeonNetworkCtrl.CS_DUNGEON_Dync_Detail = function(self, callBack)
  -- function num : 0_19 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DUNGEON_Dync_Detail, proto_csmsg.CS_DUNGEON_Dync_Detail, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DUNGEON_Dync_Detail, callBack, proto_csmsg_MSG_ID.MSG_SC_DUNGEON_Dync_Detail)
end

BattleDungeonNetworkCtrl.SC_DUNGEON_Dync_Detail = function(self, msg)
  -- function num : 0_20 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  ;
  (PlayerDataCenter.dungeonDyncData):InitDungeonDyncData(msg.dungeonDync)
end

BattleDungeonNetworkCtrl.SC_DUNGEON_Dync_SyncDiff = function(self, msg)
  -- function num : 0_21 , upvalues : _ENV
  (PlayerDataCenter.dungeonDyncData):UpdDungeonDyncData(msg.update, msg.delete)
end

BattleDungeonNetworkCtrl.CS_BATTLE_DungeonEnter = function(self, stageId, formationData, activateDrop, callBack, starting, substitute, decompose)
  -- function num : 0_22 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R8 in 'UnsetPending'

  (self.sendEnterChapter).stageId = stageId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.sendEnterChapter).formInfo).formationId = formationData.id
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.sendEnterChapter).formInfo).support = formationData:GetSupportHeroData()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.sendEnterChapter).activateDrop = activateDrop
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.sendEnterChapter).starting = starting
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.sendEnterChapter).substitute = substitute
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.sendEnterChapter).autoDecoAth = decompose
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_DungeonEnter, proto_csmsg.CS_BATTLE_DungeonEnter, self.sendEnterChapter)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_DungeonEnter, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_DungeonEnter, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter)
end

BattleDungeonNetworkCtrl.SC_BATTLE_DungeonEnter = function(self, msg)
  -- function num : 0_23 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "BattleDungeonNetworkCtrl:SC_BATTLE_DungeonEnter error:" .. tostring(msg.ret)
      error(err)
      if isGameDev then
        ((CS.MessageCommon).ShowMessageTips)(err)
      end
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_DungeonEnter)
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_BATTLE_DungeonEnter, {ab = msg.ab, astHeroId = msg.astHeroId})
  end
end

BattleDungeonNetworkCtrl.SC_BATTLE_NtfEnter = function(self, msg)
  -- function num : 0_24 , upvalues : _ENV, DungeonLevelEnum, cs_WaitNetworkResponse
  local dungeonStageCfg = (ConfigData.battle_dungeon)[msg.dungeonId]
  if dungeonStageCfg == nil then
    error("dungeon stage cfg is null,id:" .. tostring(msg.dungeonId))
    return 
  end
  local msgId = (DungeonLevelEnum.DunModuleMsgProto)[dungeonStageCfg.module_id]
  if msgId ~= nil then
    cs_WaitNetworkResponse:AddWaitData(msgId, msg)
  else
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_BATTLE_DungeonEnter, msg)
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_AlgGiveUp = function(self, callback)
  -- function num : 0_25 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_AlgGiveUp, proto_csmsg.CS_BATTLE_AlgGiveUp, {})
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_AlgGiveUp, callback, proto_csmsg_MSG_ID.MSG_SC_BATTLE_AlgGiveUp)
end

BattleDungeonNetworkCtrl.SC_BATTLE_AlgGiveUp = function(self, msg)
  -- function num : 0_26 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_AlgGiveUp error:" .. tostring(msg.ret)
    error(err)
    if isGameDev then
      ((CS.MessageCommon).ShowMessageTips)(err)
    end
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_AlgGiveUp)
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_FormationFresh = function(self, formationData, commandSkillChanged, heroChangedIdDic, callBack)
  -- function num : 0_27 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ((self.batlleFmtRefreshTab).formInfo).formationId = formationData.id
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.batlleFmtRefreshTab).formInfo).support = formationData:GetSupportHeroData()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.batlleFmtRefreshTab).commandSkillChanged = commandSkillChanged
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.batlleFmtRefreshTab).heroChanged = heroChangedIdDic
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_FormationFresh, proto_csmsg.CS_BATTLE_FormationFresh, self.batlleFmtRefreshTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_FormationFresh, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_FormationFresh)
end

BattleDungeonNetworkCtrl.SC_BATTLE_FormationFresh = function(self, msg)
  -- function num : 0_28 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "BattleDungeonNetworkCtrl:SC_BATTLE_FormationFresh error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_FormationFresh)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_BATTLE_FormationFresh, msg)
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_SelectChipGroup = function(self, chipIdDic, callBack)
  -- function num : 0_29 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.selectChipGroupTab).selected = chipIdDic
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_SelectChipGroup, proto_csmsg.CS_BATTLE_SelectChipGroup, self.selectChipGroupTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_SelectChipGroup, callBack, proto_csmsg_MSG_ID.MSG_SC_BATTLE_SelectChipGroup)
end

BattleDungeonNetworkCtrl.SC_BATTLE_SelectChipGroup = function(self, msg)
  -- function num : 0_30 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_SelectChipGroup error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_SelectChipGroup)
    return 
  end
end

BattleDungeonNetworkCtrl.CS_BATTLE_OpeningAlgSelect = function(self, chipId, callback)
  -- function num : 0_31 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.chipSelect).algId = chipId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLE_OpeningAlgSelect, proto_csmsg.CS_BATTLE_OpeningAlgSelect, self.chipSelect)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_OpeningAlgSelect, callback, proto_csmsg_MSG_ID.MSG_SC_BATTLE_OpeningAlgSelect)
end

BattleDungeonNetworkCtrl.SC_BATTLE_OpeningAlgSelect = function(self, msg)
  -- function num : 0_32 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattleDungeonNetworkCtrl:SC_BATTLE_OpeningAlgSelect error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLE_OpeningAlgSelect)
    return 
  end
end

BattleDungeonNetworkCtrl.CS_DailyDungeon_Quick = function(self, moduleId, callback)
  -- function num : 0_33 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._dailyDungeonQuick).moduleId = moduleId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_DailyDungeon_Quick, proto_csmsg.CS_DailyDungeon_Quick, self._dailyDungeonQuick)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_DailyDungeon_Quick, callback, proto_csmsg_MSG_ID.MSG_SC_DailyDungeon_Quick)
end

BattleDungeonNetworkCtrl.SC_DailyDungeon_Quick = function(self, msg)
  -- function num : 0_34 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "BattleDungeonNetworkCtrl:SC_DailyDungeon_Quick error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_DailyDungeon_Quick)
      return 
    end
    MsgCenter:Broadcast(eMsgEventId.DailyDungeonOutOfData)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_DailyDungeon_Quick, msg)
  end
end

BattleDungeonNetworkCtrl.Reset = function(self)
  -- function num : 0_35
end

return BattleDungeonNetworkCtrl

