-- params : ...
-- function num : 0 , upvalues : _ENV
local UIPeriodicBattleBossResult = class("UIPeriodicBattleBossResult", UIBaseWindow)
local base = UIBaseWindow
local UINPeriodBattleBossResultItem = require("Game.PeriodicChallenge.UI.BattleBossResult.UINPeriodBattleBossResultItem")
UIPeriodicBattleBossResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINPeriodBattleBossResultItem
  (UIUtil.AddButtonListener)((self.ui).btn_Settle, self, self._OnClickSettle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reload, self, self._OnClickRestart)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Statistic, self, self._OnClickStatistic)
  self.resultItemPool = (UIItemPool.New)(UINPeriodBattleBossResultItem, (self.ui).infoItem, false)
end

UIPeriodicBattleBossResult.InitPeriodicBattleBossResult = function(self, resultTab, settleFunc, restartFunc, statisticFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.settleFunc = settleFunc
  self.restartFunc = restartFunc
  self.statisticFunc = statisticFunc
  ;
  (self.resultItemPool):HideAll()
  do
    if resultTab.bossName ~= nil then
      local resultItem = (self.resultItemPool):GetOne()
      resultItem:SetNameIdxPeriodBossResultItem(0, resultTab.bossName)
      resultItem:SetValueIdxPeriodBossResultItem(0, resultTab.bossCurHp, resultTab.bossMaxHp)
    end
    local resultItem = (self.resultItemPool):GetOne()
    resultItem:SetNameIdxPeriodBossResultItem(1)
    local curTime = tostring(resultTab.battleCurSecond) .. "S"
    local allTime = tostring(resultTab.battleAllSecond) .. "S"
    resultItem:SetValueIdxPeriodBossResultItem(0, curTime, allTime)
    local resultItem = (self.resultItemPool):GetOne()
    resultItem:SetNameIdxPeriodBossResultItem(2)
    resultItem:SetValueIdxPeriodBossResultItem(1, resultTab.score)
  end
end

UIPeriodicBattleBossResult._OnClickSettle = function(self)
  -- function num : 0_2
  if self.settleFunc ~= nil then
    (self.settleFunc)()
  end
  self:Delete()
end

UIPeriodicBattleBossResult._OnClickRestart = function(self)
  -- function num : 0_3
  if self.restartFunc ~= nil then
    (self.restartFunc)()
  end
  self:Delete()
end

UIPeriodicBattleBossResult._OnClickStatistic = function(self)
  -- function num : 0_4
  if self.statisticFunc ~= nil then
    (self.statisticFunc)()
  end
end

UIPeriodicBattleBossResult.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.resultItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIPeriodicBattleBossResult

