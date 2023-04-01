-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthDcmpFilterDynamicTitleGroup = class("UINAthDcmpFilterDynamicTitleGroup", UIBaseNode)
local base = UIBaseNode
UINAthDcmpFilterDynamicTitleGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINAthDcmpFilterDynamicTitleGroup.InitAthDcmpFilterDynamicTitleGroup = function(self, scrollData, isSelectBasic)
  -- function num : 0_1
  local tileIdx = scrollData.tileIdx
  ;
  ((self.ui).tex_GroupName):SetIndex(tileIdx)
  local showExtraText = isSelectBasic and scrollData.isEmpty
  ;
  (((self.ui).tex_Empty).gameObject):SetActive(showExtraText)
  if not isSelectBasic then
    ((self.ui).tex_Empty):SetIndex(0)
  elseif scrollData.isEmpty then
    ((self.ui).tex_Empty):SetIndex(1)
  end
  local sizeDelta = (self.transform).sizeDelta
  if not showExtraText or not (self.ui).noneHeight then
    sizeDelta.y = (self.ui).normalHeight
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.transform).sizeDelta = sizeDelta
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

UINAthDcmpFilterDynamicTitleGroup.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINAthDcmpFilterDynamicTitleGroup

