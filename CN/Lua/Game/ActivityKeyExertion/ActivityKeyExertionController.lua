-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityKeyExertionController = class("ActivityKeyExertionController", ControllerBase)
local base = ControllerBase
local ActivityKeyExertionData = require("Game.ActivityKeyExertion.ActivityKeyExertionData")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
ActivityKeyExertionController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  self._dataDic = {}
  ConfigData:LoadDynCfg(eDynConfigData.activity_keyExertion_main)
  self.__TaskChangeCallback = BindCallback(self, self.__TaskProcessUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self._net = NetworkManager:GetNetwork(NetworkTypeID.ActivityKeyExertion)
end

ActivityKeyExertionController.InitKeyExertion = function(self, actFrameData)
  -- function num : 0_1 , upvalues : ActivityKeyExertionData
  if (self._dataDic)[actFrameData:GetActId()] ~= nil then
    return 
  end
  local data = (ActivityKeyExertionData.New)()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[actFrameData:GetActId()] = data
  data:InitKeyExertionData(actFrameData:GetActId())
  data:SetBigRewardPickedCount(actFrameData.bigReward)
end

ActivityKeyExertionController.OpenKeyExertion = function(self, actId, callback)
  -- function num : 0_2 , upvalues : _ENV
  local data = (self._dataDic)[actId]
  if data ~= nil then
    UIManager:ShowWindowAsync(UIWindowTypeID.ActivityKeyExertion, function(window)
    -- function num : 0_2_0 , upvalues : data, callback
    if window == nil then
      return 
    end
    window:InitKeyExertionMain(data)
    if callback ~= nil then
      callback(window)
    end
  end
)
  end
end

ActivityKeyExertionController.GetKeyExertionData = function(self, id)
  -- function num : 0_3
  return (self._dataDic)[id]
end

ActivityKeyExertionController.GetTheLatestKeyExertionData = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local res = nil
  for k,v in pairs(self._dataDic) do
    if res == nil then
      res = v
    else
      if res:GetActivityBornTime() < v:GetActivityBornTime() then
        res = v
      end
    end
  end
  return res
end

ActivityKeyExertionController.ReqKeyExertionOpenPackage = function(self, actId, callback)
  -- function num : 0_5
  (self._net):CS_ACTIVITY_KeyExertion_PickAllReward(actId, callback)
end

ActivityKeyExertionController.ReqKeyExertionCommitTask = function(self, actId, taskId, callback)
  -- function num : 0_6 , upvalues : _ENV, CommonRewardData
  local data = (self._dataDic)[actId]
  if data == nil or not data:IsActivityRunning() then
    return 
  end
  local dataTaskDic = data:GetKeyExertionTaskIdDic()
  if dataTaskDic == nil or dataTaskDic[taskId] == nil then
    return 
  end
  local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, callback)
  if taskData == nil or not taskData:CheckComplete() then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  network:CS_Activity_Quest_Commit((data.actInfo).id, taskId, function()
    -- function num : 0_6_0 , upvalues : dataTaskDic, taskId, data, taskData, CommonRewardData, _ENV, callback
    dataTaskDic[taskId] = nil
    data:RefreshKeyExertionRedTask()
    local rewards, nums = taskData:GetTaskCfgRewards()
    local CRData = (CommonRewardData.CreateCRDataUseList)(rewards, nums)
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_6_0_0 , upvalues : CRData
      if window == nil then
        return 
      end
      window:AddAndTryShowReward(CRData)
    end
)
    data:RefreshKeyExertionRedTask()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityKeyExertionController.__TaskProcessUpdate = function(self, taskData)
  -- function num : 0_7 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  for _,data in pairs(self._dataDic) do
    local taskIdDic = data:GetKeyExertionTaskIdDic()
    if taskIdDic ~= nil and taskIdDic[taskData.id] ~= nil then
      data:RefreshKeyExertionRedTask()
    end
  end
end

ActivityKeyExertionController.UpdateAllKeyExertionData = function(self, msg)
  -- function num : 0_8 , upvalues : _ENV
  for _,msgData in pairs(msg) do
    local diffData = (self._dataDic)[msgData.actId]
    if diffData ~= nil then
      diffData:SetBigRewardPickedCount(msgData.bigReward)
    end
  end
  local uiKeyExertionMain = UIManager:GetWindow(UIWindowTypeID.ActivityKeyExertion)
  if uiKeyExertionMain ~= nil then
    uiKeyExertionMain:RefreshKeyExertionRewards()
    uiKeyExertionMain:UpdateLogicPreviewNode()
  end
end

ActivityKeyExertionController.__ItemUpdate = function(self, itemDic)
  -- function num : 0_9 , upvalues : _ENV
  for _,data in pairs(self._dataDic) do
    if itemDic[data:GetKeyExertionTokenId()] ~= nil then
      data:RefreshKeyExertionRedPackage()
      MsgCenter:Broadcast(eMsgEventId.ActivityKeyExertionTokenNumChange, data:GetKeyExertionTokenId())
    end
  end
end

ActivityKeyExertionController.RemoveKeyExertion = function(self, id)
  -- function num : 0_10
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[id] = nil
end

ActivityKeyExertionController.IsHaveKeyExertion = function(self)
  -- function num : 0_11 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityKeyExertionController.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_keyExertion_main)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
end

return ActivityKeyExertionController

