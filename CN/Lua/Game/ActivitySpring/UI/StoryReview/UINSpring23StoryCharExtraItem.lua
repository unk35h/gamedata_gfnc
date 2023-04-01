-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryCharExtraItem = class("UINSpring23StoryCharExtraItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINSpring23StoryCharExtraItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
  self._finishColor = ((self.ui).img_LevelBg).color
  self._finishTexColor = ((self.ui).tex_Level).color
end

UINSpring23StoryCharExtraItem.InitSpring23StoryCharExtraItem = function(self, interactCfg, index, flag)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).obj_Exp):SetActive(true)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Level).text = tostring(index)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  if not flag or not self._finishColor then
    ((self.ui).img_LevelBg).color = (self.ui).color_lvBg
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

    if not flag or not self._finishTexColor then
      ((self.ui).tex_Level).color = (self.ui).color_LvTex
      ;
      (((self.ui).img_ExpProgress).gameObject):SetActive(flag)
      ;
      (self._itemPool):HideAll()
      for i,itemId in ipairs(interactCfg.reward_ids) do
        local itemCfg = (ConfigData.item)[itemId]
        local itemCount = (interactCfg.reward_nums)[i]
        local item = (self._itemPool):GetOne()
        item:InitItemWithCount(itemCfg, itemCount, nil, flag)
      end
    end
  end
end

UINSpring23StoryCharExtraItem.HideSpring23StoryCharExtraItemBar = function(self)
  -- function num : 0_2
  ((self.ui).obj_Exp):SetActive(false)
end

return UINSpring23StoryCharExtraItem

