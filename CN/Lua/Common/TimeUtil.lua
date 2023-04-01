-- params : ...
-- function num : 0 , upvalues : _ENV
local TimeUtil = {}
TimeUtil.GetDayPassTime = function(self)
  -- function num : 0_0 , upvalues : _ENV
  if self.dayPassTime == nil then
    local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleDailyBouns, 0)
    if counterElem or not 5 then
      do
        self.dayPassTime = (self:TimestampToDate(counterElem.nextExpiredTm)).hour
        return self.dayPassTime
      end
    end
  end
end

TimeUtil.GetLocalTimeZone = function(self)
  -- function num : 0_1 , upvalues : _ENV
  do
    if self.localTimeZone == nil then
      local now = (os.time)()
      self.localTimeZone = (os.difftime)(now, (os.time)((os.date)("!*t", now))) / 3600
    end
    return self.localTimeZone
  end
end

TimeUtil.CompareIsCorssDay = function(self, time1, time2)
  -- function num : 0_2 , upvalues : _ENV, TimeUtil
  if CommonUtil.DaySeconds <= (math.abs)(time1 - time2) then
    return true
  end
  local timeBig, timeSmall = nil, nil
  if time2 < time1 then
    timeBig = time1
    timeSmall = time2
  else
    timeBig = time2
    timeSmall = time1
  end
  local hourTime = TimeUtil:GetDayPassTime() * 3600
  local dateBig = TimeUtil:TimestampToDate(timeBig - hourTime, false, false)
  local dateSmall = TimeUtil:TimestampToDate(timeSmall - hourTime, false, false)
  if dateBig.day ~= dateSmall.day then
    return true
  end
  return false
end

TimeUtil.TimestampToTime = function(self, t, isMillisecond, isNotNeedS, isForceNeedH)
  -- function num : 0_3 , upvalues : _ENV
  if isMillisecond then
    t = t // 1000
  end
  local s = (math.floor)(t % 60)
  local m = (math.floor)(t / 60 % 60)
  local h = (math.floor)(t / 3600)
  local content = ""
  if h > 0 or isForceNeedH then
    if isNotNeedS then
      content = (string.format)("%02d:%02d", h, m)
    else
      content = (string.format)("%02d:%02d:%02d", h, m, s)
    end
  else
    if isNotNeedS then
      content = (string.format)("%02d:%02d", 0, m)
    else
      content = (string.format)("%02d:%02d", m, s)
    end
  end
  return content
end

TimeUtil.TimestampToTimeInter = function(self, t, isMillisecond, calculateDay)
  -- function num : 0_4 , upvalues : _ENV
  if isMillisecond then
    t = t // 1000
  end
  local s = (math.floor)(t % 60)
  local m = (math.floor)(t / 60 % 60)
  local h = (math.floor)(t / 3600)
  local d = 0
  if calculateDay then
    d = h // 24
    h = (math.floor)(h % 24)
  end
  return d, h, m, s
end

TimeUtil.TimestampToDate = function(self, t, isMillisecond, isUsingLocalTimeZone)
  -- function num : 0_5 , upvalues : _ENV
  if t < 0 then
    error("timestamp error")
    return (os.date)("*t", 0)
  end
  if isMillisecond then
    t = t // 1000
  end
  local dataTable = nil
  if isUsingLocalTimeZone then
    dataTable = (os.date)("*t", t)
  else
    dataTable = (os.date)("!*t", t + PlayerDataCenter.timezone_offset * 3600)
  end
  return dataTable
end

TimeUtil.TimestampToDateString = function(self, t, isMillisecond, isUsingLocalTimeZone, formatString)
  -- function num : 0_6 , upvalues : _ENV
  if isMillisecond then
    t = t // 1000
  end
  if not formatString then
    formatString = "%m/%d %H:%M"
  end
  local dateString = nil
  if isUsingLocalTimeZone then
    dateString = (os.date)(formatString, t)
  else
    dateString = (os.date)(formatString, tonumber(t) + PlayerDataCenter.timezone_offset * 3600)
  end
  return dateString
end

TimeUtil.DateToTimestamp = function(self, dataTable, isUsingLocalTimeZone)
  -- function num : 0_7 , upvalues : _ENV
  local ts = 0
  if isUsingLocalTimeZone then
    ts = (os.time)(dataTable)
  else
    ts = (os.time)(dataTable) - (PlayerDataCenter.timezone_offset - self:GetLocalTimeZone()) * 3600
  end
  return ts
end

TimeUtil.TimpApplyLogicOffset = function(self, t)
  -- function num : 0_8
  t = t - 3600 * self:GetDayPassTime()
  return t
end

TimeUtil.TimeStringToTimeStamp = function(self, dateStr, isUsingLocalTimeZone)
  -- function num : 0_9 , upvalues : _ENV
  local _, _, y, m, d, _hour, _min, _sec = (string.find)(dateStr, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)")
  local timestamp = nil
  if isUsingLocalTimeZone then
    timestamp = (os.time)({year = y, month = m, day = d, hour = _hour, min = _min, sec = _sec})
  else
    timestamp = (os.time)({year = y, month = m, day = d, hour = _hour, min = _min, sec = _sec, isdst = false}) - (PlayerDataCenter.timezone_offset - self:GetLocalTimeZone()) * 3600
  end
  return timestamp
end

return TimeUtil

