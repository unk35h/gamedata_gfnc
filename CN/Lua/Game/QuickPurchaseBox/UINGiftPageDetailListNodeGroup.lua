-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGiftPageDetailListNodeGroup = class("UINGiftPageDetail", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINGiftPageDetailListNodeGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.rewardItem = (UINBaseItemWithCount.New)()
  ;
  (self.rewardItem):Init((self.ui).uiNBaseItem)
end

UINGiftPageDetailListNodeGroup.InitGiftPageDetailListNodeGroup = function(self, itemCfg, count)
  -- function num : 0_1 , upvalues : _ENV
  (self.rewardItem):InitItemWithCount(itemCfg, count)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
end

UINGiftPageDetailListNodeGroup.SetRaffleItemWeight = function(self, weight)
  -- function num : 0_2 , upvalues : _ENV
  if weight then
    (((self.ui).tex_Rate).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Rate).text = tostring(weight) .. "%"
  else
    ;
    (((self.ui).tex_Rate).gameObject):SetActive(false)
  end
end

return UINGiftPageDetailListNodeGroup

