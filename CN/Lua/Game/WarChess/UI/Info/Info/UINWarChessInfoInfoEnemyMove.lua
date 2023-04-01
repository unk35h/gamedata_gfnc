-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoEnemyMove = class("UINWarChessInfoInfoEnemyMove", base)
UINWarChessInfoInfoEnemyMove.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoEnemyMove.SetCouldMoveDistance = function(self, num)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_move):SetIndex(0, tostring(num))
end

UINWarChessInfoInfoEnemyMove.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoEnemyMove

