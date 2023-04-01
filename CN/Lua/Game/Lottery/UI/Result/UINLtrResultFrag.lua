-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINLtrResultFrag = class("UINLtrResultFrag", base)
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
UINLtrResultFrag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINLtrResultFrag.InitLtrResultFrag = function(self, hasRepeatConvert, upHeroExtraFragNum, extraFragId)
  -- function num : 0_1 , upvalues : UINBaseItem, _ENV
  ((self.ui).obj_RepeatFrag):SetActive(hasRepeatConvert)
  local hasExtraFrag = upHeroExtraFragNum > 0
  ;
  ((self.ui).extraFragItem):SetActive(hasExtraFrag)
  if hasExtraFrag then
    local extraItem = (UINBaseItem.New)()
    extraItem:Init((self.ui).uINBaseItem)
    extraItem:SetItemNoClickEvent(true)
    local itemCfg = (ConfigData.item)[extraFragId]
    extraItem:InitBaseItem(itemCfg)
    self.extraItem = extraItem
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_ExtraFragNum).text = "x" .. tostring(upHeroExtraFragNum)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINLtrResultFrag.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  if self.extraItem ~= nil then
    (self.extraItem):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINLtrResultFrag

