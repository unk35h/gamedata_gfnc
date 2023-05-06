-- params : ...
-- function num : 0 , upvalues : _ENV
local JumpManager = {}
local FuncArray = {}
local ValidateFuncArray = {}
local cs_MessageCommon = CS.MessageCommon
local HomeEnum = require("Game.Home.HomeEnum")
local eActivityType = (require("Game.ActivityFrame.ActivityFrameEnum")).eActivityType
JumpManager.eJumpTarget = {Home = 0, ShopInvest = 1, ShopResident = 2, ShopVariable = 3, LotteryNormal = 4, LotteryAdvanced = 5, Mail = 6, Hero = 7, Sector = 8, Oasis = 9, Factory = 10, DaliyTask = 11, WeeklyTask = 12, MainTask = 13, SideTask = 14, Achieve4Cultivate = 15, Achieve4Commander = 16, Achieve4Dungeon = 17, Achieve4System = 18, Achieve4Oasis = 19, BuyStamina = 20, DailyChallenge = 21, WeeklyChallenge = 22, Dorm = 23, ShopBase = 24, Setting = 25, UserCenter = 26, UserInfoPage = 27, WinterActivityTech = 28, DungeonTower = 29, HeroSkin = 30, OasisBuilding = 100, StrategyOverview = 101, fragDungeon = 102, resourceDungeon = 103, ATHDungeon = 104, DynShop = 105, DynTask = 106, DynSectorLevel = 107, DynLottery = 108, DynActivity = 109, DynWarehouse = 110, DynCareerStO = 111}
JumpManager.Init = function(self)
  -- function num : 0_0 , upvalues : _ENV, FuncArray, JumpManager, ValidateFuncArray
  self:ClearSectorJumpId()
  self.couldUseItemJump = false
  local config = ConfigData.system_jump
  FuncArray[(JumpManager.eJumpTarget).Home] = UIUtil.ReturnHome
  FuncArray[(JumpManager.eJumpTarget).ShopInvest] = BindCallback(self, self.Jump2Shop, ((config[(JumpManager.eJumpTarget).ShopInvest]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).ShopResident] = BindCallback(self, self.Jump2Shop, ((config[(JumpManager.eJumpTarget).ShopResident]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).ShopVariable] = BindCallback(self, self.Jump2Shop, ((config[(JumpManager.eJumpTarget).ShopVariable]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).LotteryNormal] = BindCallback(self, self.Jump2Lottery, true)
  FuncArray[(JumpManager.eJumpTarget).LotteryAdvanced] = BindCallback(self, self.Jump2Lottery, false)
  FuncArray[(JumpManager.eJumpTarget).Mail] = BindCallback(self, self.Jump2Mail)
  FuncArray[(JumpManager.eJumpTarget).Hero] = BindCallback(self, self.Jump2Hro)
  FuncArray[(JumpManager.eJumpTarget).HeroSkin] = BindCallback(self, self.Jump2HeroSkin)
  FuncArray[(JumpManager.eJumpTarget).Sector] = BindCallback(self, self.Jump2Sector)
  FuncArray[(JumpManager.eJumpTarget).Oasis] = BindCallback(self, self.Jump2Oasis)
  FuncArray[(JumpManager.eJumpTarget).Factory] = BindCallback(self, self.Jump2Factory)
  FuncArray[(JumpManager.eJumpTarget).DaliyTask] = BindCallback(self, self.Jump2Task, ((config[(JumpManager.eJumpTarget).DaliyTask]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).WeeklyTask] = BindCallback(self, self.Jump2Task, ((config[(JumpManager.eJumpTarget).WeeklyTask]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).MainTask] = BindCallback(self, self.Jump2Task, ((config[(JumpManager.eJumpTarget).MainTask]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).SideTask] = BindCallback(self, self.Jump2Task, ((config[(JumpManager.eJumpTarget).SideTask]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).Achieve4Cultivate] = BindCallback(self, self.Jump2Achievement, ((config[(JumpManager.eJumpTarget).Achieve4Cultivate]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).Achieve4Commander] = BindCallback(self, self.Jump2Achievement, ((config[(JumpManager.eJumpTarget).Achieve4Commander]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).Achieve4Dungeon] = BindCallback(self, self.Jump2Achievement, ((config[(JumpManager.eJumpTarget).Achieve4Dungeon]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).Achieve4System] = BindCallback(self, self.Jump2Achievement, ((config[(JumpManager.eJumpTarget).Achieve4System]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).Achieve4Oasis] = BindCallback(self, self.Jump2Achievement, ((config[(JumpManager.eJumpTarget).Achieve4Oasis]).jump_arg)[1])
  FuncArray[(JumpManager.eJumpTarget).BuyStamina] = BindCallback(self, self.Jump2BuyStamina)
  FuncArray[(JumpManager.eJumpTarget).DailyChallenge] = BindCallback(self, self.Jump2DailyChallenge)
  FuncArray[(JumpManager.eJumpTarget).WeeklyChallenge] = BindCallback(self, self.Jump2WeeklyChallenge)
  FuncArray[(JumpManager.eJumpTarget).Dorm] = BindCallback(self, self.Jump2Dorm)
  FuncArray[(JumpManager.eJumpTarget).ShopBase] = BindCallback(self, self.Jump2ShopBase)
  FuncArray[(JumpManager.eJumpTarget).Setting] = BindCallback(self, self.Jump2Setting)
  FuncArray[(JumpManager.eJumpTarget).UserCenter] = BindCallback(self, self.Jump2UserCenter)
  FuncArray[(JumpManager.eJumpTarget).UserInfoPage] = BindCallback(self, self.Jump2UserInfoPage)
  FuncArray[(JumpManager.eJumpTarget).WinterActivityTech] = BindCallback(self, self.Jump2WinterActivityTech)
  FuncArray[(JumpManager.eJumpTarget).DungeonTower] = BindCallback(self, self.Jump2DungeonTower)
  FuncArray[(JumpManager.eJumpTarget).OasisBuilding] = BindCallback(self, self.Jump2OasisBuilding)
  FuncArray[(JumpManager.eJumpTarget).StrategyOverview] = BindCallback(self, self.Jump2StrategyOverview)
  FuncArray[(JumpManager.eJumpTarget).fragDungeon] = BindCallback(self, self.Jump2SectorFragDungeon)
  FuncArray[(JumpManager.eJumpTarget).resourceDungeon] = BindCallback(self, self.Jump2SectorResourceDungeon)
  FuncArray[(JumpManager.eJumpTarget).ATHDungeon] = BindCallback(self, self.Jump2SectorATHDungeon)
  FuncArray[(JumpManager.eJumpTarget).DynTask] = BindCallback(self, self.Jump2DynTask)
  FuncArray[(JumpManager.eJumpTarget).DynShop] = BindCallback(self, self.Jump2DynShop)
  FuncArray[(JumpManager.eJumpTarget).DynSectorLevel] = BindCallback(self, self.Jump2DynSectorLevel)
  FuncArray[(JumpManager.eJumpTarget).DynLottery] = BindCallback(self, self.Jump2DynLottery)
  FuncArray[(JumpManager.eJumpTarget).DynActivity] = BindCallback(self, self.Jump2DynActivity)
  FuncArray[(JumpManager.eJumpTarget).DynWarehouse] = BindCallback(self, self.Jump2DynWarehouse)
  FuncArray[(JumpManager.eJumpTarget).DynCareerStO] = BindCallback(self, self.Jump2DynCareerStO)
  ValidateFuncArray[(JumpManager.eJumpTarget).Home] = function()
    -- function num : 0_0_0
    return true
  end

  ValidateFuncArray[(JumpManager.eJumpTarget).ShopInvest] = BindCallback(self, self.Jump2ShopValidate, ((config[(JumpManager.eJumpTarget).ShopInvest]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).ShopResident] = BindCallback(self, self.Jump2ShopValidate, ((config[(JumpManager.eJumpTarget).ShopResident]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).ShopVariable] = BindCallback(self, self.Jump2ShopValidate, ((config[(JumpManager.eJumpTarget).ShopVariable]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).LotteryNormal] = BindCallback(self, self.Jump2LotteryValidate, true)
  ValidateFuncArray[(JumpManager.eJumpTarget).LotteryAdvanced] = BindCallback(self, self.Jump2LotteryValidate, false)
  ValidateFuncArray[(JumpManager.eJumpTarget).Mail] = BindCallback(self, self.Jump2MailValidate, false)
  ValidateFuncArray[(JumpManager.eJumpTarget).Hero] = BindCallback(self, self.Jump2HroValidate, false)
  ValidateFuncArray[(JumpManager.eJumpTarget).HeroSkin] = BindCallback(self, self.Jump2HeroSkinValidate, false)
  ValidateFuncArray[(JumpManager.eJumpTarget).Sector] = BindCallback(self, self.Jump2SectorValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).Oasis] = BindCallback(self, self.Jump2OasisValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).Factory] = BindCallback(self, self.Jump2FactoryValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DaliyTask] = BindCallback(self, self.Jump2TaskValidate, ((config[(JumpManager.eJumpTarget).DaliyTask]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).WeeklyTask] = BindCallback(self, self.Jump2TaskValidate, ((config[(JumpManager.eJumpTarget).WeeklyTask]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).MainTask] = BindCallback(self, self.Jump2TaskValidate, ((config[(JumpManager.eJumpTarget).MainTask]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).SideTask] = BindCallback(self, self.Jump2TaskValidate, ((config[(JumpManager.eJumpTarget).SideTask]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).Achieve4Cultivate] = BindCallback(self, self.Jump2AchievementValidate, ((config[(JumpManager.eJumpTarget).Achieve4Cultivate]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).Achieve4Commander] = BindCallback(self, self.Jump2AchievementValidate, ((config[(JumpManager.eJumpTarget).Achieve4Commander]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).Achieve4Dungeon] = BindCallback(self, self.Jump2AchievementValidate, ((config[(JumpManager.eJumpTarget).Achieve4Dungeon]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).Achieve4System] = BindCallback(self, self.Jump2AchievementValidate, ((config[(JumpManager.eJumpTarget).Achieve4System]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).Achieve4Oasis] = BindCallback(self, self.Jump2AchievementValidate, ((config[(JumpManager.eJumpTarget).Achieve4Oasis]).jump_arg)[1])
  ValidateFuncArray[(JumpManager.eJumpTarget).BuyStamina] = BindCallback(self, self.Jump2BuyStaminaValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DailyChallenge] = BindCallback(self, self.Jump2DailyChallengeValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).WeeklyChallenge] = BindCallback(self, self.Jump2WeeklyChallengeValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).Dorm] = BindCallback(self, self.Jump2DormValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).ShopBase] = BindCallback(self, self.Jump2ShopBaseValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).Setting] = BindCallback(self, self.Jump2SettingValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).UserCenter] = BindCallback(self, self.Jump2UserCenterValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).UserInfoPage] = BindCallback(self, self.Jump2UserInfoPageValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).WinterActivityTech] = BindCallback(self, self.Jump2WinterActivityTechValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DungeonTower] = BindCallback(self, self.Jump2DungeonTowerValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).OasisBuilding] = BindCallback(self, self.Jump2OasisBuildingValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).StrategyOverview] = BindCallback(self, self.Jump2StrategyOverviewValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).fragDungeon] = BindCallback(self, self.Jump2SectorFragDungeonValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).resourceDungeon] = BindCallback(self, self.Jump2SectorResourceDungeonValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).ATHDungeon] = BindCallback(self, self.Jump2SectorATHDungeonValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynTask] = BindCallback(self, self.Jump2DynTaskValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynShop] = BindCallback(self, self.Jump2DynShopValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynSectorLevel] = BindCallback(self, self.Jump2DynSectorLevelValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynLottery] = BindCallback(self, self.Jump2DynLotteryValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynActivity] = BindCallback(self, self.Jump2DynActivityValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynWarehouse] = BindCallback(self, self.Jump2DynWarehouseValidate)
  ValidateFuncArray[(JumpManager.eJumpTarget).DynCareerStO] = BindCallback(self, self.Jump2DynCareerStOValidate)
end

JumpManager.Jump = function(self, jumpType, beforeJumpCallback, jumpOverCallback, argList, isCoverJump)
  -- function num : 0_1 , upvalues : JumpManager, FuncArray, _ENV
  local bool, num = self:ValidateJump(jumpType, argList)
  if bool then
    self.isJumping = true
    local newJumpOverCallback = function(...)
    -- function num : 0_1_0 , upvalues : jumpOverCallback, self
    if jumpOverCallback ~= nil then
      jumpOverCallback(...)
    end
    self.isJumping = false
  end

    do
      local RealJumpFunc = function()
    -- function num : 0_1_1 , upvalues : isCoverJump, JumpManager, jumpType, argList, self, FuncArray, num, newJumpOverCallback, _ENV
    if not isCoverJump and JumpManager:IsJumpNeedBack2Home(jumpType, argList) then
      self:Add2OnHomeUIOpenListern(function()
      -- function num : 0_1_1_0 , upvalues : FuncArray, num, newJumpOverCallback, argList
      (FuncArray[num])(newJumpOverCallback, argList, false)
    end
)
      ;
      (UIUtil.ReturnHome)()
    else
      local jumpCorverArgs = nil
      if isCoverJump then
        for typeID,win in pairs(UIManager.windows) do
          if win.fromType == eBaseWinFromWhere.jumpCorver then
            jumpCorverArgs = win.jumpCorverArgs
            win.fromType = nil
            ;
            (UIUtil.ReturnUntil2Marker)(win:GetUIWindowTypeId(), true)
          end
        end
      end
      do
        ;
        (FuncArray[num])(newJumpOverCallback, argList, isCoverJump, jumpCorverArgs)
      end
    end
  end

      if beforeJumpCallback ~= nil then
        beforeJumpCallback(RealJumpFunc)
      else
        RealJumpFunc()
      end
    end
  end
end

JumpManager.ValidateJump = function(self, jumpType, argList)
  -- function num : 0_2 , upvalues : _ENV, FuncArray, ValidateFuncArray
  local num = nil
  if type(jumpType) == "string" then
    if (string.IsNullOrEmpty)(jumpType) then
      return false
    end
    num = tonumber(jumpType)
  else
    if type(jumpType) == "number" then
      num = jumpType
    else
      return false
    end
  end
  if FuncArray[num] == nil then
    return false
  end
  return (ValidateFuncArray[num])(argList, false), num
end

JumpManager.__ShowCanotJumpMessage = function(self, fid, lineWrap, notShowMessage)
  -- function num : 0_3 , upvalues : _ENV, cs_MessageCommon
  local des = FunctionUnlockMgr:GetFuncUnlockDecription(fid, lineWrap)
  if notShowMessage then
    return des
  end
  des = (string.format)(ConfigData:GetTipContent(TipContent.Jump_TargetFuncLocked), des)
  ;
  (cs_MessageCommon.ShowMessageTips)(des)
end

local notNeedBack2Home = {[(JumpManager.eJumpTarget).BuyStamina] = true, [(JumpManager.eJumpTarget).Home] = true, [(JumpManager.eJumpTarget).Setting] = true, [(JumpManager.eJumpTarget).UserCenter] = true}
local sectorTypes = {[(JumpManager.eJumpTarget).Sector] = true, [(JumpManager.eJumpTarget).ATHDungeon] = true, [(JumpManager.eJumpTarget).fragDungeon] = true, [(JumpManager.eJumpTarget).resourceDungeon] = true, [(JumpManager.eJumpTarget).DynSectorLevel] = true, [(JumpManager.eJumpTarget).DynCareerStO] = true, [(JumpManager.eJumpTarget).WeeklyChallenge] = true, [(JumpManager.eJumpTarget).DailyChallenge] = true, [(JumpManager.eJumpTarget).DungeonTower] = true}
local heroTypes = {[(JumpManager.eJumpTarget).Hero] = true}
local DormTypes = {[(JumpManager.eJumpTarget).Dorm] = true}
local SectorActivityType = {[eActivityType.SectorI] = true, [eActivityType.HeroGrow] = true, [eActivityType.SectorII] = true, [eActivityType.RefreshDun] = true, [eActivityType.Carnival] = true, [eActivityType.DailyChallenge] = true, [eActivityType.SectorIII] = true, [eActivityType.Hallowmas] = true, [eActivityType.Spring] = true, [eActivityType.Winter23] = true}
local NotNeedBack2HomeAct = {[eActivityType.WhiteDay] = true, [eActivityType.Spring] = true, [eActivityType.Winter23] = true, [eActivityType.Season] = true}
JumpManager.IsJumpNeedBack2Home = function(self, jumpType, argList)
  -- function num : 0_4 , upvalues : notNeedBack2Home, _ENV, HomeEnum, JumpManager, sectorTypes, heroTypes, DormTypes
  if notNeedBack2Home[jumpType] then
    return false
  end
  local homeCtrl = ControllerManager:GetController(ControllerTypeId.HomeController)
  local isInNormalHome = homeCtrl ~= nil and homeCtrl.homeState == (HomeEnum.eHomeState).Normal
  if isInNormalHome then
    return false
  end
  if jumpType == (JumpManager.eJumpTarget).DynShop and UIManager:GetWindow(UIWindowTypeID.ShopMain) ~= nil then
    return false
  end
  if sectorTypes[jumpType] and ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil then
    return false
  end
  if heroTypes[jumpType] and UIManager:GetWindow(UIWindowTypeID.HeroList) ~= nil then
    return false
  end
  if DormTypes[jumpType] and UIManager:GetWindow(UIWindowTypeID.DormMain) ~= nil then
    return false
  end
  if jumpType == (JumpManager.eJumpTarget).DynActivity then
    return self:IsThisActivityJump2Home(argList)
  end
  do return true end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

JumpManager.Add2OnHomeUIOpenListern = function(self, jumpfunc)
  -- function num : 0_5 , upvalues : _ENV
  self.back2HomeMsgFunc = function(isBackStackEmpty)
    -- function num : 0_5_0 , upvalues : _ENV, jumpfunc, self
    -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

    if not isBackStackEmpty then
      UIUtil.isRunningJump = true
    end
    if jumpfunc ~= nil then
      jumpfunc()
    end
    self.back2HomeMsgFunc = nil
  end

end

JumpManager.IsHaveBack2Home = function(self)
  -- function num : 0_6
  do return self.back2HomeMsgFunc ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

JumpManager.TryCallBack2HomeMsgFunc = function(self, isBackStackEmpty)
  -- function num : 0_7
  if self.back2HomeMsgFunc ~= nil then
    (self.back2HomeMsgFunc)(isBackStackEmpty)
    return true
  end
end

JumpManager.GetIsJumping = function(self)
  -- function num : 0_8
  return self.isJumping
end

JumpManager.__BeforeDirectJump = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local formationCtrl = ControllerManager:GetController(ControllerTypeId.Formation)
  if formationCtrl ~= nil then
    formationCtrl:RealExitFormation()
  end
  local dailyTaskCtrl = ControllerManager:GetController(ControllerTypeId.DailyDungeonLevelCtrl)
  if dailyTaskCtrl ~= nil then
    dailyTaskCtrl:ExitDailyDungeon()
  end
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:ExitSectorCtrl()
    sectorCtrl:Delete()
  end
  local dormCtrl = ControllerManager:GetController(ControllerTypeId.Dorm)
  if dormCtrl ~= nil then
    dormCtrl:Delete()
  end
  local lotterCtrl = ControllerManager:GetController(ControllerTypeId.Lottery)
  if lotterCtrl ~= nil then
    lotterCtrl:Delete()
  end
  local factoryCtrl = ControllerManager:GetController(ControllerTypeId.Factory)
  if factoryCtrl ~= nil then
    factoryCtrl:CloseFactory(true)
  end
  local actLobbyCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLobbyCtrl ~= nil then
    actLobbyCtrl:Delete()
  end
end

JumpManager.GetSectorJumpId = function(self)
  -- function num : 0_10
  return self.sectorJumpId
end

JumpManager.RecordSectorJumpId = function(self, id)
  -- function num : 0_11
  self.sectorJumpId = id
end

JumpManager.ClearSectorJumpId = function(self, id)
  -- function num : 0_12
  self.sectorJumpId = nil
end

JumpManager.Jump2Shop = function(self, shopid, jumpOverCallback)
  -- function num : 0_13
  self:Jump2DynShop(jumpOverCallback, {shopid})
end

JumpManager.Jump2ShopValidate = function(self, shopid)
  -- function num : 0_14 , upvalues : _ENV
  if type(shopid) == "table" then
    return self:Jump2DynShopValidate(shopid)
  else
    return self:Jump2DynShopValidate({shopid})
  end
end

JumpManager.Jump2Lottery = function(self, isNormal, jumpOverCallback)
  -- function num : 0_15
  if isNormal then
    self:Jump2DynLottery(jumpOverCallback, {2})
  else
    self:Jump2DynLottery(jumpOverCallback, {1})
  end
end

JumpManager.Jump2LotteryValidate = function(self, isNormal)
  -- function num : 0_16
  if isNormal then
    return self:Jump2DynLotteryValidate({2})
  else
    return self:Jump2DynLotteryValidate({1})
  end
end

JumpManager.Jump2Mail = function(self, jumpOverCallback)
  -- function num : 0_17 , upvalues : _ENV
  local isMailUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Mail)
  if not isMailUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Mail, true)
    return false
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Mail, function(win)
    -- function num : 0_17_0 , upvalues : jumpOverCallback
    if win ~= nil and jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
)
end

JumpManager.Jump2MailValidate = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local isMailUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Mail)
  if not isMailUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Mail, true)
    return false
  end
  return true
end

JumpManager.Jump2Hro = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_19 , upvalues : _ENV
  local hideWinList = nil
  local fromWhere = eBaseWinFromWhere.home
  local heroPotentialWin = UIManager:GetWindow(UIWindowTypeID.HeroPotential)
  if heroPotentialWin ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.HeroPotential, true)
  end
  local heroStateWin = UIManager:GetWindow(UIWindowTypeID.HeroState)
  if heroStateWin ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.HeroState, true)
  end
  local heroWin = UIManager:GetWindow(UIWindowTypeID.HeroList)
  if (heroWin == nil or not heroWin.active) and isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  if heroWin ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.HeroList)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroList, function(win)
    -- function num : 0_19_0 , upvalues : _ENV, isCoverJump, jumpCorverArgs, jumpOverCallback
    if win == nil then
      return 
    end
    local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
    if homeWindow ~= nil and not isCoverJump then
      homeWindow:OpenOtherWin()
    end
    win.jumpCorverArgs = jumpCorverArgs
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2HeroSkin = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_20 , upvalues : _ENV
  local hideWinList = nil
  local fromWhere = eBaseWinFromWhere.home
  if isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
    -- function num : 0_20_0 , upvalues : argList, _ENV, jumpCorverArgs, jumpOverCallback
    if win == nil then
      return 
    end
    local skinId = argList[1]
    local heroId = (PlayerDataCenter.skinData):GetHeroIdBySkinId(skinId)
    local heroCfg = (ConfigData.hero_data)[heroId]
    local skinIds = {heroCfg.default_skin}
    for i,v in ipairs(heroCfg.skin) do
      if (PlayerDataCenter.skinData):IsSkinUnlocked(v) then
        (table.insert)(skinIds, v)
      end
    end
    win:InitSkinBySkinList(skinId, skinIds, nil, nil)
    win.jumpCorverArgs = jumpCorverArgs
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2HroValidate = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local isHeroListUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroGroup)
  if not isHeroListUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroGroup, true)
    return false
  end
  return true
end

JumpManager.Jump2HeroSkinValidate = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local isHeroListUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroGroup)
  if not isHeroListUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroGroup, true)
    return false
  end
  return true
end

JumpManager.Jump2Sector = function(self, jumpOverCallback, argList)
  -- function num : 0_23 , upvalues : _ENV
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  local doNotOpenEpStages = false
  if argList ~= nil then
    doNotOpenEpStages = argList[1]
  end
  ;
  (Home.homeRightNode):OnClickEpBtn(doNotOpenEpStages)
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

JumpManager.Jump2SectorValidate = function(self, argList)
  -- function num : 0_24
  return true
end

JumpManager.Jump2Oasis = function(self, jumpOverCallback)
  -- function num : 0_25 , upvalues : _ENV
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  if Home == nil then
    return 
  end
  ;
  (Home.homeRightNode):OnClickOasisBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
end

JumpManager.Jump2OasisValidate = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local isOasisUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Building)
  if not isOasisUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Building, true)
    return false
  end
  return true
end

JumpManager.Jump2Factory = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_27 , upvalues : _ENV
  if not isCoverJump then
    local Home = UIManager:GetWindow(UIWindowTypeID.Home)
    ;
    (Home.homeRightNode):OnClickFactoryBtn()
  else
    do
      self:__BeforeDirectJump()
      ;
      (ControllerManager:GetController(ControllerTypeId.Factory, true)):OpenFactory()
      if jumpOverCallback ~= nil then
        jumpOverCallback()
      end
    end
  end
end

JumpManager.Jump2FactoryValidate = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local isFactoryUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Factory)
  if not isFactoryUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Factory, true)
    return false
  end
  return true
end

JumpManager.Jump2Task = function(self, taskTypeID, jumpOverCallback, arglist, isCoverJump, jumpCorverArgs)
  -- function num : 0_29
  self:Jump2DynTask(jumpOverCallback, {taskTypeID}, isCoverJump, jumpCorverArgs)
end

JumpManager.Jump2TaskValidate = function(self, taskTypeID)
  -- function num : 0_30
  return self:Jump2DynTaskValidate({taskTypeID})
end

JumpManager.Jump2Achievement = function(self, achievementTypeID, jumpOverCallback, arglist, isCoverJump, jumpCorverArgs)
  -- function num : 0_31 , upvalues : _ENV
  local fromWhere = eBaseWinFromWhere.home
  local hideWinList = nil
  if isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.AchievementSystem, function(win)
    -- function num : 0_31_0 , upvalues : _ENV, isCoverJump, jumpOverCallback, jumpCorverArgs
    do
      if win ~= nil then
        local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
        if homeWindow ~= nil and not isCoverJump then
          homeWindow:OpenOtherWin()
        end
        win:InitAchievement(nil, Home ~= nil)
        if jumpOverCallback ~= nil then
          jumpOverCallback()
        end
        win.jumpCorverArgs = jumpCorverArgs
      end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2AchievementValidate = function(self, achievementTypeID)
  -- function num : 0_32 , upvalues : _ENV
  local isAchUIUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Achievement)
  if not isAchUIUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Achievement, true)
    return false
  end
  return true
end

JumpManager.Jump2BuyStamina = function(self, jumpOverCallback, argList)
  -- function num : 0_33 , upvalues : _ENV
  local ShopEnum = require("Game.Shop.ShopEnum")
  local quickBuyData = (ShopEnum.eQuickBuy).stamina
  local shopId = quickBuyData.shopId
  local shelfId = quickBuyData.shelfId
  local goodData = nil
  local ctrl = (ControllerManager:GetController(ControllerTypeId.Shop, true))
  local needNum, closeCallback = nil, nil
  if argList ~= nil then
    needNum = argList[1]
    closeCallback = argList[2]
  end
  local buyKeyWin = UIManager:GetWindow(UIWindowTypeID.QuickBuyKey)
  if buyKeyWin ~= nil then
    -- DECOMPILER ERROR at PC32: Unhandled construct in 'MakeBoolean' P1

    if buyKeyWin.active and jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  ctrl:GetShopData(shopId, function(shopData)
    -- function num : 0_33_0 , upvalues : goodData, shelfId, _ENV, jumpOverCallback, needNum, closeCallback
    goodData = (shopData.shopGoodsDic)[shelfId]
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuyKey, function(win)
      -- function num : 0_33_0_0 , upvalues : _ENV, jumpOverCallback, needNum, goodData, closeCallback
      if win == nil then
        error("can\'t open QuickBuy win")
        if jumpOverCallback ~= nil then
          jumpOverCallback()
        end
        return 
      end
      if not ExplorationManager:IsInExploration() then
        local isHideLeftBtn = WarChessManager:GetIsInWarChess()
      end
      win:SlideIn(true, isHideLeftBtn)
      win:InitQuickPurchaseKey(nil, needNum, goodData, closeCallback)
      if jumpOverCallback ~= nil then
        jumpOverCallback()
      end
    end
)
  end
)
end

JumpManager.Jump2BuyStaminaValidate = function(self)
  -- function num : 0_34 , upvalues : _ENV
  local ctrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  if not ctrl:GetIsUnlock() then
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.notUnlockShopCantBuyStamina))
    return false
  end
  return true
end

JumpManager.Jump2DailyChallenge = function(self, jumpOverCallback)
  -- function num : 0_35 , upvalues : _ENV
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    ;
    (sectorController.uiCanvas):OnClickDailyDungeon()
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_35_0 , upvalues : _ENV, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    ;
    (sectorController.uiCanvas):OnClickDailyDungeon()
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.Jump2DailyChallengeValidate = function(self)
  -- function num : 0_36 , upvalues : _ENV
  local isDailyChallengeUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_DailyDungeon)
  if not isDailyChallengeUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_DailyDungeon, true)
    return false
  end
  return true
end

JumpManager.Jump2WeeklyChallenge = function(self, jumpOverCallback)
  -- function num : 0_37 , upvalues : _ENV
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    ;
    (sectorController.uiCanvas):OnClickWeeklyChallenge()
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_37_0 , upvalues : _ENV, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    ;
    (sectorController.uiCanvas):OnClickWeeklyChallenge()
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.Jump2WeeklyChallengeValidate = function(self)
  -- function num : 0_38 , upvalues : _ENV
  local isWeeklyChallengeUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge)
  if not isWeeklyChallengeUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge, true)
    return false
  end
  if not (PlayerDataCenter.allWeeklyChallengeData):IsExistChallenge() then
    error("weeklyChallenges count is 0")
    return false
  end
  return true
end

JumpManager.Jump2Dorm = function(self, jumpOverCallback)
  -- function num : 0_39 , upvalues : _ENV
  if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.DormMain) then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.DormMain)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  ;
  (Home.homeRightNode):OnClickDormBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
end

JumpManager.Jump2ShopBase = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_40 , upvalues : JumpManager, _ENV
  local isShopShowBeforeUnlock = JumpManager:Jump2DynShopBeforeUnlock(argList)
  if isShopShowBeforeUnlock == false and not JumpManager:Jump2DynShopValidate(argList) then
    return 
  end
  local fromWhere = eBaseWinFromWhere.home
  local hideWinList = nil
  if isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  local shopId, shopDataId, shopPageId = nil, nil, nil
  if argList ~= nil then
    shopId = argList[1]
    shopDataId = argList[2]
    shopPageId = argList[3]
  end
  local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
  if shopWin ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ShopMain, false)
    if isShopShowBeforeUnlock then
      if shopId == nil then
        shopWin:InitShopMainBeforeUnlock()
      else
        shopWin:InitShopMainBeforeUnlock(shopId, shopDataId, shopPageId)
      end
    else
      if shopId == nil then
        shopWin:InitShop()
      else
        shopWin:InitShop(shopId, shopDataId, shopPageId)
      end
    end
    return 
  end
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.ShopMain, function(win)
    -- function num : 0_40_0 , upvalues : isShopShowBeforeUnlock, shopId, shopDataId, shopPageId, jumpCorverArgs, _ENV, isCoverJump, jumpOverCallback
    if win ~= nil then
      if isShopShowBeforeUnlock then
        if shopId == nil then
          win:InitShopMainBeforeUnlock()
        else
          win:InitShopMainBeforeUnlock(shopId, shopDataId, shopPageId)
        end
      else
        if shopId == nil then
          win:InitShop()
        else
          win:InitShop(shopId, shopDataId, shopPageId)
        end
      end
      win.jumpCorverArgs = jumpCorverArgs
      local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
      if homeWindow ~= nil and not isCoverJump then
        homeWindow:OpenOtherWin()
      end
      if jumpOverCallback ~= nil then
        jumpOverCallback()
      end
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2DormValidate = function(self)
  -- function num : 0_41 , upvalues : _ENV
  local isDormUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm)
  if not isDormUnlock then
    return false
  end
  return true
end

JumpManager.Jump2ShopBaseValidate = function(self)
  -- function num : 0_42
  return true
end

JumpManager.Jump2StrategyOverview = function(self, jumpOverCallback, argList)
  -- function num : 0_43 , upvalues : _ENV
  local sectorId = argList ~= nil and argList[1] or nil
  local buildId = argList ~= nil and argList[2] or nil
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    sectorController:ShowStrategyOverview(sectorId, buildId)
  else
    local Home = UIManager:GetWindow(UIWindowTypeID.Home)
    Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_43_0 , upvalues : _ENV, sectorId, buildId, jumpOverCallback
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    sectorController:ShowStrategyOverview(sectorId, buildId)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
)
    ;
    (Home.homeRightNode):OnClickEpBtn()
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

JumpManager.Jump2StrategyOverviewValidate = function(self, argList)
  -- function num : 0_44 , upvalues : _ENV, cs_MessageCommon
  local isAllow = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorBuilding)
  if not isAllow then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorBuilding, true)
  end
  do
    if argList ~= nil and #argList > 0 then
      local sectorId = argList[1]
      isAllow = (PlayerDataCenter.sectorStage):IsSectorUnlock(sectorId)
      if not isAllow then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Sector_Locked))
      end
    end
    return isAllow
  end
end

JumpManager.Jump2OasisBuilding = function(self, jumpOverCallback, argList)
  -- function num : 0_45 , upvalues : _ENV
  local buildId = argList[1]
  local oasisController = ControllerManager:GetController(ControllerTypeId.OasisController, true)
  if (oasisController.buildingItems)[buildId] == nil then
    self:Jump2Oasis(jumpOverCallback)
    return 
  end
  local Oasis = UIManager:GetWindow(UIWindowTypeID.OasisMain)
  if Oasis ~= nil then
    oasisController:BuildingUpgrade(buildId)
    return 
  else
    local Home = UIManager:GetWindow(UIWindowTypeID.Home)
    if Home == nil then
      return 
    end
    if Home.sideWin ~= nil then
      (Home.sideWin):Delete()
      Home.sideWin = nil
    end
    oasisController:InjectJumpEvent(function()
    -- function num : 0_45_0 , upvalues : oasisController, buildId
    oasisController.selectBuiltId = nil
    oasisController:BuildingUpgrade(buildId, true)
  end
)
    ;
    (Home.homeRightNode):OnClickOasisBtn()
    oasisController.selectBuiltId = buildId
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
end

JumpManager.Jump2OasisBuildingValidate = function(self, argList)
  -- function num : 0_46 , upvalues : _ENV
  local isOasisUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Building)
  if not isOasisUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Building, true)
    return false
  end
  return true
end

JumpManager.Jump2SectorFragDungeon = function(self, jumpOverCallback, argList)
  -- function num : 0_47 , upvalues : _ENV
  local heroId = nil
  if argList[1] ~= 0 and (PlayerDataCenter.heroDic)[heroId] ~= nil then
    heroId = argList[1]
  end
  self:RecordSectorJumpId(22)
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    ;
    (sectorController.uiCanvas):EnterFriendshipDungeon(heroId, true)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_47_0 , upvalues : _ENV, heroId, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    ;
    (sectorController.uiCanvas):EnterFriendshipDungeon(heroId, true)
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.Jump2SectorFragDungeonValidate = function(self, argList, notShowMessage)
  -- function num : 0_48 , upvalues : _ENV, cs_MessageCommon
  local isFragDungeonUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_friendship_sector_Ui)
  do
    if not isFragDungeonUnlock then
      local unlockNotice = self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_friendship_sector_Ui, true, notShowMessage)
      return false, unlockNotice
    end
    local heroId = argList[1]
    if heroId == nil then
      return true
    end
    local heroData = (PlayerDataCenter.heroDic)[heroId]
    if heroData == nil then
      return false
    end
    local frageDungeonData = nil
    local DungeonData = require("Game.Dungeon.DungeonData")
    frageDungeonData = (DungeonData.CreateDungeonData4Frage)(nil, heroData)
    local isFrageUnlock = frageDungeonData:UnlockAndHasStageOpen()
    if not isFrageUnlock then
      local stageCfg = frageDungeonData:GetNewLockStage()
      local unlockNotice = (CheckCondition.GetUnlockInfoLua)(stageCfg.pre_condition, stageCfg.pre_para1, stageCfg.pre_para2)
      do
        do
          if not notShowMessage then
            local des = (string.format)(ConfigData:GetTipContent(TipContent.Jump_TargetFuncLocked), unlockNotice)
            ;
            (cs_MessageCommon.ShowMessageTips)(des)
          end
          do return false, unlockNotice end
          return true
        end
      end
    end
  end
end

JumpManager.Jump2SectorResourceDungeon = function(self, jumpOverCallback, argList)
  -- function num : 0_49 , upvalues : _ENV
  local typeID = argList[1]
  self:RecordSectorJumpId(11)
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    ;
    (sectorController.uiCanvas):EnterMatDungeon(typeID, true)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_49_0 , upvalues : _ENV, typeID, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    ;
    (sectorController.uiCanvas):EnterMatDungeon(typeID, true)
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.Jump2SectorResourceDungeonValidate = function(self, argList, notShowMessage)
  -- function num : 0_50 , upvalues : _ENV
  local isMatDungeonUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_MaterialDungeon)
  do
    if not isMatDungeonUnlock then
      local unlockNotice = self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_MaterialDungeon, true, notShowMessage)
      return false, unlockNotice
    end
    local typeID = argList[1]
    if typeID == nil or (ConfigData.material_dungeon)[typeID] == nil then
      error("bad jump arg Jump2SectorFragDungeon typeID:" .. tostring(typeID))
      return false
    end
    local isSpecificDungeonUnlock = FunctionUnlockMgr:ValidateUnlock(typeID)
    do
      if not isSpecificDungeonUnlock then
        local unlockNotice = self:__ShowCanotJumpMessage(typeID, true, notShowMessage)
        return false, unlockNotice
      end
      return true
    end
  end
end

JumpManager.Jump2SectorATHDungeon = function(self, jumpOverCallback, argList)
  -- function num : 0_51 , upvalues : _ENV
  local typeID = argList[1]
  self:RecordSectorJumpId(13)
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    ;
    (sectorController.uiCanvas):EnterATHDungeon(typeID, true)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_51_0 , upvalues : _ENV, typeID, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    sectorController:OnEnterPlotOrMateralDungeon()
    ;
    (sectorController.uiCanvas):EnterATHDungeon(typeID, true)
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.Jump2SectorATHDungeonValidate = function(self, argList, notShowMessage)
  -- function num : 0_52 , upvalues : _ENV
  local isATHDungeonUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_ATHDungeon)
  do
    if not isATHDungeonUnlock then
      local unlockNotice = self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_ATHDungeon, true, notShowMessage)
      return false, unlockNotice
    end
    local typeID = argList[1]
    if typeID == nil or (ConfigData.material_dungeon)[typeID] == nil then
      error("bad jump arg Jump2SectorATHDungeon typeID:" .. tostring(typeID))
      return false
    end
    return true
  end
end

JumpManager.Jump2DynTask = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_53 , upvalues : _ENV
  local hideWinList = nil
  local fromWhere = eBaseWinFromWhere.home
  local taskWin = UIManager:GetWindow(UIWindowTypeID.Task)
  if (taskWin == nil or not taskWin.active) and isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  local typeID = nil
  if argList ~= nil then
    typeID = argList[1]
  end
  local taskController = ControllerManager:GetController(ControllerTypeId.Task, true)
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  taskController:ShowTaskUI(typeID, fromWhere, function()
    -- function num : 0_53_0 , upvalues : jumpOverCallback, _ENV, isCoverJump, jumpCorverArgs
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
    if homeWindow ~= nil and not isCoverJump then
      homeWindow:OpenOtherWin()
    end
    local taskWin = UIManager:GetWindow(UIWindowTypeID.Task)
    if taskWin ~= nil then
      taskWin.jumpCorverArgs = jumpCorverArgs
    end
  end
)
end

JumpManager.Jump2DynTaskValidate = function(self, argList)
  -- function num : 0_54 , upvalues : _ENV
  local isTaskUIUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_TaskUi)
  if not isTaskUIUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_TaskUi, true)
    return false
  end
  local taskController = (ControllerManager:GetController(ControllerTypeId.Task, true))
  local typeID = nil
  if argList ~= nil then
    typeID = argList[1]
  end
  if typeID == nil then
    return true
  end
  local PageGroupList = taskController:GetPageGroupList()
  for _,group in pairs(PageGroupList) do
    for _,typeId in pairs(group) do
      if typeID == typeId then
        return true
      end
    end
  end
  return false
end

JumpManager.Jump2DynShop = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_55 , upvalues : _ENV
  local fromWhere = eBaseWinFromWhere.home
  local hideWinList = nil
  if isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  local shopId, shopDataId, shopPageId = nil, nil, nil
  if argList ~= nil then
    shopId = argList[1]
    shopDataId = argList[2]
    shopPageId = argList[3]
  end
  local shopWin = UIManager:GetWindow(UIWindowTypeID.ShopMain)
  if shopWin ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ShopMain, false)
    if shopId == nil then
      shopWin:InitShop()
    else
      shopWin:InitShop(shopId, shopDataId, shopPageId)
    end
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.ShopMain, function(win)
    -- function num : 0_55_0 , upvalues : jumpCorverArgs, shopId, shopDataId, shopPageId, _ENV, isCoverJump, jumpOverCallback
    if win ~= nil then
      win.jumpCorverArgs = jumpCorverArgs
      if shopId == nil then
        win:InitShop()
      else
        win:InitShop(shopId, shopDataId, shopPageId)
      end
      local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
      if homeWindow ~= nil and not isCoverJump then
        homeWindow:OpenOtherWin()
      end
      if jumpOverCallback ~= nil then
        jumpOverCallback()
      end
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2DynShopValidate = function(self, argList, notShowMessage)
  -- function num : 0_56 , upvalues : _ENV
  local isShopUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store)
  do
    if not isShopUnlock then
      local unlockNotice = self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Store, true, notShowMessage)
      return false, unlockNotice
    end
    local shopId = argList[1]
    if shopId == nil or (ConfigData.shop)[shopId] == nil then
      return false
    end
    local ShopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
    local isUnlcok, unlockNotice = ShopController:ShopIsUnlock(shopId)
    return isUnlcok, unlockNotice
  end
end

JumpManager.Jump2DynShopBeforeUnlock = function(self, argList, notShowMessage)
  -- function num : 0_57 , upvalues : _ENV
  local shopId = argList[1]
  if shopId == nil or (ConfigData.shop)[shopId] == nil then
    return false
  end
  local ShopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
  if not ShopController:ShopShowBeforeUnlock(shopId) then
    return false
  end
  local isUnlcok, unlockNotice = ShopController:ShopIsUnlock(shopId)
  local isShopUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store)
  if isUnlcok == true and isShopUnlock == false then
    return true
  else
    return false
  end
end

JumpManager.Jump2DynSectorLevel = function(self, jumpOverCallback, argList)
  -- function num : 0_58 , upvalues : JumpManager, _ENV
  local id, isActId, afterEnterLevelFunc = nil, nil, nil
  if argList ~= nil then
    id = argList[1]
    isActId = argList[2]
    afterEnterLevelFunc = argList[3]
  end
  if id == nil then
    JumpManager:Jump2Sector(jumpOverCallback)
    return 
  end
  local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
  local isSuccess = (whiteDayCtrl ~= nil and whiteDayCtrl:TryEnterWDSector(id))
  -- DECOMPILER ERROR at PC31: Unhandled construct in 'MakeBoolean' P1

  if isSuccess and jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  do return  end
  local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if winter23Ctrl ~= nil then
    isSuccess = winter23Ctrl:TryEnterWTSector(id)
  else
    isSuccess = false
  end
  -- DECOMPILER ERROR at PC52: Unhandled construct in 'MakeBoolean' P1

  if isSuccess and jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  do return  end
  if not isActId then
    self:RecordSectorJumpId(id * 10)
  else
    self:RecordSectorJumpId(0)
  end
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if not isActId then
      sectorController:OnSectorItemClicked(id)
    else
      sectorController:OpenActByActFramId(id)
    end
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    if afterEnterLevelFunc ~= nil then
      afterEnterLevelFunc()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_58_0 , upvalues : _ENV, isActId, id, afterEnterLevelFunc, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    if not isActId then
      sectorController:OnSectorItemClicked(id)
    else
      sectorController:OpenActByActFramId(id)
    end
    if afterEnterLevelFunc ~= nil then
      afterEnterLevelFunc()
    end
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 17 unprocessed JMP targets
end

JumpManager.Jump2DynSectorLevelValidate = function(self, argList)
  -- function num : 0_59
  if argList == nil or argList[1] == nil then
    return false
  end
  return true
end

JumpManager.Jump2DynLottery = function(self, jumpOverCallback, argList)
  -- function num : 0_60 , upvalues : _ENV
  local poolId = nil
  if argList ~= nil then
    poolId = argList[1]
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  ;
  (Home.homeRightNode):OnClickLotteryBtn(poolId)
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
end

JumpManager.Jump2DynLotteryValidate = function(self, argList)
  -- function num : 0_61 , upvalues : _ENV
  local isLotteryUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Lottery)
  if not isLotteryUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_Lottery, true)
    return false
  end
  return true
end

JumpManager.Jump2DynActivity = function(self, jumpOverCallback, argList)
  -- function num : 0_62 , upvalues : _ENV, cs_MessageCommon, eActivityType, SectorActivityType
  local activityFrameCtrl = (ControllerManager:GetController(ControllerTypeId.ActivityFrame))
  local activityId, category, actSpecialJumpId, isNeedActInRunning = nil, nil, nil, nil
  if argList ~= nil then
    activityId = argList[1]
    category = argList[2]
    actSpecialJumpId = argList[3]
    isNeedActInRunning = argList[4] == 1
  end
  local activityFrameData = nil
  if activityId or 0 > 0 then
    activityFrameData = activityFrameCtrl:GetActivityFrameData(activityId)
    category = activityFrameData:GetEnterType()
    if activityFrameData ~= nil and isNeedActInRunning and not activityFrameData:IsInRuningState() then
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(6033))
      return 
    end
  end
  if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.SectorI then
    local sectorICfg = (ConfigData.activity_time_limit)[activityFrameData.actId]
    do
      do
        do
          if sectorICfg.hard_stage or sectorICfg == nil or 0 > 0 then
            local arg = {sectorICfg.hard_stage}
            do
              self:Jump2DynSectorLevel(jumpOverCallback, arg)
            end
          end
          return 
        end
        if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.HeroGrow then
          local sectorICfg = (ConfigData.activity_hero)[activityFrameData.actId]
          do
            do
              if sectorICfg.main_stage or sectorICfg == nil or 0 > 0 then
                local arg = {sectorICfg.main_stage}
                self:Jump2DynSectorLevel(jumpOverCallback, arg)
              end
              do return  end
              do
                if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.WhiteDay then
                  local AWDCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
                  if activityFrameData:IsActivityRunningTimeout() then
                    if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.WhiteDayAlbum) then
                      (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.WhiteDayAlbum, false)
                    else
                      local AWDData = AWDCtrl:GetWhiteDayDataByActId(activityFrameData:GetActId())
                      UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayAlbum, function(window)
    -- function num : 0_62_0 , upvalues : AWDCtrl, AWDData
    if window == nil then
      return 
    end
    window:InitWDAlbun(AWDCtrl, AWDData)
  end
)
                    end
                    return 
                  end
                  if UIManager:GetWindow(UIWindowTypeID.WhiteDay) ~= nil then
                    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.WhiteDay, false)
                  else
                    self:__BeforeDirectJump()
                  end
                  AWDCtrl:TryOpenWhiteDay(activityFrameData:GetActId(), function()
    -- function num : 0_62_1 , upvalues : actSpecialJumpId, _ENV
    if actSpecialJumpId == 1 then
      local win2048 = UIManager:GetWindow(UIWindowTypeID.WhiteDay2048)
      if win2048 == nil then
        local win = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
        if win ~= nil then
          win:OnClickWDMiniGame()
        end
      end
    end
  end
)
                  if jumpOverCallback ~= nil then
                    jumpOverCallback()
                  end
                  return 
                end
                do
                  if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.Spring then
                    local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
                    if springCtrl ~= nil then
                      local actId = activityFrameData:GetActId()
                      local actLobbyCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
                      if actSpecialJumpId == nil or actSpecialJumpId == 0 then
                        if actLobbyCtrl == nil then
                          self:__BeforeDirectJump()
                          springCtrl:OpenSpring(actId)
                        else
                          (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActLobbyMain, false)
                        end
                      elseif actLobbyCtrl == nil then
                        self:__BeforeDirectJump()
                        springCtrl:OpenSpring(actId, true, function()
    -- function num : 0_62_2 , upvalues : springCtrl, actSpecialJumpId
    springCtrl:Spirng23OpenObj(actSpecialJumpId)
  end
)
                      else
                        springCtrl:Spirng23OpenObj(actSpecialJumpId)
                      end
                    end
                    if jumpOverCallback ~= nil then
                      jumpOverCallback()
                    end
                    return 
                  end
                  do
                    if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.Winter23 then
                      local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
                      if winter23Ctrl ~= nil then
                        local actId = activityFrameData:GetActId()
                        local actLobbyCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
                        if actSpecialJumpId == nil or actSpecialJumpId == 0 then
                          if actLobbyCtrl == nil then
                            self:__BeforeDirectJump()
                            winter23Ctrl:OpenWinter23(actId)
                          else
                            (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActLobbyMain, false)
                          end
                        elseif actLobbyCtrl == nil then
                          self:__BeforeDirectJump()
                          winter23Ctrl:OpenWinter23(actId, true, function()
    -- function num : 0_62_3 , upvalues : winter23Ctrl, actSpecialJumpId
    winter23Ctrl:OpenWinter23Obj(actSpecialJumpId)
  end
)
                        else
                          winter23Ctrl:OpenWinter23Obj(actSpecialJumpId)
                        end
                      end
                      if jumpOverCallback ~= nil then
                        jumpOverCallback()
                      end
                      return 
                    end
                    do
                      if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.Season then
                        local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
                        if seasonCtrl ~= nil then
                          local actId = activityFrameData:GetActId()
                          local actLobbyCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
                          if actSpecialJumpId == nil or actSpecialJumpId == 0 then
                            if actLobbyCtrl == nil then
                              self:__BeforeDirectJump()
                              seasonCtrl:OpenSeason(actId)
                            else
                              (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActLobbyMain, false)
                            end
                          elseif actLobbyCtrl == nil then
                            self:__BeforeDirectJump()
                            seasonCtrl:OpenSeason(actId, true, function()
    -- function num : 0_62_4 , upvalues : seasonCtrl, actSpecialJumpId
    seasonCtrl:OpenSeasonObj(actSpecialJumpId)
  end
)
                          else
                            seasonCtrl:OpenSeasonObj(actSpecialJumpId)
                          end
                        end
                        if jumpOverCallback ~= nil then
                          jumpOverCallback()
                        end
                        return 
                      end
                      if activityFrameData ~= nil and SectorActivityType[activityFrameData.actCat] then
                        self:Jump2DynSectorLevel(jumpOverCallback, {activityId, true})
                        return 
                      end
                      do
                        if activityFrameData ~= nil and activityFrameData.actCat == eActivityType.HistoryTinyGame then
                          local historyTinyGameCtrl = ControllerManager:GetController(ControllerTypeId.HistoryTinyGameActivity)
                          if historyTinyGameCtrl ~= nil then
                            historyTinyGameCtrl:TryOpenHistoryTinyGame((activityFrameData:GetActId()), nil, true)
                          end
                          return 
                        end
                        if category or 0 == 0 or not activityFrameCtrl:IsHaveShowByEnterType(category) then
                          category = activityFrameCtrl:GetAutoJumpTargetActivity()
                        end
                        local Home = UIManager:GetWindow(UIWindowTypeID.Home)
                        if Home ~= nil then
                          (Home.homeLeftNode):OnClickActivity(category, activityId)
                        end
                        if jumpOverCallback ~= nil then
                          jumpOverCallback()
                        end
                        -- DECOMPILER ERROR: 46 unprocessed JMP targets
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

JumpManager.Jump2DynActivityValidate = function(self, argList, withoutMessage)
  -- function num : 0_63 , upvalues : _ENV, cs_MessageCommon
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  if activityFrameCtrl == nil then
    return false
  end
  if argList[1] or argList == nil or 0 > 0 then
    local activityId = argList[1]
    local activityFrameData = activityFrameCtrl:GetActivityFrameData(activityId)
    if activityFrameData == nil then
      return false
    end
    if not activityFrameData:GetCouldShowActivity() then
      do
        do
          if not activityFrameData:GetIsActivityUnlock() and not withoutMessage then
            local des = activityFrameData:GetLockTip()
            ;
            (cs_MessageCommon.ShowMessageTips)(des)
          end
          do return false end
          do
            local couldJumpEnterType = activityFrameCtrl:GetIsHaveUnlockedActivity()
            if couldJumpEnterType == nil then
              return false
            end
            return true
          end
        end
      end
    end
  end
end

JumpManager.IsThisActivityJump2Home = function(self, argList)
  -- function num : 0_64 , upvalues : _ENV, SectorActivityType, NotNeedBack2HomeAct
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityId = argList[1]
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(activityId)
  if activityFrameData == nil then
    return true
  end
  local actCat = activityFrameData.actCat
  local sectorAct = not SectorActivityType[actCat] or ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  local notNeedBackAct = NotNeedBack2HomeAct[actCat]
  do return (not sectorAct and not notNeedBackAct) end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.DirectShowShop = function(self, beforeJumpCallback, jumpOverCallback, shopId, unCtrlTopbtn)
  -- function num : 0_65 , upvalues : JumpManager, _ENV
  local argList = {shopId}
  local isShopShowBeforeUnlock = JumpManager:Jump2DynShopBeforeUnlock(argList)
  if isShopShowBeforeUnlock == false and not JumpManager:Jump2DynShopValidate(argList) then
    return 
  end
  if beforeJumpCallback ~= nil then
    beforeJumpCallback()
  end
  local fromWhere = eBaseWinFromWhere.jumpCorver
  local hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(nil)}
  UIManager:ShowWindowAsync(UIWindowTypeID.ShopMain, function(win)
    -- function num : 0_65_0 , upvalues : isShopShowBeforeUnlock, shopId, jumpCorverArgs, unCtrlTopbtn, _ENV, jumpOverCallback
    if win == nil then
      return 
    end
    if isShopShowBeforeUnlock then
      win:InitShopMainBeforeUnlock(shopId)
    else
      win:InitShop(shopId)
    end
    win.jumpCorverArgs = jumpCorverArgs
    if not unCtrlTopbtn then
      (UIUtil.SetTopStatusBtnShow)(false, false)
    end
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2DynWarehouseValidate = function(self, argList)
  -- function num : 0_66 , upvalues : _ENV
  return FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Backpack_ui)
