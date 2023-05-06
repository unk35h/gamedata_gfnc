-- params : ...
-- function num : 0 , upvalues : _ENV
local UIRewardPreviewItem = class("UIRewardPreviewItem", UIBaseNode)
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UIRewardPreviewItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).UINBaseItemWithCount)
end

UIRewardPreviewItem.InitItemWithCount = function(self, itemCfg, count, clickEvent, wareHouseNum, clickExtrEvent, isHideLoopFx)
  -- function num : 0_1
  (self.baseItem):InitItemWithCount(itemCfg, count, clickEvent, wareHouseNum, clickExtrEvent, isHideLoopFx)
end

return UIRewardPreviewItem

