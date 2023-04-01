-- params : ...
-- function num : 0 , upvalues : _ENV
local RoundlotteryData = class("RoundlotteryData")
local cs_FixRandom = CS.FixRandom
RoundlotteryData.InitFackerPoolLotteryData = function(self, poolId)
  -- function num : 0_0 , upvalues : _ENV
  self.roundId = poolId
  self.randomSeed = 0
  self.roundTimes = 0
  self.roundIndex = 0
  self.poolParaCfg = (ConfigData.activity_time_limit_pool_para)[self.roundId]
end

RoundlotteryData.UpdateRewardPoolLotteryData = function(self, roundMsg)
  -- function num : 0_1 , upvalues : _ENV
  local lastIndex = self.roundIndex
  self.roundId = roundMsg.roundId
  self.randomSeed = roundMsg.roundSeed
  self.roundTimes = roundMsg.roundTimes
  self.roundIndex = roundMsg.roundIndex
  self.poolParaCfg = (ConfigData.activity_time_limit_pool_para)[self.roundId]
  if lastIndex or 0 ~= self.roundIndex then
    self._history = self:GenRoundRewardExchanged()
  end
end

RoundlotteryData.GetRoundId = function(self)
  -- function num : 0_2
  return self.roundId
end

RoundlotteryData.GetRoundTimes = function(self)
  -- function num : 0_3
  return self.roundIndex
end

RoundlotteryData.GetPoolParaCfg = function(self)
  -- function num : 0_4
  return self.poolParaCfg
end

RoundlotteryData.GetRoundTotalTimes = function(self)
  -- function num : 0_5
  return (self.poolParaCfg).allRewardNum
end

RoundlotteryData.GetRoundRemainTimes = function(self)
  -- function num : 0_6
  return (self.poolParaCfg).allRewardNum - self.roundIndex
end

RoundlotteryData.GetRoundSingleRewardCount = function(self, rewardId)
  -- function num : 0_7
  local content = ((self.poolParaCfg).poolContent)[rewardId]
  local allNum = content.num
  if self._history == nil then
    return 0, allNum
  end
  local usedNum = (self._history)[rewardId] or 0
  return usedNum, allNum
end

RoundlotteryData.IsSoldOutRoundBigReward = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local bigRewardIds = (self.poolParaCfg).reward_id
  for i,rewardId in ipairs(bigRewardIds) do
    local content = ((self.poolParaCfg).poolContent)[rewardId]
    if (self._history)[rewardId] or self._history == nil or 0 < content.num then
      return false
    end
  end
  return true
end

RoundlotteryData.GetUniqRandsWithSourceShuffleQuantity = function(fixRandom, normalNum, maxNum)
  -- function num : 0_9 , upvalues : _ENV
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

RoundlotteryData.ShuffleRandomPool = function(randomPoolData, fixRandom)
  -- function num : 0_10 , upvalues : RoundlotteryData, _ENV
  local maxNum = #randomPoolData.arr
  local size = maxNum - randomPoolData.bigNum
  local bigIdxList = (RoundlotteryData.GetBigIdx)(fixRandom, randomPoolData)
  local arr = (RoundlotteryData.GetUniqRandsWithSourceShuffleQuantity)(fixRandom, size, maxNum)
  for i,j in ipairs(bigIdxList) do
    arr[maxNum - i + 1] = arr[j]
  end
  return arr
end

RoundlotteryData.GetBigIdx = function(fixRandom, randomPoolData)
  -- function num : 0_11 , upvalues : _ENV
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

RoundlotteryData.GenShuffle = function(randomPoolData, randomSeed, start, count, callback)
  -- function num : 0_12 , upvalues : _ENV, cs_FixRandom, RoundlotteryData
  local total = start + count
  if #randomPoolData.arr < total then
    error("Shuffle out of range")
    return 
  end
  local fixRandom = cs_FixRandom(randomSeed)
  local arr = (RoundlotteryData.ShuffleRandomPool)(randomPoolData, fixRandom)
  for i = start + 1, total do
    local id = (randomPoolData.arr)[arr[i]]
    if callback ~= nil then
      callback(id)
    end
  end
end

RoundlotteryData._GenShuffleDataPool = function(self)
  -- function num : 0_13 , upvalues : _ENV
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
    -- function num : 0_13_0 , upvalues : bigRewardIdDic
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

RoundlotteryData.GenRoundRewardExchanged = function(self)
  -- function num : 0_14 , upvalues : _ENV, RoundlotteryData
  local randomPoolData = self:_GenShuffleDataPool()
  local pickedRewardPoolIdDic = (table.GetDefaulValueTable)(0)
  ;
  (RoundlotteryData.GenShuffle)(randomPoolData, self.randomSeed, 0, self.roundIndex, function(id)
    -- function num : 0_14_0 , upvalues : pickedRewardPoolIdDic
    pickedRewardPoolIdDic[id] = pickedRewardPoolIdDic[id] + 1
  end
)
  return pickedRewardPoolIdDic
end

RoundlotteryData.CheckShuffleResult = function(self, startIdx, count, rewardList)
  -- function num : 0_15 , upvalues : RoundlotteryData, _ENV
  local pickedRewardList = {}
  local randomPoolData = self:_GenShuffleDataPool()
  ;
  (RoundlotteryData.GenShuffle)(randomPoolData, self.randomSeed, startIdx, count, function(id)
    -- function num : 0_15_0 , upvalues : _ENV, pickedRewardList
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

return RoundlotteryData

