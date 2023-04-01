-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_DNTeamItemHeroItem = class("UINWarChessMain_DNTeamItemHeroItem", UIBaseNode)
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINWarChessMain_DNTeamItemHeroItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.heroHeadItem = (UINHeroHeadItem.New)()
  ;
  (self.heroHeadItem):Init((self.ui).obj_heroHeadItem)
end

UINWarChessMain_DNTeamItemHeroItem.InitWCHeroHeadItem = function(self, heroData, isCaptain)
  -- function num : 0_1
  (self.heroHeadItem):InitHeroHeadItem(heroData)
  ;
  ((self.ui).obj_captain):SetActive(isCaptain or false)
end

UINWarChessMain_DNTeamItemHeroItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessMain_DNTeamItemHeroItem

