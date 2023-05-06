-- params : ...
-- function num : 0 , upvalues : _ENV
local eActInteract = {}
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivityWinter23Enum = require("Game.ActivityWinter23.Data.ActivityWinter23Enum")
local cs_MessageCommon = CS.MessageCommon
eActInteract.__GetActData = function()
  -- function num : 0_0 , upvalues : _ENV
  local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if not winter23Ctrl then
    return 
  end
  return winter23Ctrl:GetWinter23Data()
end

eActInteract.eMissonBtn = {Task = 1}
local MissonBtnOpenFunc = {[(eActInteract.eMissonBtn).Task] = function()
  -- function num : 0_1 , upvalues : eActInteract, _ENV, ActLbUtil
  local winter23Data = (eActInteract.__GetActData)()
  local dailyTaskData = winter23Data:GetWinter23DailyTaskData()
  local termTaskData = winter23Data:GetWinter23TermTaskData()
  if dailyTaskData == nil then
    if isGameDev then
      warn(" daily task not open ")
    end
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Winter23Task, function(win)
    -- function num : 0_1_0 , upvalues : ActLbUtil, winter23Data, dailyTaskData, termTaskData
    if win == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    win:InitWinter23Task(winter23Data:GetActFrameId(), dailyTaskData, termTaskData, function()
      -- function num : 0_1_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
}
local MissonBtnRedFunc = {[(eActInteract.eMissonBtn).Task] = function()
  -- function num : 0_2 , upvalues : eActInteract, ActivityWinter23Enum
  local winter23Data = (eActInteract.__GetActData)()
  local reddot = winter23Data:GetActivityReddot()
  if reddot == nil then
    return false
  end
  local childReddot = reddot:GetChild((ActivityWinter23Enum.reddotType).DailyTask)
  if childReddot ~= nil and childReddot:GetRedDotCount() > 0 then
    return true
  end
  childReddot = reddot:GetChild((ActivityWinter23Enum.reddotType).OnceTask)
  do return childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
local EnterMapEp = function(isRepeat)
  -- function num : 0_3 , upvalues : _ENV, SectorStageDetailHelper, cs_MessageCommon, ActLbUtil
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local winter23Data = win23Ctrl:GetWinter23Data()
    if winter23Data == nil then
      error("winter23 act data not exist")
      return 
    end
    win23Ctrl:SetActWin23TipMode(isRepeat)
    local mainCfg = winter23Data:GetWinter23Cfg()
    local sectorId = mainCfg.normal_sector
    local flag, defaultSectorId = winter23Data:GetLastWinter23MainSector()
    if flag then
      sectorId = defaultSectorId
    end
    local unCompleteCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)((SectorStageDetailHelper.PlayMoudleType).EpMixWarchess)
    if unCompleteCfg then
      if sectorId ~= mainCfg.normal_sector and unCompleteCfg.sector == mainCfg.normal_sector then
        error("记录的扇区与正在进行游戏的扇区不是同一个")
        sectorId = mainCfg.normal_sector
      else
        if sectorId ~= mainCfg.hard_stage and unCompleteCfg.sector == mainCfg.hard_stage then
          error("记录的扇区与正在进行游戏的扇区不是同一个")
          sectorId = mainCfg.hard_stage
        end
      end
      if not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) then
        return 
      end
      if winter23Data:IsNotRepeatStage(unCompleteCfg.id) and isRepeat then
        local actName, mainName = win23Ctrl:GetActWin23NameAndMainMode()
        local _, repeatName = win23Ctrl:GetActWin23NameAndRepeatMode()
        local msg = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7136, actName, mainName, tostring(unCompleteCfg.num), actName, repeatName))
        ;
        (cs_MessageCommon.ShowMessageBox)(msg)
        return 
      end
    end
    do
      local realReturnFunc = function()
    -- function num : 0_3_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end

      if (SectorStageDetailHelper.IsSectorHasUnComplete)(sectorId) then
        ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
        win23Ctrl:SetWinter23MainInfo(sectorId, isRepeat, realReturnFunc, true)
        ;
        (SectorStageDetailHelper.ContinueUncompleteStage)((SectorStageDetailHelper.PlayMoudleType).EpMixWarchess)
        return 
      end
      ;
      (ActLbUtil.OnActLbInteractEnter)(true)
      win23Ctrl:EnterWinter23MainEp(sectorId, isRepeat, realReturnFunc)
    end
  end
end

eActInteract.eLbIntrctActionId = {Main = 1, Shop = 2, Tech = 3, Repeat = 4, MiniGame = 6, WarChessSeason = 7, ChessGreenHand = 8}
eActInteract.eLbIntrctEntityId = {Main = 1, Shop = 2, Tech = 3, Repeat = 4, MiniGame = 6, WarChessSeason = 7, ChessGreenHand = 8, sol = 9, deadSol = 13}
eActInteract.eIntrctFuncs = {[(eActInteract.eLbIntrctActionId).Main] = function(entity)
  -- function num : 0_4 , upvalues : EnterMapEp
  EnterMapEp(false)
end
, [(eActInteract.eLbIntrctActionId).Shop] = function(entity)
  -- function num : 0_5 , upvalues : eActInteract, _ENV, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  if not unlock then
    return 
  end
  local winter23Data = (eActInteract.__GetActData)()
  local mainCfg = winter23Data:GetWinter23Cfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.Winrwe23Shop, function(window)
    -- function num : 0_5_0 , upvalues : winter23Data, ActLbUtil, mainCfg
    if window == nil then
      return 
    end
    window:BindRedShopFunc(function(shopId)
      -- function num : 0_5_0_0 , upvalues : winter23Data
      return not winter23Data:IsWinter23ShopLooked(shopId)
    end
)
    window:BindSelectShopFunc(function(shopId)
      -- function num : 0_5_0_1 , upvalues : winter23Data
      winter23Data:SetWinter23ShopLooked(shopId)
    end
)
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    window:InitSum22ShopByShopList(winter23Data, mainCfg.shop_list, mainCfg.token_item, function()
      -- function num : 0_5_0_2 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
, [(eActInteract.eLbIntrctActionId).Tech] = function(entity)
  -- function num : 0_6 , upvalues : eActInteract, _ENV, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  if not unlock then
    return 
  end
  local winter23Data = (eActInteract.__GetActData)()
  local mainCfg = winter23Data:GetWinter23Cfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.Winter23StrategyOverview, function(window)
    -- function num : 0_6_0 , upvalues : ActLbUtil, winter23Data, mainCfg
    if window == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    window:InitChristmas22StrategyOverview(winter23Data:GetWinter23TechTree(), mainCfg.tech_special_branch, function()
      -- function num : 0_6_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
, [(eActInteract.eLbIntrctActionId).Repeat] = function()
  -- function num : 0_7 , upvalues : EnterMapEp
  EnterMapEp(true)
end
, [5] = function()
  -- function num : 0_8
end
, [(eActInteract.eLbIntrctActionId).MiniGame] = function()
  -- function num : 0_9 , upvalues : _ENV, ActLbUtil
  local win23Ctrl = (ControllerManager:GetController(ControllerTypeId.ActivityWinter23))
  local winter23Data = nil
  if win23Ctrl then
    winter23Data = win23Ctrl:GetWinter23Data()
    if winter23Data == nil then
      error("winter23 act data not exist")
      return 
    end
  end
  if not winter23Data:IsActivityRunning() then
    return 
  end
  local activityFwId = winter23Data:GetActFrameId()
  local miniGameConfigId = winter23Data:GetMiniGameId()
  local joinRewards = winter23Data:GetMiniGameIsGottenJoinRewards()
  local maxScore = winter23Data:GetMiniGameMaxScore()
  local setMaxScore = BindCallback(winter23Data, winter23Data.SetMiniGameMineMaxScore)
  local setJoinRewards = BindCallback(winter23Data, winter23Data.SetMiniGameIsGottenJoinRewards)
  local endtime = winter23Data:GetActivityEndTime()
  local realReturnFunc = function()
    -- function num : 0_9_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end

  ;
  (ActLbUtil.OnActLbInteractEnter)(true)
  local smashingPenguinsController = ControllerManager:GetController(ControllerTypeId.SmashingPenguins, true)
  smashingPenguinsController:InjectModifyMsgAction(setMaxScore, setJoinRewards)
  smashingPenguinsController:SetSmashingPenguinsActEndTime(endtime)
  smashingPenguinsController:ShowSmashingPenguinUIMain(activityFwId, miniGameConfigId, joinRewards, maxScore, realReturnFunc)
end
, [(eActInteract.eLbIntrctActionId).WarChessSeason] = function()
  -- function num : 0_10 , upvalues : _ENV, ActLbUtil
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local winter23Data = win23Ctrl:GetWinter23Data()
    if winter23Data == nil then
      error("winter23 act data not exist")
      return 
    end
    local curSeasonId = winter23Data:GetWinter23WarchessSeasonId()
    local isUnComplete, unCompleteData = WarChessSeasonManager:GetUncompleteWCSData()
    if isUnComplete then
      if unCompleteData.seasonId == curSeasonId then
        win23Ctrl:ContinuehallowmasSeason()
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
      win23Ctrl:EnterWinter23WarChessSeasonLevelSelect(function()
    -- function num : 0_10_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end
)
    end
  end
end
, [(eActInteract.eLbIntrctActionId).ChessGreenHand] = function()
  -- function num : 0_11 , upvalues : _ENV, SectorStageDetailHelper, ActLbUtil
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local winter23Data = win23Ctrl:GetWinter23Data()
    if winter23Data == nil then
      error("winter23 act data not exist")
      return 
    end
    local warChessGreenHandSectorId = winter23Data:GetWarChessGreenHandSectorId()
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
      win23Ctrl:EnterGreenHandWarChessSeasonLevels(warChessGreenHandSectorId, function()
    -- function num : 0_11_0 , upvalues : ActLbUtil
    (ActLbUtil.OnActLbInteractEnter)(false)
  end
)
    end
  end
end
}
eActInteract.eActIntrctActionUIInitFunc = {}
eActInteract.eSubNameFuncs = {}
eActInteract.eUnlockIntrctFunc = {[(eActInteract.eLbIntrctEntityId).Tech] = function(lbIntrctData)
  -- function num : 0_12 , upvalues : eActInteract
  local winter23Data = (eActInteract.__GetActData)()
  do return (winter23Data ~= nil and winter23Data:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).Main] = function(lbIntrctData)
  -- function num : 0_13 , upvalues : eActInteract
  local winter23Data = (eActInteract.__GetActData)()
  do return (winter23Data ~= nil and winter23Data:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).Repeat] = function(lbIntrctData)
  -- function num : 0_14 , upvalues : eActInteract
  local winter23Data = (eActInteract.__GetActData)()
  do return (winter23Data ~= nil and winter23Data:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).MiniGame] = function(lbIntrctData)
  -- function num : 0_15 , upvalues : eActInteract
  local winter23Data = (eActInteract.__GetActData)()
  do return (winter23Data ~= nil and winter23Data:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).WarChessSeason] = function(lbIntrctData)
  -- function num : 0_16 , upvalues : eActInteract
  local winter23Data = (eActInteract.__GetActData)()
  do return (winter23Data ~= nil and winter23Data:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
}
eActInteract.eActIntrctActionLockStateDesFunc = {[(eActInteract.eLbIntrctEntityId).Tech] = function(entity)
  -- function num : 0_17 , upvalues : eActInteract, _ENV
  local winter23Data = (eActInteract.__GetActData)()
  local playEndTime = winter23Data:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctEntityId).Main] = function(entity)
  -- function num : 0_18 , upvalues : eActInteract, _ENV
  local winter23Data = (eActInteract.__GetActData)()
  local playEndTime = winter23Data:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctEntityId).Repeat] = function(entity)
  -- function num : 0_19 , upvalues : eActInteract, _ENV
  local winter23Data = (eActInteract.__GetActData)()
  local playEndTime = winter23Data:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctEntityId).MiniGame] = function(entity)
  -- function num : 0_20 , upvalues : eActInteract, _ENV
  local winter23Data = (eActInteract.__GetActData)()
  local playEndTime = winter23Data:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [(eActInteract.eLbIntrctEntityId).WarChessSeason] = function(entity)
  -- function num : 0_21 , upvalues : eActInteract, _ENV
  local winter23Data = (eActInteract.__GetActData)()
  local playEndTime = winter23Data:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
}
eActInteract.eActIntrctActionShowBlueDotFunc = {[(eActInteract.eLbIntrctEntityId).Shop] = function(entity)
  -- function num : 0_22 , upvalues : eActInteract, ActivityWinter23Enum
  local winter23Data = (eActInteract.__GetActData)()
  local reddot = winter23Data:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).Shop)
  do return childReddot ~= nil and childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).Tech] = function(lbIntrctData)
  -- function num : 0_23 , upvalues : eActInteract, ActivityWinter23Enum
  local winter23Data = (eActInteract.__GetActData)()
  local reddot = winter23Data:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).Tech)
  do return childReddot ~= nil and childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).Main] = function(lbIntrctData)
  -- function num : 0_24 , upvalues : eActInteract, ActivityWinter23Enum
  local winter23Data = (eActInteract.__GetActData)()
  local reddot = winter23Data:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivityWinter23Enum.reddotType).main)
  do return childReddot ~= nil and childReddot:GetRedDotCount() > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
