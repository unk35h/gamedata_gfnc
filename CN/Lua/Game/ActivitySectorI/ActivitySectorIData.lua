-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivitySectorIData = class("ActivitySectorIData", ActivityBase)
local base = ActivityBase
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local cs_FixRandom = CS.FixRandom
ActivitySectorIData.InitDataByMsg = function(self, msg)
  -- function num : 0_0 , upvalues : _ENV, ActivityFrameEnum
  self.actId = msg.actId
  self._cfg = (ConfigData.activity_time_limit)[self.actId]
  self:SetActFrameDataByType((ActivityFrameEnum.eActivityType).SectorI, self.actId)
  self.__isReadOnLogin = false
  self.__challengeStageId = 0
  local stageList = ((ConfigData.sector_stage).sectorIdList)[(self._cfg).rechallenge_stage]
  if stageList ~= nil and #stageList > 0 then
    self.__challengeStageId = stageList[1]
  end
  if self.__challengeStageId > 0 and not (PlayerDataCenter.sectorStage):IsStageUnlock(self.__challengeStageId) then
    self.__onSectorStageStateChange = function(data)
    -- function num : 0_0_0 , upvalues : _ENV, self
    if not (PlayerDataCenter.sectorStage):IsStageUnlock(self.__challengeStageId) then
      return 
    end
    self:RefreshSectorIReddot()
    UserMsgCenter:RemoveListener(eMsgEventId.OnSectorStageStateChange, self.__onSectorStageStateChange)
  end

    UserMsgCenter:AddListener(eMsgEventId.OnSectorStageStateChange, self.__onSectorStageStateChange)
  end
  self:UpdateDataByMsg(msg)
end

ActivitySectorIData.UpdateDataByMsg = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  self.battleCount = msg.times
  self.extraTimes = msg.extraTimes
  local expireTm = msg.expireTm
  if expireTm ~= self.expireTm then
    self.expireTm = expireTm
    if expireTm > 0 then
      local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass, true)
      timePassCtrl:AddEventTimer(expireTm, function()
    -- function num : 0_1_0 , upvalues : self, _ENV
    self:RefreshSectorIReddot()
    MsgCenter:Broadcast(eMsgEventId.SectorActivityTimePass)
  end
)
    end
  end
  do
    self.recordSectorId = msg.recordSectorId
    if msg.roundElem ~= nil then
      self.roundId = (msg.roundElem).roundId
      self.randomSeed = (msg.roundElem).roundSeed
      self.roundTimes = (msg.roundElem).roundTimes
      self.roundIndex = (msg.roundElem).roundIndex
      self.poolParaCfg = (ConfigData.activity_time_limit_pool_para)[self.roundId]
    end
    self:RefreshSectorIReddot()
  end
end

ActivitySectorIData.GetSectorICfg = function(self)
  -- function num : 0_2
  return self._cfg
end

ActivitySectorIData.GetSectorIBattleCount = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.expireTm <= PlayerDataCenter.timestamp then
    return true, 0, (self._cfg).frequency_day
  end
  local totalCount = self.extraTimes + (self._cfg).frequency_day
  do return self.battleCount < totalCount, self.battleCount, totalCount end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySectorIData.GetNextExpireTimeInShow = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local timeCtrl = ControllerManager:GetController(ControllerTypeId.TimePass)
  local nextTime = self.expireTm
  if nextTime == 0 then
    nextTime = timeCtrl:GetLogicTodayPassTimeStamp()
  end
  if PlayerDataCenter.timestamp < nextTime then
    return nextTime
  end
  nextTime = timeCtrl:GetLogicTodayPassTimeStamp()
  return nextTime
end

ActivitySectorIData.GetExtraTimesCount = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for i,times in ipairs((self._cfg).refresh_times) do
    if self.extraTimes < times then
      return true, (self._cfg).refreshCostId, (((self.self)._cfg).refreshCostNum)[i]
    end
  end
  return false
end

ActivitySectorIData.GetLastSectorISector = function(self)
  -- function num : 0_6
  do return self.recordSectorId == (self._cfg).easy_stage or self.recordSectorId == (self._cfg).hard_stage, self.recordSectorId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySectorIData.RefreshSectorIReddot = function(self)
  -- function num : 0_7
  self:__RefreshChallengeReddot()
end

ActivitySectorIData.__RefreshChallengeReddot = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local redDotNode = self:GetActivityReddot()
  if redDotNode == nil then
    return 
  end
  if self.__challengeStageId == 0 then
    redDotNode:SetRedDotCount(0)
    return 
  end
  local isUnlock = (PlayerDataCenter.sectorStage):IsStageUnlock(self.__challengeStageId)
  if not isUnlock then
    redDotNode:SetRedDotCount(0)
    return 
  end
  if (self.actInfo):IsActivityRunningTimeout() then
    redDotNode:SetRedDotCount(0)
  else
    local _, battleCount, allCount = self:GetSectorIBattleCount()
    local remainCount = allCount - battleCount
    redDotNode:SetRedDotCount(remainCount)
  end
end

ActivitySectorIData.GetActSectorIDataPoolIdList = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local list = ((ConfigData.activity_time_limit_pool_para).poolDic)[self:GetActFrameId()]
  if list == nil then
    error(" activity_time_limit_pool_para NIL ID:" .. tostring(self:GetActFrameId()))
    return table.emptytable
  end
  return list
end

ActivitySectorIData.GetActSectorIDataCoinId = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local coinId = ((ConfigData.activity_time_limit_pool_para).activityCoinDic)[self:GetActFrameId()]
  if coinId == nil then
    error(" activity_time_limit_pool_para NIL Coin ID:" .. tostring(self:GetActFrameId()))
  end
  return coinId
end

ActivitySectorIData.GetRelationStage = function(self, stageId)
  -- function num : 0_11 , upvalues : _ENV
  if not self:IsActivityRunning() then
    return nil
  end
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil or stageCfg.sector ~= (self._cfg).hard_stage then
    return nil
  end
  local sectorDiffDic = ((ConfigData.sector_stage).sectorDiffDic)[(self._cfg).easy_stage]
  if sectorDiffDic == nil then
    return nil
  end
  sectorDiffDic = sectorDiffDic[stageCfg.difficulty]
  if sectorDiffDic == nil then
    return nil
  end
  local relationId = sectorDiffDic[stageCfg.num]
  if relationId == nil then
    return nil
  end
  return (ConfigData.sector_stage)[relationId]
end

ActivitySectorIData.GetUniqRandsWithSourceShuffleQuantity = function(fixRandom, normalNum, maxNum)
  -- function num : 0_12 , upvalues : _ENV
  if normalNum == 0 then
    error("normalNum == 0")
    return table.emptytable
  end
  if maxNum < normalNum then
    normalNum = maxNum
  end
  local list = {}
  for i = 1, maxNum do
    (table.insert)(list, i)
  end
  maxNum = normalNum
  for i = 1, normalNum do
    local r = fixRandom:RandUInt()
    local j = r % maxNum + i
    list[i] = list[j]
    maxNum = maxNum - 1
  end
  return list
end

ActivitySectorIData.ShuffleRandomPool = function(randomPoolData, fixRandom)
  -- function num : 0_13 , upvalues : ActivitySectorIData, _ENV
  local maxNum = #randomPoolData.arr
  local size = maxNum - randomPoolData.bigNum
  local bigIdxList = (ActivitySectorIData.GetBigIdx)(fixRandom, randomPoolData)
  local arr = (ActivitySectorIData.GetUniqRandsWithSourceShuffleQuantity)(fixRandom, size, maxNum)
  for i,j in ipairs(bigIdxList) do
    arr[maxNum - i + 1] = arr[j]
  end
  return arr
end

ActivitySectorIData.GetBigIdx = function(fixRandom, randomPoolData)
  -- function num : 0_14 , upvalues : _ENV
  local outList = {}
  local i = 0
  do
    while i < randomPoolData.bigNum do
      local j = fixRandom:RandUInt(0, randomPoolData.bigRewardSecB - randomPoolData.bigRewardSecA) + randomPoolData.bigRewardSecA
      j = j + 1
      for k,v in pairs(outList) do
      end
      if j ~= v then
        (table.insert)(outList, j)
        i = i + 1
      end
    end
    return outList
  end
end

ActivitySectorIData.GenShuffle = function(randomPoolData, randomSeed, start, count, callback)
  -- function num : 0_15 , upvalues : _ENV, cs_FixRandom, ActivitySectorIData
  local total = start + count
  if #randomPoolData.arr < total then
    error("Shuffle out of range")
    return 
  end
  local fixRandom = cs_FixRandom(randomSeed)
  local arr = (ActivitySectorIData.ShuffleRandomPool)(randomPoolData, fixRandom)
  for i = start + 1, total do
    local id = (randomPoolData.arr)[arr[i]]
    if callback ~= nil then
      callback(id)
    end
  end
end

ActivitySectorIData._GenShuffleDataPool = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local bigNum = 0
  local bigRewardIdDic = {}
  for k,rewardId in ipairs((self.poolParaCfg).reward_id) do
    local bigRewardCfg = ((self.poolParaCfg).poolContent)[rewardId]
    bigNum = bigNum + bigRewardCfg.num
    bigRewardIdDic[rewardId] = true
  end
  local randomPoolData = {
arr = {}
, bigNum = bigNum, bigRewardSecA = ((self.poolParaCfg).section)[1], bigRewardSecB = ((self.poolParaCfg).section)[2]}
  for k,v in pairs((self.poolParaCfg).poolContent) do
    for i = 1, v.num do
      (table.insert)(randomPoolData.arr, k)
    end
  end
  ;
  (table.sort)(randomPoolData.arr, function(a, b)
    -- function num : 0_16_0 , upvalues : bigRewardIdDic
    local aIsBig = bigRewardIdDic[a]
    local bIsBig = bigRewardIdDic[b]
    if aIsBig ~= bIsBig then
      return bIsBig
    end
    do return a < b end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  return randomPoolData
end

ActivitySectorIData.GenActSectorIRewardExchanged = function(self)
  -- function num : 0_17 , upvalues : _ENV, ActivitySectorIData
  local randomPoolData = self:_GenShuffleDataPool()
  local pickedRewardPoolIdDic = (table.GetDefaulValueTable)(0)
  ;
  (ActivitySectorIData.GenShuffle)(randomPoolData, self.randomSeed, 0, self.roundIndex, function(id)
    -- function num : 0_17_0 , upvalues : pickedRewardPoolIdDic
    pickedRewardPoolIdDic[id] = pickedRewardPoolIdDic[id] + 1
  end
)
  return pickedRewardPoolIdDic
end

ActivitySectorIData.CheckShuffleResult = function(self, startIdx, count, rewardList)
  -- function num : 0_18 , upvalues : ActivitySectorIData, _ENV
  local pickedRewardList = {}
  local randomPoolData = self:_GenShuffleDataPool()
  ;
  (ActivitySectorIData.GenShuffle)(randomPoolData, self.randomSeed, startIdx, count, function(id)
    -- function num : 0_18_0 , upvalues : _ENV, pickedRewardList
    (table.insert)(pickedRewardList, id)
  end
)
  if #rewardList ~= #pickedRewardList then
    error("Num error")
  end
  for k,rewardId in ipairs(pickedRewardList) do
    if rewardList[k] ~= nil and (rewardList[k]).elemNumber ~= rewardId then
      warn((string.format)("Check shuffle result failed,idx:%s,client:%s,server:%s", k, rewardId, (rewardList[k]).elemNumber))
    end
  end
end

ActivitySectorIData.GetMainWindowIsFirstInit = function(self)
  -- function num : 0_19
  if self._mainWinIsFirst == nil then
    self._mainWinIsFirst = true
  end
  return self._mainWinIsFirst
end

ActivitySectorIData.SetMainWindowIsFirstInit = function(self, bool)
  -- function num : 0_20
  self._mainWinIsFirst = bool
end

ActivitySectorIData.GetChapterPosList = function(self)
  -- function num : 0_21
  return (self._cfg).chapterPosList
end

ActivitySectorIData.GetChapterHasUnlock = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local unlock = true
  if (self._cfg).down_time ~= nil and PlayerDataCenter.timestamp < (self._cfg).down_time then
    unlock = false
  end
  return unlock, (self._cfg).down_time
end

return ActivitySectorIData

