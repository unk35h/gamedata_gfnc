-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22BuffItem = require("Game.ActivitySummer.Year22.Tech.Main.UINActSum22BuffItem")
local UINChristmasBuffItem = class("UINChristmasBuffItem", UINActSum22BuffItem)
local base = UINActSum22BuffItem
UINChristmasBuffItem.SetBuffItemNew = function(self, flag)
  -- function num : 0_0
  ((self.ui).obj_New):SetActive(flag)
end

return UINChristmasBuffItem

