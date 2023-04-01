-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityOpenListerner = class("ActivityOpenListerner")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.ActivityOpen
ActivityOpenListerner.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__OnOutCondititonChangeCallback = BindCallback(self, self.__OnOutCondititonChange)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__OnOutCondititonChangeCallback)
end

ActivityOpenListerner.InitListener = function(self, onConditonChangeCallback, removeConditonFunc)
  -- function num : 0_1
  self.onConditonChangeCallback = onConditonChangeCallback
  self.removeConditonFunc = removeConditonFunc
end

ActivityOpenListerner.AddNewCondition = function(self, conditonDataDic)
  -- function num : 0_2 , upvalues : _ENV, checkerTypeId
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  for listenerId,conditonDataList in pairs(conditonDataDic) do
    for index = #conditonDataList, 1, -1 do
      local paramGoup = conditonDataList[index]
      local activityFrameId = paramGoup[2]
      local activityData = activityFrameCtrl:GetActivityFrameData(activityFrameId)
      if activityData == nil or activityData:GetIsActivityFinished() then
        (self.removeConditonFunc)(checkerTypeId, listenerId, index)
      end
    end
  end
end

ActivityOpenListerner.__OnOutCondititonChange = function(self)
  -- function num : 0_3 , upvalues : checkerTypeId
  if self.onConditonChangeCallback ~= nil then
    (self.onConditonChangeCallback)(checkerTypeId)
  end
end

ActivityOpenListerner.Delete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__OnOutCondititonChangeCallback)
end

return ActivityOpenListerner

