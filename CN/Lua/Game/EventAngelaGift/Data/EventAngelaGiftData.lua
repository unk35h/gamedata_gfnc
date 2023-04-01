-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActivityBase")
local EventAngelaGiftData = class("EventAngelaGiftData", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).EventAngelaGift
local redDotType = {redDotLooked = 1}
EventAngelaGiftData.InitAngelaGiftData = function(self, actId)
  -- function num : 0_0 , upvalues : CurActType, _ENV
  self:SetActFrameDataByType(CurActType, actId)
  self._mainCfg = (ConfigData.activity_angela_main)[actId]
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  local groupGiftInfos = {}
  for _,giftId in ipairs((self._mainCfg).group_id) do
    local giftInfo = payGiftCtrl:GetPayGiftDataById(giftId)
    if giftInfo == nil then
      error("find angelaGiftInfo Fail! giftId = " .. tostring(giftId))
    end
    ;
    (table.insert)(groupGiftInfos, giftInfo)
  end
  self.groupGiftInfos = groupGiftInfos
  do
    if self:GetIsAngelaGiftDataOver() then
      local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
      activityCtrl:HideActivityByExtraLogic(CurActType, self:GetActId())
    end
    self:__UpdateAngelaGift()
  end
end

EventAngelaGiftData.__UpdateAngelaGift = function(self)
  -- function num : 0_1
  self:RefreshAngelaGiftLooked()
end

EventAngelaGiftData.RefreshAngelaGiftLooked = function(self)
  -- function num : 0_2 , upvalues : redDotType, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local newQARed = actRed:AddChild(redDotType.redDotLooked)
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  if not saveUserData:GetAngelaGiftLooked(self:GetActId()) then
    newQARed:SetRedDotCount(1)
    return 
  end
  newQARed:SetRedDotCount(0)
end

EventAngelaGiftData.SetAngelaGiftDataLooked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetAngelaGiftLooked(self:GetActId())
  self:__UpdateAngelaGift()
end

EventAngelaGiftData.GetAngelaGiftDataCanPop = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local isInTime = (CheckCondition.CheckLua)((self._mainCfg).pre_condition2, (self._mainCfg).pre_para3, (self._mainCfg).pre_para4)
  if not isInTime then
    return false
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  return saveUserData:GetAngelaGiftCanPop(self:GetActId())
end

EventAngelaGiftData.SetAngelaGiftDataCantPopToday = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local time = TimeUtil:TimestampToDate((math.floor)(TimeUtil:TimpApplyLogicOffset(PlayerDataCenter.timestamp)))
  time.hour = 0
  time.min = 0
  time.sec = 0
  local cantShowTime = TimeUtil:DateToTimestamp(time) + 86400 + 3600 * TimeUtil:GetDayPassTime()
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetAngelaGiftCantShowTime(self:GetActId(), cantShowTime)
  self:__UpdateAngelaGift()
end

EventAngelaGiftData.GetAngelaGiftMainCfg = function(self)
  -- function num : 0_6
  return self._mainCfg
end

EventAngelaGiftData.GetGroupGiftCurrentStep = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for step,giftInfo in ipairs(self.groupGiftInfos) do
    if not giftInfo:IsSoldOut() then
      return step
    end
  end
  return #self.groupGiftInfos + 1
end

EventAngelaGiftData.GetIsAngelaGiftDataOver = function(self)
  -- function num : 0_8
  local isAllSoldOut = #self.groupGiftInfos < self:GetGroupGiftCurrentStep()
  if isAllSoldOut then
    return true
  end
  do return false end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

return EventAngelaGiftData

