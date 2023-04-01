-- params : ...
-- function num : 0 , upvalues : _ENV
local WeeklyChallengeData = class("WeeklyChallengeData")
local WCEnum = require("Game.WeeklyChallenge.WCEnum")
local PeridicFmtBuffSelectData = require("Game.PeriodicChallenge.PeridicFmtBuffSelectData")
WeeklyChallengeData.CreatrWCData = function(id)
  -- function num : 0_0 , upvalues : WeeklyChallengeData
  local data = (WeeklyChallengeData.New)()
  data.id = id
  return data
end

WeeklyChallengeData.ctor = function(self)
  -- function num : 0_1
  self.id = nil
  self.cfg = nil
  self.heroIdList = {}
  self.isHaveRank = false
  self.currentMaxScore = 0
end

WeeklyChallengeData.UpdateByMsg = function(self, weeklyChallengeElem, wcMsg)
  -- function num : 0_2 , upvalues : _ENV, PeridicFmtBuffSelectData
  local heroGroup = (weeklyChallengeElem.cfg).heroGroup
  self.heroIdList = {}
  for k,v in pairs(heroGroup) do
    (table.insert)(self.heroIdList, k)
  end
  self.baseRate = (weeklyChallengeElem.cfg).baseRate
  self.cfg = (ConfigData.weekly_challenge)[self.id]
  local clgId = (self.cfg).challenge_id
  local endTime = (weeklyChallengeElem.cfg).endTime
  if (ConfigData.weekly_challenge_config)[clgId] == nil or ((ConfigData.weekly_challenge_config)[clgId])[endTime] == nil then
    error((string.format)("Cant get weekly_challenge_config, id:%s, endTime:%s", clgId, endTime))
    return 
  end
  self.wc_cfg = ((ConfigData.weekly_challenge_config)[clgId])[endTime]
  self._fmtBuffSelectData = (PeridicFmtBuffSelectData.CreateFmtBuffByWc)(self.id, self.wc_cfg, weeklyChallengeElem.cfg)
  self.isHaveRank = (self.cfg).have_rank > 0
  self:SetCurrentMaxScore(wcMsg)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WeeklyChallengeData.SetCurrentMaxScore = function(self, wcMsg)
  -- function num : 0_3 , upvalues : WCEnum
  if not self.isHaveRank then
    return 
  end
  if wcMsg == nil or wcMsg.current == nil then
    return 
  end
  if not (wcMsg.current).score then
    self.currentMaxScore = (self.cfg).have_rank ~= (WCEnum.eRankType).normal or 0
    if not (wcMsg.current).score2 then
      self.currentMaxScore = (self.cfg).have_rank ~= (WCEnum.eRankType).activity or 0
    end
  end
end

WeeklyChallengeData.RefreshCurrentMaxScore = function(self, score)
  -- function num : 0_4
  if not self.isHaveRank then
    return 
  end
  if score < self.currentMaxScore or 0 then
    return 
  end
  self.currentMaxScore = score
end

WeeklyChallengeData.GetCurrentMaxScore = function(self)
  -- function num : 0_5
  return self.currentMaxScore
end

WeeklyChallengeData.GetWeeklyChanllengeChipDic = function(self)
  -- function num : 0_6
  return (self.wc_cfg).const_shop_poolDic
end

WeeklyChallengeData.GetWCConfig = function(self)
  -- function num : 0_7
  return self.cfg
end

WeeklyChallengeData.GetIsHaveRankList = function(self)
  -- function num : 0_8
  return self.isHaveRank
end

WeeklyChallengeData.GetRankType = function(self)
  -- function num : 0_9
  return (self.cfg).have_rank
end

WeeklyChallengeData.GetWeeklyType = function(self)
  -- function num : 0_10
  return (self.cfg).weekly_challenge_type
end

WeeklyChallengeData.GetIsHaveRankReward = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return ((ConfigData.weekly_challenge_rank_reward).isHaveReward)[(self.wc_cfg).rank_id]
end

WeeklyChallengeData.GetRankRewardId = function(self)
  -- function num : 0_12
  return (self.wc_cfg).rank_id
end

WeeklyChallengeData.IsUnlockWeeklyChallenge = function(self)
  -- function num : 0_13 , upvalues : _ENV
  return (CheckCondition.CheckLua)((self.cfg).pre_condition, (self.cfg).pre_para1, (self.cfg).pre_para2)
end

WeeklyChallengeData.GetMapLogic = function(self)
  -- function num : 0_14
  if self.wc_cfg ~= nil then
    return (self.wc_cfg).map_logic
  end
  return nil
end

WeeklyChallengeData.GetWCEndTime = function(self)
  -- function num : 0_15
  if self.wc_cfg ~= nil then
    return (self.wc_cfg).time_end
  end
end

WeeklyChallengeData.GetFmtBuffSelectData = function(self)
  -- function num : 0_16
  return self._fmtBuffSelectData
end

return WeeklyChallengeData

