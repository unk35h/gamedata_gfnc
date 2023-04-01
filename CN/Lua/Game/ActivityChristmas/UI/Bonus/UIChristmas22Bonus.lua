-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHalloween22Bouns = require("Game.ActivityHallowmas.UI.Bouns.UIHalloween22Bouns")
local UIChristmas22Bonus = class("UIChristmas22Bonus", UIHalloween22Bouns)
local base = UIHalloween22Bouns
UIChristmas22Bonus.BindHalloweenBtn = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseBouns)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReceiveAll, self, self.OnClickPickedAll)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Icon, self, self.OnClickIconTip)
  self.__GetEftLoopCallback = BindCallback(self, self.__GetEftLoop)
end

UIChristmas22Bonus.SethalloweenItemClass = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self._itemClass = require("Game.ActivityChristmas.UI.Bonus.UINChristmasBounsItem")
  self._cycleClass = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsCycleItem")
  self._emetyElement = require("Game.ActivityChristmas.UI.Bonus.UINChristmasBoundsItemEmptyElement")
end

UIChristmas22Bonus.__RefreshAllGet = function(self)
  -- function num : 0_2 , upvalues : base
  (base.__RefreshAllGet)(self)
  ;
  ((self.ui).uI_Christmas22Bonus_yjlq):SetActive((self._data):IsHallowmasExpAllReceive())
end

UIChristmas22Bonus.__OnInstantiateItem = function(self, go)
  -- function num : 0_3 , upvalues : base
  (base.__OnInstantiateItem)(self, go)
  ;
  ((self._goItem)[go]):SetBoundsItemLoopEft(self.__GetEftLoopCallback)
end

UIChristmas22Bonus.__GetEftLoop = function(self)
  -- function num : 0_4
  return ((self.ui).uI_Christmas22Bonus_lq):Instantiate()
end

return UIChristmas22Bonus

