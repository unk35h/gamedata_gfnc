-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChipGiftRewardItem = class("UINChipGiftRewardItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINChipGiftRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.itemIcon = (UINBaseItemWithCount.New)()
  ;
  (self.itemIcon):Init((self.ui).uINBaseItemWithCount)
  ;
  (self.itemIcon):SetNotNeedAnyJump(true)
end

UINChipGiftRewardItem.InitChipGiftReward = function(self, itemId, itemCount)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  ;
  (self.itemIcon):InitItemWithCount(itemCfg, itemCount)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_itemName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(itemCfg.describe)
end

return UINChipGiftRewardItem

