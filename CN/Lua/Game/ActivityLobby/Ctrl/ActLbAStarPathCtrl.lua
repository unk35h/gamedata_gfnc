-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityLobby.Ctrl.ActLobbyCtrlBase")
local ActLbAStarPathCtrl = class("ActLbAStarPathCtrl", base)
ActLbAStarPathCtrl.ctor = function(self, actLbCtrl)
  -- function num : 0_0
end

ActLbAStarPathCtrl.OnActLbSceneEnter = function(self, bind)
  -- function num : 0_1 , upvalues : base
  (base.OnActLbSceneEnter)(self, bind)
end

ActLbAStarPathCtrl.Delete = function(self)
  -- function num : 0_2
end

return ActLbAStarPathCtrl

