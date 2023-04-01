-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActChapterItem = class("UINActChapterItem", UIBaseNode)
local base = UIBaseNode
UINActChapterItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActChapterItem.InitActChapterItem = function(self, idx, posList)
  -- function num : 0_1 , upvalues : _ENV
  local index = idx - 1
  ;
  ((self.ui).tex_Chapter):SetIndex(index)
  ;
  ((self.ui).tex_State):SetIndex(index)
  local hasData = #posList >= 2
  if hasData then
    local pos = (Vector2.New)(posList[1], posList[2])
    self:SetAnchorPos(pos)
  else
    self:Hide()
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINActChapterItem.SetAnchorPos = function(self, vector2Pos)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.transform).anchoredPosition = vector2Pos
end

UINActChapterItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINActChapterItem

