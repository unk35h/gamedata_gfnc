-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsItemEmptyElement")
local UINChristmasBoundsItemEmptyElement = class("UINChristmasBoundsItemEmptyElement", base)
UINChristmasBoundsItemEmptyElement.SetBoundsItemLoopEft = function(self, getFunc)
  -- function num : 0_0
  self._loopEftFunc = getFunc
end

UINChristmasBoundsItemEmptyElement.__SetBounsItemExtra = function(self)
  -- function num : 0_1
  (self._item):SetLoopEftCreateFunc(self._loopEftFunc)
end

return UINChristmasBoundsItemEmptyElement

