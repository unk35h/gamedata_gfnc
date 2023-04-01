-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpChipDiscardBase = class("UIEpChipDiscardBase", UIBaseWindow)
local base = UIBaseWindow
local UINEpChipDiscardItem = require("Game.Exploration.UI.ChipDiscard.UINEpChipDiscardItem")
local UINChipDetailPanel = require("Game.CommonUI.Chip.UINEpChipDetail")
local cs_ResLoader = CS.ResLoader
UIEpChipDiscardBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINChipDetailPanel
  self.chipItemDic = {}
  self.isOverLimit = true
  self.costItemNum = 0
  self.costItemId = ConstGlobalItem.EpMoney
  self.resLoader = (cs_ResLoader.Create)()
  self._onChipListChange = BindCallback(self, self.OnChipListChange, false)
  MsgCenter:AddListener(eMsgEventId.OnEpChipListChange, self._onChipListChange)
  self._onChipLimitChange = BindCallback(self, self._OnChipLimitChange)
  MsgCenter:AddListener(eMsgEventId.OnChipLimitChange, self._onChipLimitChange)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self.CloseEpDiscard)
  self._onDiscardItemClick = BindCallback(self, self._OnDiscardItemClick)
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).chipLoopList).onInstantiateItem = BindCallback(self, self._OnNewItem)
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).chipLoopList).onChangeItem = BindCallback(self, self._OnChangeItem)
  self.chipDetailPanel = (UINChipDetailPanel.New)()
  ;
  (self.chipDetailPanel):Init((self.ui).uINChipItemDetail)
  self._onDiscardChip = BindCallback(self, self.OnDiscardChip)
  self._onChipDetailActiveChange = BindCallback(self, self._OnChipDetailActiveChange)
  MsgCenter:AddListener(eMsgEventId.OnDungeonDetailWinChange, self._onChipDetailActiveChange)
  self:SetEmptyUI(false)
end

UIEpChipDiscardBase.OnShow = function(self)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.OnShow)(self)
  MsgCenter:Broadcast(eMsgEventId.OnEpBuffListDisplay, false)
  ;
  (self.transform):SetAsFirstSibling()
end

UIEpChipDiscardBase.OnHide = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.OnHide)(self)
  MsgCenter:Broadcast(eMsgEventId.OnEpBuffListDisplay, true)
end

UIEpChipDiscardBase.InitEpChipDiscard = function(self, dynPlayer, closeCallback, needConsumeSkill)
  -- function num : 0_3
  self.dynPlayer = dynPlayer
  self._closeCallback = closeCallback
  self._needConsumeSkill = needConsumeSkill
  self.discardId = (self.dynPlayer):GetChipDiscardId()
  self:OnChipListChange(true)
end

UIEpChipDiscardBase.OnChipListChange = function(self, isFirstOpen)
  -- function num : 0_4 , upvalues : _ENV
  self:RefreshExitSituation()
  self:RefreshAddLimit()
  self:RefreshLoopList()
  MsgCenter:Broadcast(eMsgEventId.OnChipDiscardChanged, isFirstOpen)
end

UIEpChipDiscardBase._OnChipLimitChange = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self:RefreshExitSituation()
  self:RefreshAddLimit()
  MsgCenter:Broadcast(eMsgEventId.OnChipDiscardChanged, false)
end

UIEpChipDiscardBase.RefreshExitSituation = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local nowCount, nowLimit = nil, nil
  self.isOverLimit = (self.dynPlayer):IsChipOverLimitNum()
  ;
  ((self.ui).needDiscard):SetActive(self.isOverLimit)
  if self.isOverLimit then
    local needDrop = nowCount - nowLimit
    ;
    ((self.ui).tex_NeedDiscard):SetIndex(0, tostring(needDrop))
  end
end

UIEpChipDiscardBase.RefreshAddLimit = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self.costItemId = (self.dynPlayer):GetChipUpgradeLimitPrice()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Money).text = tostring(self.costItemNum)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSpriteByItemId(self.costItemId)
end

UIEpChipDiscardBase.RefreshLoopList = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self.chipDataList = {}
  for chipId,chipData in pairs((self.dynPlayer):GetNormalChipDic()) do
    if self._needConsumeSkill or not chipData:IsConsumeSkillChip() then
      (table.insert)(self.chipDataList, chipData)
    end
  end
  local num = #self.chipDataList
  if num > 0 then
    (self.chipDetailPanel):Show()
  else
    ;
    (self.chipDetailPanel):Hide()
  end
  if #self.chipDataList > 0 then
    self.chipDataList = ExplorationManager:SortChipDataList(self.chipDataList, true)
  end
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).chipLoopList).totalCount = num
  ;
  ((self.ui).chipLoopList):RefillCells()
end

UIEpChipDiscardBase._OnNewItem = function(self, go)
  -- function num : 0_9 , upvalues : UINEpChipDiscardItem
  local item = (UINEpChipDiscardItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.chipItemDic)[go] = item
end

UIEpChipDiscardBase._OnChangeItem = function(self, go, index)
  -- function num : 0_10 , upvalues : _ENV
  local item = (self.chipItemDic)[go]
  if item == nil then
    error("Can\'t find levelItem by gameObject")
    return 
  end
  local chipData = (self.chipDataList)[index + 1]
  if chipData == nil then
    error("Can\'t find levelData by index, index = " .. tonumber(index))
  end
  self:InitDiscardChipItem(item, chipData, index)
end

UIEpChipDiscardBase.InitDiscardChipItem = function(self, item, chipData, index)
  -- function num : 0_11
end

UIEpChipDiscardBase._OnDiscardItemClick = function(self, discardItem)
  -- function num : 0_12 , upvalues : _ENV
  if discardItem == nil then
    return 
  end
  do
    if self.selectedData ~= nil and self.selectedData ~= discardItem.chipData then
      local lastItem = self:_GetItemByData(self.selectedData)
      if lastItem ~= nil then
        lastItem:SetItemSelect(false)
      end
    end
    self.selectedData = discardItem.chipData
    self.selectChipPrice = discardItem.price
    discardItem:SetItemSelect(true)
    ;
    (self.chipDetailPanel):Show()
    ;
    (self.chipDetailPanel):InitEpChipDetail(nil, discardItem.chipData, self.dynPlayer, self.resloader, true, eChipDetailPowerType.Subtract, true)
    ;
    (self.chipDetailPanel):ShowHeroHeadOrTacticActive(true)
    local sprite, numStr = discardItem:GetEpChipDiscardItemMoneyIconSpriteNum()
    ;
    ((self.chipDetailPanel):GetDetailButtonGroup()):InitBtnSelByCost(false, numStr, self._onDiscardChip, sprite)
  end
end

UIEpChipDiscardBase._GetItemByData = function(self, selData)
  -- function num : 0_13 , upvalues : _ENV
  for k,v in ipairs(self.chipDataList) do
    if v == selData then
      local index = k - 1
      return self:_GetItemGoByIndex(index)
    end
  end
end

UIEpChipDiscardBase._GetItemGoByIndex = function(self, index)
  -- function num : 0_14
  local go = ((self.ui).chipLoopList):GetCellByIndex(index)
  do
    if go ~= nil then
      local ChipDiscardItem = (self.chipItemDic)[go]
      return ChipDiscardItem
    end
    return nil
  end
end

UIEpChipDiscardBase.OnDiscardChip = function(self)
  -- function num : 0_15
end

UIEpChipDiscardBase._OnChipDetailActiveChange = function(self, active)
  -- function num : 0_16
  if active then
    self:Hide()
  else
    self:Show()
  end
end

UIEpChipDiscardBase.OnWinClose = function(self)
  -- function num : 0_17
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
  self:Delete()
end

UIEpChipDiscardBase.OnDelete = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnEpChipListChange, self._onChipListChange)
  MsgCenter:RemoveListener(eMsgEventId.OnChipLimitChange, self._onChipLimitChange)
  MsgCenter:RemoveListener(eMsgEventId.OnDungeonDetailWinChange, self._onChipDetailActiveChange)
  ;
  (((self.ui).chipLoopList).gameObject):SetActive(false)
  if self.chipItemDic ~= nil then
    for k,v in pairs(self.chipItemDic) do
      v:OnDelete()
    end
    self.chipItemDic = nil
  end
  ;
  (base.OnDelete)(self)
end

UIEpChipDiscardBase.CloseEpDiscard = function(self)
  -- function num : 0_19
end

UIEpChipDiscardBase.SetEmptyUI = function(self, active)
  -- function num : 0_20 , upvalues : _ENV
  for k,v in ipairs((self.ui).emptys) do
    v:SetActive(active)
  end
end

UIEpChipDiscardBase.OnDeleteEntity = function(self)
  -- function num : 0_21 , upvalues : base
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  ;
  (self.chipDetailPanel):Delete()
  ;
  (base.OnDeleteEntity)(self)
end

return UIEpChipDiscardBase

