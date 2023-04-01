-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroPotentialCostItem = class("UINHeroPotentialCostItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
UINHeroPotentialCostItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItem.New)()
  ;
  (self.baseItem):Init((self.ui).obj_uINBaseItem)
  self.__OnClickPotentialItem = BindCallback(self, self.OnClickPotentialItem)
end

UINHeroPotentialCostItem.InitCostInfo = function(self, cfg, needCount)
  -- function num : 0_1 , upvalues : _ENV
  self.hasCount = PlayerDataCenter:GetItemCount(cfg.id)
  self.needCount = needCount
  ;
  (self.baseItem):InitBaseItem(cfg, self.__OnClickPotentialItem)
  local textId = self.needCount <= self.hasCount and 0 or 2
  ;
  ((self.ui).tex_ExtrCount):SetIndex(textId, tostring(self.needCount), tostring(self.hasCount))
end

UINHeroPotentialCostItem.OnClickPotentialItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(window)
    -- function num : 0_2_0 , upvalues : self
    window:InitCommonItemDetail((self.baseItem).itemCfg, nil)
    window:TryShowGiftJump(self.hasCount < self.needCount)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
end

return UINHeroPotentialCostItem

