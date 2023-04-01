-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHandBookRewardItem = class("UINHandBookRewardItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
UINHandBookRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._item = (UINBaseItem.New)()
  ;
  (self._item):Init((self.ui).uINBaseItem)
end

UINHandBookRewardItem.InitHandbookReward = function(self, itemId)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  ;
  (self._item):InitBaseItem(itemCfg)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
end

UINHandBookRewardItem.SetHandbookRewardState = function(self, showNoGet)
  -- function num : 0_2
  ((self.ui).img_NotGet):SetActive(showNoGet)
end

UINHandBookRewardItem.PlayBookRewarsItemAni = function(self, delayTime)
  -- function num : 0_3
  ((((self.ui).item):DOFade(0, 0.2)):From()):SetDelay(delayTime)
  ;
  (((((self.ui).bottom):DOLocalMoveY(20, 0.2)):SetRelative(true)):From()):SetDelay(delayTime)
end

UINHandBookRewardItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  ((self.ui).item):DOComplete()
  ;
  ((self.ui).bottom):DOComplete()
  ;
  (base.OnDelete)(self)
end

return UINHandBookRewardItem

