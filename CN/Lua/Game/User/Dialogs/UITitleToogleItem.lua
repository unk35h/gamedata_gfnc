-- params : ...
-- function num : 0 , upvalues : _ENV
local uiToggleItem = require("Game.User.Dialogs.UIToogleItem")
local base = uiToggleItem
local UITitleToogleItem = class("UITitleToogleItem", base)
UITitleToogleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UITitleToogleItem.OnSwitchValueChange = function(self, flag)
  -- function num : 0_1 , upvalues : base
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if flag then
    ((self.ui).tog_smallIcon).color = (self.ui).color_Txtselected
  else
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tog_smallIcon).color = (self.ui).color_TxtUnselect
  end
  ;
  (base.OnSwitchValueChange)(self, flag)
end

UITitleToogleItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UITitleToogleItem

