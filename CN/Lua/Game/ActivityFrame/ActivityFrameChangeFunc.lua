-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local HomeEnum = require("Game.Home.HomeEnum")
local TaskEnum = require("Game.Task.TaskEnum")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivityTaskChangeFunc = function(activityFrameData, eTaskType, taskList)
  -- function num : 0_0 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  local taskCtrl = ControllerManager:GetController(ControllerTypeId.Task, true)
  if isOpen then
    taskCtrl:AddTimeLimitTask(eTaskType, taskList, activityFrameData:GetActivityRewardEndTime())
    return 
  end
  for _,taskId in pairs(taskList) do
    local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
    if taskData ~= nil then
      (PlayerDataCenter.allTaskData):RemoveTaskData(taskData)
    end
  end
  taskCtrl:ReomveTimeLimitTask(eTaskType, taskList)
  local ok, TaskWindowNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Task)
  do
    if ok then
      local taskPageNode = TaskWindowNode:RemoveChild(eTaskType)
    end
    local win = UIManager:GetWindow(UIWindowTypeID.Task)
    if win ~= nil then
      win:RefreshPages()
    end
    local navigationWin = UIManager:GetWindow(UIWindowTypeID.NavigationBar)
    if navigationWin ~= nil then
      navigationWin:UpdateNaviTaskQucikPreview()
    end
    local window = UIManager:GetWindow(UIWindowTypeID.Home)
    if window ~= nil then
      (window.homeLeftNode):RefreshTaskBtn()
    end
  end
end

local ActivityFrameChangeFunc = {[(ActivityFrameEnum.eActivityType).Lotter] = function(activityFrameData)
  -- function num : 0_1 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    (PlayerDataCenter.allLtrData):OpenLtrPoolData(activityFrameData)
    return 
  end
  ;
  (PlayerDataCenter.allLtrData):CloseLtrPoolData(activityFrameData)
end
, [(ActivityFrameEnum.eActivityType).Tickets] = function(activityFrameData)
  -- function num : 0_2 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    return 
  end
  if UIManager:GetWindow(UIWindowTypeID.EventWeChat) ~= nil then
    (UIUtil.ReturnHome)()
  end
end
, [(ActivityFrameEnum.eActivityType).DungeonDouble] = function(activityFrameData)
  -- function num : 0_3 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  local doubleActivityCfg = (ConfigData.activity_double)[actId]
  if doubleActivityCfg == nil then
    error("can\'t find doubleActivityCfg with actId:" .. tostring(actId))
    return 
  end
  for index,logic in ipairs(doubleActivityCfg.logic) do
    if isOpen then
      local para1 = (doubleActivityCfg.para1)[index]
      local para2 = (doubleActivityCfg.para2)[index]
      local para3 = (doubleActivityCfg.para3)[index]
      ;
      (PlayerDataCenter.playerBonus):InstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_Double_Active, actId, logic, para1, para2, para3)
    else
      do
        do
          ;
          (PlayerDataCenter.playerBonus):UninstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_Double_Active, actId, logic)
          do break end
          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  MsgCenter:Broadcast(eMsgEventId.OnBattleDungeonLimitChange)
end
, [(ActivityFrameEnum.eActivityType).SectorI] = function(activityFrameData)
  -- function num : 0_4 , upvalues : _ENV, ActivityTaskChangeFunc, TaskEnum, SectorStageDetailHelper
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivitySectorI)
  local taskList = ((ConfigData.activity_time_limit)[actId]).task_list
  ActivityTaskChangeFunc(activityFrameData, (TaskEnum.eTaskType).LargeActivityTask, taskList)
  if isOpen then
    network:CS_ACTIVITYSECTORI_Detail(function()
    -- function num : 0_4_0 , upvalues : _ENV
    MsgCenter:Broadcast(eMsgEventId.SectorActivityChange)
    local HomeEnum = require("Game.Home.HomeEnum")
    local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_LargeActivity)
    local HomeController = ControllerManager:GetController(ControllerTypeId.HomeController)
    if isUnlock and HomeController ~= nil and HomeController.homeState == (HomeEnum.eHomeState).Normal then
      HomeController:AddAutoShowGuide((HomeEnum.eAutoShwoCommand).SectorActivity)
    end
  end
)
    return 
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.ActSummer) then
    UIManager:HideWindow(UIWindowTypeID.MessageCommon)
    ;
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActSummer, true)
  end
  local actCfg = (ConfigData.activity_time_limit)[actId]
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:CreateStcEntity(actCfg.hard_stage)
  end
  TimerManager:StartTimer(1, function()
    -- function num : 0_4_1 , upvalues : network, _ENV, actId, actCfg, SectorStageDetailHelper
    network:CS_ACTIVITYSECTORI_Detail(function()
      -- function num : 0_4_1_0 , upvalues : _ENV, actId, actCfg, SectorStageDetailHelper
      if ExplorationManager:IsInExploration() then
        local stageCfg = ExplorationManager:GetSectorStageCfg()
        if stageCfg ~= nil then
          local sectorIActId = ((ConfigData.activity_time_limit).sectorMapping)[stageCfg.sector]
          if sectorIActId == actId and actCfg.hard_stage ~= stageCfg.sector then
            ExplorationManager:ForceExitEp()
          end
        end
      else
        do
          local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
          local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
          if stageCfg ~= nil then
            local sectorIActId = ((ConfigData.activity_time_limit).sectorMapping)[stageCfg.sector]
            if sectorIActId == actId and actCfg.hard_stage ~= stageCfg.sector then
              local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
              explorationNetwork:CS_EXPLORATION_Detail()
            end
          end
          do
            MsgCenter:Broadcast(eMsgEventId.SectorActivityChange)
          end
        end
      end
    end
)
  end
, nil, true)
end
, [(ActivityFrameEnum.eActivityType).HeroGrow] = function(activityFrameData)
  -- function num : 0_5 , upvalues : _ENV, ActivityTaskChangeFunc, TaskEnum, SectorStageDetailHelper
  local activityHeroCfg = (ConfigData.activity_hero)[activityFrameData.actId]
  if activityHeroCfg == nil then
    error("HeroGrowCfg Miss  id is " .. tostring(activityFrameData.actId))
  else
    local taskList = ((ConfigData.activity_hero)[activityFrameData.actId]).task_list
    if #taskList > 0 then
      ActivityTaskChangeFunc(activityFrameData, (TaskEnum.eTaskType).HeroActivityTask, taskList)
    end
  end
  do
    local isOpen = activityFrameData:IsActivityOpen()
    if isOpen then
      return 
    end
    if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.CharacterDungeon) then
      UIManager:HideWindow(UIWindowTypeID.MessageCommon)
      ;
      (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.CharacterDungeon, true)
    end
    if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.CharDunVer2) then
      UIManager:HideWindow(UIWindowTypeID.MessageCommon)
      ;
      (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.CharDunVer2, true)
    end
    local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
    if heroGrowCtrl == nil then
      return 
    end
    if ExplorationManager:IsInExploration() then
      local stageCfg = ExplorationManager:GetSectorStageCfg()
      if stageCfg ~= nil then
        local actId, isChallenge, canFight = heroGrowCtrl:IsHeroGrowChallengeSector(stageCfg.sector)
        if actId ~= nil and not canFight then
          ExplorationManager:ForceExitEp()
        end
      end
    else
      do
        local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
        local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
        do
          if stageCfg ~= nil then
            local actId, isChallenge, canFight = heroGrowCtrl:IsHeroGrowChallengeSector(stageCfg.sector)
            if actId ~= nil and not canFight then
              TimerManager:StartTimer(1, function()
    -- function num : 0_5_0 , upvalues : _ENV
    local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
    explorationNetwork:CS_EXPLORATION_Detail()
  end
, nil, true)
            end
          end
          if WarChessManager:GetIsInWarChess() then
            local stageCfg = WarChessManager:GetWCSectorStageCfg()
            if stageCfg ~= nil then
              local actId, isChallenge, canFight = heroGrowCtrl:IsHeroGrowChallengeSector(stageCfg.sector)
              if actId ~= nil and not canFight then
                WarChessManager:ForceExitWarchess()
              end
            end
          else
            do
              local hasUnComplete, stageId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Warchess)
              local stageCfg = hasUnComplete and (ConfigData.sector_stage)[stageId] or nil
              do
                if stageCfg ~= nil then
                  local actId, isChallenge, canFight = heroGrowCtrl:IsHeroGrowChallengeSector(stageCfg.sector)
                  if actId ~= nil and not canFight then
                    TimerManager:StartTimer(1, function()
    -- function num : 0_5_1 , upvalues : _ENV
    WarChessManager:SyncIsHaveUncompletedWarChess()
  end
, nil, true)
                  end
                end
                heroGrowCtrl:RemoveHeroGrow(activityFrameData.actId)
              end
            end
          end
        end
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).SectorII] = function(activityFrameData)
  -- function num : 0_6 , upvalues : _ENV, DungeonLevelEnum, ActivityTaskChangeFunc, TaskEnum
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  local taskList = nil
  if isOpen then
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII, true)
    sectorIICtrl:OnSectorIIActivityOpen(actId)
    local sectorIIdata = sectorIICtrl:GetSectorIIDataByActId(actId)
    taskList = sectorIIdata:GetSectorIIActivityTaskList()
    activityFrameData:SetActivityData(sectorIIdata)
  else
    do
      local SectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
      local sectorIIdata = SectorIICtrl:GetSectorIIDataByActId(actId)
      local AWMainMapWin = UIManager:GetWindow(UIWindowTypeID.ActivityWinterMainMap)
      if AWMainMapWin ~= nil then
        (UIUtil.ReturnHome)()
      end
      do
        do
          if BattleDungeonManager:InBattleDungeon() then
            local dunInterfaceType = (BattleDungeonManager.dunInterfaceData):GetInterfaceType()
            if dunInterfaceType == (DungeonLevelEnum.InterfaceType).SectorIIDungeon or dunInterfaceType == (DungeonLevelEnum.InterfaceType).WinterChallenge then
              (NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)):CS_DUNGEON_Dync_Detail(function()
    -- function num : 0_6_0 , upvalues : _ENV
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
          taskList = sectorIIdata:GetSectorIIActivityTaskList()
          SectorIICtrl:OnSectorIIActivityClose(actId)
          activityFrameData:SetActivityData(nil)
          ActivityTaskChangeFunc(activityFrameData, (TaskEnum.eTaskType).LargeActivityTask, taskList)
        end
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).WhiteDay] = function(activityFrameData)
  -- function num : 0_7 , upvalues : _ENV, SectorStageDetailHelper
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  if isOpen then
    local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay, true)
    whiteDayCtrl:OnWhiteDayActivityOpen(actId)
    local whiteDayData = whiteDayCtrl:GetWhiteDayDataByActId(actId)
    activityFrameData:SetActivityData(whiteDayData)
  else
    do
      local win = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
      if win ~= nil then
        (UIUtil.ReturnHome)()
      else
        win = UIManager:GetWindow(UIWindowTypeID.WhiteDayAlbum)
        if win ~= nil then
          (UIUtil.ReturnHome)()
        end
      end
      local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
      if ExplorationManager:IsInExploration() then
        local stageCfg = ExplorationManager:GetSectorStageCfg()
        if stageCfg ~= nil then
          local isWDSector = whiteDayCtrl:IsWDSector(stageCfg.sector)
          if isWDSector then
            (PlayerDataCenter.sectorStage):SetSelectSectorId(nil)
            ExplorationManager:ForceExitEp()
          end
        end
      else
        do
          local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
          local stageCfg = hasHasUncompletedEp and (ConfigData.sector_stage)[stageId] or nil
          do
            if stageCfg ~= nil then
              local isWDSector = whiteDayCtrl:IsWDSector(stageCfg.sector)
              if isWDSector then
                (PlayerDataCenter.sectorStage):SetSelectSectorId(nil)
                TimerManager:StartTimer(1, function()
    -- function num : 0_7_0 , upvalues : _ENV
    local explorationNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
    explorationNetwork:CS_EXPLORATION_Detail()
  end
, nil, true)
              end
            end
            whiteDayCtrl:OnWhiteDayActivityClose(actId)
          end
        end
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).Comeback] = function(activityFrameData)
  -- function num : 0_8 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    return 
  end
  local actId = activityFrameData.actId
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback)
  if comebackCtrl == nil then
    return 
  end
  comebackCtrl:RemoveComebackActivity(actId)
  if not comebackCtrl:HasActivityComeback() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityComeback)
  end
end
, [(ActivityFrameEnum.eActivityType).Task] = function(activityFrameData)
  -- function num : 0_9 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    return 
  end
  local actId = activityFrameData.actId
  local actTaskCtrl = ControllerManager:GetController(ControllerTypeId.ActivityTask)
  if actTaskCtrl == nil then
    return 
  end
  actTaskCtrl:RemoveActivityTask(actId)
  if not actTaskCtrl:HasActivityTask() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityTask)
  end
end
, [(ActivityFrameEnum.eActivityType).Round] = function(activityFrameData)
  -- function num : 0_10 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    return 
  end
  local actId = activityFrameData.actId
  local actRoundCtrl = ControllerManager:GetController(ControllerTypeId.ActivityRound)
  if actRoundCtrl == nil then
    return 
  end
  actRoundCtrl:RemoveActivityRound(actId)
  if not actRoundCtrl:HasActivityRound() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityRound)
  end
end
, [(ActivityFrameEnum.eActivityType).RefreshDun] = function(activityFrameData)
  -- function num : 0_11 , upvalues : _ENV, ActivityTaskChangeFunc, TaskEnum
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  local taskList = nil
  if isOpen then
    local refreshDunCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon, true)
    refreshDunCtrl:OnRefreshDunActivityOpen(actId)
    local ARDData = refreshDunCtrl:GetRefreshDunDataByActId(actId)
    activityFrameData:SetActivityData(ARDData)
    taskList = ARDData:GetARDDTaskList()
  else
    do
      local win = UIManager:GetWindow(UIWindowTypeID.AprilFool)
      if win ~= nil then
        (UIUtil.ReturnHome)()
      end
      local refreshDunCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
      do
        local ARDData = refreshDunCtrl:GetRefreshDunDataByActId(actId)
        taskList = ARDData:GetARDDTaskList()
        refreshDunCtrl:OnRefreshDunActivityClose(actId)
        if taskList ~= nil then
          ActivityTaskChangeFunc(activityFrameData, (TaskEnum.eTaskType).LargeActivityTask, taskList)
        end
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).Carnival] = function(activityFrameData)
  -- function num : 0_12 , upvalues : _ENV, DungeonLevelEnum
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  if isOpen then
    return 
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.Carnival22Main) then
    UIManager:HideWindow(UIWindowTypeID.MessageCommon)
    ;
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Carnival22Main, true)
  end
  do
    if BattleDungeonManager:InBattleDungeon() then
      local dunInterfaceType = (BattleDungeonManager.dunInterfaceData):GetInterfaceType()
      if dunInterfaceType == (DungeonLevelEnum.InterfaceType).Carnival then
        (NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)):CS_DUNGEON_Dync_Detail(function()
    -- function num : 0_12_0 , upvalues : _ENV
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
    local carnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
    if carnivalCtrl == nil then
      return 
    end
    carnivalCtrl:RemoveCarnivalAct(actId)
    if not carnivalCtrl:IsHaveCarnivalAct() then
      ControllerManager:DeleteController(ControllerTypeId.ActivityCarnival)
    end
  end
end
, [(ActivityFrameEnum.eActivityType).HistoryTinyGame] = function(activityFrameData)
  -- function num : 0_13 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  if isOpen then
    return 
  end
  local historyTinyGameCtrl = ControllerManager:GetController(ControllerTypeId.HistoryTinyGameActivity)
  if historyTinyGameCtrl == nil then
    return 
  end
  historyTinyGameCtrl:OnActivityClose(actId)
  local win = UIManager:GetWindow(UIWindowTypeID.ActivityMiniGameMain)
  if win ~= nil then
    (UIUtil.ReturnHome)()
  end
end
, [(ActivityFrameEnum.eActivityType).DailyChallenge] = function(activityFrameData)
  -- function num : 0_14 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  if isOpen then
    return 
  end
  local adcCtrl = ControllerManager:GetController(ControllerTypeId.ActivityDailyChallenge)
  if adcCtrl == nil then
    return 
  end
  adcCtrl:RemoveADC(actId)
  if not adcCtrl:HasLiveADC() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityDailyChallenge)
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.EventDaliyChallenge) then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.EventDaliyChallenge, true)
  end
end
, [(ActivityFrameEnum.eActivityType).ActvtLimitTask] = function(activityFrameData)
  -- function num : 0_15 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    (ControllerManager:GetController(ControllerTypeId.ActivityTaskLimit, true)):InitActLimitTaskCtrl(activityFrameData)
    return 
  end
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityTaskLimit)
  if ctrl == nil then
    return 
  end
  ctrl:CloseActLimitTaskCtrl(activityFrameData)
end
, [(ActivityFrameEnum.eActivityType).SignInMiniGame] = function(activityFrameData)
  -- function num : 0_16 , upvalues : _ENV
  if activityFrameData:IsActivityOpen() then
    (ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame, true)):InitCtrl(activityFrameData)
    return 
  end
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame)
  if ctrl == nil then
    return 
  end
  ctrl:CloseActLimitTaskCtrl(activityFrameData)
end
, [(ActivityFrameEnum.eActivityType).SectorIII] = function(activityFrameData)
  -- function num : 0_17 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  local actId = activityFrameData.actId
  if isOpen then
    return 
  end
  local sectorIIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII)
  if sectorIIICtrl == nil then
    return 
  end
  sectorIIICtrl:RemoveSectorIIIData(actId)
  if not sectorIIICtrl:IsHaveSectorIIIAct() then
    ControllerManager:DeleteController(ControllerTypeId.ActivitySectorIII)
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.ActSum22Main) then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActSum22Main, true)
  end
