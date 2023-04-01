-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityRoundData = class("ActivityRoundData", ActivityBase)
local RoundDataLottery = require("Game.ActivityRound.RoundDataLottery")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
ActivityRoundData.InitRoundData = function(self, msg)
  -- function num : 0_0 , upvalues : ActivityFrameEnum, _ENV, RoundDataLottery
  self:SetActFrameDataByType((ActivityFrameEnum.eActivityType).Round, msg.actId)
  self._id = msg.actId
  self._curRound = msg.curRoundId
  local frameId = self:GetActFrameId()
  self._roundPoolIds = ((ConfigData.activity_time_limit_pool_para).poolDic)[frameId]
  self._roundPoolDic = {}
  self._fakerPoolDic = {}
  for index,poolId in ipairs(self._roundPoolIds) do
    local poolMsg = (msg.rounds)[index]
    if poolMsg ~= nil then
      local data = (RoundDataLottery.New)()
      data:UpdateRewardPoolLotteryData(poolMsg)
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self._roundPoolDic)[poolMsg.roundId] = data
    else
      do
        do
          local data = (RoundDataLottery.New)()
          data:InitFackerPoolLotteryData(poolId)
          -- DECOMPILER ERROR at PC43: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (self._fakerPoolDic)[poolId] = data
          -- DECOMPILER ERROR at PC44: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC44: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC44: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  self:UpdateActFrameDataSingleMsg(msg)
end

ActivityRoundData.UpdateRoundData = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV, RoundDataLottery
  self._curRound = msg.curRoundId
  for _,roundMsg in ipairs(msg.rounds) do
    local data = (self._roundPoolDic)[roundMsg.roundId]
    if data ~= nil then
      data:UpdateRewardPoolLotteryData(roundMsg)
    else
      data = (self._fakerPoolDic)[roundMsg.roundId]
      if data ~= nil then
        data:UpdateRewardPoolLotteryData(roundMsg)
        -- DECOMPILER ERROR at PC25: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self._roundPoolDic)[roundMsg.roundId] = data
        -- DECOMPILER ERROR at PC28: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self._fakerPoolDic)[roundMsg.roundId] = nil
      else
        data = (RoundDataLottery.New)()
        data:UpdateRewardPoolLotteryData(roundMsg)
        -- DECOMPILER ERROR at PC38: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self._roundPoolDic)[roundMsg.roundId] = data
      end
    end
  end
end

ActivityRoundData.GetRoundIds = function(self)
  -- function num : 0_2
  return self._roundPoolIds
end

ActivityRoundData.GetCurRoundId = function(self)
  -- function num : 0_3
  return self._curRound
end

ActivityRoundData.GetRoundPoolData = function(self, roundId)
  -- function num : 0_4
  if (self._roundPoolDic)[roundId] ~= nil then
    return (self._roundPoolDic)[roundId]
  else
    return (self._fakerPoolDic)[roundId]
  end
end

ActivityRoundData.GetRoundActId = function(self)
  -- function num : 0_5
  return self._id
end

ActivityRoundData.IsUnlockPool = function(self, id)
  -- function num : 0_6
  do return (self._roundPoolDic)[id] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityRoundData.AllowReqRoundPool = function(self, poolId)
  -- function num : 0_7 , upvalues : _ENV
  if (self._fakerPoolDic)[poolId] == nil then
    return false
  end
  local index = (table.indexof)(self._roundPoolIds, poolId)
  if index then
    index = index - 1
    local prePoolId = (self._roundPoolIds)[index]
    if prePoolId == nil or (self._roundPoolDic)[prePoolId] == nil then
      return 
    end
    local poolData = (self._roundPoolDic)[prePoolId]
    return poolData:IsSoldOutRoundBigReward()
  end
  do
    return false
  end
end

return ActivityRoundData

