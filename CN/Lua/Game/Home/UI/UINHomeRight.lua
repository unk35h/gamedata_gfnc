-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHomeRight = class("UINHomeRight", UIBaseNode)
local base = UIBaseNode
local CS_SystemInfo = (CS.UnityEngine).SystemInfo
local CS_BatteryStatus = (CS.UnityEngine).BatteryStatus
local CS_Tweening = (CS.DG).Tweening
local CS_DoTween = CS_Tweening.DOTween
local cs_MessageCommon = CS.MessageCommon
local UINHomeGeneralBtn = require("Game.Home.UI.UINHomeGeneralBtn")
local UINHomeLotteryBtn = require("Game.Home.UI.UINHomeLotteryBtn")
local JumpManager = require("Game.Jump.JumpManager")
local NoticeData = require("Game.Notice.NoticeData")
local SectorEnum = require("Game.Sector.SectorEnum")
local UINHomeActivityEntryList = require("Game.Home.UI.Side.UINHomeActivityEntryList")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINHomeRight.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHomeActivityEntryList
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_openRightSide, self, self._SwitchUnfoldState)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exproation, self, self.OnClickEpBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Oasis, self, self.OnClickOasisBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Achievement, self, self.OnClickAchievementBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Shop, self, self.OnClickshopBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Factor, self, self.OnClickFactoryBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Warehouse, self, self.OnClickWarehouseBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Dorm, self, self.OnClickDormBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Lottery, self, self.OnClickLotteryBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroList, self, self.OnClickHeroListBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HandBook, self, self.OnClickHandBookBtn)
  self.__OnLimitItemOut = BindCallback(self, self.OnLimitItemOut)
  MsgCenter:AddListener(eMsgEventId.UpdateWareHouseLimitTime, self.__OnLimitItemOut)
  self.__RefreshBatteryAndTime = BindCallback(self, self.RefreshBatteryAndTime)
  self._seqFoldDic = {}
  self._seqUnFoldDic = {}
  self.isUnfold = false
  -- DECOMPILER ERROR at PC108: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).pageListLength = (((self.ui).tran_PageList).rect).width
  -- DECOMPILER ERROR at PC114: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).rectLength = (((self.ui).tran_ListRect).rect).width
  -- DECOMPILER ERROR at PC120: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).fullHandleLength = (((self.ui).tran_Handle).rect).width
  self.sectorActivityEntry = (UINHomeActivityEntryList.New)()
  ;
  (self.sectorActivityEntry):Init((self.ui).obj_ActivityEntry)
  local isUnlock = (PlayerDataCenter.sectorStage):IsStageComplete((ConfigData.game_config).guideFirstTipsEnd)
  ;
  ((self.ui).img_TipsGuide):SetActive(not isUnlock)
  PlayerDataCenter:CheckHaseLimitTimeItem()
  local isHasMin15LimitTimeItem = PlayerDataCenter:GetIsHasMin15LimitTime()
  self:OnLimitItemOut(isHasMin15LimitTimeItem)
end

UINHomeRight.OnHomeShow = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if self.BatteryTimerId ~= nil then
    TimerManager:StopTimer(self.BatteryTimerId)
    self.BatteryTimerId = nil
  end
  self.BatteryTimerId = TimerManager:StartTimer(1, self.__RefreshBatteryAndTime, nil, false, false, true)
  self:RefreshEpBtn()
  self:RefreshOasisBtn()
  self:RefreshAchievementBtn()
  self:RefreshshopBtn()
  self:RefreshFactoryBtn()
  self:RefreshWarehouseBtn()
  self:RefreshDormBtn()
  self:RefreshLotteryBtn()
  self:RefreshHeroListBtn()
  self:RefreshHandBooktn()
  ;
  (self.sectorActivityEntry):InitHomeActivityEntryList()
  for k,seq in pairs(self._seqFoldDic) do
    seq:Restart()
  end
end

UINHomeRight.InitHomeRightNode = function(self, homeUI)
  -- function num : 0_2
  self.homeUI = homeUI
  self.bind = homeUI.bind
  self.homeController = homeUI.homeController
  self:RefreshVersionInfo()
end

UINHomeRight.RefreshBatteryAndTime = function(self)
  -- function num : 0_3 , upvalues : CS_SystemInfo, CS_BatteryStatus, _ENV
  local batteryLevel = CS_SystemInfo.batteryLevel
  local batteryStatus = CS_SystemInfo.batteryStatus
  if batteryLevel == nil or batteryLevel < 0 then
    batteryLevel = 1
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_CurBattery).fillAmount = batteryLevel
  if batteryStatus == CS_BatteryStatus.Charging then
    ((self.ui).obj_recharge):SetActive(true)
  else
    ;
    ((self.ui).obj_recharge):SetActive(false)
  end
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Clock).text = (GR.GetLocalSystemTimeStr)()
end

UINHomeRight.RefreshVersionInfo = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local hasHotUpdateVer = (CS.ClientConsts).GameVersionStr
  local VerApp = ((CS.ClientConsts).GetGameVersionApp)()
  ;
  ((self.ui).tex_Version):SetIndex(0, VerApp, hasHotUpdateVer)
end

UINHomeRight.OnLimitItemOut = function(self, isHas)
  -- function num : 0_5
  if ((self.ui).obj_GiftTimeLimit).activeSelf ~= isHas then
    ((self.ui).obj_GiftTimeLimit):SetActive(isHas)
  end
end

UINHomeRight.OnClickEpBtn = function(self, doNotOpenEpStages)
  -- function num : 0_6 , upvalues : _ENV, JumpManager
  if (self.epBtn).isUnlock then
    if ExplorationManager:HasUncompletedEp() and JumpManager:GetSectorJumpId() == nil then
      local lastSelectSector = (PlayerDataCenter.sectorStage):GetSelectSectorId()
      local whiteDayctrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
      local isSuccess = (whiteDayctrl ~= nil and whiteDayctrl:TryEnterWDSector(lastSelectSector))
      if isSuccess then
        return 
      end
      local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
      if win23Ctrl ~= nil then
        isSuccess = win23Ctrl:TryEnterWTSector(lastSelectSector)
      else
        isSuccess = false
      end
      if isSuccess then
        return 
      end
    end
    self.doNotOpenEpStages = doNotOpenEpStages
    ;
    (self.homeUI):SetTo(AreaConst.Sector)
    ;
    (UIUtil.AddOneCover)("enterSectorTimeLine")
    ;
    ((self.bind).sectorPlayableDirector):Play()
    self.sectorBtnClicked = true
    AudioManager:PlayAudioById(1112)
  else
    AudioManager:PlayAudioById(1087)
    ;
    (self.epBtn):ShowUnlockDes()
  end
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UINHomeRight.RefreshEpBtn = function(self)
  -- function num : 0_7 , upvalues : UINHomeGeneralBtn, _ENV, SectorStageDetailHelper, JumpManager
  if self.epBtn == nil then
    self.epBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.epBtn):Init(((self.ui).btn_Exproation).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.epBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.Sector)
    ;
    (UIUtil.AddButtonListener)(((self.epBtn).ui).btn_ContinueEp, self, function()
    -- function num : 0_7_0 , upvalues : self, SectorStageDetailHelper
    (self.homeController):ResetShowHeroVoiceImme()
    ;
    (SectorStageDetailHelper.ContinueUncompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  end
)
    ;
    (UIUtil.AddButtonListener)(((self.epBtn).ui).btn_AddEpPoint, self, BindCallback(self, self.QickBuyStamina))
    ;
    (UIUtil.AddButtonListener)(((self.epBtn).ui).btn_pountInfo, self, BindCallback(self, self.ShowStaminaDetail))
    ;
    ((self.bind).sectorPlayableDirector):stopped("+", function(director)
    -- function num : 0_7_1 , upvalues : self, _ENV, JumpManager, SectorStageDetailHelper
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    if (self.bind).sectorPlayableDirector == director then
      if not self.sectorBtnClicked then
        ((self.bind).sectorPlayableDirector).initialTime = 0
        return 
      end
      self.sectorBtnClicked = false
      UIManager:DeleteWindow(UIWindowTypeID.Home)
      ;
      ((CS.GSceneManager).Instance):LoadSceneByAB((Consts.SceneName).Sector, function()
      -- function num : 0_7_1_0 , upvalues : self, JumpManager, _ENV, SectorStageDetailHelper
      if (self.homeUI).enterSectorJumpCallback ~= nil then
        local jumpId = JumpManager:GetSectorJumpId()
        local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        sectorController:SetJumpInCallback((self.homeUI).enterSectorJumpCallback)
        sectorController:SetFrom(AreaConst.Home, nil, jumpId)
        -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

        ;
        (self.homeUI).enterSectorJumpCallback = nil
      else
        do
          if (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep) and not self.doNotOpenEpStages then
            (ControllerManager:GetController(ControllerTypeId.SectorController, true)):SetFrom(AreaConst.Exploration)
          else
            ;
            (ControllerManager:GetController(ControllerTypeId.SectorController, true)):SetFrom(AreaConst.Home)
          end
          ;
          (UIUtil.CloseOneCover)("enterSectorTimeLine")
        end
      end
    end
)
    end
  end
)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration)
  ;
  (self.epBtn):RefeshUnlockInfo(isUnlock, unlockDes)
  if isUnlock then
    self:_SetExplorationTween()
  end
  self:RefreshContinueEp()
  self:RefreshStamina()
end

UINHomeRight.RefreshCurEpStage = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local sectorId, stageIndex, differIdex = (PlayerDataCenter.sectorStage):GetEpStageCfg4Home()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.epBtn).ui).tex_ProgressLevel).text = ConfigData:GetSectorInfoMsg(sectorId, stageIndex, differIdex)
end

UINHomeRight.RefreshNormalStage = function(self, stageId)
  -- function num : 0_9 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local sectorId = stageCfg.sector
  local difficultyId = stageCfg.difficulty
  local stageIndex = 0
  local difflist = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[difficultyId]
  for index,id in ipairs(difflist) do
    if id == stageId then
      stageIndex = index
    end
  end
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (((self.epBtn).ui).tex_CurLevel).text = ConfigData:GetSectorInfoMsg(sectorId, stageIndex, difficultyId)
end

