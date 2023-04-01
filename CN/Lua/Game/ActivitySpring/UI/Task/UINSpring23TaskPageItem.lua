-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Task.UINChristmasTaskPageItem")
local UINSpring23TaskPageItem = class("UINSpring23TaskPageItem", base)
UINSpring23TaskPageItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).pageItem, self, self.OnClickSelect)
end

UINSpring23TaskPageItem.InitChristmasTaskPageItem = function(self, titleType, callback)
  -- function num : 0_1
  self._titleType = titleType
  self._callback = callback
  ;
  ((self.ui).tex_Task):SetIndex(titleType - 1)
  ;
  ((self.ui).img_Title):SetIndex(titleType - 1)
end

UINSpring23TaskPageItem.InitChristmasTaskPageItemParam2 = function(self, titleType, imgType, callback)
  -- function num : 0_2
  self._titleType = titleType
  self._callback = callback
  ;
  ((self.ui).tex_Task):SetIndex(titleType - 1)
  ;
  ((self.ui).img_Title):SetIndex(imgType - 1)
end

UINSpring23TaskPageItem.SetChristmasTaskPageSelect = function(self, titleType)
  -- function num : 0_3 , upvalues : _ENV
  local flag = self._titleType == titleType
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  if not flag or not (Color.New)(1, 1, 1, 1) then
    (((self.ui).tex_Task).text).color = (self.ui).color_texUnSelected
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

    if not flag or not (Color.New)(1, 1, 1, 1) then
      (((self.ui).img_Title).image).color = (self.ui).color_texUnSelected
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R3 in 'UnsetPending'

      if not flag or not (self.ui).color_selected then
        ((self.ui).img_root).color = (self.ui).color_unselected
        ;
        ((self.ui).img_pageItem):SetIndex(flag and 0 or 1)
        -- DECOMPILER ERROR: 9 unprocessed JMP targets
      end
    end
  end
end

return UINSpring23TaskPageItem

