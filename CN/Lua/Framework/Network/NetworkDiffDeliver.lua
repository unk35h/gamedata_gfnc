-- params : ...
-- function num : 0 , upvalues : _ENV
local NetworkDiffDeliver = {}
local diffOrderList = {proto_csmsg_SyncUpdateDiffEnum.DIFF_FUNCTION, proto_csmsg_SyncUpdateDiffEnum.DIFF_USERBASE, proto_csmsg_SyncUpdateDiffEnum.DIFF_BATTLEPASS, proto_csmsg_SyncUpdateDiffEnum.DIFF_BUILDING, proto_csmsg_SyncUpdateDiffEnum.DIFF_INTIMACY, proto_csmsg_SyncUpdateDiffEnum.DIFF_FACTORY, proto_csmsg_SyncUpdateDiffEnum.DIFF_SECTOR, proto_csmsg_SyncUpdateDiffEnum.DIFF_ALG, proto_csmsg_SyncUpdateDiffEnum.DIFF_EXPLORATION, proto_csmsg_SyncUpdateDiffEnum.DIFF_HERO, proto_csmsg_SyncUpdateDiffEnum.DIFF_ATH, proto_csmsg_SyncUpdateDiffEnum.DIFF_RESOURCE, proto_csmsg_SyncUpdateDiffEnum.DIFF_EFFECTORRG, proto_csmsg_SyncUpdateDiffEnum.DIFF_QUEST, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACHIEVEMENT, proto_csmsg_SyncUpdateDiffEnum.DIFF_LOTTERY, proto_csmsg_SyncUpdateDiffEnum.DIFF_COUNTER, proto_csmsg_SyncUpdateDiffEnum.DIFF_MAIL, proto_csmsg_SyncUpdateDiffEnum.DIFF_MONTHCARD, proto_csmsg_SyncUpdateDiffEnum.DIFF_ENDLESS, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY, proto_csmsg_SyncUpdateDiffEnum.DIFF_FRIEND, proto_csmsg_SyncUpdateDiffEnum.DIFF_DUNGEON_DYNC, proto_csmsg_SyncUpdateDiffEnum.DIFF_TIMING_PRODUCT, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SECTOR_I, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SECTOR_Hero, proto_csmsg_SyncUpdateDiffEnum.DIFF_DUNGEON_TOWER, proto_csmsg_SyncUpdateDiffEnum.DIFF_HERO_TALENT, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SECTOR_II, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_VALENTINE, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_ROUND, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_REFRESHDUNGEON, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_QUEST, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_CARNIVAL, proto_csmsg_SyncUpdateDiffEnum.DIFF_EFFECT, proto_csmsg_SyncUpdateDiffEnum.DIFF_TINYGAME, proto_csmsg_SyncUpdateDiffEnum.DIFF_RECHARGE, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SUMMER2022, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_HALLOWEEN, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_WINTER2023, proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_INVITATION}
local diffFuncTable = {[proto_csmsg_SyncUpdateDiffEnum.DIFF_ACHIEVEMENT] = function(syncUpdateDiff)
  -- function num : 0_0 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.achievement
  local AchivLevelNetwork = NetworkManager:GetNetwork(NetworkTypeID.AchivLevel)
  if diffMsg ~= nil then
    AchivLevelNetwork:AchieveLevelCommonDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ATH] = function(syncUpdateDiff)
  -- function num : 0_1 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.ath
  local AthNetwork = NetworkManager:GetNetwork(NetworkTypeID.Arithmetic)
  if diffMsg ~= nil then
    AthNetwork:SC_ATH_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_BUILDING] = function(syncUpdateDiff)
  -- function num : 0_2 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.building
  local buildingNetwork = NetworkManager:GetNetwork(NetworkTypeID.Building)
  if diffMsg ~= nil then
    buildingNetwork:OnRecvBuildingSyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_EFFECTORRG] = function(syncUpdateDiff)
  -- function num : 0_3 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.effectorRG
  local EffectorNetwork = NetworkManager:GetNetwork(NetworkTypeID.Effector)
  if diffMsg ~= nil then
    EffectorNetwork:SC_EFFECTOR_RGSyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ENDLESS] = function(syncUpdateDiff)
  -- function num : 0_4 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.endless
  local SectorNetwork = NetworkManager:GetNetwork(NetworkTypeID.Sector)
  if diffMsg ~= nil then
    SectorNetwork:SC_ENDLESS_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_EXPLORATION] = function(syncUpdateDiff)
  -- function num : 0_5 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.exploration
  local epNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  if diffMsg ~= nil then
    epNetwork:SC_EXPLORATION_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_FACTORY] = function(syncUpdateDiff)
  -- function num : 0_6 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.factory
  local FactoryNetwork = NetworkManager:GetNetwork(NetworkTypeID.Factory)
  if diffMsg ~= nil then
    FactoryNetwork:FactoryCommonDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_HERO] = function(syncUpdateDiff)
  -- function num : 0_7 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.hero
  local ObjectNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  if diffMsg ~= nil then
    ObjectNetwork:SC_HERO_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_MAIL] = function(syncUpdateDiff)
  -- function num : 0_8 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.mail
  local MailNetwork = NetworkManager:GetNetwork(NetworkTypeID.Mail)
  if diffMsg ~= nil then
    MailNetwork:MailCommonDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_QUEST] = function(syncUpdateDiff)
  -- function num : 0_9 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.quest
  local TaskNetwork = NetworkManager:GetNetwork(NetworkTypeID.Task)
  if diffMsg ~= nil then
    TaskNetwork:OnRecvSyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_SECTOR] = function(syncUpdateDiff)
  -- function num : 0_10 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.sector
  local SectorNetwork = NetworkManager:GetNetwork(NetworkTypeID.Sector)
  if diffMsg ~= nil then
    SectorNetwork:SC_SECTOR_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_COUNTER] = function(syncUpdateDiff)
  -- function num : 0_11 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.counter
  local ObjectNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  if diffMsg ~= nil then
    ObjectNetwork:SC_COUNTER_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_FUNCTION] = function(syncUpdateDiff)
  -- function num : 0_12 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.functions
  local ObjectNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  if diffMsg ~= nil then
    ObjectNetwork:SC_FUNCTION_SyncUpdateDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_RESOURCE] = function(syncUpdateDiff)
  -- function num : 0_13 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.resource
  local ObjectNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  if diffMsg ~= nil then
    ObjectNetwork:ItemDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_USERBASE] = function(syncUpdateDiff)
  -- function num : 0_14 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.userBase
  local ObjectNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  if diffMsg ~= nil then
    ObjectNetwork:userBaseDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ALG] = function(syncUpdateDiff)
  -- function num : 0_15 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.alg
  local BattleDungeonNetwork = NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)
  if diffMsg ~= nil then
    BattleDungeonNetwork:SC_BATTLE_NtfAlgDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_INTIMACY] = function(syncUpdateDiff)
  -- function num : 0_16 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.intimacy
  local friendshipNetwork = NetworkManager:GetNetwork(NetworkTypeID.Friendship)
  if diffMsg ~= nil then
    friendshipNetwork:SC_INTIMACY_SyncDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_BATTLEPASS] = function(syncUpdateDiff)
  -- function num : 0_17 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.battlepass
  if diffMsg ~= nil then
    (NetworkManager:GetNetwork(NetworkTypeID.BattlePass)):SC_BATTLEPASS_SyncDiff(diffMsg)
  end
  return true
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_MONTHCARD] = function(syncUpdateDiff)
  -- function num : 0_18 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.monthCard
  local dailySignInNetwork = NetworkManager:GetNetwork(NetworkTypeID.DailySignIn)
  if diffMsg ~= nil then
    dailySignInNetwork:ApplyMonthCardDiff(diffMsg.update)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY] = function(syncUpdateDiff)
  -- function num : 0_19 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.activity
  local netWorkController = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  if diffMsg ~= nil then
    netWorkController:ApplyActivityDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_LOTTERY] = function(syncUpdateDiff)
  -- function num : 0_20 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.lottery
  local netWorkController = NetworkManager:GetNetwork(NetworkTypeID.Lottery)
  if diffMsg ~= nil then
    netWorkController:SC_LOTTERY_SyncDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_FRIEND] = function(syncUpdateDiff)
  -- function num : 0_21 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.friend
  local netWorkController = NetworkManager:GetNetwork(NetworkTypeID.Friend)
  if diffMsg ~= nil and netWorkController ~= nil then
    netWorkController:HandleFriendDiffer(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_DUNGEON_DYNC] = function(syncUpdateDiff)
  -- function num : 0_22 , upvalues : _ENV
  local diffMsg = syncUpdateDiff.dungeonDync
  local netWorkController = NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)
  if diffMsg ~= nil and netWorkController ~= nil then
    netWorkController:SC_DUNGEON_Dync_SyncDiff(diffMsg)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_TIMING_PRODUCT] = function(syncUpdateDiff)
  -- function num : 0_23 , upvalues : _ENV
  local timingProduct = syncUpdateDiff.timingProduct
  local netWorkController = NetworkManager:GetNetwork(NetworkTypeID.TimingProduct)
  if timingProduct ~= nil and netWorkController ~= nil then
    netWorkController:SC_TimingProduct_SyncUpdateDiff(timingProduct)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SECTOR_I] = function(syncUpdateDiff)
  -- function num : 0_24 , upvalues : _ENV
  local acitvitySectorI = syncUpdateDiff.acitvitySectorI
  local netWorkController = NetworkManager:GetNetwork(NetworkTypeID.ActivitySectorI)
  if acitvitySectorI ~= nil and netWorkController ~= nil then
    netWorkController:SC_ACTIVITYSECTORI_SyncDiff(acitvitySectorI)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SECTOR_Hero] = function(syncUpdateDiff)
  -- function num : 0_25 , upvalues : _ENV
  if syncUpdateDiff.acitvitySectorHero ~= nil then
    local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow, true)
    heroGrowCtrl:UpdateHeroGrow((syncUpdateDiff.acitvitySectorHero).data)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_DUNGEON_TOWER] = function(syncUpdateDiff)
  -- function num : 0_26 , upvalues : _ENV
  if syncUpdateDiff.dungeonTower ~= nil then
    (PlayerDataCenter.dungeonTowerSData):UpdateTowerServerData(syncUpdateDiff.dungeonTower)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_HERO_TALENT] = function(syncUpdateDiff)
  -- function num : 0_27 , upvalues : _ENV
  if syncUpdateDiff.heroTalent ~= nil then
    local networkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Hero)
    networkCtrl:SC_HERO_TALENT_SyncDiff(syncUpdateDiff.heroTalent)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SECTOR_II] = function(syncUpdateDiff)
  -- function num : 0_28 , upvalues : _ENV
  if syncUpdateDiff.activitySectorII ~= nil then
    local networkCtrl = NetworkManager:GetNetwork(NetworkTypeID.DungeonSectorII)
    networkCtrl:SC_ACTIVITYSCTORII_SyncDiff(syncUpdateDiff.activitySectorII)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_VALENTINE] = function(syncUpdateDiff)
  -- function num : 0_29 , upvalues : _ENV
  if syncUpdateDiff.activityValentine ~= nil then
    local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
    if whiteDayCtrl ~= nil then
      whiteDayCtrl:UpdataSingleWhiteDayActivity((syncUpdateDiff.activityValentine).data)
    end
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_ROUND] = function(syncUpdateDiff)
  -- function num : 0_30 , upvalues : _ENV
  do
    if syncUpdateDiff.activityRound ~= nil then
      local activityRoundCtrl = ControllerManager:GetController(ControllerTypeId.ActivityRound)
      if activityRoundCtrl ~= nil then
        activityRoundCtrl:UpdateActivityRound((syncUpdateDiff.activityRound).data)
      end
    end
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_REFRESHDUNGEON] = function(syncUpdateDiff)
  -- function num : 0_31 , upvalues : _ENV
  if syncUpdateDiff.activityRefreshDungeon ~= nil then
    local refreshDunCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
    if refreshDunCtrl ~= nil then
      refreshDunCtrl:UpdateAllRefreshDunActivity((syncUpdateDiff.activityRefreshDungeon).data)
    end
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_QUEST] = function(syncUpdateDiff)
  -- function num : 0_32 , upvalues : _ENV
  if syncUpdateDiff.activityQuest ~= nil then
    local activityTaskCtrl = ControllerManager:GetController(ControllerTypeId.ActivityTask)
    if activityTaskCtrl ~= nil then
      for k,singleMsg in pairs((syncUpdateDiff.activityQuest).data) do
        activityTaskCtrl:UpadteTaskActivity(singleMsg)
      end
    end
    do
      do return true end
    end
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_CARNIVAL] = function(syncUpdateDiff)
  -- function num : 0_33 , upvalues : _ENV
  if syncUpdateDiff.activityCarnival ~= nil then
    local activityCarnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
    if activityCarnivalCtrl ~= nil then
      for k,singleMsg in pairs((syncUpdateDiff.activityCarnival).data) do
        activityCarnivalCtrl:UpdateCarnivalAct(singleMsg)
      end
    end
    do
      do return true end
    end
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_EFFECT] = function(syncUpdateDiff)
  -- function num : 0_34 , upvalues : _ENV
  if syncUpdateDiff.effect ~= nil then
    MsgCenter:Broadcast(eMsgEventId.OnSpecEffectDiff, (syncUpdateDiff.effect).diff)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_TINYGAME] = function(syncUpdateDiff)
  -- function num : 0_35 , upvalues : _ENV
  if syncUpdateDiff.tinyGame ~= nil then
    local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
    activityFrameCtrl:UpdateAllTinyGame((syncUpdateDiff.tinyGame).diff)
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_RECHARGE] = function(syncUpdateDiff)
  -- function num : 0_36 , upvalues : _ENV
  if syncUpdateDiff.recharge ~= nil then
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
    payCtrl:RechargeSync((syncUpdateDiff.recharge).stat)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_SUMMER2022] = function(syncUpdateDiff)
  -- function num : 0_37 , upvalues : _ENV
  if syncUpdateDiff.activitySummer2022 ~= nil then
    local sectorIIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII, true)
    sectorIIICtrl:InitSectorIIIData((syncUpdateDiff.activitySummer2022).data)
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_HALLOWEEN] = function(syncUpdateDiff)
  -- function num : 0_38 , upvalues : _ENV
  if syncUpdateDiff.activityHalloween ~= nil then
    local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas, true)
    local list = (syncUpdateDiff.activityHalloween).data
    if list ~= nil then
      for i,msg in ipairs(list) do
        hallowmasCtrl:UpdateHallowmas(msg)
      end
    end
    do
      do return true end
    end
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_WINTER2023] = function(syncUpdateDiff)
  -- function num : 0_39 , upvalues : _ENV
  if syncUpdateDiff.activityWinter2023 ~= nil then
    local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
    if winter23Ctrl then
      winter23Ctrl:UpdateWinter23((syncUpdateDiff.activityWinter2023).data)
    end
    return true
  end
end
, [proto_csmsg_SyncUpdateDiffEnum.DIFF_ACTIVITY_INVITATION] = function(syncUpdateDiff)
  -- function num : 0_40 , upvalues : _ENV
  if syncUpdateDiff.activityInvitation ~= nil then
    local invitationCtrl = ControllerManager:GetController(ControllerTypeId.ActivityInvitation)
    if invitationCtrl ~= nil then
      invitationCtrl:UpdateInvitation(syncUpdateDiff.activityInvitation)
      return true
    end
  end
end
}
NetworkDiffDeliver.HandleDiff = function(self, syncUpdateDiff)
  -- function num : 0_41 , upvalues : _ENV, diffOrderList
  if syncUpdateDiff == nil then
    return 
  end
  local flagMap = syncUpdateDiff.flag
  for k,syncUpdateDiffEnum in ipairs(diffOrderList) do
    if flagMap[syncUpdateDiffEnum] then
      self:__HandleDiffEnum(syncUpdateDiff, syncUpdateDiffEnum)
    end
  end
  MsgCenter:Broadcast(eMsgEventId.NetDiffSyncFinish)
end

NetworkDiffDeliver.__HandleDiffEnum = function(self, syncUpdateDiff, syncUpdateDiffEnum)
  -- function num : 0_42 , upvalues : diffFuncTable, _ENV
  local func = diffFuncTable[syncUpdateDiffEnum]
  if func ~= nil then
    local isSuccessUpdate = func(syncUpdateDiff)
    if not isSuccessUpdate then
      error("can\'t apply diff diffId=" .. tostring(syncUpdateDiffEnum))
    end
  else
    do
      error("don\'t have diffFunc diffId=" .. tostring(syncUpdateDiffEnum))
    end
  end
end

return NetworkDiffDeliver

