-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackExchangeShowTitle = require("Game.ActivityComeback.UI.UINEventComebackExchangeShowTitle")
local UINEventComebackLiteExchangeShowTitle = class("UINEventComebackLiteExchangeShowTitle", UINEventComebackExchangeShowTitle)
local base = UINEventComebackExchangeShowTitle
UINEventComebackLiteExchangeShowTitle.InitExchangeShowTitle = function(self, texIndex)
  -- function num : 0_0
  ((self.ui).tex_GroupTitle):SetIndex(texIndex)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).title).color = ((self.ui).color_tileBg)[texIndex + 1]
end

UINEventComebackLiteExchangeShowTitle.SetNextPoolTip = function(self, poolName)
  -- function num : 0_1
end

return UINEventComebackLiteExchangeShowTitle

