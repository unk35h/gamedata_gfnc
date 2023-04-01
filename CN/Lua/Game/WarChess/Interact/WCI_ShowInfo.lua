-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_ShowInfo = class("WCI_ShowInfo", base)
WCI_ShowInfo.ctor = function(self)
  -- function num : 0_0
  self.needWalk = false
end

WCI_ShowInfo.WCActPlay = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  local interactentityData = (self.interactCtrl):GetCurInteractData()
  if interactentityData == nil then
    error("show info interactentityData not exist")
    ;
    (base.WCActOver)(self, false)
    return 
  end
  local isGrid = (self.interactCtrl):GetCurIsGrid()
  local isMonster = false
  if not isGrid then
    isMonster = interactentityData:GetEntityIsMonster()
  end
  if isMonster then
    ((self.wcCtrl).mapCtrl):TryShowWCMonsterCouldMoveRange(true, interactentityData)
    local battleRoomID = interactentityData:GetBattleRoomID()
    do
      local worldPos = (self.interactCtrl):GetCurInteractPos()
      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessMonsterDetail, function(win)
    -- function num : 0_1_0 , upvalues : battleRoomID, worldPos, self
    if win == nil then
      return 
    end
    win:InitWCIntro(battleRoomID, worldPos, function()
      -- function num : 0_1_0_0 , upvalues : self
      ((self.wcCtrl).mapCtrl):TryShowWCMonsterCouldMoveRange(false)
    end
)
  end
)
    end
  else
    do
      local pms = (self.interactCtrl):GetCurInteractPMS()
      if pms == nil or pms[1] == nil then
        error("show info desId not exist")
        ;
        (base.WCActOver)(self, false)
        return 
      end
      local desId = pms[1]
      do
        local worldPos = (self.interactCtrl):GetCurInteractPos()
        UIManager:ShowWindowAsync(UIWindowTypeID.WarChessObjDetail, function(win)
    -- function num : 0_1_1 , upvalues : desId, worldPos
    if win == nil then
      return 
    end
    win:InitWCIntro(desId, worldPos, function()
      -- function num : 0_1_1_0
    end
)
  end
)
        ;
        (base.WCActOver)(self, true)
      end
    end
  end
end

WCI_ShowInfo.PlayWCActOverAudio = function(self)
  -- function num : 0_2 , upvalues : _ENV
  AudioManager:PlayAudioById(1234)
end

return WCI_ShowInfo

