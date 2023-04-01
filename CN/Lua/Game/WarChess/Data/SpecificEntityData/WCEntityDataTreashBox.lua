-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Data.WarChessEntityData")
local WCEntityDataTreashBox = class("WCEntityDataTreashBox", base)
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local OPEN_TREASURE_BOX_WAIT_TIME = 1
WCEntityDataTreashBox.PlayEntityAnimation = function(self, animaId, trigger, callback)
  -- function num : 0_0 , upvalues : _ENV, eWarChessEnum, OPEN_TREASURE_BOX_WAIT_TIME
  if animaId == -1 then
    (self.__entity):PlayWCEntityDownTween(0.75, 0.25)
  else
    ;
    (self.__entity):PlayWCEntityAnimation(animaId, trigger)
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    do
      if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
        (wcCtrl.curState):SetIsWaitingEntityAnimation(true)
        self.__treashBoxTimerId = TimerManager:StartTimer(OPEN_TREASURE_BOX_WAIT_TIME, function()
    -- function num : 0_0_0 , upvalues : wcCtrl, self
    (wcCtrl.curState):SetIsWaitingEntityAnimation(false)
    wcCtrl:RunAllSystemChange()
    self.__treashBoxTimerId = nil
  end
, self, true)
      end
    end
  end
  do
    if callback ~= nil then
      callback()
    end
  end
end

WCEntityDataTreashBox.CleanTimerAndTween = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  if self.__treashBoxTimerId ~= nil then
    TimerManager:StopTimer(self.__treashBoxTimerId)
    self.__treashBoxTimerId = nil
  end
  ;
  (base.CleanTimerAndTween)(self)
end

return WCEntityDataTreashBox

