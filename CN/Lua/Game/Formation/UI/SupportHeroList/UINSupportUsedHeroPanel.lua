-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSupportUsedHeroPanel = class("UINSupportUsedHeroPanel", UIBaseNode)
local base = UIBaseNode
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINSupportUsedHeroPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Bg, self, UIUtil.OnClickBack)
  self.headPool = (UIItemPool.New)(UINHeroHeadItem, (self.ui).heroHeadItem)
  ;
  ((self.ui).heroHeadItem):SetActive(false)
end

UINSupportUsedHeroPanel.InitUsedSupportHero = function(self, assistHeroTime)
  -- function num : 0_1 , upvalues : _ENV
  (self.headPool):HideAll()
  if assistHeroTime == nil then
    return 
  end
  for heroId,usedTimes in pairs(assistHeroTime) do
    if usedTimes > 0 then
      local headItem = (self.headPool):GetOne()
      headItem:InitHeroHeadItemWithId(heroId, nil)
    end
  end
end

UINSupportUsedHeroPanel.__OnClickClose = function(self)
  -- function num : 0_2
  self:Hide()
end

UINSupportUsedHeroPanel.OnShow = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.__OnClickClose)
  ;
  (UIUtil.HideTopStatus)()
end

UINSupportUsedHeroPanel.OnHide = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (UIUtil.ReShowTopStatus)()
end

UINSupportUsedHeroPanel.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINSupportUsedHeroPanel

