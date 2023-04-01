-- params : ...
-- function num : 0 , upvalues : _ENV
local AllWeeklyChallengeData = class("AllWeeklyChallengeData")
local WeeklyChallengeData = require("Game.WeeklyChallenge.WeeklyChallengeData")
AllWeeklyChallengeData.ctor = function(self)
  -- function num : 0_0
  self.dataDic = {}
  self.isOutOfData = true
  self.rewardDic = {}
  self.doublePickTm = nil
  self.rankTm = 0
  self.lastTm = nil
end

AllWeeklyChallengeData.UpdateByMsg = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV, WeeklyChallengeData
  self.dataDic = {}
  for id,weeklyChallengeElem in pairs(msg.elem) do
    if (self.dataDic)[id] ~= nil then
      ((self.dataDic)[id]):UpdateByMsg(weeklyChallengeElem, msg.wc)
    else
      local data = (WeeklyChallengeData.CreatrWCData)(id)
      data:UpdateByMsg(weeklyChallengeElem, msg.wc)
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.dataDic)[id] = data
    end
  end
  do
    if not ((msg.wc).current).rankTm then
      self.rankTm = msg.wc == nil or 0
      if not (msg.wc).reward then
        self.rewardDic = {}
        self.doublePickTm = ((msg.wc).current).doublePickTm
        self.lastTm = msg.lastEndTm
        self.isOutOfData = false
        if not (msg.wc).maxScore then
          self.maxScore = {}
          -- DECOMPILER ERROR at PC63: Confused about usage of register: R2 in 'UnsetPending'

          ;
          (self.maxScore).score1 = (self.maxScore).score1 or 0
          -- DECOMPILER ERROR at PC70: Confused about usage of register: R2 in 'UnsetPending'

          ;
          (self.maxScore).score2 = (self.maxScore).score2 or 0
        end
      end
    end
  end
end

AllWeeklyChallengeData.UpdateScoreInfo = function(self, dungeonId, score, rewardDic)
  -- function num : 0_2 , upvalues : _ENV
  local isHaveNot = true
  for k,v in pairs(self.dataDic) do
    if k == dungeonId then
      isHaveNot = false
      break
    end
  end
  do
    if isHaveNot then
      return 
    end
    if rewardDic ~= nil and (table.count)(rewardDic) > 0 then
      for k,v in pairs(rewardDic) do
        -- DECOMPILER ERROR at PC31: Confused about usage of register: R10 in 'UnsetPending'

        if (self.rewardDic)[k] == nil then
          (self.rewardDic)[k] = v
        else
          -- DECOMPILER ERROR at PC37: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (self.rewardDic)[k] = (self.rewardDic)[k] + v
        end
      end
    end
    do
      local WCData = self:GetWeeklyChallengeDataByDungeonId(dungeonId)
      if WCData ~= nil and PlayerDataCenter.timestamp < self.rankTm then
        WCData:RefreshCurrentMaxScore(score)
      end
    end
  end
end

AllWeeklyChallengeData.GetWeeklyChallengeDataByDungeonId = function(self, dungeonId)
  -- function num : 0_3
  return (self.dataDic)[dungeonId]
end

AllWeeklyChallengeData.GetWeeklyChallengeReward = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local rewardMax = (ConfigData.game_config).weeklyRewardMax
  local counterElem = self:GetCounterElem()
  local isFinish = counterElem == nil or counterElem.nextExpiredTm < PlayerDataCenter.timestamp
  do return isFinish, (self.rewardDic)[1] or 0, rewardMax[1] or 0, (self.rewardDic)[2] or 0, rewardMax[2] or 0 end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

AllWeeklyChallengeData.GetCounterElem = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleWeeklyChallengeFresh, 0)
end

AllWeeklyChallengeData.IsUnlockExtraReward = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for _,data in pairs(self.dataDic) do
    if #(data.cfg).base_reward > 1 and data:IsUnlockWeeklyChallenge() then
      return true
    end
  end
  return false
end

AllWeeklyChallengeData.SetOutOfData = function(self)
  -- function num : 0_7
  self.isOutOfData = true
end

AllWeeklyChallengeData.IsOutOfData = function(self)
  -- function num : 0_8
  return self.isOutOfData
end

AllWeeklyChallengeData.IsExistChallenge = function(self)
  -- function num : 0_9 , upvalues : _ENV
  do return (table.count)(self.dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllWeeklyChallengeData.ConvetTypeReward2RewadDic = function(weeklyReward)
  -- function num : 0_10 , upvalues : _ENV
  local num = 0
  for type,rewardNum in pairs(weeklyReward) do
    num = rewardNum + num
  end
  if num > 0 then
    return {[(ConfigData.game_config).weeklyRewardItemId] = num}
  else
    return nil
  end
end

AllWeeklyChallengeData.IsTokenReach2Capacity = function(self)
  -- function num : 0_11
  local isFinish, baseNum, baseMax, extrNum, extrMax = self:GetWeeklyChallengeReward()
  if isFinish or baseMax <= baseNum and extrMax <= extrNum then
    return true
  end
  return false
end

AllWeeklyChallengeData.GetIsUnderDoubleReward = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.doublePickTm == nil then
    return true
  end
  do return self.doublePickTm <= PlayerDataCenter.timestamp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllWeeklyChallengeData.GetWCIsHaveReplaceUIType = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local curEndTm = nil
  for id,wcData in pairs(self.dataDic) do
    curEndTm = wcData:GetWCEndTime()
    do break end
  end
  do
    local fakeType = {}
    for key,value in pairs(UIWindowGlobalConfig[UIWindowTypeID.DailyChallenge]) do
      fakeType[key] = value
    end
    local wcAppCfg = (ConfigData.challenge_appearance)[curEndTm]
    if wcAppCfg == nil or (string.IsNullOrEmpty)(wcAppCfg.ui_prefab) then
      return nil, fakeType
    end
    fakeType.PrefabName = wcAppCfg.ui_prefab
    return true, fakeType
  end
end

AllWeeklyChallengeData.GetIsHaveLastActivityWCRank = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self:GetWeeklyChallengeDataByDungeonId(1503) ~= nil then
    return false
  end
  local maxActitvityEndTime = 0
  for id,wcCfgs in pairs(ConfigData.weekly_challenge_config) do
    if id == 103 then
      for tiem_end,wcCfg in pairs(wcCfgs) do
        if maxActitvityEndTime < tiem_end then
          maxActitvityEndTime = tiem_end
        end
      end
    end
  end
  if PlayerDataCenter.timestamp < maxActitvityEndTime + 1209600 then
    return true
  end
  return false
end

AllWeeklyChallengeData.GetWeelyNodeMaxScore = function(self)
  -- function num : 0_15
  if not self.maxScore then
    self.maxScore = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.maxScore).score1 = (self.maxScore).score1 or 0
    return (self.maxScore).score1
  end
end

AllWeeklyChallengeData.GetSpecNodeMaxScore = function(self)
  -- function num : 0_16
  if not self.maxScore then
    self.maxScore = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.maxScore).score2 = (self.maxScore).score2 or 0
    return (self.maxScore).score2
  end
end

return AllWeeklyChallengeData

