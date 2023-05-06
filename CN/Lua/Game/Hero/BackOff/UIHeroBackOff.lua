-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeroBackOff = class("UIHeroBackOff", UIBaseWindow)
local base = UIBaseWindow
UIHeroBackOff.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnBtnCloseClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnBtnCloseClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confim, self, self.OnBtnConfirmClicked)
  ;
  (UIUtil.SetTopStatus)(self, self.OnReturnClick, nil, nil, nil, true)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_BackOff).text = ConfigData:GetTipContent(554)
end

UIHeroBackOff.InitHeroBackOffUI = function(self, heroData)
  -- function num : 0_1
  self.__heroData = heroData
end

UIHeroBackOff.OnReturnClick = function(self)
  -- function num : 0_2
  self:Delete()
end

UIHeroBackOff.OnBtnCloseClicked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIHeroBackOff.ShowHeroExpireTip = function(self)
  -- function num : 0_4 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_4_0 , upvalues : _ENV
    if win == nil then
      return 
    end
    win:ShowTextBoxWithConfirm((ConfigData:GetTipContent(556)), nil)
  end
)
end

UIHeroBackOff.OnBtnConfirmClicked = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local ok, actId = PlayerDataCenter:IsHeroBackOffEnable((self.__heroData).dataId)
  if not ok then
    self:ShowHeroExpireTip()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_5_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    local msg = (string.format)(ConfigData:GetTipContent(555), (self.__heroData):GetName())
    win:ShowTextBoxWithYesAndNo(msg, function()
      -- function num : 0_5_0_0 , upvalues : _ENV, self
      local ok, actId = PlayerDataCenter:IsHeroBackOffEnable((self.__heroData).dataId)
      if not ok then
        self:ShowHeroExpireTip()
        return 
      end
      ;
      (NetworkManager:GetNetwork(NetworkTypeID.Hero)):CS_HEROREVERT_Exec(actId, (self.__heroData).dataId)
      self:OnBtnCloseClicked()
    end
, nil)
  end
)
end

UIHeroBackOff.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UIHeroBackOff

