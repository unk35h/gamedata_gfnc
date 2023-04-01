-- params : ...
-- function num : 0 , upvalues : _ENV
local PayController = class("PayController", ControllerBase)
local base = ControllerBase
local rapidjson = require("rapidjson")
local JumpManager = require("Game.Jump.JumpManager")
local ShopEnum = require("Game.Shop.ShopEnum")
local cs_MessageCommon = CS.MessageCommon
local cs_MicaSDKManager = CS.MicaSDKManager
local cs_LanguageGlobal = CS.LanguageGlobal
local identifier = ((CS.UnityEngine).Application).identifier
PayController.OnInit = function(self)
  -- function num : 0_0
  self._totalRecharge = 0
end

PayController.GetPayPriceInter = function(self, productId)
  -- function num : 0_1 , upvalues : _ENV, cs_LanguageGlobal
  local productCfg = (ConfigData.pay_product)[productId]
  if productCfg == nil then
    error("Cant get pay_product cfg, productId : " .. tostring(productId))
    return 
  end
  local priceNum = ConfigData:TryGetSpecailPayPrice(productCfg.sdk_id)
  local useSpecialPrice = true
  if priceNum == nil then
    local paySdkCfg = (ConfigData.pay_sdk)[productCfg.sdk_id]
    if paySdkCfg == nil then
      error("Cant get pay_sdk cfg, id : " .. tostring(productCfg.sdk_id))
      return 
    end
    local pricePara = "price_" .. (cs_LanguageGlobal.GetLanguageStr)()
    if paySdkCfg[pricePara] == nil then
      error("Cant get payCfg." .. pricePara)
      return 
    end
    priceNum = FormatNum(paySdkCfg[pricePara] / 100)
    useSpecialPrice = false
  end
  do
    do return priceNum, priceNum == 0, useSpecialPrice end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

PayController.GetPayPriceShow = function(self, productId)
  -- function num : 0_2 , upvalues : _ENV
  local priceNum, _, useSpecialPrice = self:GetPayPriceInter(productId)
  do
    if priceNum == 0 then
      local freeStr = ConfigData:GetTipContent(10013)
      return freeStr, freeStr
    end
    local payPriceUnit = ConfigData:GetTipContent(TipContent.PayPriceUnit)
    local specailSymbol = ConfigData:TryGetSpecailPayCurrencySymbol()
    if specailSymbol ~= nil and useSpecialPrice then
      return specailSymbol .. tostring(priceNum), priceNum, specailSymbol
    end
    return (string.format)(payPriceUnit, tostring(priceNum)), priceNum
  end
end

PayController.GetPayShowUnitStr = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local specailSymbol = ConfigData:TryGetSpecailPayCurrencySymbol()
  if specailSymbol ~= nil then
    return specailSymbol
  end
  local payPriceUnit = ConfigData:GetTipContent(TipContent.PayPriceUnit)
  local priceUnitStr = (string.format)(payPriceUnit, "")
  return priceUnitStr
end

PayController.GetPayName = function(self, productId)
  -- function num : 0_4 , upvalues : _ENV
  local productCfg = (ConfigData.pay_product)[productId]
  if productCfg == nil then
    error("Cant get pay_product cfg, productId : " .. tostring(productId))
    return 
  end
  local paySdkCfg = (ConfigData.pay_sdk)[productCfg.sdk_id]
  if paySdkCfg == nil then
    error("Cant get pay_sdk cfg, id : " .. tostring(productCfg.sdk_id))
    return 
  end
  return (LanguageUtil.GetLocaleText)(paySdkCfg.name)
end

PayController.GetPayRewards = function(self, productId, isDouble)
  -- function num : 0_5 , upvalues : _ENV
  local rechargeCfg = (ConfigData.pay_recharge)[productId]
  if rechargeCfg == nil then
    error("Cant get pay_recharge cfg, id : " .. tostring(productCfg.sdk_id))
    return 
  end
  if isDouble then
    return rechargeCfg.doubleRewardIdList, rechargeCfg.doubleRewardNumList
  else
    return rechargeCfg.rewardIdList, rechargeCfg.rewardNumList
  end
end

PayController._GetProductIdStrPre = function(self)
  -- function num : 0_6 , upvalues : cs_MicaSDKManager, identifier, _ENV
  if self._productIdPre ~= nil then
    return self._productIdPre
  end
  local channelId = (cs_MicaSDKManager.Instance).channelId
  local productIdPre = identifier
  if channelId == (Consts.GameChannelType).Bilibili or channelId == (Consts.GameChannelType).BilibiliQATest or channelId == (Consts.GameChannelType).BilibiliKol or channelId == (Consts.GameChannelType).BilibiliGray then
    productIdPre = "com.sunborn.neuralcloud.cn"
  end
  local pre = productIdPre .. ".diamond"
  self._productIdPre = pre
  return pre
end

PayController._GetProductIdStr = function(self, sdkId)
  -- function num : 0_7 , upvalues : _ENV
  local pre = self:_GetProductIdStrPre()
  local str = pre .. tostring(sdkId)
  return str
end

PayController.ReqPay = function(self, productId, num, callback, showTitle, afterRewardAction)
  -- function num : 0_8 , upvalues : _ENV, cs_LanguageGlobal, cs_MicaSDKManager, cs_MessageCommon, rapidjson
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  self._rewardTitle = showTitle
  local productCfg = (ConfigData.pay_product)[productId]
  if productCfg == nil then
    error("Cant get pay_product cfg, productId : " .. tostring(productId))
    return 
  end
  local paySdkCfg = (ConfigData.pay_sdk)[productCfg.sdk_id]
  if paySdkCfg == nil then
    error("Cant get pay_sdk cfg, id : " .. tostring(productCfg.sdk_id))
    return 
  end
  local pricePara = "price_" .. (cs_LanguageGlobal.GetLanguageStr)()
  if paySdkCfg[pricePara] == nil then
    error("Cant get payCfg." .. pricePara)
    return 
  end
  local totalPrice = paySdkCfg[pricePara] * num
  if self.__OnRecPayRewardFunc == nil then
    self.__OnRecPayRewardFunc = BindCallback(self, self.OnRecPayReward)
  end
  self.__payCallback = callback
  self.__afterRewardAction = afterRewardAction
  if isEditorMode then
    print("start pay:" .. (LanguageUtil.GetLocaleText)(paySdkCfg.name))
  end
  if totalPrice == 0 then
    (NetworkManager:GetNetwork(NetworkTypeID.Pay)):CS_RECHARGE_RechargeFree(productId, self.__OnRecPayRewardFunc)
    return 
  end
  if not (cs_MicaSDKManager.Instance):IsUseSdk() then
    (NetworkManager:GetNetwork(NetworkTypeID.Pay)):CS_RECHARGE_FakeRecharge(productId, totalPrice, self.__OnRecPayRewardFunc)
    return 
  end
  local channelId = (cs_MicaSDKManager.Instance).channelId
  if channelId == (Consts.GameChannelType).Kol or channelId == (Consts.GameChannelType).EnKol then
    (cs_MessageCommon.ShowMessageBoxConfirm)((ConfigData:GetTipContent(10011)), nil)
    return 
  end
  local extraStr = PlayerDataCenter.strPlayerId
  if channelId == (Consts.GameChannelType).Bilibili or channelId == (Consts.GameChannelType).BilibiliQATest then
    extraStr = extraStr .. "-bili"
  else
    if channelId == (Consts.GameChannelType).BilibiliKol then
      extraStr = extraStr .. "-kol"
    end
  end
  local payParamTab = {GAME_USER_ROLE_NAME = PlayerDataCenter.playerName, GAME_USER_ID = PlayerDataCenter.strPlayerId, AMOUNT = tostring(totalPrice), PRODUCT_ID = self:_GetProductIdStr(paySdkCfg.id), PRODUCT_NAME = (LanguageUtil.GetLocaleText)(paySdkCfg.name), PRODUCT_DESC = (LanguageUtil.GetLocaleText)(paySdkCfg.description), VIRTUAL_QUANTITY = tostring(num), EXTRA = extraStr, GAME_USER_ROLE_LEVEL = (PlayerDataCenter.inforData):GetUserLevel(), SERVER_ID = tostring(channelId)}
  local payParamJson = (rapidjson.encode)(payParamTab)
  ;
  (cs_MicaSDKManager.Instance):ReqPay(payParamJson, function(payFinish)
    -- function num : 0_8_0
  end
)
end

PayController.OnRecPayReward = function(self, objList)
  -- function num : 0_9 , upvalues : _ENV
  if objList.Count == 0 then
    error("objList.Count == 0")
    return 
  end
  local rechargeRewardsBrief = objList[0]
  self:ShowPayReward(rechargeRewardsBrief)
end

PayController.ShowPayReward = function(self, rechargeRewardsBrief)
  -- function num : 0_10 , upvalues : _ENV, cs_MicaSDKManager, cs_MessageCommon
  self:_PayTrackEvent(rechargeRewardsBrief)
  local rewardIds = {}
  local rewardNums = {}
  local overflowDic, newSkinDic = nil, nil
  local rewardDic = rechargeRewardsBrief.rewards
  rewardIds = self:HandleOverflowSkins(rewardDic, rechargeRewardsBrief.skinGiftConvertSkinIds)
  -- DECOMPILER ERROR at PC18: Overwrote pending register: R5 in 'AssignReg'

  local mergedRewardIdDic = {}
  do
    for id,num in pairs(rewardDic) do
      if not mergedRewardIdDic[id] then
        local showId = id
        local showNum = num
        local mergeIdList = eItemMergeDic[id]
        if mergeIdList ~= nil then
          showNum = 0
          for k,mergeId in ipairs(mergeIdList) do
            local mNum = rewardDic[mergeId]
            if mNum ~= nil then
              showNum = showNum + mNum
            end
            mergedRewardIdDic[mergeId] = true
          end
          showId = mergeIdList[1]
        end
        ;
        (table.insert)(rewardIds, showId)
        ;
        (table.insert)(rewardNums, showNum)
      end
    end
  end
  if #rewardIds == 0 then
    self.waitMsgBoxConfirm = true
    if not (cs_MicaSDKManager.Instance):IsUseSdk() then
      (cs_MessageCommon.ShowMessageBoxConfirm)(ConfigData:GetTipContent(10003), function()
    -- function num : 0_10_0 , upvalues : self
    self.waitMsgBoxConfirm = false
  end
)
    end
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.Pay)):CS_RECHARGE_ConfirmRewards()
    if self.__afterRewardAction ~= nil then
      (self.__afterRewardAction)()
      self.__afterRewardAction = nil
    end
  else
    local _heroIdSnapShoot = self._heroIdSnapShoot
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_10_1 , upvalues : self, _ENV, rewardIds, rewardNums, rewardDic, _heroIdSnapShoot, overflowDic, newSkinDic
    if window == nil then
      return 
    end
    if self._rewardTitle == nil or not self._rewardTitle then
      local msg = ConfigData:GetTipContent(10006)
    end
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = (((((((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRBeforeMergeItemDic(rewardDic)):SetCRHeroSnapshoot(_heroIdSnapShoot)):SetCRTitle(msg)):SetCRShowOverFunc(function()
      -- function num : 0_10_1_0 , upvalues : self
      if self.finishCallback ~= nil then
        (self.finishCallback)()
      end
      if self.__afterRewardAction ~= nil then
        (self.__afterRewardAction)()
        self.__afterRewardAction = nil
      end
    end
)):SetCRItemTransDic(overflowDic)):SetCRItemNewDic(newSkinDic)
    window:AddAndTryShowReward(CRData)
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.Pay)):CS_RECHARGE_ConfirmRewards()
  end
)
  end
  do
    if self.__payCallback ~= nil then
      (self.__payCallback)()
      self.__payCallback = nil
    end
  end
end

PayController.SetWaitShowPayResult = function(self, rechargeRewardsBrief)
  -- function num : 0_11
  self._waitShowPayResult = rechargeRewardsBrief
end

PayController.GetCouldSHowPayResult = function(self)
  -- function num : 0_12 , upvalues : _ENV
  do return self._waitShowPayResult ~= nil and (table.count)((self._waitShowPayResult).rewards) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayController.TryShowPayResult = function(self, finishCallback)
  -- function num : 0_13 , upvalues : _ENV
  self.finishCallback = finishCallback
  if self._waitShowPayResult == nil then
    if finishCallback ~= nil then
      finishCallback()
    end
    return 
  end
  local hasRewardItem = (table.count)((self._waitShowPayResult).rewards) > 0
  self:ShowPayReward(self._waitShowPayResult)
  self._waitShowPayResult = nil
  if not hasRewardItem and finishCallback ~= nil then
    finishCallback()
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

PayController.IsPayItem = function(self, itemId)
  -- function num : 0_14 , upvalues : _ENV
  do return itemId == ConstGlobalItem.PaidSubItem or itemId == ConstGlobalItem.PaidItem end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PayController.TryConvertPayItem = function(self, itemId, num, beforeJumpCallback, jumpOverCallback, callBack, directShowShop)
  -- function num : 0_15 , upvalues : _ENV
  if itemId == ConstGlobalItem.PaidSubItem then
    self:ConvertQuartz(num, beforeJumpCallback, jumpOverCallback, callBack, directShowShop)
    return true
  else
    if itemId == ConstGlobalItem.PaidItem then
      self:Jump2BuyQuartz(beforeJumpCallback, jumpOverCallback, directShowShop)
      return true
    end
  end
  return false
end

PayController.HandleOverflowSkins = function(self, rewardDic, skinGiftConvertSkinIds)
  -- function num : 0_16 , upvalues : _ENV
  local outputRewardIds = {}
  local outputRewardNums = {}
  local outputSkinRewardDic = {}
  local currentSkinTokenNum = 0
  local skinTonkenId = ConstGlobalItem.SkinTicket
  if skinGiftConvertSkinIds ~= nil then
    for iSkinIdIndex = 1, #skinGiftConvertSkinIds do
      local id = skinGiftConvertSkinIds[iSkinIdIndex]
      local skinPrice = self:GetItemCurrencyPrice(id, skinTonkenId)
      if skinPrice == nil then
        return {}, {}, nil, nil
      end
      currentSkinTokenNum = currentSkinTokenNum - skinPrice
      outputSkinRewardDic[id] = 1
      ;
      (table.insert)(outputRewardIds, id)
      ;
      (table.insert)(outputRewardNums, 1)
    end
  end
  do
    for id,num in pairs(rewardDic) do
      if id == skinTonkenId then
        currentSkinTokenNum = currentSkinTokenNum + num
        if currentSkinTokenNum > 0 then
          (table.insert)(outputRewardIds, id)
          ;
          (table.insert)(outputRewardNums, currentSkinTokenNum)
        end
        rewardDic[id] = nil
      end
    end
    return outputRewardIds, outputRewardNums, outputSkinRewardDic
  end
end

PayController.HandleNewSkins = function(self, newSkinIds)
  -- function num : 0_17
  if newSkinIds == nil then
    return nil
  end
  local newSkinDic = {}
  for iSkinIndex = 1, #newSkinIds do
    newSkinDic[newSkinIds[iSkinIndex]] = true
  end
  return newSkinDic
end

PayController.GetItemCurrencyPrice = function(self, itemId, payType)
  -- function num : 0_18 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("item cfg is null,id:" .. tostring(itemId))
    return 
  end
  local payItemCfg = (ConfigData.item)[payType]
  if payItemCfg == nil then
    error("item cfg is null,id:" .. tostring(payType))
    return 
  end
  local currencyCfg = (ConfigData.item_currency)[payType]
  if currencyCfg == nil then
    error("Item Currency Cfg is null,ID:" .. tostring(payType))
    return 
  else
    local originPrice = (math.ceil)((itemCfg.currency_price)[currencyCfg.num] / currencyCfg.divisor)
    return originPrice
  end
end

PayController.ConvertQuartz = function(self, num, beforeJumpCallback, jumpOverCallback, callBack, directShowShop)
  -- function num : 0_19 , upvalues : _ENV, cs_MessageCommon
  local msg = (string.format)(ConfigData:GetTipContent(10008), num, num)
  if ((Consts.GameChannelType).IsJp)() then
    msg = msg .. ConfigData:GetTipContent(334)
  end
  ;
  (cs_MessageCommon.ShowMessageBox)(msg, function()
    -- function num : 0_19_0 , upvalues : _ENV, num, callBack, self, beforeJumpCallback, jumpOverCallback, directShowShop
    local quartzNum = PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem)
    -- DECOMPILER ERROR at PC12: Unhandled construct in 'MakeBoolean' P1

    if num <= quartzNum and callBack ~= nil then
      callBack()
    end
    self:Jump2BuyQuartz(beforeJumpCallback, jumpOverCallback, directShowShop)
  end
, nil)
end

PayController.Jump2BuyQuartz = function(self, beforeJumpCallback, jumpOverCallback, directShow)
  -- function num : 0_20 , upvalues : cs_MessageCommon, _ENV, ShopEnum, JumpManager
  (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(TipContent.PaidItemNotEnoughTip), function()
    -- function num : 0_20_0 , upvalues : ShopEnum, directShow, JumpManager, beforeJumpCallback, jumpOverCallback
    local shopId = (ShopEnum.ShopId).recharge
    if directShow then
      JumpManager:DirectShowShop(beforeJumpCallback, jumpOverCallback, shopId)
    else
      JumpManager:Jump((JumpManager.eJumpTarget).DynShop, beforeJumpCallback, jumpOverCallback, {shopId})
    end
  end
, nil)
end

PayController.PaidCurrencyExecute = function(self, currencyId, needCurrencyNum, needItemId, needItemNum, executeFunc, assignMsg, formatMsg)
  -- function num : 0_21 , upvalues : _ENV
  local containCurrencyNum = PlayerDataCenter:GetItemCount(currencyId)
  local currencyCfg = (ConfigData.item)[currencyId]
  if currencyCfg == nil then
    error("Item Cfg is null,ID:" .. tostring(currencyId))
    return 
  end
  local currencyName = (LanguageUtil.GetLocaleText)(currencyCfg.name)
  local srcIdList = {}
  local srcNumList = {}
  local needPaidItemNum = 0
  local linkSign = ""
  if LanguageUtil.LanguageInt == eLanguageType.EN_US then
    linkSign = " "
  end
  if currencyId == ConstGlobalItem.PaidSubItem then
    needPaidItemNum = needCurrencyNum - containCurrencyNum
    if needPaidItemNum > 0 and (containCurrencyNum == 0 or currencyId == needItemId) then
      (table.insert)(srcIdList, ConstGlobalItem.PaidItem)
      ;
      (table.insert)(srcNumList, needPaidItemNum)
      local itemCfg = (ConfigData.item)[ConstGlobalItem.PaidItem]
      currencyName = tostring(needPaidItemNum) .. linkSign .. (LanguageUtil.GetLocaleText)(itemCfg.name)
    else
      do
        if needPaidItemNum > 0 and containCurrencyNum > 0 then
          (table.insert)(srcIdList, ConstGlobalItem.PaidItem)
          ;
          (table.insert)(srcNumList, needPaidItemNum)
          ;
          (table.insert)(srcIdList, ConstGlobalItem.PaidSubItem)
          ;
          (table.insert)(srcNumList, containCurrencyNum)
          local itemCfg = (ConfigData.item)[ConstGlobalItem.PaidItem]
          currencyName = tostring(needPaidItemNum) .. linkSign .. (LanguageUtil.GetLocaleText)(itemCfg.name) .. linkSign .. "+" .. linkSign .. tostring(containCurrencyNum) .. linkSign .. currencyName
        else
          do
            ;
            (table.insert)(srcIdList, ConstGlobalItem.PaidSubItem)
            ;
            (table.insert)(srcNumList, needCurrencyNum)
            currencyName = tostring(needCurrencyNum) .. linkSign .. currencyName
            ;
            (table.insert)(srcIdList, currencyId)
            ;
            (table.insert)(srcNumList, needCurrencyNum)
            currencyName = tostring(needCurrencyNum) .. linkSign .. currencyName
            local needItemName = (LanguageUtil.GetLocaleText)(((ConfigData.item)[needItemId]).name)
            local msg = assignMsg
            if msg == nil then
              if not formatMsg then
                formatMsg = ConfigData:GetTipContent(302)
              end
              msg = (string.format)(formatMsg, currencyName, tostring(needItemNum), needItemName)
              if ((Consts.GameChannelType).IsJp)() then
                msg = msg .. ConfigData:GetTipContent(334)
              end
            end
            local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
            window:ShowItemConvert(msg, srcIdList, srcNumList, {needItemId}, {needItemNum}, function()
    -- function num : 0_21_0 , upvalues : needPaidItemNum, _ENV, self, executeFunc
    if PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem) < needPaidItemNum then
      self:Jump2BuyQuartz(nil, nil, true)
    else
      executeFunc()
    end
  end
)
          end
        end
      end
    end
  end
end

PayController.TryReqPnSdkPrice = function(self)
  -- function num : 0_22 , upvalues : _ENV, rapidjson, cs_MicaSDKManager
  if not ((Consts.GameChannelType).IsTw)() then
    return 
  end
  local goodTab = {}
  for sdkId,v in pairs(ConfigData.pay_sdk) do
    local str = self:_GetProductIdStr(sdkId)
    ;
    (table.insert)(goodTab, str)
  end
  local reqParamJsonStr = (rapidjson.encode)(goodTab)
  local callBack = function(jsonStr)
    -- function num : 0_22_0 , upvalues : _ENV, self, rapidjson
    if (string.IsNullOrEmpty)(jsonStr) then
      return 
    end
    local pre = self:_GetProductIdStrPre()
    local startLen = #pre
    local currencySymbol = nil
    local priceDic = {}
    local tab = (rapidjson.decode)(jsonStr)
    for k,v in ipairs(tab) do
      currencySymbol = v.currencySymbol
      local id = (string.sub)(v.productIdentifier, startLen + 1, #v.productIdentifier)
      priceDic[tonumber(id)] = FormatNum(tonumber(v.price))
    end
    ConfigData:SetSpecailPayCfg(currencySymbol, priceDic)
  end

  ;
  (cs_MicaSDKManager.Instance):QueryWithProducts(reqParamJsonStr, callBack)
end

local pnSdkPayTrackCfg = {[6] = "charge648", [7] = "stdmonthly", [8] = "growthfund", [10] = "magraseapass", [11] = "uptomagraseapass"}
PayController._PayTrackEvent = function(self, rechargeRewardsBrief)
  -- function num : 0_23 , upvalues : cs_MicaSDKManager, _ENV, pnSdkPayTrackCfg, rapidjson
  if not (cs_MicaSDKManager.Instance):IsUseSdk() then
    return 
  end
  if ((Consts.GameChannelType).IsPnSdk)() then
    local productCfg = (ConfigData.pay_product)[rechargeRewardsBrief.goodId]
    if productCfg then
      do
        local param = pnSdkPayTrackCfg[productCfg.sdk_id]
        if param ~= nil then
          (cs_MicaSDKManager.Instance):TrackEvent(param)
        end
        if ((Consts.GameChannelType).IsOversea)() then
          local productCfg = (ConfigData.pay_product)[rechargeRewardsBrief.goodId]
          local productName = nil
          if productCfg == nil then
            error("Cant get pay_product cfg, productId : " .. tostring(rechargeRewardsBrief.goodId))
            productName = ""
          else
            productName = (LanguageUtil.GetLocaleText)(productCfg.name)
          end
          local sdkPara = rechargeRewardsBrief.AdvertisingParams
          if (string.IsNullOrEmpty)(sdkPara.amount) then
            return 
          end
          local tab = {uid = PlayerDataCenter.strPlayerId, currency = sdkPara.currency, amount = sdkPara.amount, product_id = tostring(rechargeRewardsBrief.goodId), product_name = productName, transaction_id = sdkPara.transaction_id}
          local jsonStr = (rapidjson.encode)(tab)
          ;
          (cs_MicaSDKManager.Instance):StatsEventPreSet("purchase", jsonStr)
        end
      end
    end
  end
end

PayController.RechargeSync = function(self, rechargeStat)
  -- function num : 0_24 , upvalues : _ENV, cs_MicaSDKManager
  if rechargeStat.firstRechargeAmount > 0 then
    if ((Consts.GameChannelType).IsOversea)() then
      (cs_MicaSDKManager.Instance):StatsEventPreSetUid("first_purchase")
    else
      if ((Consts.GameChannelType).IsPnSdk)() then
        (cs_MicaSDKManager.Instance):TrackEvent("stdrecharge")
      end
    end
  end
  if rechargeStat.firstUseQuartzBuyFsnVur == true and ((Consts.GameChannelType).IsPnSdk)() then
    (cs_MicaSDKManager.Instance):TrackEvent("dupspend780")
  end
  self:UpdTotalCharge(rechargeStat.amount)
end

local TwTotalChargeList = {[300] = 150000, [2000] = 980000}
local KrTotalChargeList = {[300] = 5500000, [2000] = 35000000}
PayController._TrackFunc = function(self, chargeList, newAmount)
  -- function num : 0_25 , upvalues : _ENV, cs_MicaSDKManager
  for k,num in pairs(chargeList) do
    if self._totalRecharge < num and num <= newAmount then
      (cs_MicaSDKManager.Instance):TrackEvent("totalcharge" .. tostring(k))
    end
  end
end

PayController.UpdTotalCharge = function(self, amount, isInit)
  -- function num : 0_26 , upvalues : _ENV, TwTotalChargeList, KrTotalChargeList
  if not isInit then
    if ((Consts.GameChannelType).IsTw)() then
      self:_TrackFunc(TwTotalChargeList, amount)
    else
      if ((Consts.GameChannelType).IsKr)() then
        self:_TrackFunc(KrTotalChargeList, amount)
      end
    end
  end
  self._totalRecharge = amount
end

PayController.OnDelete = function(self)
  -- function num : 0_27 , upvalues : base
  (base.OnDelete)(self)
end

return PayController

