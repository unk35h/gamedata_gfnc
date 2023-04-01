-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum21ExcgResultItem = class("UINActSum21ExcgResultItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINActSum21ExcgResultItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).uINBaseItemWithCount)
  ;
  (self.baseItem):SetNotNeedAnyJump(false)
end

UINActSum21ExcgResultItem.InitActSum21ExcgResultItem = function(self, itemId, itemNum, groupNum)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  ;
  (self.baseItem):InitItemWithCount(itemCfg, itemNum, nil, nil, nil, true)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(groupNum))
end

UINActSum21ExcgResultItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (self.baseItem):Delete()
  ;
  (base.OnDelete)(self)
end

return UINActSum21ExcgResultItem

