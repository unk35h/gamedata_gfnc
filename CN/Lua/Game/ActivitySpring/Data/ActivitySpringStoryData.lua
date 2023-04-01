-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySpringStoryData = class("ActivitySpringStoryData")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local ActivitySpringStoryEnum = require("Game.ActivitySpring.Data.ActivitySpringStoryEnum")
ActivitySpringStoryData.InitSpringData = function(self, actId, interactList)
  -- function num : 0_0 , upvalues : _ENV
  self.actId = actId
  self._storyCfg = (ConfigData.activity_spring_interact)[actId]
  self.avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay, true)
  self.interactDic = {}
  for i,v in pairs(interactList) do
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R8 in 'UnsetPending'

    (self.interactDic)[v] = true
  end
end

ActivitySpringStoryData.FinishTalk = function(self, interactId, callback)
  -- function num : 0_1 , upvalues : _ENV, CommonRewardData, ActivitySpringStoryEnum
  (NetworkManager:GetNetwork(NetworkTypeID.ActivitySpring)):CS_ACTIVITY_Spring_Interact(self.actId, interactId, function(args)
    -- function num : 0_1_0 , upvalues : _ENV, self, interactId, CommonRewardData, ActivitySpringStoryEnum, callback
    if not args then
      return 
    end
    local msg = args[0]
    local rewardIds = {}
    local rewardNums = {}
    for id,num in pairs(msg.rewards) do
      (table.insert)(rewardIds, id)
      ;
      (table.insert)(rewardNums, num)
    end
    local cfg = (self._storyCfg)[interactId]
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_1_0_0 , upvalues : CommonRewardData, rewardIds, rewardNums, cfg, ActivitySpringStoryEnum, _ENV, callback
      if window == nil then
        return 
      end
      local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRShowOverFunc(function()
        -- function num : 0_1_0_0_0 , upvalues : cfg, ActivitySpringStoryEnum, _ENV, callback
        if cfg.stage_id == (ActivitySpringStoryEnum.stageEnum).main or cfg.stage_id == (ActivitySpringStoryEnum.stageEnum).side then
          local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
          avgCtrl:StartAvg(nil, cfg.story, callback)
        else
          do
            if callback then
              callback()
            end
          end
        end
      end
)
      window:AddAndTryShowReward(CRData)
    end
)
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R5 in 'UnsetPending'

    if cfg.stage_id ~= (ActivitySpringStoryEnum.stageEnum).ranReward then
      (self.interactDic)[interactId] = true
    end
    local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
    if springCtrl then
      (springCtrl:GetSpringData(self.actId)):RefreshRedTalk()
    end
  end
)
end

ActivitySpringStoryData.CostIsEnough = function(self, num, interactId)
  -- function num : 0_2
  local cfg = (self._storyCfg)[interactId]
  do return cfg.need_exp <= num end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySpringStoryData.IsLongTail = function(self, interactId)
  -- function num : 0_3 , upvalues : ActivitySpringStoryEnum
  local cfg = (self._storyCfg)[interactId]
  do return cfg.stage_id == (ActivitySpringStoryEnum.stageEnum).fixReward or cfg.stage_id == (ActivitySpringStoryEnum.stageEnum).ranReward end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySpringStoryData.IsSpringMaininteracterComplete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._tempMaininteracterComplete then
    return true
  end
  local cfgList = self:GetSpringStoryMain()
  for k,cfg in pairs(cfgList) do
    if not (self.interactDic)[cfg.id] then
      return false
    end
  end
  self._tempMaininteracterComplete = true
  return true
end

ActivitySpringStoryData.CheckHaveTalk = function(self, costNum)
  -- function num : 0_5 , upvalues : _ENV, ActivitySpringStoryEnum
  for heroId,heroHave in pairs(((ConfigData.activity_spring_interact).heroActDic)[self.actId]) do
    local interactCfg, cantTalk = self:GetNowCfgByHeroId(heroId)
    if not cantTalk and interactCfg.stage_id ~= (ActivitySpringStoryEnum.stageEnum).ranReward and self:CostIsEnough(costNum, interactCfg.id) then
      return true
    end
  end
  return false
end

ActivitySpringStoryData.GetNeedExp = function(self, interactId)
  -- function num : 0_6
  local cfg = (self._storyCfg)[interactId]
  return cfg.need_exp
end

ActivitySpringStoryData._CalInteractState = function(self, id, main)
  -- function num : 0_7 , upvalues : _ENV
  local cfg = (self._storyCfg)[id]
  if (self._preFinishDic)[id] ~= nil and not main then
    return 
  end
  for i,v in pairs(cfg.pre_interact) do
    self:_CalInteractState(v)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R9 in 'UnsetPending'

    if not (self._preFinishDic)[v] then
      (self._preFinishDic)[id] = false
      return false
    end
  end
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

  if cfg.stageId == 4 then
    (self._preFinishDic)[id] = false
    return true
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R4 in 'UnsetPending'

  if (self.interactDic)[id] then
    (self._preFinishDic)[id] = true
    return false
  else
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._preFinishDic)[id] = false
    return true
  end
end

ActivitySpringStoryData.GetThisPhaseStateAndCfg = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local stateDic = {}
  local cfgDic = {}
  self._preFinishDic = {}
  for i,v in pairs(self._storyCfg) do
    local canTalk = self:_CalInteractState(i, true)
    if canTalk then
      stateDic[i] = true
      cfgDic[i] = v
    end
  end
  return stateDic, cfgDic
end

ActivitySpringStoryData.GetNowCfgByHeroId = function(self, heroId)
  -- function num : 0_9 , upvalues : _ENV
  local stateDic = {}
  local cfg = nil
  self._preFinishDic = {}
  local cantTalkCfg = nil
  local cantTalkId = 9999
  local cantTalk = false
  for i,v in pairs(self._storyCfg) do
    if v.interact_character == heroId then
      local canTalk = self:_CalInteractState(i, true)
      if canTalk then
        return v, false
      else
        if i < cantTalkId and not self:GetThisTalkStateById(i) then
          cantTalkCfg = v
          cantTalk = true
          cantTalkId = i
        end
      end
    end
  end
  return cantTalkCfg, cantTalk
end

ActivitySpringStoryData.GetThisTalkStateById = function(self, id)
  -- function num : 0_10
  return (self.interactDic)[id]
end

ActivitySpringStoryData.GetSpringStoryMain = function(self)
  -- function num : 0_11 , upvalues : _ENV, ActivitySpringStoryEnum
  if self._tempMainStepDic ~= nil then
    return self._tempMainStepDic
  end
  self._tempMainStepDic = {}
  for k,v in pairs(self._storyCfg) do
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

    if v.stage_id == (ActivitySpringStoryEnum.stageEnum).main then
      (self._tempMainStepDic)[v.id] = v
    end
  end
  return self._tempMainStepDic
end

ActivitySpringStoryData.GetSpringStoryActId = function(self)
  -- function num : 0_12
  return self.actId
end

ActivitySpringStoryData.GetSpringStoryInteractCfg = function(self)
  -- function num : 0_13
  return self._storyCfg
end

return ActivitySpringStoryData

