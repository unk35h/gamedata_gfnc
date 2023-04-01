-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmasBtn = class("UINChristmasBtn", UIBaseNode)
local base = UIBaseNode
UINChristmasBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickRootBtn)
end

UINChristmasBtn.InitChristmasBtn = function(self, callback)
  -- function num : 0_1
  self._callback = callback
end

UINChristmasBtn.OnClickRootBtn = function(self)
  -- function num : 0_2
  if self._callback ~= nil then
    (self._callback)()
  end
end

UINChristmasBtn.SetChristmasBtnRed = function(self, flag)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull((self.ui).redDot) and isGameDev then
    error(" redDot Miss ")
  end
  do return  end
  ;
  ((self.ui).redDot):SetActive(flag)
end

UINChristmasBtn.SetChristmasBtnBlue = function(self, flag)
  -- function num : 0_4 , upvalues : _ENV
  if IsNull((self.ui).blueDot) and isGameDev then
    error(" redDot Miss ")
  end
  do return  end
  ;
  ((self.ui).blueDot):SetActive(flag)
end

return UINChristmasBtn

