-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopData_timeLimitComp = class("ShopData_timeLimitComp")
ShopData_timeLimitComp.ctor = function(self)
  -- function num : 0_0
end

ShopData_timeLimitComp.UpdateShopDataComp = function(self, shopData, shopDataMsg)
  -- function num : 0_1
  self.shopData = shopData
  self:__RemoveShopGoods()
end

ShopData_timeLimitComp.GetNeedRefreshGoodsTs = function(self)
  -- function num : 0_2
  return (self.shopData).needRefreshGoodsTs
end

ShopData_timeLimitComp.__RemoveShopGoods = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (self.shopData).needRefreshGoodsTs = math.maxinteger
  for shelfId,goodData in pairs((self.shopData).shopGoodsDic) do
    local hasTimeLimit, inTime, startTime, endTime = goodData:GetStillTime()
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R10 in 'UnsetPending'

    if hasTimeLimit then
      if inTime then
        (self.shopData).needRefreshGoodsTs = (math.min)((self.shopData).needRefreshGoodsTs, endTime)
      else
        -- DECOMPILER ERROR at PC35: Confused about usage of register: R10 in 'UnsetPending'

        if PlayerDataCenter.timestamp < startTime then
          (self.shopData).needRefreshGoodsTs = (math.min)((self.shopData).needRefreshGoodsTs, startTime)
        end
        -- DECOMPILER ERROR at PC38: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((self.shopData).shopGoodsDic)[shelfId] = nil
      end
    end
  end
end

return ShopData_timeLimitComp

