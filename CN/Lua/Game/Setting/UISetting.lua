-- params : ...
-- function num : 0 , upvalues : _ENV
local UISetting = class("UISetting", UIBaseWindow)
local base = UIBaseWindow
local UISettingDisplayPanel = require("Game.Setting.UI.UISettingDisplayPanel")
local UINSettingTypeItem = require("Game.Setting.UI.UINSettingTypeItem")
local UINNotifySettingNode = require("Game.Setting.UI.UINNotifySettingNode")
local UINCDKeyPanelNode = require("Game.Setting.UI.UINCDKeyPanelNode")
local UINGameSetPanelNode = require("Game.Setting.UI.UINGameSetPanel")
local UISingleSwitchTogItem = require("Game.Setting.UI.UISingleSwitchTogItem")
local UINSettingJpStatute = require("Game.Setting.UI.UINSettingJpStatute")
local cs_MicaSDKManager = (CS.MicaSDKManager).Instance
local CS_ClientConsts = CS.ClientConsts
UISetting.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self.CloseSettingClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Logout, self, self.UserLogout)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_UserCenter, self, self.OpenUserCenter)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Customer, self, self.EnterCustomService)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BiliCloseAccount, self, self._BiliCloseAccount)
  ;
  (((self.ui).btn_BiliCloseAccount).gameObject):SetActive(((Consts.GameChannelType).IsBilibili)())
  self.ctrl = ControllerManager:GetController(ControllerTypeId.Setting, true)
  self.notifySettingNode = nil
  ;
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.Delete)):PushTopStatusDataToBackStack()
end

local InitStartup = {
[UIWindowTypeID.BattlePause] = {
showTypeGroup = {5, 2}
, topActive = false}
}
UISetting.InitSettingByFrom = function(self, winFrom)
  -- function num : 0_1 , upvalues : InitStartup, _ENV
  local starUp = InitStartup[winFrom]
  local topActive = true
  local showTypeGroup = nil
  if starUp ~= nil then
    showTypeGroup = starUp.showTypeGroup
    topActive = starUp.topActive
  else
    showTypeGroup = {}
    for i = 1, #(self.ui).settingTypeGroup do
      (table.insert)(showTypeGroup, i)
    end
  end
  do
    self:_SetTopBtnActive(topActive)
    self:_InitCustomer()
    self:InitSettingTypeItem(showTypeGroup)
    self:__InitGameSettingReddot()
  end
end

UISetting._SetTopBtnActive = function(self, active)
  -- function num : 0_2
  (((self.ui).btn_Logout).gameObject):SetActive(active)
  ;
  (((self.ui).btn_UserCenter).gameObject):SetActive(active)
  ;
  (((self.ui).btn_Customer).gameObject):SetActive(active)
end

UISetting._InitCustomer = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_MicaSDKManager
  self.__onCustomerNewMsg = BindCallback(self, self.OnCustomerNewMsg)
  cs_MicaSDKManager:onHaveNewMsg("+", self.__onCustomerNewMsg)
  local channelId = cs_MicaSDKManager.channelId
  if ((Consts.GameChannelType).IsInland)() and (channelId == (Consts.GameChannelType).Bilibili or channelId == (Consts.GameChannelType).BilibiliKol or channelId == (Consts.GameChannelType).BilibiliGray or channelId == (Consts.GameChannelType).BilibiliQATest) then
    (((self.ui).btn_UserCenter).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Customer).gameObject):SetActive(false)
  else
    cs_MicaSDKManager:CheckCustomNewMsg()
  end
end

UISetting.InitSettingTypeItem = function(self, showTypeGroup)
  -- function num : 0_4 , upvalues : _ENV, UINSettingTypeItem, cs_MicaSDKManager
  for i = 1, #(self.ui).settingTypeGroup do
    ((((self.ui).settingTypeGroup)[i]).gameObject):SetActive(false)
  end
  self.settingTypeItemList = {}
  for _,value in ipairs(showTypeGroup) do
    local typeItem = (UINSettingTypeItem.New)()
    typeItem:Init((((self.ui).settingTypeGroup)[value]).transform)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.settingTypeItemList)[value] = typeItem
    ;
    (UIUtil.AddValueChangedListener)(((self.ui).settingTypeGroup)[value], self, self.OnPanelToggleValueChanged, value)
    local active = true
    if value == 4 then
      active = self:VerifyGiftUnlock()
    end
    ;
    (typeItem.gameObject):SetActive(active)
  end
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).settingTypeGroup)[showTypeGroup[1]]).isOn = true
  if not ((Consts.GameChannelType).IsInland)(cs_MicaSDKManager.channelId) and GameSystemInfo.Platform == (GameSystemInfo.PlatformType).iOS and (self.settingTypeItemList)[4] ~= nil then
    (((self.settingTypeItemList)[4]).gameObject):SetActive(false)
  end
  if (self.settingTypeItemList)[6] ~= nil then
    local isJp = ((Consts.GameChannelType).IsJp)(cs_MicaSDKManager.channelId)
    ;
    (((self.settingTypeItemList)[6]).gameObject):SetActive(isJp)
  end
