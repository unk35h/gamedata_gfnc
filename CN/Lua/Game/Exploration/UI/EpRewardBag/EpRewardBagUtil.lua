-- params : ...
-- function num : 0 , upvalues : _ENV
local EpRewardBagUtil = {}
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local GetEpRewardBagStateType = function(epModuleId, stageId)
  -- function num : 0_0 , upvalues : _ENV, ExplorationEnum
  if epModuleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
    local cfg = (ConfigData.sector_stage)[stageId]
    if cfg == nil then
      error("sector stage is null,id:" .. tostring(stageId))
      return 0
    end
    if cfg.difficulty == (ExplorationEnum.eDifficultType).Normal then
      return 1
    else
      if cfg.difficulty == (ExplorationEnum.eDifficultType).Hard then
        return 2
      else
        error("Unsupported exploration difficulty, difficulty = " .. tostring(cfg.difficulty))
        return 0
      end
    end
  else
    do
      if epModuleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Endless then
        return 3
      else
        if epModuleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess then
          return 4
        else
          if epModuleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason then
            return 5
          end
        end
      end
    end
  end
end

EpRewardBagUtil.GetEpRewardItemPrice = function(itemId, epModuleId, stageId, num, original)
  -- function num : 0_1 , upvalues : GetEpRewardBagStateType, _ENV
  local stateType = GetEpRewardBagStateType(epModuleId, stageId)
  if stateType == nil then
    error((string.format)("EpModuleId is invalid,EpModuleId = %s, itemId = %s, stateType = %s", epModuleId, itemId, stateType))
    return 0, nil
  end
  local stageTypeDic = ((ConfigData.reward_purchase).rewardPurchaseDic)[itemId]
  if stageTypeDic == nil then
    error((string.format)("Cant get reward_purchase cfg, itemId = %s, stateType = %s", itemId, stateType))
    return 0, nil
  end
  local stageIdList = stageTypeDic[stateType]
  if stageIdList == nil then
    error((string.format)("Cant get reward_purchase cfg, itemId = %s, stateType = %s", itemId, stateType))
    return 0, nil
  end
  local price = 0
  local costItemId = nil
  if original then
    local id = stageIdList[1]
    local cfg = (ConfigData.reward_purchase)[id]
    price = cfg.item_price
    costItemId = cfg.currency
  else
    do
      for k,v in ipairs(stageIdList) do
        local curCfg = (ConfigData.reward_purchase)[v]
        local nextCfg = (ConfigData.reward_purchase)[stageIdList[k + 1]]
        if nextCfg == nil then
          price = curCfg.item_price
          costItemId = curCfg.currency
          break
        end
        if stageId < nextCfg.stage_id then
          price = curCfg.item_price
          costItemId = curCfg.currency
          break
        end
      end
      do
        return price * num, costItemId
      end
    end
  end
end

EpRewardBagUtil.GetEpRewardItemPriceStr = function(self, price)
  -- function num : 0_2 , upvalues : _ENV
  local dividend = (ConfigData.game_config).staminaDividend / 10
  local value = (math.ceil)(price / dividend)
  value = FormatNum(value / 10)
  return tostring(value)
end

EpRewardBagUtil.GetEpRewardCurrencyId = function(self, epModuleId, stageId)
  -- function num : 0_3 , upvalues : _ENV, GetEpRewardBagStateType
  local defaultId = ConstGlobalItem.SKey
  local stateType = GetEpRewardBagStateType(epModuleId, stageId)
  if stateType == nil then
    error((string.format)("EpModuleId is invalid,EpModuleId = %s, stageId = %s", epModuleId, stageId))
    return defaultId
  end
  local stageCurrencyList = ((ConfigData.reward_purchase).currencyIndexDic)[stateType]
  if stageCurrencyList == nil then
    error((string.format)("stageCurrencyList == nil, EpModuleId = %s, stageId = %s", epModuleId, stageId))
    return defaultId
  end
  local currencyId = 0
  for k,curCfg in ipairs(stageCurrencyList) do
    local nextCfg = stageCurrencyList[k + 1]
    if nextCfg == nil then
      currencyId = curCfg.currencyId
      break
    end
    if stageId < nextCfg.stageId then
      currencyId = curCfg.currencyId
      break
    end
  end
  do
    if currencyId == 0 then
      return defaultId
    end
    return currencyId
  end
end

return EpRewardBagUtil

