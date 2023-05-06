-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessTurnCtrl = class("WarChessTurnCtrl", base)
WarChessTurnCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.turnNum = 1
  self.stressLevel = 0
  self.stressPoint = 0
  self.rewindTotalTime = 0
  self.rewindLeftTime = 0
end

WarChessTurnCtrl.InitWCTurnCtrl = function(self, pressurePoint, round)
  -- function num : 0_1 , upvalues : _ENV
  self.turnNum = round.roundId
  self.stressLevel = pressurePoint.level
  self.stressPoint = pressurePoint.point
  self.wcStressCfg = WarChessManager:GetWCLevelStressCfg()
  if self.wcStressCfg == nil then
    error("can\'t get warchess_stress with id:" .. tostring(stressId))
  end
end

WarChessTurnCtrl.SetWCRewindTimes = function(self, totalTime, leftTime)
  -- function num : 0_2
  self.rewindTotalTime = totalTime
  self.rewindLeftTime = leftTime
end

WarChessTurnCtrl.GetWCRewindTimes = function(self)
  -- function num : 0_3
  return self.rewindTotalTime, self.rewindLeftTime
end

WarChessTurnCtrl.GetWCTurnNum = function(self)
  -- function num : 0_4
  return self.turnNum
end

WarChessTurnCtrl.GetWCStressCfgs = function(self)
  -- function num : 0_5
  return self.wcStressCfg
end

WarChessTurnCtrl.GetWCStressLevelAndPoint = function(self)
  -- function num : 0_6
  return self.stressLevel, self.stressPoint
end

WarChessTurnCtrl.SendTurnOver = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local wid = (self.wcCtrl):GetWCId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_RoundStartSingle(wid, function(argList)
    -- function num : 0_7_0 , upvalues : _ENV, self
    if argList.Count < 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    if isSucess then
      local roundNum = argList[1]
      self.turnNum = roundNum
      ;
      ((self.wcCtrl).mapCtrl):CleanCacheMonsterPower()
      MsgCenter:Broadcast(eMsgEventId.WC_TurnStart, self.turnNum)
      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessNotice, function(window)
      -- function num : 0_7_0_0
      if window ~= nil then
        window:OnWCTurnOver()
      end
    end
)
    end
  end
)
end

WarChessTurnCtrl.WCStressUpdata = function(self, pressurePointDiff)
  -- function num : 0_8 , upvalues : _ENV
  local lastStressLevel = self.stressLevel
  self.stressLevel = pressurePointDiff.level
  self.stressPoint = pressurePointDiff.point
  MsgCenter:Broadcast(eMsgEventId.WC_StressPointChange, self.stressLevel, self.stressPoint)
  if lastStressLevel ~= self.stressLevel then
    for level = lastStressLevel + 1, self.stressLevel do
      local stressCfg = (self.wcStressCfg)[level]
      do
        UIManager:ShowWindowAsync(UIWindowTypeID.WarChessNotice, function(window)
    -- function num : 0_8_0 , upvalues : stressCfg
    if window ~= nil then
      window:OnWCStressUpgrade(stressCfg)
    end
  end
)
      end
    end
  end
end

WarChessTurnCtrl.GetWCStressNum = function(self)
  -- function num : 0_9
  return self.stressLevel, self.stressPoint
end

return WarChessTurnCtrl

