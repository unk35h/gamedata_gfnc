-- params : ...
-- function num : 0 , upvalues : _ENV
local ActLobbyCtrlBase = class("ActLobbyCtrlBase")
ActLobbyCtrlBase.ctor = function(self, actLbCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.actLbCtrl = actLbCtrl
  ;
  (table.insert)((self.actLbCtrl).ctrls, self)
end

ActLobbyCtrlBase.OnActLbSceneEnter = function(self, bind)
  -- function num : 0_1
  self._rootBind = bind
end

ActLobbyCtrlBase.Delete = function(self)
  -- function num : 0_2
end

return ActLobbyCtrlBase

