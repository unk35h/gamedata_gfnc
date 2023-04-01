-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWCMain_HeroHeadItem = class("UINWCMain_HeroHeadItem", base)
local heroHpPercent = (require("Game.Exploration.ExplorationEnum")).eHeroHpPercent
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINWCMain_HeroHeadItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._heroHeadItem = (UINHeroHeadItem.New)()
  ;
  (self._heroHeadItem):Init((self.ui).heroHeadItem)
end

UINWCMain_HeroHeadItem.InitWCHeroHeadItem = function(self, dynHero, isCaptain)
  -- function num : 0_1
  self.dynHeroData = dynHero
  ;
  ((self.ui).obj_captain):SetActive(isCaptain or false)
  ;
  (self._heroHeadItem):InitHeroHeadItem(dynHero.heroData, self._resloader)
  ;
  (self._heroHeadItem):Show()
  self:RefreshWCHeroHp()
end

UINWCMain_HeroHeadItem.RefreshWCHeroHp = function(self, setMin)
  -- function num : 0_2 , upvalues : _ENV, heroHpPercent
  local amount = (BattleUtil.CalculateBloodDensity)((self.dynHeroData).hpPer / heroHpPercent)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_hP).fillAmount = amount
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  if setMin then
    ((self.ui).img_hPMin).fillAmount = amount
  end
  if amount <= 0.3 then
    ((self.ui).obj_img_Wound):SetActive(true)
  else
    ;
    ((self.ui).obj_img_Wound):SetActive(false)
  end
end

return UINWCMain_HeroHeadItem

