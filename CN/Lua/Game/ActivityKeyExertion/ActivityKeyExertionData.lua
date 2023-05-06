-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityKeyExertionData = class("ActivityKeyExertionData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).KeyExertion
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local redDotType = {redDotPackage = 1, redDotTask = 2}
ActivityKeyExertionData.InitKeyExertionData = function(self, actId)
  -- function num : 0_0 , upvalues : CurActType, _ENV
  self:SetActFrameDataByType(CurActType, actId)
  self._mainCfg = (ConfigData.activity_keyExertion_main)[actId]
  self._token = (self._mainCfg).token
  self._progressBar = (self._mainCfg).progress_bar
  self._net = NetworkManager:GetNetwork(NetworkTypeID.ActivityKeyExertion)
  self._taskIdDic = {}
  self._mainColor = (ColorUtil.FromHexUnit)((self._mainCfg).color)
  for _,taskId in pairs((self._mainCfg).task) do
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R7 in 'UnsetPending'

    (self._taskIdDic)[taskId] = true
  end
  self:__UpdateKeyExertion()
end

ActivityKeyExertionData.__UpdateKeyExertion = function(self)
  -- function num : 0_1
  self:RefreshKeyExertionRedPackage()
  self:RefreshKeyExertionRedTask()
end

ActivityKeyExertionData.RefreshKeyExertionRedPackage = function(self)
  -- function num : 0_2 , upvalues : redDotType
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local expRed = actRed:AddChild(redDotType.redDotPackage)
  expRed:SetRedDotCount(self:CanKeyExertionOpenPackage() and 1 or 0)
end

ActivityKeyExertionData.RefreshKeyExertionRedTask = function(self)
  -- function num : 0_3 , upvalues : redDotType, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local taskRed = actRed:AddChild(redDotType.redDotTask)
  if self:IsActivityRunning() then
    for taskId,_ in pairs(self._taskIdDic) do
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
      if taskData ~= nil and taskData:CheckComplete() then
        taskRed:SetRedDotCount(1)
        return 
      end
    end
  end
  do
    taskRed:SetRedDotCount(0)
  end
end

ActivityKeyExertionData.CanKeyExertionOpenPackage = function(self)
  -- function num : 0_4
  do return self._progressBar <= self:GetKeyExertionPackageFragmentNum() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityKeyExertionData.GetKeyExertionMainCfg = function(self)
  -- function num : 0_5
  return self._mainCfg
end

ActivityKeyExertionData.GetKeyExertionMainReward = function(self)
  -- function num : 0_6
  return (self._mainCfg).preprecess_main_rewardIds, (self._mainCfg).preprecess_main_rewardNums
end

ActivityKeyExertionData.GetKeyExertionAllReward = function(self)
  -- function num : 0_7
  return (self._mainCfg).preprecess_all_rewardIds, (self._mainCfg).preprecess_all_rewardNums
end

ActivityKeyExertionData.GetKeyExertionActivityDes = function(self)
  -- function num : 0_8 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self._mainCfg).activity_des)
end

ActivityKeyExertionData.GetKeyExertionMainDes = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self._mainCfg).main_des)
end

ActivityKeyExertionData.GetKeyExertionAllRewardDes = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self._mainCfg).rewards_des)
end

ActivityKeyExertionData.GetKeyExertionTokenId = function(self)
  -- function num : 0_11
  return self._token
end

ActivityKeyExertionData.GetKeyExertionPackageFragmentNum = function(self)
  -- function num : 0_12 , upvalues : _ENV
  return PlayerDataCenter:GetItemCount(self._token)
end

ActivityKeyExertionData.GetKeyExertionPackageFragmentMaxNum = function(self)
  -- function num : 0_13
  return (self._mainCfg).progress_bar
end

ActivityKeyExertionData.GetKeyExertionOpenedPackageNum = function(self)
  -- function num : 0_14
  return self:GetKeyExertionPackageFragmentNum() // self._progressBar
end

ActivityKeyExertionData.GetKeyExertionRedDotType = function(self)
  -- function num : 0_15 , upvalues : redDotType
  return redDotType
end

ActivityKeyExertionData.GetKeyExertionTaskIdDic = function(self)
  -- function num : 0_16
  return self._taskIdDic
end

ActivityKeyExertionData.GetKeyExertionCurrentTaskId = function(self)
  -- function num : 0_17
  return ((self._mainCfg).task)[1]
end

ActivityKeyExertionData.GetBigRewardId = function(self)
  -- function num : 0_18
  return (self._mainCfg).big_reward
end

ActivityKeyExertionData.GetIsBigRewardAllPicked = function(self)
  -- function num : 0_19
  do return (self._mainCfg).reward_times <= self.bigRewardPickedCount or 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityKeyExertionData.GetKeyExertionMainColor = function(self)
  -- function num : 0_20
  return self._mainColor
end

ActivityKeyExertionData.SetBigRewardPickedCount = function(self, count)
  -- function num : 0_21
  self.bigRewardPickedCount = count
end

return ActivityKeyExertionData

