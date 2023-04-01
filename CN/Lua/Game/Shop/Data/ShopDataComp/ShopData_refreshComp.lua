-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopData_refreshComp = class("ShopData_refreshComp")
ShopData_refreshComp.ctor = function(self)
  -- function num : 0_0
end

ShopData_refreshComp.UpdateShopDataComp = function(self, shopData, shopDataMsg)
  -- function num : 0_1 , upvalues : _ENV
  self.shopData = shopData
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.shopData).couldFresh = false
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.shopData).couldFreshCount = 0
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  if shopDataMsg.freeFreshTm or shopDataMsg == nil or 0 > 0 then
    (self.shopData).freeFreshTm = shopDataMsg.freeFreshTm
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.shopData).freshCount = shopDataMsg.freshCount
  else
    local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass)
    local counterEltReset = timePassCtrl:getCounterElemData(proto_object_CounterModule.CounterModuleStorePurchaseResetTimes, (self.shopData).shopId)
    local counterEltSys = timePassCtrl:getCounterElemData(proto_object_CounterModule.CounterModuleStoreSystemReset, (self.shopData).shopId)
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

    if counterEltSys == nil then
      (self.shopData).isRefreshShop = false
      error("Cant get refrshTm, shopId:" .. tostring((self.shopData).shopId))
      return 
    end
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R6 in 'UnsetPending'

    if counterEltReset == nil or counterEltReset.nextExpiredTm < counterEltSys.nextExpiredTm then
      (self.shopData).freshCount = 0
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.shopData).freeFreshTm = counterEltSys.nextExpiredTm
    else
      -- DECOMPILER ERROR at PC64: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.shopData).freshCount = counterEltReset.times
      -- DECOMPILER ERROR at PC67: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.shopData).freeFreshTm = counterEltReset.nextExpiredTm
    end
    for shelfId,goodData in pairs((self.shopData).shopGoodsDic) do
      local counterId = (self.shopData).shopId << 32 | shelfId
      local counterEltGood = timePassCtrl:getCounterElemData(proto_object_CounterModule.CounterModuleStoreShelfPurchaseLimit, counterId)
      -- DECOMPILER ERROR at PC94: Confused about usage of register: R13 in 'UnsetPending'

      if counterEltGood ~= nil and goodData.purchases > 0 and counterEltGood.nextExpiredTm < (self.shopData).freeFreshTm then
        (self.shopData).freeFreshTm = counterEltGood.nextExpiredTm
      end
    end
  end
  do
    local refresh_times = ((self.shopData).shopCfg).refresh_times
    -- DECOMPILER ERROR at PC101: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.shopData).couldFreshCount = 0
    if #refresh_times ~= 0 then
      for i,refreshTime in ipairs(refresh_times) do
        -- DECOMPILER ERROR at PC112: Confused about usage of register: R9 in 'UnsetPending'

        if refreshTime >= 0 then
          (self.shopData).couldFreshCount = refreshTime
        else
          -- DECOMPILER ERROR at PC115: Confused about usage of register: R9 in 'UnsetPending'

          ;
          (self.shopData).couldFreshCount = "∞"
        end
      end
      for i,refreshTime in ipairs(refresh_times) do
        if (self.shopData).freshCount < refreshTime or refreshTime == -1 then
          local costId = ((self.shopData).shopCfg).refreshCostId
          local costNum = (((self.shopData).shopCfg).refreshCostNum)[i]
          -- DECOMPILER ERROR at PC139: Confused about usage of register: R11 in 'UnsetPending'

          ;
          (self.shopData).refreshCost = {costId = costId, costNum = costNum}
          -- DECOMPILER ERROR at PC141: Confused about usage of register: R11 in 'UnsetPending'

          ;
          (self.shopData).couldFresh = true
          break
        end
      end
      do
        -- DECOMPILER ERROR at PC156: Confused about usage of register: R4 in 'UnsetPending'

        if (self.shopData).refreshCost == nil then
          (self.shopData).refreshCost = {costId = ((self.shopData).shopCfg).refreshCostId, costNum = -1}
        end
      end
    end
  end
end

ShopData_refreshComp.GetCouldRefresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isAbleRefresh = false
  local refreshCostId, refreshCostNum = nil, nil
  if #((self.shopData).shopCfg).refresh_times ~= 0 then
    for index,refreshTime in ipairs((self.shopCfg).refresh_times) do
      if (self.shopData).freshCount < refreshTime or refreshTime == -1 then
        isAbleRefresh = true
        refreshCostNum = (((self.shopData).shopCfg).refreshCostNum)[index]
        refreshCostId = ((self.shopData).shopCfg).refreshCostId
        break
      end
    end
  end
  do
    return isAbleRefresh, refreshCostId, refreshCostNum
  end
end

ShopData_refreshComp.GetRemainAutoRefreshTime = function(self, needZero)
  -- function num : 0_3 , upvalues : _ENV
  if needZero then
    return (math.max)((self.shopData).freeFreshTm - PlayerDataCenter.timestamp, 0)
  end
  return (self.shopData).freeFreshTm - PlayerDataCenter.timestamp
end

return ShopData_refreshComp

