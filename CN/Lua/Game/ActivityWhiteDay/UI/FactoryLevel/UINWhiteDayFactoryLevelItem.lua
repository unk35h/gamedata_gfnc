-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayFactoryLevelItem = class("UINWhiteDayFactoryLevelItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local UINWhiteDayInfoBtnUnlockItem = require("Game.ActivityWhiteDay.UI.UINWhiteDayInfoBtnUnlockItem")
UINWhiteDayFactoryLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived, UINWhiteDayInfoBtnUnlockItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
  self.unlockItemPool = (UIItemPool.New)(UINWhiteDayInfoBtnUnlockItem, (self.ui).obj_unlockItem)
  ;
  ((self.ui).obj_unlockItem):SetActive(false)
end

UINWhiteDayFactoryLevelItem.InitWDFactoryLevelItem = function(self, AWDData, preLevelCfg, levelCfg, curLevel, curExp)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDData = AWDData
  self.preLevelCfg = preLevelCfg
  self.levelCfg = levelCfg
  local level = levelCfg.level
  local isNextLevel = level == curLevel + 1
  local isComplete = level <= curLevel
  local levelUpExp = 0
  if self.preLevelCfg ~= nil then
    levelUpExp = (self.preLevelCfg).level_up_exp
  end
  ;
  ((self.ui).obj_IsComplete):SetActive(isComplete)
  ;
  ((self.ui).obj_IsNextLevel):SetActive(isNextLevel)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Lv).text = tostring((self.levelCfg).level)
  ;
  (((self.ui).tex_ProgressBar).gameObject):SetActive(not isComplete)
  ;
  ((self.ui).tex_Complete):SetActive(isComplete)
  ;
  (((self.ui).slider).gameObject):SetActive(not isComplete)
  if not isComplete or isNextLevel then
    ((self.ui).tex_ProgressBar):SetIndex(0, tostring(curExp), tostring(levelUpExp))
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).slider).value = curExp / levelUpExp
  else
    ((self.ui).tex_ProgressBar):SetIndex(0, "0", tostring(levelUpExp))
    -- DECOMPILER ERROR at PC85: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).slider).value = 0
  end
  self:__GenRewardItems((self.levelCfg).level, isComplete)
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINWhiteDayFactoryLevelItem.__GenRewardItems = function(self, curLevel, isComplete)
  -- function num : 0_2 , upvalues : _ENV
  local randomId, _ = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  local isLimit = (self.AWDData):GetWhiteDayPhotoConvertItemIsAboveLimit()
  ;
  (self.rewardItemPool):HideAll()
  for index,itemId in ipairs((self.levelCfg).level_reward_ids) do
    local num = ((self.levelCfg).level_reward_nums)[index]
    local rewardItem = (self.rewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    rewardItem:InitItemWithCount(itemCfg, num, nil, isComplete)
    if not isComplete and (randomId == itemId or exchangeId == itemId) then
      rewardItem:SetItemRecycyleTag(isLimit)
    end
  end
  ;
  (self.unlockItemPool):HideAll()
  if not (self.AWDData):GetAWDFactoryLevelUpUnlockLineList(curLevel) then
    local lineList = table.emptytable
  end
  for _,lineId in ipairs(lineList) do
    local unlockItem = (self.unlockItemPool):GetOne()
    unlockItem:IntiInfoBtnUnlockItem(true, nil)
  end
  if not (self.AWDData):GetAWDFactoryLevelUpUnlockOrderDataList(curLevel) then
    local orderDataList = table.emptytable
  end
  for _,orderData in ipairs(orderDataList) do
    local unlockItem = (self.unlockItemPool):GetOne()
    unlockItem:IntiInfoBtnUnlockItem(false, orderData)
  end
end

UINWhiteDayFactoryLevelItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayFactoryLevelItem

