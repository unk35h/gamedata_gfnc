-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventInvitation = class("UIEventInvitation", UIBaseWindow)
local base = UIBaseWindow
local UINEventInvitationMain = require("Game.ActivityInvitation.UI.UINEventInvitationMain")
local UINEventInvitationInput = require("Game.ActivityInvitation.UI.UINEventInvitationInput")
local UINShareCommonBtn = require("Game.Share.UI.UINShareCommonBtn")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
UIEventInvitation.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventInvitationMain, UINShareCommonBtn
  (UIUtil.AddButtonListener)((self.ui).btn_Tips, self, self.OnClickRule)
  self._mainNode = (UINEventInvitationMain.New)()
  ;
  (self._mainNode):Init((self.ui).main)
  self._shareNode = (UINShareCommonBtn.New)()
  ;
  (self._shareNode):Init((self.ui).shareCommonButton)
  ;
  ((self.ui).prtScNode):SetActive(false)
  ;
  ((self.ui).logicPreviewNode):SetActive(false)
  self._resloader = ((CS.ResLoader).Create)()
  self.__OnReceiveCodeRegisterCallback = BindCallback(self, self.__OnReceiveCodeRegister)
  MsgCenter:AddListener(eMsgEventId.InvitationCodeRegister, self.__OnReceiveCodeRegisterCallback)
end

UIEventInvitation.InitInvitation = function(self, actId)
  -- function num : 0_1 , upvalues : _ENV
  local invitationCtrl = ControllerManager:GetController(ControllerTypeId.ActivityInvitation)
  self._data = invitationCtrl:GetInvitationDataByActId(actId)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (self._data):GetActivityName()
  local tipId = ((self._data):GetInvitationMainCfg()).activity_des
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent(tipId)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Code).text = (self._data):GetInvitationCode()
  ;
  (((self.ui).img_Logo).gameObject):SetActive(false)
  local relPath = "Activity/Invitation/" .. ((self._data):GetInvitationMainCfg()).title_icon .. ".png"
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetResImagePath(relPath), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_Logo).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Logo).texture = texture
  end
)
  ;
  (self._mainNode):InitInvitationMain(self._data, BindCallback(self, self.__OpenInput))
  ;
  (self._shareNode):InitShareCommonBtn(BindCallback(self, self.__OpenShare), (self._data):GetActFrameId())
  if self._timerId == nil then
    self._timerId = TimerManager:StartTimer(1, self.__OnTimer, self)
    self:__OnTimer()
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local isFirst = not saveUserData:GetInvitationLooked(actId)
  if isFirst then
    saveUserData:SetInvitationLooked(actId)
    ;
    (self._data):RefreshInvitationRed()
  end
  if (self._data):IsInvitationReturnUser() and not (self._data):IsInvitationReturnPicked() and isFirst then
    self:__OpenInput()
  end
end

UIEventInvitation.__OpenInput = function(self)
  -- function num : 0_2 , upvalues : UINEventInvitationInput
  if (self._data):IsInvitationReturnUser() and not (self._data):IsInvitationReturnPicked() then
    if self._inputNode == nil then
      ((self.ui).logicPreviewNode):SetActive(true)
      self._inputNode = (UINEventInvitationInput.New)()
      ;
      (self._inputNode):Init((self.ui).logicPreviewNode)
      ;
      (self._inputNode):InitInvitationInput(self._data)
    else
      ;
      (self._inputNode):Show()
    end
  end
end

UIEventInvitation.__OpenShare = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Share, function(win)
    -- function num : 0_3_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    ;
    ((win:SetShareBeforeCaptureFunc(function()
      -- function num : 0_3_0_0 , upvalues : _ENV, self
      (UIUtil.HideTopStatus)()
      ;
      ((self.ui).prtScNode):SetActive(true)
      local frameUI = UIManager:GetWindow(UIWindowTypeID.ActivityFrameMain)
      if frameUI ~= nil and frameUI.active then
        frameUI:SetTagPageNodeState(false)
      end
    end
)):SetShareAfterCaptureFunc(function()
      -- function num : 0_3_0_1 , upvalues : self, _ENV
      ((self.ui).prtScNode):SetActive(false)
      ;
      (UIUtil.ReShowTopStatus)()
      local frameUI = UIManager:GetWindow(UIWindowTypeID.ActivityFrameMain)
      if frameUI ~= nil and frameUI.active then
        frameUI:SetTagPageNodeState(true)
      end
    end
)):InitShare((self._data):GetActFrameId())
  end
)
end

UIEventInvitation.__OnTimer = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._nextTime or 0 < PlayerDataCenter.timestamp then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._data)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_TimeTitle).text = title
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_EndTime).text = timeStr
      self._nextTime = expireTime
    end
    local countdownStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._nextTime)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_LastTime).text = countdownStr
    if diff < 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UIEventInvitation.OnClickRule = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local cfg = (self._data):GetInvitationMainCfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_5_0 , upvalues : _ENV, cfg
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent(cfg.rule_des), ConfigData:GetTipContent(cfg.rule_title))
  end
)
end

UIEventInvitation.__OnReceiveCodeRegister = function(self)
  -- function num : 0_6
  (self._mainNode):RefreshInvitationMain()
  ;
  (self._inputNode):Hide()
end

UIEventInvitation.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  (self._mainNode):OnDelete()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.InvitationCodeRegister, self.__OnReceiveCodeRegisterCallback)
  ;
  (base.OnDelete)(self)
end

return UIEventInvitation

