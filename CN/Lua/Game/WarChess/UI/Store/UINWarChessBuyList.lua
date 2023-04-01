-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessBuyList = class("UINWarChessBuyList", UIBaseNode)
local base = UIBaseNode
local UINWarChessStoreChipItem = require("Game.Warchess.UI.Store.UINWarChessStoreChipItem")
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
UINWarChessBuyList.ctor = function(self, storeRoomRoot)
  -- function num : 0_0
  self.storeRoomRoot = storeRoomRoot
end

UINWarChessBuyList.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINWarChessStoreChipItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.chipItemPool = (UIItemPool.New)(UINWarChessStoreChipItem, (self.ui).storeChipItem)
  self._OnClickChipItemFunc = BindCallback(self, self._OnClickChipItem)
  self.__onWCChipChanged = BindCallback(self, self.OnDynPlayChipUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
end

UINWarChessBuyList.InitWarchessStoreRoomBuyList = function(self, storeItemDataList)
  -- function num : 0_2 , upvalues : _ENV, ChipEnum
  if #storeItemDataList > 20 then
    error("The num(chip) greater than 20.")
    return 
  end
  self.itemIndexDic = {}
  local chipNum = 0
  local sortedStoreItemDataList = {}
  for k,v in ipairs(storeItemDataList) do
    (table.insert)(sortedStoreItemDataList, v)
    if v.chipData ~= nil then
      chipNum = chipNum + 1
    end
  end
  ;
  (table.sort)(sortedStoreItemDataList, function(a, b)
    -- function num : 0_2_0
    local aChip = a.chipData ~= nil
    local bChip = b.chipData ~= nil
    if aChip ~= bChip then
      return aChip
    end
    do return a.idx < b.idx end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
  self.selectIndex = nil
  for k,storeItemData in ipairs(sortedStoreItemDataList) do
    if not storeItemData.saled then
      self.selectIndex = storeItemData.idx
      break
    end
  end
  do
    if self.selectIndex == nil then
      self.selectIndex = 1
    end
    local hasChip = chipNum > 0
    ;
    ((self.ui).groupItem_Chip):SetActive(hasChip)
    ;
    (self.chipItemPool):HideAll()
    local buyPrice = nil
    for k,storeItemData in ipairs(sortedStoreItemDataList) do
      local isSelected = storeItemData.idx == self.selectIndex
      if storeItemData.chipData ~= nil then
        local chipItem = (self.chipItemPool):GetOne()
        ;
        (chipItem.transform):SetParent(((self.ui).groupItem_Chip).transform)
        ;
        (chipItem.transform):SetAsLastSibling()
        chipItem:InitWCStoreChipItem(storeItemData, (self.storeRoomRoot).CoinIconId, self._OnClickChipItemFunc, false)
        chipItem:SetStoreItemSelect(isSelected)
        if isSelected then
          buyPrice = chipItem.price
        end
        local isHadChip = false
        if not isHadChip or not (ChipEnum.eChipShowState).UpState then
          local chipShowState = (ChipEnum.eChipShowState).NewState
        end
        chipItem:SetNewTagActive(false, chipShowState)
        -- DECOMPILER ERROR at PC114: Confused about usage of register: R15 in 'UnsetPending'

        ;
        (self.itemIndexDic)[storeItemData.idx] = chipItem
      end
    end
    self.selectBuyPrice = buyPrice
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

UINWarChessBuyList.OnDynPlayChipUpdate = function(self, chipList, dynPlayer)
  -- function num : 0_3
end

UINWarChessBuyList._OnClickChipItem = function(self, chipItem)
  -- function num : 0_4
  local index = (chipItem.epStoreItemData).idx
  self.selectIndex = index
  self.selectBuyPrice = chipItem.price
  ;
  (self.storeRoomRoot):OnSelectWCSChipItemForBuy(chipItem)
end

UINWarChessBuyList.GetChipItemByIndex = function(self, index)
  -- function num : 0_5
  return (self.itemIndexDic)[index]
end

UINWarChessBuyList.RefreshAllItemSellOut = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for k,v in pairs(self.itemIndexDic) do
    v:WCRefreshShowSaledType((v.epStoreItemData).saled)
  end
end

UINWarChessBuyList.GetEpStoreBuyData = function(self)
  -- function num : 0_7
  local selectItem = (self.itemIndexDic)[self.selectIndex]
  return self.selectIndex, self.selectBuyPrice, selectItem
end

UINWarChessBuyList.OnShow = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnShow)(self)
  local scrollBar = ((self.ui).scrollRect).verticalScrollbar
  if not IsNull(scrollBar) then
    (scrollBar.gameObject):SetActive(true)
  end
  ;
  ((self.ui).otherScrollbar):SetActive(false)
end

UINWarChessBuyList.OnHide = function(self)
  -- function num : 0_9 , upvalues : base, _ENV
  (base.OnHide)()
  local scrollBar = ((self.ui).scrollRect).verticalScrollbar
  if not IsNull(scrollBar) then
    (scrollBar.gameObject):SetActive(false)
  end
  ;
  ((self.ui).otherScrollbar):SetActive(true)
end

UINWarChessBuyList.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  (self.chipItemPool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
  ;
  (base.OnDelete)(self)
end

return UINWarChessBuyList

