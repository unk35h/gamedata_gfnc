-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopController = class("ShopController", ControllerBase)
local ShopEnum = require("Game.Shop.ShopEnum")
local ShopBaseData = require("Game.Shop.Data.ShopDataBase")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local shopDataClasses = {[(ShopEnum.eShopType).Normal] = require("Game.Shop.Data.NormalShopData"), [(ShopEnum.eShopType).Skin] = require("Game.Shop.Data.SkinShopData"), [(ShopEnum.eShopType).Random] = require("Game.Shop.Data.RefreshShopData"), [(ShopEnum.eShopType).Resource] = require("Game.Shop.Data.ResourceShopData"), [(ShopEnum.eShopType).ResourceRefresh] = require("Game.Shop.Data.ResourceRefreshShopData"), [(ShopEnum.eShopType).Charcter] = require("Game.Shop.Data.HeroShopData"), [(ShopEnum.eShopType).Recharge] = require("Game.Shop.Data.RechargeShopData")}
ShopController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.shopDataDic = {}
  self.redDotTimerDic = {}
  self.network = NetworkManager:GetNetwork(NetworkTypeID.Shop)
  self.isUnlocked = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store)
  self.shopCommonTimerFunDic = {}
  self.shopCommonTimer = TimerManager:StartTimer(1, self.OnShopCommonTimerTick, self, false, false, true)
  TimerManager:PauseTimer(self.shopCommonTimer)
end

ShopController.SetIsUnLock = function(self, bool)
  -- function num : 0_1
  self.isUnlocked = bool
end

ShopController.GetIsUnlock = function(self)
  -- function num : 0_2
  return self.isUnlocked
end

ShopController.ReqShopDetail = function(self, shopId, callback)
  -- function num : 0_3 , upvalues : _ENV, shopDataClasses
  local next = function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    (table.remove)(self.__wait2SentReq, 1)
    if #self.__wait2SentReq > 0 then
      ((self.__wait2SentReq)[1])()
    end
  end

  local nextFunc = function()
    -- function num : 0_3_1 , upvalues : _ENV, shopId, next, self, shopDataClasses, callback
    local shopCfg = (ConfigData.shop)[shopId]
    if shopCfg == nil then
      error("can\'t read shopCfg id = " .. shopId)
      next()
    else
      ;
      (self.network):CS_STORE_Detail(shopId, function(args)
      -- function num : 0_3_1_0 , upvalues : self, shopId, shopDataClasses, shopCfg, _ENV, callback, next
      if args ~= nil and args.Count > 0 then
        local shopDataMsg = args[0]
        local shopData = (self.shopDataDic)[shopId]
        if shopData ~= nil then
          shopData:UpdateShopData(shopDataMsg)
        else
          local shopDataClass = shopDataClasses[shopCfg.shop_type]
          if shopDataClass == nil then
            error("shopDataClass is nil for shopId:" .. tostring(shopId))
          end
          shopData = (shopDataClass.New)()
          shopData:InitShopData(shopDataMsg, shopId)
          -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

          ;
          (self.shopDataDic)[shopData.shopId] = shopData
        end
        do
          do
            self:StartOneShopRedDot(shopData)
            error("require shopData not have data")
            if callback ~= nil then
              callback()
            end
            next()
          end
        end
      end
    end
)
    end
  end

  if self.__wait2SentReq == nil then
    self.__wait2SentReq = {}
  end
  ;
  (table.insert)(self.__wait2SentReq, nextFunc)
  if #self.__wait2SentReq == 1 then
    nextFunc()
  end
end

ShopController.ReqRefreshShopDetail = function(self, shopId, callback)
  -- function num : 0_4 , upvalues : _ENV
  local next = function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    (table.remove)(self.__wait2SentReqRefresh, 1)
    if #self.__wait2SentReqRefresh > 0 then
      ((self.__wait2SentReqRefresh)[1])()
    end
  end

  local nextFunc = function()
    -- function num : 0_4_1 , upvalues : self, shopId, _ENV, callback, next
    (self.network):CS_STORE_Fresh(shopId, function(args)
      -- function num : 0_4_1_0 , upvalues : self, shopId, _ENV, callback, next
      if args ~= nil and args.Count > 0 and (self.shopDataDic)[shopId] ~= nil then
        local shopDataMsg = args[0]
        local shopData = (self.shopDataDic)[shopId]
        shopData:UpdateShopData(shopDataMsg)
      else
        do
          error("CS_STORE_Fresh require shopData not have data")
          if callback ~= nil then
            callback()
          end
          next()
        end
      end
    end
)
  end

  if self.__wait2SentReqRefresh == nil then
    self.__wait2SentReqRefresh = {}
  end
  ;
  (table.insert)(self.__wait2SentReqRefresh, nextFunc)
  if #self.__wait2SentReqRefresh == 1 then
    nextFunc()
  end
end

ShopController.ReqBuySuitGoods = function(self, storeId, shelf2Cnt, callback)
  -- function num : 0_5 , upvalues : _ENV
  (self.network):CS_STORE_Purchase_Batch(storeId, shelf2Cnt, function(objList)
    -- function num : 0_5_0 , upvalues : _ENV, self, storeId, callback
    if objList.Count ~= 1 then
      error("CS_STORE_Purchase objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local CommonStoreShelfDataList = objList[0]
    for k,CommonStoreShelfData in pairs(CommonStoreShelfDataList) do
      self:RefreshGoodsData(CommonStoreShelfData, storeId)
    end
    MsgCenter:Broadcast(eMsgEventId.ShopSuitGoodsBuyed, storeId)
    if callback ~= nil then
      callback()
    end
  end
)
end

ShopController.ReqBuyGoods = function(self, storeId, shelfId, cnt, callback)
  -- function num : 0_6 , upvalues : _ENV
  if not cnt then
    cnt = 1
  end
  ;
  (self.network):CS_STORE_Purchase(storeId, shelfId, cnt, function(objList)
    -- function num : 0_6_0 , upvalues : _ENV, self, storeId, shelfId, callback
    if objList.Count ~= 1 then
      error("CS_STORE_Purchase objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local CommonStoreShelfData = objList[0]
    self:RefreshGoodsData(CommonStoreShelfData, storeId)
    MsgCenter:Broadcast(eMsgEventId.ShopGoodsBuyed, storeId, shelfId)
    if callback ~= nil then
      callback()
    end
  end
)
end

ShopController.ReqExchangeGoods = function(self, toId, num, callback)
  -- function num : 0_7
  (self.network):CS_BACKPACK_Exchange(toId, num, callback)
end

ShopController.RefreshGoodsData = function(self, CommonStoreShelfData, shopId)
  -- function num : 0_8 , upvalues : _ENV
  local shopData = (self.shopDataDic)[shopId]
  if shopData == nil then
    error("can\'t get shopData by Id:" .. tostring(shopId))
    return 
  end
  local goodsData = (shopData.shopGoodsDic)[CommonStoreShelfData.shelfId]
  if goodsData == nil then
    error("can\'t get goodsData by shelfId:" .. tostring(CommonStoreShelfData.shelfId))
    return 
  end
  goodsData:UpdateShopGoodData(CommonStoreShelfData)
end

ShopController.GetShopData = function(self, shopId, callback, notLoclJudge)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC11: Unhandled construct in 'MakeBoolean' P1

  if not notLoclJudge and not self:ShopIsUnlock(shopId) and callback ~= nil then
    callback(nil)
  end
  do return  end
  local shopData = (self.shopDataDic)[shopId]
  if shopData == nil then
    self:ReqShopDetail(shopId, function()
    -- function num : 0_9_0 , upvalues : callback, self, shopId
    if callback ~= nil then
      callback((self.shopDataDic)[shopId])
    end
  end
)
  else
    local isNeedFresh = not shopData:GetIsHaveRefresh() or shopData:GetRemainAutoRefreshTime() < 0
    local isGoodsNeedFresh = shopData:GetIsHaveRefreshItem()
    if isNeedFresh or isGoodsNeedFresh then
      self:ReqShopDetail(shopId, function()
    -- function num : 0_9_1 , upvalues : callback, self, shopId
    if callback ~= nil then
      callback((self.shopDataDic)[shopId])
    end
  end
)
    else
      callback(shopData)
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

ShopController.ShopShowBeforeUnlock = function(self, shopId)
  -- function num : 0_10 , upvalues : _ENV
  local flag = ((ConfigData.game_config).shopShowBeforeUnlockDic)[shopId]
  if flag == nil or flag == false then
    return false
  else
    return true
  end
end

ShopController.ShopIsUnlock = function(self, shopId)
  -- function num : 0_11 , upvalues : _ENV
  local cfg = (ConfigData.shop)[shopId]
  if cfg == nil then
    return false
  end
  return (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2), (CheckCondition.GetUnlockInfoLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
end

ShopController.ShopIsUnlockOnly = function(self, shopId)
  -- function num : 0_12 , upvalues : _ENV
  local cfg = (ConfigData.shop)[shopId]
  if cfg == nil then
    return false
  end
  return (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
end

ShopController.StartShopAllRedDot = function(self)
  -- function num : 0_13 , upvalues : _ENV, ShopEnum
  if not self.isUnlocked then
    return 
  end
  local showShopDic = (ConfigData.shop_classification).showShopDic
  for k,shopId in ipairs((ConfigData.shop).id_sort_list) do
    local shopCfg = (ConfigData.shop)[shopId]
    if shopCfg.shop_type == (ShopEnum.eShopType).PayGift and (CheckCondition.CheckLua)(shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2) then
      local saveUserData = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData))
      do
        local monthCardPageId = nil
        for _,pageId in ipairs(shopCfg.shop_para) do
          local pageCfg = (ConfigData.shop_page)[pageId]
          if pageCfg.mark == (ShopEnum.ePageMarkType).MonthCard then
            monthCardPageId = pageId
            break
          end
        end
        do
          if monthCardPageId ~= nil then
            local isBoughtMonthCardRDClosed = saveUserData:GetIsSReddotClose(RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring(shopId) .. "." .. tostring(monthCardPageId))
            if not isBoughtMonthCardRDClosed then
              do
                local shopNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId, monthCardPageId)
                shopNode:SetRedDotCount(1)
                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
        if showShopDic[shopId] and shopCfg.isRefreshShop and (CheckCondition.CheckLua)(shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2) then
          self:RemoveShopTimerCallback((self.redDotTimerDic)[shopId])
          -- DECOMPILER ERROR at PC103: Confused about usage of register: R8 in 'UnsetPending'

          ;
          (self.redDotTimerDic)[shopId] = nil
          local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleStoreSystemReset, shopId)
          if counterElem == nil then
            local shopNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
            shopNode:SetRedDotCount(1)
          else
            do
              local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
              local isBoughtMonthCardRDClosed = saveUserData:GetIsSReddotClose(RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring(shopId))
              do
                do
                  if isBoughtMonthCardRDClosed ~= nil and not isBoughtMonthCardRDClosed then
                    local shopNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
                    shopNode:SetRedDotCount(1)
                  end
                  if PlayerDataCenter.timestamp < counterElem.nextExpiredTm then
                    self:_StartShopRedDotTimer(shopId, counterElem.nextExpiredTm)
                  end
                  if shopId == (ShopEnum.ShopId).supportShop then
                    local maxPoint = (ConfigData.game_config).supportPointMaxNum
                    local shopNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
                    local SFSPNode = shopNode:AddChildWithPath(RedDotStaticTypeId.ShopFriendSupportBtn, RedDotDynPath.ShopFriendSupportBtnPath)
                    local curPoint = (PlayerDataCenter.inforData):GetCurSupportPoint()
                    if maxPoint <= curPoint then
                      SFSPNode:SetRedDotCount(1)
                    else
                      SFSPNode:SetRedDotCount(0)
                    end
                    self.__FriendShipPointReddotTimerId = TimerManager:StartTimer(60, function()
    -- function num : 0_13_0 , upvalues : _ENV, maxPoint, SFSPNode
    local curPoint = (PlayerDataCenter.inforData):GetCurSupportPoint()
    if maxPoint <= curPoint then
      SFSPNode:SetRedDotCount(1)
    else
      SFSPNode:SetRedDotCount(0)
    end
  end
, self, false, false, true)
                  end
                  do
                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC215: LeaveBlock: unexpected jumping out IF_STMT

                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

