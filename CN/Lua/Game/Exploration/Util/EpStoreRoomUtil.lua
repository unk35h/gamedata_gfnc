-- params : ...
-- function num : 0 , upvalues : _ENV
local EpStoreRoomUtil = {}
EpStoreRoomUtil.GetFinalRefreshPriceWithOriginPrice = function(originPrice)
  -- function num : 0_0 , upvalues : _ENV
  if originPrice == nil then
    return 0
  end
  if ExplorationManager == nil then
    return 0
  end
  local serverArg = 100
  local dynPlayer = ExplorationManager:GetDynPlayer()
  if dynPlayer ~= nil then
    serverArg = dynPlayer:GetEpStoreRefreshCommonPriceArg()
  end
  return originPrice * serverArg // 100
end

EpStoreRoomUtil.GetFinalChipItemBuyPriceWithOriginPrice = function(originPrice)
  -- function num : 0_1 , upvalues : _ENV
  if originPrice == nil then
    return 0
  end
  if ExplorationManager == nil then
    return 0
  end
  local serverArg = 100
  local dynPlayer = ExplorationManager:GetDynPlayer()
  if dynPlayer ~= nil then
    serverArg = dynPlayer:GetChipItemCommonPriceArg()
  end
  return originPrice * serverArg // 100
end

return EpStoreRoomUtil

