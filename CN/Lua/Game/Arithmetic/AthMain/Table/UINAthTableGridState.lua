-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthTableGridState = class("UINAthTableGridState", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINAthTableGridState.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINAthTableGridState.InitAthGridState = function(self, position, stateIndex, gridState)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.transform).anchoredPosition = position
  ;
  ((self.ui).img_State):SetIndex(stateIndex)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_State).image).raycastTarget = true
  self._gridState = gridState
end

UINAthTableGridState.BindAthGridClickCallback = function(self, callback)
  -- function num : 0_2
  self._clickCallback = callback
end

UINAthTableGridState._OnClickRoot = function(self)
  -- function num : 0_3
  if self._clickCallback ~= nil then
    (self._clickCallback)(self._gridState)
  end
end

UINAthTableGridState.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINAthTableGridState

