-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpRewardBag = class("UIEpRewardBag", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItemWithCount = require("Game.CommonUI.Item.UICommonRewardItem")
local EpRewardBagUtil = require("Game.Exploration.UI.EpRewardBag.EpRewardBagUtil")
local UINEpRewardBagItem = require("Game.Exploration.UI.EpRewardBag.UINEpRewardBagItem")
local UINResourceGroup = require("Game.CommonUI.ResourceGroup.UINResourceGroup")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
UIEpRewardBag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINResourceGroup, UINBaseItemWithCount, UINEpRewardBagItem
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self._OnClickGetReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelectAll, self, self._OnClickSelectAll)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self._OnClickCancelSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickGiveup)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_TipsInfo, self, self._OnClickInfo)
  self.resourceGroup = (UINResourceGroup.New)()
  ;
  (self.resourceGroup):Init((self.ui).gameResourceGroup)
  ;
  ((self.ui).obj_rewardItem):SetActive(false)
  self.firstClearRewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).obj_rewardItem)
  ;
  ((self.ui).rewardBagItem):SetActive(false)
  self.rewardItemPool = (UIItemPool.New)(UINEpRewardBagItem, (self.ui).rewardBagItem)
  self._selectRewardFunc = BindCallback(self, self._OnSelectReward)
end

