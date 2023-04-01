-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChipDisplace = class("UIChipDisplace", UIBaseWindow)
local base = UIBaseWindow
local UINChipDisplaceItem = require("Game.Exploration.UI.ChipDisplace.UINChipDisplaceItem")
local UINChipDetailPanel = require("Game.CommonUI.Chip.UINEpChipDetail")
local cs_tweening = (CS.DG).Tweening
UIChipDisplace.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINChipDetailPanel, _ENV
  self.chipList = {}
  self.chipItemDic = {}
  self.selectIndex = 1
  self.chipDetail = (UINChipDetailPanel.New)()
  ;
  (self.chipDetail):Init((self.ui).uINChipItemDetail)
  self.__OnClickChipItem = BindCallback(self, self.OnClickChipItem)
  self.__OnClickDetail = BindCallback(self, self.OnClickDetail)
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self.OnClickSkip)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Displace, self, self.OnClickDisplace)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnClickMap)
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).chipList).onInstantiateItem = BindCallback(self, self.OnInstantiateItem)
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).chipList).onChangeItem = BindCallback(self, self.OnChangeItem)
end

UIChipDisplace.InitChipDisplace = function(self, remainCount, isAllDisplace, epCtr)
  -- function num : 0_1 , upvalues : _ENV
  (((self.ui).btn_Map).gameObject):SetActive(ExplorationManager:HasRoomSceneInEp())
  self.epCtr = epCtr
  self.remainCount = remainCount
  self.isAllDisplace = isAllDisplace
  self:SwitchDisplaceStateUI(isAllDisplace)
  self:RefreshChipItemsUI()
  self:RefreshChipItemDetail()
  self:RefreshBtnDisplaceState()
  ;
  ((self.ui).frameNode):SetActive(true)
end

UIChipDisplace.SwitchDisplaceStateUI = function(self, isAllDisplace)
  -- function num : 0_2
  ((self.ui).maxRefresh):SetActive(not isAllDisplace)
  ;
  ((self.ui).tips):SetActive(isAllDisplace)
  local idx = isAllDisplace and 0 or 1
  ;
  ((self.ui).tex_Displace):SetIndex(idx)
end

UIChipDisplace.RefreshChipItemsUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.chipList = {}
  self.selectIndex = 1
  local chipDic = ((self.epCtr).dynPlayer):GetNormalChipDic()
  for k,chipData in pairs(chipDic) do
    if not chipData:IsConsumeSkillChip() then
      (table.insert)(self.chipList, chipData)
    end
  end
  local listCount = #self.chipList
  ;
  (((self.ui).btn_Displace).gameObject):SetActive(listCount > 0)
  ;
  (((self.ui).tran_OnSelect).gameObject):SetActive(listCount > 0)
  if listCount > 0 then
    self.chipList = ExplorationManager:SortChipDataList(self.chipList, true)
  end
  self.selectIndex = 1
  ;
  ((self.ui).chipList):ClearCells()
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).chipList).totalCount = #self.chipList
  ;
  ((self.ui).chipList):RefillCells()
  ;
  ((self.ui).tex_maxRefresh):SetIndex(0, tostring(self.remainCount))
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIChipDisplace.RefreshChipItemDetail = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for k,v in pairs(self.chipItemDic) do
    v:SetItemSelectState(self.isAllDisplace, v.idx == self.selectIndex)
    if v.idx == self.selectIndex then
      self:SetSelectFrame(v.transform)
    end
  end
  if self.isAllDisplace then
    (self.chipDetail):OnSelectChipChanged(false)
  else
    (self.chipDetail):OnSelectChipChanged(self.remainCount > 0)
  end
  self:_SetCantDisplacesActive(self.remainCount == 0)
  local selectData = (self.chipList)[self.selectIndex]
  if selectData ~= nil then
    (self.chipDetail):Show()
    ;
    (self.chipDetail):InitEpChipDetail(nil, selectData, (self.epCtr).dynPlayer, self.resloader, true, eChipDetailPowerType.None, true)
  else
    (self.chipDetail):Hide()
  end
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UIChipDisplace._SetCantDisplacesActive = function(self, active)
  -- function num : 0_5 , upvalues : _ENV
  for _,v in ipairs((self.ui).cantDisplaceArr) do
    v:SetActive(active)
  end
end

UIChipDisplace.UpdateDiff = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.remainCount = self.remainCount - 1
  ;
  ((self.ui).tex_maxRefresh):SetIndex(0, tostring(self.remainCount))
  if self.isAllDisplace then
    self:RefreshChipItemsUI()
    self:RefreshChipItemDetail()
    self:RefreshBtnDisplaceState()
    local localItemList = {}
    for i,v1 in ipairs(self.chipList) do
      for k,v2 in pairs(self.chipItemDic) do
        if v2.chipData == v1 then
          (table.insert)(localItemList, v2)
        end
      end
    end
    self:PlayAllDisplaceTween(localItemList)
    return 
  end
  do
    local remData = (self.chipList)[self.selectIndex]
    local addData = nil
    local allData = ((self.epCtr).dynPlayer):GetNormalChipDic()
    for k,v1 in pairs(allData) do
      if not v1:IsConsumeSkillChip() then
        for i,v2 in ipairs(self.chipList) do
        end
        if (v1.chipCfg).id ~= (v2.chipCfg).id then
          addData = 
          break
        end
      end
    end
    do
      -- DECOMPILER ERROR at PC81: Confused about usage of register: R4 in 'UnsetPending'

      if addData ~= nil then
        (self.chipList)[self.selectIndex] = addData
        for k,v in pairs(self.chipItemDic) do
          if v.chipData == remData then
            v:InitItem(self.selectIndex, addData, self.__OnClickChipItem)
            self:RefreshChipItemDetail()
            self:PlayAllDisplaceTween({R12_PC99})
            break
          end
        end
      end
      do
        self:RefreshBtnDisplaceState()
      end
    end
  end
end

UIChipDisplace.RefreshBtnDisplaceState = function(self)
  -- function num : 0_7
  local inRoom = ((self.ui).frameNode).activeInHierarchy
  ;
  ((self.ui).tex_MapBtnName):SetIndex(inRoom and 0 or 1)
end

UIChipDisplace.OnClickMap = function(self)
  -- function num : 0_8
  ((self.ui).frameNode):SetActive(not ((self.ui).frameNode).activeInHierarchy)
  self:RefreshBtnDisplaceState()
end

UIChipDisplace.OnClickSkip = function(self)
  -- function num : 0_9
  (self.epCtr):SendExitChipReplace()
end

UIChipDisplace.OnClickDisplace = function(self)
  -- function num : 0_10
  if self.isAllDisplace then
    self:OnClickAllDisplace()
  else
    self:OnClickDetail()
  end
end

UIChipDisplace.OnClickAllDisplace = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.remainCount > 0 then
    local showingWindow = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    showingWindow:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(TipContent.ChipReplaceAll), function()
    -- function num : 0_11_0 , upvalues : self
    (self.epCtr):SendChipReplace(0)
  end
, nil)
  else
    do
      ;
      ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.ChipReplaceNotCount))
    end
  end
end

UIChipDisplace.OnClickDetail = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local selectData = (self.chipList)[self.selectIndex]
  if selectData == nil then
    return 
  end
  if self.remainCount > 0 then
    (self.epCtr):SendChipReplace((selectData.chipCfg).id)
  else
    ;
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.ChipReplaceNotCount))
  end
end

UIChipDisplace.OnInstantiateItem = function(self, go)
  -- function num : 0_13 , upvalues : UINChipDisplaceItem
  local item = (UINChipDisplaceItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.chipItemDic)[go] = item
end

UIChipDisplace.OnChangeItem = function(self, go, index)
  -- function num : 0_14 , upvalues : _ENV
  local item = (self.chipItemDic)[go]
  if item == nil then
    error("UIChipDisplace Can`t Find Item")
    return 
  end
  local data = (self.chipList)[index + 1]
  if data == nil then
    error("UIChipDisplace Can`t Find Data")
    return 
  end
  item:InitItem(index + 1, data, self.__OnClickChipItem)
end

UIChipDisplace.OnClickChipItem = function(self, idx)
  -- function num : 0_15
  if self.selectIndex ~= idx then
    self.selectIndex = idx
    self:RefreshChipItemDetail()
  end
end

UIChipDisplace.SetSelectFrame = function(self, transform)
  -- function num : 0_16 , upvalues : _ENV
  ((self.ui).tran_OnSelect):SetParent(transform)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tran_OnSelect).localPosition = Vector3.zero
end

UIChipDisplace.PlayAllDisplaceTween = function(self, itemList)
  -- function num : 0_17 , upvalues : cs_tweening, _ENV
  local duration = 0.15
  if self.pageSequence ~= nil then
    (self.pageSequence):Kill(true)
  end
  self.pageSequence = ((cs_tweening.DOTween).Sequence)()
  for index,childData in ipairs(itemList) do
    local num = 0
    if index < 5 then
      num = num + 1
    else
      num = 1
    end
    local over = num % 5
    ;
    (self.pageSequence):Join((((((childData.ui).tran):DOLocalMoveY(20, duration)):SetLoops(2, (cs_tweening.LoopType).Yoyo)):SetRelative(true)):SetDelay(index * 0.01))
    ;
    (self.pageSequence):Join(((((childData.ui).canvasGroup):DOFade(0.4, duration)):SetLoops(2, (cs_tweening.LoopType).Yoyo)):SetDelay(over * 0.01))
  end
  ;
  (self.pageSequence):SetEase((cs_tweening.Ease).Linear)
end

UIChipDisplace.OnDelete = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.pageSequence ~= nil then
    (self.pageSequence):Kill(true)
  end
  if self.chipItemDic ~= nil then
    for k,v in pairs(self.chipItemDic) do
      v:Delete()
    end
    self.chipItemDic = nil
  end
  ;
  (self.chipDetail):OnDelete()
  ;
  (base.OnDelete)(self)
end

return UIChipDisplace

