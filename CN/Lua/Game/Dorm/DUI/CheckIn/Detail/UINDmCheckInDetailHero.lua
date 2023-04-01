-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmCheckInDetailHero = class("UINDmCheckInDetailHero", UIBaseNode)
local base = UIBaseNode
UINDmCheckInDetailHero.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINDmCheckInDetailHero.InitDmCheckInDetailHero = function(self, heroData, inCurRoom, inOtherRoom, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.clickFunc = clickFunc
  self.heroData = heroData
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_HeroIcon).sprite = CRH:GetHeroSkinSprite(heroData.dataId, heroData.skinId)
  self:UpdDmCheckInDetailHeroState(inCurRoom, inOtherRoom)
end

UINDmCheckInDetailHero.UpdDmCheckInDetailHeroState = function(self, inCurRoom, inOtherRoom)
  -- function num : 0_2
  ((self.ui).inOtherRoom):SetActive(inOtherRoom)
  ;
  ((self.ui).inCurRoom):SetActive(inCurRoom)
end

UINDmCheckInDetailHero._OnClickRoot = function(self)
  -- function num : 0_3
  if self.clickFunc ~= nil then
    (self.clickFunc)(self, self.heroData)
  end
end

UINDmCheckInDetailHero.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmCheckInDetailHero

