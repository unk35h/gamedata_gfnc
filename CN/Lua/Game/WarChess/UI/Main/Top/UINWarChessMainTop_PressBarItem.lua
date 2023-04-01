-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMainTop_PressBarItem = class("UINWarChessMainTop_PressBarItem", base)
UINWarChessMainTop_PressBarItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._isBigItem = nil
  self._pressLevel = nil
end

UINWarChessMainTop_PressBarItem.WCInitPressItem = function(self, isBig, level, icon)
  -- function num : 0_1
  self._isBigItem = isBig
  self._pressLevel = level
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  if icon ~= nil then
    ((self.ui).img_Icon).sprite = icon
  end
end

UINWarChessMainTop_PressBarItem.RefreshPressBarItem = function(self, isOver)
  -- function num : 0_2 , upvalues : _ENV
  ;
  ((self.ui).img_Item):SetIndex(isOver and 1 or 0)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  if self._isBigItem then
    if isOver then
      ((self.ui).img_Icon).color = Color.white
    else
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).img_Icon).color = (self.ui).color_unable
    end
  end
end

UINWarChessMainTop_PressBarItem.PlayBarItemOver = function(self)
  -- function num : 0_3
  self:RefreshPressBarItem(true)
  ;
  ((self.ui).obj_aniGroup):SetActive(true)
end

UINWarChessMainTop_PressBarItem.WCPressBarGetIsBigItem = function(self)
  -- function num : 0_4
  return self._isBigItem
end

UINWarChessMainTop_PressBarItem.WCPressBarGetLevel = function(self)
  -- function num : 0_5
  return self._pressLevel
end

return UINWarChessMainTop_PressBarItem

