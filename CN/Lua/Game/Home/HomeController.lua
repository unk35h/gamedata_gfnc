-- params : ...
-- function num : 0 , upvalues : _ENV
local HomeController = class("HomeController", ControllerBase)
local base = ControllerBase
local HomeEnum = require("Game.Home.HomeEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local UIBannerData = require("Game.CommonUI.Container.Model.ContainerData")
local NoticeData = require("Game.Notice.NoticeData")
local BuildingBelong = require("Game.Oasis.Data.BuildingBelong")
local JumpManager = require("Game.Jump.JumpManager")
local util = require("XLua.Common.xlua_util")
local HomeMainBg = require("Game.Home.HomeMainBg")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local cs_Input = (CS.UnityEngine).Input
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_CameraController = CS.OasisCameraController
local CS_CmCoreState = ((CS.Cinemachine).CinemachineCore).Stage
HomeController.OnInit = function(self)
  -- function num : 0_0 , upvalues : HomeEnum, _ENV
  self.oasisController = nil
  self:_ChangeHomeState((HomeEnum.eHomeState).None)
  self.homeCurrAdjutantLoaded = nil
  self.redDotFuncDic = {}
  self.sideNoticeList = {}
  self.m_timeSecond = 0
  self.m_timeSecond2 = 0
  self.needUpdateProduction = false
  self.updateProductionEvent = nil
  self.isNewFull = {}
  self.needUpdateConstruct = false
  self.updateConstructEvent = false
  self.isOasisHasCOB = false
  self.isSectorHasCOB = false
  self.isRewindingBack2HomeTimeLine = false
  self.__isLogin = true
  self.__live2DOver = true
  self.__OnUpdate = BindCallback(self, self.OnUpdate)
  UpdateManager:AddUpdate(self.__OnUpdate)
  self.__OnUpdatePlayerName = BindCallback(self, self.OnUpdatePlayerName)
  MsgCenter:AddListener(eMsgEventId.UserNameChanged, self.__OnUpdatePlayerName)
  self.__OnUpdateTask = BindCallback(self, self.OnUpdateTask)
  MsgCenter:AddListener(eMsgEventId.TaskSyncFinish, self.__OnUpdateTask)
  self.__UIOasisShow = BindCallback(self, self.ShowOasisUI)
  MsgCenter:AddListener(eMsgEventId.UIOasisShow, self.__UIOasisShow)
  self.__onUpdateUncompletedEp = BindCallback(self, self.OnUpdateUncompletedEp)
  MsgCenter:AddListener(eMsgEventId.OnHasUncompletedEp, self.__onUpdateUncompletedEp)
  self.__OnUpdateStamina = BindCallback(self, self.OnUpdateStamina)
  MsgCenter:AddListener(eMsgEventId.StaminaUpdate, self.__OnUpdateStamina)
  self.__OnUpdateHeroCollectRate = BindCallback(self, self.OnUpdateHeroCollectRate)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__OnUpdateHeroCollectRate)
  self.__OnUpdateARG = BindCallback(self, self.OnUpdateARG)
  MsgCenter:AddListener(eMsgEventId.UpdateARGItem, self.__OnUpdateARG)
  self.__OnUpdateItem = BindCallback(self, self.OnUpdateItem)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnUpdateItem)
  self.__OnActivityShowChange = BindCallback(self, self.OnActivityShowChange)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__OnActivityShowChange)
  self.__OnPlayerLevelChange = BindCallback(self, self.OnPlayerLevelChange)
  MsgCenter:AddListener(eMsgEventId.UpdatePlayerLevel, self.__OnPlayerLevelChange)
  self.AutoShowCommandList = {}
  self.__onGesture = BindCallback(self, self.OnGesture)
  self.__tryRunNextAutoShow = BindCallback(self, self.__TryRunNextAutoShow)
  self.__startShowHomeCoFunc = BindCallback(self, self.__StartShowHomeCo)
  self.lastVoiceId = 0
end

HomeController.OnInitHomeUI = function(self)
  -- function num : 0_1 , upvalues : CS_LeanTouch, _ENV
  self:PauseHomeOnHookTimer(false)
  ;
  (CS_LeanTouch.OnGesture)("+", self.__onGesture)
  local isEnd = (PlayerDataCenter.sectorStage):IsStageComplete((ConfigData.game_config).warfarEndEpl)
  if not isEnd and not self.__CheckInWarfarStage then
    self.__CheckInWarfarStage = BindCallback(self, self.CheckAndSetWarfarStage)
    MsgCenter:AddListener(eMsgEventId.PreCondition, self.__CheckInWarfarStage)
  end
end

HomeController.OnEnterHome = function(self)
  -- function num : 0_2 , upvalues : _ENV, HomeMainBg
  self.oasisController = ControllerManager:GetController(ControllerTypeId.OasisController, true)
  if self._mainBg == nil then
    self._mainBg = (HomeMainBg.New)()
    self._editorBg = (HomeMainBg.New)()
  end
  local mainCamera = UIManager:GetMainCamera()
  local bind = mainCamera:FindComponent(eUnityComponentID.LuaBinding)
  ;
  (self._editorBg):MainBgSetBind(bind)
  ;
  (self._editorBg):SetHomeMainEnable(false)
  ;
  (self._mainBg):MainBgSetBind(bind)
  ;
  (self._mainBg):SetHomeMainEnable(true)
  self._cm0 = bind:GetBind("toSectorVHomeCam")
  self._cm1 = bind:GetBind("toOasiaVHomeCam")
end

HomeController.OnShowHomeUI = function(self, isFromOasis)
  -- function num : 0_3 , upvalues : HomeEnum, _ENV, JumpManager
  self:PauseHomeOnHookTimer(false)
  local homeOldState = self.homeState
  if self.homeState == (HomeEnum.eHomeState).Covered then
    self.__wait4Guide = true
    self:_ChangeHomeState((HomeEnum.eHomeState).Normal)
    TimerManager:AddLateCommand(function()
    -- function num : 0_3_0 , upvalues : JumpManager, _ENV, self
    if JumpManager:IsHaveBack2Home() then
      JumpManager:TryCallBack2HomeMsgFunc((UIUtil.backStack):Empty())
      return 
    end
    if JumpManager.isJumping then
      return 
    end
    GuideManager:TryTriggerGuide(eGuideCondition.InHome)
    self.__wait4Guide = false
    self:__StartShowHomeCo()
  end
)
    self:OnUpdate(true)
    MsgCenter:Broadcast(eMsgEventId.OnOpenHomeUI)
    return 
  end
  self.factoryController = ControllerManager:GetController(ControllerTypeId.Factory, false)
  if self.homeState ~= (HomeEnum.eHomeState).Normal then
    self.__wait4Guide = true
    self:_ChangeHomeState((HomeEnum.eHomeState).Normal)
    TimerManager:AddLateCommand(function()
    -- function num : 0_3_1 , upvalues : JumpManager, self, _ENV
    if JumpManager:IsHaveBack2Home() and not self.isRewindingBack2HomeTimeLine then
      JumpManager:TryCallBack2HomeMsgFunc((UIUtil.backStack):Empty())
    end
    do return  end
    if JumpManager.isJumping then
      return 
    end
    GuideManager:TryTriggerGuide(eGuideCondition.InHome)
    self.__wait4Guide = false
    if not DeepLinkManager:StartDeepLink(self.__startShowHomeCoFunc) then
      self:__StartShowHomeCo()
    end
  end
)
    self:OnUpdate(true)
  end
  if self.__isLogin and not self:IsPlayLoginAnimationOnAutoShowOver() then
    self:PlayLoginHeroGreeting()
  end
  MsgCenter:Broadcast(eMsgEventId.OnOpenHomeUI)
