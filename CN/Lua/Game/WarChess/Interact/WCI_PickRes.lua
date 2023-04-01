-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_PickRes = class("WCI_PickRes", base)
local WarChessHelper = require("Game.Warchess.WarChessHelper")
WCI_PickRes.ctor = function(self)
  -- function num : 0_0
  self.needWalk = true
  if (self.interactCtrl):GetCurInteractRange() == 1 then
    self.isWalk2NearBy = true
  else
    self.isWalk2NearBy = false
  end
end

WCI_PickRes.WCActOver = function(self, isSucess)
  -- function num : 0_1 , upvalues : base, WarChessHelper
  (base.WCActOver)(self, isSucess)
  local triggers = (self.InteractCfg).triggers
  if triggers == nil then
    return 
  end
  ;
  (WarChessHelper.AcquireOutSideBoxReward)(triggers, (self.wcCtrl).wcGlobalData)
end

return WCI_PickRes

