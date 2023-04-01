-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWinter23TechSpSidePageItem = class("UINWinter23TechSpSidePageItem", UIBaseNode)
UINWinter23TechSpSidePageItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickPageItem)
end

UINWinter23TechSpSidePageItem.InitWinter23TechSpSidePageItem = function(self, index, callback)
  -- function num : 0_1
  ((self.ui).tex_Text):SetIndex(index - 1)
  self._callback = callback
  self._index = index
end

UINWinter23TechSpSidePageItem.SetWinter23TechSpSidePageSelect = function(self, index)
  -- function num : 0_2 , upvalues : _ENV
  local flag = self._index == index
  ;
  ((self.ui).Bottom1):SetActive(flag)
  ;
  ((self.ui).Bottom2):SetActive(not flag)
  ;
  ((self.ui).obj_Selected):SetActive(flag)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

  if not flag or not Color.white then
    (((self.ui).tex_Text).text).color = (self.ui).color_unSelect
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINWinter23TechSpSidePageItem.OnClickPageItem = function(self)
  -- function num : 0_3
  if self._callback then
    (self._callback)(self._index)
  end
end

return UINWinter23TechSpSidePageItem

