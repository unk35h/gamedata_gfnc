-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayFactoryLevelUp = class("UIWhiteDayFactoryLevelUp", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINWhiteDayInfoBtnUnlockItem = require("Game.ActivityWhiteDay.UI.UINWhiteDayInfoBtnUnlockItem")
UIWhiteDayFactoryLevelUp.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount, UINWhiteDayInfoBtnUnlockItem
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self.unlockItemPool = (UIItemPool.New)(UINWhiteDayInfoBtnUnlockItem, (self.ui).obj_unlockItem)
  ;
  ((self.ui).obj_unlockItem):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnClickClose)
end

UIWhiteDayFactoryLevelUp.InitWDFactoryLevelUp = function(self, AWDData, beforeLevelUpLevel, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDData = AWDData
  self.curLevel = AWDData:GetAWDFactoryLevel()
  self.beforeLevelUpLevel = beforeLevelUpLevel
  self.closeCallback = closeCallback
  if self.curLevel <= beforeLevelUpLevel then
    (UIUtil.OnClickBackByUiTab)(self)
  end
  self:__RefreshLevelUpUI()
end

UIWhiteDayFactoryLevelUp.__RefreshLevelUpUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local randomId, _ = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  local isLimit = (self.AWDData):GetWhiteDayPhotoConvertItemIsAboveLimit()
  local unlockLevel = self.beforeLevelUpLevel + 1
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_CurrentLevel).text = tostring(self.beforeLevelUpLevel)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_LvUp).text = tostring(unlockLevel)
  ;
  (self.rewardItemPool):HideAll()
  ;
  (self.unlockItemPool):HideAll()
  local ids, nums = (self.AWDData):GetAWDFactoryLevelUpReward(self.beforeLevelUpLevel)
  for index,itemId in ipairs(ids) do
    local num = nums[index]
    local rewardItem = (self.rewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    rewardItem:InitItemWithCount(itemCfg, num, nil, nil)
    if randomId == itemId or exchangeId == itemId then
      rewardItem:SetItemRecycyleTag(isLimit)
    end
  end
  if not (self.AWDData):GetAWDFactoryLevelUpUnlockLineList(unlockLevel) then
    local lineList = table.emptytable
  end
  for _,lineId in ipairs(lineList) do
    local unlockItem = (self.unlockItemPool):GetOne()
    unlockItem:IntiInfoBtnUnlockItem(true, nil)
  end
  if not (self.AWDData):GetAWDFactoryLevelUpUnlockOrderDataList(unlockLevel) then
    local orderDataList = table.emptytable
  end
  for _,orderData in ipairs(orderDataList) do
    local unlockItem = (self.unlockItemPool):GetOne()
    unlockItem:IntiInfoBtnUnlockItem(false, orderData)
  end
end

UIWhiteDayFactoryLevelUp.BackAction = function(self)
  -- function num : 0_3
  if self.beforeLevelUpLevel + 1 < self.curLevel then
    self.beforeLevelUpLevel = self.beforeLevelUpLevel + 1
    self:__RefreshLevelUpUI()
    return 
  end
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self:Hide()
end

UIWhiteDayFactoryLevelUp.__OnClickClose = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIWhiteDayFactoryLevelUp.OnShow = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack()
  ;
  (base.OnShow)(self)
end

UIWhiteDayFactoryLevelUp.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UIWhiteDayFactoryLevelUp