end

UISetting.OnPanelToggleValueChanged = function(self, index, value)
  -- function num : 0_5
  if index == 1 then
    ((self.ui).displayPanel):SetActive(value)
    if value and not self.__isDisplayInited then
      self:InitDisplaySettingPanel()
      self.__isDisplayInited = true
    end
  else
    if index == 2 then
      ((self.ui).audioPanel):SetActive(value)
      if value and not self.__isAudioInited then
        self:InitAudioSettingPanel()
        self.__isAudioInited = true
      end
    else
      if index == 3 then
        ((self.ui).notifiesPanel):SetActive(value)
        if value and not self.__isNoticeInited then
          self:InitNoticeSettingPanel()
          self.__isNoticeInited = true
        end
      else
        if index == 4 then
          ((self.ui).cDKeyPanel):SetActive(value)
          if value and not self.__iscDKeyInited then
            self:InitCDKeyPanel()
            self.__iscDKeyInited = true
          end
        else
          if index == 5 then
            ((self.ui).gameSetPanel):SetActive(value)
            if value and not self.__isGameSetInited then
              self:InitGameSet()
              self.__isGameSetInited = true
              ;
              (self.ctrl):SetGameSettingReddotLooked()
            end
          else
            if index == 6 then
              self:_TryInitJpStatute()
              if value then
                (self._jpStatuteNode):Show()
              else
                ;
                (self._jpStatuteNode):Hide()
              end
            end
          end
        end
      end
    end
  end
  ;
  ((self.settingTypeItemList)[index]):SetSettingTypeItemActive(value, self.ui)
end

UISetting.InitDisplaySettingPanel = function(self)
  -- function num : 0_6 , upvalues : UISettingDisplayPanel
  self.displayPanel = (UISettingDisplayPanel.New)()
  ;
  (self.displayPanel):Init((self.ui).displayPanel)
  ;
  (self.displayPanel):InitDisplayPanel(self.ctrl)
end

UISetting.InitAudioSettingPanel = function(self)
  -- function num : 0_7 , upvalues : _ENV, UISingleSwitchTogItem
  local audioSetting = (self.ctrl):GetSettingAudioData()
  for index = 1, AudioManager.AudioTypeCount do
    (UIUtil.AddValueChangedListener)(((self.ui).audioSliderGroup)[index], self, self.OnAudioVolumeChanged, index)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).audioSliderGroup)[index]).value = (audioSetting.volumes)[index] or 1
  end
  if self.muteTogItem == nil then
    self.muteTogItem = (UISingleSwitchTogItem.New)()
    ;
    (self.muteTogItem):Init((self.ui).tog_mute)
    local currnetOpenWeatherCallback = BindCallback(self, self.IsGlobalMute, "mute")
    ;
    (self.muteTogItem):InitSingleSwitchTogItem(currnetOpenWeatherCallback, {ConfigData:GetTipContent(8002), ConfigData:GetTipContent(8001)}, self.OnAudioSwitchChaned, self)
  end
end

UISetting.OnAudioVolumeChanged = function(self, index, value)
  -- function num : 0_8 , upvalues : _ENV
  (self.ctrl):SetSettingAudioVolume(index, value)
  ;
  ((CS.AudioManager).Instance):SetVolume(index, value)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).audioVolTextGroup)[index]).text = tostring((math.floor)(value * 100))
end

UISetting.IsGlobalMute = function(self)
  -- function num : 0_9
  local audioSetting = (self.ctrl):GetSettingAudioData()
  if audioSetting == nil then
    return false
  end
  if audioSetting.globalMute == nil then
    return false
  end
  return audioSetting.globalMute
end

UISetting.OnAudioSwitchChaned = function(self, value)
  -- function num : 0_10 , upvalues : _ENV
  (self.ctrl):SetSettingAudioGlobalMute(value)
  for index = 1, AudioManager.AudioTypeCount do
    ((CS.AudioManager).Instance):SetMute(index, value)
  end
end

UISetting.InitNoticeSettingPanel = function(self)
  -- function num : 0_11 , upvalues : UINNotifySettingNode
  local noticeSwitchOffDic = (self.ctrl):GetSettingNoticeSwitch()
  if self.notifySettingNode == nil then
    self.notifySettingNode = (UINNotifySettingNode.New)()
    ;
    (self.notifySettingNode):Init((self.ui).notifiesPanel)
  end
  ;
  (self.notifySettingNode):InitNotifySettingNode(noticeSwitchOffDic)
end

UISetting.InitCDKeyPanel = function(self)
  -- function num : 0_12 , upvalues : UINCDKeyPanelNode
  if self.cDKeyPanelNode == nil then
    self.cDKeyPanelNode = (UINCDKeyPanelNode.New)()
    ;
    (self.cDKeyPanelNode):Init((self.ui).cDKeyPanel)
  end
end

UISetting.InitGameSet = function(self)
  -- function num : 0_13 , upvalues : UINGameSetPanelNode
  if self.gameSetPanelNode == nil then
    self.gameSetPanelNode = (UINGameSetPanelNode.New)()
    ;
    (self.gameSetPanelNode):Init((self.ui).gameSetPanel)
    ;
    (self.gameSetPanelNode):InitGameSetPanel(self.ctrl)
  end
end

UISetting._TryInitJpStatute = function(self)
  -- function num : 0_14 , upvalues : UINSettingJpStatute
  if self._jpStatuteNode == nil then
    self._jpStatuteNode = (UINSettingJpStatute.New)()
    ;
    (self._jpStatuteNode):Init((self.ui).jPStatutePanel)
  end
  ;
  (self._jpStatuteNode):InitSettingJpStatute()
end

UISetting.CloseSettingClicked = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UISetting.UserLogout = function(self)
  -- function num : 0_16
  (self.ctrl):UserLogout()
end

UISetting.OpenUserCenter = function(self)
  -- function num : 0_17
  (self.ctrl):OpenUserCenter()
end

UISetting.EnterCustomService = function(self)
  -- function num : 0_18
  ((self.ui).redDot_Customer):SetActive(false)
  ;
  (self.ctrl):EnterCustomService()
end

UISetting._BiliCloseAccount = function(self)
  -- function num : 0_19
  (self.ctrl):BiliCloseAccount()
end

UISetting.OnCustomerNewMsg = function(self, value)
  -- function num : 0_20
  if value then
    ((self.ui).redDot_Customer):SetActive(true)
  end
end

UISetting.SetCDKButtomActive = function(self, active)
  -- function num : 0_21
  ((((self.ui).settingTypeGroup)[4]).gameObject):SetActive(active)
end

UISetting.SetUIMailHideCallback = function(self, callback)
  -- function num : 0_22
  self.__hideCallback = callback
end

UISetting.VerifyGiftUnlock = function(self)
  -- function num : 0_23 , upvalues : _ENV, CS_ClientConsts
  local isGiftUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_GiftCode)
  if CS_ClientConsts.IsAudit then
    isGiftUnlock = false
  end
  return isGiftUnlock
end

UISetting.__InitGameSettingReddot = function(self)
  -- function num : 0_24 , upvalues : _ENV
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Setting, RedDotStaticTypeId.GameSetting)
  if isOk then
    if self.__refresnGameSettingReddot == nil then
      self.__refresnGameSettingReddot = function(node)
    -- function num : 0_24_0 , upvalues : self
    ((self.ui).blueDot_GameSetting):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnGameSettingReddot)
    ;
    (self.__refresnGameSettingReddot)(node)
  end
end

UISetting.__RemoveGameSettingReddot = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Setting, RedDotStaticTypeId.GameSetting)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnGameSettingReddot)
  end
  self.__refresnGameSettingReddot = nil
end

UISetting.OnHide = function(self)
  -- function num : 0_26 , upvalues : base
  self:OnCloseWin()
  if self.__hideCallback ~= nil then
    (self.__hideCallback)()
  end
  ;
  (base.OnHide)(self)
end

UISetting.OnDelete = function(self)
  -- function num : 0_27 , upvalues : cs_MicaSDKManager, base, _ENV
  if self._jpStatuteNode ~= nil then
    (self._jpStatuteNode):Delete()
    self._jpStatuteNode = nil
  end
  self:__RemoveGameSettingReddot()
  cs_MicaSDKManager:onHaveNewMsg("-", self.__onCustomerNewMsg)
  ;
  (self.ctrl):TryReqSaveGameSettingData()
  self.ctrl = nil
  ;
  (base.OnDelete)(self)
  PersistentManager:SaveModelData((PersistentConfig.ePackage).SystemData)
  PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
end

return UISetting

