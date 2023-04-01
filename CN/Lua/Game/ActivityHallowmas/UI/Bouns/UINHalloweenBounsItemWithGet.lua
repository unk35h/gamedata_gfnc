-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenBounsItem = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsItem")
local UINHalloweenBounsItemWithGet = class("UINHalloweenBounsItemWithGet", UINHalloweenBounsItem)
local base = UINHalloweenBounsItem
UINHalloweenBounsItemWithGet.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.AddButtonListener)((self.ui).obj_Get, self, self.OnClickGet)
end

UINHalloweenBounsItemWithGet.__IntiFixed = function(self)
  -- function num : 0_1 , upvalues : base
  (base.__IntiFixed)(self)
  ;
  (((self.ui).obj_Get).transform):SetAsLastSibling()
end

UINHalloweenBounsItemWithGet.RefreshBounsItem = function(self)
  -- function num : 0_2
  local canPicked = (self._data):IsHallowmasLevelCanPick(self._level)
  ;
  (((self.ui).obj_Get).gameObject):SetActive(canPicked)
end

return UINHalloweenBounsItemWithGet

