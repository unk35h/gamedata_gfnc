-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_Born = class("WCI_Born", base)
WCI_Born.ctor = function(self)
  -- function num : 0_0
  self.needWalk = false
end

WCI_Born.WCActConfirm = function(self)
  -- function num : 0_1 , upvalues : base
  (base.WCActWalkTo)(self)
end

WCI_Born.WCActPlay = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local teamData = (self.interactCtrl):GetCurTeam()
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
  local wcPos = (self.interactCtrl):GetWCPos()
  local entityCat = (self.interactCtrl):GetWCEntityCat()
  local id = (self.interactCtrl):GetCurInteractId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Deploy(wid, tid, wcPos, entityCat, id, function(argList)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    self:WCActOver(isSucess)
  end
)
end

return WCI_Born

