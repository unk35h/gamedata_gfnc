-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonUpgradeTips = class("UICommonUpgradeTips", UIBaseWindow)
local base = UIBaseWindow
UICommonUpgradeTips.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.__OnClickClose)
end

UICommonUpgradeTips.InitAthEffiUpSuccess = function(self, fromValue, toValue)
  -- function num : 0_1 , upvalues : _ENV
  self:SetAthUpgradeSign(true)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = ConfigData:GetTipContent(940)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_CurNum).text = fromValue
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_NewNum).text = toValue
  AudioManager:PlayAudioById(1074)
end

UICommonUpgradeTips.InitBattlePassLevelUp = function(self, fromValue, toValue)
  -- function num : 0_2 , upvalues : _ENV
  self:SetAthUpgradeSign(false)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = ConfigData:GetTipContent(941)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_CurNum).text = (string.format)("LV.%d", fromValue)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_NewNum).text = (string.format)("LV.%d", toValue)
  AudioManager:PlayAudioById(1074)
end

UICommonUpgradeTips.SetBackClickAction = function(self, clickAction)
  -- function num : 0_3
  self.__clickAction = clickAction
end

UICommonUpgradeTips.SetAthUpgradeSign = function(self, active)
  -- function num : 0_4
  (((self.ui).tex_CurSign).gameObject):SetActive(active)
  ;
  (((self.ui).tex_NewSign).gameObject):SetActive(active)
end

UICommonUpgradeTips.__OnClickClose = function(self)
  -- function num : 0_5
  self:Delete()
  if self.__clickAction ~= nil then
    local bindfunc = self.__clickAction
    self.__clickAction = nil
    bindfunc()
  end
end

UICommonUpgradeTips.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UICommonUpgradeTips

