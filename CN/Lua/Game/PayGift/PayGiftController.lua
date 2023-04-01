-- params : ...
-- function num : 0 , upvalues : _ENV
local PayGiftController = class("PayGiftController", ControllerBase)
local base = ControllerBase
local PayGiftInfo = require("Game.PayGift.PayGiftInfo")
local ShopEnum = require("Game.Shop.ShopEnum")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local HomeEnum = require("Game.Home.HomeEnum")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local JumpManager = require("Game.Jump.JumpManager")
local PopFuncDic = {[1] = function(giftInfo, callback)
  -- function num : 0_0 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ChipGift, function(window)
    -- function num : 0_0_0 , upvalues : _ENV, giftInfo, callback
    if IsNull(window) then
      return 
    end
    window:InitChipGift(giftInfo, callback)
  end
)
end
, [2] = function(giftInfo, callback)
  -- function num : 0_1 , upvalues : _ENV, JumpManager
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonActivityLogin, function(window)
    -- function num : 0_1_0 , upvalues : _ENV, giftInfo, callback, JumpManager
    if IsNull(window) then
      return 
    end
    local loginPupupCfg = (ConfigData.login_popup_ui)[(giftInfo.groupCfg).popup_id]
    local shopItemId = (giftInfo.groupCfg).id
    local shopId = giftInfo:GetGiftInWhichShop()
    window:SetCloseCallback(callback)
    window:SetJumpFunc(function()
      -- function num : 0_1_0_0 , upvalues : giftInfo, JumpManager, shopId, shopItemId, _ENV
      if giftInfo:IsUnlock() then
        local flag = not giftInfo:IsSoldOut()
      end
      if flag then
        JumpManager:Jump((JumpManager.eJumpTarget).DynShop, nil, nil, {shopId, shopItemId})
      else
        ;
        ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(TipContent.Shop_OutOfDate))
        return 
      end
    end
)
    window:InitActivityLoginUI(loginPupupCfg)
  end
)
end
, [3] = function(giftInfo, callback)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EventNewYear23SkinBag, function(window)
    -- function num : 0_2_0 , upvalues : _ENV, giftInfo, callback
    if IsNull(window) then
      return 
    end
    window:InitSkinBag(giftInfo, callback)
  end
)
end
}
local Local_GroupPopFunc = function(groupPopId, callback, self)
  -- function num : 0_3 , upvalues : _ENV
  local groupCfg = (ConfigData.pay_gift_pop_des)[groupPopId]
  if groupCfg == nil then
    callback()
    return 
  end
  local giftids = ((ConfigData.pay_gift_pop_des).popGroup)[groupPopId]
  if giftids == nil or giftids[1] == nil then
    callback()
    return 
  end
  local isRemove = false
  for _,giftInfoId in ipairs(giftids) do
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R11 in 'UnsetPending'

    if (self._homeMainPopDic)[giftInfoId] ~= nil then
      (self._homeMainPopDic)[giftInfoId] = nil
      isRemove = true
    end
  end
  if isRemove then
    self:SortHomeMainPopList()
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonThemedPacks, function(win)
    -- function num : 0_3_0 , upvalues : groupPopId, callback
    if win == nil then
      return 
    end
    win:InitCommonThemedPacks(groupPopId, callback)
  end
)
end

PayGiftController.OnInit = function(self)
  -- function num : 0_4 , upvalues : ConditionListener, _ENV, PayGiftInfo, CheckerTypeId
  self._conditionListener = (ConditionListener.New)()
  self.__OnConditionStateChangeCallback = BindCallback(self, self.__OnConditionStateChange)
  self.__SoldoutStateChangeChangeCallback = BindCallback(self, self.__SoldoutStateChange)
  self.dataDic = {}
  self.shopGiftDic = {}
  self._homeMainPopDic = {}
  self._conditionGiftDic = {}
  for k,giftTypeCfg in pairs(ConfigData.pay_gift_type) do
    local data = (PayGiftInfo.CreatePayGiftInfo)(giftTypeCfg)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R7 in 'UnsetPending'

    if (self.shopGiftDic)[giftTypeCfg.inShop] == nil then
      (self.shopGiftDic)[giftTypeCfg.inShop] = true
    end
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.dataDic)[k] = data
    for _,conditonKey in ipairs(giftTypeCfg.pre_condition) do
      local conditionGifts = (self._conditionGiftDic)[conditonKey]
      if conditionGifts == nil then
        conditionGifts = {}
        -- DECOMPILER ERROR at PC50: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (self._conditionGiftDic)[conditonKey] = conditionGifts
      end
      ;
      (table.insert)(conditionGifts, data)
    end
    for _,conditonKey in ipairs(giftTypeCfg.pre_condition2) do
      local conditionGifts = (self._conditionGiftDic)[conditonKey]
      if conditionGifts == nil then
        conditionGifts = {}
        -- DECOMPILER ERROR at PC69: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (self._conditionGiftDic)[conditonKey] = conditionGifts
      end
      ;
      (table.insert)(conditionGifts, data)
    end
  end
  self.__ListenPreCondtion = BindCallback(self, self.ListenPreCondtion)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__ListenPreCondtion)
  self._timeConditionFixed = {CheckerTypeId.TimeRange}
  self._timePara1 = {}
  self._timePara2Fixed = {-1}
  ;
  (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):TryClearChipGiftPopIgnore()
end

PayGiftController.InitPayGift = function(self)
  -- function num : 0_5 , upvalues : _ENV, ShopEnum, CheckerTypeId
  self.PopOffset = 10000
  for k,v in pairs(self.dataDic) do
    v:UpdatePayGiftInfo()
  end
  self.shopId = 0
  for k,v in pairs(ConfigData.shop) do
    if v.shop_type == (ShopEnum.eShopType).PayGift then
      self.shopId = k
      break
    end
  end
  do
    self._lockedDic = {}
    self._lockedPopDic = {}
    for k,payGiftInfo in pairs(self.dataDic) do
      local giftTypeInfo = (PlayerDataCenter.GiftTypeInfos)[(payGiftInfo.groupCfg).id]
      if giftTypeInfo ~= nil then
        local PopStartTime = giftTypeInfo.popFixedTm
        local _, timeLength = payGiftInfo:GetParas34ByCondition2Id(CheckerTypeId.SectorStagePassTm)
        local PopEndTime = timeLength + PopStartTime
        ;
        (self._conditionListener):AddConditionChangeListener(-k - self.PopOffset, self.__OnConditionStateChangeCallback, {CheckerTypeId.TimeRange}, {PopStartTime}, {PopEndTime})
        payGiftInfo.startTime = PopStartTime
        payGiftInfo.endTime = PopEndTime
      end
      do
        local flag, startTime, endTime = payGiftInfo:IsUnlockTimeCondition()
        if flag then
          (self._conditionListener):AddConditionChangeListener(-k, self.__OnConditionStateChangeCallback, {CheckerTypeId.TimeRange}, {startTime}, {endTime})
        end
        local isUnlock = payGiftInfo:IsUnlock()
        local isFree = self:__IsFreeGift(payGiftInfo)
        local isUnlockPop = self:CheckPayGiftCanPop(payGiftInfo)
        -- DECOMPILER ERROR at PC97: Confused about usage of register: R13 in 'UnsetPending'

        if not isUnlock or not true then
          (self._homeMainPopDic)[k] = not isUnlockPop or nil
          -- DECOMPILER ERROR at PC104: Confused about usage of register: R13 in 'UnsetPending'

          if (payGiftInfo.groupCfg).ispop > 0 then
            (self._lockedPopDic)[k] = payGiftInfo
          end
          -- DECOMPILER ERROR at PC108: Confused about usage of register: R13 in 'UnsetPending'

          if not isUnlock then
            (self._lockedDic)[k] = payGiftInfo
          else
            if isFree then
              if payGiftInfo:IsSoldOut() then
                local nextRefreshTime = payGiftInfo:GetPayGiftNextTime()
                -- DECOMPILER ERROR at PC123: Confused about usage of register: R14 in 'UnsetPending'

                if PlayerDataCenter.timestamp < nextRefreshTime then
                  (self._timePara1)[1] = nextRefreshTime
                  ;
                  (self._conditionListener):AddConditionChangeListener(k, self.__SoldoutStateChangeChangeCallback, self._timeConditionFixed, self._timePara1, self._timePara2Fixed)
                end
              else
                do
                  do
                    local reddot = self:__GetPayGiftReddot(payGiftInfo)
                    reddot:SetRedDotCount(1)
                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC139: LeaveBlock: unexpected jumping out DO_STMT

                  end
                end
              end
            end
          end
        end
      end
    end
    self:SortHomeMainPopList()
  end
end

PayGiftController.SortHomeMainPopList = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local homeMainPopList = {}
  for id,_ in pairs(self._homeMainPopDic) do
    (table.insert)(homeMainPopList, id)
  end
  ;
  (table.sort)(homeMainPopList, function(aId, bId)
    -- function num : 0_6_0 , upvalues : self
    local aInfo = self:GetPayGiftDataById(aId)
    local bInfo = self:GetPayGiftDataById(bId)
    local orderA = aInfo:GetPopGiftSortLevel()
    local orderB = bInfo:GetPopGiftSortLevel()
    if orderB >= orderA then
      do return orderA == orderB end
      do return (bInfo.groupCfg).id < (aInfo.groupCfg).id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  self._homeMainPopList = homeMainPopList
  self._homeMainPopListIndex = 1
end

PayGiftController.UpdatePayGift = function(self, giftInfo)
  -- function num : 0_7 , upvalues : _ENV
  giftInfo:UpdatePayGiftInfo()
  if giftInfo:IsSoldOut() then
    do
      if self:__IsFreeGift(giftInfo) then
        local reddot = self:__GetPayGiftReddot(giftInfo)
        reddot:SetRedDotCount(0)
      end
      local nextRefreshTime = giftInfo:GetPayGiftNextTime()
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

      if PlayerDataCenter.timestamp < nextRefreshTime then
        (self._timePara1)[1] = nextRefreshTime
        ;
        (self._conditionListener):AddConditionChangeListener((giftInfo.groupCfg).id, self.__SoldoutStateChangeChangeCallback, self._timeConditionFixed, self._timePara1, self._timePara2Fixed)
      end
    end
  end
end

PayGiftController.__OnConditionStateChange = function(self, listenId)
  -- function num : 0_8 , upvalues : _ENV, HomeEnum
  local giftId = -listenId
  if self.PopOffset < giftId then
    giftId = giftId - self.PopOffset
  end
  local payGiftInfo = (self.dataDic)[giftId]
  local newState = payGiftInfo:IsUnlock()
  if ((self._lockedDic)[giftId] ~= nil and not newState) or (self._lockedDic)[giftId] == nil and newState then
    return 
  end
  local needRefreshPopList = false
  local isFree = self:__IsFreeGift(payGiftInfo)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

  if newState then
    (self._lockedDic)[giftId] = nil
    if isFree then
      local reddot = self:__GetPayGiftReddot(payGiftInfo)
      local redCount = payGiftInfo:IsSoldOut() and 0 or 1
      reddot:SetRedDotCount(redCount)
    end
    do
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R7 in 'UnsetPending'

      if self:CheckPayGiftCanPop(payGiftInfo) then
        (self._homeMainPopDic)[giftId] = true
        needRefreshPopList = true
        local homeController = ControllerManager:GetController(ControllerTypeId.HomeController)
        if homeController ~= nil then
          homeController:AddAutoShowGuide((HomeEnum.eAutoShwoCommand).ChipGift)
        end
      end
      do
        -- DECOMPILER ERROR at PC68: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self._lockedDic)[giftId] = payGiftInfo
        do
          if isFree then
            local reddot = self:__GetPayGiftReddot(payGiftInfo)
            reddot:SetRedDotCount(0)
          end
          -- DECOMPILER ERROR at PC78: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self._homeMainPopDic)[giftId] = nil
          needRefreshPopList = true
          if needRefreshPopList then
            self:SortHomeMainPopList()
          end
          MsgCenter:Broadcast(eMsgEventId.PayGiftItemPreConfition)
        end
      end
    end
  end
end

PayGiftController.__SoldoutStateChange = function(self, listenId, isUnlock)
  -- function num : 0_9 , upvalues : _ENV
  (self._conditionListener):RemoveConditionChangeListener(listenId)
  local giftInfo = (self.dataDic)[listenId]
  do
    if self:__IsFreeGift(giftInfo) then
      local reddot = self:__GetPayGiftReddot(giftInfo)
      reddot:SetRedDotCount(1)
    end
    MsgCenter:Broadcast(eMsgEventId.PayGiftChange, listenId)
  end
end

PayGiftController.ListenPreCondtion = function(self, conditionId)
  -- function num : 0_10 , upvalues : _ENV, CheckerTypeId, HomeEnum
  local conditionGifts = (self._conditionGiftDic)[conditionId]
  if conditionGifts == nil then
    return 
  end
  local needRefreshPopList = false
  local needBrodcast = false
  local collectDic = nil
  for _,giftInfo in pairs(conditionGifts) do
    if giftInfo:IsUnlock() and (self._lockedDic)[(giftInfo.groupCfg).id] ~= nil then
      needBrodcast = true
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (self._lockedDic)[(giftInfo.groupCfg).id] = nil
      if self:__IsFreeGift(giftInfo) then
        local reddot = self:__GetPayGiftReddot(giftInfo)
        local redcount = giftInfo:IsSoldOut() and 0 or 1
        reddot:SetRedDotCount(redcount)
      end
      do
        do
          if conditionId == CheckerTypeId.MinHeroStar and self:CheckPayGiftCanPop(giftInfo) then
            if not collectDic then
              collectDic = {}
            end
            collectDic[(giftInfo.groupCfg).id] = true
          end
          -- DECOMPILER ERROR at PC79: Confused about usage of register: R11 in 'UnsetPending'

          if giftInfo:IsUnlock() and self:CheckPayGiftCanPop(giftInfo) and (self._lockedPopDic)[(giftInfo.groupCfg).id] ~= nil then
            (self._lockedPopDic)[(giftInfo.groupCfg).id] = nil
            if not collectDic then
              collectDic = {}
            end
            collectDic[(giftInfo.groupCfg).id] = true
          end
          -- DECOMPILER ERROR at PC87: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC87: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC87: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  if collectDic ~= nil then
    local homeController = ControllerManager:GetController(ControllerTypeId.HomeController)
    if homeController ~= nil then
      for giftId,_ in pairs(collectDic) do
        -- DECOMPILER ERROR at PC107: Confused about usage of register: R12 in 'UnsetPending'

        if not (self._homeMainPopDic)[giftId] then
          (self._homeMainPopDic)[giftId] = true
          needRefreshPopList = true
          homeController:AddAutoShowGuide((HomeEnum.eAutoShwoCommand).ChipGift)
        end
      end
    end
  end
  do
    if needRefreshPopList then
      self:SortHomeMainPopList()
    end
    if needBrodcast then
      MsgCenter:Broadcast(eMsgEventId.PayGiftItemPreConfition)
    end
    return 
  end
end

PayGiftController.__GetPayGiftReddot = function(self, payGiftInfo)
  -- function num : 0_11 , upvalues : _ENV
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, self.shopId)
  if not ok then
    shopNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, self.shopId)
  end
  return (shopNode:AddChild((payGiftInfo.groupCfg).inPage)):AddChild((payGiftInfo.groupCfg).id)
end

PayGiftController.__IsFreeGift = function(self, payGiftInfo)
  -- function num : 0_12 , upvalues : _ENV
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
  if payGiftInfo:IsUseItemPay() then
    return false
  end
  local payId = (payGiftInfo.defaultCfg).payId
  local _, isFree = payCtrl:GetPayPriceInter(payId)
  return isFree
end

PayGiftController.__GetGiftInfoByChildId = function(self, childGiftId)
  -- function num : 0_13 , upvalues : _ENV
  for k,giftInfo in pairs(self.dataDic) do
    if ((giftInfo.groupCfg).giftDic)[childGiftId] ~= nil then
      return giftInfo
    end
  end
  return nil
end

PayGiftController.GetShowPayGiftByPageId = function(self, pageId, showSouldOut)
  -- function num : 0_14 , upvalues : _ENV
  local oriGroupDatas = {}
  for k,v in pairs(self.dataDic) do
    if ((v.groupCfg).pre_group == nil or #(v.groupCfg).pre_group == 0) and v:IsUnlock() and (pageId == nil or (v.groupCfg).inPage == pageId) then
      (table.insert)(oriGroupDatas, v)
    end
  end
  if showSouldOut then
    return oriGroupDatas
  end
  local dataList = {}
  for i,v in ipairs(oriGroupDatas) do
    if v:IsLinearGift() then
      local list = self:SeekNextLinearSellGift(v)
      if list ~= nil and #list > 0 then
        (table.insertto)(dataList, list)
      end
    else
      do
        do
          if not v:IsEternalAndSoldOut() and (v.needRefresh or not v:IsSoldOut()) then
            (table.insert)(dataList, v)
          end
          -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return dataList
end

PayGiftController.CheckHaveLimitGift = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  for shopId,_ in pairs(self.shopGiftDic) do
    if shopCtrl:GetIsThisShopHasTimeLimit(shopId) and #self:GetShowPayGiftByPageId(shopId) > 0 then
      return true
    end
  end
  return false
end

PayGiftController.CheckPageIdIsGiftShop = function(self, pageId)
  -- function num : 0_16
  return (self.shopGiftDic)[pageId]
end

PayGiftController.GetPayGiftDataById = function(self, id)
  -- function num : 0_17
  return (self.dataDic)[id]
end

PayGiftController.SeekNextLinearSellGift = function(self, giftGroup)
  -- function num : 0_18 , upvalues : _ENV
  local list = {}
  if giftGroup == nil or not giftGroup:IsLinearGift() then
    return list
  end
  local __SeekNextLinerSellGift = function(item)
    -- function num : 0_18_0 , upvalues : _ENV, list, self, __SeekNextLinerSellGift
    if not item:IsSoldOut() then
      (table.insert)(list, item)
      return 
    end
    for k,v in pairs((item.groupCfg).afterGroup) do
      local nextItem = (self.dataDic)[k]
      if nextItem:IsUnlock() then
        __SeekNextLinerSellGift(nextItem)
      end
    end
  end

  __SeekNextLinerSellGift(giftGroup)
  return list
end

PayGiftController.SendBuyGifit = function(self, giftCfg, params, successFunc)
  -- function num : 0_19 , upvalues : _ENV
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
  local giftId = giftCfg.id
  local giftInfo = self:__GetGiftInfoByChildId(giftId)
  local buyLogicFunc = function()
    -- function num : 0_19_0 , upvalues : _ENV, giftId, params, giftInfo, self, successFunc, giftCfg, payCtrl
    local network = NetworkManager:GetNetwork(NetworkTypeID.PayGift)
    network:CS_Gift_Buy(giftId, params, function()
      -- function num : 0_19_0_0 , upvalues : giftInfo, self, _ENV, successFunc, giftCfg, payCtrl
      if giftInfo:IsUseItemPay() then
        self:UpdatePayGift(giftInfo)
        MsgCenter:Broadcast(eMsgEventId.PayGiftChange, (giftInfo.groupCfg).id)
        if successFunc ~= nil then
          successFunc()
        end
      else
        local payId = giftCfg.payId
        if payId ~= nil then
          payCtrl:ReqPay(payId, 1, function()
        -- function num : 0_19_0_0_0 , upvalues : self, giftInfo, _ENV, successFunc
        self:UpdatePayGift(giftInfo)
        MsgCenter:Broadcast(eMsgEventId.PayGiftChange, (giftInfo.groupCfg).id)
        if successFunc ~= nil then
          successFunc()
        end
      end
, ConfigData:GetTipContent(297))
        end
      end
    end
)
  end

  do
    if giftInfo:IsUseItemPay() then
      local haveCost = PlayerDataCenter:GetItemCount(giftCfg.costId)
      if haveCost < giftCfg.costCount then
        if payCtrl:IsPayItem(giftCfg.costId) then
          payCtrl:TryConvertPayItem(giftCfg.costId, giftCfg.costCount - haveCost, nil, nil, function()
    -- function num : 0_19_1 , upvalues : buyLogicFunc
    buyLogicFunc()
  end
, false)
        else
          ;
          ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_MoneyInsufficient))
        end
        return 
      end
    end
    buyLogicFunc()
  end
end

PayGiftController.SelfSelectGift = function(self, giftCfg, payGiftInfo, successFunc)
  -- function num : 0_20 , upvalues : _ENV
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
  local giftId = giftCfg.id
  local giftInfo = self:__GetGiftInfoByChildId(giftId)
  local selfSelectParam = giftCfg.param
  if selfSelectParam == nil then
    return false
  end
  local selfSelectCfg = (ConfigData.customized_gift)[selfSelectParam]
  if selfSelectCfg == nil then
    return false
  end
  local SelfSelectGiftDealFunc = require("Game.PayGift.SelfSelectGiftDealFunc")
  local func = SelfSelectGiftDealFunc[selfSelectCfg.type]
  if func == nil then
    return false
  end
  func(selfSelectCfg, successFunc, payGiftInfo)
  return true
end

PayGiftController.GetIsGiftSouldOut = function(self, giftGroupId)
  -- function num : 0_21
  local giftInfo = (self.dataDic)[giftGroupId]
  if giftInfo ~= nil then
    return giftInfo:IsSoldOut()
  end
  return false
end

PayGiftController.IsHaveNewGiftInShop = function(self, pageId)
  -- function num : 0_22 , upvalues : _ENV
  for giftId,paygiftInfo in pairs(self.dataDic) do
    if (pageId == nil or (paygiftInfo.groupCfg).inPage == pageId) and paygiftInfo:IsUnlock() and paygiftInfo:IsNewGiftInShop() then
      return true
    end
  end
  return false
end

PayGiftController.SetAllNewBeLooked = function(self, pageId)
  -- function num : 0_23 , upvalues : _ENV
  for giftId,paygiftInfo in pairs(self.dataDic) do
    if (pageId == nil or (paygiftInfo.groupCfg).inPage == pageId) and paygiftInfo:IsUnlock() then
      paygiftInfo:SetNewGiftLooked()
    end
  end
end

PayGiftController.GetHomePopGiftDic = function(self)
  -- function num : 0_24
  return self._homeMainPopDic
end

PayGiftController.GetHomePopGiftOne = function(self, needDelete)
  -- function num : 0_25
  if self._homeMainPopList == nil then
    return nil
  end
  local giftId = (self._homeMainPopList)[self._homeMainPopListIndex]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  if giftId ~= nil and needDelete then
    (self._homeMainPopDic)[giftId] = nil
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._homeMainPopList)[self._homeMainPopListIndex] = nil
    self._homeMainPopListIndex = self._homeMainPopListIndex + 1
  end
  return giftId
end

PayGiftController.CheckPayGiftCanPop = function(self, giftInfo)
  -- function num : 0_26 , upvalues : _ENV
  if giftInfo:IsUnclockPopGift() then
    local flag = not giftInfo:IsSoldOut()
  end
  if not flag then
    return false
  end
  local giftId = (giftInfo.groupCfg).id
  local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local time, endTime = userData:GetChipGiftPopIgnore(giftId)
  if time ~= nil then
    if endTime ~= nil and endTime < PlayerDataCenter.timestamp then
      return true
    end
    return false
  end
  return true
end

PayGiftController.GetPopGiftType = function(self, giftInfo)
  -- function num : 0_27
  return giftInfo:GetPopGiftType()
end

PayGiftController.ShowPayGiftWin = function(self, giftInfo, callback)
  -- function num : 0_28 , upvalues : Local_GroupPopFunc, PopFuncDic, _ENV
  local groupPopId = giftInfo:GeyGiftGroupPopId()
  if groupPopId > 0 then
    Local_GroupPopFunc(groupPopId, callback, self)
    return 
  end
  local winPopFunc = PopFuncDic[giftInfo:GetPopGiftType()]
  if winPopFunc ~= nil then
    winPopFunc(giftInfo, callback)
  else
    error("对应礼包弹窗类型不存在 " .. tostring(giftInfo:GetPopGiftType()))
  end
end

PayGiftController.ShowHeroGiftWin = function(self, giftInfo, callback)
  -- function num : 0_29 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CustomHeroGift, function(window)
    -- function num : 0_29_0 , upvalues : _ENV, giftInfo, callback
    if IsNull(window) then
      return 
    end
    window:InitCustomHeroGift(giftInfo, callback)
  end
)
end

PayGiftController.OnDelete = function(self)
  -- function num : 0_30 , upvalues : _ENV, base
  (self._conditionListener):Delete()
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__ListenPreCondtion)
  ;
  (base.OnDelete)(self)
end

return PayGiftController

