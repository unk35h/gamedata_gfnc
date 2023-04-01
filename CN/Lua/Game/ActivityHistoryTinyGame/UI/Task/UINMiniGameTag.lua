-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameTag = class("UINMiniGameTag", UIBaseNode)
local base = UIBaseNode
UINMiniGameTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).pageItem, self, self.OnClickTag)
end

UINMiniGameTag.InitMiniGameTag = function(self, index, callback)
  -- function num : 0_1
  self._index = index
  self._callback = callback
  ;
  ((self.ui).img_Icon):SetIndex(index - 1)
  ;
  ((self.ui).tex_Text):SetIndex(index - 1)
end

UINMiniGameTag.RefreshTagState = function(self, selectIndex)
  -- function num : 0_2
  local flag = selectIndex == self._index
  ;
  (((self.ui).img_SelectFrame).gameObject):SetActive(flag)
  local color = (((self.ui).tex_Text).text).color
  color.a = flag and 1 or 0.7
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).tex_Text).text).color = color
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_Icon).image).color = color
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINMiniGameTag.SetHTGTaskTagDot = function(self, flag)
  -- function num : 0_3
  ((self.ui).blueDot):SetActive(flag)
end

UINMiniGameTag.OnClickTag = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self._index)
  end
end

return UINMiniGameTag

