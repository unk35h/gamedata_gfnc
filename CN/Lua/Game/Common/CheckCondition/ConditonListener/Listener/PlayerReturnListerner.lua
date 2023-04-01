-- params : ...
-- function num : 0 , upvalues : _ENV
local TimeRangeListerner = require("Game.Common.CheckCondition.ConditonListener.Listener.TimeRangeListerner")
local PlayerReturnListerner = class("PlayerReturnListerner", TimeRangeListerner)
local base = TimeRangeListerner
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.PlayerReturn
PlayerReturnListerner.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__latestTm = math.maxinteger
  self.__timerId = nil
end

PlayerReturnListerner.AddNewCondition = function(self, conditonDataDic)
  -- function num : 0_1 , upvalues : _ENV, base
  if (PlayerDataCenter.inforData):GetReturnTime() == 0 then
    return 
  end
  ;
  (base.AddNewCondition)(self, conditonDataDic)
end

PlayerReturnListerner.GetConversionTime = function(self, paramGoup)
  -- function num : 0_2 , upvalues : _ENV
  local returnTm = (PlayerDataCenter.inforData):GetReturnTime()
  if paramGoup[2] ~= -1 or not -1 then
    local startTm = paramGoup[2] + returnTm
  end
  if paramGoup[3] ~= -1 or not -1 then
    local endTm = paramGoup[3] + returnTm
  end
  return startTm, endTm
end

return PlayerReturnListerner

