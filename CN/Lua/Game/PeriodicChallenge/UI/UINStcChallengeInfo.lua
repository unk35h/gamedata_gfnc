-- params : ...
-- function num : 0 , upvalues : _ENV
local UINStcChallengeInfo = class("UINStcChallengeInfo", UIBaseNode)
local base = UIBaseNode
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local eDungeonEnum = require("Game.Dungeon.eDungeonEnum")
local UINStcChallengeInfoRewardNode = require("Game.PeriodicChallenge.UI.UINStcChallengeInfoRewardNode")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINStcChallengeInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINStcChallengeInfo.InitDailyDgEnterBtn = function(self)
  -- function num : 0_1 , upvalues : SectorLevelDetailEnum
  self.detailType = (SectorLevelDetailEnum.eDetailType).DailyDungeon
  ;
  ((self.ui).tex_TypeTile):SetIndex(0)
  ;
  ((self.ui).tex_TypeTileEn):SetIndex(0)
  ;
  ((self.ui).imageIcon):SetIndex(0)
  self:RefreshDailyDgEnterBtn()
end

UINStcChallengeInfo.InitWeeklyChallenge = function(self, isSectorBtn)
  -- function num : 0_2 , upvalues : SectorLevelDetailEnum, UINStcChallengeInfoRewardNode
  self.detailType = (SectorLevelDetailEnum.eDetailType).WeeklyChallenge
  ;
  ((self.ui).rewardNode):SetActive(true)
  if self.__RewardNode == nil then
    self.__RewardNode = (UINStcChallengeInfoRewardNode.New)()
    ;
    (self.__RewardNode):Init((self.ui).rewardNode)
  end
  self.isSectorBtn = isSectorBtn
  ;
  ((self.ui).tex_TypeTile):SetIndex(1)
  ;
  ((self.ui).tex_TypeTileEn):SetIndex(1)
  ;
  ((self.ui).imageIcon):SetIndex(1)
  self:RefreshWeeklyChallenge()
end

UINStcChallengeInfo.InitDungoneTowerBtn = function(self)
  -- function num : 0_3 , upvalues : SectorLevelDetailEnum, _ENV
  self.detailType = (SectorLevelDetailEnum.eDetailType).DungeonTower
  ;
  ((self.ui).tex_TypeTile):SetIndex(2)
  ;
  ((self.ui).tex_TypeTileEn):SetIndex(2)
  ;
  ((self.ui).imageIcon):SetIndex(2)
  ;
  ((self.ui).obj_Continue):SetActive(false)
  ;
  ((self.ui).obj_passMarker):SetActive(false)
  ;
  ((self.ui).tex_TimeTitle):SetIndex(2)
  self:RefreshDungeonTowerBtn()
  if self._dunTowerListener == nil then
    self._dunTowerListener = function(node)
    -- function num : 0_3_0 , upvalues : self
    local active = node:GetRedDotCount() > 0
    ;
    ((self.ui).redDot):SetActive(active)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    local _, dunTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower)
    RedDotController:AddListener(dunTowerNode.nodePath, self._dunTowerListener)
    ;
    (self._dunTowerListener)(dunTowerNode)
  end
end

UINStcChallengeInfo.RefreshStcChallengeInfo = function(self)
  -- function num : 0_4 , upvalues : SectorLevelDetailEnum
  if self.detailType == (SectorLevelDetailEnum.eDetailType).DailyDungeon then
    self:RefreshDailyDgEnterBtn()
  else
    if self.detailType == (SectorLevelDetailEnum.eDetailType).WeeklyChallenge then
      self:RefreshWeeklyChallenge()
    end
  end
end

UINStcChallengeInfo.RefreshDailyDgEnterBtn = function(self)
  -- function num : 0_5 , upvalues : _ENV, eDungeonEnum
  local isFinish, inDungeon = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonState()
  ;
  ((self.ui).obj_Continue):SetActive(inDungeon)
  local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
  local isNew = dungeonDyncElem.isDailyDungeonNew
  ;
  ((self.ui).blueDot):SetActive(isNew)
  local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleRefreshableDungeon, (eDungeonEnum.eMatDungeonGroup).DailyDungeon)
  if counterElem ~= nil then
    self.netxRefreshTimeStamp = counterElem.nextExpiredTm
    self:SetRemaindTime()
  end
  if isFinish then
    ((self.ui).tex_TimeTitle):SetIndex(1)
    ;
    ((self.ui).obj_passMarker):SetActive(true)
  else
    ;
    ((self.ui).tex_TimeTitle):SetIndex(0)
    ;
    ((self.ui).obj_passMarker):SetActive(false)
  end
  self:RefreshDailyDgEnterBtnDouble()
end

UINStcChallengeInfo.RefreshDailyDgEnterBtnDouble = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
  local hasDouble = dungeonDyncElem:DgDyncIsHaveMultReward()
  ;
  ((self.ui).obj_double):SetActive(hasDouble)
end

UINStcChallengeInfo.RefreshWeeklyChallenge = function(self)
  -- function num : 0_7 , upvalues : SectorStageDetailHelper, _ENV
  local _, _, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  local isInEp = moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge
  ;
  ((self.ui).obj_Continue):SetActive(isInEp)
  local counterElem = (PlayerDataCenter.allWeeklyChallengeData):GetCounterElem()
  if counterElem ~= nil then
    self.netxRefreshTimeStamp = counterElem.nextExpiredTm
    self:SetRemaindTime()
  end
  local isFinish, baseReward, baseRewardMax, extraReward, extraRewardMax = (PlayerDataCenter.allWeeklyChallengeData):GetWeeklyChallengeReward()
  if self.__RewardNode ~= nil then
    (self.__RewardNode):RefreshChallengeReward()
  end
  if isFinish then
    ((self.ui).tex_TimeTitle):SetIndex(1)
    ;
    ((self.ui).obj_passMarker):SetActive(true)
  else
    ((self.ui).tex_TimeTitle):SetIndex(0)
    ;
    ((self.ui).obj_passMarker):SetActive(false)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINStcChallengeInfo.RefreshDungeonTowerBtn = function(self)
  -- function num : 0_8 , upvalues : _ENV
  ((self.ui).blueDot):SetActive(false)
  local curLevel = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerCompleteLevel()
  local totalLevel = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerTotalLevel()
  ;
  ((self.ui).tex_Timer):SetIndex(2, tostring(curLevel), tostring(totalLevel))
  ;
  ((self.ui).blueDot):SetActive((PlayerDataCenter.dungeonTowerSData):HasNewDunTower())
end

UINStcChallengeInfo.SetRemaindTime = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if self.netxRefreshTimeStamp == nil or self.netxRefreshTimeStamp <= PlayerDataCenter.timestamp then
    return 
  end
  self:RefreshRemaindTime()
  self.timerId = TimerManager:StartTimer(1, self.RefreshRemaindTime, self, false, false, false)
end

UINStcChallengeInfo.RefreshRemaindTime = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local remaindTime = (math.max)((math.floor)(self.netxRefreshTimeStamp - PlayerDataCenter.timestamp), 0)
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
    ;
    ((self.ui).tex_Timer):SetIndex(1, hStr, mStr, sStr)
  end
  if remaindTime <= 0 and self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
end

UINStcChallengeInfo.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if self.__RewardNode ~= nil then
    (self.__RewardNode):Delete()
  end
  do
    if self._dunTowerListener ~= nil then
      local _, dunTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower)
      RedDotController:RemoveListener(dunTowerNode.nodePath, self._dunTowerListener)
    end
    ;
    (base.OnDelete)(self)
  end
end

return UINStcChallengeInfo

