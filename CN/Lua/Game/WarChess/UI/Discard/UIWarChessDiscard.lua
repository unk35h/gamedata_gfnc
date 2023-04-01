-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessDiscard = class("UIWarChessDiscard", base)
local UINWarChessDiscardChipItem = require("Game.WarChess.UI.Discard.UINWarChessDiscardChipItem")
local UINChipDetailPanel = require("Game.CommonUI.Chip.UINEpChipDetail")
UIWarChessDiscard.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChipDetailPanel
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.__OnClickShowMap)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self.OnClicWCSkLeave)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AddTotalCount, self, self.OnClickWCAddChipCapacity)
  self.chipItemDic = {}
  self.chipList = nil
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).chipLoopList).onInstantiateItem = BindCallback(self, self.m_OnNewItem)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).chipLoopList).onChangeItem = BindCallback(self, self.m_OnChangeItem)
  self.chipDetailPanel = (UINChipDetailPanel.New)()
  ;
  (self.chipDetailPanel):Init((self.ui).uINChipItemDetail)
  ;
  (self.chipDetailPanel):Hide()
  ;
  ((self.ui).obj_img_DetailEmpty):SetActive(true)
  self.__onClickWCSChipItem = BindCallback(self, self.OnSelectWCSChipItem)
  self.__onChipChange = BindCallback(self, self.__OnChipChange)
  MsgCenter:AddListener(eMsgEventId.WC_ChipChange, self.__onChipChange)
  self.__onChipCapacityChange = BindCallback(self, self.__OnChipCapacityChange)
  MsgCenter:AddListener(eMsgEventId.OnChipLimitChange, self.__onChipCapacityChange)
end

UIWarChessDiscard.InitWCChipDiscard = function(self, discardCtrl, teamData)
  -- function num : 0_1
  self.discardCtrl = discardCtrl
  self._teamData = teamData
  self:RefreshWCDiscardTeamInfo()
  self:RefreshAllChips()
  self:RefreshAddLimit()
  ;
  ((self.ui).tex_MapBtnName):SetIndex(0)
end

UIWarChessDiscard.RefreshWCDiscardTeamInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local dynPlayer = (self._teamData):GetTeamDynPlayer()
  local _, curChipCount, maxChipCount = dynPlayer:IsChipOverLimitNum()
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_GroupTitle).text = (string.format)("%s(%s/%s)", (self._teamData):GetWCTeamName(), tostring(curChipCount), tostring(maxChipCount))
  self:__RefreshExitSituation(curChipCount, maxChipCount)
end

UIWarChessDiscard.__RefreshExitSituation = function(self, curChipCount, maxChipCount)
  -- function num : 0_3 , upvalues : _ENV
  local isFoceDiscard = maxChipCount < curChipCount
  ;
  ((self.ui).needDiscard):SetActive(isFoceDiscard)
  if isFoceDiscard then
    ((self.ui).tex_NeedDiscard):SetIndex(0, tostring(curChipCount - maxChipCount))
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWarChessDiscard.RefreshAddLimit = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local costItemId, costItemNum = (self.discardCtrl):GetWCCapacityUpGradeCost(self._teamData)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Money).text = tostring(costItemNum)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSpriteByItemId(costItemId)
end

UIWarChessDiscard.RefreshAllChips = function(self)
  -- function num : 0_5
  self.chipList = (self._teamData):GetWCTeamChipList()
  local num = #self.chipList
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).chipLoopList).totalCount = num
  ;
  ((self.ui).chipLoopList):RefillCells()
end

UIWarChessDiscard.m_OnNewItem = function(self, go)
  -- function num : 0_6 , upvalues : UINWarChessDiscardChipItem
  local ChipDiscardItem = (UINWarChessDiscardChipItem.New)()
  ChipDiscardItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.chipItemDic)[go] = ChipDiscardItem
end

UIWarChessDiscard.m_OnChangeItem = function(self, go, index)
  -- function num : 0_7 , upvalues : _ENV
  local ChipDiscardItem = (self.chipItemDic)[go]
  if ChipDiscardItem == nil then
    error("Can\'t find levelItem by gameObject")
    return 
  end
  local chipData = (self.chipList)[index + 1]
  if chipData == nil then
    error("Can\'t find levelData by index, index = " .. tonumber(index))
  end
  local discardPrice, MoneyIconId = (self.discardCtrl):GetWCChipDiscardPrice(chipData)
  ChipDiscardItem:InitWCDiscardChipItem(chipData, discardPrice, MoneyIconId, self.__onClickWCSChipItem)
  ChipDiscardItem:SetStoreItemSelect(self.selectedData == chipData)
  if self.selectedData == nil and index == 0 then
    self:OnSelectWCSChipItem(ChipDiscardItem)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWarChessDiscard.m_GetItemByData = function(self, chipData)
  -- function num : 0_8 , upvalues : _ENV
  for k,v in ipairs(self.chipList) do
    if v == chipData then
      local index = k - 1
      return self:m_GetItemGoByIndex(index)
    end
  end
end

UIWarChessDiscard.m_GetItemGoByIndex = function(self, index)
  -- function num : 0_9
  local go = ((self.ui).chipLoopList):GetCellByIndex(index)
  do
    if go ~= nil then
      local ChipDiscardItem = (self.chipItemDic)[go]
      return ChipDiscardItem
    end
    return nil
  end
end

UIWarChessDiscard.OnSelectWCSChipItem = function(self, chipItem)
  -- function num : 0_10 , upvalues : _ENV
  do
    if self.selectedData ~= nil and self.selectedData ~= chipItem.chipData then
      local lastItem = self:m_GetItemByData(self.selectedData)
      if lastItem ~= nil then
        lastItem:SetStoreItemSelect(false)
      end
    end
    self.selectedData = chipItem.chipData
    local index = (table.indexof)(self.chipList, self.selectedData)
    chipItem:SetStoreItemSelect(true)
    local salePrice = (self.discardCtrl):GetWCChipDiscardPrice(self.selectedData)
    local dynPlayer = (self._teamData):GetTeamDynPlayer()
    ;
    (self.chipDetailPanel):InitEpChipDetail(index, self.selectedData, dynPlayer, self.resloader, true, eChipDetailPowerType.Subtract, true)
    ;
    (self.chipDetailPanel):ShowEpChipDetailEff(5)
    ;
    (self.chipDetailPanel):SetObjNewTagActive(false)
    ;
    ((self.chipDetailPanel):GetDetailButtonGroup()):InitBtnSelByCost(false, salePrice, function()
    -- function num : 0_10_0 , upvalues : chipItem, self, _ENV
    local algId = (chipItem.chipData).dataId
    ;
    (self.discardCtrl):WCDiscardChip(algId, function()
      -- function num : 0_10_0_0 , upvalues : _ENV
      if isGameDev then
        print("丢弃结束")
      end
      ;
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8533))
    end
)
  end
)
    ;
    (self.chipDetailPanel):Show()
    ;
    ((self.ui).obj_img_DetailEmpty):SetActive(false)
  end
end

UIWarChessDiscard.OnClickWCAddChipCapacity = function(self)
  -- function num : 0_11
  (self.discardCtrl):AddWCChipCapacity(nil)
end

UIWarChessDiscard.OnClicWCSkLeave = function(self)
  -- function num : 0_12
  (self.discardCtrl):ExitWCDiscard(function()
    -- function num : 0_12_0 , upvalues : self
    self:Delete()
  end
)
end

UIWarChessDiscard.__OnClickShowMap = function(self)
  -- function num : 0_13
  local isOpen = ((self.ui).frameNode).activeInHierarchy
  ;
  ((self.ui).tex_MapBtnName):SetIndex(isOpen and 1 or 0)
  ;
  ((self.ui).frameNode):SetActive(not isOpen)
end

UIWarChessDiscard.__OnChipChange = function(self)
  -- function num : 0_14
  self.selectedData = nil
  ;
  (self.chipDetailPanel):Hide()
  ;
  ((self.ui).obj_img_DetailEmpty):SetActive(true)
  self:RefreshWCDiscardTeamInfo()
  self:RefreshAllChips()
end

UIWarChessDiscard.__OnChipCapacityChange = function(self)
  -- function num : 0_15
  self:RefreshAddLimit()
  self:RefreshWCDiscardTeamInfo()
end

UIWarChessDiscard.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.WC_ChipChange, self.__onChipChange)
  MsgCenter:RemoveListener(eMsgEventId.OnChipLimitChange, self.__onChipCapacityChange)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return UIWarChessDiscard

