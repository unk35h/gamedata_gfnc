-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryPage = class("UINSpring23StoryPage", UIBaseNode)
local base = UIBaseNode
UINSpring23StoryPage.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickPage)
end

UINSpring23StoryPage.InitSpring23StoryPage = function(self, index, unlock, callback)
  -- function num : 0_1
  ((self.ui).img_Icon):SetIndex(index - 1)
  ;
  ((self.ui).tex_StoryName):SetIndex(index - 1)
  ;
  ((self.ui).obj_Lock):SetActive(not unlock)
  self._index = index
  self._callback = callback
end

UINSpring23StoryPage.ActiveSpring23StoryPage = function(self, flag)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if not flag or not Color.white then
    (((self.ui).img_Icon).image).color = (self.ui).clor_unSelect
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

    if not flag or not (self.ui).color_bg_selected then
      ((self.ui).bottom).color = (self.ui).color_bg_unselect
    end
  end
end

UINSpring23StoryPage.OnClickPage = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._index, self)
  end
end

return UINSpring23StoryPage

