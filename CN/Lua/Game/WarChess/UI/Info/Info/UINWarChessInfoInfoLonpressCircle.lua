-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoLonpressCircle = class("UINWarChessInfoInfoLonpressCircle", base)
UINWarChessInfoInfoLonpressCircle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoLonpressCircle.WCInfoLongPressCircleSetRate = function(self, rate)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_longPressCircle).fillAmount = rate
end

UINWarChessInfoInfoLonpressCircle.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoLonpressCircle

