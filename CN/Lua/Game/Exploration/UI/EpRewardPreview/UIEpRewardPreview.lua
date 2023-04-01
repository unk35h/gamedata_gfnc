-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpRewardPreview = class("UIEpRewardPreview", UIBaseWindow)
local base = UIBaseWindow
local UINEpRewardPreviewItem = require("Game.Exploration.UI.EpRewardPreview.UINEpRewardPreviewItem")
local UINResourceGroup = require("Game.CommonUI.ResourceGroup.UINResourceGroup")
local EpRewardBagUtil = require("Game.Exploration.UI.EpRewardBag.EpRewardBagUtil")
UIEpRewardPreview.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINResourceGroup, _ENV, UINEpRewardPreviewItem
  self.resourceGroup = (UINResourceGroup.New)()
  ;
  (self.resourceGroup):Init((self.ui).gameResourceGroup)
  ;
  ((self.ui).obj_PreviewItem):SetActive(false)
  self.previewItemPool = (UIItemPool.New)(UINEpRewardPreviewItem, (self.ui).obj_PreviewItem)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnCloseClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self._OnCloseClick)
  ;
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
end

UIEpRewardPreview.InitEpRewardPreview = function(self, itemList, epModuleId, stageId)
  -- function num : 0_1
  local totalPrice, previewDataList = self:_InitData(itemList, epModuleId, stageId)
  self:_RefreshUI(totalPrice, previewDataList)
end

UIEpRewardPreview._InitData = function(self, itemList, epModuleId, stageId)
  -- function num : 0_2 , upvalues : _ENV, EpRewardBagUtil
  local totalPrice = 0
  local currencyId = nil
  local previewDataList = {}
  for __,StmGoodElem in ipairs(itemList) do
    local itemId = StmGoodElem.itemId
    local itemNum = StmGoodElem.num
    local itemCfg = (ConfigData.item)[StmGoodElem.itemId]
    if itemCfg == nil then
      error("Cant get item cfg, id = " .. tostring(itemId))
    else
      local price, thisCurrencyId = (EpRewardBagUtil.GetEpRewardItemPrice)(itemId, epModuleId, stageId, itemNum)
      local previewData = {itemId = itemId, itemCfg = itemCfg, itemNum = itemNum, priceStr = EpRewardBagUtil:GetEpRewardItemPriceStr(price)}
      ;
      (table.insert)(previewDataList, previewData)
      totalPrice = totalPrice + price
      if currencyId == nil then
        currencyId = thisCurrencyId
      else
        if currencyId ~= thisCurrencyId then
          error("reward bag has not same currencyId reward id:" .. tostring(itemId))
        end
      end
    end
  end
  local moneyIcon = nil
  local isKey = ConstGlobalItem.SKey == currencyId
  do
    if not isKey then
      local itemCfg = (ConfigData.item)[currencyId]
      if itemCfg ~= nil then
        moneyIcon = CRH:GetSprite(itemCfg.small_icon)
        -- DECOMPILER ERROR at PC80: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((self.ui).img_CurrencyIcon).sprite = moneyIcon
      end
    end
    ;
    (self.resourceGroup):SetResourceIds({currencyId})
    for _,previewData in pairs(previewDataList) do
      previewData.moneyIcon = moneyIcon
    end
    do return totalPrice, previewDataList end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UIEpRewardPreview._RefreshUI = function(self, totalPrice, previewDataList)
  -- function num : 0_3 , upvalues : _ENV
  local isDataEmpty = #previewDataList <= 0
  local isEmpty = false
  local setColor = Color.white
  if totalPrice == 0 and isDataEmpty then
    isEmpty = true
    setColor = (self.ui).col_TPriceEmptyCol
  end
  local totalPriceStr = tostring((math.ceil)(totalPrice / (ConfigData.game_config).staminaDividend))
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_TotalPrice).text = totalPriceStr
  ;
  ((self.ui).obj_Empty):SetActive(isEmpty)
  ;
  ((self.ui).obj_PreviewList):SetActive(not isEmpty)
  self:_SetTotalPriceEmptyUIColor(setColor)
  self:_RefreshPreviewItem(previewDataList)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIEpRewardPreview._SetTotalPriceEmptyUIColor = function(self, color)
  -- function num : 0_4 , upvalues : _ENV
  for _,compoment in ipairs((self.ui).totalPriceColArr) do
    compoment.color = color
  end
end

UIEpRewardPreview._RefreshPreviewItem = function(self, previewDataList)
  -- function num : 0_5 , upvalues : _ENV
  (self.previewItemPool):HideAll()
  for index,previewData in ipairs(previewDataList) do
    local item = (self.previewItemPool):GetOne()
    item:InitEpRewardPreviewItem(index, previewData)
  end
end

UIEpRewardPreview._OnCloseClick = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIEpRewardPreview.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (self.resourceGroup):Delete()
  self.resourceGroup = nil
  ;
  (self.previewItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIEpRewardPreview

