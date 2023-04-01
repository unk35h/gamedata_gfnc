-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonItemDetailWin = class("UICommonItemDetailWin", UIBaseWindow)
local base = UIBaseWindow
local util = require("XLua.Common.xlua_util")
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
local UINAthDetailItem = require("Game.Arithmetic.AthDetail.UINAthDetailItem")
local UINRaffleDetailItem = require("Game.CommonUI.ItemDetail.UINRaffleDetailItem")
local JumpInfoItem = require("Game.CommonUI.ItemDetail.UICIDJumpInfoItem")
local JumpManager = require("Game.Jump.JumpManager")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local cs_MessageCommon = CS.MessageCommon
UICommonItemDetailWin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItem, UINAthDetailItem, JumpInfoItem, UINRaffleDetailItem
  self.isARG = false
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_return, self, self.OnBtnReturnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Use, self, self.OnBtnUseClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Left, self, self.OnClickSwitchLeft)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Right, self, self.OnClickSwitchRight)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_UseGift, self, self.OnClickUse)
  self.resloader = ((CS.ResLoader).Create)()
  self.baseItem = (UINBaseItem.New)()
  ;
  (self.baseItem):Init((self.ui).uINBaseItem)
  ;
  (self.baseItem):BindBaseItemResloader(self.resloader)
  self.athInfoNode = (UINAthDetailItem.New)()
  ;
  (self.athInfoNode):Init((self.ui).aTHDetailItem)
  self.poolInfoItem = (UIItemPool.New)(JumpInfoItem, (self.ui).obj_jumpInfoItem)
  ;
  ((self.ui).obj_jumpInfoItem):SetActive(false)
  self.raffleItemPool = (UIItemPool.New)(UINRaffleDetailItem, (self.ui).obj_raffleItem, false)
  self.__OnItemRefresh = BindCallback(self, self.OnItemRefresh)
end

UICommonItemDetailWin.InitCommonItemDetail = function(self, itemCfg, useAction)
  -- function num : 0_1 , upvalues : _ENV
  if itemCfg == nil then
    error("Can\'t find itemCfg")
    return 
  end
  self.itemId = itemCfg.id
  self.useAction = useAction
  self.showList = {
[1] = {itemCfg = itemCfg, athData = nil}
}
  self.selectIndex = 1
  self:RefreshDetail()
  AudioManager:PlayAudioById(1072)
end

UICommonItemDetailWin.OnShow = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.Hide, nil, nil, nil, true)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemRefresh)
  ;
  (self.transform):SetAsLastSibling()
end

UICommonItemDetailWin.InitAthDetail = function(self, itemCfg, athData, useAction)
  -- function num : 0_3 , upvalues : _ENV
  if itemCfg == nil then
    error("Can\'t find itemCfg")
    return 
  end
  self.useAction = useAction
  self.showList = {
[1] = {itemCfg = itemCfg, athData = athData}
}
  self.selectIndex = 1
  self:RefreshDetail()
end

UICommonItemDetailWin.InitLimitTimeItemDetail = function(self, itemCfg, stackInfo, useAction)
  -- function num : 0_4 , upvalues : _ENV
  if itemCfg == nil then
    error("Can\'t find itemCfg")
    return 
  end
  do
    if stackInfo == nil then
      local limitCfg = (ConfigData.item_time_limit)[itemCfg.id]
      if limitCfg ~= nil and limitCfg.type == eLimitTimeItemType.Fixed then
        stackInfo = {}
        stackInfo.num = PlayerDataCenter:GetItemCount(itemCfg.id)
        stackInfo.time = limitCfg.time
      end
    end
    self.useAction = useAction
    self.showList = {
[1] = {itemCfg = itemCfg, stackInfo = stackInfo}
}
    self.isTimeOut = false
    self.selectIndex = 1
    self:RefreshDetail()
  end
end

UICommonItemDetailWin.InitListDetail = function(self, showList, index, notShowBuyFrag)
  -- function num : 0_5 , upvalues : _ENV
  if showList == nil or #showList == 0 then
    error("Can\'t find itemCfg")
    return 
  end
  self.useAction = nil
  self.showList = showList
  self.selectIndex = index
  if notShowBuyFrag ~= nil then
    self.notShowBuyFrag = notShowBuyFrag
  end
  self:RefreshDetail()
end

UICommonItemDetailWin.RefreshDetail = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.selectIndex = self.selectIndex or 1
  local selectData = (self.showList)[self.selectIndex]
  self.itemId = (selectData.itemCfg).id
  local itemCfg = selectData.itemCfg
  local athData = selectData.athData
  local stackInfo = selectData.stackInfo
  if itemCfg == nil then
    error("Can\'t find itemCfg")
    return 
  end
  self:RefreshSwitchState()
  self:__InitCIDData(itemCfg)
  self:__InitCIDUI(itemCfg, athData, stackInfo)
  if (((self.ui).btn_UseGift).gameObject).activeSelf then
    (((self.ui).btn_UseGift).gameObject):SetActive(false)
  end
  if athData ~= nil then
    ((self.ui).obj_normalDetail):SetActive(false)
    ;
    (self.athInfoNode):InitAthDetailItem(nil, athData, nil, false, false, false)
    ;
    (self.athInfoNode):Show()
    self:RefreshARGInfo(false)
    self:RefreshLimitTime(nil, self.itemId)
  else
    if stackInfo ~= nil then
      ((self.ui).obj_normalDetail):SetActive(true)
      ;
      (self.athInfoNode):Hide()
      self:UpdateJumpList(itemCfg)
      self:RefreshLimitTime(stackInfo.time, self.itemId)
      self:RefreshARGInfo(false)
    else
      ;
      ((self.ui).obj_normalDetail):SetActive(true)
      ;
      (self.athInfoNode):Hide()
      self.isARG = (PlayerDataCenter.allEffectorData):IsAutoGenerateResource(itemCfg.id)
      self:RefreshARGInfo(self.isARG)
      self:UpdateJumpList(itemCfg)
      self:RefreshLimitTime(nil, self.itemId)
    end
  end
  self:RefreshRaffleItemList()
end

UICommonItemDetailWin.__InitCIDData = function(self, itemCfg)
  -- function num : 0_7 , upvalues : _ENV
  self.isHeroItem = false
  if itemCfg.action_type == eItemActionType.HeroCardFrag then
    self.isHeroItem = true
  end
  self.isHaveThisHero = false
  if self.isHeroItem and (PlayerDataCenter.heroDic)[(itemCfg.arg)[1]] ~= nil then
    self.isHaveThisHero = true
  end
  self.showUseBtn = false
  if (itemCfg.can_use ~= false and itemCfg.can_use ~= nil) or self.useAction ~= nil then
    self.showUseBtn = true
  end
  self.canUse = itemCfg.can_use
end

UICommonItemDetailWin.__InitCIDUI = function(self, itemCfg, athData, stackInfo)
  -- function num : 0_8 , upvalues : _ENV
  (self.baseItem):InitBaseItem(itemCfg, nil)
  ;
  (self.baseItem):SetLimtTimeTagActive(false)
  if athData ~= nil then
    self:_ShowCount((PlayerDataCenter.allAthData):GetAthNumById(athData.id))
  else
    if stackInfo ~= nil then
      self:_ShowCount(stackInfo.num)
    else
      self:_ShowCountByItem(itemCfg)
    end
  end
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = tostring((LanguageUtil.GetLocaleText)(itemCfg.name))
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Descr).text = tostring((LanguageUtil.GetLocaleText)(itemCfg.describe))
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R4 in 'UnsetPending'

  if not self.isHeroItem then
    ((self.ui).img_ItemQuality).color = ItemQualityColor[(self.baseItem):GetQuality()]
  end
  ;
  ((self.ui).obj_HeroQuailty):SetActive(self.isHeroItem)
  ;
  (((self.ui).img_ItemQuality).gameObject):SetActive(not self.isHeroItem)
  ;
  (((self.ui).btn_Use).gameObject):SetActive(self.showUseBtn)
  if itemCfg.type_tag > 0 then
    ((self.ui).obj_ItemType):SetActive(true)
    -- DECOMPILER ERROR at PC93: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_ItemType).text = (LanguageUtil.GetLocaleText)(((ConfigData.item_type_tag)[itemCfg.type_tag]).name)
  else
    ;
    ((self.ui).obj_ItemType):SetActive(false)
  end
end

UICommonItemDetailWin.RefreshARGInfo = function(self, bool)
  -- function num : 0_9 , upvalues : _ENV
  ((self.ui).obj_aRGInfo_Speed):SetActive(bool)
  ;
  ((self.ui).obj_aRGInfo_Time2Limit):SetActive(bool)
  if bool then
    local Refresh = function()
    -- function num : 0_9_0 , upvalues : _ENV, self
    local num, nextTime = (PlayerDataCenter.allEffectorData):GetCurrentARGNum(self.itemId)
    local speed = (PlayerDataCenter.allEffectorData):GetCurrentARGSpeed(self.itemId)
    local ceiling = (PlayerDataCenter.allEffectorData):GetCurrentARGCeiling(self.itemId)
    self:_ShowCount(num)
    if nextTime > 0 then
      ((self.ui).tex_speed):SetIndex(1, GetPreciseDecimalStr(speed * 3600, 1), TimeUtil:TimestampToTime(nextTime))
    else
      ;
      ((self.ui).tex_speed):SetIndex(0, GetPreciseDecimalStr(speed * 3600, 1))
    end
    ;
    ((self.ui).text_time2Limittitle):SetIndex(0, tostring(num), tostring(ceiling))
    if num < ceiling then
      local timeStr = TimeUtil:TimestampToTime((ceiling - num - 1) / speed + nextTime)
      ;
      ((self.ui).tex_time2Limit):SetIndex(0, timeStr)
    else
      do
        ;
        ((self.ui).tex_time2Limit):SetIndex(1)
      end
    end
  end

    Refresh()
    TimerManager:StopTimer(self.ARGTimerId)
    self.ARGTimerId = TimerManager:StartTimer(1, Refresh)
  else
    do
      if self.ARGTimerId ~= nil then
        TimerManager:StopTimer(self.ARGTimerId)
        self.ARGTimerId = nil
      end
    end
  end
end

UICommonItemDetailWin.RefreshRaffleItemList = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local cfg = (ConfigData.item)[self.itemId]
  ;
  (self.raffleItemPool):HideAll()
  if cfg.type == eItemType.RaffleBox then
    ((self.ui).obj_rateList):SetActive(true)
    local raffleItemList = ((ConfigData.item).raffleBoxDic)[self.itemId]
    for _,raffleCfg in pairs(raffleItemList) do
      local item = (self.raffleItemPool):GetOne(true)
      item:InitRaffleDetailItem((ConfigData.item)[raffleCfg.rewardId], raffleCfg.rewardCount, raffleCfg.weight)
    end
  else
    do
      ;
      ((self.ui).obj_rateList):SetActive(false)
    end
  end
end

UICommonItemDetailWin.RefreshLimitTime = function(self, outTime, itemId, isBackPackItem)
  -- function num : 0_11 , upvalues : _ENV
  local cfg = (ConfigData.item_time_limit)[itemId]
  local limitType = eLimitTimeItemType.None
  if cfg ~= nil then
    limitType = cfg.type
  end
  if limitType ~= eLimitTimeItemType.None then
    if ((self.ui).obj_limitTime).activeSelf == false then
      ((self.ui).obj_limitTime):SetActive(true)
    end
    if outTime ~= nil then
      local Refresh = function()
    -- function num : 0_11_0 , upvalues : outTime, _ENV, self
    local diffTime = outTime - PlayerDataCenter.timestamp
    if diffTime > 0 then
      local d, h, m, s = TimeUtil:TimestampToTimeInter(diffTime, false, true)
      if d > 0 then
        ((self.ui).text_LimitTime):SetIndex(0, tostring(d), tostring(h))
      else
        if h > 0 then
          ((self.ui).text_LimitTime):SetIndex(1, tostring(h), tostring(m))
        else
          if m > 0 then
            ((self.ui).text_LimitTime):SetIndex(2, tostring(m))
          else
            ;
            ((self.ui).text_LimitTime):SetIndex(2, tostring(1))
          end
        end
      end
    else
      do
        ;
        ((self.ui).text_LimitTime):SetIndex(3)
        self.isTimeOut = true
        TimerManager:StopTimer(self.LimitTimeItemTimerId)
      end
    end
  end

      Refresh()
      TimerManager:StopTimer(self.LimitTimeItemTimerId)
      self.LimitTimeItemTimerId = TimerManager:StartTimer(1, Refresh, self)
    else
      do
        ;
        ((self.ui).text_LimitTime):SetIndex(4)
        if ((self.ui).obj_limitTime).activeSelf == true then
          ((self.ui).obj_limitTime):SetActive(false)
        end
      end
    end
  end
end

UICommonItemDetailWin.SetNotNeedAnyJump = function(self, bool)
  -- function num : 0_12
  self.notNeedAnyJump = bool
end

UICommonItemDetailWin.UpdateJumpList = function(self, itemCfg)
  -- function num : 0_13 , upvalues : _ENV, util
  if self.__UpdateJumpListCo ~= nil then
    (GR.StopCoroutine)(self.__UpdateJumpListCo)
    self.__UpdateJumpListCo = nil
  end
  self.__UpdateJumpListCo = (GR.StartCoroutine)((util.cs_generator)(self.__UpdateJumpList, self, itemCfg))
end

UICommonItemDetailWin.__UpdateJumpList = function(self, itemCfg)
  -- function num : 0_14 , upvalues : JumpManager, _ENV
  (self.poolInfoItem):HideAll()
  local isHaveAchieveDes = itemCfg.achieve_des ~= ""
  local isHaveNormalJumpList = (itemCfg.jumpList ~= nil and #itemCfg.jumpList ~= 0 and JumpManager.couldUseItemJump)
  if self.isHeroItem and self.isHaveThisHero and FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store) then
    local isCouldBuyFrag = not self.notShowBuyFrag
  end
  self.isCoulduseGift = false
  self.useGiftList = nil
  self.jumpuseGiftItem = nil
  if not BattleDungeonManager:InBattleDungeon() then
    local inDungeonOrEp = ExplorationManager:IsInExploration()
  end
  if self.notNeedAnyJump or inDungeonOrEp then
    if isHaveAchieveDes then
      ((self.ui).obj_jumpList):SetActive(false)
      ;
      (((self.ui).tex_achieveText).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC71: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).tex_achieveText).text = tostring((LanguageUtil.GetLocaleText)(itemCfg.achieve_des))
      return 
    else
      ((self.ui).obj_jumpList):SetActive(false)
      ;
      (((self.ui).tex_achieveText).gameObject):SetActive(false)
      return 
    end
  end
  local waitFactory = true
  self.factoryController = ControllerManager:GetController(ControllerTypeId.Factory, false)
  ;
  (self.factoryController):IsCouldOpenQuickProduceUI(self.itemId, function(isHaveQuickFactory, targetOrderData)
    -- function num : 0_14_0 , upvalues : waitFactory, self
    waitFactory = false
    if isHaveQuickFactory then
      local factoryItem = (self.poolInfoItem):GetOne()
      factoryItem:InitQuickProduce(targetOrderData, self.factoryController)
    end
  end
)
  while waitFactory do
    (coroutine.yield)(nil)
  end
  if isCouldBuyFrag then
    local frageId = itemCfg.id
    local shopCfg = ((ConfigData.shop_hero).fragId2ShopInfo)[frageId]
    if shopCfg then
      local item = (self.poolInfoItem):GetOne()
      item:InitQuickBuy(shopCfg.shopId, shopCfg.shelfId, shopCfg.resourceIds)
    end
  end
  if isHaveNormalJumpList then
    local jumpDic = {}
    for index,cfg in ipairs(itemCfg.jumpList) do
      if cfg.jump_id ~= (JumpManager.eJumpTarget).fragDungeon or self.isHaveThisHero then
        if jumpDic[cfg.jump_id] == nil then
          jumpDic[cfg.jump_id] = {}
        end
        ;
        (table.insert)(jumpDic[cfg.jump_id], cfg.jumpArgs)
      end
    end
    for jumpId,args in pairs(jumpDic) do
      local item = (self.poolInfoItem):GetOne()
      item:InitCIDJumpInfoItem(jumpId, args)
    end
  end
  local isHaveJumpList = #(self.poolInfoItem).listItem > 0
  if isHaveJumpList then
    ((self.ui).obj_jumpList):SetActive(true)
    ;
    (((self.ui).tex_achieveText).gameObject):SetActive(false)
  elseif isHaveAchieveDes then
    ((self.ui).obj_jumpList):SetActive(false)
    ;
    (((self.ui).tex_achieveText).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC208: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).tex_achieveText).text = tostring((LanguageUtil.GetLocaleText)(itemCfg.achieve_des))
  else
    ((self.ui).obj_jumpList):SetActive(false)
    ;
    (((self.ui).tex_achieveText).gameObject):SetActive(false)
  end
  -- DECOMPILER ERROR: 20 unprocessed JMP targets
end

UICommonItemDetailWin.OnBtnReturnClick = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UICommonItemDetailWin.TryShowGiftJump = function(self, flag)
  -- function num : 0_16 , upvalues : _ENV
  self.isCoulduseGift = flag
  -- DECOMPILER ERROR at PC9: Unhandled construct in 'MakeBoolean' P1

  if not flag and self.jumpuseGiftItem ~= nil then
    (self.poolInfoItem):HideOne(self.jumpuseGiftItem)
    self.jumpuseGiftItem = nil
  end
  do return  end
  if self.useGiftList == nil then
    local list = {}
    if not ((ConfigData.item).fixedPacketMappingDic)[self.itemId] then
      (table.insertto)(list, table.emptytable)
      if not ((ConfigData.item).selectPacketMappingDic)[self.itemId] then
        do
          (table.insertto)(list, table.emptytable)
          self.useGiftList = list
          local canShow = false
          for _,expPacketid in ipairs(self.useGiftList) do
            if PlayerDataCenter:GetItemCount(expPacketid) > 0 then
              canShow = true
              break
            end
          end
          do
            if canShow then
              if self.jumpuseGiftItem == nil then
                self.jumpuseGiftItem = (self.poolInfoItem):GetOne()
              end
              ;
              (self.jumpuseGiftItem):InitUseGift(self.itemId, self.useGiftList)
            else
              if self.jumpuseGiftItem ~= nil then
                (self.poolInfoItem):HideOne(self.jumpuseGiftItem)
              end
              self.jumpuseGiftItem = nil
            end
          end
        end
      end
    end
  end
end

UICommonItemDetailWin.OnBtnUseClick = function(self)
  -- function num : 0_17
  if self.useAction ~= nil then
    (self.useAction)()
    return 
  end
  if self.canUse then
  end
end

UICommonItemDetailWin.OnClickSwitchLeft = function(self)
  -- function num : 0_18
  if self.selectIndex > 1 then
    self.selectIndex = self.selectIndex - 1
    self:RefreshDetail()
  end
end

UICommonItemDetailWin.OnClickSwitchRight = function(self)
  -- function num : 0_19
  if self.selectIndex < #self.showList then
    self.selectIndex = self.selectIndex + 1
    self:RefreshDetail()
  end
end

UICommonItemDetailWin.RefreshSwitchState = function(self)
  -- function num : 0_20
  ;
  (((self.ui).btn_Left).gameObject):SetActive(self.selectIndex ~= nil and self.selectIndex > 1)
  ;
  (((self.ui).btn_Right).gameObject):SetActive(self.selectIndex ~= nil and self.selectIndex < #self.showList)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UICommonItemDetailWin.ParentWindowType = function(self, type)
  -- function num : 0_21
  self.parentWindowType = type
end

UICommonItemDetailWin.OnItemRefresh = function(self, itemUpdate)
  -- function num : 0_22 , upvalues : _ENV
  if itemUpdate[self.itemId] ~= nil then
    self:_ShowCountByItem((ConfigData.item)[self.itemId])
  end
  if self.useGiftList ~= nil then
    for _,itemId in ipairs(self.useGiftList) do
      if itemUpdate[itemId] ~= nil then
        self:_ShowUseGiftJump()
        break
      end
    end
  end
end

UICommonItemDetailWin._ShowUseGiftJump = function(self)
  -- function num : 0_23 , upvalues : _ENV
  if not self.isCoulduseGift then
    return 
  end
  local canShow = false
  for _,itemId in ipairs(self.useGiftList) do
    if PlayerDataCenter:GetItemCount(itemId) > 0 then
      canShow = true
      break
    end
  end
  do
    -- DECOMPILER ERROR at PC27: Unhandled construct in 'MakeBoolean' P1

    if canShow and self.jumpuseGiftItem == nil then
      self.jumpuseGiftItem = (self.poolInfoItem):GetOne()
      ;
      (self.jumpuseGiftItem):InitUseGift(self.itemId, self.useGiftList)
    end
    if self.jumpuseGiftItem ~= nil then
      (self.poolInfoItem):HideOne(self.jumpuseGiftItem)
    end
    self.jumpuseGiftItem = nil
  end
end

UICommonItemDetailWin._ShowCountByItem = function(self, itemCfg)
  -- function num : 0_24 , upvalues : _ENV
  if itemCfg == nil or itemCfg.type == eItemType.HeroCard then
    ((self.ui).obj_stock):SetActive(false)
    return 
  end
  local count = 0
  if itemCfg.id == ConstGlobalItem.SKey then
    count = (PlayerDataCenter.stamina):GetCurrentStamina()
  else
    count = PlayerDataCenter:GetItemCount(itemCfg.id)
  end
  self:_ShowCount(count)
end

UICommonItemDetailWin._ShowCount = function(self, count)
  -- function num : 0_25 , upvalues : _ENV
  if count <= 0 then
    ((self.ui).obj_stock):SetActive(false)
  else
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Count).text = tostring(count)
    ;
    ((self.ui).obj_stock):SetActive(true)
  end
end

UICommonItemDetailWin.OnClickUse = function(self)
  -- function num : 0_26 , upvalues : _ENV
  (UIUtil.OnClickBack)()
  local itemCfg = (ConfigData.item)[self.itemId]
  if self.isTimeOut then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6041))
    return 
  end
  if ConfigData:IsManualOpenGiftItem(itemCfg) then
    self:UseGift(itemCfg)
  else
    if itemCfg.id == (ConfigData.game_config).changeNameItemId or itemCfg.id == (ConfigData.game_config).limitTimeChangeNameItemId then
      self:UseChangeNameCard(itemCfg)
    end
  end
end

UICommonItemDetailWin.UseChangeNameCard = function(self, itemCfg)
  -- function num : 0_27 , upvalues : _ENV
  if CloseCustomBename then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(393))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.UserInfoDialog, function(window)
    -- function num : 0_27_0
    if window ~= nil then
      window:OpenChangeNameDialogFromStore()
    end
  end
)
end

UICommonItemDetailWin.UseGift = function(self, itemCfg)
  -- function num : 0_28 , upvalues : _ENV, cs_MessageCommon, CommonRewardData
  local count = PlayerDataCenter:GetItemCount(itemCfg.id)
  if (itemCfg.action_type == proto_csmsg_ItemActionType.ItemActionTypeFixedItem or itemCfg.action_type == proto_csmsg_ItemActionType.ItemActionTypeRandomReward) and count == 1 then
    local athMaxCoulHaveNum = ((ConfigData.item).athGiftDic)[itemCfg.id]
    do
      if athMaxCoulHaveNum ~= nil and athMaxCoulHaveNum > 0 and (ConfigData.game_config).athMaxNum < #(PlayerDataCenter.allAthData):GetAllAthList() + athMaxCoulHaveNum then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.WearhouseOpenAthPackageFull))
        return 
      end
      local heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
      local warehouseNetwork = NetworkManager:GetNetwork(NetworkTypeID.Warehouse)
      warehouseNetwork:CS_BACKPACK_UseItem(itemCfg.id, count, function(dataList)
    -- function num : 0_28_0 , upvalues : _ENV, CommonRewardData, heroIdSnapShoot
    if dataList.Count <= 0 then
      return 
    end
    local rewardDic = dataList[0]
    local rewardIds = {}
    local rewardCounts = {}
    for id,num in pairs(rewardDic) do
      (table.insert)(rewardIds, id)
      ;
      (table.insert)(rewardCounts, num)
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_28_0_0 , upvalues : CommonRewardData, rewardIds, rewardCounts, heroIdSnapShoot
      if window == nil then
        return 
      end
      local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardCounts)):SetCRHeroSnapshoot(heroIdSnapShoot)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
    end
  else
    do
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonUseGift, function(win)
    -- function num : 0_28_1 , upvalues : itemCfg
    if win == nil then
      return 
    end
    win:InitCommonUseGift(itemCfg)
  end
)
    end
  end
end

UICommonItemDetailWin.ShowUseGiftBtn = function(self, itemCfg)
  -- function num : 0_29 , upvalues : _ENV
  if itemCfg == nil then
    return 
  end
  do
    if ConfigData:IsManualOpenItem(itemCfg) then
      local itemData = (PlayerDataCenter.itemDic)[itemCfg.id]
      ;
      (((self.ui).btn_UseGift).gameObject):SetActive(itemData ~= nil and itemData:GetCount() > 0)
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UICommonItemDetailWin.OnHide = function(self)
  -- function num : 0_30 , upvalues : _ENV
  (self.poolInfoItem):DeleteAll()
  self.notNeedAnyJump = false
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemRefresh)
  TimerManager:StopTimer(self.ARGTimerId)
  TimerManager:StopTimer(self.LimitTimeItemTimerId)
end

UICommonItemDetailWin.OnDelete = function(self)
  -- function num : 0_31 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.__UpdateJumpListCo ~= nil then
    (GR.StopCoroutine)(self.__UpdateJumpListCo)
    self.__UpdateJumpListCo = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICommonItemDetailWin

