-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINLtrResultItem = class("UINLtrResultItem", base)
UINLtrResultItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINLtrResultItem.InitLtrResultItem = function(self, itemCfg, num)
  -- function num : 0_1 , upvalues : base
  (base.InitItemWithCount)(self, itemCfg, num)
end

UINLtrResultItem.SetLtrResultItemEmpty = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_Empty).enabled = true
  ;
  ((self.ui).baseItemWithName):SetActive(false)
end

UINLtrResultItem.GetLtrResultItemUIRoot = function(self)
  -- function num : 0_3
  return (self.ui).root
end

UINLtrResultItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINLtrResultItem

