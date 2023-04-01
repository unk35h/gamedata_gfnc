-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmasTaskPageItem = class("UINChristmasTaskPageItem", UIBaseNode)
local base = UIBaseNode
UINChristmasTaskPageItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).pageItem, self, self.OnClickSelect)
  self._color = ((self.ui).img_root).color
end

UINChristmasTaskPageItem.InitChristmasTaskPageItem = function(self, titleType, callback)
  -- function num : 0_1
  self._titleType = titleType
  self._callback = callback
  ;
  ((self.ui).tex_TaskName):SetIndex(titleType - 1)
  ;
  ((self.ui).img_Note):SetIndex(titleType - 1)
  ;
  ((self.ui).tex_Task):SetIndex(titleType - 1)
end

UINChristmasTaskPageItem.SetChristmasTaskPageSelect = function(self, titleType)
  -- function num : 0_2
  self:SetChristmasTaskPageSelectFlag(self._titleType == titleType)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINChristmasTaskPageItem.SetChristmasTaskPageSelectFlag = function(self, flag)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_root).alpha = flag and 1 or 0.5
end

UINChristmasTaskPageItem.SetChristmasTaskPageRed = function(self, flag)
  -- function num : 0_4
  ((self.ui).redDot):SetActive(flag)
end

UINChristmasTaskPageItem.ShowChristmasTaskPageLine = function(self, flag)
  -- function num : 0_5 , upvalues : _ENV
  if not IsNull((self.ui).line) then
    ((self.ui).line):SetActive(flag)
  end
end

UINChristmasTaskPageItem.OnClickSelect = function(self)
  -- function num : 0_6
  if self._callback ~= nil then
    (self._callback)(self._titleType, self)
  end
end

return UINChristmasTaskPageItem

