-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAct21SumExcgRewardItem = class("UINAct21SumExcgRewardItem", UIBaseNode)
local base = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINAct21SumExcgRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).uINBaseItemWithCount)
  ;
  (self.baseItem):SetNotNeedAnyJump(false)
end

UINAct21SumExcgRewardItem.InitAct21SumExcgRewardItem = function(self, itemCfg, itemNum, surplusNum)
  -- function num : 0_1 , upvalues : _ENV
  (self.baseItem):InitItemWithCount(itemCfg, itemNum, nil, nil, nil, true)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Surplus).text = tostring(surplusNum)
  local isClear = surplusNum == 0
  ;
  ((self.ui).isClear):SetActive(isClear)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = isClear and 0.4 or 1
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINAct21SumExcgRewardItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (self.baseItem):Delete()
  ;
  (base.OnDelete)(self)
end

return UINAct21SumExcgRewardItem

