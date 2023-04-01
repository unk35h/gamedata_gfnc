-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCmUseGiftItem = class("UINCmUseGiftItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINCmUseGiftItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_check, self, self._OnClickShowInfo)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).uINBaseItemWithCount)
end

UINCmUseGiftItem.InitCmUseGiftItem = function(self, itemCfg, count, clickEvent)
  -- function num : 0_1
  self.itemCfg = itemCfg
  self.count = count
  ;
  (self.baseItem):InitItemWithCount(itemCfg, count, clickEvent)
end

UINCmUseGiftItem._OnClickShowInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(window)
    -- function num : 0_2_0 , upvalues : self
    window:SetNotNeedAnyJump(true)
    window:InitCommonItemDetail(self.itemCfg)
  end
)
end

UINCmUseGiftItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (self.baseItem):Delete()
  ;
  (base.OnDelete)(self)
end

return UINCmUseGiftItem

