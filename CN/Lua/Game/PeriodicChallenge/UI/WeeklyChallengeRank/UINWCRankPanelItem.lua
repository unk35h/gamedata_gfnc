-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCRankPanelItem = class("UINWCRankPanelItem", UIBaseNode)
local base = UIBaseNode
local UINWCRankPanelItemHeroHead = require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankPanelItemHeroHead")
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local eFriendEnum = require("Game.Friend.eFriendEnum")
local UINUserTitle = require("Game.CommonUI.Title.UINNormalTitleItem")
UINWCRankPanelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCRankPanelItemHeroHead, UINUserHead, UINUserTitle
  self.waitingDataIndex = nil
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_openUserInfo, self, self.OnClickOpenUserInfoBtn)
  self.heroHeadPool = (UIItemPool.New)(UINWCRankPanelItemHeroHead, (self.ui).obj_HeroHead)
  ;
  ((self.ui).obj_HeroHead):SetActive(false)
  self.userHead = (UINUserHead.New)()
  ;
  (self.userHead):Init((self.ui).uINBaseHead)
  self.userTitle = (UINUserTitle.New)()
  ;
  (self.userTitle):Init((self.ui).obj_title)
end

UINWCRankPanelItem.RefreshWCRItemInfo = function(self, rankData, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.waitingDataIndex = nil
  self.rankData = rankData
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_RankNumber).text = tostring(rankData.rank)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_PlayerName).text = tostring((rankData.entry).name)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring((rankData.entry).score)
  ;
  (self.userHead):InitUserHeadUI(((self.rankData).entry).avatarId, ((self.rankData).entry).avatarFrame, resloader)
  local title = ((self.rankData).entry).title
  local atlasPath = PathConsts:GetSpriteAtlasPath("TitleIcon")
  self._titleBgAtlas = resloader:LoadABAsset(atlasPath)
  if title and title.titlePrefix ~= 0 then
    ((self.ui).obj_title):SetActive(true)
    ;
    (self.userTitle):InitNormalTitleItem(title.titlePrefix, title.titlePostfix, title.titleBackGround, resloader, self._titleBgAtlas)
  else
    ;
    ((self.ui).obj_title):SetActive(false)
  end
  local count = 0
  ;
  (self.heroHeadPool):HideAll()
  for key,heroData in ipairs((rankData.entry).heroes) do
    ((self.heroHeadPool):GetOne()):InitHead(heroData.id, heroData.level, heroData.star)
    count = count + 1
  end
  do
    if count < 5 then
    end
  end
end

UINWCRankPanelItem.SetWCRItemWait4Data = function(self, dataIndex)
  -- function num : 0_2 , upvalues : _ENV
  self.waitingDataIndex = dataIndex
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_RankNumber).text = tostring(dataIndex)
  ;
  (self.heroHeadPool):HideAll()
end

UINWCRankPanelItem.OnClickOpenUserInfoBtn = function(self)
  -- function num : 0_3 , upvalues : _ENV, eFriendEnum
  PlayerDataCenter:GetUserInfoByUID(((self.rankData).entry).uid, function(userInfoData)
    -- function num : 0_3_0 , upvalues : _ENV, eFriendEnum
    if userInfoData == nil then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonUserInfo, function(win)
      -- function num : 0_3_0_0 , upvalues : userInfoData, eFriendEnum
      if win == nil then
        return 
      end
      win:InitUserInfoView(userInfoData, (eFriendEnum.eFriendApplyWay).Rank)
    end
)
  end
)
end

UINWCRankPanelItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWCRankPanelItem

