-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonUseGift = class("UICommonUseGift", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
local UINCmUseGiftItem = require("Game.CommonUI.UseGift.UINCmUseGiftItem")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local cs_Canvas = (CS.UnityEngine).Canvas
local cs_MessageCommon = CS.MessageCommon
UICommonUseGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCmUseGiftItem, UINBaseItem
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonNo, self, self.OnClickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonYes, self, self.OnClickUse)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self.OnClickAdd)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reduce, self, self.OnClickReduce)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).scrollbar, self, self.OnScrollbarValueChange)
  self.itemSelectPool = (UIItemPool.New)(UINCmUseGiftItem, (self.ui).obj_choseItem)
  ;
  ((self.ui).obj_choseItem):SetActive(false)
  self.itemFixed = (UINBaseItem.New)()
  ;
  (self.itemFixed):Init((self.ui).obj_itemGiftSub)
  self.__OnSelectItemCallback = BindCallback(self, self.OnSelectItemCallback)
  self.__OnUseGiftSuccess = BindCallback(self, self.__UseGiftSuccess)
  self.__OnItemUpdate = BindCallback(self, self.OnItemUpdateUseGift)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemUpdate)
end

UICommonUseGift.InitCommonUseGift = function(self, itemCfg, defalutSelectItemId, closeFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.itemCfg = itemCfg
  self.closeFunc = closeFunc
  if not ConfigData:IsManualOpenGiftItem(self.itemCfg) then
    error("道具不是礼包却打开了礼包使用界面")
    return 
  end
  local itemData = (PlayerDataCenter.itemDic)[(self.itemCfg).id]
  local itemMaxCount = 0
  if itemData ~= nil then
    itemMaxCount = itemData:GetCount()
  end
  self:_UpdItemMaxCount(itemMaxCount)
  self:_UpdItemCountUse(self.itemCountMax == 0 and 0 or 1)
  self.selectItem = nil
  self:RefreshUseGiftView(defalutSelectItemId)
end

UICommonUseGift.RefreshUseGiftView = function(self, defalutSelectItemId)
  -- function num : 0_2 , upvalues : _ENV
  if (self.itemCfg).action_type == proto_csmsg_ItemActionType.ItemActionTypeRadioChoiceGift then
    self:__RefreshUseGiftViewWithSelect(defalutSelectItemId)
  else
    self:__RefreshUseGiftViewWithNormal()
  end
  self:__UseCountChangeUpdate(self.itemCountUse, true)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  if (self.itemCfg).auto_max then
    ((self.ui).scrollbar).value = self.itemCountMax
  else
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).scrollbar).value = self.itemCountUse
  end
end

UICommonUseGift.__RefreshUseGiftViewWithSelect = function(self, defalutSelectItemId)
  -- function num : 0_3 , upvalues : _ENV, cs_Canvas
  ((self.ui).obj_itemList):SetActive(true)
  ;
  ((self.ui).obj_itemGift):SetActive(false)
  ;
  ((self.ui).obj_ItemInfo):SetActive(false)
  local itemList = {}
  for k,v in pairs((self.itemCfg).giftOptainDic) do
    (table.insert)(itemList, k)
  end
  ;
  (table.sort)(itemList, function(a, b)
    -- function num : 0_3_0
    do return a < b end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (self.itemSelectPool):HideAll()
  local selectIndex = 0
  for index,id in ipairs(itemList) do
    local item = (self.itemSelectPool):GetOne()
    local itemCfg = (ConfigData.item)[id]
    item:InitCmUseGiftItem(itemCfg, ((self.itemCfg).giftOptainDic)[id] * self.itemCountUse, self.__OnSelectItemCallback)
    if id == defalutSelectItemId then
      selectIndex = index
    end
  end
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  if selectIndex == 0 then
    ((self.ui).obj_Select):SetActive(false)
  else
    self:__SelectItemStateUpdate(((self.itemSelectPool).listItem)[selectIndex])
  end
end

UICommonUseGift.__RefreshUseGiftViewWithNormal = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_itemList):SetActive(false)
  ;
  ((self.ui).obj_itemGift):SetActive(true)
  local itemCfg = self.itemCfg
  ;
  (self.itemFixed):InitBaseItem(itemCfg, self.__OnSelectItemCallback)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_GiftName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
end

UICommonUseGift.OnClickUse = function(self)
  -- function num : 0_5 , upvalues : _ENV, cs_MessageCommon
  if self.itemCountUse < 0 then
    return 
  end
  do
    if (self.itemCfg).action_type ~= proto_csmsg_ItemActionType.ItemActionTypeRadioChoiceGift then
      local athMaxCoulHaveNum = ((ConfigData.item).athGiftDic)[(self.itemCfg).id]
      if athMaxCoulHaveNum ~= nil and athMaxCoulHaveNum > 0 and (ConfigData.game_config).athMaxNum < #(PlayerDataCenter.allAthData):GetAllAthList() + athMaxCoulHaveNum * self.itemCountUse then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.WearhouseOpenAthPackageFull))
        return 
      end
    end
    local warehouseNetwork = NetworkManager:GetNetwork(NetworkTypeID.Warehouse)
    self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
    if (self.itemCfg).action_type == proto_csmsg_ItemActionType.ItemActionTypeRadioChoiceGift then
      if self.selectItem == nil then
        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(146))
        return 
      end
      if ((self.selectItem).itemCfg).type == eItemType.Arithmetic and (ConfigData.game_config).athMaxNum < #(PlayerDataCenter.allAthData):GetAllAthList() + (self.selectItem).count * self.itemCountUse then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.WearhouseOpenAthPackageFull))
        return 
      end
      local selectId = ((self.selectItem).itemCfg).id
      warehouseNetwork:CS_BACKPACK_SelectItem((self.itemCfg).id, self.itemCountUse, {selectId}, self.__OnUseGiftSuccess)
    else
      do
        warehouseNetwork:CS_BACKPACK_UseItem((self.itemCfg).id, self.itemCountUse, self.__OnUseGiftSuccess)
        ;
        (UIUtil.OnClickBack)()
      end
    end
  end
end

UICommonUseGift.BackAction = function(self)
  -- function num : 0_6
  if self.closeFunc ~= nil then
    (self.closeFunc)(false)
  end
  self:Delete()
end

UICommonUseGift.OnClickCancle = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UICommonUseGift.OnClickAdd = function(self)
  -- function num : 0_8
  if self.itemCountUse < self.itemCountMax then
    self:__UseCountChangeUpdate(self.itemCountUse + 1, true)
  end
end

UICommonUseGift.OnClickReduce = function(self)
  -- function num : 0_9
  if self.itemCountUse > 1 then
    self:__UseCountChangeUpdate(self.itemCountUse - 1, true)
  end
end

UICommonUseGift.OnScrollbarValueChange = function(self, value)
  -- function num : 0_10 , upvalues : _ENV
  if self.scrollbarValueCallbackEnable then
    local num = (math.tointeger)(((self.ui).scrollbar).value)
    if num ~= self.itemCountUse then
      self:__UseCountChangeUpdate(num, false)
    end
  end
end

UICommonUseGift.OnSelectItemCallback = function(self, itemCfg)
  -- function num : 0_11 , upvalues : _ENV
  if (self.itemCfg).action_type == proto_csmsg_ItemActionType.ItemActionTypeRadioChoiceGift then
    for i,v in ipairs((self.itemSelectPool).listItem) do
      if v.itemCfg == itemCfg then
        self:__SelectItemStateUpdate(v)
        break
      end
    end
  end
end

UICommonUseGift.__UseCountChangeUpdate = function(self, num, updateScrollbar)
  -- function num : 0_12 , upvalues : _ENV
  self:_UpdItemCountUse(num)
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scrollbar).minValue = 1
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scrollbar).maxValue = self.itemCountMax
  if updateScrollbar then
    self.scrollbarValueCallbackEnable = false
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).scrollbar).value = self.itemCountUse
    self.scrollbarValueCallbackEnable = true
  end
  local itemCfg = self.itemCfg
  if itemCfg.action_type == proto_csmsg_ItemActionType.ItemActionTypeFixedItem then
    local des = nil
    for id,count in pairs(itemCfg.giftOptainDic) do
      local itemCfg = (ConfigData.item)[id]
      local tempDes = tostring(count * self.itemCountUse) .. (LanguageUtil.GetLocaleText)(itemCfg.name)
      if des == nil then
        des = tempDes
      else
        des = des .. "," .. tempDes
      end
    end
    ;
    ((self.ui).tex_GiftInfo):SetIndex(0, des)
  else
    do
      local num = self.itemCountUse
      ;
      ((self.ui).tex_GiftInfo):SetIndex(1, (LanguageUtil.GetLocaleText)(itemCfg.describe))
    end
  end
end

UICommonUseGift.__SelectItemStateUpdate = function(self, selectItem)
  -- function num : 0_13 , upvalues : _ENV
  self.selectItem = selectItem
  ;
  (((self.ui).obj_Select).transform):SetParent((self.selectItem).transform)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).obj_Select).transform).localPosition = Vector3.zero
  ;
  ((self.ui).obj_Select):SetActive(true)
end

UICommonUseGift.__UseGiftSuccess = function(self, dataList)
  -- function num : 0_14 , upvalues : _ENV, CommonRewardData
  if dataList.Count <= 0 then
    return 
  end
  local rewardCache = dataList[0]
  local rewardIds = {}
  local rewardCounts = {}
  local heroIdSnapShoot = self._heroIdSnapShoot
  for id,count in pairs(rewardCache) do
    (table.insert)(rewardIds, id)
    ;
    (table.insert)(rewardCounts, count)
  end
  local window = UIManager:GetWindow(UIWindowTypeID.CommonReward)
  if window ~= nil then
    local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardCounts)):SetCRHeroSnapshoot(heroIdSnapShoot)
    window:AddAndTryShowReward(CRData)
  else
    do
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_14_0 , upvalues : CommonRewardData, rewardIds, rewardCounts, heroIdSnapShoot
    if window == nil then
      return 
    end
    local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardCounts)):SetCRHeroSnapshoot(heroIdSnapShoot)
    window:AddAndTryShowReward(CRData)
  end
)
      if self.closeFunc ~= nil then
        (self.closeFunc)(true)
      end
      self:Delete()
    end
  end
end

UICommonUseGift.OnItemUpdateUseGift = function(self, itemUpdate, resourceData)
  -- function num : 0_15 , upvalues : _ENV
  if self.itemCfg == nil then
    return 
  end
  local itemData = (PlayerDataCenter.itemDic)[(self.itemCfg).id]
  if itemData ~= nil or not 0 then
    local currrentMaxCount = itemData:GetCount()
  end
  if currrentMaxCount ~= self.itemCountMax then
    self:_UpdItemMaxCount(currrentMaxCount)
    if self.itemCountMax < self.itemCountUse then
      self:_UpdItemCountUse(self.itemCountMax)
    end
    self:__UseCountChangeUpdate(self.itemCountUse, true)
  end
end

UICommonUseGift._UpdItemCountUse = function(self, itemCountUse)
  -- function num : 0_16 , upvalues : _ENV
  self.itemCountUse = itemCountUse
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_CurCount).text = tostring(itemCountUse)
  if (self.itemCfg).action_type == proto_csmsg_ItemActionType.ItemActionTypeRadioChoiceGift then
    for k,item in ipairs((self.itemSelectPool).listItem) do
      local itemCfg = item.itemCfg
      local num = ((self.itemCfg).giftOptainDic)[itemCfg.id] * self.itemCountUse
      ;
      (item.baseItem):SetNum(num)
    end
  end
end

UICommonUseGift._UpdItemMaxCount = function(self, itemCountMax)
  -- function num : 0_17 , upvalues : _ENV
  self.itemCountMax = itemCountMax
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_count).text = tostring(itemCountMax)
  ;
  ((self.ui).obj_sliderNode):SetActive(itemCountMax > 1)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UICommonUseGift.OnDelete = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  (self.itemFixed):Delete()
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemUpdate)
  ;
  (base.OnDelete)(self)
end

return UICommonUseGift

