-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSupportHeroItem = class("UINSupportHeroItem", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
local UINHeroCardItem = require("Game.Hero.NewUI.UINHeroCardItem")
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local eFriendEnum = require("Game.Friend.eFriendEnum")
UINSupportHeroItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroCardItem, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelDetail, self, self.OnClickSupportorInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Use, self, self.OnClickUse)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_FriendInfo, self, self.OnClickFriendInfo)
  self.heroCard = (UINHeroCardItem.New)()
  ;
  (self.heroCard):Init((self.ui).uINHeroItem)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
  self.expiredData = nil
end

UINSupportHeroItem.InitSupportHeroCard = function(self, friednSupportHeroData, useCardCallback, resloader, normalHeroDic)
  -- function num : 0_1 , upvalues : _ENV
  self.friednSupportHeroData = friednSupportHeroData
  self.useCardCallback = useCardCallback
  self.expiredData = friednSupportHeroData.expiredSupport
  ;
  (self.heroCard):InitHeroCardItem(friednSupportHeroData, resloader, nil, nil)
  ;
  (self.heroCard):SetEfficiencyActive(true)
  self:RefreshUserInfo(resloader)
  if self.expiredData ~= nil then
    ((self.ui).obj_img_SameHero):SetActive(true)
    ;
    ((self.ui).tex_Tip):SetIndex(1, tostring((self.expiredData).nextUseTurn))
  else
    ;
    ((self.ui).obj_img_SameHero):SetActive(false)
  end
  local talentLevel = (self.friednSupportHeroData):GetSupportHerotalentLevel()
  ;
  (self.heroCard):ShowTalentStage(talentLevel)
end

UINSupportHeroItem.RefreshUserInfo = function(self, resloader)
  -- function num : 0_2 , upvalues : _ENV
  local userInfoData = (self.friednSupportHeroData):GetUserInfo()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_UserName).text = userInfoData:GetAlias()
  ;
  ((self.ui).tex_UserLv):SetIndex(0, tostring(userInfoData:GetUserLevel()))
  ;
  ((self.ui).img_Recommend):SetActive(not userInfoData:GetIsFriend())
  ;
  (self.userHeadNode):InitUserHeadUI(userInfoData:GetAvatarId(), userInfoData:GetAvatarFrameId(), resloader)
end

UINSupportHeroItem.OnClickSupportorInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SupportHeroState, function(win)
    -- function num : 0_3_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitSupportHeroState(self.friednSupportHeroData)
  end
)
end

UINSupportHeroItem.OnClickUse = function(self)
  -- function num : 0_4 , upvalues : cs_MessageCommon, _ENV
  if self.expiredData ~= nil then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Support_CanNotUseSameSupport))
    return 
  end
  if self.useCardCallback ~= nil then
    (self.useCardCallback)(self)
  end
end

UINSupportHeroItem.OnClickFriendInfo = function(self)
  -- function num : 0_5 , upvalues : _ENV, eFriendEnum
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonUserInfo, function(win)
    -- function num : 0_5_0 , upvalues : self, eFriendEnum
    if win == nil then
      return 
    end
    win:InitUserInfoView((self.friednSupportHeroData):GetUserInfo(), (eFriendEnum.eFriendApplyWay).Assist)
  end
)
end

UINSupportHeroItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINSupportHeroItem

