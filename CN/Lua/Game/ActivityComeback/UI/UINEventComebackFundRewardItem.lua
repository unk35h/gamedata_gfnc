-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackFundRewardItem = class("UINEventComebackFundRewardItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINEventComebackFundRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._item = (UINBaseItemWithReceived.New)()
  ;
  (self._item):Init((self.ui).uINBaseItemWithReceived)
end

UINEventComebackFundRewardItem.InitFundRewardItem = function(self, itemCfg, count)
  -- function num : 0_1
  (self._item):InitItemWithCount(itemCfg, count)
end

UINEventComebackFundRewardItem.SetPickedUIActive = function(self, isPicked)
  -- function num : 0_2
  (self._item):SetPickedUIActive(isPicked)
end

UINEventComebackFundRewardItem.SetRewardLockState = function(self, flag)
  -- function num : 0_3
  ((self.ui).obj_lock):SetActive(flag)
end

UINEventComebackFundRewardItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINEventComebackFundRewardItem

