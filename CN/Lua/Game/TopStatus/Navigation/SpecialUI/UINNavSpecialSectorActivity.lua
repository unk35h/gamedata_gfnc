-- params : ...
-- function num : 0 , upvalues : _ENV
local UINNavSpecialUIBase = require("Game.TopStatus.Navigation.SpecialUI.UINNavSpecialUIBase")
local UINNavSpecialSectorActivity = class("UINNavSpecialSectorActivity", UINNavSpecialUIBase)
local base = UINNavSpecialUIBase
local ActEntryEnum = require("Game.Home.UI.Side.Enum.ActEntryEnum")
local JumpManager = require("Game.Jump.JumpManager")
local UINHomeActivityEntryList = require("Game.Home.UI.Side.UINHomeActivityEntryList")
UINNavSpecialSectorActivity.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, UINHomeActivityEntryList, _ENV
  (base.OnInit)(self)
  self.activityEntry = (UINHomeActivityEntryList.New)()
  ;
  (self.activityEntry):Init((self.ui).activityEntry)
  ;
  (self.activityEntry):BindingEntryCountChange(BindCallback(self, self.__RefreshByEntryCount))
  ;
  (self.activityEntry):BingEntryJumpCallback(BindCallback(self, self.__OnClickedEntry))
end

UINNavSpecialSectorActivity.GetSpecialUI = function(item, go, resloader)
  -- function num : 0_1 , upvalues : base, UINNavSpecialSectorActivity
  local specialUI = (base.GetSpecialUI)(UINNavSpecialSectorActivity, item, go)
  specialUI.resloader = resloader
  specialUI:InitSpcSectorActivityUI()
  return specialUI
end

UINNavSpecialSectorActivity.InitSpcSectorActivityUI = function(self)
  -- function num : 0_2 , upvalues : ActEntryEnum
  (self.activityEntry):InitHomeActivityEntryList((ActEntryEnum.EnterWay).TopNav)
end

UINNavSpecialSectorActivity.__RefreshByEntryCount = function(self, count)
  -- function num : 0_3
  if count > 0 then
    self:Show()
  else
    self:Hide()
  end
end

UINNavSpecialSectorActivity.__OnClickedEntry = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  if win ~= nil then
    win:HideNavigation()
  end
end

UINNavSpecialSectorActivity.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.activityEntry):Delete()
  ;
  (base.OnDelete)(self)
end

return UINNavSpecialSectorActivity