local UpdateActivityReddotChange = function()
  -- function num : 0_25 , upvalues : _ENV, eActInteract, ActLbUtil
  for k,v in pairs(eActInteract.eActIntrctActionShowBlueDotFunc) do
    (ActLbUtil.UpdLbEnttBluedot)(k)
  end
  local missonUI = UIManager:GetWindow(UIWindowTypeID.Spring23Misson)
  if missonUI ~= nil then
    missonUI:RefreshMissonReddot()
  end
end

eActInteract.OnActLbSceneLoadedFunc = function(actLbCtrl)
  -- function num : 0_26 , upvalues : _ENV, MissonBtnOpenFunc, eActInteract, MissonBtnRedFunc, UpdateActivityReddotChange
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Misson, function(win)
    -- function num : 0_26_0 , upvalues : MissonBtnOpenFunc, eActInteract, MissonBtnRedFunc
    if win == nil then
      return 
    end
    win:SetTaskFunc(MissonBtnOpenFunc[(eActInteract.eMissonBtn).Task], MissonBtnRedFunc[(eActInteract.eMissonBtn).Task])
    win:RefreshMissonReddot()
  end
)
  local winter23Data = (eActInteract.__GetActData)()
  local reddot = winter23Data:GetActivityReddot()
  RedDotController:AddListener(reddot.nodePath, UpdateActivityReddotChange)
  local isSolDead = winter23Data:GetIsExterUnlock()
  local sol = (actLbCtrl.actLbIntrctCtrl):GetLbIntrctEntFxUnlockById((eActInteract.eLbIntrctEntityId).sol)
  if sol ~= nil then
    sol:SetLbEnityGameObjectActive(not isSolDead)
  end
  local deadSol = (actLbCtrl.actLbIntrctCtrl):GetLbIntrctEntFxUnlockById((eActInteract.eLbIntrctEntityId).deadSol)
  if deadSol ~= nil then
    deadSol:SetLbEnityGameObjectActive(isSolDead)
  end
end

eActInteract.OnActLbStartShowEndCoFunc = function(actLbCtrl)
  -- function num : 0_27 , upvalues : _ENV
  while UIManager:GetWindow(UIWindowTypeID.Spring23Misson) == nil do
    (coroutine.yield)(nil)
  end
  local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if not winter23Ctrl then
    return 
  end
  winter23Ctrl:RunEnterCompleteFunc()
end

eActInteract.OnActLbInteractEnterFunc = function(isEnter)
  -- function num : 0_28 , upvalues : _ENV
  if isEnter then
    UIManager:HideWindow(UIWindowTypeID.Spring23Misson)
  else
    UIManager:ShowWindowOnly(UIWindowTypeID.Spring23Misson)
  end
end

eActInteract.OnActCamChangeFunc = function()
  -- function num : 0_29
end

eActInteract.OnLbActivityRunningTimeoutFunc = function(actLbCtrl)
  -- function num : 0_30
end

eActInteract.OnLbActivityFinishedFunc = function(actLbCtrl)
  -- function num : 0_31
end

eActInteract.OnActLbExitFunc = function(actLbCtrl)
  -- function num : 0_32 , upvalues : eActInteract, _ENV, UpdateActivityReddotChange
  local winter23Data = (eActInteract.__GetActData)()
  if winter23Data ~= nil then
    local reddot = winter23Data:GetActivityReddot()
    RedDotController:RemoveListener(reddot.nodePath, UpdateActivityReddotChange)
  end
end

return eActInteract

