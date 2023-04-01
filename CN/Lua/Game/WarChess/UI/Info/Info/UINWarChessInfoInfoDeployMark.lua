-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoDeployMark = class("UINWarChessInfoInfoDeployMark", base)
UINWarChessInfoInfoDeployMark.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoDeployMark.OnDelete = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoDeployMark

