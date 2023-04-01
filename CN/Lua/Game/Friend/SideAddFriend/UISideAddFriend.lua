-- params : ...
-- function num : 0 , upvalues : _ENV
local UISideAddFriend = class("UISideAddFriend", UIBaseWindow)
local base = UIBaseWindow
local cs_MessageCommon = CS.MessageCommon
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local eFriendEnum = require("Game.Friend.eFriendEnum")
UISideAddFriend.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.OnCLickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickAddFriend)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
end

UISideAddFriend.InitAddHeroSide = function(self, userUID, resLoader)
  -- function num : 0_1 , upvalues : _ENV
  self.resLoader = resLoader
  ;
  (((self.ui).btn_Cancel).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Confirm).gameObject):SetActive(false)
  PlayerDataCenter:GetUserInfoByUID(userUID, function(userData)
    -- function num : 0_1_0 , upvalues : self
    if userData == nil then
      return 
    end
    if userData:GetIsFriend() then
      return 
    end
    ;
    ((self.ui).inTween):DOPlay()
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = userData:GetUserName()
    ;
    (self.userHeadNode):InitUserHeadUI(userData:GetAvatarId(), userData:GetAvatarFrameId(), self.resLoader)
    self.userData = userData
    ;
    (((self.ui).btn_Cancel).gameObject):SetActive(true)
    ;
    (((self.ui).btn_Confirm).gameObject):SetActive(true)
  end
)
end

UISideAddFriend.OnCLickCancle = function(self)
  -- function num : 0_2
  self:Delete()
end

UISideAddFriend.OnClickAddFriend = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_MessageCommon, eFriendEnum
  if (PlayerDataCenter.friendDataCenter):GetIsFriendFull() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Friend_AddFailure))
    self:Delete()
    return 
  end
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Friend)):CS_FRIEND_ApplyFriend((self.userData):GetUserUID(), (eFriendEnum.eFriendApplyWay).Assist, function()
    -- function num : 0_3_0 , upvalues : self
    self:Delete()
  end
)
end

UISideAddFriend.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UISideAddFriend

