-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRecommeTeamItem = class("UINRecommeTeamItem", UIBaseNode)
local base = UIBaseNode
local UINCommonRankItemHeroHead = require("Game.CommonUI.Rank.UINCommonRankItemHeroHead")
local RankHeroSortFunc = function(hero1, hero2)
  -- function num : 0_0
  do return hero1.formIdx < hero2.formIdx end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINRecommeTeamItem.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINCommonRankItemHeroHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.heroHeadPool = (UIItemPool.New)(UINCommonRankItemHeroHead, (self.ui).obj_HeroHead)
  ;
  ((self.ui).obj_HeroHead):SetActive(false)
end

UINRecommeTeamItem.RefreshRecommeTeamItem = function(self, teamHero, index)
  -- function num : 0_2 , upvalues : _ENV, RankHeroSortFunc
  ((self.ui).tex_TitleName):SetIndex(index - 1)
  ;
  (self.heroHeadPool):HideAll()
  local onBattleHeros = {}
  if teamHero then
    local heroList = teamHero.heroes
    for key,rankHero in ipairs(heroList) do
      if not (BattleUtil.PosOnBench)(rankHero.position) then
        (table.insert)(onBattleHeros, rankHero)
      end
    end
  end
  do
    if #onBattleHeros < 5 then
      (table.sort)(onBattleHeros, RankHeroSortFunc)
      local heroNum = (math.min)(#onBattleHeros, 5)
      for i = 1, 5 do
        if i <= heroNum then
          local rankHero = onBattleHeros[i]
          local item = (self.heroHeadPool):GetOne()
          if rankHero ~= nil then
            item:InitHead(rankHero.heroId, rankHero.level, rankHero.rank)
          end
          item:SetHeroHeadItemAtive(rankHero ~= nil)
        else
          local emptyObj = ((self.ui).obj_EmptyHero):Instantiate((((self.ui).obj_EmptyHero).transform).parent)
          emptyObj:SetActive(true)
        end
      end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
end

UINRecommeTeamItem.OnClickClose = function(self)
  -- function num : 0_3
  self:Delete()
end

return UINRecommeTeamItem