ShopController.AddMonthCardRedDot = function(self, hasDiscount)
  -- function num : 0_14 , upvalues : _ENV, ShopEnum
  local monthCardPageId = nil
  for _,pageId in ipairs(((ConfigData.shop)[(ShopEnum.ShopId).gift]).shop_para) do
    local pageCfg = (ConfigData.shop_page)[pageId]
    if pageCfg.mark == (ShopEnum.ePageMarkType).MonthCard then
      monthCardPageId = pageId
      break
    end
  end
  do
    if monthCardPageId == nil then
      return 
    end
    local needReddot = false
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    if hasDiscount then
      local pathStr = RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring((ShopEnum.ShopId).gift) .. "." .. tostring(monthCardPageId) .. "discount"
      local isBoughtMonthCardRDClosed = saveUserData:GetIsSReddotClose(pathStr)
      if not isBoughtMonthCardRDClosed then
        needReddot = true
      end
    end
    do
      if not needReddot then
        local leftday = (PlayerDataCenter.dailySignInData):GetMonthCardLeftCount()
        if leftday > 0 and leftday <= (ConfigData.game_config).monthCardReddot then
          local lastTime = saveUserData:GetLastMonthCardRenew()
          local curTime = (math.floor)(PlayerDataCenter.timestamp)
          local leftTime = curTime - lastTime
          local d, h, m, s = TimeUtil:TimestampToTimeInter(leftTime, false, true)
          if (ConfigData.game_config).monthCardReddot < d then
            needReddot = true
          end
        end
      end
      do
        if needReddot then
          local shopNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, (ShopEnum.ShopId).gift, monthCardPageId)
          if shopNode ~= nil then
            shopNode:SetRedDotCount(1)
          end
        end
      end
    end
  end
end

ShopController.AddMonthCardRenewReddot = function(self)
  -- function num : 0_15
end

ShopController.StartOneShopRedDot = function(self, shopData)
  -- function num : 0_16
  if not shopData:GetIsHaveRefresh() then
    return 
  end
  local nextTime = shopData.freeFreshTm
  self:_StartShopRedDotTimer(shopData.shopId, nextTime)
end

ShopController._StartShopRedDotTimer = function(self, shopId, nextTime)
  -- function num : 0_17 , upvalues : _ENV
  if (self.redDotTimerDic)[shopId] ~= nil then
    self:RemoveShopTimerCallback((self.redDotTimerDic)[shopId])
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.redDotTimerDic)[shopId] = nil
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.redDotTimerDic)[shopId] = function()
    -- function num : 0_17_0 , upvalues : nextTime, _ENV, self, shopId
    if nextTime < PlayerDataCenter.timestamp then
      self:RemoveShopTimerCallback((self.redDotTimerDic)[shopId])
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.redDotTimerDic)[shopId] = nil
      local shopNode = RedDotController:AddRedDotNodeWithPath(RedDotDynPath.ShopPath, RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
      shopNode:SetRedDotCount(1)
      local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      saveUserData:SetSReddotClose(RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring(shopId), false)
    end
  end

  self:AddShopTimerCallback((self.redDotTimerDic)[shopId], "refreshShop out side redddot:" .. tostring(shopId))
end

ShopController.StopShopRedDot = function(self)
  -- function num : 0_18 , upvalues : _ENV
  for _,func in pairs(self.redDotTimerDic) do
    self:RemoveShopTimerCallback(func)
  end
  if self.__FriendShipPointReddotTimerId ~= nil then
    TimerManager:StopTimer(self.__FriendShipPointReddotTimerId)
    self.__FriendShipPointReddotTimerId = nil
  end
end

ShopController.IsShopBlueReddot = function(self, shopId)
  -- function num : 0_19 , upvalues : ShopEnum, _ENV
  if shopId == (ShopEnum.ShopId).supportShop then
    return false
  end
  local shopCfg = (ConfigData.shop)[shopId]
  do return (shopCfg ~= nil and shopCfg.isRefreshShop) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ShopController.OnOpenShopSetShopRedDot = function(self, shopId)
  -- function num : 0_20 , upvalues : ShopEnum, _ENV
  do
    if shopId ~= (ShopEnum.ShopId).supportShop then
      local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId)
      if ok then
        shopNode:SetRedDotCount(0)
      end
    end
    local shopCfg = (ConfigData.shop)[shopId]
    if shopCfg.isRefreshShop and (CheckCondition.CheckLua)(shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2) then
      local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      saveUserData:SetSReddotClose(RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring(shopId), true)
    end
  end
end

ShopController.AddShopTimerCallback = function(self, callback, name)
  -- function num : 0_21 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if not (self.shopCommonTimerFunDic)[callback] then
    (self.shopCommonTimerFunDic)[callback] = name
    if TimerManager:IsTimerPaused(self.shopCommonTimer) then
      TimerManager:ResumeTimer(self.shopCommonTimer)
    end
  end
end

ShopController.RemoveShopTimerCallback = function(self, callback)
  -- function num : 0_22 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  if callback ~= nil and (self.shopCommonTimerFunDic)[callback] ~= nil then
    (self.shopCommonTimerFunDic)[callback] = nil
    if (table.count)(self.shopCommonTimerFunDic) == 0 then
      TimerManager:PauseTimer(self.shopCommonTimer)
    end
  end
end

ShopController.OnShopCommonTimerTick = function(self)
  -- function num : 0_23 , upvalues : _ENV
  for callback,name in pairs(self.shopCommonTimerFunDic) do
    if not pcall(callback) then
      error(name)
    end
  end
end

ShopController.ReqShopRecharge = function(self, pay_id)
  -- function num : 0_24 , upvalues : _ENV
  self._rechargePayId = pay_id
  if not self._OnShopRechargeFunc then
    self._OnShopRechargeFunc = BindCallback(self, self._OnShopRecharge)
    ;
    (self.network):CS_STORE_Recharge(pay_id, self._OnShopRechargeFunc)
  end
end

ShopController._OnShopRecharge = function(self)
  -- function num : 0_25 , upvalues : _ENV
  (ControllerManager:GetController(ControllerTypeId.Pay, true)):ReqPay(self._rechargePayId, 1)
end

ShopController.AfterShopRechargeComplete = function(self, CommonStore)
  -- function num : 0_26 , upvalues : _ENV
  if (self.shopDataDic)[CommonStore.storeId] ~= nil then
    for k,CommonStoreShelf in pairs(CommonStore.data) do
      self:RefreshGoodsData(CommonStoreShelf, CommonStore.storeId)
    end
  end
  do
    MsgCenter:Broadcast(eMsgEventId.ShopRechargeComplete, CommonStore.storeId)
  end
end

ShopController.IsHaveNewGoodItemInShop = function(self, shopData)
  -- function num : 0_27 , upvalues : _ENV
  if shopData == nil then
    return 
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local isHaveNew = false
  for i,goodData in pairs(shopData.shopGoodsDic) do
    local isNotNew = (saveUserData:GetNewItemReddotDic())[goodData.itemId]
    if goodData.isSoldOut == false and not isNotNew then
      isHaveNew = true
      break
    end
  end
  do
    return isHaveNew
  end
end

ShopController.GetIsHaveNewSkinGoodItemInShop = function(self)
  -- function num : 0_28 , upvalues : ShopEnum
  local shopData = (self.shopDataDic)[(ShopEnum.ShopId).skin]
  if shopData == nil then
    return false
  end
  local isHaveNew = self:IsHaveNewGoodItemInShop(shopData)
  return isHaveNew
end

ShopController.IsHaveNewSkinGoodItemInShop = function(self, callback)
  -- function num : 0_29 , upvalues : ShopEnum
  local shopData = (self.shopDataDic)[(ShopEnum.ShopId).skin]
  if shopData == nil then
    self:GetShopData((ShopEnum.ShopId).skin, function(shopData)
    -- function num : 0_29_0 , upvalues : self, callback
    local isHavaNew = self:IsHaveNewGoodItemInShop(shopData)
    if callback then
      callback(isHavaNew)
    end
  end
)
    return 
  end
  local isHavaNew = self:IsHaveNewGoodItemInShop(shopData)
  if callback then
    callback(isHavaNew)
  end
end

ShopController.SetHaveNewGoodItemInShop = function(self, shopData)
  -- function num : 0_30 , upvalues : _ENV
  if shopData == nil then
    return 
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for i,goodData in pairs(shopData.shopGoodsDic) do
    saveUserData:SetNewItemReddot(goodData.itemId, true)
  end
end

ShopController.GetShopIsSouldOut = function(self, shopId)
  -- function num : 0_31 , upvalues : _ENV
  local shopCfg = (ConfigData.shop)[shopId]
  if shopCfg == nil then
    return true
  end
  local shopData = (self.shopDataDic)[shopId]
  if shopData == nil then
    return true
  end
  local empty = true
  for i,goodData in pairs(shopData.shopGoodsDic) do
    local isTimelimit, inTime = goodData:GetStillTime()
    if isTimelimit and inTime and goodData.isSoldOut == false then
      empty = false
      break
    end
  end
  do
    return empty
  end
end

ShopController.GetShelfIsSouldOut = function(self, shopId, shelfId)
  -- function num : 0_32 , upvalues : _ENV, ShopEnum
  local shopCfg = (ConfigData.shop)[shopId]
  if shopCfg == nil then
    return true
  end
  if shopCfg.shop_type == (ShopEnum.eShopType).PayGift then
    local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
    return payGiftCtrl:GetIsGiftSouldOut(shelfId)
  else
    do
      local shopData = (self.shopDataDic)[shopId]
      if shopData == nil then
        return true
      end
      local goodData = (shopData.shopGoodsDic)[shelfId]
      if goodData == nil then
        return true
      end
      local isTimelimit, inTime = goodData:GetStillTime()
      if isTimelimit and not inTime then
        return true
      end
      do return goodData.isSoldOut end
    end
  end
end

ShopController.GetShelfOutDataTime = function(self, shopId, shelfId)
  -- function num : 0_33 , upvalues : _ENV, ShopEnum
  local shopCfg = (ConfigData.shop)[shopId]
  if shopCfg == nil then
    return false
  end
  if shopCfg.shop_type == (ShopEnum.eShopType).PayGift then
    return false
  end
  local shopData = (self.shopDataDic)[shopId]
  if shopData == nil then
    return false
  end
  local goodData = (shopData.shopGoodsDic)[shelfId]
  if goodData == nil then
    return false
  end
  local outDataTime = -1
  if shopData.isRefreshShop then
    outDataTime = shopData.freeFreshTm
  end
  local isTimelimit, inTime, _, endTime = goodData:GetStillTime()
  if isTimelimit and (outDataTime <= 0 or outDataTime >= endTime or not outDataTime) then
    outDataTime = endTime
  end
  do return outDataTime > 0, outDataTime, true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ShopController.GetIsThisShopHasTimeLimit = function(self, shopId)
  -- function num : 0_34 , upvalues : _ENV, CheckerTypeId
  local shopCfg = (ConfigData.shop)[shopId]
  if shopCfg == nil then
    return false
  end
  if not (CheckCondition.CheckLua)(shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2) then
    return false
  end
  for index,conditonTypeId in ipairs(shopCfg.pre_condition) do
    if conditonTypeId == CheckerTypeId.TimeRange then
      return true, (shopCfg.pre_para1)[index], (shopCfg.pre_para2)[index]
    else
      if conditonTypeId == CheckerTypeId.SectorStagePassTm then
        local ok, outRange, sectorPassTm, realSectorPassTm = (PlayerDataCenter.sectorStage):CheckSectorPassTmInRange((shopCfg.pre_para1)[index], (shopCfg.pre_para2)[index])
        return true, sectorPassTm, realSectorPassTm
      end
    end
  end
  return false
end

ShopController.CheckShopInTimePeriod = function(self, shopId)
  -- function num : 0_35 , upvalues : _ENV
  local hasTimeFlag, startTime, endTime = self:GetIsThisShopHasTimeLimit(shopId)
  if startTime > PlayerDataCenter.timestamp or PlayerDataCenter.timestamp >= endTime then
    do return not hasTimeFlag end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

ShopController.OnDelete = function(self)
  -- function num : 0_36 , upvalues : _ENV
  self:StopShopRedDot()
  self.shopDataDic = nil
  if self.shopCommonTimer ~= nil then
    TimerManager:StopTimer(self.shopCommonTimer)
    self.shopCommonTimer = nil
  end
end

return ShopController