UIEpRewardBag.InitEpRewardBag = function(self, rewardList, stageCfg, inEp, firstClearRewardDic, canGetReward, epModuleId, stageId)
  -- function num : 0_1 , upvalues : EpRewardBagUtil, _ENV, cs_MessageCommon
  self.inEp = inEp
  self.epModuleId = epModuleId
  self.stageCfg = stageCfg
  self._stageId = stageId
  local currencyId = EpRewardBagUtil:GetEpRewardCurrencyId(epModuleId, stageId)
  self._currencyId = currencyId
  ;
  (self.resourceGroup):SetResourceIds({currencyId})
  local moneyIcon = nil
  local isKey = ConstGlobalItem.SKey == currencyId
  if not isKey then
    ((self.ui).img_Key):SetActive(false)
    ;
    (((self.ui).img_CurrencyIcon).gameObject):SetActive(true)
    local itemCfg = (ConfigData.item)[currencyId]
    if itemCfg ~= nil then
      moneyIcon = CRH:GetSprite(itemCfg.small_icon)
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).img_CurrencyIcon).sprite = moneyIcon
    end
  end
  local containAth = false
  local curSectorId = stageCfg ~= nil and stageCfg.sector or nil
  local msg = nil
  if stageCfg ~= nil and stageCfg.endlessCfg ~= nil then
    msg = ConfigData:GetEndlessInfoMsg(stageCfg.endlessCfg, (stageCfg.endlessCfg).index * 10)
  elseif epModuleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess or epModuleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason then
    msg = ""
    ;
    (((self.ui).btn_TipsInfo).gameObject):SetActive(false)
  else
    msg = ConfigData:GetSectorInfoMsg(stageCfg.sector, stageCfg.num, stageCfg.difficulty)
  end
  -- DECOMPILER ERROR at PC96: Confused about usage of register: R14 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelName).text = msg
  local unlockSelect = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_RewardPurchase)
  local selectable = not unlockSelect or canGetReward
  self.selectable = selectable
  ;
  (((self.ui).btn_Get).gameObject):SetActive(canGetReward)
  ;
  (((self.ui).btn_SelectAll).gameObject):SetActive(selectable)
  ;
  (((self.ui).btn_Cancel).gameObject):SetActive(selectable)
  ;
  (((self.ui).btn_Back).gameObject):SetActive(not canGetReward)
  local selectDefault = true
  if (ConfigData.sector)[curSectorId] ~= nil then
    local sectorCfg = (ConfigData.sector)[curSectorId]
    if not sectorCfg.is_special then
      local lastSectorId = (PlayerDataCenter.sectorStage):GetEpStageCfg4UserInfo()
      if lastSectorId ~= nil and curSectorId < lastSectorId then
        selectDefault = false
      end
    end
  end
  ;
  (self.rewardItemPool):HideAll()
  local rewardDataList = {}
  do
    for k,v in ipairs(rewardList) do
      local itemCfg = (ConfigData.item)[v.itemId]
      if itemCfg == nil then
        error("Cant get item cfg, id = " .. tostring(v.itemId))
      else
        if not containAth and itemCfg.type == eItemType.Arithmetic then
          containAth = true
        end
        local rewardData = {itemId = v.itemId, itemNum = v.num, itemCfg = itemCfg, price = (EpRewardBagUtil.GetEpRewardItemPrice)(v.itemId, self.epModuleId, stageId, v.num), originalPrice = (EpRewardBagUtil.GetEpRewardItemPrice)(v.itemId, self.epModuleId, stageId, v.num, true), index = k - 1, SetRewardDataSelected = function(self, selected)
    -- function num : 0_1_0
    if self.price == 0 then
      self.selected = true
      return 
    end
    self.selected = selected
  end
}
        rewardData:SetRewardDataSelected(selectDefault)
        ;
        (table.insert)(rewardDataList, rewardData)
      end
    end
  end
  ExplorationManager:RewardSort(rewardDataList)
  self.rewardDataList = rewardDataList
  for k,rewardData in ipairs(rewardDataList) do
    local rewardItem = (self.rewardItemPool):GetOne()
    rewardItem:InitEpRewardBagItem(k, rewardData.itemCfg, rewardData.itemNum, rewardData.price, rewardData.originalPrice, self._selectRewardFunc, selectable)
    rewardItem:SetEpRewardBagItemSelected(rewardData.selected)
    if moneyIcon ~= nil then
      rewardItem:SetEpRewardBagItemCurrencyIcon(moneyIcon)
    end
  end
  local firstClearRewardList = nil
  if firstClearRewardDic == nil then
    firstClearRewardList = 
  else
    firstClearRewardList = ({})(self, firstClearRewardDic)
  end
  self.firstClearRewardList = firstClearRewardList
  if #firstClearRewardList == 0 then
    ((self.ui).firstRewardList):SetActive(false)
  else
    ((self.ui).firstRewardList):SetActive(true)
    ;
    (self.firstClearRewardItemPool):HideAll()
    for k,v in ipairs(firstClearRewardList) do
      if not containAth and (v.itemCfg).type == eItemType.Arithmetic then
        containAth = true
      end
      local rewardItem = (self.firstClearRewardItemPool):GetOne()
      local num = 0
      if (v.itemCfg).overflow_type == eItemTransType.actMoneyX then
        num = PlayerDataCenter:GetItemOverflowNum((v.itemCfg).id, v.num)
      end
      if num ~= 0 then
        rewardItem:SetItemTranNum(num)
      end
      rewardItem:InitCommonRewardItem(v.itemCfg, v.num, nil, function()
    -- function num : 0_1_1 , upvalues : _ENV, self, k
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_1_1_0 , upvalues : self, k
      if win ~= nil then
        win:InitListDetail(self.firstClearRewardList, k)
      end
    end
)
  end
)
      rewardItem:SetItemNameShow(false)
    end
  end
  if canGetReward and containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
  end
  self:_RefreshTotalPrice()
  local showClose = false
  if unlockSelect then
    showClose = true
  elseif not unlockSelect and (PlayerDataCenter.stamina):GetCurrentStamina() < self.totalPrice then
    showClose = true
  end
  ;
  (((self.ui).btn_Close).gameObject):SetActive(not showClose or canGetReward)
  GuideManager:TryTriggerGuide(eGuideCondition.InEpRewardBagSettle)
  if not self.inEp then
    (UIUtil.SetTopStatus)(nil, nil, nil, nil, nil, true)
  end
  if not self.SettedTopStatus then
    (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
    self.SettedTopStatus = true
  end
  -- DECOMPILER ERROR: 28 unprocessed JMP targets
end

UIEpRewardBag._InitRewardData = function(self, rewardDic)
  -- function num : 0_2 , upvalues : _ENV
  local rewardList = {}
  for itemId,itemNum in pairs(rewardDic) do
    local itemCfg = (ConfigData.item)[itemId]
    if itemCfg == nil then
      error("can\'t get itemCfg with id=" .. tostring(itemId))
    else
      ;
      (table.insert)(rewardList, {num = itemNum, itemCfg = itemCfg})
    end
  end
  ExplorationManager:RewardSort(rewardList)
  return rewardList
end

UIEpRewardBag._RefreshTotalPrice = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local selectAll = false
  local selectedNum = 0
  local totalPrice = 0
  local tPriceOriginal = 0
  for k,rewardData in ipairs(self.rewardDataList) do
    if rewardData.selected then
      totalPrice = totalPrice + rewardData.price
      tPriceOriginal = tPriceOriginal + rewardData.originalPrice
      selectedNum = selectedNum + 1
    end
  end
  local selectedAll = selectedNum == #self.rewardDataList
  self.selectedAll = selectedAll
  if selectedAll then
    totalPrice = (totalPrice) * (ConfigData.game_config).staminaShopAllDiscount / 100
  end
  totalPrice = self:_GetTotalPrice(totalPrice)
  tPriceOriginal = self:_GetTotalPrice(tPriceOriginal)
  self.totalPrice = totalPrice
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Consume).text = tostring(totalPrice)
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_OrignConsume).text = tostring(tPriceOriginal)
  ;
  (((self.ui).tex_OrignConsume).gameObject):SetActive(totalPrice ~= tPriceOriginal)
  local canGet = selectedNum > 0 or #self.firstClearRewardList > 0
  self.canClickGetReward = canGet
  -- DECOMPILER ERROR at PC81: Confused about usage of register: R7 in 'UnsetPending'

  if not canGet or not (self.ui).color_get then
    ((self.ui).img_Get).color = Color.gray
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

UIEpRewardBag._OnSelectReward = function(self, rewardItem, index)
  -- function num : 0_4
  local rewardData = (self.rewardDataList)[index]
  rewardData:SetRewardDataSelected(not rewardData.selected)
  rewardItem:SetEpRewardBagItemSelected(rewardData.selected)
  self:_RefreshTotalPrice()
end

UIEpRewardBag._OnClickGetReward = function(self)
  -- function num : 0_5 , upvalues : cs_MessageCommon, _ENV, JumpManager
  if not self.canClickGetReward then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(757))
    return 
  end
  local isKey = ConstGlobalItem.SKey == self._currencyId
  -- DECOMPILER ERROR at PC39: Unhandled construct in 'MakeBoolean' P1

  if isKey and (PlayerDataCenter.stamina):GetCurrentStamina() < self.totalPrice then
    JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina, nil, nil, {self.totalPrice - (PlayerDataCenter.stamina):GetCurrentStamina()})
    return 
  end
  if PlayerDataCenter:GetItemCount(self._currencyId) < self.totalPrice then
    local itemCfg = (ConfigData.item)[self._currencyId]
    local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)((string.format)(ConfigData:GetTipContent(7120), itemName, itemName))
    return 
  end
  self.pickInfo = {}
  self.rewardDic = (table.GetDefaulValueTable)(0)
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R2 in 'UnsetPending'

  if self.selectedAll then
    (self.pickInfo).pickState = proto_csmsg_stmStorePickInfoPickState.stmStorePickInfoPickStatePickAll
    for k,rewardData in ipairs(self.rewardDataList) do
      -- DECOMPILER ERROR at PC94: Confused about usage of register: R7 in 'UnsetPending'

      (self.rewardDic)[rewardData.itemId] = (self.rewardDic)[rewardData.itemId] + rewardData.itemNum
    end
  else
    -- DECOMPILER ERROR at PC101: Confused about usage of register: R2 in 'UnsetPending'

    (self.pickInfo).pickState = proto_csmsg_stmStorePickInfoPickState.stmStorePickInfoPickStatePickPartial
    local choiceDic = {}
    for k,rewardData in ipairs(self.rewardDataList) do
      if rewardData.selected then
        choiceDic[rewardData.index] = true
        -- DECOMPILER ERROR at PC119: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.rewardDic)[rewardData.itemId] = (self.rewardDic)[rewardData.itemId] + rewardData.itemNum
      end
    end
    -- DECOMPILER ERROR at PC123: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.pickInfo).choices = choiceDic
  end
  self:_OnClickClose()
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UIEpRewardBag._OnClickSelectAll = function(self)
  -- function num : 0_6 , upvalues : _ENV, cs_MessageCommon
  for k,rewardData in ipairs(self.rewardDataList) do
    rewardData:SetRewardDataSelected(true)
    local rewardItem = ((self.rewardItemPool).listItem)[k]
    rewardItem:SetEpRewardBagItemSelected(rewardData.selected)
  end
  self:_RefreshTotalPrice()
  ;
  (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(754))
end

UIEpRewardBag._OnClickCancelSelect = function(self)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  for k,rewardData in ipairs(self.rewardDataList) do
    rewardData:SetRewardDataSelected(false)
    local rewardItem = ((self.rewardItemPool).listItem)[k]
    rewardItem:SetEpRewardBagItemSelected(rewardData.selected)
  end
  self:_RefreshTotalPrice()
  ;
  (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(755))
end

UIEpRewardBag._OnClickInfo = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_8_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    local infoStr, titleStr = nil, nil
    if (ExplorationManager.IsCarnivalEp)(self._stageId) then
      titleStr = ConfigData:GetTipContent(7118)
      infoStr = ConfigData:GetTipContent(7119)
    else
      local discount = FormatNum((ConfigData.game_config).staminaShopAllDiscount / 10)
      infoStr = (string.format)(ConfigData:GetTipContent(761), discount)
      titleStr = ConfigData:GetTipContent(760)
    end
    do
      window:InitCommonInfo(infoStr, titleStr)
    end
  end
)
end

UIEpRewardBag.BackAction = function(self)
  -- function num : 0_9 , upvalues : _ENV
  self.SettedTopStatus = false
  local exitFunc = function()
    -- function num : 0_9_0 , upvalues : self, _ENV
    self.pickInfo = {}
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.pickInfo).pickState = proto_csmsg_stmStorePickInfoPickState.stmStorePickInfoPickStateAbandon
    self.rewardDic = (table.GetDefaulValueTable)(0)
    self:_OnClickClose()
  end

  local enableConfirm = (PlayerDataCenter.cacheSaveData):GetEnableEpRewardBagExitConfirm()
  if enableConfirm then
    local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    local itemCfg = (ConfigData.item)[self._currencyId]
    local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
    window:ShowTextBoxWithYesAndNo((string.format)(ConfigData:GetTipContent(756), itemName, itemName), exitFunc, function()
    -- function num : 0_9_1 , upvalues : self, _ENV
    if not self.SettedTopStatus then
      (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
      self.SettedTopStatus = true
    end
  end
)
    window:ShowDontRemindTog(function(isOn)
    -- function num : 0_9_2 , upvalues : _ENV
    (PlayerDataCenter.cacheSaveData):SetEnableEpRewardBagExitConfirm(not isOn)
  end
)
  else
    do
      exitFunc()
    end
  end
end

UIEpRewardBag._OnClickClose = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.SettedTopStatus then
    (UIUtil.PopFromBackStack)()
    self.SettedTopStatus = false
  end
  if self.closeFunc ~= nil then
    (self.closeFunc)(self.rewardDic, self.pickInfo)
    self.closeFunc = nil
    return 
  end
  if self.inEp then
    self:Hide()
  else
    ;
    (UIUtil.PopFromBackStack)()
    self:Delete()
  end
end

UIEpRewardBag._OnClickGiveup = function(self)
  -- function num : 0_11 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIEpRewardBag.SetEpRewardBagCloseFunc = function(self, closeFunc)
  -- function num : 0_12
  self.closeFunc = closeFunc
end

UIEpRewardBag._IsCanShowAth = function(self)
  -- function num : 0_13 , upvalues : _ENV
  return FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Algorithm)
end

UIEpRewardBag._GetTotalPrice = function(self, price)
  -- function num : 0_14 , upvalues : _ENV
  local value = (math.ceil)(price / (ConfigData.game_config).staminaDividend)
  return value
end

UIEpRewardBag.__GetSinglePriceStr = function(self, price)
  -- function num : 0_15 , upvalues : _ENV
  local dividend = (ConfigData.game_config).staminaDividend / 10
  local value = (math.ceil)(price / dividend)
  value = FormatNum(value / 10)
  return tostring(value)
end

UIEpRewardBag._SetModifier = function(self, inEp)
  -- function num : 0_16 , upvalues : _ENV
  local num = inEp and 5 or 0
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).modifier).rotation = (Vector3.New)(num, 0, 0)
  ;
  ((self.ui).modifier):RefreshGraphics()
end

UIEpRewardBag.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (self.firstClearRewardItemPool):DeleteAll()
  ;
  (self.rewardItemPool):DeleteAll()
  ;
  (self.resourceGroup):Delete()
  ;
  (base.OnDelete)(self)
end

return UIEpRewardBag

