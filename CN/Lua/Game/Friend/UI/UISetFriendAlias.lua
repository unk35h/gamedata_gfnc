-- params : ...
-- function num : 0 , upvalues : _ENV
local UISetFriendAlias = class("UISetFriendAlias", UIBaseWindow)
local base = UIBaseWindow
local CS_MessageCommon = CS.MessageCommon
local RenameHelper = require("Game.CommonUI.Rename.RenameHelper")
UISetFriendAlias.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.friendNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Friend)
  ;
  (UIUtil.HideTopStatus)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self._OnClickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self._OnClickCancle)
end

UISetFriendAlias.InitSetFriendAlias = function(self, userInfoData)
  -- function num : 0_1 , upvalues : _ENV
  self.userInfoData = userInfoData
  if userInfoData == nil then
    self:_OnClickCancle()
    return 
  end
  local friendRealName = userInfoData:GetUserName()
  ;
  ((self.ui).text_textTips):SetIndex(0, friendRealName)
  local maxInputNum = (ConfigData.game_config).friendSetAliasLimit
  self.characterLimit = maxInputNum
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).inputField).characterLimit = maxInputNum
  ;
  ((self.ui).text_textTips2):SetIndex(0, tostring(maxInputNum))
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

  if userInfoData:GetIsHaveAlias() then
    ((self.ui).inputField).text = userInfoData:GetAlias()
  end
end

UISetFriendAlias._OnClickCancle = function(self)
  -- function num : 0_2
  self:Delete()
end

UISetFriendAlias._OnClickConfirm = function(self)
  -- function num : 0_3 , upvalues : RenameHelper, _ENV
  local inputUserName = ((self.ui).inputField).text
  if inputUserName == nil then
    return 
  end
  local inputLength = RenameHelper:GetNameLength(inputUserName)
  if self.characterLimit < inputLength then
    inputUserName = RenameHelper:ClampNameInLength(inputUserName, self.characterLimit)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).inputField).text = inputUserName
    return 
  end
  ;
  (self.friendNetworkCtrl):CS_FRIEND_Alias((self.userInfoData):GetUserUID(), inputUserName, function()
    -- function num : 0_3_0 , upvalues : self, inputUserName, _ENV
    (self.userInfoData):SetAlias(inputUserName)
    self:_OnClickCancle()
    ;
    (PlayerDataCenter.friendDataCenter):UpdateFriendUI()
  end
)
end

UISetFriendAlias.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  (UIUtil.ReShowTopStatus)()
  ;
  (base.OnDelete)(self)
end

return UISetFriendAlias

