-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameData = class("ActivityFrameData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
ActivityFrameData.CreateActivityFrameData = function(activityElemMsg)
  -- function num : 0_0 , upvalues : ActivityFrameData
  local data = (ActivityFrameData.New)()
  data:__SetData(activityElemMsg)
  return data
end

ActivityFrameData.UpdateActivityFrameData = function(self, newData)
  -- function num : 0_1 , upvalues : _ENV
  if self.id ~= newData.id then
    error("activity id is diff C:" .. tostring(self.activityId) .. " S:" .. tostring(newData.id))
    return 
  end
  self:__SetData(newData)
end

ActivityFrameData.__SetData = function(self, dataMsg)
  -- function num : 0_2 , upvalues : ActivityFrameEnum, _ENV
  self.id = dataMsg.id
  self.actCat = dataMsg.actCat
  self.actId = dataMsg.actId
  self.lifeCat = dataMsg.lifeCat
  local diffTime = 0
  if self.lifeCat == (ActivityFrameEnum.eActivityLiftType).ServerTime then
    diffTime = PlayerDataCenter.serverTm
  else
    if self.lifeCat == (ActivityFrameEnum.eActivityLiftType).RoleTime then
      diffTime = PlayerDataCenter.createRelativeTm
    end
  end
  if (dataMsg.tm).bornTm == -1 or not (dataMsg.tm).bornTm + diffTime then
    self.bornTime = dataMsg.tm == nil or -1
    self.startTime = (dataMsg.tm).startTm ~= -1 and (dataMsg.tm).startTm + diffTime or -1
    self.endTime = (dataMsg.tm).endTm ~= -1 and (dataMsg.tm).endTm + diffTime or -1
    self.rewardStartTime = (dataMsg.tm).rewardStartTm ~= -1 and (dataMsg.tm).rewardStartTm + diffTime or -1
    self.rewardEndTime = (dataMsg.tm).rewardEndTm ~= -1 and (dataMsg.tm).rewardEndTm + diffTime or -1
    self.destoryTime = (dataMsg.tm).destoryTm ~= -1 and (dataMsg.tm).destoryTm + diffTime or -1
    self.durationTm = (dataMsg.tm).durationTm
    self.bornTime = -1
    self.startTime = -1
    self.endTime = -1
    self.rewardStartTime = -1
    self.rewardEndTime = -1
    self.destoryTime = -1
    self.durationTm = -1
    if self.destoryTime ~= -1 and (self.endTime == -1 or self.destoryTime < self.endTime) then
      self.endTime = self.destoryTime
      error(" rewardTime or destoryTime ERROR")
    end
    self.conditionKey = {}
    self.condition = {}
    self.conditionPara1 = {}
    self.conditionPara2 = {}
    if dataMsg.cond ~= nil and (dataMsg.cond).data ~= nil then
      for _,data in ipairs((dataMsg.cond).data) do
        (table.insert)(self.condition, (data.data)[1])
        ;
        (table.insert)(self.conditionPara1, (data.data)[2] or 0)
        ;
        (table.insert)(self.conditionPara2, (data.data)[3] or 0)
        -- DECOMPILER ERROR at PC166: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.conditionKey)[(data.data)[1]] = true
      end
    end
    do
      self.enterType = (dataMsg.ct).enterType
      self.order = (dataMsg.ct).order
      self.previewTime = (dataMsg.ct).preview or 0
      self.isPreviewType = self.previewTime ~= 0 and self.previewTime < self.bornTime
      local nameCfg = (ConfigData.activity_name)[(dataMsg.ct).nameId]
      if nameCfg == nil or not (LanguageUtil.GetLocaleText)(nameCfg.name) then
        self.name = tostring((dataMsg.ct).nameId)
        self.icon = nameCfg ~= nil and nameCfg.icon or nil
        -- DECOMPILER ERROR: 5 unprocessed JMP targets
      end
    end
  end
end

ActivityFrameData.CreateActivityFrameDataFromFakeData = function(fakeData)
  -- function num : 0_3 , upvalues : ActivityFrameData, _ENV
  local data = (ActivityFrameData.New)()
  data.id = fakeData.id
  data.actCat = fakeData.actCat
  data.actId = fakeData.actId
  data.bornTime = -1
  data.startTime = -1
  data.endTime = -1
  data.rewardStartTime = -1
  data.rewardEndTime = -1
  data.destoryTime = -1
  data.durationTm = -1
  data.enterType = fakeData.enterType
  data.order = fakeData.order
  local nameCfg = (ConfigData.activity_name)[fakeData.id]
  data.name = (LanguageUtil.GetLocaleText)(nameCfg.name)
  data.icon = nameCfg.icon
  return data
end

ActivityFrameData.ctor = function(self)
  -- function num : 0_4 , upvalues : ActivityFrameEnum
  self._unlockTempActivityState = (ActivityFrameEnum.eActivityState).WaitState
  self._activityState = (ActivityFrameEnum.eActivityState).WaitState
end

ActivityFrameData.GetActivityFrameId = function(self)
  -- function num : 0_5
  return self.id
end

ActivityFrameData.GetActId = function(self)
  -- function num : 0_6
  return self.actId
end

ActivityFrameData.GetActivityFrameCat = function(self)
  -- function num : 0_7
  return self.actCat
end

ActivityFrameData.GetEnterType = function(self)
  -- function num : 0_8
  return self.enterType
end

ActivityFrameData.GetActivityFrameName = function(self)
  -- function num : 0_9
  return self.name
end

ActivityFrameData.GetActivityEndTime = function(self)
  -- function num : 0_10
  return self.endTime
end

ActivityFrameData.GetActivityRewardEndTime = function(self)
  -- function num : 0_11
  return self.rewardEndTime
end

ActivityFrameData.GetActivityRewardStartTime = function(self)
  -- function num : 0_12
  return self.rewardStartTime
end

ActivityFrameData.IsPreviewType = function(self)
  -- function num : 0_13
  return self.isPreviewType
end

ActivityFrameData.GetActivityBornTime = function(self)
  -- function num : 0_14
  return self.bornTime
end

ActivityFrameData.GetActivityDestroyTime = function(self)
  -- function num : 0_15
  return self.destoryTime
end

ActivityFrameData.GetActivityPreviewTime = function(self)
  -- function num : 0_16
  return self.previewTime
end

ActivityFrameData.GetLockTip = function(self)
  -- function num : 0_17 , upvalues : CheckerGlobalConfig, CheckerTypeId, _ENV
  if self._conditionDes ~= nil then
    return self._conditionDes
  end
  local timeTip = nil
  local checker = CheckerGlobalConfig[CheckerTypeId.TimeRange]
  if checker ~= nil and checker.Checker ~= nil then
    timeTip = ((checker.Checker).GetUnlockInfo)({CheckerTypeId.TimeRange, self.bornTime, self.destoryTime})
  end
  if self.condition == nil or #self.condition == 0 then
    self._conditionDes = timeTip
  else
    self._conditionDes = (CheckCondition.GetUnlockInfoLua)(self.condition, self.conditionPara1, self.conditionPara2)
    self._conditionDes = self._conditionDes .. "\n" .. timeTip
  end
  return self._conditionDes
end

ActivityFrameData.GetIsActivityUnlock = function(self)
  -- function num : 0_18
  do return self._unlockTempActivityState ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.IsActivityOpen = function(self)
  -- function num : 0_19 , upvalues : ActivityFrameEnum
  do return (ActivityFrameEnum.eActivityState).OpenState <= self._activityState and self._activityState < (ActivityFrameEnum.eActivityState).DestroyState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.GetIsActivityFinished = function(self)
  -- function num : 0_20 , upvalues : ActivityFrameEnum
  do return (ActivityFrameEnum.eActivityState).DestroyState <= self._activityState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.IsActivityRunningTimeout = function(self)
  -- function num : 0_21 , upvalues : ActivityFrameEnum
  do return (ActivityFrameEnum.eActivityState).OpenState < self._activityState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.GetCouldShowActivity = function(self)
  -- function num : 0_22 , upvalues : ActivityFrameEnum
  do return (ActivityFrameEnum.eActivityState).WaitState < self._activityState and self._activityState < (ActivityFrameEnum.eActivityState).DestroyState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.GetActivityFrameState = function(self)
  -- function num : 0_23
  return self._activityState
end

ActivityFrameData.IsInPreviewState = function(self)
  -- function num : 0_24 , upvalues : ActivityFrameEnum
  do return self._activityState == (ActivityFrameEnum.eActivityState).PreviewState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.IsInRuningState = function(self)
  -- function num : 0_25 , upvalues : ActivityFrameEnum
  do return self._activityState == (ActivityFrameEnum.eActivityState).OpenState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.CanPreviewNoExchange = function(self)
  -- function num : 0_26 , upvalues : ActivityFrameEnum
  do return (ActivityFrameEnum.eActivityState).WaitState < self._activityState and self._activityState < (ActivityFrameEnum.eActivityState).RewardState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.GetActivityReddotNode = function(self)
  -- function num : 0_27
  return self._reddot
end

ActivityFrameData.IsActivityReadOnLogin = function(self)
  -- function num : 0_28
  return self.__isReadOnLogin
end

ActivityFrameData.SetActivityAsReadOnLogin = function(self)
  -- function num : 0_29
  self.__isReadOnLogin = true
end

ActivityFrameData.GetIsActivityUnlockForFrameCtrl = function(self)
  -- function num : 0_30 , upvalues : _ENV
  if self._forceOpen then
    return true
  end
  if self.condition == nil or #self.condition == 0 then
    return true
  end
  return (CheckCondition.CheckLua)(self.condition, self.conditionPara1, self.conditionPara2)
end

ActivityFrameData.SetIsActivityUnlockForFrameCtrl = function(self)
  -- function num : 0_31
  self._activityState = self._unlockTempActivityState
  self._unlockTempActivityState = nil
end

ActivityFrameData.SetActivityStateForFrameCtrl = function(self, actState)
  -- function num : 0_32
  if self._unlockTempActivityState ~= nil then
    self._unlockTempActivityState = actState
  else
    self._activityState = actState
  end
end

ActivityFrameData.SetActivityReddotForFrameCtrl = function(self, reddotNode)
  -- function num : 0_33
  self._reddot = reddotNode
end

ActivityFrameData.IsHaveThisConditionForFrameCtrl = function(self, conditionId)
  -- function num : 0_34
  do return self.conditionKey ~= nil and (self.conditionKey)[conditionId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameData.SetForceOpenForFrameCtrl = function(self, flag)
  -- function num : 0_35
  self._forceOpen = flag
end

ActivityFrameData.SetActivityData = function(self, data)
  -- function num : 0_36
  self.__actBaseData = data
end

ActivityFrameData.GetActivityData = function(self)
  -- function num : 0_37
  return self.__actBaseData
end

ActivityFrameData.ResetFinishTmForFrameCtrl = function(self, startTm, endTm)
  -- function num : 0_38
  self.rewardEndTime = endTm
  self.endTime = endTm
  self.destoryTime = endTm
  self.bornTime = startTm
  self.startTime = startTm
  self.durationTm = -1
end

ActivityFrameData.GetDurationTmForFrameCtrl = function(self)
  -- function num : 0_39
  return self.durationTm
end

return ActivityFrameData

