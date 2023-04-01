-- params : ...
-- function num : 0 , upvalues : _ENV
local AllLtrPoolData = class("AllLtrPoolData")
local LotteryPoolData = require("Game.Lottery.Data.LotteryPoolData")
local LotteryPoolGroupData = require("Game.Lottery.Data.LotteryPoolGroupData")
AllLtrPoolData.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._OnLtrDayNumUpdateFunc = BindCallback(self, self._OnLtrDayNumUpdate)
  self:InitAllLtrPoolData()
end

AllLtrPoolData.InitAllLtrPoolData = function(self)
  -- function num : 0_1
  self.ltrDataDic = {}
  self.ltrRecords = {}
  self.ltrSpecial = {}
  self.ltrGroupSelectTagDic = {}
  self.__maxRecords = 20
end

AllLtrPoolData.OpenLtrPoolData = function(self, activityFrameData)
  -- function num : 0_2 , upvalues : LotteryPoolData
  local ltrId = activityFrameData:GetActId()
  local ltrData = (LotteryPoolData.New)(ltrId)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.ltrDataDic)[ltrId] = ltrData
  self:_UpdLtrPoolRedDot(ltrData)
end

AllLtrPoolData.CloseLtrPoolData = function(self, activityFrameData)
  -- function num : 0_3
  local ltrId = activityFrameData:GetActId()
  local ltrData = (self.ltrDataDic)[ltrId]
  if ltrData ~= nil then
    (self:GetLtrRedDotNode()):RemoveChild(ltrData.poolId)
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.ltrDataDic)[ltrId] = nil
end

AllLtrPoolData.GetLtrRedDotNode = function(self)
  -- function num : 0_4 , upvalues : _ENV
  do
    if self._ltrRedNode == nil then
      local ok, ltrRedNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.LotteryPr)
      self._ltrRedNode = ltrRedNode
    end
    return self._ltrRedNode
  end
end

AllLtrPoolData._UpdLtrPoolRedDot = function(self, ltrData)
  -- function num : 0_5 , upvalues : _ENV
  if ltrData:IsLtrHasTenPrior() then
    local poolNode = (self:GetLtrRedDotNode()):AddChildWithPath(ltrData.poolId, RedDotDynPath.LotteryPrPoolPath)
    local ltrTenNode = poolNode:AddChild(RedDotStaticTypeId.LotteryTen)
    local ltrTenPriorNode = ltrTenNode:AddChild(RedDotStaticTypeId.LotteryTenPrior)
    ltrTenPriorNode:SetRedDotCount(ltrData:LtrCurTenIsPrior() and 1 or 0)
  end
end

AllLtrPoolData.UpdAllLtrPoolRedDot = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for ltrId,ltrData in pairs(self.ltrDataDic) do
    self:_UpdLtrPoolRedDot(ltrData)
  end
end

AllLtrPoolData.UpdSpecialAndRecordsData = function(self, specialMissFix, records)
  -- function num : 0_7 , upvalues : _ENV
  if specialMissFix ~= nil then
    for k,v in pairs(specialMissFix) do
      -- DECOMPILER ERROR at PC9: Confused about usage of register: R8 in 'UnsetPending'

      (self.ltrSpecial)[v.id] = v.miss
    end
  end
  do
    if #records > 0 then
      local ltrRecords = {}
      for k,v in ipairs(records) do
        (table.insert)(ltrRecords, 1, v)
      end
      self.ltrRecords = ltrRecords
    end
  end
end

AllLtrPoolData.UpdGroupSelectTagData = function(self, tags)
  -- function num : 0_8 , upvalues : _ENV
  if tags == nil then
    return 
  end
  for i,v in ipairs(tags) do
    local tempGroupPoolId = v >> 32
    local tempPoolId = v & CommonUtil.UInt32Max
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.ltrGroupSelectTagDic)[tempGroupPoolId] = tempPoolId
  end
end

AllLtrPoolData.UpdAllLtrPoolData = function(self, detail)
  -- function num : 0_9 , upvalues : _ENV
  local addDayNumUpdEvent = false
  for ltrId,v in pairs(detail) do
    local ltrData = (self.ltrDataDic)[ltrId]
    if ltrData ~= nil then
      ltrData:UpdLtrPoolData(v)
      local ts = ltrData:GetLtrPoolDayNumUpdateTimestamp()
      if ts > 0 and (self._dayNumEarlistUpdateTs == nil or ts < self._dayNumEarlistUpdateTs) then
        self._dayNumEarlistUpdateTs = ts
        addDayNumUpdEvent = true
      end
    end
  end
  if addDayNumUpdEvent then
    local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass, true)
    timePassCtrl:RemoveEventTimer(self._updDayNumEventId)
    self._updDayNumEventId = timePassCtrl:AddEventTimer(self._dayNumEarlistUpdateTs, self._OnLtrDayNumUpdateFunc)
  end
end

AllLtrPoolData._OnLtrDayNumUpdate = function(self)
  -- function num : 0_10 , upvalues : _ENV
  self._dayNumEarlistUpdateTs = nil
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Lottery)):CS_LOTTERY_Detail()
end

AllLtrPoolData.SetDrawHeroRankCount = function(self, drawHeroRankCount)
  -- function num : 0_11
  self.drawHeroRankCount = drawHeroRankCount
end

AllLtrPoolData.IsDrawHeroRankCountAboveZero = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if (PlayerDataCenter.allLtrData).drawHeroRankCount ~= nil and (PlayerDataCenter.allLtrData).drawHeroRankCount > 0 then
    return true
  end
end

AllLtrPoolData.GetOpeningLtrPoolDataList = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local ltrDataList = {}
  for ltrId,ltrData in pairs(self.ltrDataDic) do
    if ltrData:IsLtrPoolOpen() then
      (table.insert)(ltrDataList, ltrData)
    end
  end
  return ltrDataList
end

AllLtrPoolData.TryGetOpenLotteryGroup = function(self, letteryId)
  -- function num : 0_14 , upvalues : _ENV
  local groupId = self:TryGetLtrGroupId(letteryId)
  local ltrGroupCfg = (ConfigData.lottery_group)[groupId]
  local ltrGroupDataList = {}
  for idx,grpLtrId in ipairs(ltrGroupCfg.list) do
    if self:GetIsSpecificPoolOpen(grpLtrId) then
      (table.insert)(ltrGroupDataList, (self.ltrDataDic)[grpLtrId])
    end
  end
  return ltrGroupDataList
end

AllLtrPoolData.GetOpeningLtrGroupPoolDataList = function(self)
  -- function num : 0_15 , upvalues : _ENV, LotteryPoolGroupData
  local inGroupIdDic = {}
  local ltrGroupDataList = {}
  for ltrId,ltrData in pairs(self.ltrDataDic) do
    if ltrData:IsLtrPoolOpen() then
      local groupId = ((ConfigData.lottery_group).ltrGroupIdMap)[ltrId]
      if groupId == nil then
        local ltrGroupData = (LotteryPoolGroupData.New)(ltrData)
        ;
        (table.insert)(ltrGroupDataList, ltrGroupData)
      else
        do
          if inGroupIdDic[groupId] == nil then
            inGroupIdDic[groupId] = true
            local ltrGroupCfg = (ConfigData.lottery_group)[groupId]
            local firstPoolData = nil
            local inGroupNum = 0
            for idx,grpLtrId in ipairs(ltrGroupCfg.list) do
              if self:GetIsSpecificPoolOpen(grpLtrId) then
                inGroupNum = inGroupNum + 1
                if inGroupNum == 1 then
                  firstPoolData = (self.ltrDataDic)[grpLtrId]
                end
              end
            end
            local ltrGroupData = nil
            if inGroupNum > 1 then
              ltrGroupData = (LotteryPoolGroupData.New)(firstPoolData, groupId)
            else
              ltrGroupData = (LotteryPoolGroupData.New)(ltrData)
            end
            ;
            (table.insert)(ltrGroupDataList, ltrGroupData)
          end
          do
            -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  ;
  (table.sort)(ltrGroupDataList, function(a, b)
    -- function num : 0_15_0 , upvalues : _ENV
    do return ((ConfigData.lottery_para)[(a.ltrPoolData).poolId]).line < ((ConfigData.lottery_para)[(b.ltrPoolData).poolId]).line end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  return ltrGroupDataList
end

AllLtrPoolData.TryGetLtrGroupId = function(self, ltrId)
  -- function num : 0_16 , upvalues : _ENV
  return ((ConfigData.lottery_group).ltrGroupIdMap)[ltrId]
end

AllLtrPoolData.GetIsSpecificPoolOpen = function(self, ltrId)
  -- function num : 0_17
  local ltrData = (self.ltrDataDic)[ltrId]
  if ltrData == nil then
    return false
  end
  return ltrData:IsLtrPoolOpen()
end

AllLtrPoolData.GetIsSelectByGroupId = function(self, groupPoolId)
  -- function num : 0_18
  if (self.ltrGroupSelectTagDic)[groupPoolId] ~= nil then
    return (self.ltrGroupSelectTagDic)[groupPoolId]
  end
  return 0
end

AllLtrPoolData.SetIsSelectSuccess = function(self, poolGroupId, newPoolId)
  -- function num : 0_19
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.ltrGroupSelectTagDic)[poolGroupId] = newPoolId
end

return AllLtrPoolData

