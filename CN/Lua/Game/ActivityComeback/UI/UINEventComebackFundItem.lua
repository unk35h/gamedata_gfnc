-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackFundItem = class("UINEventComebackFundItem", UIBaseNode)
local base = UIBaseNode
local UINEventComebackFundRewardItem = require("Game.ActivityComeback.UI.UINEventComebackFundRewardItem")
UINEventComebackFundItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventComebackFundRewardItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Receive, self, self.__OnClickItem)
  self._rewardPool = (UIItemPool.New)(UINEventComebackFundRewardItem, (self.ui).itemWithLock)
  ;
  ((self.ui).itemWithLock):SetActive(false)
end

UINEventComebackFundItem.InitCombackFundItem = function(self, fundItemCfg, targetItemId, targetItemCount, clickEvent)
  -- function num : 0_1 , upvalues : _ENV
  self._targetItemCount = targetItemCount
  self._fundLevel = fundItemCfg.level
  self._clickEvent = clickEvent
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(targetItemId)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Count).text = tostring(targetItemCount)
  ;
  (self._rewardPool):HideAll()
  for i,itemId in ipairs(fundItemCfg.base_item_ids) do
    local itemCfg = (ConfigData.item)[itemId]
    local itemCount = (fundItemCfg.base_item_nums)[i]
    local item = (self._rewardPool):GetOne()
    item:InitFundRewardItem(itemCfg, itemCount)
  end
  for i,itemId in ipairs(fundItemCfg.senior_item_ids) do
    local itemCfg = (ConfigData.item)[itemId]
    local itemCount = (fundItemCfg.senior_item_nums)[i]
    local item = (self._rewardPool):GetOne()
    item:InitFundRewardItem(itemCfg, itemCount)
  end
end

UINEventComebackFundItem.RefreshConbackFundItemState = function(self, isUnlock, isTarget, isReveice)
  -- function num : 0_2 , upvalues : _ENV
  if isTarget then
    local bottomLight = not isReveice
  end
  ;
  ((self.ui).bottom):SetIndex(bottomLight and 1 or 0)
  if not isUnlock then
    ((self.ui).obj_Locked):SetActive(true)
    ;
    (((self.ui).tex_Received).gameObject):SetActive(false)
    ;
    ((self.ui).tex_Received):SetIndex(0)
    ;
    (((self.ui).btn_NotReceive).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Receive).gameObject):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_Locked):SetActive(false)
  ;
  (((self.ui).btn_NotReceive).gameObject):SetActive(not isTarget)
  if isTarget then
    (((self.ui).btn_Receive).gameObject):SetActive(not isReveice)
    if isTarget and isReveice then
      (((self.ui).tex_Received).gameObject):SetActive(true)
      ;
      ((self.ui).tex_Received):SetIndex(1)
    else
      ;
      (((self.ui).tex_Received).gameObject):SetActive(false)
    end
    for i,item in ipairs((self._rewardPool).listItem) do
      item:SetPickedUIActive(isReveice)
      item:SetRewardLockState(isUnlock and not isTarget)
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINEventComebackFundItem.GetConbackFundLevel = function(self)
  -- function num : 0_3
  return self._fundLevel
end

UINEventComebackFundItem.GetTargetItemCount = function(self)
  -- function num : 0_4
  return self._targetItemCount
end

UINEventComebackFundItem.__OnClickItem = function(self)
  -- function num : 0_5
  if self._clickEvent ~= nil then
    (self._clickEvent)(self._fundLevel)
  end
end

return UINEventComebackFundItem

