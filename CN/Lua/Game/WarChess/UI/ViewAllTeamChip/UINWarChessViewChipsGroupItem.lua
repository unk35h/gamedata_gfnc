-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessViewChipsGroupItem = class("UINWarChessViewChipsGroupItem", base)
UINWarChessViewChipsGroupItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessViewChipsGroupItem.InitWCViewChipGroup = function(self, teamData, chipItemPool, onClickFunc, isSelected)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R5 in 'UnsetPending'

  ((self.ui).tex_GroupTitle).text = teamData:GetWCTeamName()
  local chipList = teamData:GetWCTeamChipList()
  for _,chipData in ipairs(chipList) do
    local chipItem = chipItemPool:GetOne()
    chipItem:InitWCViewChipChipItem(chipData, onClickFunc)
    ;
    (chipItem.transform):SetParent(self.transform)
    if not isSelected.isSelected then
      chipItem:__OnClickItem()
      isSelected.isSelected = true
    end
  end
end

UINWarChessViewChipsGroupItem.OnDelete = function(self)
  -- function num : 0_2
end

return UINWarChessViewChipsGroupItem

