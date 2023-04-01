-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCRankRewardPanel = class("UINWCRankRewardPanel", UIBaseNode)
local base = UIBaseNode
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local UINWCRankRewardPanelItem = require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankRewardPanelItem")
UINWCRankRewardPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCRankRewardPanelItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.rewardItemPool = (UIItemPool.New)(UINWCRankRewardPanelItem, (self.ui).obj_rank)
  ;
  ((self.ui).obj_rank):SetActive(false)
  self.curRankItem = nil
end

UINWCRankRewardPanel.InitRankRewardPanel = function(self, rankRewardId, selfRangeData, resloader)
  -- function num : 0_1 , upvalues : _ENV, UINWCRankRewardPanelItem
  local rank, rate = nil, nil
  if selfRangeData.score ~= 0 and selfRangeData.curRank ~= 0 then
    rank = selfRangeData.curRank
    rate = selfRangeData.curRank / selfRangeData.total
  end
  ;
  (self.rewardItemPool):HideAll()
  local lastScore = 0
  local maxIndex = #(ConfigData.weekly_challenge_rank_reward)[rankRewardId]
  for index,rankRewardCfg in ipairs((ConfigData.weekly_challenge_rank_reward)[rankRewardId]) do
    local item = (self.rewardItemPool):GetOne()
    item:InitRankRewardPanelItem(rankRewardCfg, lastScore, maxIndex == index, resloader)
    lastScore = rankRewardCfg.score
    if rank ~= nil and self.curRankItem == nil then
      if rankRewardCfg.type == (UINWCRankRewardPanelItem.eType).actuallyRank and rank <= rankRewardCfg.score then
        self.curRankItem = item
      elseif rankRewardCfg.type == (UINWCRankRewardPanelItem.eType).percentRank and rate * 1000 <= rankRewardCfg.score then
        self.curRankItem = item
      end
    end
    ;
    ((item.ui).img_CurrentRank):SetActive(false)
  end
  if self.curRankItem ~= nil then
    (((self.curRankItem).ui).img_CurrentRank):SetActive(true)
  end
  if (PlayerDataCenter.allWeeklyChallengeData).lastTm == nil then
    (((self.ui).tex_Time).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).tex_Time).gameObject):SetActive(true)
  local lastEndTime = (PlayerDataCenter.allWeeklyChallengeData).lastTm
  local endTime = (PlayerDataCenter.allWeeklyChallengeData).rankTm
  local lastEndTimeData = TimeUtil:TimestampToDate(lastEndTime, false, true)
  local endTimeData = TimeUtil:TimestampToDate(endTime, false, true)
  if ((lastEndTimeData.hour <= 9 or not tostring(lastEndTimeData.hour)) and lastEndTimeData.min <= 9) or not tostring(lastEndTimeData.min) then
    local lastEndStr = (string.format)("%s/%s %s:%s", tostring(lastEndTimeData.month), tostring(lastEndTimeData.day), "0" .. tostring(lastEndTimeData.hour), "0" .. tostring(lastEndTimeData.min))
    if ((endTimeData.hour <= 9 or not tostring(endTimeData.hour)) and endTimeData.min <= 9) or not tostring(endTimeData.min) then
      local endStr = (string.format)("%s/%s %s:%s", tostring(endTimeData.month), tostring(endTimeData.day), "0" .. tostring(endTimeData.hour), "0" .. tostring(endTimeData.min))
      ;
      ((self.ui).tex_Time):SetIndex(0, lastEndStr, endStr)
      -- DECOMPILER ERROR: 14 unprocessed JMP targets
    end
  end
end

UINWCRankRewardPanel.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWCRankRewardPanel

