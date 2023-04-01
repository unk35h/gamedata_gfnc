-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonMask = class("UICommonMask", UIBaseWindow)
local base = UIBaseWindow
UICommonMask.InitCommonMask = function(self, bgColor)
  -- function num : 0_0
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).bgImage).color = bgColor
  return self
end

UICommonMask.CommonMaskFadeIn = function(self, time, callback)
  -- function num : 0_1
  self.__permanent = true
  local tween = (((self.ui).bgImage):DOFade(0, time)):From()
  tween.onComplete = function()
    -- function num : 0_1_0 , upvalues : callback, self
    if callback ~= nil then
      callback()
    end
    self.__permanent = false
  end

  return self
end

UICommonMask.CommonMaskFadeOut = function(self, time, callback)
  -- function num : 0_2
  self.__permanent = true
  local tween = ((self.ui).bgImage):DOFade(0, time)
  tween.onComplete = function()
    -- function num : 0_2_0 , upvalues : callback, self
    if callback ~= nil then
      callback()
    end
    self.__permanent = false
  end

  return self
end

return UICommonMask

