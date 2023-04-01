-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivityFrameRunningEndFunc = {[(ActivityFrameEnum.eActivityType).BattlePass] = function(activityFrameData)
  -- function num : 0_0 , upvalues : _ENV
  (PlayerDataCenter.battlepassData):OnBattlePassEnd(activityFrameData.actId)
end
, [(ActivityFrameEnum.eActivityType).SectorI] = function(activityFrameData)
  -- function num : 0_1 , upvalues : _ENV, SectorStageDetailHelper
  local sectorActivity = (PlayerDataCenter.allActivitySectorIData):GetSectorIData(activityFrameData.actId)
  if sectorActivity == nil then
    return 
  end
  sectorActivity:RefreshSectorIReddot()
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.ActSummerLvSwitch) then
    UIManager:HideWindow(UIWindowTypeID.MessageCommon)
    ;
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActSummerLvSwitch, true)
  end
  local actId = activityFrameData.actId
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivitySectorI)
  local actCfg = (ConfigData.activity_time_limit)[actId]
  if ExplorationManager:IsInExploration() then
    local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
    local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
    do
      if stageCfg ~= nil then
        local sectorIActId = ((ConfigData.activity_time_limit).sectorMapping)[stageCfg.sector]
        if sectorIActId == actId and actCfg.hard_stage ~= stageCfg.sector then
          TimerManager:StartTimer(1, function()
    -- function num : 0_1_0 , upvalues : _ENV, activityFrameData
    local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
    explorationNetwork:CS_EXPLORATION_Detail(activityFrameData:GetActivityFrameId())
  end
, nil, true)
        end
      end
      MsgCenter:Broadcast(eMsgEventId.SectorActivityRunEnd, activityFrameData.actId)
    end
  end
end
, [(ActivityFrameEnum.eActivityType).HeroGrow] = function(activityFrameData)
  -- function num : 0_2 , upvalues : _ENV
  local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
  do
    if heroGrowCtrl ~= nil then
      local data = heroGrowCtrl:GetHeroGrowActivity(activityFrameData.actId)
      if data ~= nil then
        data:RefreshHeroGrowChallengeNewReddot()
      end
    end
    MsgCenter:Broadcast(eMsgEventId.HeroGrowActivityRunEnd, activityFrameData.actId)
  end
end
, [(ActivityFrameEnum.eActivityType).SectorII] = function(activityFrameData)
  -- function num : 0_3 , upvalues : _ENV, SectorStageDetailHelper
  local actId = activityFrameData.actId
  local SectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII, true)
  local sectorIIdata = SectorIICtrl:GetSectorIIDataByActId(actId)
  if sectorIIdata == nil then
    return 
  end
  sectorIIdata:RefreshSectorIIReddotWhenActEnd()
  local AWMainMapWin = UIManager:GetWindow(UIWindowTypeID.ActivityWinterMainMap)
  if AWMainMapWin ~= nil then
    if UIManager:GetWindow(UIWindowTypeID.Win21Shop) == nil then
      (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActivityWinterMainMap)
    end
    AWMainMapWin:ShowActivtyFinishedUI()
  end
  local Win21SectorBarWin = UIManager:GetWindow(UIWindowTypeID.Win21SectorBar)
  if Win21SectorBarWin ~= nil then
    Win21SectorBarWin:SetIsTreeFinishedUI(true)
  end
  if ExplorationManager:IsInExploration() then
    local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
    local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
    do
      if stageCfg ~= nil and sectorIIdata:GetSectorIIActId() == actId then
        local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
        explorationNetwork:CS_EXPLORATION_Detail(activityFrameData:GetActivityFrameId())
      end
      MsgCenter:Broadcast(eMsgEventId.SectorActivityRunEnd, activityFrameData.actId)
    end
  end
end
, [(ActivityFrameEnum.eActivityType).RefreshDun] = function(activityFrameData)
  -- function num : 0_4 , upvalues : _ENV, DungeonLevelEnum
  local daMieWin = UIManager:GetWindow(UIWindowTypeID.AprilGameDamie)
  if daMieWin ~= nil then
    daMieWin:OnClickDamieBack()
  end
  local win = UIManager:GetWindow(UIWindowTypeID.AprilFool)
  if win ~= nil then
    win:RefreshAprilFoolMain()
  end
  if BattleDungeonManager:InBattleDungeon() then
    local dunInterfaceType = (BattleDungeonManager.dunInterfaceData):GetInterfaceType()
    if dunInterfaceType == (DungeonLevelEnum.InterfaceType).RefreshDun then
      (NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)):CS_DUNGEON_Dync_Detail(function()
    -- function num : 0_4_0 , upvalues : _ENV
    local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
    if dungeonCtrl ~= nil and dungeonCtrl:DungeonIsInWaitFirstLoadScene() then
      dungeonCtrl:SetDungeonAfterEnterSceneExit()
    else
      BattleDungeonManager:RetreatDungeonNoReq()
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

      if (Time.unity_time).timeScale ~= 1 then
        (Time.unity_time).timeScale = 1
      end
    end
  end
)
    end
  end
end
, [(ActivityFrameEnum.eActivityType).Carnival] = function(activityFrameData)
  -- function num : 0_5 , upvalues : _ENV, DungeonLevelEnum
  local actId = activityFrameData.actId
  local activityCarnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
  if activityCarnivalCtrl == nil then
    return 
  end
  local carnivalData = activityCarnivalCtrl:GetCarnivalAct(actId)
  if carnivalData == nil then
    return 
  end
  carnivalData:DealCarnivalWhenEnd()
  local carnivalWin = UIManager:GetWindow(UIWindowTypeID.Carnival22Main)
  if carnivalWin ~= nil then
    carnivalWin:RefreshCarnivalBtnState()
    if UIManager:GetWindow(UIWindowTypeID.Carnival22Select) ~= nil or UIManager:GetWindow(UIWindowTypeID.Carnival22Task) ~= nil or UIManager:GetWindow(UIWindowTypeID.Carnival22StrategyOverview) ~= nil or UIManager:GetWindow(UIWindowTypeID.Carnival22MiniGame) ~= nil or UIManager:GetWindow(UIWindowTypeID.Carnival22Challenge) ~= nil then
      UIManager:HideWindow(UIWindowTypeID.MessageCommon)
      ;
      (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Carnival22Main, false)
    end
  end
  if BattleDungeonManager:InBattleDungeon() then
    local dunInterfaceType = (BattleDungeonManager.dunInterfaceData):GetInterfaceType()
    if dunInterfaceType == (DungeonLevelEnum.InterfaceType).Carnival then
      (NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)):CS_DUNGEON_Dync_Detail(function()
    -- function num : 0_5_0 , upvalues : _ENV
    local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
    if dungeonCtrl ~= nil and dungeonCtrl:DungeonIsInWaitFirstLoadScene() then
      dungeonCtrl:SetDungeonAfterEnterSceneExit()
    else
      BattleDungeonManager:RetreatDungeonNoReq()
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

      if (Time.unity_time).timeScale ~= 1 then
        (Time.unity_time).timeScale = 1
      end
    end
  end
)
    end
  end
end
, [(ActivityFrameEnum.eActivityType).WhiteDay] = function(activityFrameData)
  -- function num : 0_6 , upvalues : _ENV, SectorStageDetailHelper, ActivityFrameEnum
  local win = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
  if win ~= nil then
    (UIUtil.ReturnHome)()
  end
  if ExplorationManager:IsInExploration() then
    local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
    local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
    if stageCfg ~= nil then
      local stageActType, atageActId = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(stageCfg.sector)
      if stageActType == (ActivityFrameEnum.eActivityType).WhiteDay and atageActId == activityFrameData.actId then
        (PlayerDataCenter.sectorStage):SetSelectSectorId(nil)
        TimerManager:StartTimer(1, function()
    -- function num : 0_6_0 , upvalues : _ENV, activityFrameData
    local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
    explorationNetwork:CS_EXPLORATION_Detail(activityFrameData:GetActivityFrameId())
  end
, nil, true)
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).SectorIII] = function(activityFrameData)
  -- function num : 0_7 , upvalues : _ENV, SectorStageDetailHelper
  local actId = activityFrameData.actId
  local SectorIIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII, true)
  local sectorIIIdata = SectorIIICtrl:GetSectorIIIAct(actId)
  if sectorIIIdata == nil then
    return 
  end
  sectorIIIdata:RefreshSectorIIIMapReddot()
  sectorIIIdata:RefreshSectorIIITaskReddot()
  sectorIIIdata:UpdActSum22TechRedDot()
  local mapUI = UIManager:GetWindow(UIWindowTypeID.ActSum22Map)
  local repeatUI = UIManager:GetWindow(UIWindowTypeID.ActSum22DunRepeat)
  if mapUI ~= nil or repeatUI ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActSum22Main)
  end
  if ExplorationManager:IsInExploration() then
    local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
    local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
    do
      if stageCfg ~= nil then
        local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
        explorationNetwork:CS_EXPLORATION_Detail(activityFrameData:GetActivityFrameId())
      end
      MsgCenter:Broadcast(eMsgEventId.SectorActivityRunEnd, activityFrameData.actId)
    end
  end
end
, [(ActivityFrameEnum.eActivityType).Hallowmas] = function(activityFrameData)
  -- function num : 0_8 , upvalues : _ENV
  local actId = activityFrameData.actId
  local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
  if hallowmasCtrl == nil then
    return 
  end
  local data = hallowmasCtrl:GetHallowmasData(actId)
  if data == nil then
    return 
  end
  data:RefreshHallowmasRedDailyTask()
  data:RefreshHallowmasRedAchievement()
  data:RefreshHallowmasRedRedEnvTask()
  data:DealHallowmasWhenEnd()
  if WarChessSeasonManager:IsInWCS() then
    local seasonId = WarChessSeasonManager:GetWCSSeasonId()
    local actType, actId = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySeasonId(seasonId)
    if actType == activityFrameData:GetActivityFrameCat() and actId == activityFrameData:GetActId() then
      TimerManager:StartTimer(1, function()
    -- function num : 0_8_0 , upvalues : _ENV
    WarChessManager:ExitWarChess((Consts.SceneName).Sector, false, nil)
  end
, nil, true)
    end
  else
    do
      local uncomplete, seasonData = WarChessSeasonManager:GetUncompleteWCSData()
      do
        if uncomplete then
          local actType, actId = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySeasonId(seasonData.seasonId)
          if actType == activityFrameData:GetActivityFrameCat() and actId == activityFrameData:GetActId() then
            TimerManager:StartTimer(1, function()
    -- function num : 0_8_1 , upvalues : _ENV
    WarChessManager:SyncIsHaveUncompletedWarChess()
  end
, nil, true)
          end
        end
        if WarChessManager:GetIsInWarChess() then
          local sectorStage = WarChessManager:GetWCSectorStageCfg()
          local sectorId = sectorStage ~= nil and sectorStage.sector or 0
          local actType, actId = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(sectorId)
          if actType == activityFrameData:GetActivityFrameCat() and actId == activityFrameData:GetActId() then
            TimerManager:StartTimer(1, function()
    -- function num : 0_8_2 , upvalues : _ENV
    GuideManager:SkipGuide()
    WarChessManager:ExitWarChess((Consts.SceneName).Sector, false, nil)
  end
, nil, true)
          end
        else
          do
            local uncomplete, stageId = WarChessManager:GetIsHaveUncompletedWarChess()
            if uncomplete then
              local sectorStageCfg = (ConfigData.sector_stage)[stageId]
              local sectorId = sectorStage ~= nil and sectorStage.sectorId or 0
              local actType, actId = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(sectorId)
              if actType == activityFrameData:GetActivityFrameCat() and actId == activityFrameData:GetActId() then
                TimerManager:StartTimer(1, function()
    -- function num : 0_8_3 , upvalues : _ENV
    WarChessManager:SyncIsHaveUncompletedWarChess()
  end
, nil, true)
              end
            end
            do
              MsgCenter:Broadcast(eMsgEventId.SectorActivityRunEnd, activityFrameData.actId)
            end
          end
        end
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).Spring] = function(activityFrameData)
  -- function num : 0_9 , upvalues : _ENV, SectorStageDetailHelper
  local actId = activityFrameData.actId
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return 
  end
  local unCompleteActTable = nil
  local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
  if stageCfg ~= nil then
    unCompleteActTable = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(stageCfg.sector)
  end
  if unCompleteActTable ~= nil and actTable.actId == actId then
    TimerManager:StartTimer(1, function()
    -- function num : 0_9_0 , upvalues : _ENV, activityFrameData
    local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
    explorationNetwork:CS_EXPLORATION_Detail(activityFrameData:GetActivityFrameId())
  end
, nil, true)
  end
  local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
  ;
  (ActLbUtil.ActLbActivityRunningTimeout)(activityFrameData:GetActivityFrameId())
  MsgCenter:Broadcast(eMsgEventId.SectorActivityRunEnd, activityFrameData.actId)
end
, [(ActivityFrameEnum.eActivityType).Winter23] = function(activityFrameData)
  -- function num : 0_10 , upvalues : _ENV
  local actId = activityFrameData.actId
  local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if winter23Ctrl == nil then
    return 
  end
  local data = winter23Ctrl:GetWinter23DataByActId(actId)
  data:RefreshRedWinter23Tech()
  local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
  ;
  (ActLbUtil.ActLbActivityRunningTimeout)(activityFrameData:GetActivityFrameId())
  MsgCenter:Broadcast(eMsgEventId.SectorActivityRunEnd, activityFrameData.actId)
end
}
return ActivityFrameRunningEndFunc

