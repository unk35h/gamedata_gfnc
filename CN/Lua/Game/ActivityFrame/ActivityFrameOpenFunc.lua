-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local HomeEnum = require("Game.Home.HomeEnum")
local __isSendingSingle = false
local __singleQueue = {}
local SendSingle = function(callback)
  -- function num : 0_0 , upvalues : __isSendingSingle, _ENV, __singleQueue
  if __isSendingSingle then
    (table.insert)(__singleQueue, callback)
    return 
  else
    __isSendingSingle = true
    if callback ~= nil then
      callback()
    end
  end
end

local SendSingleOver = function()
  -- function num : 0_1 , upvalues : __isSendingSingle, __singleQueue, _ENV
  __isSendingSingle = false
  if #__singleQueue > 0 then
    local callback = __singleQueue[1]
    ;
    (table.remove)(__singleQueue, 1)
    callback()
  end
end

local ActivityFrameOpenFunc = {[(ActivityFrameEnum.eActivityType).StarUp] = function(activityFrameData)
  -- function num : 0_2 , upvalues : _ENV
  local activityId = activityFrameData:GetActId()
  local data = ((PlayerDataCenter.activityStarUpData).dataDic)[activityId]
  if data ~= nil then
    data:UpdateStarUpRedddot()
  end
end
, [(ActivityFrameEnum.eActivityType).BattlePass] = function(activityFrameData)
  -- function num : 0_3 , upvalues : _ENV
  local activityId = activityFrameData:GetActId()
  if ((PlayerDataCenter.battlepassData).passInfos)[activityId] ~= nil then
    return 
  end
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.BattlePass)):CS_BATTLEPASS_Detail()
end
, [(ActivityFrameEnum.eActivityType).SevenDayLogin] = function(activityFrameData)
  -- function num : 0_4 , upvalues : _ENV
  local activityId = activityFrameData:GetActId()
  if ((PlayerDataCenter.eventNoviceSignData).dataDic)[activityId] ~= nil then
    return 
  end
  local defaultData = {id = activityId, times = 0, nextExpiredTm = 0}
  ;
  (PlayerDataCenter.eventNoviceSignData):UpdateNoviceSignData(defaultData)
  local HomeEnum = require("Game.Home.HomeEnum")
  local HomeController = ControllerManager:GetController(ControllerTypeId.HomeController)
  if HomeController ~= nil and HomeController.homeState == (HomeEnum.eHomeState).Normal then
    HomeController:AddAutoShowGuide((HomeEnum.eAutoShwoCommand).NoviceSign)
  end
end
, [(ActivityFrameEnum.eActivityType).HeroBackOff] = function(activityFrameData)
  -- function num : 0_5 , upvalues : _ENV
  (NetworkManager:GetNetwork(NetworkTypeID.Hero)):CS_HEROREVERT_Detail()
end
, [(ActivityFrameEnum.eActivityType).HeroGrow] = function(activityFrameData)
  -- function num : 0_6 , upvalues : _ENV, SendSingle, SendSingleOver
  TimerManager:StartTimer(1, function()
    -- function num : 0_6_0 , upvalues : SendSingle, _ENV, activityFrameData, SendSingleOver
    SendSingle(function()
      -- function num : 0_6_0_0 , upvalues : _ENV, activityFrameData, SendSingleOver
      (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
        -- function num : 0_6_0_0_0 , upvalues : _ENV, activityFrameData, SendSingleOver
        if args.Count == 0 then
          error("args.Count == 0")
          return 
        end
        local msg = args[0]
        if msg.activtySectorHero ~= nil then
          local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow, true)
          heroGrowCtrl:UpdateHeroGrowSingle(msg.activtySectorHero)
        else
          do
            if isGameDev then
              error(" hero activity is nil frameId:" .. tostring(activityFrameData:GetActivityFrameId()))
            end
            SendSingleOver()
          end
        end
      end
)
    end
)
  end
, nil, true)
end
, [(ActivityFrameEnum.eActivityType).SectorII] = function(activityFrameData)
  -- function num : 0_7 , upvalues : _ENV, SendSingle, SendSingleOver
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII, true)
  local actId = activityFrameData.actId
  sectorIICtrl:OnSectorIIActivityOpen(actId)
  TimerManager:StartTimer(2, function()
    -- function num : 0_7_0 , upvalues : SendSingle, _ENV, activityFrameData, sectorIICtrl, SendSingleOver
    SendSingle(function()
      -- function num : 0_7_0_0 , upvalues : _ENV, activityFrameData, sectorIICtrl, SendSingleOver
      (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
        -- function num : 0_7_0_0_0 , upvalues : _ENV, sectorIICtrl, SendSingleOver
        if args.Count == 0 then
          error("args.Count == 0")
          return 
        end
        local msg = args[0]
        sectorIICtrl:UpdataSectorIIActivityBySingleMsg(msg.activitySectorIIData)
        SendSingleOver()
      end
)
    end
)
  end
, nil, true)
end
, [(ActivityFrameEnum.eActivityType).WhiteDay] = function(activityFrameData)
  -- function num : 0_8 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay, true)
  whiteDayCtrl:OnWhiteDayActivityOpen(actId)
  SendSingle(function()
    -- function num : 0_8_0 , upvalues : _ENV, activityFrameData, whiteDayCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_8_0_0 , upvalues : _ENV, whiteDayCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      whiteDayCtrl:UpdataSingleWhiteDayActivity(msg.activityValentine)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Comeback] = function(activityFrameData)
  -- function num : 0_9 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback, true)
  SendSingle(function()
    -- function num : 0_9_0 , upvalues : _ENV, activityFrameData, comebackCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_9_0_0 , upvalues : _ENV, comebackCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      comebackCtrl:AddComebackActivity(msg.activityUserReturn)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Task] = function(activityFrameData)
  -- function num : 0_10 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local actTaskCtrl = ControllerManager:GetController(ControllerTypeId.ActivityTask, true)
  SendSingle(function()
    -- function num : 0_10_0 , upvalues : _ENV, activityFrameData, actTaskCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_10_0_0 , upvalues : _ENV, actTaskCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      actTaskCtrl:AddActivityTask(msg.activityQuest)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Round] = function(activityFrameData)
  -- function num : 0_11 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local actRoundCtrl = ControllerManager:GetController(ControllerTypeId.ActivityRound, true)
  SendSingle(function()
    -- function num : 0_11_0 , upvalues : _ENV, activityFrameData, actRoundCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_11_0_0 , upvalues : _ENV, actRoundCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      actRoundCtrl:AddActivityRound(msg.activityRound)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).RefreshDun] = function(activityFrameData)
  -- function num : 0_12 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local refreshDunCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon, true)
  refreshDunCtrl:OnRefreshDunActivityOpen(actId)
  SendSingle(function()
    -- function num : 0_12_0 , upvalues : _ENV, activityFrameData, refreshDunCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_12_0_0 , upvalues : _ENV, refreshDunCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      refreshDunCtrl:UpdataSingleRefreshDunActivity(msg.activityRefreshDungeon)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Carnival] = function(activityFrameData)
  -- function num : 0_13 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local carnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival, true)
  SendSingle(function()
    -- function num : 0_13_0 , upvalues : _ENV, activityFrameData, carnivalCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_13_0_0 , upvalues : _ENV, carnivalCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      carnivalCtrl:AddCarnivalAct(msg.activityCarnival)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).HistoryTinyGame] = function(activityFrameData)
  -- function num : 0_14 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local historyTinyGameCtrl = ControllerManager:GetController(ControllerTypeId.HistoryTinyGameActivity, true)
  historyTinyGameCtrl:OnActivityOpen(actId)
  SendSingle(function()
    -- function num : 0_14_0 , upvalues : _ENV, activityFrameData, historyTinyGameCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_14_0_0 , upvalues : _ENV, historyTinyGameCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      historyTinyGameCtrl:AddCarnivalAct(msg.activityTinyGame)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).DailyChallenge] = function(activityFrameData)
  -- function num : 0_15 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local adcCtrl = ControllerManager:GetController(ControllerTypeId.ActivityDailyChallenge, true)
  SendSingle(function()
    -- function num : 0_15_0 , upvalues : _ENV, activityFrameData, adcCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_15_0_0 , upvalues : _ENV, adcCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      adcCtrl:AddADC(msg.activityDailyChallenge)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).SectorIII] = function(activityFrameData)
  -- function num : 0_16 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local sectorIIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII, true)
  SendSingle(function()
    -- function num : 0_16_0 , upvalues : _ENV, activityFrameData, sectorIIICtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_16_0_0 , upvalues : _ENV, sectorIIICtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      sectorIIICtrl:UpdateSectorIIIAct(msg.activitySummer2022)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).SignInMiniGame] = function(activityFrameData)
  -- function num : 0_17 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local signMiniGameCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame, true)
  SendSingle(function()
    -- function num : 0_17_0 , upvalues : _ENV, activityFrameData, signMiniGameCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_17_0_0 , upvalues : _ENV, signMiniGameCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      signMiniGameCtrl:InitNetWrorkData(msg.activityAnnivSign)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Hallowmas] = function(activityFrameData)
  -- function num : 0_18 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas, true)
  SendSingle(function()
    -- function num : 0_18_0 , upvalues : _ENV, activityFrameData, hallowmasCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_18_0_0 , upvalues : _ENV, hallowmasCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      hallowmasCtrl:AddHallowmas(msg.activityHalloween)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Spring] = function(activityFrameData)
  -- function num : 0_19 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring, true)
  SendSingle(function()
    -- function num : 0_19_0 , upvalues : _ENV, activityFrameData, springCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_19_0_0 , upvalues : _ENV, springCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      springCtrl:AddSpring(msg.activitySpring)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Winter23] = function(activityFrameData)
  -- function num : 0_20 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)
  SendSingle(function()
    -- function num : 0_20_0 , upvalues : _ENV, activityFrameData, winter23Ctrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_20_0_0 , upvalues : _ENV, winter23Ctrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      winter23Ctrl:AddWinter23(msg.activityWinter23)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Invitation] = function(activityFrameData)
  -- function num : 0_21 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local invitationCtrl = ControllerManager:GetController(ControllerTypeId.ActivityInvitation, true)
  SendSingle(function()
    -- function num : 0_21_0 , upvalues : _ENV, activityFrameData, invitationCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_21_0_0 , upvalues : _ENV, invitationCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      invitationCtrl:AddInvitation(msg.activityInvitation)
      SendSingleOver()
    end
)
  end
)
end
, [(ActivityFrameEnum.eActivityType).Season] = function(activityFrameData)
  -- function num : 0_22 , upvalues : _ENV, SendSingle, SendSingleOver
  local actId = activityFrameData.actId
  local activitySeasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason, true)
  SendSingle(function()
    -- function num : 0_22_0 , upvalues : _ENV, activityFrameData, activitySeasonCtrl, SendSingleOver
    (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(activityFrameData:GetActivityFrameId(), function(args)
      -- function num : 0_22_0_0 , upvalues : _ENV, activitySeasonCtrl, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local msg = args[0]
      activitySeasonCtrl:InitSeasons(msg.activitySeason)
      SendSingleOver()
    end
)
  end
)
end
}
return ActivityFrameOpenFunc

