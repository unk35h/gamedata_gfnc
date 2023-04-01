-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_PushBox = class("WCI_PushBox", base)
WCI_PushBox.ctor = function(self)
  -- function num : 0_0
  self.needWalk = true
  self.isWalk2NearBy = true
end

WCI_PushBox.WCActPlay = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local teamData = (self.interactCtrl):GetCurTeam()
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
  local wcPos = (self.interactCtrl):GetWCPos()
  local entityCat = (self.interactCtrl):GetWCEntityCat()
  local id = (self.interactCtrl):GetCurInteractId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Interact(wid, tid, wcPos, entityCat, id, function(argList)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    if not isSucess then
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8525))
    end
    self:WCActOver(isSucess)
  end
)
end

return WCI_PushBox

