-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_LobbyDoorInfo = class("WCI_LobbyDoorInfo", base)
WCI_LobbyDoorInfo.ctor = function(self)
  -- function num : 0_0
  self.needWalk = false
end

WCI_LobbyDoorInfo.WCActPlay = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if WarChessSeasonManager:GetIsInWCSeasonIsInLobby() then
    local datas = (WarChessSeasonManager:GetWCSCtrl()):WCSGetLobbyNextRoomDataMsg()
    do
      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSeasonSelectLevel, function(win)
    -- function num : 0_1_0 , upvalues : datas, self
    if win == nil then
      return 
    end
    win:InitWCSLevelInfo(datas)
    win:WCSPlayAniSelectLevel(false, nil, 1.25)
    self:WCActOver(true)
  end
)
    end
  end
end

return WCI_LobbyDoorInfo

