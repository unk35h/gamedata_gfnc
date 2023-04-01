-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSignInMiniGameDayItem = class("UINSignInMiniGameDayItem", UIBaseNode)
local base = UIBaseNode
UINSignInMiniGameDayItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINSignInMiniGameDayItem.InitVaildItem = function(self, day)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  if day > 9 then
    ((self.ui).tex_Date).text = tostring(day)
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Date).text = "0" .. tostring(day)
  end
end

UINSignInMiniGameDayItem.ChangeSignFlag = function(self, signEnum)
  -- function num : 0_2
  ((self.ui).obj_signFlag):SetActive(signEnum == 1)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Date).color = ((self.ui).color_sign)[signEnum]
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINSignInMiniGameDayItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINSignInMiniGameDayItem

