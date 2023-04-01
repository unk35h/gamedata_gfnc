-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityDailyChallengeData = class("ActivityDailyChallengeData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local PeridicFmtBuffSelectData = require("Game.PeriodicChallenge.PeridicFmtBuffSelectData")
local CurActType = (ActivityFrameEnum.eActivityType).DailyChallenge
ActivityDailyChallengeData.InitADCData = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV
  self._isOpened = false
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._cfg = (ConfigData.activity_dailychallenge)[msg.actId]
  self._dungeonCfg = (ConfigData.activity_dailychallenge_dungeon)[msg.actId]
  self._awardCfg = (ConfigData.activity_dailychallenge_award)[msg.actId]
  self._cycleAwardCfg = ((ConfigData.activity_dailychallenge_award).cyclePhaseDic)[msg.actId]
  self._maxFixedPoint = ((self._awardCfg)[#self._awardCfg]).need_point
  self:UpdateADCData(msg)
  self._fmtSelectDic = {}
end

ActivityDailyChallengeData.UpdateADCData = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  self._dungeonPointDic = {}
  for k,v in pairs(msg.dungeonPoint) do
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R7 in 'UnsetPending'

    (self._dungeonPointDic)[k] = v >> 32
  end
  self._extraGotPoint = msg.extraGotPoint
  self._nextUnlockRefreshTime = msg.nextUnlockRefreshTime
  self._totalPoint = 0
  for dungeonId,point in pairs(self._dungeonPointDic) do
    self._totalPoint = self._totalPoint + point
  end
  self._rewardGotPointDic = {}
  for i,score in ipairs(msg.rewardGotPoint) do
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R7 in 'UnsetPending'

    (self._rewardGotPointDic)[score] = true
  end
  self:__RefreshReddot()
end

ActivityDailyChallengeData.UpdateADCKeyItemMsg = function(self, msg)
  -- function num : 0_2
  self._nextUnlockRefreshTime = msg.nextExpiredTm
end

ActivityDailyChallengeData.SetADCDunegonPoint = function(self, dungeonId, score)
  -- function num : 0_3
  if self:IsADCDungeonUnlock(dungeonId) then
    self._totalPoint = self._totalPoint - (self._dungeonPointDic)[dungeonId]
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._dungeonPointDic)[dungeonId] = score
    self._totalPoint = self._totalPoint + score
    self:__RefreshReddot()
  end
end

ActivityDailyChallengeData.ReqADCScoreReward = function(self, score, isCycle, callback)
  -- function num : 0_4 , upvalues : _ENV
  if not isCycle and not self:IsCanADCFixedReward(score) then
    return 
  end
  if not self:IsCanADCExtraReward() then
    return 
  end
  score = (math.max)(self._extraGotPoint, self._maxFixedPoint)
  score = score + (math.floor)((self._totalPoint - score) / (self._cycleAwardCfg).need_point) * (self._cycleAwardCfg).need_point
  local adcNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityDailyChallenge)
  adcNet:CS_ACTIVITY_DailyChallenge_GetPointReward(self:GetActId(), score, function(args)
    -- function num : 0_4_0 , upvalues : _ENV, self, score, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    local total = #msg.rewardGotPoint
    do
      for index,rewardScore in ipairs(msg.rewardGotPoint) do
        -- DECOMPILER ERROR at PC18: Confused about usage of register: R8 in 'UnsetPending'

        if rewardScore <= self._maxFixedPoint then
          (self._rewardGotPointDic)[rewardScore] = true
        else
          if index == total then
            self._extraGotPoint = rewardScore
          end
        end
      end
    end
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    if score <= self._maxFixedPoint then
      (self._rewardGotPointDic)[score] = true
    else
      self._extraGotPoint = score
    end
    local rewardIds = {}
    local rewardNums = {}
    for k,v in pairs(msg.rewards) do
      (table.insert)(rewardIds, k)
      ;
      (table.insert)(rewardNums, v)
    end
    do
      if #rewardIds > 0 then
        local heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
        UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_4_0_0 , upvalues : _ENV, rewardIds, rewardNums, heroIdSnapShoot
      if window == nil then
        return 
      end
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = (((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(heroIdSnapShoot, false)):SetCRNotHandledGreat(true)
      window:AddAndTryShowReward(CRData)
    end
)
      end
      self:__RefreshReddot()
      if callback ~= nil then
        callback()
      end
    end
  end
)
end

ActivityDailyChallengeData.RefreshADCDailyFlush = function(self)
  -- function num : 0_5
  self:__RefreshReddot()
end

ActivityDailyChallengeData.ReqADCUnlockDungeon = function(self, dungeonId, callback)
  -- function num : 0_6 , upvalues : _ENV
  if (self._dungeonPointDic)[dungeonId] ~= nil then
    return 
  end
  local dungeonCfg = (self._dungeonCfg)[dungeonId]
  if dungeonCfg == nil then
    return 
  end
  if self:GetADCKeyItemCount() < dungeonCfg.unlock_item then
    return 
  end
  local adcNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityDailyChallenge)
  adcNet:CS_ACTIVITY_DailyChallenge_UnlockDungeon(self:GetActId(), dungeonId, function(args)
    -- function num : 0_6_0 , upvalues : _ENV, self, callback, dungeonId
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    for i,dungeonId in ipairs(msg.dungeon) do
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R7 in 'UnsetPending'

      if (self._dungeonPointDic)[dungeonId] == nil then
        (self._dungeonPointDic)[dungeonId] = 0
      end
    end
    if callback ~= nil then
      callback()
    end
    MsgCenter:Broadcast(eMsgEventId.ActivityDailyChallengeDungeonUpdate, dungeonId)
  end
)
end

ActivityDailyChallengeData.SetAdcOpend = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  self._lastOpenMainUITime = (math.floor)(PlayerDataCenter.timestamp)
  userDataCache:RecordADCEnterTime(self:GetActId(), self._lastOpenMainUITime)
  self:__RefreshReddot()
end

ActivityDailyChallengeData.__RefreshReddot = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  do
    if self._lastOpenMainUITime == nil then
      local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      self._lastOpenMainUITime = userDataCache:GetADCEnterTime(self:GetActId())
    end
    if TimeUtil:CompareIsCorssDay(self._lastOpenMainUITime, (math.floor)(PlayerDataCenter.timestamp)) then
      reddot:SetRedDotCount(1)
      return 
    end
    if self:IsCanADCExtraReward() then
      reddot:SetRedDotCount(1)
      return 
    end
    for k,cfg in ipairs(self._awardCfg) do
      if self:IsCanADCFixedReward(cfg.need_point) then
        reddot:SetRedDotCount(1)
        return 
      end
    end
    reddot:SetRedDotCount(0)
  end
end

ActivityDailyChallengeData.IsCanADCFixedReward = function(self, score)
  -- function num : 0_9
  do return not (self._rewardGotPointDic)[score] and score <= self._totalPoint and score <= self._maxFixedPoint end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityDailyChallengeData.IsCanADCExtraReward = function(self)
  -- function num : 0_10
  if (self._cycleAwardCfg).need_point > self._totalPoint - self._extraGotPoint then
    do return self._extraGotPoint or 0 <= 0 end
    do return (self._cycleAwardCfg).need_point <= self._totalPoint - self._maxFixedPoint end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

ActivityDailyChallengeData.IsReceiveADCFixedReward = function(self, score)
  -- function num : 0_11
  return (self._rewardGotPointDic)[score]
end

ActivityDailyChallengeData.GetADCTotalPoint = function(self)
  -- function num : 0_12
  return self._totalPoint
end

ActivityDailyChallengeData.GetADCDungeonPoint = function(self, dungeonId)
  -- function num : 0_13
  return (self._dungeonPointDic)[dungeonId] or 0
end

ActivityDailyChallengeData.IsADCDungeonUnlock = function(self, dungeonId)
  -- function num : 0_14
  do return (self._dungeonPointDic)[dungeonId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityDailyChallengeData.GetADCKeyItemRecure = function(self)
  -- function num : 0_15
  return self._nextUnlockRefreshTime
end

ActivityDailyChallengeData.GetADCKeyItemCount = function(self)
  -- function num : 0_16 , upvalues : _ENV
  return PlayerDataCenter:GetItemCount((self._cfg).unlock_item)
end

ActivityDailyChallengeData.GetADCMaxFixedPoint = function(self)
  -- function num : 0_17
  return self._maxFixedPoint
end

ActivityDailyChallengeData.GetADCCycleGotPoint = function(self)
  -- function num : 0_18
  return self._extraGotPoint
end

ActivityDailyChallengeData.GetADCMainCfg = function(self)
  -- function num : 0_19
  return self._cfg
end

ActivityDailyChallengeData.GetADCDungeonCfg = function(self)
  -- function num : 0_20
  return self._dungeonCfg
end

ActivityDailyChallengeData.GetADCAwardCfg = function(self)
  -- function num : 0_21
  return self._awardCfg
end

ActivityDailyChallengeData.GetADCCycleAward = function(self)
  -- function num : 0_22
  return self._cycleAwardCfg
end

ActivityDailyChallengeData.IsADCAllPass = function(self)
  -- function num : 0_23 , upvalues : _ENV
  for dungeonid,_ in pairs(self._dungeonCfg) do
    if self:GetADCDungeonPoint(dungeonid) == 0 then
      return false
    end
  end
  return true
end

ActivityDailyChallengeData.IsEnoughADCItemKey = function(self)
  -- function num : 0_24 , upvalues : _ENV
  local needKeyNum = 0
  for dungeonid,cfg in pairs(self._dungeonCfg) do
    if not self:IsADCDungeonUnlock(dungeonid) then
      needKeyNum = needKeyNum + cfg.unlock_item
    end
  end
  do return needKeyNum <= self:GetADCKeyItemCount() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityDailyChallengeData.GetADCBuffSelectData = function(self, dungeonId)
  -- function num : 0_25 , upvalues : _ENV, PeridicFmtBuffSelectData
  if (self._fmtSelectDic)[dungeonId] ~= nil then
    return (self._fmtSelectDic)[dungeonId]
  end
  local dungeonCfg = (self._dungeonCfg)[dungeonId]
  if dungeonCfg == nil then
    error("id id nil " .. tostring(dungeonId))
    return nil
  end
  local fmtBuffSelectData = (PeridicFmtBuffSelectData.CreateFmtBuffByADC)(self, dungeonId)
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local dungenOrder = dungeonCfg.dungeon_order
  local selectbuffDic = userDataCache:GetADCBuffSelect(self:GetActId(), dungenOrder)
  fmtBuffSelectData:SetDefaultSelect(selectbuffDic)
  fmtBuffSelectData:SetSelectCallback(function(buffDic)
    -- function num : 0_25_0 , upvalues : userDataCache, self, dungenOrder
    userDataCache:RecordADCBuffSelect(self:GetActId(), dungenOrder, buffDic)
  end
)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self._fmtSelectDic)[dungeonId] = fmtBuffSelectData
  return fmtBuffSelectData
end

return ActivityDailyChallengeData

