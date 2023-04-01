-- params : ...
-- function num : 0 , upvalues : _ENV
local TimeRangeListerner = class("TimeRangeListerner")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.TimeRange
TimeRangeListerner.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__latestTm = math.maxinteger
  self.__timerId = nil
end

TimeRangeListerner.InitListener = function(self, onConditonChangeCallback, removeConditonFunc)
  -- function num : 0_1
  self.onConditonChangeCallback = onConditonChangeCallback
  self.removeConditonFunc = removeConditonFunc
end

TimeRangeListerner.AddNewCondition = function(self, conditonDataDic)
  -- function num : 0_2 , upvalues : _ENV
  self.__latestTm = math.maxinteger
  local curTimeStamp = PlayerDataCenter.timestamp
  for listenerId,conditonDataList in pairs(conditonDataDic) do
    for index = #conditonDataList, 1, -1 do
      local paramGoup = conditonDataList[index]
      local unlock = (((self.__checker).Checker).ParamsCheck)(paramGoup)
      local startTm, endTm = self:GetConversionTime(paramGoup)
      -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

      if not unlock and (startTm >= curTimeStamp or startTm < self.__latestTm) then
        self.__latestTm = startTm
      end
      if endTm >= 0 or endTm < self.__latestTm then
        self.__latestTm = endTm
      end
    end
  end
  self:StartCoditonJudge()
end

TimeRangeListerner.GetConversionTime = function(self, paramGoup)
  -- function num : 0_3
  return paramGoup[2], paramGoup[3]
end

TimeRangeListerner.StartCoditonJudge = function(self)
  -- function num : 0_4 , upvalues : _ENV, checkerTypeId
  self:StopCoditonJudge()
  if self.__latestTm ~= nil and self.__latestTm ~= math.maxinteger then
    self.__timerId = TimerManager:StartTimer(1, function()
    -- function num : 0_4_0 , upvalues : _ENV, self, checkerTypeId
    if self.__latestTm < PlayerDataCenter.timestamp then
      self:StopCoditonJudge()
      ;
      (self.onConditonChangeCallback)(checkerTypeId)
    end
  end
, self, false)
  end
end

TimeRangeListerner.StopCoditonJudge = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.__timerId ~= nil then
    TimerManager:StopTimer(self.__timerId)
    self.__timerId = nil
  end
end

TimeRangeListerner.CheckOutTimeCondition = function(self, conditonDataDic)
  -- function num : 0_6 , upvalues : _ENV, checkerTypeId
  local curTimeStamp = PlayerDataCenter.timestamp
  for listenerId,conditonDataList in pairs(conditonDataDic) do
    for index = #conditonDataList, 1, -1 do
      local paramGoup = conditonDataList[index]
      local unlock = (((self.__checker).Checker).ParamsCheck)(paramGoup)
      local startTm, endTm = self:GetConversionTime(paramGoup)
      -- DECOMPILER ERROR at PC27: Unhandled construct in 'MakeBoolean' P1

      if not unlock and startTm < curTimeStamp then
        (self.removeConditonFunc)(checkerTypeId, listenerId, index)
      end
      if endTm < 0 then
        (self.removeConditonFunc)(checkerTypeId, listenerId, index)
      end
    end
  end
end

TimeRangeListerner.Delete = function(self)
  -- function num : 0_7
  self:StopCoditonJudge()
end

return TimeRangeListerner

