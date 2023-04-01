-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Main.WarChessItem.UINWarChessPumpkin")
local UINWarChessChristmasStar = class("UINWarChessChristmasStar", base)
UINWarChessChristmasStar.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINWarChessChristmasStar.OnDelete = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessChristmasStar

