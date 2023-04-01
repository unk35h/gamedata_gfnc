-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventNoviceSignItemII = class("UINEventNoviceSignItemII", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINEventNoviceSignItemII.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._item = (UINBaseItemWithCount.New)()
  ;
  (self._item):Init((self.ui).obj_RewardItem)
end

UINEventNoviceSignItemII.InitNoviceSignItemII = function(self, day, itemId, itemCount)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  ;
  (self._item):InitItemWithCount(itemCfg, itemCount)
  ;
  ((self.ui).img_date):SetIndex(day - 1)
  ;
  ((self.ui).obj_Received):SetActive(false)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
end

UINEventNoviceSignItemII.SetNoviceSignItemIIReviced = function(self, flag)
  -- function num : 0_2
  ((self.ui).obj_Received):SetActive(flag)
end

return UINEventNoviceSignItemII

