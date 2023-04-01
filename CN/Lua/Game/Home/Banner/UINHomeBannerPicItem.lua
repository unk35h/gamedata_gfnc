-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHomeBannerPicItem = class("UICarouselBanner", UIBaseNode)
local base = UIBaseNode
local HomeBannerManager = require("Game.Home.Banner.HomeBannerManager")
local JumpManager = require("Game.Jump.JumpManager")
UINHomeBannerPicItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__OnOpenUrl = BindCallback(self, self.OnOpenUrl)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).button, self, self.__OnClick)
end

UINHomeBannerPicItem.InitHomeBannerPicItem = function(self, bannerData)
  -- function num : 0_1 , upvalues : HomeBannerManager, _ENV
  if self.bannerData == bannerData then
    return 
  end
  self.bannerData = bannerData
  self:__UpdateBannerDurationTime()
  HomeBannerManager:GetBannerPicFromHTTP(bannerData:GetBannerPicUrl(), bannerData:GetBannerPicName(), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.gameObject) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_advItem).texture = texture
  end
)
end

UINHomeBannerPicItem.__UpdateBannerDurationTime = function(self)
  -- function num : 0_2
  if (self.ui).tex_AdvContent == nil then
    return 
  end
  ;
  (((self.ui).tex_AdvContent).gameObject):SetActive(true)
  local startTime, endTime = (self.bannerData):GetStartAndEndTime()
  ;
  ((self.ui).tex_AdvContent):SetIndex(0, startTime, endTime)
end

UINHomeBannerPicItem.__OnClick = function(self)
  -- function num : 0_3 , upvalues : _ENV, JumpManager
  if (self.bannerData):GetBannerIsOpenURL() then
    ((CS.MessageCommon).ShowMessageBox)(ConfigData:GetTipContent(TipContent.bannerJumpMention), ConfigData:GetTipContent(TipContent.commonConfirm), ConfigData:GetTipContent(TipContent.commonCancle), self.__OnOpenUrl, nil)
  else
    if (self.bannerData):GetBannerIsInnerJump() then
      JumpManager:Jump((self.bannerData).jumpTargetId, nil, nil, (self.bannerData).jumpArgs)
    end
  end
end

UINHomeBannerPicItem.OnOpenUrl = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (((CS.UnityEngine).Application).OpenURL)((self.bannerData):GetWebURL())
end

UINHomeBannerPicItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINHomeBannerPicItem

