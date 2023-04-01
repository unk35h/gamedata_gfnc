-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityComebackData = class("ActivityComebackData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local emptyString = ""
local ActivityComebackWindowIdDic = {[1] = UIWindowTypeID.ActivityComeback, [2] = UIWindowTypeID.ActivityComebackLite}
local ActivityComebackEntryTextIdDic = {[1] = TipContent.ComebackEntryText, [2] = TipContent.ComebackLiteEntryText}
ActivityComebackData.InitActivityComeback = function(self, msg)
  -- function num : 0_0 , upvalues : _ENV
  self._id = msg.actId
  self._avgId = msg.avgId
  self._comebackCfg = (ConfigData.activity_user_return)[self._id]
  self:UpdateActFrameDataSingleMsg(msg)
end

ActivityComebackData.GetComebackId = function(self)
  -- function num : 0_1
  return self._id
end

ActivityComebackData.GetComebackAvgId = function(self)
  -- function num : 0_2
  return self._avgId
end

ActivityComebackData.GetComebackCfg = function(self)
  -- function num : 0_3
  return self._comebackCfg
end

ActivityComebackData.GetComebackWindowId = function(self)
  -- function num : 0_4 , upvalues : ActivityComebackWindowIdDic, _ENV
  local dataActId = self:GetActId() or 0
  if ActivityComebackWindowIdDic[dataActId] ~= nil then
    return ActivityComebackWindowIdDic[dataActId]
  else
    error("Dont Have WindowId, ComeBack ActId = " .. dataActId)
  end
end

ActivityComebackData.GetComebackEntryText = function(self)
  -- function num : 0_5 , upvalues : ActivityComebackEntryTextIdDic, _ENV, emptyString
  local dataActId = self:GetActId() or 0
  if ActivityComebackEntryTextIdDic[dataActId] ~= nil then
    return ConfigData:GetTipContent(ActivityComebackEntryTextIdDic[dataActId])
  else
    error("Dont Have EntryTextId, ComeBack ActId = " .. dataActId)
    return emptyString
  end
end

return ActivityComebackData

