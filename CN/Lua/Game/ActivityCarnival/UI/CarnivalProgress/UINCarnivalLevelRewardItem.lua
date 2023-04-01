-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINCarnivalLevelRewardItem = class("UINCarnivalLevelRewardItem", base)
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINCarnivalLevelRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItemWithReceived.New)()
  ;
  (self.baseItem):Init((self.ui).uINBaseItemWithReceived)
end

UINCarnivalLevelRewardItem.InitCarnivalLevelRewardItem = function(self, itemId, itemNum, clickEvent, isPicked, pickable)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("Cant get itemCfg, id = " .. tostring(itemId))
    return 
  end
  ;
  ((self.ui).img_Black):SetActive(pickable)
  ;
  (self.baseItem):InitItemWithCount(itemCfg, itemNum, clickEvent, isPicked)
  ;
  (self.baseItem):SetNotNeedAnyJump(true)
end

UINCarnivalLevelRewardItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (self.baseItem):Delete()
  ;
  (base.OnDelete)(self)
end

return UINCarnivalLevelRewardItem

