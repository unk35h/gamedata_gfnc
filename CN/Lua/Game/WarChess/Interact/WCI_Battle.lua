-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_Battle = class("WCI_Battle", base)
WCI_Battle.ctor = function(self)
  -- function num : 0_0
  self.needWalk = not self:WCIsTeamOnPoint()
  self.isWalk2NearBy = true
end

WCI_Battle.WCActPlay = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local teamData = (self.interactCtrl):GetCurTeam()
  local entityData = (self.interactCtrl):GetCurInteractData()
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
  local wcPos = (self.interactCtrl):GetWCPos()
  local entityCat = (self.interactCtrl):GetWCEntityCat()
  local id = (self.interactCtrl):GetCurInteractId()
  ;
  ((self.wcCtrl).mapCtrl):GetMonsterCouldSecKill(entityData, teamData, function(isSeckill)
    -- function num : 0_1_0 , upvalues : self, wid, tid, wcPos, entityCat, id, _ENV
    local battleInteract = {canSecKill = isSeckill}
    ;
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Interact(wid, tid, wcPos, entityCat, id, function(argList)
      -- function num : 0_1_0_0 , upvalues : _ENV, self
      if argList.Count ~= 1 then
        error("argList.Count error:" .. tostring(argList.Count))
        return 
      end
      local isSucess = argList[0]
      self:WCActOver(isSucess)
    end
, battleInteract)
  end
)
end

WCI_Battle.PlayWCActOverAudio = function(self)
  -- function num : 0_2 , upvalues : _ENV
  AudioManager:PlayAudioById(1237)
end

return WCI_Battle

