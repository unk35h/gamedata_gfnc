-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameMainBtn = class("UINMiniGameMainBtn", UIBaseNode)
local base = UIBaseNode
UINMiniGameMainBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Item, self, self.OnClickMiniBtn)
end

UINMiniGameMainBtn.InitMiniBtn = function(self, index, callback)
  -- function num : 0_1
  self._index = index
  ;
  ((self.ui).tex_Text):SetIndex(index - 1)
  self._callback = callback
end

UINMiniGameMainBtn.SetMiniBtnState = function(self, selectIndex)
  -- function num : 0_2
  local flag = selectIndex == self._index
  ;
  ((self.ui).obj_selected):SetActive(flag)
  local color = (((self.ui).tex_Text).text).color
  color.a = flag and 1 or 0.7
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).tex_Text).text).color = color
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINMiniGameMainBtn.SetMiniBtnReddot = function(self, flag, isBlue)
  -- function num : 0_3
  ;
  ((self.ui).blueDot):SetActive(not flag or isBlue)
  if flag then
    ((self.ui).redDot):SetActive(not isBlue)
  end
end

UINMiniGameMainBtn.GetMiniBtnIndex = function(self)
  -- function num : 0_4
  return self._index
end

UINMiniGameMainBtn.OnClickMiniBtn = function(self)
  -- function num : 0_5
  if self._callback ~= nil then
    (self._callback)(self._index)
  end
end

return UINMiniGameMainBtn

