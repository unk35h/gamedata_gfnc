-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local UINLevelDetailRewardItem = class("UINLevelDetailRewardItem", UINBaseItemWithReceived)
local base = UINBaseItemWithReceived
UINLevelDetailRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINLevelDetailRewardItem.InitItemWithCount = function(self, itemCfg, count, clickEvent, isPicked, showTag)
  -- function num : 0_1 , upvalues : base
  (base.InitItemWithCount)(self, itemCfg, count, clickEvent, isPicked)
  ;
  (((self.ui).img_isActSupport).gameObject):SetActive(showTag)
end

UINLevelDetailRewardItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINLevelDetailRewardItem

