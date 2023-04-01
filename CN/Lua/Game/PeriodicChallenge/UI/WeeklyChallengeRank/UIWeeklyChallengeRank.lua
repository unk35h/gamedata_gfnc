-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWeeklyChallengeRank = class("UIWeeklyChallengeRank", UIBaseWindow)
local base = UIBaseWindow
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local UINWCRankRewardPanel = require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankRewardPanel")
local UINWCRankPanel = require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankPanel")
local UINWCRankTogItem = require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankTogItem")
local cs_ResLoader = CS.ResLoader
UIWeeklyChallengeRank.ePanelType = {curRank = 1, oldRank = 2, reward = 3, activityOldRank = 4}
UIWeeklyChallengeRank.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, UINWCRankRewardPanel, UINWCRankPanel, _ENV, UINWCRankTogItem
  self.resloader = (cs_ResLoader.Create)()
  self.rewardPanel = (UINWCRankRewardPanel.New)()
  ;
  (self.rewardPanel):Init((self.ui).awardNode)
  self.listPanel = (UINWCRankPanel.New)()
  ;
  (self.listPanel):Init((self.ui).rankNode)
  self.showingType = nil
  self.pageTogPool = (UIItemPool.New)(UINWCRankTogItem, (self.ui).obj_Page)
  ;
  ((self.ui).obj_Page):SetActive(false)
  self.__ShowCurTermRanklist = BindCallback(self, self.ShowCurTermRanklist)
  self.__ShowPreviousTermRanklist = BindCallback(self, self.ShowPreviousTermRanklist)
  self.__ShowRanklistReward = BindCallback(self, self.ShowRanklistReward)
  self.__ShowLastActivityRanklist = BindCallback(self, self.ShowLastActivityRanklist)
  ;
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, nil)
  self.selfRangeDataDic = {}
end

UIWeeklyChallengeRank.GenWCRPageTogs = function(self, challengeId)
  -- function num : 0_1 , upvalues : _ENV, UINWCRankTogItem
  self.challengeId = challengeId
  self.challengeData = (PlayerDataCenter.allWeeklyChallengeData):GetWeeklyChallengeDataByDungeonId(challengeId)
  ;
  (self.pageTogPool):HideAll()
  local curTermRanklistTog = (self.pageTogPool):GetOne()
  curTermRanklistTog:InitWCRankTogItem((UINWCRankTogItem.eTogType).curTermRankList, self.__ShowCurTermRanklist)
  local previousTermRanklistTog = (self.pageTogPool):GetOne()
  previousTermRanklistTog:InitWCRankTogItem((UINWCRankTogItem.eTogType).previousTermRankList, self.__ShowPreviousTermRanklist)
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if (self.challengeData):GetIsHaveRankReward() then
    local RanklistRewardTog = (self.pageTogPool):GetOne()
    RanklistRewardTog:InitWCRankTogItem((UINWCRankTogItem.eTogType).rankRewardList, self.__ShowRanklistReward)
    self:RefreshRemaindTime()
    self.timerId = TimerManager:StartTimer(1, self.RefreshRemaindTime, self, false, false, false)
    ;
    ((self.ui).obj_timer):SetActive(true)
  else
    do
      ;
      ((self.ui).obj_timer):SetActive(false)
      do
        if (PlayerDataCenter.allWeeklyChallengeData):GetIsHaveLastActivityWCRank() then
          local lastActivityWC = (self.pageTogPool):GetOne()
          lastActivityWC:InitWCRankTogItem((UINWCRankTogItem.eTogType).activityOldRankList, self.__ShowLastActivityRanklist)
        end
        -- DECOMPILER ERROR at PC86: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((curTermRanklistTog.ui).tog_Page).isOn = true
      end
    end
  end
end

UIWeeklyChallengeRank.ShowCurTermRanklist = function(self)
  -- function num : 0_2 , upvalues : UIWeeklyChallengeRank, UINWCRankPanel
  self.showingType = (UIWeeklyChallengeRank.ePanelType).curRank
  ;
  (self.rewardPanel):Hide()
  ;
  (self.listPanel):Show()
  local rankType = (self.challengeData):GetRankType()
  ;
  (self.listPanel):ShowRankPlayers((UINWCRankPanel.eRankListType).cur, self.challengeData, (self.challengeData).wc_cfg, self.resloader, rankType)
end

UIWeeklyChallengeRank.ShowPreviousTermRanklist = function(self)
  -- function num : 0_3 , upvalues : UIWeeklyChallengeRank, _ENV, UINWCRankPanel
  self.showingType = (UIWeeklyChallengeRank.ePanelType).oldRank
  ;
  (self.rewardPanel):Hide()
  ;
  (self.listPanel):Show()
  local clgId = ((self.challengeData).cfg).challenge_id
  local lastWCEndTime = (PlayerDataCenter.allWeeklyChallengeData).lastTm
  local rankType = (self.challengeData):GetRankType()
  ;
  (self.listPanel):ShowRankPlayers((UINWCRankPanel.eRankListType).old, self.challengeData, ((ConfigData.weekly_challenge_config)[clgId])[lastWCEndTime], self.resloader, rankType)
end

UIWeeklyChallengeRank.ShowRanklistReward = function(self)
  -- function num : 0_4 , upvalues : UIWeeklyChallengeRank, _ENV
  self.showingType = (UIWeeklyChallengeRank.ePanelType).reward
  ;
  (self.rewardPanel):Show()
  ;
  (self.listPanel):Hide()
  if (self.selfRangeDataDic)[(self.challengeData):GetRankType()] == nil then
    (NetworkManager:GetNetwork(NetworkTypeID.Sector)):CS_WEEKLYCHALLENGE_RankPage(false, 0, (self.challengeData):GetRankType(), function()
    -- function num : 0_4_0 , upvalues : self
    self:CalAndShowRanklistReward()
  end
)
  else
    self:CalAndShowRanklistReward()
  end
end

UIWeeklyChallengeRank.ShowLastActivityRanklist = function(self)
  -- function num : 0_5 , upvalues : UIWeeklyChallengeRank, _ENV, UINWCRankPanel
  self.showingType = (UIWeeklyChallengeRank.ePanelType).activityOldRank
  ;
  (self.rewardPanel):Hide()
  ;
  (self.listPanel):Show()
  local clgId = ((self.challengeData).cfg).challenge_id
  local lastWCEndTime = (PlayerDataCenter.allWeeklyChallengeData).lastTm
  local rankType = 2
  ;
  (self.listPanel):ShowRankPlayers((UINWCRankPanel.eRankListType).old, self.challengeData, ((ConfigData.weekly_challenge_config)[clgId])[lastWCEndTime], self.resloader, rankType)
end

UIWeeklyChallengeRank.CalAndShowRanklistReward = function(self)
  -- function num : 0_6
  (self.rewardPanel):InitRankRewardPanel((self.challengeData):GetRankRewardId(), (self.selfRangeDataDic)[(self.challengeData):GetRankType()], self.resloader)
end

UIWeeklyChallengeRank.OnReceiveRankMsg = function(self, msg)
  -- function num : 0_7
  local isOld = msg.history
  if self.listPanel ~= nil then
    (self.listPanel):GetRankPageMsg(msg)
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  if not isOld then
    (self.selfRangeDataDic)[msg.rankCat] = msg.selfRange
  end
end

UIWeeklyChallengeRank.RefreshRemaindTime = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local isRankOutof = (PlayerDataCenter.allWeeklyChallengeData).rankTm < PlayerDataCenter.timestamp
  ;
  ((self.ui).title_Timer):SetIndex(isRankOutof and 1 or 0)
  local nextTime = nil
  if isRankOutof then
    local counterElem = (PlayerDataCenter.allWeeklyChallengeData):GetCounterElem()
    nextTime = counterElem ~= nil and counterElem.nextExpiredTm or 0
  else
    nextTime = (PlayerDataCenter.allWeeklyChallengeData).rankTm
  end
  local remaindTime = (math.max)((math.floor)(nextTime - PlayerDataCenter.timestamp), 0)
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
  if h < 10 or not tostring(h) then
    local hStr = "0" .. tostring(h)
  end
  if m < 10 or not tostring(m) then
    local mStr = "0" .. tostring(m)
  end
  if s < 10 or not tostring(s) then
    local sStr = "0" .. tostring(s)
  end
  if d > 0 then
    ((self.ui).tex_Timer):SetIndex(0, tostring(d), hStr, mStr, sStr)
  else
    ((self.ui).tex_Timer):SetIndex(1, hStr, mStr, sStr)
  end
  if remaindTime <= 0 and isRankOutof and self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  -- DECOMPILER ERROR: 16 unprocessed JMP targets
end

UIWeeklyChallengeRank.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  (self.rewardPanel):Delete()
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWeeklyChallengeRank

