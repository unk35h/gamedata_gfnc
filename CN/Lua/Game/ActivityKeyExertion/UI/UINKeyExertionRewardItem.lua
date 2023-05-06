-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINKeyExertionRewardItem = class("UINKeyExertionRewardItem", UINBaseItemWithCount)
local base = UINBaseItemWithCount
UINKeyExertionRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).uINBaseItemWithCount)
  ;
  (self.baseItem):SetNotNeedAnyJump(false)
end

UINKeyExertionRewardItem.InitKeyExertionRewardItem = function(self, itemCfg, itemNum, isAllPicked)
  -- function num : 0_1
  (self.baseItem):InitItemWithCount(itemCfg, itemNum)
  ;
  ((self.ui).isClear):SetActive(isAllPicked)
  ;
  ((self.ui).obj_ClearMask):SetActive(isAllPicked)
end

UINKeyExertionRewardItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (self.baseItem):Delete()
  ;
  (base.OnDelete)(self)
end

return UINKeyExertionRewardItem

