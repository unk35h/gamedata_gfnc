-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSignInMiniGameAwardItem = class("UINSignInMiniGameDayItem", UIBaseNode)
local base = UIBaseNode
UINSignInMiniGameAwardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINSignInMiniGameAwardItem.InitItem = function(self, index, minAwardNum, maxAwardNum)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_Number).color = ((self.ui).color_Numbers)[index]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Number).text = "0" .. tostring(4 - index)
  ;
  ((self.ui).tex_TagName):SetIndex(index - 1)
  ;
  ((self.ui).img_Tag):SetIndex(index - 1)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_frame).color = ((self.ui).color_Numbers)[index]
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Range).text = tostring(minAwardNum) .. "-" .. tostring(maxAwardNum)
end

UINSignInMiniGameAwardItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINSignInMiniGameAwardItem

