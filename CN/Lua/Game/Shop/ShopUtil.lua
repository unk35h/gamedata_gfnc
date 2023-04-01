-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopUtil = {}
local ShopEnum = require("Game.Shop.ShopEnum")
ShopUtil.CommonSortGoodList = function(dataList)
  -- function num : 0_0 , upvalues : _ENV
  (table.sort)(dataList, function(a, b)
    -- function num : 0_0_0
    if b.currencyId >= a.currencyId then
      do return a.currencyId == b.currencyId end
      if a.discount >= b.discount then
        do return a.discount == b.discount end
        if a.order >= b.order then
          do return a.order == b.order end
          do return a.shelfId < b.shelfId end
          -- DECOMPILER ERROR: 7 unprocessed JMP targets
        end
      end
    end
  end
)
end

local RefreshShopSorter = function(a, b)
  -- function num : 0_1 , upvalues : _ENV
  if a.isSoldOut ~= b.isSoldOut then
    return not a.isSoldOut
  end
  if a.isSoldOut then
    local aIsLimitHold = PlayerDataCenter:IsItemLimitHold(a.itemId)
    local bIsLimitHold = PlayerDataCenter:IsItemLimitHold(b.itemId)
    if aIsLimitHold ~= bIsLimitHold then
      return aIsLimitHold
    end
    if a:IsReplenishGoodsAndCount() ~= b:IsReplenishGoodsAndCount() then
      return a:IsReplenishGoodsAndCount()
    end
  end
  do
    local aFragMax = false
    local bFragMax = false
    do
      if (a.itemCfg).action_type == eItemActionType.HeroCardFrag then
        local heroData = (PlayerDataCenter.heroDic)[((a.itemCfg).arg)[1]]
        if heroData ~= nil and heroData:GetMaxNeedFragNum(true) <= 0 then
          aFragMax = true
        end
      end
      do
        if (b.itemCfg).action_type == eItemActionType.HeroCardFrag then
          local heroData = (PlayerDataCenter.heroDic)[((b.itemCfg).arg)[1]]
          if heroData ~= nil and heroData:GetMaxNeedFragNum(true) <= 0 then
            bFragMax = true
          end
        end
        if aFragMax ~= bFragMax then
          return bFragMax
        end
        if b.currencyId >= a.currencyId then
          do return a.currencyId == b.currencyId end
          if a.discount >= b.discount then
            do return a.discount == b.discount end
            if a.order >= b.order then
              do return a.order == b.order end
              do return a.shelfId < b.shelfId end
              -- DECOMPILER ERROR: 7 unprocessed JMP targets
            end
          end
        end
      end
    end
  end
end

local NonRefreshShopSorter = function(a, b)
  -- function num : 0_2 , upvalues : _ENV
  if a.isSoldOut ~= b.isSoldOut then
    return not a.isSoldOut
  end
  if a.isSoldOut then
    local aIsLimitHold = PlayerDataCenter:IsItemLimitHold(a.itemId)
    local bIsLimitHold = PlayerDataCenter:IsItemLimitHold(b.itemId)
    if aIsLimitHold ~= bIsLimitHold then
      return aIsLimitHold
    end
    if a:IsReplenishGoodsAndCount() ~= b:IsReplenishGoodsAndCount() then
      return a:IsReplenishGoodsAndCount()
    end
  end
  do
    local aFragMax = false
    local bFragMax = false
    do
      if (a.itemCfg).action_type == eItemActionType.HeroCardFrag then
        local heroData = (PlayerDataCenter.heroDic)[((a.itemCfg).arg)[1]]
        if heroData ~= nil and heroData:GetMaxNeedFragNum(true) <= 0 then
          aFragMax = true
        end
      end
      do
        if (b.itemCfg).action_type == eItemActionType.HeroCardFrag then
          local heroData = (PlayerDataCenter.heroDic)[((b.itemCfg).arg)[1]]
          if heroData ~= nil and heroData:GetMaxNeedFragNum(true) <= 0 then
            bFragMax = true
          end
        end
        if aFragMax ~= bFragMax then
          return bFragMax
        end
        if a.order >= b.order then
          do return a.order == b.order end
          if b.currencyId >= a.currencyId then
            do return a.currencyId == b.currencyId end
            if a.discount >= b.discount then
              do return a.discount == b.discount end
              do return a.shelfId < b.shelfId end
              -- DECOMPILER ERROR: 7 unprocessed JMP targets
            end
          end
        end
      end
    end
  end
end

ShopUtil.CommonAndFragSrotGoodList = function(dataList, isRefeshShop)
  -- function num : 0_3 , upvalues : _ENV, RefreshShopSorter, NonRefreshShopSorter
  if isRefeshShop then
    (table.sort)(dataList, RefreshShopSorter)
  else
    ;
    (table.sort)(dataList, NonRefreshShopSorter)
  end
end

ShopUtil.GetSkinShopIdList = function()
  -- function num : 0_4 , upvalues : _ENV
  local needStoreList = {}
  if FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store) then
    for k,shopId in ipairs((ConfigData.skin).skinShopIds) do
      local shopCfg = (ConfigData.shop)[shopId]
      if (CheckCondition.CheckLua)(shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2) then
        (table.insert)(needStoreList, shopId)
      end
    end
  end
  do
    return needStoreList
  end
end

local ShopCurrencyGiftCheck = {[ConstGlobalItem.BpSkinCoin] = function()
  -- function num : 0_5 , upvalues : _ENV
  for _,passInfo in pairs((PlayerDataCenter.battlepassData).passInfos) do
    if passInfo:IsBattleType() and passInfo:GetBpSkinCoinGift() > 0 then
      return true
    end
  end
  return false
end
}
local ShopCurrencyGiftBuy = {[ConstGlobalItem.BpSkinCoin] = function()
  -- function num : 0_6 , upvalues : _ENV
  for _,passInfo in pairs((PlayerDataCenter.battlepassData).passInfos) do
    if passInfo:IsBattleType() and passInfo:GetBpSkinCoinGift() > 0 then
      local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
      do
        if payGiftCtrl == nil then
          return false
        end
        do
          local giftInfo = payGiftCtrl:GetPayGiftDataById(passInfo:GetBpSkinCoinGift())
          do
            if giftInfo ~= nil and giftInfo:IsUnlock() then
              local quickBuy = UIManager:GetWindow(UIWindowTypeID.QuickBuy)
              if quickBuy ~= nil then
                quickBuy:SlideOutImmediately()
              end
              UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
    -- function num : 0_6_0 , upvalues : giftInfo
    window:SlideIn()
    window:InitBuyPayGift(giftInfo)
  end
)
              return true
            end
            return false
          end
          -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end
}
ShopUtil.CheckCurrencyExchange = function(itemId)
  -- function num : 0_7 , upvalues : ShopCurrencyGiftCheck
  local func = ShopCurrencyGiftCheck[itemId]
  if func ~= nil then
    return func()
  end
  return false
end

ShopUtil.StartCurrencyExchange = function(itemId)
  -- function num : 0_8 , upvalues : ShopCurrencyGiftBuy
  local buyFunc = ShopCurrencyGiftBuy[itemId]
  if buyFunc == nil then
    return nil
  end
  return buyFunc()
end

return ShopUtil

