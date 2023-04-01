-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessSubSystemCtrlBase = class("WarChessSubSystemCtrlBase", base)
WarChessSubSystemCtrlBase.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  local cat = self:__GetWCSubSystemCat()
  if cat == nil then
    error("not\'t def wc sub system cat, pleas check it")
  else
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (wcCtrl.cat2SubCtrlDic)[cat] = self
  end
end

WarChessSubSystemCtrlBase.__GetWCSubSystemCat = function(self)
  -- function num : 0_1
end

WarChessSubSystemCtrlBase.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2
end

WarChessSubSystemCtrlBase.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_3
end

return WarChessSubSystemCtrlBase

