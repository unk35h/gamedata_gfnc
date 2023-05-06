-- params : ...
-- function num : 0 , upvalues : _ENV
local PayGiftInfo = class("PayGiftInfo")
local ShopEnum = require("Game.Shop.ShopEnum")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local eSelfSelectGift = require("Game.PayGift.eSelfSelectGift")
local isSelfSelectChipGiftTable = {(eSelfSelectGift.type).heroFragWithOutLimit, (eSelfSelectGift.type).heroFragWithSpecWeapon, (eSelfSelectGift.type).heroFragSelected}
PayGiftInfo.CreatePayGiftInfo = function(groupCfg)
  -- function num : 0_0 , upvalues : PayGiftInfo, _ENV, ShopEnum, _
  local data = (PayGiftInfo.New)()
  data.groupCfg = groupCfg
  data.initPreGroupId = (data.groupCfg).id
  data.initPreGroupLine = (data.groupCfg).line
  if (data.groupCfg).pre_group ~= nil and #(data.groupCfg).pre_group > 0 then
    data.initPreGroupId = ((data.groupCfg).pre_group)[1]
    data.initPreGroupLine = ((ConfigData.pay_gift_type)[data.initPreGroupId]).line
  end
  data.giftCfgList = {}
  for i,v in pairs((data.groupCfg).giftDic) do
    (table.insert)(data.giftCfgList, v)
  end
  data.times = 0
  data.refreshTime = 0
  data.nextRefreshTime = data.refreshTime
  ;
  (table.sort)(data.giftCfgList, function(a, b)
    -- function num : 0_0_0
    if a.limit_type >= b.limit_type then
      do return a.limit_type == b.limit_type end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  data.defaultCfg = (data.giftCfgList)[1]
  data.needRefresh = (data.defaultCfg).limit_type == (ShopEnum.eLimitType).Day or (data.defaultCfg).limit_type == (ShopEnum.eLimitType).Week or (data.defaultCfg).limit_type == (ShopEnum.eLimitType).Month or (data.defaultCfg).limit_type == (ShopEnum.eLimitType).Subscription
  data.isFree = nil
  data.isFree = not (data.defaultCfg).cur_price and not data:IsUseItemPay() or 0 == 0
  do
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
    _ = payCtrl:GetPayPriceInter((data.defaultCfg).payId)
    data.selfSelectGiftIsSelected = false
    data.selfSelectGiftSelectedItemIds = nil
    data.selfSelectGiftSelectedItemNums = nil
    data.selfSelectGiftSelectedParams = nil
    if data:IsSelfSelectGift() then
      data.customGiftCount = #(data.defaultCfg).params
      data.customGiftCfg = (ConfigData.customized_gift)[(data.defaultCfg).param]
    end
    do return data end
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

PayGiftInfo.IsPeriodicityPayGift = function(self)
  -- function num : 0_1 , upvalues : ShopEnum
  do return (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Day or (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Week or (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Month end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayGiftInfo.UpdatePayGiftInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (ControllerManager:GetController(ControllerTypeId.TimePass, true))
  local timepassCtr = nil
  local counterEl = nil
  for k,v in pairs(self.giftCfgList) do
    local tempCounterEl = timepassCtr:getCounterElemData(proto_object_CounterModule.CounterModuleGiftReset, v.id)
    if tempCounterEl ~= nil and PlayerDataCenter.timestamp < tempCounterEl.nextExpiredTm then
      counterEl = tempCounterEl
      break
    end
  end
  do
    if counterEl ~= nil then
      self.times = counterEl.times
      self.refreshTime = counterEl.nextExpiredTm
      self.nextRefreshTime = self.refreshTime
      self:UpadteNextTime()
    end
  end
end

PayGiftInfo.IsUnlock = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (CheckCondition.CheckLua)((self.groupCfg).pre_condition, (self.groupCfg).pre_para1, (self.groupCfg).pre_para2)
end

PayGiftInfo.GetUnlockParam = function(self)
  -- function num : 0_4
  return (self.groupCfg).pre_condition, (self.groupCfg).pre_para1, (self.groupCfg).pre_para2
end

PayGiftInfo.IsUnlockTimeCondition = function(self)
  -- function num : 0_5 , upvalues : _ENV, CheckerTypeId
  for i,preCondition in ipairs((self.groupCfg).pre_condition) do
    if preCondition == CheckerTypeId.TimeRange then
      return true, ((self.groupCfg).pre_para1)[i], ((self.groupCfg).pre_para2)[i]
    else
      if preCondition == CheckerTypeId.SectorStagePassTm then
        local ok, outRange, sectorPassTm, realSectorPassTm = (PlayerDataCenter.sectorStage):CheckSectorPassTmInRange(((self.groupCfg).pre_para1)[i], ((self.groupCfg).pre_para2)[i])
        if ok and not outRange then
          return true, sectorPassTm, realSectorPassTm
        end
      end
    end
  end
  return false
end

PayGiftInfo.GetPopGiftType = function(self)
  -- function num : 0_6
  return (self.groupCfg).ispop
end

PayGiftInfo.GeyGiftGroupPopId = function(self)
  -- function num : 0_7
  return (self.groupCfg).group_pop
end

PayGiftInfo.GetPopGiftSortLevel = function(self)
  -- function num : 0_8
  return (self.groupCfg).line
end

PayGiftInfo.GetGiftInWhichShop = function(self)
  -- function num : 0_9
  return (self.groupCfg).inShop
end

PayGiftInfo.IsGiftInfoInShop = function(self)
  -- function num : 0_10
  do return (self.groupCfg).inShop ~= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayGiftInfo.IsUnlockForAdditionalTimeCondition2 = function(self)
  -- function num : 0_11 , upvalues : _ENV
  do return self.endTime ~= nil and PlayerDataCenter.timestamp < self.endTime end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayGiftInfo.IsUnclockPopGift = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if (self.groupCfg).ispop == 0 and (self.groupCfg).group_pop == 0 then
    return false
  end
  if not self:IsUnlockForAdditionalTimeCondition2() and not (CheckCondition.CheckLua)((self.groupCfg).pre_condition2, (self.groupCfg).pre_para3, (self.groupCfg).pre_para4) then
    return false
  end
  do
    if (self.groupCfg).pop_date > 0 then
      local timeData = TimeUtil:TimestampToDate((math.floor)(PlayerDataCenter.timestamp))
      return timeData.day & 1 == (self.groupCfg).pop_date & 1
    end
    do return true end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

PayGiftInfo.GetPopGiftConditionsAndParas = function(self)
  -- function num : 0_13
  return (self.groupCfg).pre_condition2, (self.groupCfg).pre_para3, (self.groupCfg).pre_para4
end

PayGiftInfo.IsHeroConditionInGift = function(self)
  -- function num : 0_14 , upvalues : _ENV, CheckerTypeId
  for i,preCondition in ipairs((self.groupCfg).pre_condition) do
    if preCondition == CheckerTypeId.MinHeroStar then
      return true, ((self.groupCfg).pre_para1)[i], ((self.groupCfg).pre_para2)[i]
    end
  end
  return false
end

PayGiftInfo.GetParas34ByCondition2Id = function(self, conditionId)
  -- function num : 0_15
  for i = 1, #(self.groupCfg).pre_condition2 do
    if ((self.groupCfg).pre_condition2)[i] == conditionId then
      return ((self.groupCfg).pre_para3)[i], ((self.groupCfg).pre_para4)[i]
    end
  end
end

PayGiftInfo.IsLinearGift = function(self)
  -- function num : 0_16 , upvalues : _ENV
  if (self.groupCfg).pre_group ~= nil and #(self.groupCfg).pre_group > 0 then
    return true
  end
  if (self.groupCfg).afterGroup ~= nil and (table.count)((self.groupCfg).afterGroup) > 0 then
    return true
  end
  return false
end

PayGiftInfo.IsSoldOut = function(self)
  -- function num : 0_17 , upvalues : ShopEnum, _ENV
  if (self.defaultCfg).limit_type == (ShopEnum.eLimitType).None then
    return false
  end
  if (self.defaultCfg).times > self.times then
    do return (self.defaultCfg).limit_type ~= (ShopEnum.eLimitType).Eternal and (self.defaultCfg).limit_type ~= (ShopEnum.eLimitType).EternalSubscription end
    do return PlayerDataCenter.timestamp < self.refreshTime and (self.defaultCfg).times <= self.times end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

PayGiftInfo.IsEternalAndSoldOut = function(self)
  -- function num : 0_18 , upvalues : ShopEnum
  if (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Eternal or (self.defaultCfg).limit_type == (ShopEnum.eLimitType).EternalSubscription then
    return self:IsSoldOut()
  end
  return false
end

PayGiftInfo.GetLimitBuyCount = function(self)
  -- function num : 0_19 , upvalues : ShopEnum, _ENV
  local isLimitBuy = (self.defaultCfg).limit_type ~= (ShopEnum.eLimitType).None
  local times = self.times
  if isLimitBuy and self.refreshTime < PlayerDataCenter.timestamp then
    times = 0
  end
  do return isLimitBuy, times, (self.defaultCfg).times end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

PayGiftInfo.GetPayGiftNextTime = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if not self:NeedRefreshTime() then
    return -1
  end
  if PlayerDataCenter.timestamp < self.nextRefreshTime then
    return self.nextRefreshTime
  else
    self:UpadteNextTime()
    return self.nextRefreshTime
  end
end

PayGiftInfo.NeedRefreshTime = function(self)
  -- function num : 0_21 , upvalues : ShopEnum, _ENV
  if (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Subscription then
    if PlayerDataCenter.timestamp >= self.nextRefreshTime then
      do return not self.needRefresh end
      do return true end
      do return false end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
end

PayGiftInfo.IsUseItemPay = function(self)
  -- function num : 0_22
  do return (self.defaultCfg).pay_type == 2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayGiftInfo.UpadteNextTime = function(self)
  -- function num : 0_23 , upvalues : _ENV, ShopEnum
  if PlayerDataCenter.timestamp <= self.nextRefreshTime then
    return 
  end
  local time = TimeUtil:TimestampToDate((math.floor)(TimeUtil:TimpApplyLogicOffset(PlayerDataCenter.timestamp)))
  if (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Day then
    time.hour = 0
    time.min = 0
    time.sec = 0
    self.nextRefreshTime = TimeUtil:DateToTimestamp(time) + 86400 + 3600 * TimeUtil:GetDayPassTime()
  else
    if (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Week or (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Subscription then
      local wday = time.wday
      wday = wday - 1
      if wday == 0 then
        wday = 7
      end
      local dayCount = 8 - wday
      time.hour = 0
      time.min = 0
      time.sec = 0
      self.nextRefreshTime = TimeUtil:DateToTimestamp(time) + 86400 * dayCount + 3600 * TimeUtil:GetDayPassTime()
    else
      do
        if (self.defaultCfg).limit_type == (ShopEnum.eLimitType).Month then
          time.day = 1
          time.hour = 0
          time.min = 0
          time.sec = 0
          if time.month == 12 then
            time.month = 1
            time.year = time.year + 1
          else
            time.month = time.month + 1
          end
          self.nextRefreshTime = TimeUtil:DateToTimestamp(time) + 3600 * TimeUtil:GetDayPassTime()
        end
      end
    end
  end
end

PayGiftInfo.TryGetGiftSubscriptionCfg = function(self)
  -- function num : 0_24 , upvalues : _ENV, ShopEnum
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.limit_type == (ShopEnum.eLimitType).Subscription or giftCfg.limit_type == (ShopEnum.eLimitType).EternalSubscription or self:IsOrderOfManyTypeGift() then
      return true, giftCfg, giftCfg.param
    end
    if self:IsCheckNextGift() then
      return true, giftCfg, 0
    end
  end
  return false, nil, 0
end

PayGiftInfo.TryGetGiftRaffleCfg = function(self)
  -- function num : 0_25 , upvalues : _ENV, ShopEnum
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.type == (ShopEnum.eGiftType).raffle then
      return true, giftCfg
    end
  end
  return false, nil
end

PayGiftInfo.IsNewGiftInShop = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if not (self.groupCfg).is_new then
    return false
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local isNotNew = saveUserData:GetNewPayGiftItemIsNotNew((self.groupCfg).id)
  if not isNotNew and not self:IsSoldOut() then
    return true
  end
  return false
end

PayGiftInfo.SetNewGiftLooked = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if not (self.groupCfg).is_new then
    return 
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local isNotNew = saveUserData:SetNewGiftItemIsNotNew((self.groupCfg).id, true)
end

PayGiftInfo.IsSelfSelectChipGift = function(self)
  -- function num : 0_28 , upvalues : _ENV, ShopEnum, isSelfSelectChipGiftTable
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.type == (ShopEnum.eGiftType).select and (table.contain)(isSelfSelectChipGiftTable, ((ConfigData.customized_gift)[giftCfg.param]).type) then
      return true
    end
  end
  return false
end

PayGiftInfo.IsCheckNextGift = function(self)
  -- function num : 0_29 , upvalues : _ENV, ShopEnum
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.type == (ShopEnum.eGiftType).checkNextGift then
      return true
    end
  end
  return false
end

PayGiftInfo.IsOrderOfManyTypeGift = function(self)
  -- function num : 0_30 , upvalues : _ENV, ShopEnum
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.type == (ShopEnum.eGiftType).orderOfManyType then
      return true
    end
  end
  return false
end

PayGiftInfo.IsSelfSelectHeroGift = function(self)
  -- function num : 0_31 , upvalues : _ENV, ShopEnum, eSelfSelectGift
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.type == (ShopEnum.eGiftType).select and giftCfg.param == (eSelfSelectGift.type).heroCard then
      return true
    end
  end
  return false
end

PayGiftInfo.IsSelfSelectGift = function(self)
  -- function num : 0_32 , upvalues : _ENV, ShopEnum
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.type == (ShopEnum.eGiftType).select then
      return true
    end
  end
  return false
end

PayGiftInfo.IsFreeGift = function(self)
  -- function num : 0_33 , upvalues : _ENV
  for _,giftCfg in ipairs(self.giftCfgList) do
    if giftCfg.cur_price == 0 then
      return true
    end
  end
  return false
end

PayGiftInfo.CleanSelfSelectInfo = function(self)
  -- function num : 0_34
  self.selfSelectGiftIsSelected = false
  self.selfSelectGiftSelectedItemIds = nil
  self.selfSelectGiftSelectedItemNums = nil
  self.selfSelectGiftSelectedParams = nil
end

PayGiftInfo.SetSelfSelectInfo = function(self, showItemIds, showItemNums, params)
  -- function num : 0_35
  if not self:IsSelfSelectGift() then
    return 
  end
  self.selfSelectGiftSelectedItemIds = showItemIds
  self.selfSelectGiftSelectedItemNums = showItemNums
  self.selfSelectGiftSelectedParams = params
  self.selfSelectGiftIsSelected = self.customGiftCount <= #params
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayGiftInfo.GetSelfSelectGiftIsSelected = function(self)
  -- function num : 0_36
  return self.selfSelectGiftIsSelected
end

PayGiftInfo.GetSelfSelectGiftParams = function(self)
  -- function num : 0_37
  return self.selfSelectGiftSelectedParams
end

PayGiftInfo.GetSelectGiftCustomCfg = function(self)
  -- function num : 0_38
  return self.customGiftCfg
end

PayGiftInfo.GetSelectGiftCustomCount = function(self)
  -- function num : 0_39
  return self.customGiftCount
end

PayGiftInfo.TryGetPayGiftOldPrice = function(self)
  -- function num : 0_40 , upvalues : _ENV
  local showOldPrice = ((self.defaultCfg).cur_price ~= (self.defaultCfg).old_price and not ((Consts.GameChannelType).IsTw)())
  local oldPrice = (self.defaultCfg).old_price
  if not self:IsUseItemPay() and LanguageUtil.LanguageInt == eLanguageType.EN_US then
    oldPrice = FormatNum(oldPrice / 100)
  end
  do return showOldPrice, oldPrice end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

PayGiftInfo.GetPayGiftRewards = function(self)
  -- function num : 0_41 , upvalues : _ENV
  local itemids = {}
  local itemnums = {}
  ;
  (table.insertto)(itemids, (self.defaultCfg).awardIds)
  ;
  (table.insertto)(itemnums, (self.defaultCfg).awardCounts)
  if self.selfSelectGiftSelectedItemIds ~= nil then
    (table.insertto)(itemids, self.selfSelectGiftSelectedItemIds)
    ;
    (table.insertto)(itemnums, self.selfSelectGiftSelectedItemNums)
  end
  return itemids, itemnums
end

return PayGiftInfo

