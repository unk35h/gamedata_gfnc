-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWAMMMapLevelPointItem = class("UINWAMMMapLevelPointItem", UIBaseNode)
local base = UIBaseNode
UINWAMMMapLevelPointItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWAMMMapLevelPointItem.InitLevelPointItem = function(self, isBattle, index)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Point).text = tostring(index)
  ;
  ((self.ui).obj_img_Line):SetActive(true)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Line).enabled = false
end

UINWAMMMapLevelPointItem.PlayOnSelectTween = function(self, isBattle)
  -- function num : 0_2
  ((self.ui).tween_animaNode):DOPlayForward()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Line).enabled = true
end

UINWAMMMapLevelPointItem.PlayOnCancleSelectTween = function(self)
  -- function num : 0_3
  ((self.ui).tween_animaNode):DOPlayBackwards()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Line).enabled = false
end

UINWAMMMapLevelPointItem.SetArrowSprites = function(self, isClear, isHard)
  -- function num : 0_4
  if isClear then
    ((self.ui).img_Dis):SetIndex(0)
  else
    if isHard then
      ((self.ui).img_Dis):SetIndex(2)
    else
      ;
      ((self.ui).img_Dis):SetIndex(1)
    end
  end
end

UINWAMMMapLevelPointItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINWAMMMapLevelPointItem

