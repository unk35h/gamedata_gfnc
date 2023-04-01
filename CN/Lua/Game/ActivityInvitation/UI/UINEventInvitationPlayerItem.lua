-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventInvitationPlayerItem = class("UINEventInvitationPlayerItem", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local eFriendEnum = require("Game.Friend.eFriendEnum")
UINEventInvitationPlayerItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_States, self, self.OnClickAddFriend)
  self._headNode = (UINUserHead.New)()
  ;
  (self._headNode):Init((self.ui).uINUserHead)
  self._defaultColor = ((self.ui).img_States).color
end

UINEventInvitationPlayerItem.SetInvitationPlayerItem = function(self, uid, resloader, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._resloader = resloader
  self._uid = uid
  self._avatar = nil
  self._callback = callback
  PlayerDataCenter:GetUserInfoByUID(uid, function(avatar)
    -- function num : 0_1_0 , upvalues : _ENV, self, uid
    if IsNull(self.transform) then
      return 
    end
    if uid ~= self._uid then
      return 
    end
    self._avatar = avatar
    self:RefreshInvitationPlayerItem()
  end
)
end

UINEventInvitationPlayerItem.RefreshInvitationPlayerItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._avatar == nil then
    return 
  end
  ;
  (self._headNode):InitUserHeadUI((self._avatar):GetAvatarId(), (self._avatar):GetAvatarFrameId(), self._resloader)
  ;
  (self._headNode):BindUserHeadEvent(function()
    -- function num : 0_2_0 , upvalues : self
    (self._callback)(self._uid)
  end
)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_PlayerName).text = (self._avatar):GetUserName()
  if (PlayerDataCenter.friendDataCenter):TryGetFriendData(self._uid) then
    ((self.ui).img_state):SetIndex(2)
    ;
    ((self.ui).tex_state):SetIndex(2)
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_States).color = self._defaultColor
  else
    if (PlayerDataCenter.friendDataCenter):TryGetFriendApplyData(self._uid) then
      ((self.ui).img_state):SetIndex(1)
      ;
      ((self.ui).tex_state):SetIndex(1)
      -- DECOMPILER ERROR at PC66: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_States).color = self._defaultColor
    else
      ;
      ((self.ui).img_state):SetIndex(0)
      ;
      ((self.ui).tex_state):SetIndex(0)
      -- DECOMPILER ERROR at PC82: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_States).color = (self.ui).color_black
    end
  end
end

UINEventInvitationPlayerItem.OnClickAddFriend = function(self)
  -- function num : 0_3 , upvalues : _ENV, eFriendEnum
  if (PlayerDataCenter.friendDataCenter):TryGetFriendData(self._uid) or (PlayerDataCenter.friendDataCenter):TryGetFriendApplyData(self._uid) then
    return 
  end
  ;
  ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(7708))
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Friend)):CS_FRIEND_ApplyFriend(self._uid, (eFriendEnum.eFriendApplyWay).Search, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshInvitationPlayerItem()
    end
  end
)
end

return UINEventInvitationPlayerItem