end

HomeController.OnCoverHomeUI = function(self)
  -- function num : 0_4 , upvalues : HomeEnum, _ENV
  self:_ChangeHomeState((HomeEnum.eHomeState).Covered)
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    self:PauseHomeOnHookTimer(true)
  end
end

HomeController.OnHideHomeUI = function(self)
  -- function num : 0_5 , upvalues : HomeEnum, _ENV
  self:_ChangeHomeState((HomeEnum.eHomeState).Hided)
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    self:PauseHomeOnHookTimer(true)
  end
end

HomeController.OnDeleteHomeUI = function(self)
  -- function num : 0_6 , upvalues : _ENV, HomeEnum, CS_LeanTouch
  ControllerManager:DeleteController(ControllerTypeId.OasisController)
  self:RemoveAllRedDotEvent()
  self:_ChangeHomeState((HomeEnum.eHomeState).None)
  self:PauseHomeOnHookTimer(true)
  ;
  (CS_LeanTouch.OnGesture)("-", self.__onGesture)
  if self.__CheckInWarfarStage ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__CheckInWarfarStage)
    self.__CheckInWarfarStage = nil
  end
  if self._cm0 ~= nil then
    self._cm0 = nil
    self._cm1 = nil
  end
end

HomeController._ChangeHomeState = function(self, state)
  -- function num : 0_7 , upvalues : cs_Input, HomeEnum, JumpManager, _ENV
  self.homeState = state
  cs_Input.multiTouchEnabled = state ~= (HomeEnum.eHomeState).Normal
  JumpManager.couldUseItemJump = state == (HomeEnum.eHomeState).Normal
  ;
  ((CS.RenderManager).Instance):SetShaderLODGlobal(self:IsNormalState() and 400 or 600)
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    if self:IsNormalState() then
      homeUI:OnScreenSizeChanged()
    else
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

      (homeUI.canvas).worldCamera = nil
    end
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

HomeController.IsNormalState = function(self)
  -- function num : 0_8 , upvalues : HomeEnum
  do return self.homeState == (HomeEnum.eHomeState).Normal end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HomeController.OnAutoShowOver = function(self)
  -- function num : 0_9 , upvalues : _ENV
  self.isRunningAutoShow = false
  ;
  (table.removeall)(self.AutoShowCommandList)
  if self.__startOpenHomeAutoShow and self.__isLogin then
    if self:IsPlayLoginAnimationOnAutoShowOver() then
      self:PlayLoginHeroGreeting()
    end
    self.__startOpenHomeAutoShow = nil
    self.__isLogin = false
  end
  NoticeManager:ContinueShowNotice("homePop")
  NoticeManager:ForceContinueShowNotice()
end

HomeController.__TryRunNextAutoShow = function(self, isEnter, notRunNext)
  -- function num : 0_10 , upvalues : _ENV, HomeEnum
  if notRunNext then
    self.isRunningAutoShow = false
    return 
  end
  if isEnter then
    self.isRunningAutoShow = true
    if #self.AutoShowCommandList > 0 then
      NoticeManager:PuaseShowNotice("homePop")
    end
  end
  if self.homeState ~= (HomeEnum.eHomeState).Normal then
    self.isRunningAutoShow = false
    return 
  end
  if #self.AutoShowCommandList <= 0 then
    self:OnAutoShowOver()
    return 
  end
  local command = (table.remove)(self.AutoShowCommandList, 1)
  if command == (HomeEnum.eAutoShwoCommand).Pay then
    (ControllerManager:GetController(ControllerTypeId.Pay, true)):TryShowPayResult(self.__tryRunNextAutoShow)
    return 
  end
  if command == (HomeEnum.eAutoShwoCommand).GameNotice and self:TryShowGameNotice() then
    return 
  end
  if command == (HomeEnum.eAutoShwoCommand).NoviceSign then
    local signIdList = (PlayerDataCenter.eventNoviceSignData):GetSortSignDataIdList()
    for k,signId in ipairs(signIdList) do
      if self:TryShowEventNoviceSign(signId) then
        return 
      end
    end
  end
  do
    if command == (HomeEnum.eAutoShwoCommand).Singin and self:TryCollectSinginReward() then
      return 
    end
    if command == (HomeEnum.eAutoShwoCommand).ActivitySignInMiniGame and self:__TryShowActivitySiginMiniGame() then
      return 
    end
    if command == (HomeEnum.eAutoShwoCommand).SectorActivity then
      for k,activityEntranceCfg in pairs(ConfigData.activity_entrance) do
        if self:TryShowSectorActivity(activityEntranceCfg) then
          return 
        end
      end
    end
    do
      if command == (HomeEnum.eAutoShwoCommand).Singin and self:TryCollectSinginReward() then
        return 
      end
      if command == (HomeEnum.eAutoShwoCommand).LoginPupup and self:_TryShowLoginPupup() then
        return 
      end
      if command == (HomeEnum.eAutoShwoCommand).ChipGift then
        local giftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
        local giftId = giftCtrl:GetHomePopGiftOne(true)
        if giftId ~= nil and self:TryOpenPayGift(giftId) then
          return 
        end
      end
      do
        if command == (HomeEnum.eAutoShwoCommand).EventAngelaGift and self:_TryShowAngelaGiftPopup() then
          return 
        end
        if command == (HomeEnum.eAutoShwoCommand).Comeback and self:__TryComebackPopup() then
          return 
        end
        self:__TryRunNextAutoShow()
      end
    end
  end
end

HomeController.__StartShowHomeCo = function(self)
  -- function num : 0_11 , upvalues : _ENV, HomeEnum
  self.__startOpenHomeAutoShow = true
  self.AutoShowCommandList = {}
  if GuideManager.inGuide then
    return 
  end
  if (ControllerManager:GetController(ControllerTypeId.Pay, true)):GetCouldSHowPayResult() then
    (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).Pay)
  end
  if self:ValidCouldOpenGameNotice() then
    (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).GameNotice)
  end
  local singMiniGameFlag = self:ValidCouldActivitySignInMiniGame()
  if singMiniGameFlag then
    (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).ActivitySignInMiniGame)
  end
  for activityId,data in pairs((PlayerDataCenter.eventNoviceSignData).dataDic) do
    if self:ValidCouldOpenNoviceSign(activityId) then
      (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).NoviceSign)
    end
  end
  if self:ValidCouldOpenSinginReward() then
    (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).Singin)
  end
  for k,v in pairs(ConfigData.activity_entrance) do
    if self:ValidCouldOpenSectorActivity(v) then
      (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).SectorActivity)
    end
  end
  for k,v in pairs(ConfigData.login_popup_client_ctrl) do
    if self:ValidCouldOpenLoginPupup(v) then
      (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).LoginPupup)
    end
  end
  for k,v in pairs(ConfigData.shop) do
    if self:ValidShopCouldOpenLoginPupup(v) then
      (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).LoginPupup)
    end
  end
  for k,v in pairs(ConfigData.activity_angela_main) do
    if self:ValidCouldOpenActivityAngelaGiftPopup(v) then
      (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).EventAngelaGift)
    end
  end
  local giftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  local giftPopDic = giftCtrl:GetHomePopGiftDic()
  for giftId,_ in pairs(giftPopDic) do
    if self:ValidCouldOpenPayGift(giftId) then
      (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).ChipGift)
    end
  end
  local comebackFlag = self:ValidCouldComebackPopup()
  if comebackFlag then
    (table.insert)(self.AutoShowCommandList, (HomeEnum.eAutoShwoCommand).Comeback)
  end
  if not self.isRunningAutoShow then
    self:__TryRunNextAutoShow(true)
  end
end

HomeController.AddAutoShowGuide = function(self, autoShowType, isNolyAddGuide)
  -- function num : 0_12 , upvalues : _ENV
  (table.insert)(self.AutoShowCommandList, autoShowType)
  if isNolyAddGuide then
    return 
  end
  self:TryRunAutoShow()
end

HomeController.TryRunAutoShow = function(self)
  -- function num : 0_13 , upvalues : JumpManager, HomeEnum
  if not JumpManager.isJumping and not self.__wait4Guide and not self.isRunningAutoShow and self.homeState == (HomeEnum.eHomeState).Normal then
    self:__TryRunNextAutoShow(true)
  end
end

HomeController.ValidCouldOpenSinginReward = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if GuideManager.inGuide or not self:IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SignIn) then
    return false
  end
  local mailController = ControllerManager:GetController(ControllerTypeId.Mail, false)
  if mailController == nil then
    return false
  end
  local notPickedSinginMailUIDList = mailController:GetSignInRewardMailUIDs(self.__isNotFirstGetSignInReward, true)
  if #notPickedSinginMailUIDList <= 0 then
    return false
  end
  return true
end

HomeController.TryCollectSinginReward = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if not self:ValidCouldOpenSinginReward() then
    return false
  end
  local mailController = ControllerManager:GetController(ControllerTypeId.Mail, false)
  local notPickedSinginMailUIDList = mailController:GetSignInRewardMailUIDs(self.__isNotFirstGetSignInReward)
  self.__isNotFirstGetSignInReward = true
  UIManager:ShowWindowAsync(UIWindowTypeID.EventSignin, function(window)
    -- function num : 0_15_0 , upvalues : self, notPickedSinginMailUIDList
    window:SetCloseCallback(self.__tryRunNextAutoShow)
    window:InitEventSignin(nil, notPickedSinginMailUIDList)
  end
)
  return true
end

HomeController.ValidCouldOpenNoviceSign = function(self, id)
  -- function num : 0_16 , upvalues : _ENV
  if GuideManager.inGuide then
    return 
  end
  local data = ((PlayerDataCenter.eventNoviceSignData).dataDic)[id]
  if data == nil then
    return 
  end
  if not data:IsCanPop() then
    return 
  end
  return true
end

HomeController.TryShowEventNoviceSign = function(self, id)
  -- function num : 0_17 , upvalues : _ENV
  if not self:ValidCouldOpenNoviceSign(id) then
    return false
  end
  local data = ((PlayerDataCenter.eventNoviceSignData).dataDic)[id]
  data:SetPoped()
  if data:IsFestivalSign() then
    UIManager:ShowWindowAsync(UIWindowTypeID.EventFestivalSignIn, function(window)
    -- function num : 0_17_0 , upvalues : self, id
    window:SetCloseCallback(self.__tryRunNextAutoShow)
    window:InitEventFestivalSignIn(id, true)
  end
)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.EventNoviceSign, function(window)
    -- function num : 0_17_1 , upvalues : self, id
    window:SetCloseCallback(self.__tryRunNextAutoShow)
    window:InitNoviceSign(id, true)
  end
)
  end
  return true
end

HomeController.ValidCouldOpenGameNotice = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if GuideManager.inGuide then
    return false
  end
  if (CS.ClientConsts).IsAudit then
    return false
  end
  local ctrl = ControllerManager:GetController(ControllerTypeId.GameNotice)
  local canPush = ctrl:CanAutoPushGameNotice()
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Notice)
  return not canPush or isUnlock
end

HomeController.TryShowGameNotice = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if not self:ValidCouldOpenGameNotice() then
    return false
  end
  UIManager:CreateWindowAsync(UIWindowTypeID.GameNotice, function(win)
    -- function num : 0_19_0 , upvalues : self
    if win == nil then
      return 
    end
    win:SetCloseCallback(self.__tryRunNextAutoShow)
    win:InitUIGameNotice(false)
  end
)
  return true
end

HomeController.ValidCouldOpenSectorActivity = function(self, activityEntranceCfg, isRecord)
  -- function num : 0_20 , upvalues : _ENV
  if GuideManager.inGuide then
    return false
  end
  local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actInfo = activityCtrl:GetActivityFrameData(activityEntranceCfg.activityId)
  if actInfo == nil or not actInfo:CanPreviewNoExchange() then
    return false
  end
  if actInfo:IsActivityReadOnLogin() then
    return false
  end
  if isRecord then
    actInfo:SetActivityAsReadOnLogin()
  end
  return true
end

HomeController.TryShowSectorActivity = function(self, activityEntranceCfg)
  -- function num : 0_21 , upvalues : _ENV
  if not self:ValidCouldOpenSectorActivity(activityEntranceCfg, true) then
    return false
  end
  if self:_LoginPupupIsNeverPopToday(activityEntranceCfg.popup_id) then
    return false
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonActivityLogin, function(win)
    -- function num : 0_21_0 , upvalues : _ENV, activityEntranceCfg, self
    if win == nil then
      return 
    end
    local loginPupupCfg = (ConfigData.login_popup_ui)[activityEntranceCfg.popup_id]
    win:SetCloseCallback(self.__tryRunNextAutoShow)
    win:InitActivityLoginUI(loginPupupCfg)
  end
)
  return true
end

HomeController._LoginPupupIsNeverPopToday = function(self, popup_id)
  -- function num : 0_22 , upvalues : _ENV
  local systemSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)
  local loginPupupCfg = (ConfigData.login_popup_ui)[popup_id]
  if systemSaveData:GetActEntranceReadOneValue() then
    local userSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    local lastTime = userSaveData:GetActEntranceLastShow(loginPupupCfg.id)
    local showTime = (math.floor)(PlayerDataCenter.timestamp)
    if not TimeUtil:CompareIsCorssDay(lastTime, showTime) then
      return true
    end
  end
  do
    return false
  end
end

HomeController.ValidShopCouldOpenLoginPupup = function(self, shopCfg)
  -- function num : 0_23 , upvalues : _ENV
  if GuideManager.inGuide then
    return false
  end
  if not self._activetyPreviewShowDic then
    self._activetyPreviewShowDic = {}
    if shopCfg.popup_id == nil or shopCfg.popup_id == 0 then
      return false
    end
    if not (CheckCondition.CheckLua)(shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2) then
      return false
    else
      local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
      if payGiftCtrl:CheckPageIdIsGiftShop(shopCfg.id) and #payGiftCtrl:GetShowPayGiftByPageId(shopCfg.id) <= 0 then
        return false
      end
    end
    do
      if (self._activetyPreviewShowDic)[shopCfg.id] then
        return false
      end
      if self:_LoginPupupIsNeverPopToday(shopCfg.popup_id) then
        return false
      end
      return true
    end
  end
end

HomeController.ValidCouldOpenLoginPupup = function(self, loginPopupClientCtrlCfg)
  -- function num : 0_24 , upvalues : _ENV
  if GuideManager.inGuide then
    return false
  end
  if not self._activetyPreviewShowDic then
    self._activetyPreviewShowDic = {}
    local curTs = PlayerDataCenter.timestamp
    if curTs < loginPopupClientCtrlCfg.start_time or loginPopupClientCtrlCfg.end_time < curTs then
      return false
    end
    if (self._activetyPreviewShowDic)[loginPopupClientCtrlCfg.id] then
      return false
    end
    if self:_LoginPupupIsNeverPopToday(loginPopupClientCtrlCfg.popup_id) then
      return false
    end
    return true
  end
end

HomeController.ValidCouldOpenActivityAngelaGiftPopup = function(self, activityAngelaCfg)
  -- function num : 0_25 , upvalues : _ENV
  if GuideManager.inGuide then
    return false
  end
  local angelaGiftController = ControllerManager:GetController(ControllerTypeId.EventAngelaGift)
  if angelaGiftController == nil then
    return false
  end
  local data = angelaGiftController:GetAngelaGiftDataByActId(activityAngelaCfg.id)
  if data == nil or data:GetIsAngelaGiftDataOver() then
    return false
  end
  if not self._activetyPreviewShowDic then
    self._activetyPreviewShowDic = {}
    if (self._activetyPreviewShowDic)[data:GetActFrameId()] then
      return false
    end
    return data:GetAngelaGiftDataCanPop()
  end
end

HomeController._TryShowAngelaGiftPopup = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local angelaGiftController = ControllerManager:GetController(ControllerTypeId.EventAngelaGift)
  if angelaGiftController == nil then
    return false
  end
  local data = angelaGiftController:GetTheLatestAngelaGiftData()
  if data == nil or data:GetIsAngelaGiftDataOver() then
    return false
  end
  if not self._activetyPreviewShowDic then
    self._activetyPreviewShowDic = {}
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._activetyPreviewShowDic)[data:GetActFrameId()] = true
    UIManager:ShowWindowAsync(UIWindowTypeID.EventAngelaGift, function(win)
    -- function num : 0_26_0 , upvalues : self, data
    if win == nil then
      return 
    end
    win:SetCloseCallback(self.__tryRunNextAutoShow)
    win:InitEventAngelaGiftMain(data:GetActId(), true)
  end
)
    return true
  end
end

HomeController._TryShowLoginPupup = function(self)
  -- function num : 0_27 , upvalues : _ENV, JumpManager
  if not self._activetyPreviewShowDic then
    self._activetyPreviewShowDic = {}
    local curTs = PlayerDataCenter.timestamp
    for k,popCfg in pairs(ConfigData.login_popup_client_ctrl) do
      do
        -- DECOMPILER ERROR at PC18: Confused about usage of register: R7 in 'UnsetPending'

        if self:ValidCouldOpenLoginPupup(popCfg) then
          (self._activetyPreviewShowDic)[k] = true
          UIManager:ShowWindowAsync(UIWindowTypeID.CommonActivityLogin, function(win)
    -- function num : 0_27_0 , upvalues : _ENV, popCfg, self
    if win == nil then
      return 
    end
    local loginPupupCfg = (ConfigData.login_popup_ui)[popCfg.popup_id]
    win:SetCloseCallback(self.__tryRunNextAutoShow)
    win:InitActivityLoginUI(loginPupupCfg)
  end
)
          return true
        end
      end
    end
    for k,shopCfg in pairs(ConfigData.shop) do
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R7 in 'UnsetPending'

      if self:ValidShopCouldOpenLoginPupup(shopCfg) then
        (self._activetyPreviewShowDic)[k] = true
        UIManager:ShowWindowAsync(UIWindowTypeID.CommonActivityLogin, function(win)
    -- function num : 0_27_1 , upvalues : _ENV, shopCfg, self, JumpManager
    if win == nil then
      return 
    end
    local loginPupupCfg = (ConfigData.login_popup_ui)[shopCfg.popup_id]
    win:SetCloseCallback(self.__tryRunNextAutoShow)
    win:SetJumpFunc(function()
      -- function num : 0_27_1_0 , upvalues : JumpManager, shopCfg
      JumpManager:DirectShowShop(nil, nil, shopCfg.id)
    end
)
    win:SetTimeId(true, shopCfg.id)
    win:InitActivityLoginUI(loginPupupCfg)
  end
)
        return true
      end
    end
    return false
  end
end

HomeController.ValidCouldOpenPayGift = function(self, id)
  -- function num : 0_28 , upvalues : _ENV
  local giftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  local giftInfo = giftCtrl:GetPayGiftDataById(id)
  if giftInfo == nil then
    return false
  end
  return giftCtrl:CheckPayGiftCanPop(giftInfo)
end

HomeController.TryOpenPayGift = function(self, id)
  -- function num : 0_29 , upvalues : _ENV
  if not self:ValidCouldOpenPayGift(id) then
    return false
  end
  local giftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  local giftInfo = giftCtrl:GetPayGiftDataById(id)
  if (giftInfo.groupCfg).popup_id ~= 0 and self:_LoginPupupIsNeverPopToday((giftInfo.groupCfg).popup_id) then
    return false
  end
  if giftInfo:IsSelfSelectHeroGift() or giftInfo:IsSelfSelectChipGift() then
    giftCtrl:ShowHeroGiftWin(giftInfo, self.__tryRunNextAutoShow)
  else
    giftCtrl:ShowPayGiftWin(giftInfo, self.__tryRunNextAutoShow)
  end
  return true
end

HomeController.ValidCouldComebackPopup = function(self)
  -- function num : 0_30 , upvalues : _ENV
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback)
  if comebackCtrl == nil then
    return false
  end
  local comebackData = comebackCtrl:GetTheLatestComebackData()
  if comebackData == nil then
    return false
  end
  if not comebackData:IsActivityOpen() then
    return false
  end
  local avgID = comebackData:GetComebackAvgId()
  if avgID ~= 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay, true)
    if avgPlayCtrl:IsAvgPlayed(avgID) then
      return false
    end
  else
    do
      local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      do
        local isPopPlayed = userDataCache:GetComebackPopLooked(comebackData:GetActId())
        do return not isPopPlayed, comebackData, avgID end
        return true, comebackData, avgID
      end
    end
  end
end

HomeController.__TryComebackPopup = function(self)
  -- function num : 0_31 , upvalues : _ENV
  local flag, comebackData, avgID = self:ValidCouldComebackPopup()
  if not flag then
    return false
  end
  local closeFunc = function()
    -- function num : 0_31_0 , upvalues : avgID, _ENV, comebackData, self
    if avgID ~= 0 then
      local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
      avgCtrl:StartAvg(nil, avgID, function()
      -- function num : 0_31_0_0 , upvalues : _ENV, comebackData
      UIManager:ShowWindowAsync(comebackData:GetComebackWindowId(), function(window)
        -- function num : 0_31_0_0_0 , upvalues : _ENV, comebackData
        if window ~= nil then
          local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
          if homeUI ~= nil then
            homeUI:OpenOtherWin()
          end
          window:SetFromWhichUI(eBaseWinFromWhere.home)
          window:InitActivityCombackMain(comebackData:GetActId())
        end
      end
)
    end
)
    else
      do
        UIManager:ShowWindowAsync(comebackData:GetComebackWindowId(), function(window)
      -- function num : 0_31_0_1 , upvalues : _ENV, comebackData
      if window ~= nil then
        local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
        if homeUI ~= nil then
          homeUI:OpenOtherWin()
        end
        window:SetFromWhichUI(eBaseWinFromWhere.home)
        window:InitActivityCombackMain(comebackData:GetActId())
      end
    end
)
        self:OnAutoShowOver()
      end
    end
  end

  UIManager:ShowWindowAsync(UIWindowTypeID.CommonActivityLogin, function(win)
    -- function num : 0_31_1 , upvalues : comebackData, _ENV, closeFunc
    if win == nil then
      return 
    end
    local comebackCfg = comebackData:GetComebackCfg()
    local loginPupupCfg = (ConfigData.login_popup_ui)[comebackCfg.login_popup]
    win:SetCloseCallback(closeFunc)
    win:InitActivityLoginUI(loginPupupCfg)
    win:SetIgnoreExtraPopupUI()
    local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    userDataCache:SetComebackPopLooked(comebackData:GetActId())
  end
)
  return true
end

HomeController.ValidCouldActivitySignInMiniGame = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local signInMiniGameCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame)
  if signInMiniGameCtrl == nil then
    return false
  end
  if signInMiniGameCtrl:IsOpen() ~= true then
    return false
  end
  if signInMiniGameCtrl:IsCanSignToDay() ~= true then
    return false
  end
  if signInMiniGameCtrl:GetLoginIsFirstOpen() == true then
    return false
  end
  local isplayed = signInMiniGameCtrl:GetIsPlayedCartoon()
  local actId = signInMiniGameCtrl:GetActId()
  return true, actId, isplayed
end

HomeController.__TryShowActivitySiginMiniGame = function(self)
  -- function num : 0_33 , upvalues : _ENV
  local flag, actId, isplayed = self:ValidCouldActivitySignInMiniGame()
  if not flag then
    return false
  end
  local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
  if isplayed == false then
    avgCtrl:StartAvg(nil, 2000101, function()
    -- function num : 0_33_0 , upvalues : _ENV, actId, self
    local signInMiniGameCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame)
    signInMiniGameCtrl:CS_ACTIVITY_SignMiniGame_PlayCartoon()
    signInMiniGameCtrl:SetLoginIsFirstOpen()
    UIManager:ShowWindowAsync(UIWindowTypeID.SignInMiniGame, function(win)
      -- function num : 0_33_0_0 , upvalues : actId, self
      if win == nil then
        return 
      end
      win:InitSignInMiniGame(actId, true)
      win:SetCloseCallback(self.__tryRunNextAutoShow)
    end
)
  end
)
  else
    local signInMiniGameCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame)
    signInMiniGameCtrl:SetLoginIsFirstOpen()
    UIManager:ShowWindowAsync(UIWindowTypeID.SignInMiniGame, function(win)
    -- function num : 0_33_1 , upvalues : actId, self
    if win == nil then
      return 
    end
    win:InitSignInMiniGame(actId, true)
    win:SetCloseCallback(self.__tryRunNextAutoShow)
  end
)
  end
  do
    return true
  end
end

HomeController.OnUpdate = function(self, isForce)
  -- function num : 0_34 , upvalues : _ENV
  if self.m_timeSecond2 == nil then
    self.m_timeSecond2 = 0
  else
    self.m_timeSecond2 = self.m_timeSecond2 + Time.deltaTime
  end
  local isMin = false
  if self.m_timeSecond2 > 60 then
    self.m_timeSecond2 = 0
    isMin = true
  end
  if isMin then
    (PlayerDataCenter.friendDataCenter):RefreshFriendApplyReddotNum()
  end
  if isForce or isMin then
    self:UpdateCouldOperateBuilding()
    self:UpdateOasisGenResourceFull()
    self:UpdateIsFactoryLineOver()
  end
end

HomeController.SetNeedUpdateProduction = function(self, bool, updateEvent)
  -- function num : 0_35
  self.needUpdateProduction = true
  self.updateProductionEvent = updateEvent
end

local m_AddBuildRes = function(allResDic, resData, countMax)
  -- function num : 0_36
  local allResData = allResDic[resData.id]
  if allResData == nil then
    allResData = {id = resData.id, name = resData.name, count = resData.count, speed = resData.speed, effSpeed = resData.effSpeed, progress = resData.progress, countMax = countMax}
    allResDic[resData.id] = allResData
  else
    allResData.effSpeed = allResData.effSpeed + resData.effSpeed
    allResData.speed = allResData.speed + resData.speed
    allResData.count = allResData.count + resData.count
    allResData.countMax = allResData.countMax + countMax
  end
end

HomeController.SetNeedUpdateConstruct = function(self, bool, updateEvent)
  -- function num : 0_37
  self.needUpdateConstruct = bool
  self.updateConstructEvent = updateEvent
end

HomeController.OnUpdateBuildingConstruct = function(self)
  -- function num : 0_38 , upvalues : BuildingBelong, _ENV
  if not self.needUpdateConstruct then
    return 
  end
  local constructingBuildingLists = {
[BuildingBelong.Oasis] = {}
, 
[BuildingBelong.Sector] = {}
}
  for _,builtData in ipairs((PlayerDataCenter.AllBuildingData).builtSort) do
    builtData:GetProcess(PlayerDataCenter.timestamp)
    if builtData.state == proto_object_BuildingState.BuildingStateCreate or builtData.state == proto_object_BuildingState.BuildingStateUpgrade then
      (table.insert)(constructingBuildingLists[builtData.belong], builtData)
    end
  end
  if self.updateConstructEvent ~= nil then
    (self.updateConstructEvent)(constructingBuildingLists)
  end
end

HomeController.UpdateCouldOperateBuilding = function(self)
  -- function num : 0_39 , upvalues : _ENV, NoticeData, JumpManager
  local curHasSectorCOB, curHasOasisCOB = nil, nil
  local isSectorBuildingUnlock = self:IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorBuilding)
  for id,data in pairs((PlayerDataCenter.AllBuildingData).unbuilt) do
    if data:IsSectorBuilding() and not curHasSectorCOB and isSectorBuildingUnlock and data:CanBuild() then
      curHasSectorCOB = true
    end
    if not curHasOasisCOB and data:CanBuild() then
      curHasOasisCOB = true
    end
  end
  for id,data in pairs((PlayerDataCenter.AllBuildingData).built) do
    if (data.dynData):IsSectorBuilding() and not curHasSectorCOB and isSectorBuildingUnlock and data:CanUpgrade() then
      curHasSectorCOB = true
    end
    if not curHasOasisCOB and data:CanUpgrade() then
      curHasOasisCOB = true
    end
  end
  if not self.isOasisHasCOB and curHasOasisCOB then
    self.isOasisHasCOB = curHasOasisCOB
    NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).HasOasisBuildingOperate, {jumpType = (JumpManager.eJumpTarget).Oasis, argList = nil}, nil, nil))
  else
    if self.isOasisHasCOB and not curHasOasisCOB then
      NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).HasOasisBuildingOperate)
      self.isOasisHasCOB = curHasOasisCOB
    end
  end
  if not self.isSectorHasCOB and curHasSectorCOB then
    self.isSectorHasCOB = curHasSectorCOB
    NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).HasSectorBuildingOperate, {jumpType = (JumpManager.eJumpTarget).Sector, 
argList = {true}
}, nil, nil))
  else
    if self.isSectorHasCOB and not curHasSectorCOB then
      NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).HasSectorBuildingOperate)
      self.isSectorHasCOB = curHasSectorCOB
    end
  end
end

HomeController.UpdateOasisGenResourceFull = function(self)
  -- function num : 0_40 , upvalues : _ENV, NoticeData, JumpManager
  for _,buildingData in pairs((PlayerDataCenter.AllBuildingData).oasisBuilt) do
    local datas = buildingData:GetResDatas()
    if datas ~= nil then
      for resId,data in pairs(datas) do
        if data.countMax <= data.count then
          if not self.isOasisHasFullResource then
            self.isOasisHasFullResource = true
            NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).ResourceGenerateOverflow, {jumpType = (JumpManager.eJumpTarget).Oasis, argList = nil}, nil, nil))
          end
          return 
        end
      end
    end
  end
  if self.isOasisHasFullResource then
    self.isOasisHasFullResource = false
    NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).ResourceGenerateOverflow)
  end
end

HomeController.UpdateIsFactoryLineOver = function(self)
  -- function num : 0_41 , upvalues : _ENV
  local isFactoryUnlock = self:IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Factory)
  if isFactoryUnlock then
    local factoryController = ControllerManager:GetController(ControllerTypeId.Factory, false)
    if factoryController == nil or factoryController.factoryMainUI ~= nil then
      return 
    end
    factoryController:RefreshFactoryRedDot()
  end
end

HomeController.OnUpdatePlayerName = function(self)
  -- function num : 0_42 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeUpNdoe):RefershUserInfo()
  end
end

HomeController.OnUpdateTask = function(self)
  -- function num : 0_43 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeLeftNode):RefreshTaskBtn()
  end
end

HomeController.ShowOasisUI = function(self)
  -- function num : 0_44
  if self.isInEnterOasis then
    (self.oasisController):EnterOasis()
  end
end

HomeController.IsEnterOasis = function(self, isEnter)
  -- function num : 0_45
  self.isInEnterOasis = isEnter
end

HomeController.ResetOasisCamera = function(self)
  -- function num : 0_46 , upvalues : cs_CameraController
  (cs_CameraController.Instance):ResetOasisView()
end

HomeController.OnUpdateUncompletedEp = function(self)
  -- function num : 0_47 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeRightNode):RefreshContinueEp()
  end
end

HomeController.OnUpdateStamina = function(self)
  -- function num : 0_48 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeRightNode):RefreshStamina()
  end
end

HomeController.OnUpdateFactoryEnergy = function(self)
  -- function num : 0_49 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeRightNode):RefreshFactoryEnergy()
  end
end

HomeController.OnUpdateLotteryCost = function(self, fromeAuto)
  -- function num : 0_50 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeRightNode):RefreshLotteryCost(fromeAuto)
  end
end

HomeController.OnUpdateHeroCollectRate = function(self)
  -- function num : 0_51 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeRightNode):RefreshCollectRate()
  end
end

HomeController.OnUpdateOasisBuilding = function(self)
  -- function num : 0_52 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeRightNode):RefreshBuiltRate()
  end
  self:OnUpdateFactoryEnergy()
end

HomeController.OnUpdateARG = function(self, changedItemNumDic)
  -- function num : 0_53
  self:OnUpdateLotteryCost(true)
end

HomeController.OnUpdateItem = function(self, itemUpdate)
  -- function num : 0_54 , upvalues : _ENV
  self:OnUpdateLotteryCost()
  if itemUpdate[(ConfigData.game_config).factoryEnergyItemId] ~= nil then
    self:OnUpdateFactoryEnergy()
  end
end

HomeController.OnActivityShowChange = function(self)
  -- function num : 0_55 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeLeftNode):RefreshActivityShow()
  end
end

HomeController.OnPlayerLevelChange = function(self)
  -- function num : 0_56 , upvalues : _ENV
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    (homeUI.homeUpNdoe):RefershUserInfo()
  end
end

HomeController.IsFuncUnlock = function(self, funcId)
  -- function num : 0_57 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(funcId)
  if not isUnlock then
    local unlockDes = FunctionUnlockMgr:GetFuncUnlockDecription(funcId)
    return isUnlock, unlockDes
  else
    do
      do return isUnlock, nil end
    end
  end
end

HomeController.AddRedDotEvent = function(self, redDotCallback, ...)
  -- function num : 0_58 , upvalues : _ENV
  local ok, node = RedDotController:GetRedDotNode(...)
  redDotCallback(node:GetRedDotCount())
  local redDotFunc = function(node)
    -- function num : 0_58_0 , upvalues : redDotCallback
    redDotCallback(node:GetRedDotCount())
  end

  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.redDotFuncDic)[redDotFunc] = node
  RedDotController:AddListener(node.nodePath, redDotFunc)
end

HomeController.RemoveAllRedDotEvent = function(self)
  -- function num : 0_59 , upvalues : _ENV
  for redDotFunc,node in pairs(self.redDotFuncDic) do
    RedDotController:RemoveListener(node.nodePath, redDotFunc)
  end
  self.redDotFuncDic = {}
end

HomeController.GetAdjutant = function(self)
  -- function num : 0_60 , upvalues : _ENV
  if PlayerDataCenter.showGirlId == nil or PlayerDataCenter.showGirlId == 0 then
    local firtBoardHeroID = (ConfigData.game_config).firtBoardHeroID
    if (PlayerDataCenter.heroDic)[firtBoardHeroID] == nil then
      error("default board hero data is nil id " .. firtBoardHeroID)
    else
      return (PlayerDataCenter.heroDic)[firtBoardHeroID]
    end
  else
    do
      do return (PlayerDataCenter.heroDic)[PlayerDataCenter.showGirlId] end
    end
  end
end

HomeController.GetAdjutantHeroId = function(self)
  -- function num : 0_61
  local heroData = self:GetAdjutant()
  if heroData == nil then
    return nil
  end
  return heroData.dataId
end

HomeController.ResetHomeVoice = function(self)
  -- function num : 0_62 , upvalues : _ENV
  self.__aniPlayEnd = true
  TimerManager:StopTimer(self.__animTimerId)
  if self.__fakeVoiceTimer ~= nil then
    TimerManager:StopTimer(self.__fakeVoiceTimer)
    self.__fakeVoiceTimer = nil
  end
end

HomeController.PlayLoginHeroGreeting = function(self)
  -- function num : 0_63 , upvalues : _ENV
  if self.dontPlayCvNextReturnHome then
    self:NextReturnHomeDontPlayCv(false)
    return 
  end
  if self.isRunningAutoShow then
    return 
  end
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window ~= nil and window.homeAdjutant ~= nil then
    (window.homeAdjutant):PlayAdjutantLoginGreeting()
  end
end

HomeController.TryPlayVoReturnHome = function(self)
  -- function num : 0_64 , upvalues : _ENV
  if self.dontPlayCvNextReturnHome then
    self:NextReturnHomeDontPlayCv(false)
    return false
  end
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window == nil or window.homeAdjutant == nil or (window.homeAdjutant).heroCubismInteration == nil then
    return false
  end
  ;
  (window.homeAdjutant):PlayAdjutantHeroEnterHomeAnimation()
  return true
end

HomeController.PlayHomeVoice = function(self, heroId, skinId, voiceId, cvOverBackFun, animLength, OpenMouseListen)
  -- function num : 0_65 , upvalues : _ENV
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  local isHeroHasVoice = cvCtr:HasCv(heroId)
  if self._lastHomeVoicePlayback ~= nil then
    AudioManager:StopAudioByBack(self._lastHomeVoicePlayback)
    self._lastHomeVoicePlayback = nil
  end
  self.lastVoiceId = voiceId
  local lastCvInfo = (PlayerDataCenter.cacheSaveData):GetLastHeroInterationCVInfo()
  lastCvInfo.lastVoiceHeroId = heroId
  lastCvInfo.lastVoiceTIme = ((CS.UnityEngine).Time).time
  ;
  (PlayerDataCenter.cacheSaveData):SetLastHeroInterationCVInfo(lastCvInfo)
  if not isHeroHasVoice then
    if cvOverBackFun ~= nil then
      cvOverBackFun(false)
    end
    if self.__fakeVoiceTimer ~= nil then
      TimerManager:StopTimer(self.__fakeVoiceTimer)
      self.__fakeVoiceTimer = nil
    end
    local fakeTime = animLength ~= nil and animLength or 3
    local window = UIManager:GetWindow(UIWindowTypeID.Home)
    do
      do
        if window ~= nil then
          local text = cvCtr:GetCvText(heroId, voiceId, skinId)
          ;
          (window.homeLeftNode):ShowHeroVoiceText(true, text, true, fakeTime)
        end
        self.__fakeVoiceTimer = TimerManager:StartTimer(fakeTime, function()
    -- function num : 0_65_0 , upvalues : self, cvOverBackFun
    self:TryResetShowHeroVoice()
    if cvOverBackFun ~= nil then
      cvOverBackFun(true)
    end
  end
, self, true)
        do return  end
        if OpenMouseListen then
          OpenMouseListen = self:JudgeMouseOpen()
        end
        if cvOverBackFun ~= nil then
          cvOverBackFun(not OpenMouseListen)
        end
        if animLength ~= nil then
          self.__aniPlayEnd = false
          TimerManager:StopTimer(self.__animTimerId)
          self.__animTimerId = TimerManager:StartTimer(animLength, function()
    -- function num : 0_65_1 , upvalues : self
    self.__aniPlayEnd = true
    self:TryResetShowHeroVoice()
  end
)
        end
        self._lastHomeVoicePlayback = cvCtr:PlayCv(heroId, voiceId, function()
    -- function num : 0_65_2 , upvalues : self, cvOverBackFun
    self._lastHomeVoicePlayback = nil
    self:TryResetShowHeroVoice()
    if cvOverBackFun ~= nil then
      cvOverBackFun(true)
    end
  end
, OpenMouseListen, skinId)
        local audioLength = cvCtr:GetVoiceLength(heroId, voiceId, skinId)
        local voiceTextDuration = audioLength / 1000
        local window = UIManager:GetWindow(UIWindowTypeID.Home)
        if window ~= nil then
          local text = cvCtr:GetCvText(heroId, voiceId, skinId)
          ;
          (window.homeLeftNode):ShowHeroVoiceText(true, text, false, voiceTextDuration)
        end
      end
    end
  end
end

HomeController.TryResetShowHeroVoice = function(self)
  -- function num : 0_66 , upvalues : _ENV
  if self._lastHomeVoicePlayback == nil and self.__aniPlayEnd then
    local window = UIManager:GetWindow(UIWindowTypeID.Home)
    if window ~= nil then
      (window.homeLeftNode):ShowHeroVoiceText(false)
    end
  end
end

HomeController.ResetShowHeroVoiceImme = function(self)
  -- function num : 0_67 , upvalues : _ENV
  if self._lastHomeVoicePlayback == nil and self.__aniPlayEnd then
    return 
  end
  if self._lastHomeVoicePlayback ~= nil then
    AudioManager:StopAudioByBack(self._lastHomeVoicePlayback)
    self._lastHomeVoicePlayback = nil
  end
  if not self.__aniPlayEnd then
    self.__aniPlayEnd = true
    TimerManager:StopTimer(self.__animTimerId)
    self.__animTimerId = nil
  end
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window ~= nil then
    (window.homeLeftNode):ShowHeroVoiceText(false)
    if window.homeAdjutant ~= nil and (window.homeAdjutant).heroCubismInteration ~= nil then
      ((window.homeAdjutant).heroCubismInteration):RestartBodyAnimation()
    end
  end
end

HomeController.JudgeMouseOpen = function(self)
  -- function num : 0_68 , upvalues : _ENV
  if not self.homeCurrAdjutantLoaded then
    return false
  end
  local adjPreset = (PlayerDataCenter.allAdjCustomData):GetUsingCustomPreset()
  local mainAdjHero = adjPreset:GetAdjPresetElemMain()
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  return skinCtrl:CheckMouseOpen(mainAdjHero.dataId, mainAdjHero.skinId)
end

HomeController.NextReturnHomeDontPlayCv = function(self, isFrom)
  -- function num : 0_69
  self.dontPlayCvNextReturnHome = isFrom
end

HomeController.PauseHomeOnHookTimer = function(self, pause)
  -- function num : 0_70 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window ~= nil then
    (window.homeAdjutant):OpenAdjutantWait(not pause)
  end
end

HomeController.StopHomeOnHookTimer = function(self)
  -- function num : 0_71 , upvalues : CS_LeanTouch
  (CS_LeanTouch.OnGesture)("-", self.__onGesture)
end

HomeController.OnGesture = function(self, fingerList)
  -- function num : 0_72 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window == nil or window.homeAdjutant == nil or (window.homeAdjutant).heroCubismInteration == nil then
    return false
  end
  ;
  ((window.homeAdjutant).heroCubismInteration):ResetInterationWaitTime()
end

HomeController.ChangeSceneMainBg = function(self, isDay)
  -- function num : 0_73
  if self._mainBg ~= nil then
    (self._mainBg):SetHomeMainState(isDay)
    ;
    (self._editorBg):SetHomeMainState(isDay)
  end
end

HomeController.ResetHomeMainBg = function(self)
  -- function num : 0_74 , upvalues : _ENV
  local mainCamera = UIManager:GetMainCamera()
  local bind = mainCamera:FindComponent(eUnityComponentID.LuaBinding)
  ;
  (self._editorBg):MainBgSetBind(bind)
  ;
  (self._editorBg):SetHomeMainEnable(false)
  ;
  (self._mainBg):MainBgSetBind(bind)
  ;
  (self._mainBg):SetHomeMainEnable(true)
end

HomeController.HideWarfarEffect = function(self)
  -- function num : 0_75
  self:__RecoverCMCamera()
  ;
  (self._mainBg):SetHomeMainEnable(false)
end

HomeController.ShowWarfarEffect = function(self)
  -- function num : 0_76
  self:__RecoverCMCamera()
  ;
  (self._mainBg):SetHomeMainEnable(true)
end

HomeController.CheckAndSetWarfarStage = function(self, conditionId)
  -- function num : 0_77 , upvalues : CheckerTypeId, _ENV
  if conditionId ~= nil and conditionId ~= CheckerTypeId.CompleteStage then
    return 
  end
  local isEnd = (PlayerDataCenter.sectorStage):IsStageComplete((ConfigData.game_config).warfarEndEpl)
  if isEnd and self.__CheckInWarfarStage ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__CheckInWarfarStage)
    self.__CheckInWarfarStage = nil
  end
  self:RefreshHomeMainBg()
end

HomeController.RefreshHomeMainBg = function(self)
  -- function num : 0_78 , upvalues : _ENV
  local adjInfo = (PlayerDataCenter.allAdjCustomData):GetUsingCustomPreset()
  if adjInfo == nil then
    return 
  end
  local bgId = adjInfo:GetAdjPresetBgId()
  if bgId == nil then
    return 
  end
  local bgCfg = (ConfigData.background)[bgId]
  if bgCfg == nil then
    return 
  end
  local isEnd = (PlayerDataCenter.sectorStage):IsStageComplete((ConfigData.game_config).warfarEndEpl)
  local isInDuring = (not isEnd and (PlayerDataCenter.sectorStage):IsStageComplete((ConfigData.game_config).warfarStartEpl))
  if isInDuring then
    bgCfg = (ConfigData.background)[(ConfigData.buildinConfig).WarfarBgId]
  end
  self:__RecoverCMCamera()
  ;
  (self._editorBg):SetHomeMainEnable(false)
  ;
  (self._mainBg):UpdateBgId(bgCfg)
  ;
  (self._mainBg):SetHomeMainEnable(true)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

HomeController.SetHomeMainEditorBg = function(self, bgCfg)
  -- function num : 0_79
  self:__RecoverCMCamera()
  ;
  (self._editorBg):UpdateBgId(bgCfg)
  ;
  (self._mainBg):SetHomeMainEnable(false)
  ;
  (self._editorBg):SetHomeMainEnable(true)
end

HomeController.ResetHomeMainBg = function(self)
  -- function num : 0_80
  self:__RecoverCMCamera()
  ;
  (self._editorBg):SetHomeMainEnable(false)
  ;
  (self._mainBg):SetHomeMainEnable(true)
end

HomeController.ClearRecordMainBg = function(self)
  -- function num : 0_81
  self:ResetHomeMainBg()
  ;
  (self._editorBg):ClearMainBgRes()
end

HomeController.PreLoadMainBg = function(self, callback)
  -- function num : 0_82 , upvalues : HomeMainBg
  if self._mainBg == nil then
    self._mainBg = (HomeMainBg.New)()
    self._editorBg = (HomeMainBg.New)()
    ;
    (self._mainBg):SetLoadedSuccessFunc(function()
    -- function num : 0_82_0 , upvalues : self, callback
    (self._mainBg):SetLoadedSuccessFunc(nil)
    callback()
  end
)
    self:RefreshHomeMainBg()
  end
end

HomeController.UnloadMainBg = function(self)
  -- function num : 0_83
  if self._mainBg ~= nil then
    (self._mainBg):Delete()
    ;
    (self._editorBg):Delete()
    self._mainBg = nil
    self._editorBg = nil
  end
end

HomeController.__RecoverCMCamera = function(self)
  -- function num : 0_84 , upvalues : _ENV, CS_CmCoreState
  if IsNull(self._cm0) then
    return 
  end
  local noise = (self._cm0):GetCinemachineComponent(CS_CmCoreState.Noise)
  noise.m_AmplitudeGain = 0
  noise = (self._cm1):GetCinemachineComponent(CS_CmCoreState.Noise)
  noise.m_AmplitudeGain = 0
end

HomeController.GetLastCVId = function(self)
  -- function num : 0_85
  return self.lastVoiceId
end

HomeController.IsPlayLoginAnimationOnAutoShowOver = function(self)
  -- function num : 0_86 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window ~= nil and window.homeAdjutant ~= nil then
    local IsPlayOnAutoShowOver = (window.homeAdjutant):IsPlayLoginAnimationOnAutoShowOver()
    return IsPlayOnAutoShowOver
  end
end

HomeController.SetLoginReadyFinished = function(self, flag)
  -- function num : 0_87
  self._loginReadyFinished = flag
end

HomeController.OnDelete = function(self)
  -- function num : 0_88 , upvalues : _ENV, base
  UpdateManager:RemoveUpdate(self.__OnUpdate)
  MsgCenter:RemoveListener(eMsgEventId.UserNameChanged, self.__OnUpdatePlayerName)
  MsgCenter:RemoveListener(eMsgEventId.TaskSyncFinish, self.__OnUpdateTask)
  MsgCenter:RemoveListener(eMsgEventId.UIOasisShow, self.__UIOasisShow)
  MsgCenter:RemoveListener(eMsgEventId.OnHasUncompletedEp, self.__onUpdateUncompletedEp)
  MsgCenter:RemoveListener(eMsgEventId.StaminaUpdate, self.__OnUpdateStamina)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__OnUpdateHeroCollectRate)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnUpdateItem)
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__OnActivityShowChange)
  MsgCenter:RemoveListener(eMsgEventId.UpdatePlayerLevel, self.__OnPlayerLevelChange)
  if self.__CheckInWarfarStage ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__CheckInWarfarStage)
    self.__CheckInWarfarStage = nil
  end
  self.oasisController = nil
  TimerManager:StopTimer(self.__animTimerId)
  if self.__fakeVoiceTimer ~= nil then
    TimerManager:StopTimer(self.__fakeVoiceTimer)
    self.__fakeVoiceTimer = nil
  end
  self:RemoveAllRedDotEvent()
  if self._mainBg ~= nil then
    (self._mainBg):Delete()
    ;
    (self._editorBg):Delete()
    self._mainBg = nil
    self._editorBg = nil
  end
  self._cm0 = nil
  self._cm1 = nil
  ;
  (base.OnDelete)(self)
end

return HomeController

