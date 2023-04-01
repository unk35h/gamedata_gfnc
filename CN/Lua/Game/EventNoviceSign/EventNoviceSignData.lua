-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local EventNoviceSignData = class("EventNoviceSignData", ActivityBase)
local base = ActivityBase
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local TaskEnum = require("Game.Task.TaskEnum")
local eSignType = {Novice = 1, Festival = 2}
EventNoviceSignData.InitNoviceSignData = function(self, data)
  -- function num : 0_0 , upvalues : ActivityFrameEnum, _ENV
  self:SetActFrameDataByType((ActivityFrameEnum.eActivityType).SevenDayLogin, data.id)
  self.id = data.id
  self.cfg = (ConfigData.sign_activity)[self.id]
  self.awardCfg = (ConfigData.sign_activity_award)[self.id]
  self:UpdateNoviceSignData(data)
  self:UpdateActFrameDataSingleMsg(data)
end

EventNoviceSignData.UpdateNoviceSignData = function(self, data)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  self.times = data.times
  self.nextExpiredTm = data.nextExpiredTm
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actInfo = activityFrameCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).SevenDayLogin, self.id)
  local reddot = actInfo ~= nil and actInfo:GetActivityReddotNode() or nil
  if not self:IsAllowReceive() or not 1 then
    reddot:SetRedDotCount(reddot == nil or 0)
    if not (self.cfg).forbid_hide_after_completion and (table.count)(self.awardCfg) <= self.times then
      activityFrameCtrl:HideActivityByExtraLogic((ActivityFrameEnum.eActivityType).SevenDayLogin, self.id)
    end
  end
end

EventNoviceSignData.GetReceiveState = function(self, day)
  -- function num : 0_2 , upvalues : TaskEnum
  if day <= self.times then
    return (TaskEnum.eTaskState).Picked
  end
  if day == self.times + 1 and self:IsAllowReceive() then
    return (TaskEnum.eTaskState).Completed
  end
  return (TaskEnum.eTaskState).InProgress
end

EventNoviceSignData.GetEvtSignPickRewardBgColor = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local colorList = (self.cfg).BtnIsCompleted_Color
  if #colorList == 3 then
    return (Color.New)(colorList[1] / 255, colorList[2] / 255, colorList[3] / 255)
  end
  return nil
end

EventNoviceSignData.IsAllowReceive = function(self)
  -- function num : 0_4 , upvalues : _ENV
  do return self.nextExpiredTm < PlayerDataCenter.timestamp and self.times < (table.count)(self.awardCfg) end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EventNoviceSignData.GetEventSignTimes = function(self)
  -- function num : 0_5
  return self.times
end

EventNoviceSignData.SetPoped = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.popTime = PlayerDataCenter.timestamp
end

EventNoviceSignData.IsCanPop = function(self)
  -- function num : 0_7 , upvalues : _ENV, ActivityFrameEnum
  if self.cfg ~= nil and (self.cfg).forbid_popup then
    return false
  end
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  do
    if activityFrameCtrl ~= nil then
      local actData = activityFrameCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).SevenDayLogin, self.id)
      if actData == nil or not actData:GetCouldShowActivity() then
        return false
      end
    end
    if not self:IsAllowReceive() then
      return false
    end
    local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass)
    do
      if self.popTime ~= nil then
        local isTody = timePassCtrl:GetIsLogicToday(self.popTime)
        if PlayerDataCenter.timestamp < self.popTime or isTody then
          return false
        end
      end
      return true
    end
  end
end

EventNoviceSignData.GetSignRewardList = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local list = {}
  for k,v in pairs(self.awardCfg) do
    (table.insert)(list, v)
  end
  ;
  (table.sort)(list, function(a, b)
    -- function num : 0_8_0
    do return a.day < b.day end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  return list
end

EventNoviceSignData.GetSignCfg = function(self)
  -- function num : 0_9
  return self.cfg
end

EventNoviceSignData.IsFestivalSign = function(self)
  -- function num : 0_10 , upvalues : eSignType
  do return (self.cfg).sign_type == eSignType.Festival end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return EventNoviceSignData

