-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Event.UINWarChessEventTypeNodeBase")
local UINWarChessEventEventNode = class("UINWarChessEventEventNode", base)
UINWarChessEventEventNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

return UINWarChessEventEventNode

