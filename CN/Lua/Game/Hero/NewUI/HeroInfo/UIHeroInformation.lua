-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeroInformation = class("UIHeroInformation", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local UINHeroInfoAchriveNode = require("Game.Hero.NewUI.HeroInfo.UINHeroInfoAchriveNode")
local UINHeroInfoStrotyNode = require("Game.Hero.NewUI.HeroInfo.UINHeroInfoStrotyNode")
local UINHeroInfoVoiceNode = require("Game.Hero.NewUI.HeroInfo.UINHeroInfoVoiceNode")
local UINHeroInfoFrageState = require("Game.Hero.NewUI.HeroInfo.UINHeroInfoFrageState")
local HeroInfoTextUtil = require("Game.Hero.NewUI.HeroInfo.HeroInfoTextUtil")
local JumpManager = require("Game.Jump.JumpManager")
UIHeroInformation.eNodeType = {achrive = 1, story = 2, voice = 3}
local eNodeType = UIHeroInformation.eNodeType
local eNodeTypeClass = {[eNodeType.achrive] = UINHeroInfoAchriveNode, [eNodeType.story] = UINHeroInfoStrotyNode, [eNodeType.voice] = UINHeroInfoVoiceNode}
local waitRecorverNUM = 0
UIHeroInformation.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, eNodeType, eNodeTypeClass
  self.nodeDic = {}
  self.togUI = {}
  self.resloader = (cs_ResLoader.Create)()
  for _,typeId in pairs(eNodeType) do
    (UIUtil.AddValueChangedListener)(((self.ui).tog_list)[typeId], self, self.__OnClickTog, typeId)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.togUI)[typeId] = {}
    ;
    (UIUtil.LuaUIBindingTable)((((self.ui).tog_list)[typeId]).transform, (self.togUI)[typeId])
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.nodeDic)[typeId] = ((eNodeTypeClass[typeId]).New)()
    ;
    ((self.nodeDic)[typeId]):Init(((self.ui).nodeGo)[typeId])
  end
  ;
  ((self.ui).boj_heroChipInfo):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_LeftArrow, self, self._OnLeftBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RightArrow, self, self._OnRightBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AVGNoun, self, self.OnClickAvgNoun)
  ;
  (UIUtil.AddButtonListener)((self.ui).Btn_friendShip, self, self._OnfriendShipClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroBackOff, self, self.__OnClickHeroBackOff)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_voiceLock, self, self.OnClickLockedVoiceBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AVGCharDun, self, self.OnClickCharDun)
  self.__shiftHeroData = BindCallback(self, self.__ShiftHeroData)
end

UIHeroInformation.InitHeroInformation = function(self, heroData, closeCallback, switchHeroFunc, notAdd2BackStack, isReturn)
  -- function num : 0_1 , upvalues : _ENV
  if not notAdd2BackStack then
    (UIUtil.SetTopStatus)(self, self.OnClickReturn)
  end
  self.closeCallback = closeCallback
  if self.winTween ~= nil then
    (self.winTween):Complete()
  end
  self:StopHomeLive2dVoice()
  self:RefreshHeroInformation(heroData, switchHeroFunc, isReturn)
end

UIHeroInformation.RefreshHeroInformation = function(self, heroData, switchHeroFunc, isReturn)
  -- function num : 0_2
  self.heroData = heroData
  self.switchHeroFunc = switchHeroFunc
  local active = switchHeroFunc ~= nil
  ;
  (((self.ui).btn_LeftArrow).gameObject):SetActive(active)
  ;
  (((self.ui).btn_RightArrow).gameObject):SetActive(active)
  ;
  ((self.ui).tween_info):DORestart()
  self:SwitchHero(heroData, nil, isReturn)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIHeroInformation.StopHomeLive2dVoice = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local homeController = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeController ~= nil then
    homeController:ResetShowHeroVoiceImme()
  end
end

UIHeroInformation.SwitchHero = function(self, heroData, reUseBigImgResLoader, isReturn)
  -- function num : 0_4 , upvalues : _ENV, HeroInfoTextUtil, eNodeType
  self.heroData = heroData
  self.isLocked = heroData.isLockedHero or (PlayerDataCenter.heroDic)[heroData.dataId] == nil
  self:RefreshFrageStateNode()
  local cvController = ControllerManager:GetController(ControllerTypeId.Cv, true)
  cvController:RemoveAllCvText()
  cvController:RemoveCvAllCueSheet(true)
  for type,node in pairs(self.nodeDic) do
    node:InitUsefulData(heroData, HeroInfoTextUtil, self.resloader)
    node:InitHeroInfoNode()
    if node.playerRateTimer ~= nil then
      (node.playerRateTimer):Stop()
      node.playerRateTimer = nil
      ;
      (node.playerRateCallback)(1)
    end
  end
  if not isReturn then
    for _,tog in ipairs((self.ui).tog_list) do
      tog.isOn = true
      break
    end
  end
  local hasVoice = (ControllerManager:GetController(ControllerTypeId.Cv, true)):HasCv(heroData.dataId)
  ;
  (((self.ui).Btn_friendShip).gameObject):SetActive(not self.isLocked)
  -- DECOMPILER ERROR at PC83: Confused about usage of register: R6 in 'UnsetPending'

  if self.isLocked then
    (((self.ui).tog_list)[eNodeType.voice]).interactable = false
    ;
    ((self.ui).obj_img_voiceLock):SetActive(true)
  else
    -- DECOMPILER ERROR at PC94: Confused about usage of register: R6 in 'UnsetPending'

    (((self.ui).tog_list)[eNodeType.voice]).interactable = true
    ;
    ((self.ui).obj_img_voiceLock):SetActive(false)
  end
  self:__RefreshLeftUI()
  self:__ShowHeroSkin(reUseBigImgResLoader)
  ;
  ((self.nodeDic)[eNodeType.story]):StopPlayVoice()
  ;
  ((self.nodeDic)[eNodeType.voice]):StopPlayVoice()
  self:RefreshHeroBackOff()
  local showDunEnter, sectorId = self:__GetDunSectorId()
  ;
  (((self.ui).btn_AVGCharDun).gameObject):SetActive(showDunEnter)
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UIHeroInformation.__PlayAllDOTweenBackwards = function(self)
  -- function num : 0_5
  ((self.ui).tween_heroHolder):DOPlayBackwards()
  ;
  ((self.ui).tween_info):DOPlayBackwards()
end

UIHeroInformation.__RefreshLeftUI = function(self)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Name).text = (self.heroData):GetName()
  local birthday, model, cv, archives_career = (self.heroData):GetHeroArchiveInfo()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_CV_Name).text = cv
  local friendShipLevel = (PlayerDataCenter.allFriendshipData):GetLevel((self.heroData).dataId)
  local curLevelExp = (PlayerDataCenter.allFriendshipData):GetExp((self.heroData).dataId)
  local curLevelTotalExp = ((ConfigData.friendship_level)[friendShipLevel]).friendship
  ;
  ((self.ui).tex_FrienshipLevel):SetIndex(0, tostring(friendShipLevel))
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_FriendshipBar).fillAmount = curLevelExp / curLevelTotalExp
end

UIHeroInformation.__ShowHeroSkin = function(self, reUseBigImgResLoader)
  -- function num : 0_7 , upvalues : _ENV, cs_ResLoader
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if reUseBigImgResLoader ~= nil then
    if not IsNull(self.bigImgGameObject) then
      (self.bigImgGameObject):SetActive(false)
    end
    reUseBigImgResLoader:LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath((self.heroData):GetResPicName()), function(prefab)
    -- function num : 0_7_0 , upvalues : _ENV, self
    DestroyUnityObject(self.bigImgGameObject)
    if IsNull(prefab) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate((self.ui).heroHolder)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
    do
      if self.isLocked or (self.heroData):GetHeroIsNotHaveLegalSkin() then
        local rawImage = (self.bigImgGameObject):FindComponent(eUnityComponentID.RawImage)
        rawImage.material = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_heroPicPaperCut)
      end
      ;
      ((self.ui).tween_heroHolder):DORestart()
    end
  end
)
  else
    self.bigImgResloader = (cs_ResLoader.Create)()
    if not IsNull(self.bigImgGameObject) then
      (self.bigImgGameObject):SetActive(false)
    end
    ;
    (self.bigImgResloader):LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath((self.heroData):GetResPicName()), function(prefab)
    -- function num : 0_7_1 , upvalues : _ENV, self
    DestroyUnityObject(self.bigImgGameObject)
    if IsNull(prefab) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate((self.ui).heroHolder)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
    do
      if self.isLocked then
        local rawImage = (self.bigImgGameObject):FindComponent(eUnityComponentID.RawImage)
        rawImage.material = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_heroPicPaperCut)
      end
      ;
      ((self.ui).tween_heroHolder):DORestart()
    end
  end
)
  end
end

UIHeroInformation.RefreshHeroBackOff = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.isLocked then
    (((self.ui).btn_HeroBackOff).gameObject):SetActive(false)
    return 
  end
  local ok = PlayerDataCenter:IsHeroBackOffEnable((self.heroData).dataId)
  ;
  (((self.ui).btn_HeroBackOff).gameObject):SetActive(ok)
end

UIHeroInformation.__OnClickHeroBackOff = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local ok = PlayerDataCenter:IsHeroBackOffEnable((self.heroData).dataId)
  if not ok then
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_9_0 , upvalues : _ENV
    if win == nil then
      return 
    end
    win:ShowTextBoxWithConfirm((ConfigData:GetTipContent(556)), nil)
  end
)
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroBackOff, function(win)
    -- function num : 0_9_1 , upvalues : self
    if win == nil then
      return 
    end
    win:InitHeroBackOffUI(self.heroData)
  end
)
end

UIHeroInformation.__OnClickTog = function(self, type, bool)
  -- function num : 0_10
  if not bool then
    if (self.nodeDic)[type] ~= nil then
      ((self.nodeDic)[type]):Hide()
      ;
      ((((self.nodeDic)[type]).ui).fade):DOKill()
    end
    ;
    (((self.togUI)[type]).img_UnSel):SetActive(true)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.togUI)[type]).tex_pageName).color = (self.ui).colot_unselected
    return 
  end
  ;
  (((self.togUI)[type]).img_UnSel):SetActive(false)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.togUI)[type]).tex_pageName).color = (self.ui).color_selected
  ;
  ((self.nodeDic)[type]):Show()
  ;
  ((self.nodeDic)[type]):InitHeroInfoNode()
  -- DECOMPILER ERROR at PC53: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((((self.nodeDic)[type]).ui).fade).alpha = 1
  ;
  (((((self.nodeDic)[type]).ui).fade):DOFade(0, 0.25)):From()
end

UIHeroInformation.SwitchTog = function(self, activeTypeId)
  -- function num : 0_11 , upvalues : _ENV, eNodeType
  for _,typeId in pairs(eNodeType) do
    local isOn = activeTypeId == typeId
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).tog_list)[typeId]).isOn = isOn
    self:__OnClickTog(typeId, isOn)
  end
  local switchToToggle = ((self.ui).tog_list)[activeTypeId]
  if not IsNull(switchToToggle) then
    (switchToToggle.group):NotifyToggleOn(switchToToggle)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIHeroInformation.RefreshFrageStateNode = function(self)
  -- function num : 0_12 , upvalues : UINHeroInfoFrageState
  if self.isLocked and not (self.heroData):IsHeroNotMergeable() then
    if self.frageStateNode == nil then
      self.frageStateNode = (UINHeroInfoFrageState.New)()
      ;
      (self.frageStateNode):Init((self.ui).boj_heroChipInfo)
    end
    ;
    (self.frageStateNode):Show()
  else
    if self.frageStateNode ~= nil then
      (self.frageStateNode):Hide()
    end
    return 
  end
  ;
  (self.frageStateNode):RefreshFrageState(self.heroData, self.resloader)
end

UIHeroInformation.__UnloadHeroVoiceAndStory = function(self)
  -- function num : 0_13 , upvalues : _ENV, HeroInfoTextUtil
  local cvController = ControllerManager:GetController(ControllerTypeId.Cv, true)
  cvController:RemoveAllCvText()
  cvController:RemoveCvAllCueSheet(true)
  ;
  (HeroInfoTextUtil.RemoveAllArchiveText)()
end

UIHeroInformation.OnTcpLogout_HeroInfo = function(self)
  -- function num : 0_14 , upvalues : _ENV, eNodeType
  for _,typeId in pairs(eNodeType) do
    ((self.nodeDic)[typeId]):OnTcpLogOut_HeroInfoNode()
  end
end

UIHeroInformation.OnClickReturn = function(self)
  -- function num : 0_15 , upvalues : waitRecorverNUM
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self:__PlayAllDOTweenBackwards()
  if waitRecorverNUM > 0 then
    self:Hide()
  else
    self:Delete()
  end
end

UIHeroInformation.__ShiftHeroData = function(self, heroData)
  -- function num : 0_16
  if heroData == nil or heroData:GetIsNotShowInfo() then
    return true
  end
end

UIHeroInformation._OnLeftBtnClick = function(self)
  -- function num : 0_17
  if self.switchHeroFunc ~= nil then
    local newHeroData, reUseBigImgResloader = (self.switchHeroFunc)(-1, self.__shiftHeroData)
    if newHeroData ~= nil then
      self:SwitchHero(newHeroData, reUseBigImgResloader)
    end
  end
end

UIHeroInformation._OnRightBtnClick = function(self)
  -- function num : 0_18
  if self.switchHeroFunc ~= nil then
    local newHeroData, reUseBigImgResloader = (self.switchHeroFunc)(1, self.__shiftHeroData)
    if newHeroData ~= nil then
      self:SwitchHero(newHeroData, reUseBigImgResloader)
    end
  end
end

UIHeroInformation._OnfriendShipClick = function(self)
  -- function num : 0_19 , upvalues : _ENV, cs_MessageCommon
  do
    if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_friendship) then
      local des = FunctionUnlockMgr:GetFuncUnlockDecription(proto_csmsg_SystemFunctionID.SystemFunctionID_friendship)
      ;
      (cs_MessageCommon.ShowMessageTips)(des)
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.FriendShip, function(win)
    -- function num : 0_19_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    local heroInfoWin = UIManager:GetWindow(UIWindowTypeID.HeroInfomation)
    if heroInfoWin == nil then
      win:Delete()
      return 
    end
    heroInfoWin:Hide()
    win:InitFriendshipSkillUpgrade(heroInfoWin.heroData, nil, function(heroData, switchFunc)
      -- function num : 0_19_0_0 , upvalues : _ENV, self
      if not heroData:GetIsNotShowInfo() then
        (UIManager:ShowWindow(UIWindowTypeID.HeroInfomation)):RefreshHeroInformation(heroData, switchFunc)
      else
        ;
        (UIUtil.OnClickBackByUiTab)(self)
      end
    end
, heroInfoWin.switchHeroFunc)
  end
)
  end
end

UIHeroInformation.OnClickAvgNoun = function(self)
  -- function num : 0_20 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.AvgNounDes, function(window)
    -- function num : 0_20_0
    if window == nil then
      return 
    end
    window:InitAvgNounDes()
  end
)
end

UIHeroInformation.OnClickLockedVoiceBtn = function(self)
  -- function num : 0_21 , upvalues : cs_MessageCommon, _ENV
  (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(618))
end

UIHeroInformation.OnClickCharDun = function(self)
  -- function num : 0_22 , upvalues : JumpManager
  local showDunEnter, sectorId = self:__GetDunSectorId()
  if not showDunEnter then
    return 
  end
  JumpManager:Jump((JumpManager.eJumpTarget).DynSectorLevel, nil, nil, {sectorId})
end

UIHeroInformation.__GetDunSectorId = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local activityHeroCfgId = ((ConfigData.activity_hero).heroMappping)[(self.heroData).dataId]
  if activityHeroCfgId == nil then
    return false, nil
  end
  local activityHeroCfg = (ConfigData.activity_hero)[activityHeroCfgId]
  if activityHeroCfg == nil then
    return false, nil
  end
  return (PlayerDataCenter.sectorEntranceHandler):CheckSectorValid(activityHeroCfg.main_stage), activityHeroCfg.main_stage
end

UIHeroInformation.OnDelete = function(self)
  -- function num : 0_24 , upvalues : _ENV, eNodeType, HeroInfoTextUtil, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  for index,tween in ipairs((self.ui).tweenList) do
    tween:DOKill()
  end
  self:__UnloadHeroVoiceAndStory()
  for _,typeId in pairs(eNodeType) do
    ((((self.nodeDic)[typeId]).ui).fade):DOKill()
    ;
    ((self.nodeDic)[typeId]):Delete()
  end
  ;
  (HeroInfoTextUtil.Delete)()
  if self.frageStateNode ~= nil then
    (self.frageStateNode):Delete()
  end
  ;
  (base.OnDelete)(self)
end

UIHeroInformation.OnCloseTween = function(self)
  -- function num : 0_25 , upvalues : base
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  ;
  (base.OnCloseTween)(self)
end

UIHeroInformation.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_26 , upvalues : waitRecorverNUM
  local dataTable = {}
  dataTable.heroData = self.heroData
  dataTable.closeCallback = self.closeCallback
  dataTable.switchHeroFunc = self.switchHeroFunc
  waitRecorverNUM = waitRecorverNUM + 1
  return function()
    -- function num : 0_26_0 , upvalues : self, dataTable, waitRecorverNUM
    self:InitHeroInformation(dataTable.heroData, dataTable.closeCallback, dataTable.switchHeroFunc, true, true)
    self:Show()
    waitRecorverNUM = waitRecorverNUM - 1
  end

end

return UIHeroInformation