UINHomeRight.RefreshEndlessStage = function(self, stageId)
  -- function num : 0_10 , upvalues : _ENV
  local eDynConfigData = require("Game.ConfigData.eDynConfigData")
  local endlessLevelDic = ((ConfigData.endless).levelDic)[stageId]
  local sectorId = endlessLevelDic.sectorId
  local depth = endlessLevelDic.index * 10
  local sectorCfg = (ConfigData.sector)[sectorId]
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (package.loaded)[eDynConfigData] = nil
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (((self.epBtn).ui).tex_CurLevel).text = ConfigData:GetEndlessInfoMsg(sectorCfg, depth)
end

UINHomeRight.RefreshChallengeStage = function(self, moduleId)
  -- function num : 0_11 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  (((self.epBtn).ui).tex_CurLevel).text = ConfigData:GetChallengeInfoMsg(moduleId)
end

UINHomeRight.RefreshContinueEp = function(self)
  -- function num : 0_12 , upvalues : SectorStageDetailHelper, _ENV
  local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  ;
  ((((self.epBtn).ui).btn_ContinueEp).gameObject):SetActive(hasHasUncompletedEp)
  ;
  (((self.epBtn).ui).obj_ProgressLevel):SetActive(not hasHasUncompletedEp)
  ;
  (((self.epBtn).ui).obj_curLevel):SetActive(hasHasUncompletedEp)
  if moduleId ~= proto_csmsg_SystemFunctionID.SystemFunctionID_Endless then
    local isEndless = not hasHasUncompletedEp
    do
      local isChallenge = moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_DailyChallenge or moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge
      if isEndless then
        self:RefreshEndlessStage(stageId)
      elseif isChallenge then
        self:RefreshChallengeStage(moduleId)
      else
        self:RefreshNormalStage(stageId)
      end
      self:RefreshCurEpStage()
      -- DECOMPILER ERROR: 6 unprocessed JMP targets
    end
  end
end

UINHomeRight.RefreshStamina = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local ceiling = (PlayerDataCenter.stamina):GetStaminaCeiling()
  local stamina, remainSecond = (PlayerDataCenter.stamina):GetCurrentStamina()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.epBtn).ui).tex_EpPoint).text = tostring(stamina)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.epBtn).ui).tex_EpPointLimit).text = "/" .. tostring(ceiling)
end

UINHomeRight.QickBuyStamina = function(self)
  -- function num : 0_14 , upvalues : JumpManager
  JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
end

UINHomeRight.ShowStaminaDetail = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if GuideManager.inGuide then
    return 
  end
  local window = UIManager:ShowWindow(UIWindowTypeID.GlobalItemDetail)
  if self.parentWindowType ~= nil then
    window:ParentWindowType(self.parentWindowType)
  end
  window:InitCommonItemDetail((ConfigData.item)[ConstGlobalItem.SKey])
end

UINHomeRight._SetExplorationTween = function(self)
  -- function num : 0_16
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (((self.epBtn).ui).canvas_Explore).alpha = 0
  local seq, isFirst = self:_CreateTweenSequence(self.epBtn)
  if not isFirst then
    return 
  end
  seq:SetDelay(0.35)
  seq:OnComplete(function()
    -- function num : 0_16_0 , upvalues : self
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R0 in 'UnsetPending'

    if not ((((self.epBtn).ui).canvas_Explore).gameObject).activeInHierarchy then
      (((self.epBtn).ui).canvas_Explore).alpha = 1
      return 
    end
    ;
    (((self.epBtn).ui).anim_Explore):Rewind()
    ;
    (((self.epBtn).ui).anim_Explore):Play()
  end
)
end

UINHomeRight.OnClickOasisBtn = function(self)
  -- function num : 0_17 , upvalues : _ENV
  if (self.oasisBtn).isUnlock then
    ((CS.RenderManager).Instance):SetUnityShadow(true)
    ;
    (self.homeUI):SetIsUnfold(false, true)
    ;
    (self.homeUI):OpenOtherCoverWin()
    ;
    ((CS.OasisCameraController).Instance):ResetOasisView()
    TimerManager:StartTimer(0.2, function()
    -- function num : 0_17_0 , upvalues : self
    (self.homeUI):HideBordGirl()
    ;
    (self.homeController):HideWarfarEffect()
  end
, nil, true)
    ;
    (self.homeUI):SetTo(AreaConst.Oasis)
    self:_ClearOasisTlCo()
    ;
    (self.homeController):IsEnterOasis(true)
    self.__tlOasisCo = (TimelineUtil.Play)((self.bind).oasisPlayableDirector)
    ;
    (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
    AudioManager:PlayAudioById(1016)
    local homeClicked = function()
    -- function num : 0_17_1 , upvalues : self, _ENV
    (self.homeController):IsEnterOasis(false)
    ;
    (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
    self:_ClearOasisTlCo()
    ;
    ((self.homeController).oasisController):OnExitOasis()
    AudioManager:PlayAudioById(1017)
    self.__tlOasisCo = (TimelineUtil.Rewind)((self.bind).oasisPlayableDirector, function()
      -- function num : 0_17_1_0 , upvalues : _ENV, self
      ((CS.RenderManager).Instance):SetUnityShadow(false)
      UIManager:ShowWindow(UIWindowTypeID.Home)
      ;
      (self.homeUI):ShowBordGirl()
      ;
      (self.homeUI):OnShow(true)
      ;
      (self.homeController):OnUpdate(true)
      ;
      (self.homeUI):SetFrom2Home(AreaConst.Oasis, true)
      UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    end
)
  end

    -- DECOMPILER ERROR at PC69: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.homeController).oasisController).backToHomeEvent = BindCallback(self, homeClicked)
  else
    do
      AudioManager:PlayAudioById(1087)
      ;
      (self.oasisBtn):ShowUnlockDes()
    end
  end
end

UINHomeRight.RefreshOasisBtn = function(self)
  -- function num : 0_18 , upvalues : UINHomeGeneralBtn, _ENV
  if self.oasisBtn == nil then
    self.oasisBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.oasisBtn):Init(((self.ui).btn_Oasis).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.oasisBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.Oasis)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BuildingBug)
  ;
  (self.oasisBtn):RefeshUnlockInfo(isUnlock, unlockDes)
  if isUnlock then
    self:_SetOasisBtnTween()
  end
  self:RefreshBuiltRate()
end

UINHomeRight.RefreshBuiltRate = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local rate = (PlayerDataCenter.AllBuildingData):GetOasisBuiltRate()
  rate = (math.floor)(rate * 100)
  ;
  (((self.oasisBtn).ui).tex_OasisDevRate):SetIndex(0, tostring(rate))
end

UINHomeRight._SetOasisBtnTween = function(self)
  -- function num : 0_20 , upvalues : _ENV, CS_Tweening
  local seq, isFirst = self:_CreateTweenSequence(self.oasisBtn)
  if not isFirst then
    return 
  end
  local aniComponents = ((self.oasisBtn).ui).aniComponents
  self:_SetComLocalMove((aniComponents[1]).transform, (Vector3.New)(10, -10, 0))
  seq:Append((((aniComponents[1]).transform):DOLocalMove((Vector3.New)(10, -10, 0), 0.35)):SetRelative(true))
  self:_SetComImageAlpha(aniComponents[1], 0)
  seq:Join((aniComponents[1]):DOFade(1, 0.35))
  self:_SetComLocalMove((aniComponents[2]).transform, (Vector3.New)(10, -10, 0))
  seq:Append((((aniComponents[2]).transform):DOLocalMove((Vector3.New)(10, -10, 0), 0.35)):SetRelative(true))
  self:_SetComImageAlpha(aniComponents[2], 0)
  seq:Join((aniComponents[2]):DOFade(1, 0.35))
  self:_SetComImageAlpha(aniComponents[3], 0)
  seq:Join(((aniComponents[3]):DOFade(0.4, 1)):SetDelay(0.7))
  seq:Join(((((aniComponents[3]).transform):DOLocalRotate((Vector3.New)(23, 10, -360), 100, (CS_Tweening.RotateMode).FastBeyond360)):SetLoops(-1)):SetDelay(0.7))
  seq:SetDelay(0.35)
  seq:Restart()
end

UINHomeRight.OnClickAchievementBtn = function(self)
  -- function num : 0_21 , upvalues : _ENV
  if (self.achievementBtn).isUnlock then
    UIManager:ShowWindowAsync(UIWindowTypeID.AchievementSystem, function(win)
    -- function num : 0_21_0 , upvalues : self, _ENV
    if win ~= nil then
      (self.homeUI):OpenOtherWin()
      win:SetFromWhichUI(eBaseWinFromWhere.home)
      win:InitAchievement(nil)
    end
  end
)
  end
end

UINHomeRight.RefreshAchievementBtn = function(self)
  -- function num : 0_22 , upvalues : UINHomeGeneralBtn, _ENV
  if self.achievementBtn == nil then
    self.achievementBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.achievementBtn):Init(((self.ui).btn_Achievement).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.achievementBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.AchivLevel)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Achievement)
  ;
  (self.achievementBtn):RefeshUnlockInfo(isUnlock)
  ;
  ((self.achievementBtn).gameObject):SetActive(isUnlock)
end

UINHomeRight.OnClickshopBtn = function(self)
  -- function num : 0_23 , upvalues : _ENV
  if (self.shopBtn).isUnlock then
    UIManager:ShowWindowAsync(UIWindowTypeID.ShopMain, function(window)
    -- function num : 0_23_0 , upvalues : _ENV, self
    if window ~= nil then
      window:SetFromWhichUI(eBaseWinFromWhere.home)
      window:InitShop()
      ;
      (self.homeUI):OpenOtherWin()
    end
  end
)
  else
    AudioManager:PlayAudioById(1087)
    ;
    (self.shopBtn):ShowUnlockDes()
  end
end