end

JumpManager.Jump2DynWarehouse = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_67 , upvalues : _ENV
  local hideWinList = nil
  local fromWhere = eBaseWinFromWhere.home
  local wareHouseWin = UIManager:GetWindow(UIWindowTypeID.Warehouse)
  if (wareHouseWin == nil or not wareHouseWin.active) and isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  local itemId = argList ~= nil and argList[1] or nil
  local openType = argList ~= nil and argList[2] or nil
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.Warehouse, function(window)
    -- function num : 0_67_0 , upvalues : _ENV, isCoverJump, itemId, openType, jumpCorverArgs, jumpOverCallback
    local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
    if homeWindow ~= nil and not isCoverJump then
      homeWindow:OpenOtherWin()
    end
    window:InitWarehouse(itemId, openType)
    window.jumpCorverArgs = jumpCorverArgs
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2SettingValidate = function(self)
  -- function num : 0_68
  return true
end

JumpManager.Jump2Setting = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_69 , upvalues : _ENV
  local oringLayoutLevel = (UIWindowGlobalConfig[UIWindowTypeID.Setting]).LayoutLevel
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (UIWindowGlobalConfig[UIWindowTypeID.Setting]).LayoutLevel = EUILayoutLevel.OverHigh
  UIManager:ShowWindowAsync(UIWindowTypeID.Setting, function(win)
    -- function num : 0_69_0 , upvalues : _ENV, oringLayoutLevel
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

    if win ~= nil then
      ((win.ui).background).enabled = false
      win:SetFromWhichUI(nil)
      local topWin = UIManager:GetWindow(UIWindowTypeID.TopStatus)
      do
        local isHaveTopStatus = (topWin ~= nil and topWin.active)
        if isHaveTopStatus then
          (UIUtil.HideTopStatus)()
        end
        win:SetUIMailHideCallback(function()
      -- function num : 0_69_0_0 , upvalues : isHaveTopStatus, _ENV
      if isHaveTopStatus then
        (UIUtil.ReShowTopStatus)()
      end
    end
)
        win:InitSettingByFrom()
        -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

        ;
        (UIWindowGlobalConfig[UIWindowTypeID.Setting]).LayoutLevel = oringLayoutLevel
      end
    end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
end

JumpManager.Jump2UserCenterValidate = function(self)
  -- function num : 0_70
  return true
end

JumpManager.Jump2UserCenter = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_71 , upvalues : _ENV
  if not ((CS.MicaSDKManager).Instance):IsUseSdk() then
    warn("当前未使用SDK，无法转跳到用户中心")
  end
  ;
  ((CS.MicaSDKManager).Instance):OpenUserCenter()
end

JumpManager.Jump2UserInfoPageValidate = function(self)
  -- function num : 0_72 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_CommanderInformation)
  if not isUnlock then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_CommanderInformation, true)
  end
  return isUnlock
end

JumpManager.Jump2UserInfoPage = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_73 , upvalues : _ENV
  local hideWinList = nil
  local fromWhere = eBaseWinFromWhere.home
  local userInfoWin = UIManager:GetWindow(UIWindowTypeID.UserInfo)
  if (userInfoWin == nil or not userInfoWin.active) and isCoverJump then
    if jumpCorverArgs ~= nil then
      hideWinList = jumpCorverArgs.hideWinList
    else
      hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true})
    end
    fromWhere = eBaseWinFromWhere.jumpCorver
  end
  if userInfoWin ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.UserInfo)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local jumpCorverArgs = {hideWinList = hideWinList, befroeJumpCouldUseItemJump = self:GetBefroeJumpCouldUseItemJump(jumpCorverArgs)}
  UIManager:ShowWindowAsync(UIWindowTypeID.UserInfo, function(win)
    -- function num : 0_73_0 , upvalues : _ENV, isCoverJump, jumpCorverArgs, jumpOverCallback
    if win ~= nil then
      local homeWindow = UIManager:GetWindow(UIWindowTypeID.Home)
      if homeWindow ~= nil and not isCoverJump then
        homeWindow:OpenOtherWin()
      end
      win.jumpCorverArgs = jumpCorverArgs
      win:InitUserInfo()
      if jumpOverCallback ~= nil then
        jumpOverCallback()
      end
    end
  end
, nil, fromWhere)
end

JumpManager.Jump2WinterActivityTech = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_74 , upvalues : _ENV
  local actId = 11001
  if argList and argList[1] then
    actId = argList[1]
  end
  self:Jump2DynSectorLevel(jumpOverCallback, {actId, true, function()
    -- function num : 0_74_0 , upvalues : _ENV
    local win = UIManager:GetWindow(UIWindowTypeID.Win21SectorBar)
    if win ~= nil then
      win:__OnClickOpenTech()
    end
  end
})
  return 
end

JumpManager.Jump2WinterActivityTechValidate = function(self)
  -- function num : 0_75 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter) then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, true)
    return false
  end
  local SectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if SectorIICtrl == nil then
    return false
  end
  return true
end

JumpManager.Jump2DungeonTower = function(self, jumpOverCallback, argList, isCoverJump, jumpCorverArgs)
  -- function num : 0_76 , upvalues : _ENV
  self:RecordSectorJumpId(27)
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    ;
    (sectorController.uiCanvas):OnClickDungeonTower(true)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_76_0 , upvalues : _ENV, self
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    sectorController:OnEnterDungeonTower()
    ;
    (sectorController.uiCanvas):OnClickDungeonTower(true)
    self:ClearSectorJumpId()
    self.isJumping = false
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  if jumpOverCallback ~= nil then
    jumpOverCallback()
  end
  self.isJumping = true
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

JumpManager.Jump2DungeonTowerValidate = function(self)
  -- function num : 0_77 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_DungeonTower) then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_DungeonTower, true)
    return false
  end
  return true
end

JumpManager.Jump2DynCareerStO = function(self, jumpOverCallback, argList)
  -- function num : 0_78 , upvalues : _ENV
  local buildId = argList ~= nil and argList[1] or nil
  local isInSector = ControllerManager:GetController(ControllerTypeId.SectorController) ~= nil
  if isInSector then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector)
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    sectorController:ShowCareerStO(buildId)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
    return 
  end
  local Home = UIManager:GetWindow(UIWindowTypeID.Home)
  Home.enterSectorJumpCallback = BindCallback(self, function()
    -- function num : 0_78_0 , upvalues : _ENV, buildId, jumpOverCallback
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController == nil then
      error("can\'t get sectorController")
      return 
    end
    sectorController:ShowCareerStO(buildId)
    if jumpOverCallback ~= nil then
      jumpOverCallback()
    end
  end
)
  ;
  (Home.homeRightNode):OnClickEpBtn()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

JumpManager.Jump2DynCareerStOValidate = function(self, argList)
  -- function num : 0_79 , upvalues : _ENV
  local isAllow = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorBuilding1)
  if not isAllow then
    self:__ShowCanotJumpMessage(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorBuilding1, true)
  end
  return isAllow
end

JumpManager.GetBefroeJumpCouldUseItemJump = function(self, jumpCorverArgs)
  -- function num : 0_80
  if jumpCorverArgs ~= nil and jumpCorverArgs.befroeJumpCouldUseItemJump ~= nil then
    return jumpCorverArgs.befroeJumpCouldUseItemJump
  end
  return self.couldUseItemJump
end

JumpManager.CleanJumpManager = function(self)
  -- function num : 0_81
  self.couldUseItemJump = false
  self.isJumping = false
end

JumpManager:Init()
JumpManager.ValidateFuncArray = ValidateFuncArray
return JumpManager

