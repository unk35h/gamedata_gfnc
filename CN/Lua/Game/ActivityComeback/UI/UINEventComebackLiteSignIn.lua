-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackSignIn = require("Game.ActivityComeback.UI.UINEventComebackSignIn")
local UINEventComebackLiteSignIn = class("UINEventComebackLiteSignIn", UINEventComebackSignIn)
local base = UINEventComebackSignIn
local UINEventComebackSignInItem = require("Game.ActivityComeback.UI.UINEventComebackSignInItem")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
UINEventComebackLiteSignIn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventComebackSignInItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__RefreshItemCallback = BindCallback(self, self.__RefreshItem)
  MsgCenter:AddListener(eMsgEventId.NoviceSignTime, self.__RefreshItemCallback)
  self.__ReviewAwardCallback = BindCallback(self, self.__ReviewAward)
  self._dayPool = (UIItemPool.New)(UINEventComebackSignInItem, (self.ui).signItem)
  ;
  ((self.ui).signItem):SetActive(false)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent(7407)
end

return UINEventComebackLiteSignIn

