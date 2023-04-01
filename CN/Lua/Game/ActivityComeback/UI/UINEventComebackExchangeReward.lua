-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackExchangeReward = class("UINEventComebackExchangeReward", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINEventComebackExchangeReward.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._item = (UINBaseItemWithCount.New)()
  ;
  (self._item):Init((self.ui).uINBaseItemWithCount)
end

UINEventComebackExchangeReward.InitExchangeReward = function(self, itemId, itemCount, remainTimes)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  ;
  (self._item):InitItemWithCount(itemCfg, itemCount)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Count).text = tostring(remainTimes)
end

UINEventComebackExchangeReward.SetExchangeRemainCount = function(self, remainTimes)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Count).text = tostring(remainTimes)
end

return UINEventComebackExchangeReward

