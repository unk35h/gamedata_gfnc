-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.LogicPreviewNode.UINLogicPreviewRowBase")
local UINAttrOutLineRowItem = class("UINAttrOutLineRowItem", base)
UINAttrOutLineRowItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINAttrOutLineRowItem.InitAttrOutLineRowItem = function(self, nameStr, iconSprite, attr, attrExtra, isRecommend)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R6 in 'UnsetPending'

  ((self.ui).attrIcon).sprite = iconSprite
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = nameStr
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Attri).text = attr
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

  if (string.IsNullOrEmpty)(attrExtra) then
    (((self.ui).tex_AttriExtra).text).text = ""
  else
    ;
    ((self.ui).tex_AttriExtra):SetIndex(0, attrExtra)
  end
  ;
  ((self.ui).obj_Recommend):SetActive(isRecommend)
end

UINAttrOutLineRowItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINAttrOutLineRowItem

