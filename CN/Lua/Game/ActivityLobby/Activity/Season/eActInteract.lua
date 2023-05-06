-- params : ...
-- function num : 0 , upvalues : _ENV
local eActInteract = {}
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local ActivitySeasonEnum = require("Game.ActivitySeason.ActivitySeasonEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local cs_MessageCommon = CS.MessageCommon
eActInteract.__GetActData = function()
  -- function num : 0_0 , upvalues : _ENV
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if not seasonCtrl then
    return 
  end
  return seasonCtrl:GetSeasonData()
end

eActInteract.eMissonBtn = {Task = 1}
local MissonBtnOpenFunc = {[(eActInteract.eMissonBtn).Task] = function()
  -- function num : 0_1 , upvalues : eActInteract, _ENV, ActLbUtil
  local seasonData = (eActInteract.__GetActData)()
  local dailyTaskData = seasonData:GetSeasonDailyTaskData()
  local termTaskData = seasonData:GetSeasonTermTaskData()
  if dailyTaskData == nil then
    if isGameDev then
      warn(" daily task not open ")
    end
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Winter23Task, function(win)
    -- function num : 0_1_0 , upvalues : ActLbUtil, seasonData, dailyTaskData, termTaskData
    if win == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    win:InitWinter23Task(seasonData:GetActFrameId(), dailyTaskData, termTaskData, function()
      -- function num : 0_1_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
}
local MissonBtnRedFunc = {[(eActInteract.eMissonBtn).Task] = function()
  -- function num : 0_2 , upvalues : eActInteract, ActivitySeasonEnum
  local seasonData = (eActInteract.__GetActData)()
  local reddot = seasonData:GetActivityReddot()
  if reddot == nil then
    return false
  end
  local childReddot = reddot:GetChild((ActivitySeasonEnum.reddotType).DailyTask)
  if childReddot ~= nil and childReddot:GetRedDotCount() > 0 then
    return true
  end
  childReddot = reddot:GetChild((ActivitySeasonEnum.reddotType).OnceTask)
  do return childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
eActInteract.eLbIntrctActionId = {Main = 1, Bonus = 2, Tech = 3, Repeat = 4, ChessGreenHand = 6, MainStory = 7}
eActInteract.eLbIntrctEntityId = {Main = 1, Bonus = 2, Tech = 3, Repeat = 7, ChessGreenHand = 6, MainStory = 4}
eActInteract.eIntrctFuncs = {[(eActInteract.eLbIntrctActionId).Main] = function(entity)
  -- function num : 0_3 , upvalues : _ENV, eActInteract, ActLbUtil
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if not seasonCtrl then
    return 
  end
  local seasonData = (eActInteract.__GetActData)()
  local wcsId = seasonData:GetSeasonId()
  local isUnComplete, unCompleteData = WarChessSeasonManager:GetUncompleteWCSData()
  if isUnComplete then
    if unCompleteData.seasonId == wcsId then
      seasonCtrl:ContinueSeason()
      return 
    end
    local tips = ConfigData:GetTipContent(8704)
    ;
    ((CS.MessageCommon).ShowMessageTips)(tips)
    return 
  end
  do
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    seasonCtrl:EnterCommonSeasonWarChessSeasonLevelSelect(function()
    -- function num : 0_3_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end
)
  end
end
, [(eActInteract.eLbIntrctActionId).Bonus] = function(entity)
  -- function num : 0_4 , upvalues : _ENV, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  if not unlock then
    return 
  end
  local seasonController = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if seasonController == nil then
    return 
  end
  local realReturnFunc = function()
    -- function num : 0_4_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end

  ;
  (ActLbUtil.OnActLbInteractEnter)(true)
  seasonController:ShowSeasonBonus(realReturnFunc)
end
, [(eActInteract.eLbIntrctActionId).Tech] = function(entity)
  -- function num : 0_5 , upvalues : eActInteract, _ENV, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  if not unlock then
    return 
  end
  local seasonData = (eActInteract.__GetActData)()
  local mainCfg = seasonData:GetSeasonMainCfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.Winter23StrategyOverview, function(window)
    -- function num : 0_5_0 , upvalues : ActLbUtil, seasonData, mainCfg
    if window == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    window:InitChristmas22StrategyOverview(seasonData:GetSeasonTechTree(), mainCfg.tech_special_branch, function()
      -- function num : 0_5_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
, [(eActInteract.eLbIntrctActionId).Repeat] = function()
  -- function num : 0_6 , upvalues : eActInteract, _ENV, ActLbUtil
  local seasonData = (eActInteract.__GetActData)()
  local actDungeonCollect = seasonData:GetSeasonDungeonCollect()
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonActivityRepeatDungeon, function(win)
    -- function num : 0_6_0 , upvalues : _ENV, ActLbUtil, actDungeonCollect
    if win == nil then
      if isGameDev then
        warn(" CommonActivityRepeatDungeon not open ")
      end
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    win:InitActivityRepeatDungeon(actDungeonCollect, function()
      -- function num : 0_6_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
    local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
    if aftertTeatmentCtrl ~= nil then
      aftertTeatmentCtrl:TeatmentBengin()
    end
  end
)
end
, [5] = function()
  -- function num : 0_7
end
, [(eActInteract.eLbIntrctActionId).ChessGreenHand] = function()
  -- function num : 0_8 , upvalues : _ENV, eActInteract, SectorStageDetailHelper, ActLbUtil
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if not seasonCtrl then
    return 
  end
  local seasonData = (eActInteract.__GetActData)()
  local warChessGreenHandSectorId = seasonData:GetGreenHandSectorId()
  if not (SectorStageDetailHelper.IsSectorNoCollide)(warChessGreenHandSectorId, true) then
    return 
  end
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  do
    if isUnComplete then
      local tips = ConfigData:GetTipContent(8704)
      ;
      ((CS.MessageCommon).ShowMessageTips)(tips)
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    seasonCtrl:EnterGreenHandWarChessSeasonLevels(warChessGreenHandSectorId, function()
    -- function num : 0_8_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end
)
  end
end
, [(eActInteract.eLbIntrctActionId).MainStory] = function()
  -- function num : 0_9 , upvalues : eActInteract, ActLbUtil, SectorStageDetailHelper, _ENV
  local seasonData = (eActInteract.__GetActData)()
  local mainCfg = seasonData:GetSeasonMainCfg()
  local storySector = mainCfg.story_stage
  local realReturnFunc = function()
    -- function num : 0_9_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end

  if not (SectorStageDetailHelper.IsSectorNoCollide)(storySector, true) then
    return 
  end
  ;
  (ActLbUtil.OnActLbInteractEnter)(true)
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevel, function(window)
    -- function num : 0_9_1 , upvalues : storySector, realReturnFunc
    if window == nil then
      return 
    end
    window:InitSectorLevel(storySector, realReturnFunc, 1)
  end
)
end
}
eActInteract.eActIntrctActionUIInitFunc = {}
eActInteract.eSubNameFuncs = {}
eActInteract.eUnlockIntrctFunc = {[(eActInteract.eLbIntrctEntityId).Main] = function(lbIntrctData)
  -- function num : 0_10 , upvalues : eActInteract
  local seasonData = (eActInteract.__GetActData)()
  do return (seasonData ~= nil and seasonData:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).Tech] = function(lbIntrctData)
  -- function num : 0_11 , upvalues : eActInteract
  local seasonData = (eActInteract.__GetActData)()
  do return (seasonData ~= nil and seasonData:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).Bonus] = function(lbIntrctData)
  -- function num : 0_12
  return true
end
, [(eActInteract.eLbIntrctEntityId).Main] = function(lbIntrctData)
  -- function num : 0_13
  return true
end
, [(eActInteract.eLbIntrctEntityId).Repeat] = function(lbIntrctData)
  -- function num : 0_14 , upvalues : eActInteract
  local seasonData = (eActInteract.__GetActData)()
  do return (seasonData ~= nil and seasonData:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).MainStory] = function(lbIntrctData)
  -- function num : 0_15
  return true
end
}
eActInteract.eActIntrctActionLockStateDesFunc = {[(eActInteract.eLbIntrctEntityId).Main] = function(lbIntrctData)
  -- function num : 0_16 , upvalues : eActInteract, _ENV
  local seasonData = (eActInteract.__GetActData)()
  local playEndTime = seasonData:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctActionId).Tech] = function(entity)
  -- function num : 0_17 , upvalues : eActInteract, _ENV
  local seasonData = (eActInteract.__GetActData)()
  local playEndTime = seasonData:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctActionId).Bonus] = function(entity)
  -- function num : 0_18
end
, [(eActInteract.eLbIntrctActionId).Main] = function(entity)
  -- function num : 0_19
end
, [(eActInteract.eLbIntrctActionId).Repeat] = function(entity)
  -- function num : 0_20 , upvalues : eActInteract, _ENV
  local seasonData = (eActInteract.__GetActData)()
  local playEndTime = seasonData:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctActionId).MainStory] = function(entity)
  -- function num : 0_21
end
}
eActInteract.eActIntrctActionShowBlueDotFunc = {[(eActInteract.eLbIntrctActionId).Tech] = function(lbIntrctData)
  -- function num : 0_22 , upvalues : eActInteract, ActivitySeasonEnum
  local seasonData = (eActInteract.__GetActData)()
  local reddot = seasonData:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).Tech)
  do return childReddot ~= nil and childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctActionId).Bonus] = function(lbIntrctData)
  -- function num : 0_23 , upvalues : eActInteract, ActivitySeasonEnum
  local seasonData = (eActInteract.__GetActData)()
  local reddot = seasonData:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).Bonus)
  do return childReddot ~= nil and childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctActionId).Main] = function(lbIntrctData)
  -- function num : 0_24
end
, [(eActInteract.eLbIntrctActionId).MainStory] = function(lbIntrctData)
  -- function num : 0_25 , upvalues : eActInteract, ActivitySeasonEnum
  local seasonData = (eActInteract.__GetActData)()
  local reddot = seasonData:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivitySeasonEnum.reddotType).mainStory)
  do return childReddot ~= nil and childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
local UpdateActivityReddotChange = function()
  -- function num : 0_26 , upvalues : ActLbUtil, eActInteract, _ENV
  (ActLbUtil.UpdLbEntranceBlueDot)(eActInteract.eLbIntrctEntityId, eActInteract.eActIntrctActionShowBlueDotFunc)
  for k,v in pairs(eActInteract.eLbIntrctEntityId) do
    (ActLbUtil.UpdLbEnttBluedot)(v)
  end
  local missonUI = UIManager:GetWindow(UIWindowTypeID.Spring23Misson)
  if missonUI ~= nil then
    missonUI:RefreshMissonReddot()
  end
end

eActInteract.OnActLbSceneLoadedFunc = function(actLbCtrl)
  -- function num : 0_27 , upvalues : _ENV, MissonBtnOpenFunc, eActInteract, MissonBtnRedFunc, UpdateActivityReddotChange
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Misson, function(win)
    -- function num : 0_27_0 , upvalues : MissonBtnOpenFunc, eActInteract, MissonBtnRedFunc
    if win == nil then
      return 
    end
    win:SetTaskFunc(MissonBtnOpenFunc[(eActInteract.eMissonBtn).Task], MissonBtnRedFunc[(eActInteract.eMissonBtn).Task])
    win:RefreshMissonReddot()
  end
)
  local seasonData = (eActInteract.__GetActData)()
  local reddot = seasonData:GetActivityReddot()
  RedDotController:AddListener(reddot.nodePath, UpdateActivityReddotChange)
  UpdateActivityReddotChange()
end

eActInteract.OnActLbStartShowEndCoFunc = function(actLbCtrl)
  -- function num : 0_28 , upvalues : _ENV
  while UIManager:GetWindow(UIWindowTypeID.Spring23Misson) == nil do
    (coroutine.yield)(nil)
  end
  local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
  if not seasonCtrl then
    return 
  end
  seasonCtrl:RunEnterCompleteFunc()
end

eActInteract.OnActLbInteractEnterFunc = function(isEnter)
  -- function num : 0_29 , upvalues : _ENV, eActInteract
  if isEnter then
    UIManager:HideWindow(UIWindowTypeID.Spring23Misson)
  else
    UIManager:ShowWindowOnly(UIWindowTypeID.Spring23Misson)
    local seasonData = (eActInteract.__GetActData)()
    local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
    if not seasonCtrl then
      return 
    end
    seasonCtrl:TryOpenUnlockWin(seasonData)
  end
end

eActInteract.OnActCamChangeFunc = function()
  -- function num : 0_30
end

eActInteract.OnLbActivityRunningTimeoutFunc = function(actLbCtrl)
  -- function num : 0_31
end

eActInteract.OnLbActivityFinishedFunc = function(actLbCtrl)
  -- function num : 0_32
end

eActInteract.OnActLbExitFunc = function(actLbCtrl)
  -- function num : 0_33 , upvalues : eActInteract, _ENV, UpdateActivityReddotChange
  local seasonData = (eActInteract.__GetActData)()
  if seasonData ~= nil then
    local reddot = seasonData:GetActivityReddot()
    RedDotController:RemoveListener(reddot.nodePath, UpdateActivityReddotChange)
  end
end

return eActInteract