UINHomeRight.RefreshshopBtn = function(self)
  -- function num : 0_24 , upvalues : _ENV, UINHomeGeneralBtn
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store)
  local giftController = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  local shopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
  if self.shopBtn == nil then
    self.shopBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.shopBtn):Init(((self.ui).btn_Shop).gameObject)
    ;
    (self.shopBtn):RefeshUnlockInfo(isUnlock, unlockDes)
    local RefreshShopReddot = function(reddotNum)
    -- function num : 0_24_0 , upvalues : isUnlock, giftController, shopController, self, _ENV
    if isUnlock and not giftController:IsHaveNewGiftInShop() then
      local isHaveNewGift = shopController:GetIsHaveNewSkinGoodItemInShop()
    end
    local reddotCount = reddotNum
    if reddotCount == 0 then
      (self.shopBtn):RefreshRedDot(reddotCount)
      ;
      (((self.shopBtn).ui).obj_NewGift):SetActive(isHaveNewGift)
      if isHaveNewGift == false and giftController:CheckHaveLimitGift() then
        (((self.shopBtn).ui).obj_GiftTimeLimit):SetActive(true)
      else
        ;
        (((self.shopBtn).ui).obj_GiftTimeLimit):SetActive(false)
      end
      return 
    end
    local blueCount = 0
    local shopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
    for _,shopId in ipairs((ConfigData.shop).id_sort_list) do
      if shopController:IsShopBlueReddot(shopId) then
        local ok, tempNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
        local tempCount = ok and tempNode:GetRedDotCount() or 0
        blueCount = blueCount + tempCount
      end
    end
    local isRedDot = reddotCount ~= blueCount
    ;
    (((self.shopBtn).ui).obj_GiftTimeLimit):SetActive(false)
    ;
    (((self.shopBtn).ui).obj_NewGift):SetActive((not isRedDot and isHaveNewGift))
    if not isHaveNewGift or isRedDot then
      (self.shopBtn):RefreshRedDot(reddotCount, not isRedDot)
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end

    do
      (self.homeController):AddRedDotEvent(RefreshShopReddot, RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow)
      shopController:IsHaveNewSkinGoodItemInShop(function(isHaveNew)
    -- function num : 0_24_1 , upvalues : _ENV, RefreshShopReddot
    if isHaveNew then
      local ok, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow)
      RefreshShopReddot(node:GetRedDotCount())
    end
  end
)
    end
  else
    do
      ;
      (self.shopBtn):RefeshUnlockInfo(isUnlock, unlockDes)
      if isUnlock and not giftController:IsHaveNewGiftInShop() then
        local isHaveNewGift = shopController:GetIsHaveNewSkinGoodItemInShop()
      end
      local ok, tempNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow)
      local reddotCount = ok and tempNode:GetRedDotCount() or 0
      local blueCount = 0
      local shopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
      for _,shopId in ipairs((ConfigData.shop).id_sort_list) do
        if shopController:IsShopBlueReddot(shopId) then
          local ok, tempNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
          local tempCount = ok and tempNode:GetRedDotCount() or 0
          blueCount = blueCount + tempCount
        end
      end
      do
        local isRedDot = reddotCount ~= blueCount
        ;
        (((self.shopBtn).ui).obj_NewGift):SetActive((not isRedDot and isHaveNewGift))
        if not isHaveNewGift or isRedDot then
          (self.shopBtn):RefreshRedDot(reddotCount, not isRedDot)
        end
        if isHaveNewGift == false and giftController:CheckHaveLimitGift() and reddotCount == 0 then
          (((self.shopBtn).ui).obj_GiftTimeLimit):SetActive(true)
        else
          (((self.shopBtn).ui).obj_GiftTimeLimit):SetActive(false)
        end
        ;
        ((((self.epBtn).ui).btn_AddEpPoint).gameObject):SetActive(isUnlock)
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end

UINHomeRight.OnClickFactoryBtn = function(self)
  -- function num : 0_25 , upvalues : _ENV
  if (self.factoryBtn).isUnlock then
    (self.homeUI):SetTo(AreaConst.FactoryDorm)
    ;
    (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
    ;
    ((self.bind).factorydormPlayableDirector):Play()
    self.factoryBtnClicked = true
  else
    AudioManager:PlayAudioById(1087)
    ;
    (self.factoryBtn):ShowUnlockDes()
  end
end

UINHomeRight.RefreshFactoryEnergy = function(self)
  -- function num : 0_26 , upvalues : _ENV, NoticeData, JumpManager
  if self.factoryBtn ~= nil and (self.factoryBtn).isUnlock then
    local factoryEnergyItemId = (ConfigData.game_config).factoryEnergyItemId
    local totalCeiling = (PlayerDataCenter.playerBonus):GetWarehouseCapcity(factoryEnergyItemId)
    local totalValue = PlayerDataCenter:GetItemCount(factoryEnergyItemId)
    if totalCeiling <= totalValue then
      NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).FactoryEnergyFull, {jumpType = (JumpManager.eJumpTarget).Factory, argList = nil}, nil, nil))
    else
      NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).FactoryEnergyFull)
    end
    local rate = totalValue / totalCeiling
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.factoryBtn).ui).tex_energy).text = tostring(totalValue)
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.factoryBtn).ui).img_fill).fillAmount = rate
    local ok, factoryNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Factory, RedDotStaticTypeId.FactoryEnerage)
    if ok then
      if totalCeiling <= totalValue then
        factoryNode:SetRedDotCount(1)
      else
        factoryNode:SetRedDotCount(0)
      end
    end
  end
end

UINHomeRight.RefreshFactoryBtn = function(self)
  -- function num : 0_27 , upvalues : UINHomeGeneralBtn, _ENV
  if self.factoryBtn == nil then
    self.factoryBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.factoryBtn):Init(((self.ui).btn_Factor).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.factoryBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.Factory)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Factory)
  ;
  (self.factoryBtn):RefeshUnlockInfo(isUnlock, unlockDes)
  if isUnlock then
    self:RefreshFactoryEnergy()
  end
  ;
  ((self.bind).factorydormPlayableDirector):stopped("+", function(director)
    -- function num : 0_27_0 , upvalues : self, _ENV
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    if (self.bind).factorydormPlayableDirector == director then
      if not self.factoryBtnClicked then
        ((self.bind).factorydormPlayableDirector).initialTime = 0
        return 
      end
      self.factoryBtnClicked = false
      UIManager:DeleteWindow(UIWindowTypeID.Home)
      UIManager:HideWindow(UIWindowTypeID.ClickContinue)
      ;
      (ControllerManager:GetController(ControllerTypeId.Factory, true)):OpenFactory()
    end
  end
)
end

UINHomeRight.OnClickWarehouseBtn = function(self)
  -- function num : 0_28 , upvalues : _ENV
  if (self.warehouseBtn).isUnlock then
    UIManager:ShowWindowAsync(UIWindowTypeID.Warehouse, function(window)
    -- function num : 0_28_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:SetFromWhichUI(eBaseWinFromWhere.home)
    ;
    (self.homeUI):OpenOtherWin()
    window:InitWarehouse()
  end
)
  else
    AudioManager:PlayAudioById(1087)
    ;
    (self.warehouseBtn):ShowUnlockDes()
  end
end

UINHomeRight.RefreshWarehouseBtn = function(self)
  -- function num : 0_29 , upvalues : UINHomeGeneralBtn, _ENV
  if self.warehouseBtn == nil then
    self.warehouseBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.warehouseBtn):Init(((self.ui).btn_Warehouse).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.warehouseBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.Warehouse)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Backpack_ui)
  ;
  (self.warehouseBtn):RefeshUnlockInfo(isUnlock, unlockDes)
end

UINHomeRight.OnClickDormBtn = function(self)
  -- function num : 0_30 , upvalues : _ENV, cs_MessageCommon
  if (self.dormBtn).isUnlock then
    (ControllerManager:GetController(ControllerTypeId.Dorm, true)):EnterDorm()
  else
    local openCfg = (ConfigData.system_open)[proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm]
    if openCfg ~= nil and openCfg.screening then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(170))
    else
      AudioManager:PlayAudioById(1087)
      ;
      (self.dormBtn):ShowUnlockDes()
    end
  end
end

UINHomeRight.RefreshDormBtn = function(self)
  -- function num : 0_31 , upvalues : UINHomeGeneralBtn, _ENV
  if self.dormBtn == nil then
    self.dormBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.dormBtn):Init(((self.ui).btn_Dorm).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.dormBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm)
  ;
  (self.dormBtn):RefeshUnlockInfo(isUnlock, unlockDes)
end

UINHomeRight.OnClickLotteryBtn = function(self, defaultSelectPoolId)
  -- function num : 0_32 , upvalues : _ENV
  if (self.lotteryBtn).isUnlock then
    local ctrl = ControllerManager:GetController(ControllerTypeId.Lottery, true)
    ctrl:InitLottery(function(win)
    -- function num : 0_32_0 , upvalues : _ENV, self
    win:SetFromWhichUI(eBaseWinFromWhere.home)
    ;
    (self.homeUI):OpenOtherWin()
  end
, defaultSelectPoolId)
  else
    do
      AudioManager:PlayAudioById(1087)
      ;
      (self.lotteryBtn):ShowUnlockDes()
    end
  end
end

UINHomeRight.RefreshLotteryBtn = function(self)
  -- function num : 0_33 , upvalues : UINHomeLotteryBtn, _ENV
  if self.lotteryBtn == nil then
    self.lotteryBtn = (UINHomeLotteryBtn.New)()
    ;
    (self.lotteryBtn):Init(((self.ui).btn_Lottery).gameObject)
    ;
    (self.lotteryBtn):InitHomeLotteryBtn()
    ;
    (self.homeController):AddRedDotEvent((self.lotteryBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.Lottery)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Lottery)
  ;
  (self.lotteryBtn):RefeshUnlockInfo(isUnlock, unlockDes)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

  if isUnlock then
    (self.lotteryBtn).costItemNumDic = {}
    self:InitLotteryCostItem()
    self:_SetLotteryTween()
  else
    ;
    (((self.lotteryBtn).ui).obj_costItem1):SetActive(false)
    ;
    (((self.lotteryBtn).ui).obj_costItem2):SetActive(false)
  end
end

UINHomeRight.InitLotteryCostItem = function(self)
  -- function num : 0_34 , upvalues : _ENV
  (((self.lotteryBtn).ui).obj_costItem1):SetActive(false)
  ;
  (((self.lotteryBtn).ui).obj_costItem2):SetActive(false)
  local itemCfg1 = (ConfigData.item)[ConstGlobalItem.LotteryTicket1]
  if itemCfg1 == nil then
    error("Can\'t find itemCfg by Id:" .. tostring(ConstGlobalItem.LotteryTicket1))
    return 
  end
  ;
  (((self.lotteryBtn).ui).obj_costItem1):SetActive(true)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.lotteryBtn).ui).cost1_img_Icon).sprite = CRH:GetSprite(itemCfg1.small_icon)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.lotteryBtn).ui).cost1_tex_Count).text = PlayerDataCenter:GetItemCount(ConstGlobalItem.LotteryTicket1)
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.lotteryBtn).costItemNumDic)[ConstGlobalItem.LotteryTicket1] = ((self.lotteryBtn).ui).cost1_tex_Count
  local itemCfg2 = (ConfigData.item)[ConstGlobalItem.LotteryTicket2]
  if itemCfg2 == nil then
    error("Can\'t find itemCfg by Id:" .. tostring(ConstGlobalItem.LotteryTicket2))
    return 
  end
  ;
  (((self.lotteryBtn).ui).obj_costItem2):SetActive(true)
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.lotteryBtn).ui).cost2_img_Icon).sprite = CRH:GetSprite(itemCfg2.small_icon)
  -- DECOMPILER ERROR at PC97: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.lotteryBtn).ui).cost2_tex_Count).text = PlayerDataCenter:GetItemCount(ConstGlobalItem.LotteryTicket2)
  -- DECOMPILER ERROR at PC105: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.lotteryBtn).costItemNumDic)[ConstGlobalItem.LotteryTicket2] = ((self.lotteryBtn).ui).cost2_tex_Count
end

UINHomeRight.RefreshLotteryCost = function(self, fromeAuto)
  -- function num : 0_35 , upvalues : _ENV
  if (self.lotteryBtn).costItemNumDic ~= nil then
    for itemId,textComponent in pairs((self.lotteryBtn).costItemNumDic) do
      do
        if fromeAuto and (PlayerDataCenter.allEffectorData):IsAutoGenerateResource(itemId) then
          local num = tostring(PlayerDataCenter:GetItemCount(itemId))
          if textComponent.text ~= num then
            textComponent.text = num
          end
        end
        do
          local num = tostring(PlayerDataCenter:GetItemCount(itemId))
          if textComponent.text ~= num then
            textComponent.text = num
          end
          -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
  end
end

UINHomeRight._SetLotteryTween = function(self)
  -- function num : 0_36 , upvalues : _ENV
  local seq, isFirst = self:_CreateTweenSequence(self.lotteryBtn, true)
  if not isFirst then
    return 
  end
  local aniComponents = ((self.lotteryBtn).ui).aniComponents
  self:_SetComLocalMove(aniComponents[1], (Vector3.New)(100, 100, 0))
  seq:Append(((aniComponents[1]):DOLocalMove((Vector3.New)(100, 100, 0), 2)):SetRelative(true))
  self:_SetComLocalMove(aniComponents[3], (Vector3.New)(100, 100, 0))
  seq:Join(((aniComponents[3]):DOLocalMove((Vector3.New)(100, 100, 0), 1)):SetRelative(true))
  seq:Insert(1, (((aniComponents[2]).transform):DOScale((Vector3.New)(0.8, 0.8, 1), 2)):From())
  self:_SetComImageAlpha(aniComponents[2], 0)
  seq:Join((aniComponents[2]):DOFade(1, 2))
  seq:Rewind()
end

UINHomeRight.OnClickHeroListBtn = function(self)
  -- function num : 0_37 , upvalues : _ENV
  if (self.heroListBtn).isUnlock then
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroList, function(win)
    -- function num : 0_37_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    TimerManager:StartTimer(1, (self.homeUI).OpenOtherWin, self.homeUI, true, true, true)
  end
, nil, eBaseWinFromWhere.home)
  else
    AudioManager:PlayAudioById(1087)
    ;
    (self.heroListBtn):ShowUnlockDes()
  end
end

UINHomeRight.RefreshHeroListBtn = function(self)
  -- function num : 0_38 , upvalues : UINHomeGeneralBtn, _ENV
  if self.heroListBtn == nil then
    self.heroListBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.heroListBtn):Init(((self.ui).btn_HeroList).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.heroListBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.HeroWindow)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroGroup)
  ;
  (self.heroListBtn):RefeshUnlockInfo(isUnlock, unlockDes)
  self:RefreshCollectRate()
end

UINHomeRight.RefreshCollectRate = function(self)
  -- function num : 0_39 , upvalues : _ENV
  local totalCount = (ConfigData.hero_data).totalHeroCount
  local collectRate = 0
  collectRate = (math.ceil)(PlayerDataCenter.heroCount / totalCount * 100)
  local strCollRate = tostring(collectRate)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.heroListBtn).ui).tex_bigCollect).text = strCollRate
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.heroListBtn).ui).tex_smallCollect).text = strCollRate
  self:_SetHeroListBtnTween(collectRate)
end

UINHomeRight.OnClickHandBookBtn = function(self)
  -- function num : 0_40 , upvalues : _ENV
  if (self.handBookBtn).isUnlock then
    local handBookCtrl = ControllerManager:GetController(ControllerTypeId.HandBook, true)
    handBookCtrl:OpenHandBookMain(eBaseWinFromWhere.home)
    ;
    (self.homeUI):OpenOtherWin()
  else
    do
      AudioManager:PlayAudioById(1087)
      ;
      (self.handBookBtn):ShowUnlockDes()
    end
  end
end

UINHomeRight.RefreshHandBooktn = function(self)
  -- function num : 0_41 , upvalues : UINHomeGeneralBtn, _ENV
  if self.handBookBtn == nil then
    self.handBookBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.handBookBtn):Init(((self.ui).btn_HandBook).gameObject)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HandBook)
  ;
  (self.handBookBtn):RefeshUnlockInfo(isUnlock, unlockDes)
end

UINHomeRight.SetHomeHandBookBtn = function(self, active)
  -- function num : 0_42
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).btn_HandBook).enabled = active
end

UINHomeRight._SetHeroListBtnTween = function(self, collectRate)
  -- function num : 0_43 , upvalues : _ENV, CS_Tweening
  local seq = (self._seqUnFoldDic)[self.heroListBtn]
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if self.collectRate ~= collectRate then
    (((self.heroListBtn).ui).img_Collect).fillAmount = 0
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.heroListBtn).ui).img_Angle).localRotation = (Quaternion.Euler)(0, 0, 0)
    if seq ~= nil then
      seq:Kill()
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self._seqUnFoldDic)[self.heroListBtn] = nil
    end
    seq = self:_CreateTweenSequence(self.heroListBtn, true)
    seq:Append(((((self.heroListBtn).ui).img_Collect):DOFillAmount(collectRate / 100, 1.25, (CS_Tweening.RotateMode).FastBeyond360)):SetEase((CS_Tweening.Ease).OutExpo))
    seq:Join(((((self.heroListBtn).ui).img_Angle):DOLocalRotate((Vector3.New)(0, 0, -collectRate / 100 * 360), 1.25, (CS_Tweening.RotateMode).FastBeyond360)):SetEase((CS_Tweening.Ease).OutExpo))
    self.collectRate = collectRate
  end
  seq:Restart()
end

UINHomeRight._ClearOasisTlCo = function(self)
  -- function num : 0_44 , upvalues : _ENV
  if self.__tlOasisCo ~= nil then
    (TimelineUtil.StopTlCo)(self.__tlOasisCo)
    self.__tlOasisCo = nil
  end
end

UINHomeRight._SwitchUnfoldState = function(self)
  -- function num : 0_45
  (self.homeUI):SwitchUnfold()
end

local SCALE_CLOSE = (Vector3.New)(-1, 1, 1)
UINHomeRight.SetUnfoldBtnState = function(self, isUnfold)
  -- function num : 0_46 , upvalues : SCALE_CLOSE, _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if isUnfold then
    (((self.ui).btn_openRightSide).transform).localScale = SCALE_CLOSE
  else
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).btn_openRightSide).transform).localScale = Vector3.one
  end
end

UINHomeRight.UpdateHomeRightUnfoldRate = function(self, rate)
  -- function num : 0_47
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if self.heroListBtn ~= nil then
    (((self.heroListBtn).ui).bIGNode).alpha = rate
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.heroListBtn).ui).sMALLNode).alpha = 1 - rate
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  if self.handBookBtn ~= nil then
    (((self.handBookBtn).ui).cg_btn_HandBook).alpha = rate
  end
  local posX = ((self.ui).rectLength - (self.ui).pageListLength) * rate
  self:RefreshScrollbarHandle(posX)
end

UINHomeRight.OnHomeRightIsUnfold = function(self, isUnfold)
  -- function num : 0_48 , upvalues : _ENV
  if self.isUnfold == isUnfold then
    return 
  end
  if isUnfold then
    for k,seq in pairs(self._seqUnFoldDic) do
      seq:Restart()
    end
  else
    do
      for k,seq in pairs(self._seqUnFoldDic) do
        seq:Pause()
        seq:Rewind()
      end
      do
        self.isUnfold = isUnfold
        self:SetUnfoldBtnState(isUnfold)
      end
    end
  end
end

UINHomeRight._CreateTweenSequence = function(self, key, isUnfold)
  -- function num : 0_49 , upvalues : CS_DoTween
  if isUnfold ~= true or not self._seqUnFoldDic then
    local tab = self._seqFoldDic
  end
  local seq = tab[key]
  local isFirst = false
  if seq == nil then
    seq = (CS_DoTween.Sequence)()
    seq:SetAutoKill(false)
    tab[key] = seq
    isFirst = true
  end
  return seq, isFirst
end

UINHomeRight._SetComLocalMove = function(self, com, pos)
  -- function num : 0_50
  local pos1 = com.localPosition
  com.localPosition = pos1 - pos
end

UINHomeRight._SetComImageAlpha = function(self, com, alpha)
  -- function num : 0_51 , upvalues : _ENV
  local col = com.color
  com.color = (Color.New)(col.r, col.g, col.b, alpha)
end

UINHomeRight.OnHomeHide = function(self)
  -- function num : 0_52 , upvalues : _ENV
  if self.BatteryTimerId ~= nil then
    TimerManager:StopTimer(self.BatteryTimerId)
    self.BatteryTimerId = nil
  end
end

UINHomeRight.RefreshScrollbarHandle = function(self, x)
  -- function num : 0_53 , upvalues : _ENV
  local ratio = ((self.ui).pageListLength + x) / (self.ui).rectLength
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tran_Handle).sizeDelta = (Vector2.New)((self.ui).fullHandleLength * ratio, 8)
end

UINHomeRight.OnDelete = function(self)
  -- function num : 0_54 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateWareHouseLimitTime, self.__OnLimitItemOut)
  if self.lotteryBtn ~= nil then
    (self.lotteryBtn):Delete()
    self.lotteryBtn = nil
  end
  ;
  (self.sectorActivityEntry):Delete()
  for k,seq in pairs(self._seqFoldDic) do
    seq:Kill()
  end
  self._seqFoldDic = nil
  for k,seq in pairs(self._seqUnFoldDic) do
    seq:Kill()
  end
  self._seqUnFoldDic = nil
  ;
  (base.OnDelete)(self)
end

return UINHomeRight

