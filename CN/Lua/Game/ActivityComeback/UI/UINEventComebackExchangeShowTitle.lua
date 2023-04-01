-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackExchangeShowTitle = class("UINEventComebackExchangeShowTitle", UIBaseNode)
local base = UINEventComebackExchangeShowTitle
UINEventComebackExchangeShowTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINEventComebackExchangeShowTitle.InitExchangeShowTitle = function(self, texIndex)
  -- function num : 0_1
  ((self.ui).tex_GroupTitle):SetIndex(texIndex)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).title).color = ((self.ui).color_tileBg)[texIndex + 1]
  ;
  (((self.ui).tex_Tips).gameObject):SetActive(false)
end

UINEventComebackExchangeShowTitle.SetNextPoolTip = function(self, poolName)
  -- function num : 0_2
  (((self.ui).tex_Tips).gameObject):SetActive(true)
  ;
  ((self.ui).tex_Tips):SetIndex(0, poolName)
end

return UINEventComebackExchangeShowTitle

