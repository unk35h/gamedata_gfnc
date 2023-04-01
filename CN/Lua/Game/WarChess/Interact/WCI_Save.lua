-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_Save = class("WCI_Switch", base)
local WarChessSeasonUtil = require("Game.WarchessSeason.WarChessSeasonUtil")
WCI_Save.ctor = function(self)
  -- function num : 0_0
  self.needWalk = false
  self.isWalk2NearBy = false
end

WCI_Save.WCActPlay = function(self)
  -- function num : 0_1 , upvalues : _ENV, base, WarChessSeasonUtil
  local interactentityData = (self.interactCtrl):GetCurInteractData()
  if interactentityData == nil then
    error("show info interactentityData not exist")
    ;
    (base.WCActOver)(self, false)
    return 
  end
  ;
  (WarChessSeasonUtil.OpenSeasonSaveWindow)(function()
    -- function num : 0_1_0 , upvalues : base, self
    (base.WCActOver)(self, true)
  end
)
end

return WCI_Save

