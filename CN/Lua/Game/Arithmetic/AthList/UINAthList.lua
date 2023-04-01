-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthList = class("UINAthList", UIBaseNode)
local base = UIBaseNode
local UINAthListArea = require("Game.Arithmetic.AthList.Area.UINAthListArea")
local AthSortEnum = require("Game.Arithmetic.AthList.Sort.AthSortEnum")
local UINAthListSort = require("Game.Arithmetic.AthList.Sort.UINAthListSort")
local UINAthListToggle = require("Game.Arithmetic.AthList.UINAthListToggle")
local UINAthListSuit = require("Game.Arithmetic.AthList.Suit.UINAthListSuit")
local UINAthListAreaTog = require("Game.Arithmetic.AthList.Area.UINAthListAreaTog")
local UINAthUsingRate = require("Game.Arithmetic.UsingRate.UINAthUsingRate")
local AthUtil = require("Game.Arithmetic.AthUtil")
local CS_DoTween = ((CS.DG).Tweening).DOTween
local CS_ResLoader = CS.ResLoader
local spaceIdDic = {[1] = 1, [2] = 2, [4] = 3, [8] = 4}
UINAthList.ctor = function(self, isConsumeAth)
  -- function num : 0_0
  self.isConsumeAth = isConsumeAth
  self._reverseSortOrder = not isConsumeAth
end

UINAthList.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINAthListArea, UINAthListSort, UINAthListSuit, UINAthListToggle, UINAthListAreaTog
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self:_RefreshReverseSort()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sort, self, self.OnClickSort)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Decompose, self, self._OnClickDecompose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Dteail, self, self._OnClickDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SortReverse, self, self._OnClickReverseSort)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelectAll, self, self._OnClickSelectAll)
  self.__OnClickAthItem = BindCallback(self, self.OnClickAthItem)
  self.__onAthDataUpdate = BindCallback(self, self.OnAthDataUpdate)
  self.__OnAthItemDetailShow = BindCallback(self, self._OnAthItemDetailShow)
  self.athListArea = (UINAthListArea.New)()
  ;
  (self.athListArea):Init((self.ui).areaNode)
  ;
  ((self.athListArea).athScrollList):SetAthScrollListEmptyFunc(BindCallback(self, self.ShowAthListEmpty))
  self.athListSortNode = (UINAthListSort.New)()
  ;
  (self.athListSortNode):Init((self.ui).sortDropdown)
  ;
  (self.athListSortNode):InitAthListSort(self, self.isConsumeAth)
  ;
  (self.athListSortNode):Hide()
  self.athListSuit = (UINAthListSuit.New)()
  ;
  (self.athListSuit):Init((self.ui).suitNode)
  ;
  (self.athListSuit):Hide()
  self.togArea = (UINAthListToggle.New)()
  ;
  (self.togArea):Init((self.ui).tog_Area)
  ;
  (self.togArea):InitAthListToggle(BindCallback(self, self._OnSelectAreaTog))
  self.togSuit = (UINAthListToggle.New)()
  ;
  (self.togSuit):Init((self.ui).tog_Suit)
  ;
  (self.togSuit):InitAthListToggle(BindCallback(self, self._OnSelectSuitTog))
  self.__onAthListAreaSelect = BindCallback(self, self.__OnAreaSelect)
  ;
  ((self.ui).tog_AreaItem):SetActive(false)
  self.areaTogList = (UIItemPool.New)(UINAthListAreaTog, (self.ui).tog_AreaItem)
  for i = 0, (ConfigData.game_config).athSlotCount do
    local togItem = (self.areaTogList):GetOne()
    togItem:InitAthListAreaTog(R8_PC159, self.__onAthListAreaSelect)
  end
  local fecomposeUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Algorithm_Decompose)
  self:ShowAthListDecomposeBtn(fecomposeUnlock)
  ;
  ((self.ui).tex_TogArea):SetIndex(0)
end

UINAthList.InitAthListNode = function(self, heroData, resLoader, withMat, clickItemFunc, areaId, quality, changeAreaFunc, ignoreInstalled, withSuitNode)
  -- function num : 0_2 , upvalues : _ENV, AthSortEnum
  self.heroData = heroData
  self.clickItemFunc = clickItemFunc
  self.resLoader = resLoader
  self.changeAreaFunc = changeAreaFunc
  if withSuitNode then
    (self.togSuit):Show()
  else
    ;
    (self.togSuit):Hide()
  end
  self:SetAthListArea(areaId)
  if self.suitNodeIsShow then
    self:_ShowListSuit()
    return 
  end
  ;
  ((self.ui).img_Select):SetIndex((PlayerDataCenter.allAthData):IsAthItemAttrShow() and 1 or 0)
  self.withMat = withMat
  ;
  (AthSortEnum.SetAthSortKindParam)(self._sortKindValue, self._reverseSortOrder)
  ;
  ((self.athListArea).athScrollList):SetAthScrollListSortFunc(self._sortFunc)
  ;
  (self.athListArea):InitAthListArea(heroData, areaId, quality, self.__OnClickAthItem, self.__itemStartDragFunc, resLoader, withMat, changeAreaFunc, ignoreInstalled)
  self:_ShowAreaTog(areaId)
end

UINAthList.SetAthListArea = function(self, areaId)
  -- function num : 0_3
  self.areaId = areaId
  local showUsingRate = self._showUsingRate and ((areaId ~= nil and not self.suitNodeIsShow))
  if self.athUsingRateNode then
    if showUsingRate then
      (self.athUsingRateNode):Show()
    else
      (self.athUsingRateNode):Hide()
    end
  else
    ((self.ui).athUsingRate):SetActive(showUsingRate)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINAthList._ShowAreaTog = function(self, areaId)
  -- function num : 0_4
  local selecteTogItem = ((self.areaTogList).listItem)[(areaId or 0) + 1]
  ;
  ((self.ui).areaTogGroup):SetAllTogglesOff()
  selecteTogItem:SetAthListAreaTogIsOn()
end

UINAthList.ShowAthListUsingRate = function(self)
  -- function num : 0_5 , upvalues : UINAthUsingRate, _ENV
  self._showUsingRate = true
  do
    if self.athUsingRateNode == nil then
      local athUsingRate = (UINAthUsingRate.New)()
      athUsingRate:Init((self.ui).athUsingRate)
      athUsingRate:InitAthUsingRate(BindCallback(self, self._ShowUsingRateWin))
      self.athUsingRateNode = athUsingRate
    end
    ;
    (self.athUsingRateNode):Show()
  end
end

UINAthList._ShowUsingRateWin = function(self)
  -- function num : 0_6
  (self.athUsingRateNode):ShowAthUsingRateDetail(self.heroData, self.areaId)
end

UINAthList.ShowAthListDecomposeBtn = function(self, show)
  -- function num : 0_7
  (((self.ui).btn_Decompose).gameObject):SetActive(show)
end

UINAthList.EnableAthListDecomposeMode = function(self)
  -- function num : 0_8
  (((self.ui).areaTogGroup).gameObject):SetActive(false)
  ;
  (self.athListArea):SetAthListAreaScrollTop(-20)
  ;
  ((self.ui).tex_TogArea):SetIndex(1)
  self:ShowAthListDecomposeBtn(false)
end

UINAthList.SetAthItemStartDragFunc = function(self, itemStartDragFunc)
  -- function num : 0_9
  self.__itemStartDragFunc = itemStartDragFunc
end

UINAthList.OnAthDataUpdate = function(self)
  -- function num : 0_10
  if not self.active then
    return 
  end
  if (self.athListArea).active then
    ((self.athListArea).athScrollList):RefreshAthScrollListData()
    self:RefillCurAthSortList(true)
  end
  if (self.athListSuit).active then
    (self.athListSuit):RefreshAthListSuit()
  end
end

UINAthList.RefillCurAthSortList = function(self, useLastPos)
  -- function num : 0_11 , upvalues : AthSortEnum
  (AthSortEnum.SetAthSortKindParam)(self._sortKindValue, self._reverseSortOrder)
  ;
  ((self.athListArea).athScrollList):RefillAthScrollList(nil, self._sortFunc, useLastPos)
end

UINAthList.OnClickAthItem = function(self, athItem)
  -- function num : 0_12
  if self.clickItemFunc ~= nil then
    (self.clickItemFunc)(athItem)
  end
end

UINAthList.GetAthItemGo = function(self, space)
  -- function num : 0_13 , upvalues : spaceIdDic, _ENV
  local index = spaceIdDic[space]
  if index == nil then
    error("Can\'t get athItemGo, space = " .. tostring(space))
    return 
  end
  return ((((self.athListArea).athScrollList).ui).athSpaceItemList)[index]
end

UINAthList._OnClickDecompose = function(self)
  -- function num : 0_14 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.AthDecompose, function(window)
    -- function num : 0_14_0 , upvalues : _ENV, self
    if window == nil or IsNull(self.gameObject) then
      return 
    end
    self:Hide()
    window:InitAthDecompose(self.resLoader, function()
      -- function num : 0_14_0_0 , upvalues : _ENV, self
      if IsNull(self.gameObject) then
        return 
      end
      self:Show()
      self:OnAthDataUpdate()
      ;
      ((self.ui).img_Select):SetIndex((PlayerDataCenter.allAthData):IsAthItemAttrShow() and 1 or 0)
    end
)
  end
)
end

UINAthList.OnClickSort = function(self)
  -- function num : 0_15 , upvalues : _ENV
  AudioManager:PlayAudioById(1069)
  ;
  (self.athListSortNode):ShowAthListSort()
end

UINAthList.DragInAthSortList = function(self, worldPos)
  -- function num : 0_16 , upvalues : _ENV
  local anchordPos = UIManager:World2UIPosition(worldPos, self.transform, nil, UIManager.UICamera)
  if anchordPos.x <= ((self.transform).rect).xMax then
    return true
  end
  return false
end

UINAthList.OnShow = function(self)
  -- function num : 0_17 , upvalues : _ENV
  self:SetAthSortListTween()
  MsgCenter:AddListener(eMsgEventId.OnAthDataUpdate, self.__onAthDataUpdate)
  MsgCenter:AddListener(eMsgEventId.OnAthItemDetailShow, self.__OnAthItemDetailShow)
end

UINAthList.OnHide = function(self)
  -- function num : 0_18 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.OnAthDataUpdate, self.__onAthDataUpdate)
  MsgCenter:RemoveListener(eMsgEventId.OnAthItemDetailShow, self.__OnAthItemDetailShow)
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
end

UINAthList.SetAthSortListTween = function(self)
  -- function num : 0_19 , upvalues : _ENV, CS_DoTween
  local moveX = 100
  local pageLocalPos = (self.transform).localPosition
  pageLocalPos = (Vector3.New)(pageLocalPos.x - moveX, pageLocalPos.y, pageLocalPos.z)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.transform).localPosition = pageLocalPos
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = 0.4
  if self.sequence == nil then
    local sequence = (CS_DoTween.Sequence)()
    sequence:Append(((self.transform):DOLocalMoveX(moveX, 0.3)):SetRelative(true))
    sequence:Join(((self.ui).fade):DOFade(1, 0.3))
    sequence:SetAutoKill(false)
    self.sequence = sequence
  else
    do
      ;
      (self.sequence):Restart()
    end
  end
end

UINAthList.GetAthItemFromList = function(self, uid)
  -- function num : 0_20
  return ((self.athListArea).athScrollList):GetAthItemFromListAll(uid)
end

UINAthList.ChangeAthListSort = function(self, kindType, kindValue, name, isInit)
  -- function num : 0_21 , upvalues : AthSortEnum
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R5 in 'UnsetPending'

  ((self.ui).tex_Sort).text = name
  self._sortKindValue = kindValue
  self._sortFunc = (AthSortEnum.GetSortFunc)(kindType, self.isConsumeAth)
  if not isInit then
    self:RefillCurAthSortList()
  end
end

UINAthList._ShowSortBtn = function(self, isOn)
  -- function num : 0_22
  (((self.ui).btn_Sort).gameObject):SetActive(isOn)
  ;
  (((self.ui).btn_SortReverse).gameObject):SetActive(isOn)
end

UINAthList._OnSelectAreaTog = function(self, isOn)
  -- function num : 0_23
  if self._areaTogIsShow == isOn then
    return 
  end
  self._areaTogIsShow = isOn
  self:_ShowSortBtn(isOn)
  if isOn then
    if self.showSuitAth then
      self:_Return2SuitNode(true, true)
    end
    ;
    (self.athListArea):Show()
    self:_ShowAreaTog(self.areaId)
  else
    ;
    (self.athListArea):Hide()
  end
end

UINAthList._OnSelectSuitTog = function(self, isOn)
  -- function num : 0_24
  if self.suitNodeIsShow == isOn then
    return 
  end
  self.suitNodeIsShow = isOn
  if isOn then
    if self.showSuitAth then
      self:_Return2SuitNode(true)
      return 
    end
    self:_ShowListSuit()
  else
    ;
    (self.athListSuit):Hide()
  end
end

UINAthList._ShowListSuit = function(self)
  -- function num : 0_25
  if self.showSuitAth then
    self:_Return2SuitNode(true)
  end
  ;
  (self.athListSuit):Show()
  ;
  (self.athListSuit):InitAthListSuit(self, self.heroData, self.resLoader)
  self:_ShowAreaTog(self.areaId)
end

UINAthList.ShowAthListSuitAth = function(self, suitId)
  -- function num : 0_26 , upvalues : _ENV, AthUtil
  (UIUtil.SetTopStatus)(self, self._Return2SuitNode, nil, AthUtil.ShowATHInfoFunc)
  ;
  (self.athListSuit):Hide()
  ;
  (self.athListArea):Show()
  self:_ShowSortBtn(true)
  self:ShowAthListAreaTogs(false)
  ;
  (self.athListArea):ShowAthListAreaSuitPartTog(true, suitId)
  self.showSuitAth = true
end

UINAthList._Return2SuitNode = function(self, popFunc, withoutSuit)
  -- function num : 0_27 , upvalues : _ENV, AthSortEnum
  if popFunc then
    (UIUtil.PopFromBackStack)()
  end
  if not withoutSuit then
    (self.athListSuit):Show()
    ;
    (self.athListSuit):RefreshAthListSuit()
    self:_ShowSortBtn(false)
  end
  ;
  (self.athListArea):Hide()
  ;
  ((self.athListArea).athScrollList):SetAthScrollListSuitId(nil)
  ;
  (AthSortEnum.SetAthSortKindParam)(self._sortKindValue, self._reverseSortOrder)
  ;
  ((self.athListArea).athScrollList):SetAthScrollListSortFunc(self._sortFunc)
  self:ShowAthListAreaTogs(true)
  ;
  (self.athListArea):ShowAthListAreaSuitPartTog(false)
  self.showSuitAth = false
end

UINAthList.__OnAreaSelect = function(self, areaId)
  -- function num : 0_28
  if areaId == 0 then
    areaId = nil
  end
  self:ChangeAthListArea(areaId)
  if self.changeAreaFunc ~= nil then
    (self.changeAreaFunc)(areaId)
  end
end

UINAthList.ShowAthListAreaTogs = function(self, show)
  -- function num : 0_29
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).cg_areaTogGroup).alpha = show and 1 or 0
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).cg_areaTogGroup).interactable = show
end

UINAthList.ChangeAthListArea = function(self, areaId)
  -- function num : 0_30
  if self.suitNodeIsShow then
    (self.athListSuit):SetAthListSuitArea(areaId)
  else
    ;
    ((self.athListArea).athScrollList):SetAthScrollListArea(areaId)
    ;
    ((self.athListArea).athScrollList):RefreshAthScrollListData()
    ;
    ((self.athListArea).athScrollList):RefillAthScrollList()
  end
end

UINAthList.SelectAthListSuit = function(self, athSuitId)
  -- function num : 0_31 , upvalues : _ENV
  if self.showSuitAth then
    (UIUtil.OnClickBack)()
  end
  ;
  (self.togSuit):SetAthListTogSelect(true)
  ;
  (self.athListSuit):SetAthListSuitSelectedSuitId(athSuitId)
  ;
  (self.athListSuit):RefreshAthListSuit(true, athSuitId)
end

UINAthList._OnClickDetail = function(self, isOn)
  -- function num : 0_32 , upvalues : _ENV
  (PlayerDataCenter.allAthData):SetAthItemAttrShow(not (PlayerDataCenter.allAthData):IsAthItemAttrShow())
end

UINAthList._OnClickReverseSort = function(self)
  -- function num : 0_33
  self._reverseSortOrder = not self._reverseSortOrder
  self:_RefreshReverseSort()
  self:RefillCurAthSortList()
end

UINAthList._RefreshReverseSort = function(self)
  -- function num : 0_34
  ((self.ui).img_Ascend):SetActive(not self._reverseSortOrder)
  ;
  ((self.ui).img_Descend):SetActive(self._reverseSortOrder)
end

UINAthList._OnAthItemDetailShow = function(self)
  -- function num : 0_35 , upvalues : _ENV
  if not self.active then
    return 
  end
  local show = (PlayerDataCenter.allAthData):IsAthItemAttrShow()
  ;
  ((self.ui).img_Select):SetIndex(show and 1 or 0)
  if (self.athListArea).active then
    self:RefillCurAthSortList(true)
  end
end

UINAthList.SetAthListSelectAllFunc = function(self, selectAllFunc)
  -- function num : 0_36
  self.selectAllFunc = selectAllFunc
  ;
  (((self.ui).btn_SelectAll).gameObject):SetActive(true)
end

UINAthList._OnClickSelectAll = function(self)
  -- function num : 0_37
  if self.selectAllFunc ~= nil then
    (self.selectAllFunc)()
  end
end

UINAthList.ShowAthListEmpty = function(self, isShow)
  -- function num : 0_38
  ((self.ui).emptyNode):SetActive(isShow)
end

UINAthList.OnDelete = function(self)
  -- function num : 0_39 , upvalues : base
  (self.athListArea):Delete()
  ;
  (self.athListSortNode):Delete()
  ;
  (self.athListSuit):Delete()
  if self.athUsingRateNode then
    (self.athUsingRateNode):Delete()
  end
  ;
  (self.togArea):Delete()
  ;
  (self.togSuit):Delete()
  if self.sequence ~= nil then
    (self.sequence):Kill()
    self.sequence = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINAthList

