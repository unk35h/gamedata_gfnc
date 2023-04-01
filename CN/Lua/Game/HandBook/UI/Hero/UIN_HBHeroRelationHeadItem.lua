-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.HandBook.UI.Hero.UIN_HBHeroHeroListHeroItem")
local UIN_HBHeroRelationHeadItem = class("UIN_HBHeroRelationHeadItem", base)
UIN_HBHeroRelationHeadItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroItem, self, self.__OnClick)
end

UIN_HBHeroRelationHeadItem.InitHBRelationHeroHeadItem = function(self, isMain, onClickHeroItem)
  -- function num : 0_1
  self.isMain = isMain
  self.onClickHeroItem = onClickHeroItem
end

UIN_HBHeroRelationHeadItem.RefreshHBRelationHeroHeadItem = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  local campCfg = (ConfigData.camp)[heroCfg.camp]
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_CampIcon).sprite = CRH:GetSprite(campCfg.icon, CommonAtlasType.CareerCamp)
  return self:RefreshHBHeroHeadItem(heroId)
end

UIN_HBHeroRelationHeadItem.__OnClick = function(self)
  -- function num : 0_3
  if self.onClickHeroItem ~= nil then
    (self.onClickHeroItem)(self.heroId, self)
  end
end

UIN_HBHeroRelationHeadItem.HBHRHeadPlayEnterTween = function(self, delay)
  -- function num : 0_4
  self:ClearHBHeroItemTween()
  ;
  (((((self.ui).rect_head):DOLocalMoveY(-50, 0.3)):From()):SetRelative(true)):SetDelay(delay)
  ;
  ((((self.ui).cg_head):DOFade(0, 0.25)):From()):SetDelay(delay)
  ;
  ((((self.ui).img_CampIcon):DOFade(0, 0.5)):From()):SetDelay(delay + 0.1)
  ;
  (((((self.ui).img_CampIcon).transform):DOScale(1.2, 0.5)):From()):SetDelay(delay + 0.1)
end

UIN_HBHeroRelationHeadItem.ClearHBHeroItemTween = function(self)
  -- function num : 0_5
  ((self.ui).rect_head):DOComplete()
  ;
  ((self.ui).cg_head):DOComplete()
  ;
  ((self.ui).img_CampIcon):DOComplete()
  ;
  (((self.ui).img_CampIcon).transform):DOComplete()
end

UIN_HBHeroRelationHeadItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UIN_HBHeroRelationHeadItem

