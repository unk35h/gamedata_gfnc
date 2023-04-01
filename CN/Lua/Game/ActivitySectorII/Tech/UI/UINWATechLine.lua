-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWATechLine = class("UINWATechLine", UIBaseNode)
local base = UIBaseNode
UINWATechLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWATechLine.InitWALineItem = function(self, preTechItem, techItem)
  -- function num : 0_1 , upvalues : _ENV
  local startPos = (preTechItem.transform).anchoredPosition
  local endPos = (techItem.transform).anchoredPosition
  local techItemSize = (techItem.transform).sizeDelta
  local sizeDelta = (Vector2.New)(4, (math.abs)(endPos.y - startPos.y) - techItemSize.y)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = sizeDelta
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = (Vector2.New)(startPos.x + techItemSize.x / 2, startPos.y - techItemSize.y)
end

UINWATechLine.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechLine

