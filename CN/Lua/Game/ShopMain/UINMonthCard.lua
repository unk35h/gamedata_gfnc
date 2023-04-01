-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMonthCard = class("UINMonthCard", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
UINMonthCard.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  self.rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  self.extrRewardList = {}
  self.__Refresh = BindCallback(self, self.Refresh)
  MsgCenter:AddListener(eMsgEventId.MonthCardRefresh, self.__Refresh)
  self.__CountDownExpire = BindCallback(self, self.CountDownExpire)
  if ((Consts.GameChannelType).IsJp)() then
    ((self.ui).obj_JpQz):SetActive(true)
  end
end

UINMonthCard.ShopCommonInit = function(self, uiShop)
  -- function num : 0_1
  self.uiShop = uiShop
  self.shopCtrl = uiShop.shopCtrl
end

UINMonthCard.RefreshShopNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.RefreshTopResId)({ConstGlobalItem.PaidItem, ConstGlobalItem.PaidSubItem})
  self:InitMonthCard()
  self:RefreshSpecailReddot(shopId, pageId)
  ;
  (self.uiShop):RefreshHeadBar(nil)
end

UINMonthCard.InitMonthCard = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self.rewardPool):HideAll()
  self.monthCardCfg = (ConfigData.month_card)[1]
  for i = 1, #(self.monthCardCfg).first_award_ids do
    local itemCfg = (ConfigData.item)[((self.monthCardCfg).first_award_ids)[i]]
    local count = ((self.monthCardCfg).first_award_nums)[i]
    local item = (self.rewardPool):GetOne(true)
    ;
    (item.gameObject):SetActive(true)
    ;
    (item.transform):SetParent(((self.ui).obj_CurrentItemList).transform)
    item:InitItemWithCount(itemCfg, count, nil, false)
  end
  for i = 1, #(self.monthCardCfg).daily_award_ids do
    local itemCfg = (ConfigData.item)[((self.monthCardCfg).daily_award_ids)[i]]
    local count = ((self.monthCardCfg).daily_award_nums)[i]
    local item = (self.rewardPool):GetOne(true)
    ;
    (item.gameObject):SetActive(true)
    ;
    (item.transform):SetParent(((self.ui).obj_DailyItemList).transform)
    item:InitItemWithCount(itemCfg, count, nil, false)
    ;
    (table.insert)(self.extrRewardList, item)
  end
  self:Refresh()
end

UINMonthCard.RefreshSpecailReddot = function(self, shopId, pageId)
  -- function num : 0_4 , upvalues : _ENV
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, shopId, pageId)
  if ok then
    shopNode:SetRedDotCount(0)
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local specStr = RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring(shopId) .. "." .. tostring(pageId)
  saveUserData:SetSReddotClose(specStr, true)
  local pathStr = RedDotStaticTypeId.Main .. "." .. RedDotStaticTypeId.ShopWindow .. "." .. tostring(shopId) .. "." .. tostring(pageId) .. "discount"
  saveUserData:SetSReddotClose(pathStr, true)
  local leftday = (PlayerDataCenter.dailySignInData):GetMonthCardLeftCount()
  if leftday > 0 and leftday <= (ConfigData.game_config).monthCardReddot then
    local showTime = (math.floor)(PlayerDataCenter.timestamp)
    saveUserData:SetLastMonthCardRenew(showTime)
  end
end

UINMonthCard.Refresh = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local dailySignInData = PlayerDataCenter.dailySignInData
  local dayCount = dailySignInData:GetMonthCardLeftCount()
  local isCanBuy = not dailySignInData:IsLimitMonthCardBuy()
  local isDiscount, discountDuration = dailySignInData:IsCardDiscount()
  self.isDiscount = isDiscount
  local priceId = (self.monthCardCfg).price
  if isDiscount then
    priceId = (self.monthCardCfg).discount_price
    ;
    ((self.ui).obj_discount):SetActive(true)
    self:RefreshDiscountTimeLimit(discountDuration)
  else
    ;
    ((self.ui).obj_discount):SetActive(false)
  end
  local payCtr = ControllerManager:GetController(ControllerTypeId.Pay, true)
  local priceStr, price = payCtr:GetPayPriceShow(priceId)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Price).text = priceStr
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).btn_Buy).enabled = isCanBuy
  ;
  ((self.ui).obj_GetLimited):SetActive(not isCanBuy)
  if isCanBuy then
    ((self.ui).obj_Price):SetActive(true)
    local hasMonthCard = dailySignInData:IsHaveCard()
    local idx = hasMonthCard and 1 or 0
    ;
    ((self.ui).tex_PriceInfo):SetIndex(idx)
  else
    do
      ;
      ((self.ui).obj_Price):SetActive(false)
      if dailySignInData:IsHaveCard() then
        ((self.ui).tex_Time):SetIndex(0, tostring(dayCount))
        -- DECOMPILER ERROR at PC93: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (((self.ui).tex_Time).text).color = (self.ui).color_hasCardText
      else
        ;
        ((self.ui).tex_Time):SetIndex(1)
        -- DECOMPILER ERROR at PC105: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (((self.ui).tex_Time).text).color = (self.ui).color_noHaveCardText
      end
      for i,v in ipairs(self.extrRewardList) do
        v:SetPickedUIActive(dailySignInData:IsHaveCard())
      end
      if self.waitingMonthCardreward then
        local mailController = ControllerManager:GetController(ControllerTypeId.Mail, false)
        local notPickedSinginMailUIDList = mailController:GetSignInRewardMailUIDs(true, true, true)
        if #notPickedSinginMailUIDList > 0 then
          self:ShowCollectSignInReward(mailController, notPickedSinginMailUIDList, 1)
        end
        self.waitingMonthCardreward = nil
      end
      do
        if PlayerDataCenter.timestamp <= (PlayerDataCenter.dailySignInData).expireAt or (PlayerDataCenter.dailySignInData):IsCardDiscount() then
          (self.shopCtrl):AddShopTimerCallback(self.__CountDownExpire, "monthCard")
        end
      end
    end
  end
end

UINMonthCard.RefreshDiscountTimeLimit = function(self, discountDuration)
  -- function num : 0_6 , upvalues : _ENV
  local timeStr = ""
  local diff = discountDuration - PlayerDataCenter.timestamp
  if diff < 0 then
    timeStr = (string.format)(ConfigData:GetTipContent(6045), "0")
  end
  local d, h, m = TimeUtil:TimestampToTimeInter(diff, false, true)
  if d > 0 then
    timeStr = (string.format)(ConfigData:GetTipContent(6043), tostring(d))
  else
    if h > 0 then
      timeStr = (string.format)(ConfigData:GetTipContent(6044), tostring(h))
    else
      timeStr = (string.format)(ConfigData:GetTipContent(6045), tostring(m))
    end
  end
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_discount).text = timeStr
end

UINMonthCard.CountDownExpire = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if (PlayerDataCenter.dailySignInData).expireAt < PlayerDataCenter.timestamp or self.isDiscount then
    (self.shopCtrl):RemoveShopTimerCallback(self.__CountDownExpire)
    self:Refresh()
  end
end

UINMonthCard.ShowCollectSignInReward = function(self, mailController, notPickedSinginMailUIDList, index)
  -- function num : 0_8 , upvalues : _ENV, CommonRewardData
  local mailUid = notPickedSinginMailUIDList[index]
  if mailController == nil or (mailController.mailDataDic)[mailUid] == nil then
    error("can\'t get mail data with UID:" .. tostring(mailUid))
    return 
  end
  local win = UIManager:GetWindow(UIWindowTypeID.CommonReward)
  if win ~= nil and win.active then
    win:BindCommonRewardExit(function()
    -- function num : 0_8_0 , upvalues : self, mailController, notPickedSinginMailUIDList, index
    self:ShowCollectSignInReward(mailController, notPickedSinginMailUIDList, index)
  end
)
    return 
  end
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Mail)):CS_MAIL_ReceiveAttachment(mailUid, function()
    -- function num : 0_8_1 , upvalues : _ENV, mailController, mailUid, CommonRewardData, self, index, notPickedSinginMailUIDList
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_8_1_0 , upvalues : mailController, mailUid, _ENV, CommonRewardData, self, index, notPickedSinginMailUIDList
      local rewardIds = {}
      local rewardNums = {}
      local _, rewardDic, _ = ((mailController.mailDataDic)[mailUid]):IsHaveAtt()
      for id,num in pairs(rewardDic) do
        (table.insert)(rewardIds, id)
        ;
        (table.insert)(rewardNums, num)
      end
      if window == nil then
        return 
      end
      local CRData = ((((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot)):SetCRTitle(ConfigData:GetTipContent(14024))):SetCRShowOverFunc(function()
        -- function num : 0_8_1_0_0 , upvalues : index, notPickedSinginMailUIDList, self, mailController
        local index = index
        if index < #notPickedSinginMailUIDList then
          index = index + 1
          self:ShowCollectSignInReward(mailController, notPickedSinginMailUIDList, index)
        end
      end
)
      window:AddAndTryShowReward(CRData)
      mailController:ReqDeleteOneMail(mailUid)
    end
)
  end
)
end

UINMonthCard.OnClickBuy = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if (PlayerDataCenter.dailySignInData):IsLimitMonthCardBuy() then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.DailySignIn)
  if self.isDiscount then
    network:CS_MONTH_CARD_BUY((self.monthCardCfg).discount_price)
  else
    network:CS_MONTH_CARD_BUY((self.monthCardCfg).price)
  end
  self.waitingMonthCardreward = true
end

UINMonthCard.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.MonthCardRefresh, self.__Refresh)
  ;
  (self.shopCtrl):RemoveShopTimerCallback(self.__CountDownExpire)
  ;
  (base.OnDelete)(self)
end

return UINMonthCard

