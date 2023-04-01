-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessSeasonSettleHanlder = class("WarChessSeasonSettleHanlder")
local cs_MessageCommon = CS.MessageCommon
WarChessSeasonSettleHanlder.EnterWarchessLevel = function(self, isWin, settleMsg, WCResultFunc)
  -- function num : 0_0 , upvalues : _ENV, cs_MessageCommon
  local nextWarChessLobby = settleMsg.nextWarChessLobby
  local nextRooms = settleMsg.RoomData
  local seasonSettleData = settleMsg.seasonData
  local totalScore = seasonSettleData.totalScore
  ;
  (WarChessSeasonManager.__wcSeasonCtrl):WCSSetTotalScore(totalScore)
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  ;
  (wcCtrl.palySquCtrl):SetWCSGetRewardWhenSettle(seasonSettleData)
  ;
  (wcCtrl.palySquCtrl):SetWCSSelectLevel(nextWarChessLobby, nextRooms)
  local floor = (WarChessSeasonManager.__wcSeasonCtrl).warChessSeasonFloor
  local addtionData = WarChessSeasonManager:GetSeasonAddtionData()
  if addtionData and addtionData:IsSetSeasonCompleteFloor() and addtionData:GetSeasonCompleteFloor() == floor then
    (wcCtrl.palySquCtrl):SetCompleteFloorTipCallCoroutine(function()
    -- function num : 0_0_0 , upvalues : cs_MessageCommon, addtionData, wcCtrl, _ENV
    (cs_MessageCommon.ShowMessageBox)(addtionData:GetSeasonCompleteFloorTip(), function()
      -- function num : 0_0_0_0 , upvalues : wcCtrl
      (wcCtrl.palySquCtrl):ResumeFloorTipCallCoroutine()
    end
, function()
      -- function num : 0_0_0_1 , upvalues : _ENV
      WarChessManager:GiveUpWarchess()
    end
)
  end
, true)
  end
  ;
  (wcCtrl.palySquCtrl):WhenWCSLevelSettle()
end

WarChessSeasonSettleHanlder.EnterWarchessSeason = function(self, isWin, settleMsg, WCResultFunc)
  -- function num : 0_1 , upvalues : _ENV
  local addtionData = WarChessSeasonManager:GetSeasonAddtionData()
  local isFakeWin = false
  do
    if not isWin and addtionData ~= nil and addtionData:IsSetSeasonCompleteFloor() then
      local floor = (WarChessSeasonManager:GetWCSCtrl()):WCSGetFloor()
      isFakeWin = addtionData:GetSeasonCompleteFloor() < floor
    end
    local seasonId = WarChessSeasonManager:GetWCSSeasonId()
    WarChessSeasonManager:RefreshWCSPassedTowerData(seasonId)
    UIManager:ShowWindowAsync(UIWindowTypeID.WCDebuffResult, function(window)
    -- function num : 0_1_0 , upvalues : _ENV, settleMsg, isFakeWin, WCResultFunc
    if window ~= nil then
      local hightesScore = WarChessSeasonManager:GetWCHighesScore()
      window:InitWarchessSeasonResult(settleMsg.seasonData, hightesScore, isFakeWin, function()
      -- function num : 0_1_0_0 , upvalues : WCResultFunc, isFakeWin
      if WCResultFunc ~= nil then
        WCResultFunc(isFakeWin)
      end
    end
)
    end
  end
)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

return WarChessSeasonSettleHanlder

