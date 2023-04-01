-- params : ...
-- function num : 0 , upvalues : _ENV
local eActInteract = {}
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivitySpringEnum = require("Game.ActivitySpring.Data.ActivitySpringEnum")
eActInteract.eLbIntrctEntityId = {EnvSelect = 1, StoryReview = 2, TechTree = 3, HardLevel = 4, PaintedEggshell = 5}
local CreateUIWhenEnterFinish = function(springData)
  -- function num : 0_0 , upvalues : _ENV, ActLbUtil
  local Local_Spring23MissonFunc = function(callback)
    -- function num : 0_0_0 , upvalues : _ENV, springData, ActLbUtil
    UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Misson, function(win)
      -- function num : 0_0_0_0 , upvalues : springData, ActLbUtil, callback
      if win == nil then
        return 
      end
      win:InitSpring23Misson(springData, function(flag)
        -- function num : 0_0_0_0_0 , upvalues : ActLbUtil
        if not flag then
          (ActLbUtil.UpdLbCurInteractList)()
        end
        ;
        (ActLbUtil.OnActLbInteractEnter)(flag)
      end
)
      callback()
    end
)
  end

  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Interactive, function(win)
    -- function num : 0_0_1 , upvalues : springData, actLbCtrl
    if win == nil then
      return 
    end
    win:InitSpring23Interactive(springData, (actLbCtrl.actLbIntrctCtrl):GetAllHeroEntity())
  end
)
  local Local_Spring23UnlockFunc = function(callback)
    -- function num : 0_0_2 , upvalues : springData, _ENV, ActLbUtil
    local unlockInfo = springData:GetSpringUnlockInfo()
    if unlockInfo ~= nil and unlockInfo:IsExistActUnlockInfo() then
      UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Unlock, function(win)
      -- function num : 0_0_2_0 , upvalues : ActLbUtil, unlockInfo, callback
      if win == nil then
        return 
      end
      ;
      (ActLbUtil.OnActLbInteractEnter)(true)
      win:InitSpring23Unlock(unlockInfo, function()
        -- function num : 0_0_2_0_0 , upvalues : ActLbUtil
        (ActLbUtil.OnActLbInteractEnter)(false)
      end
)
      callback()
    end
)
    else
      callback()
    end
  end

  local createSort = {Local_Spring23MissonFunc, Local_Spring23UnlockFunc}
  local Local_SortNextFunc = nil
  Local_SortNextFunc = function()
    -- function num : 0_0_3 , upvalues : createSort, _ENV, Local_SortNextFunc
    if createSort[1] ~= nil then
      local func = createSort[1]
      ;
      (table.remove)(createSort, 1)
      func(Local_SortNextFunc)
    end
  end

  Local_SortNextFunc()
end

local TryOpenUnlockWin = function(springData)
  -- function num : 0_1 , upvalues : _ENV, ActLbUtil
  local unlockInfo = springData:GetSpringUnlockInfo()
  if unlockInfo ~= nil and unlockInfo:IsExistActUnlockInfo() then
    UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Unlock, function(win)
    -- function num : 0_1_0 , upvalues : ActLbUtil, unlockInfo
    if win == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    win:InitSpring23Unlock(unlockInfo, function()
      -- function num : 0_1_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
  end
end

local UpdateActivityReddotChange = function()
  -- function num : 0_2 , upvalues : _ENV, eActInteract, ActLbUtil
  for k,v in pairs(eActInteract.eActIntrctActionShowBlueDotFunc) do
    (ActLbUtil.UpdLbEnttBluedot)(k)
  end
end

eActInteract.eIntrctFuncs = {[1] = function(entity)
  -- function num : 0_3 , upvalues : _ENV, SectorStageDetailHelper, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil then
    error("spring act data not exist")
    return 
  end
  local mainCfg = springData:GetSpringMainCfg()
  local sectorId = mainCfg.main_stage
  if not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) then
    return 
  end
  if (SectorStageDetailHelper.IsSectorHasUnComplete)(sectorId) then
    ControllerManager:DeleteController(ControllerTypeId.ActivityLobbyCtrl)
    ;
    (SectorStageDetailHelper.ContinueUncompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
    return 
  end
  ;
  (ActLbUtil.OnActLbInteractEnter)(true)
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23LevelModSelect, function(window)
    -- function num : 0_3_0 , upvalues : springData, ActLbUtil
    if window == nil then
      return 
    end
    window:InitSpring23ModeSelect(springData, function()
      -- function num : 0_3_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
, [2] = function(entity)
  -- function num : 0_4 , upvalues : _ENV, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  if not unlock then
    return 
  end
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Story, function(win)
    -- function num : 0_4_0 , upvalues : ActLbUtil, intrctData, springData
    if win == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    local heroId = intrctData:GetLbIntrctObjHeroId()
    win:InitSpring23Story(springData, heroId, function()
      -- function num : 0_4_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
, [3] = function(entity)
  -- function num : 0_5 , upvalues : _ENV, ActLbUtil
  local intrctData = entity:GetLbIntrctEntData()
  local unlock = intrctData:IsLbIntrctUnlock()
  if not unlock then
    return 
  end
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  local actTechTree = springData:GetSpringTechTree()
  local specialBranchId = (springData:GetSpringMainCfg()).tech_special_branch
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23StrategyOverview, function(win)
    -- function num : 0_5_0 , upvalues : ActLbUtil, actTechTree, specialBranchId
    if win == nil then
      return 
    end
    ;
    (ActLbUtil.OnActLbInteractEnter)(true)
    win:InitChristmas22StrategyOverview(actTechTree, specialBranchId, function()
      -- function num : 0_5_0_0 , upvalues : ActLbUtil
      (ActLbUtil.OnActLbInteractEnter)(false)
    end
)
  end
)
end
, [4] = function(entity)
  -- function num : 0_6 , upvalues : _ENV, ActLbUtil
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  local objNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  objNetwork:CS_Rank_Detail(springData:GetRankId(), 0, function(args)
    -- function num : 0_6_0 , upvalues : _ENV, ActLbUtil, springData
    if not args then
      return 
    end
    local msg = args[0]
    UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Challenge, function(win)
      -- function num : 0_6_0_0 , upvalues : ActLbUtil, springData, msg
      if win == nil then
        return 
      end
      ;
      (ActLbUtil.OnActLbInteractEnter)(true)
      win:InitSpring23HardLevel(springData, function()
        -- function num : 0_6_0_0_0 , upvalues : ActLbUtil
        (ActLbUtil.OnActLbInteractEnter)(false)
      end
)
      win:SetRankTex(msg.myRank)
    end
)
  end
)
end
, [5] = function(entity)
  -- function num : 0_7 , upvalues : _ENV, ActLbUtil, TryOpenUnlockWin
  if IsNull(entity.gameObject) then
    error("entity.gameObject is nil")
    return 
  end
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  ;
  (actLbCtrl.actLbCmderCtrl):LbHeroAndCmdFace2Face(entity, function()
    -- function num : 0_7_0 , upvalues : _ENV, entity, ActLbUtil, TryOpenUnlockWin
    local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
    if not springCtrl then
      return 
    end
    local springData = springCtrl:GetFirstSpringData()
    local intrctData = entity:GetLbIntrctEntData()
    local heroId = intrctData:GetLbIntrctObjHeroId()
    local success = springCtrl:CheckAndTalk(springData:GetActId(), heroId, function()
      -- function num : 0_7_0_0 , upvalues : ActLbUtil, TryOpenUnlockWin, springData
      (ActLbUtil.UpdLbCurInteractList)()
      ;
      (ActLbUtil.OnActLbInteractEnter)(false)
      TryOpenUnlockWin(springData)
    end
)
    if success then
      (ActLbUtil.OnActLbInteractEnter)(true)
    end
  end
)
end
, [6] = function(entity)
  -- function num : 0_8 , upvalues : _ENV, ActLbUtil, eActInteract
  local lbIntrctData = entity:GetLbIntrctEntData()
  local actionData = lbIntrctData:GetLbIntrctObjActionFirst()
  local params = actionData:GetLbIntrctActionParams()
  local avgId = params[1]
  ;
  (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId, function()
    -- function num : 0_8_0 , upvalues : ActLbUtil, eActInteract
    (ActLbUtil.UpdActLbEnttUnlockStateByObjId)((eActInteract.eLbIntrctEntityId).PaintedEggshell)
  end
)
end
}
eActInteract.eActIntrctActionUIInitFunc = {[5] = function(uiItem, entity, actionCfg)
  -- function num : 0_9 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  local springStoryData = springData:GetSpringStoryData()
  local intrctData = entity:GetLbIntrctEntData()
  local heroId = intrctData:GetLbIntrctObjHeroId()
  local interactCfg, cantTalk = springStoryData:GetNowCfgByHeroId(heroId)
  if not interactCfg or cantTalk then
    uiItem:SetSetActLbIntrctItemLock()
    return 
  end
  local needCost = springStoryData:GetNeedExp(interactCfg.id)
  local allCost = springData:GetInteractCostNum()
  if needCost <= allCost then
    uiItem:SetActLbIntrctItemHighlight()
  end
  uiItem:SetSetActLbIntrctItemProgress(tostring(allCost) .. "/" .. tostring(needCost))
end
}
eActInteract.eSubNameFuncs = {[5] = function(entity, actionCfg)
  -- function num : 0_10 , upvalues : _ENV
  local intrctData = entity:GetLbIntrctEntData()
  local heroId = intrctData:GetLbIntrctObjHeroId()
  local heroCfg = (ConfigData.hero_data)[heroId]
  local heroName = (LanguageUtil.GetLocaleText)(heroCfg.name)
  return (string.format)((LanguageUtil.GetLocaleText)(actionCfg.obj_func_subname), heroName)
end
}
eActInteract.eUnlockIntrctFunc = {[1] = function(lbIntrctData)
  -- function num : 0_11 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil then
    return false
  end
  local isRunning = springData:IsActivityRunning()
  return isRunning
end
, [3] = function(lbIntrctData)
  -- function num : 0_12 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  do return (springData ~= nil and springData:IsActivityRunning()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(eActInteract.eLbIntrctEntityId).HardLevel] = function(lbIntrctData)
  -- function num : 0_13 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil then
    return false
  end
  local isRunning = springData:IsActivityRunning()
  return isRunning
end
, [(eActInteract.eLbIntrctEntityId).PaintedEggshell] = function(lbIntrctData)
  -- function num : 0_14 , upvalues : _ENV
  local actionData = lbIntrctData:GetLbIntrctObjActionFirst()
  local params = actionData:GetLbIntrctActionParams()
  local avgId = params[1]
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local played = avgPlayCtrl:IsAvgPlayed(avgId)
  return not played
end
}
eActInteract.eActIntrctActionLockStateDesFunc = {[1] = function(entity, actionCfg)
  -- function num : 0_15 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil then
    return false
  end
  local playEndTime = springData:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [3] = function(entity)
  -- function num : 0_16 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil then
    return false
  end
  local playEndTime = springData:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
, [4] = function(entity, actionCfg)
  -- function num : 0_17 , upvalues : _ENV
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil then
    return false
  end
  local playEndTime = springData:GetActivityEndTime()
  if playEndTime < PlayerDataCenter.timestamp then
    return 1
  end
  return 0
end
}
eActInteract.eActIntrctActionShowBlueDotFunc = {[1] = function(entity, actionCfg)
  -- function num : 0_18 , upvalues : _ENV, ActivitySpringEnum
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil or not springData:IsActivityRunning() then
    return false
  end
  local reddot = springData:GetActivityReddot()
  local childReddot = reddot:AddChild((ActivitySpringEnum.reddotType).EpEnv)
  if childReddot:GetRedDotCount() > 0 then
    return true
  end
  return false
end
, [3] = function(lbIntrctData)
  -- function num : 0_19 , upvalues : _ENV, ActivitySpringEnum
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if springCtrl == nil then
    return false
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData == nil or not springData:IsActivityRunning() then
    return false
  end
  local reddot = springData:GetActivityReddot()
  local childReddot1 = reddot:AddChild((ActivitySpringEnum.reddotType).Tech)
  local childReddot2 = reddot:AddChild((ActivitySpringEnum.reddotType).TechItemLimit)
  do return (childReddot1 ~= nil and childReddot1:GetRedDotCount() > 0) or (childReddot2 ~= nil and childReddot2:GetRedDotCount() > 0) end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
eActInteract.OnActLbSceneLoadedFunc = function(actLbCtrl)
  -- function num : 0_20 , upvalues : _ENV, CreateUIWhenEnterFinish, UpdateActivityReddotChange
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  CreateUIWhenEnterFinish(springData)
  local reddot = springData:GetActivityReddot()
  RedDotController:AddListener(reddot.nodePath, UpdateActivityReddotChange)
end

eActInteract.OnActLbStartShowEndCoFunc = function(actLbCtrl)
  -- function num : 0_21 , upvalues : _ENV
  while UIManager:GetWindow(UIWindowTypeID.Spring23Misson) == nil do
    (coroutine.yield)(nil)
  end
  while UIManager:GetWindow(UIWindowTypeID.Spring23Interactive) == nil do
    (coroutine.yield)(nil)
  end
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  springCtrl:RunEnterCompleteFunc()
end

eActInteract.OnActLbInteractEnterFunc = function(isEnter)
  -- function num : 0_22 , upvalues : _ENV, TryOpenUnlockWin
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  local springData = springCtrl:GetFirstSpringData()
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if isEnter then
    UIManager:HideWindow(UIWindowTypeID.Spring23Misson)
    UIManager:HideWindow(UIWindowTypeID.Spring23Interactive)
  else
    UIManager:ShowWindowOnly(UIWindowTypeID.Spring23Misson)
    local interactWin = UIManager:ShowWindowOnly(UIWindowTypeID.Spring23Interactive)
    if interactWin then
      interactWin:InitSpring23Interactive(springData, (actLbCtrl.actLbIntrctCtrl):GetAllHeroEntity())
    end
  end
  do
    if not isEnter then
      TryOpenUnlockWin(springData)
    end
  end
end

eActInteract.OnActCamChangeFunc = function()
  -- function num : 0_23 , upvalues : _ENV
  local interactWin = UIManager:GetWindow(UIWindowTypeID.Spring23Interactive)
  if interactWin and interactWin.active then
    interactWin:UpdateInteractive()
  end
end

eActInteract.OnLbActivityRunningTimeoutFunc = function(actLbCtrl)
  -- function num : 0_24
end

eActInteract.OnLbActivityFinishedFunc = function(actLbCtrl)
  -- function num : 0_25
end

eActInteract.OnActLbExitFunc = function(actLbCtrl)
  -- function num : 0_26 , upvalues : _ENV, UpdateActivityReddotChange
  local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
  if not springCtrl then
    return 
  end
  local springData = springCtrl:GetFirstSpringData()
  if springData ~= nil then
    local reddot = springData:GetActivityReddot()
    RedDotController:RemoveListener(reddot.nodePath, UpdateActivityReddotChange)
  end
end

return eActInteract

