-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessCtrlBase = class("WarChessCtrlBase")
WarChessCtrlBase.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.wcCtrl = wcCtrl
  ;
  (table.insert)((self.wcCtrl).ctrls, self)
end

WarChessCtrlBase.OnSceneUnload = function(self)
  -- function num : 0_1
end

WarChessCtrlBase.Delete = function(self)
  -- function num : 0_2
end

return WarChessCtrlBase