end
, [(ActivityFrameEnum.eActivityType).Hallowmas] = function(activityFrameData)
  -- function num : 0_18 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    return 
  end
  local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
  if hallowmasCtrl == nil then
    return 
  end
  local actId = activityFrameData.actId
  hallowmasCtrl:RemoveHallowmas(actId)
  if not hallowmasCtrl:IsHaveHallowmas() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityHallowmas)
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.Halloween22Main) then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Halloween22Main, true)
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.Christmas22Main) then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Christmas22Main, true)
  end
end
, [(ActivityFrameEnum.eActivityType).KeyExertion] = function(activityFrameData)
  -- function num : 0_19 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    (ControllerManager:GetController(ControllerTypeId.ActivityKeyExertion, true)):InitKeyExertion(activityFrameData)
    return 
  end
  local keyExertionCtrl = ControllerManager:GetController(ControllerTypeId.ActivityKeyExertion)
  if keyExertionCtrl == nil then
    return 
  end
  local actId = activityFrameData.actId
  keyExertionCtrl:RemoveKeyExertion(actId)
  if not keyExertionCtrl:IsHaveKeyExertion() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityKeyExertion)
  end
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.ActivityKeyExertion) then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActivityKeyExertion, true)
  end
end
, [(ActivityFrameEnum.eActivityType).Spring] = function(activityFrameData)
  -- function num : 0_20 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    return 
  end
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return 
  end
  local actId = activityFrameData.actId
  springCtrl:RemoveSpring(actId)
  if not springCtrl:IsHaveSpring() then
    ControllerManager:DeleteController(ControllerTypeId.ActivitySpring)
  end
  local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
  ;
  (ActLbUtil.ActLbActivityFinish)(activityFrameData:GetActivityFrameId())
end
, [(ActivityFrameEnum.eActivityType).Winter23] = function(activityFrameData)
  -- function num : 0_21 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    return 
  end
  local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if winter23Ctrl == nil then
    return 
  end
  local actId = activityFrameData.actId
  winter23Ctrl:RemoveWinter23(actId)
  if not winter23Ctrl:IsHaveWinter23() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityWinter23)
  end
  local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
  ;
  (ActLbUtil.ActLbActivityFinish)(activityFrameData:GetActivityFrameId())
end
, [(ActivityFrameEnum.eActivityType).Invitation] = function(activityFrameData)
  -- function num : 0_22 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    return 
  end
  local invitationCtrl = ControllerManager:GetController(ControllerTypeId.ActivityInvitation)
  if invitationCtrl == nil then
    return 
  end
  local actId = activityFrameData.actId
  invitationCtrl:RemoveInvitation(actId)
  if not invitationCtrl:IsHaveInvitation() then
    ControllerManager:DeleteController(ControllerTypeId.ActivityInvitation)
  end
end
, [(ActivityFrameEnum.eActivityType).EventWeeklyQA] = function(activityFrameData)
  -- function num : 0_23 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    local weeklyQACtrl = ControllerManager:GetController(ControllerTypeId.EventWeeklyQA, true)
    weeklyQACtrl:ReqWeeklyQAData(activityFrameData.id)
    return 
  end
end
, [(ActivityFrameEnum.eActivityType).EventAngelaGift] = function(activityFrameData)
  -- function num : 0_24 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  do
    if isOpen then
      local angelaGiftCtrl = ControllerManager:GetController(ControllerTypeId.EventAngelaGift, true)
      angelaGiftCtrl:InitAngelaGift(activityFrameData)
      return 
    end
    local angelaGiftCtrl = ControllerManager:GetController(ControllerTypeId.EventAngelaGift)
    if angelaGiftCtrl == nil then
      return 
    end
    ControllerManager:DeleteController(ControllerTypeId.EventAngelaGift)
  end
end
, [(ActivityFrameEnum.eActivityType).Gift] = function(activityFrameData)
  -- function num : 0_25 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    do
      if ConfigData.activity_gift == nil then
        local eDynConfigData = require("Game.ConfigData.eDynConfigData")
        ConfigData:LoadDynCfg(eDynConfigData.activity_gift)
      end
      local reddot = activityFrameData:GetActivityReddotNode()
      local reddoutCount = 0
      local cfg = (ConfigData.activity_gift)[activityFrameData:GetActId()]
      local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
      for i,giftid in ipairs(cfg.giftlist) do
        local gift = payGiftCtrl:GetPayGiftDataById(giftid)
        if gift ~= nil and not gift:IsSoldOut() and gift:IsFreeGift() then
          reddoutCount = 1
          break
        end
      end
      do
        do
          reddot:SetRedDotCount(reddoutCount)
          local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
          do
            if not actCtrl:IsExistOpenActByActType() then
              local eDynConfigData = require("Game.ConfigData.eDynConfigData")
              ConfigData:ReleaseDynCfg(eDynConfigData.activity_gift)
            end
            if UIManager:GetWindow(UIWindowTypeID.EventOptionalGift) ~= nil then
              (UIUtil.ReturnHome)()
            end
          end
        end
      end
    end
  end
end
, [(ActivityFrameEnum.eActivityType).Season] = function(activityFrameData)
  -- function num : 0_26 , upvalues : _ENV
  local isOpen = activityFrameData:IsActivityOpen()
  if isOpen then
    return 
  end
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if seasonCtrl == nil then
    return 
  end
  local actId = activityFrameData.actId
  seasonCtrl:RemoveSeason(actId)
  if not seasonCtrl:IsHaveSeason() then
    ControllerManager:DeleteController(ControllerTypeId.ActivitySeason)
  end
  local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
  ;
  (ActLbUtil.ActLbActivityFinish)(activityFrameData:GetActivityFrameId())
end
}
return ActivityFrameChangeFunc

