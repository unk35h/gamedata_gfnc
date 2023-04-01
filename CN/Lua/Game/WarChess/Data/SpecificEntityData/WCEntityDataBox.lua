-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Data.WarChessEntityData")
local WCEntityDataBox = class("WCEntityDataBox", base)
WCEntityDataBox.SetNewPos = function(self, x, y)
  -- function num : 0_0 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local oldLogPos = self.worldLogicPos
  self.worldLogicPos = (Vector2.New)(x, y)
  self.pos = (Vector3.New)(x, 0, y)
  local needPlayAnimation = (Vector2.Distance)(self.worldLogicPos, oldLogPos) <= 1.1
  self.__isMoving = true
  ;
  (self.__entity):GetWCEntityMoverOverCallback(function()
    -- function num : 0_0_0 , upvalues : self, wcCtrl
    if self.__wait2Delete then
      (self.__entity):PlayWCEntityAnimation(-1)
    end
    self.__isMoving = false
    ;
    (wcCtrl.animaCtrl):RemoveWCAnimationWaitPlay("pushBox")
  end
)
  ;
  (self.__entity):WCEntitySetPos(self.pos, needPlayAnimation)
  local lastGridData = (wcCtrl.mapCtrl):GetGridDataByLogicPos(nil, oldLogPos)
  local curGridData = (wcCtrl.mapCtrl):GetGridDataByLogicPos(nil, self.worldLogicPos)
  if lastGridData ~= nil then
    MsgCenter:Broadcast(eMsgEventId.WC_GridInfoUpdate, lastGridData, true)
  end
  if curGridData ~= nil then
    MsgCenter:Broadcast(eMsgEventId.WC_GridInfoUpdate, curGridData, true)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

WCEntityDataBox.PlayEntityAnimation = function(self, animaId, trigger, callback)
  -- function num : 0_1 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if animaId == -1 then
    if not self.__isMoving then
      (self.__entity):PlayWCEntityAnimation(-1)
    else
      ;
      (wcCtrl.animaCtrl):AddWCAnimationWaitPlay("pushBox")
    end
    self.__wait2Delete = true
  else
    ;
    (self.__entity):PlayWCEntityAnimation(animaId, trigger)
    ;
    (wcCtrl.curState):SetIsWaitingEntityAnimation(true)
    self.__treashBoxTimerId = TimerManager:StartTimer(2, function()
    -- function num : 0_1_0 , upvalues : wcCtrl
    (wcCtrl.curState):SetIsWaitingEntityAnimation(false)
    wcCtrl:RunAllSystemChange()
  end
, self, true)
  end
  if callback ~= nil then
    callback()
  end
end

return WCEntityDataBox

