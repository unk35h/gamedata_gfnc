-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonRankPanelItem = class("UINCommonRankPanelItem", UIBaseNode)
local base = UIBaseNode
local UINCommonRankItemHeroHead = require("Game.CommonUI.Rank.UINCommonRankItemHeroHead")
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local UINUserTitle = require("Game.CommonUI.Title.UINNormalTitleItem")
local RankHeroSortFunc = function(hero1, hero2)
  -- function num : 0_0
  do return hero1.formIdx < hero2.formIdx end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINCommonRankPanelItem.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINCommonRankItemHeroHead, UINUserHead, UINUserTitle
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_openUserInfo, self, self.OnClickOpenUserInfoBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickMultiTeamCheck)
  self.heroHeadPool = (UIItemPool.New)(UINCommonRankItemHeroHead, (self.ui).obj_HeroHead)
  ;
  ((self.ui).obj_HeroHead):SetActive(false)
  self.userHead = (UINUserHead.New)()
  ;
  (self.userHead):Init((self.ui).uINBaseHead)
  self.userTitle = (UINUserTitle.New)()
  ;
  (self.userTitle):Init((self.ui).obj_title)
end

UINCommonRankPanelItem.RefeshCommonRankItem = function(self, rankCfg, rankElemData, resloader, hasTime, showHeroNum)
  -- function num : 0_2 , upvalues : _ENV, RankHeroSortFunc
  self.__rankElemData = rankElemData
  local rankAvatar = (rankElemData.entry).avatar
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_RankNumber).text = tostring(rankElemData.rankIdx)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_PlayerName).text = tostring(rankAvatar.name)
  local atlasPath = PathConsts:GetSpriteAtlasPath("TitleIcon")
  self._titleBgAtlas = resloader:LoadABAsset(atlasPath)
  if rankAvatar.title and (rankAvatar.title).titlePrefix ~= 0 then
    ((self.ui).obj_title):SetActive(true)
    ;
    (self.userTitle):InitNormalTitleItem((rankAvatar.title).titlePrefix, (rankAvatar.title).titlePostfix, (rankAvatar.title).titleBackGround, resloader, self._titleBgAtlas)
  else
    ;
    ((self.ui).obj_title):SetActive(false)
  end
  local valueText = nil
  if rankCfg.option_show_type == 1 then
    valueText = (BattleUtil.FrameToTimeString)((rankElemData.entry).score1, true)
  else
    valueText = tostring((rankElemData.entry).score1)
  end
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = valueText
  ;
  (((self.ui).tex_Time).gameObject):SetActive(hasTime)
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R9 in 'UnsetPending'

  if hasTime then
    ((self.ui).tex_Time).text = (BattleUtil.FrameToTimeString)((rankElemData.entry).frame, true)
  end
  ;
  (self.userHead):InitUserHeadUI(rankAvatar.avatarId, rankAvatar.avatarFrame, resloader)
  local rankForm = (rankElemData.entry).form
  self.rankMultiForm = (rankElemData.entry).multiForm
  if not rankForm or #rankForm.heroes == 0 then
    rankForm = (self.rankMultiForm)[1]
    ;
    (((self.ui).btn_Check).gameObject):SetActive(true)
  else
    ;
    (((self.ui).btn_Check).gameObject):SetActive(false)
  end
  local count = 0
  ;
  (self.heroHeadPool):HideAll()
  ;
  (((self.ui).tex_heroCount).gameObject):SetActive(showHeroNum)
  ;
  ((self.ui).obj_heroList):SetActive(not showHeroNum)
  do
    -- DECOMPILER ERROR at PC145: Unhandled construct in 'MakeBoolean' P1

    if showHeroNum and (rankElemData.entry).params ~= nil then
      local heroCount = ((rankElemData.entry).params)[1]
      -- DECOMPILER ERROR at PC150: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).tex_heroCount).text = tostring(heroCount)
    end
    local onBattleHeros = {}
    for key,rankHero in ipairs(rankForm.heroes) do
      if not (BattleUtil.PosOnBench)(rankHero.position) then
        (table.insert)(onBattleHeros, rankHero)
      end
    end
    do
      if #onBattleHeros < 5 then
        (table.sort)(onBattleHeros, RankHeroSortFunc)
        local heroNum = (math.min)(rankCfg.hero_num, 5)
        for i = 1, heroNum do
          local rankHero = onBattleHeros[i]
          local item = (self.heroHeadPool):GetOne()
          if rankHero ~= nil then
            item:InitHead(rankHero.heroId, rankHero.level, rankHero.rank)
          end
          item:SetHeroHeadItemAtive(rankHero ~= nil)
        end
        -- DECOMPILER ERROR: 2 unprocessed JMP targets
      end
    end
  end
end

UINCommonRankPanelItem.OnClickOpenUserInfoBtn = function(self)
  -- function num : 0_3 , upvalues : _ENV
  PlayerDataCenter:GetUserInfoByUID(((self.__rankElemData).entry).uid, function(userInfoData)
    -- function num : 0_3_0 , upvalues : _ENV
    if userInfoData == nil then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonUserInfo, function(win)
      -- function num : 0_3_0_0 , upvalues : userInfoData
      if win == nil then
        return 
      end
      win:InitUserInfoView(userInfoData)
    end
)
  end
)
end

UINCommonRankPanelItem.SetDownTransform = function(self, transform)
  -- function num : 0_4
  self.downTransform = transform
end

UINCommonRankPanelItem.OnClickMultiTeamCheck = function(self)
  -- function num : 0_5 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormationSeason, function(win)
    -- function num : 0_5_0 , upvalues : self
    if win == nil then
      return 
    end
    win:RefreshTeamItem(self.rankMultiForm)
    win:SetShowPosition(((self.ui).btn_Check).transform, self.downTransform)
  end
)
end

return UINCommonRankPanelItem

