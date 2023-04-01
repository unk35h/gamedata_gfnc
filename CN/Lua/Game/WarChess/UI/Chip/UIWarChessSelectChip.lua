-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWarChessSelectChip = class("UIWarChessSelectChip", UIBaseWindow)
local base = UIBaseWindow
local cs_Ease = ((CS.DG).Tweening).Ease
local UINWCChipDetail = require("Game.WarChess.UI.Common.UINWCChipDetail")
local UINWarChessSelectTeam = require("Game.WarChess.UI.Common.UINWarChessSelectTeam")
UIWarChessSelectChip.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCChipDetail, UINWarChessSelectTeam
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self._OnClickWCSkipChip)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self._OnClickWCRefreshChip)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnClickShowMap)
  ;
  ((self.ui).tex_MapBtnName):SetIndex(0)
  ;
  ((self.ui).wcChipDetail):SetActive(false)
  self._selectChipPool = (UIItemPool.New)(UINWCChipDetail, (self.ui).wcChipDetail)
  ;
  ((self.ui).teamNode):SetActive(false)
  self._selectTeamPool = (UIItemPool.New)(UINWarChessSelectTeam, (self.ui).teamNode)
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Skip).gameObject):SetActive(false)
  self.resloader = ((CS.ResLoader).Create)()
  self._selectChipItem = nil
  self._updateWCSelectChipRefreshInfo = BindCallback(self, self.UpdateWCSelectChipRefreshInfo)
  MsgCenter:AddListener(eMsgEventId.WC_ItemNumChange, self._updateWCSelectChipRefreshInfo)
end

UIWarChessSelectChip.InitWCSelectChip = function(self, chipDataList, teamDataDic, selectEvent)
  -- function num : 0_1 , upvalues : _ENV
  self._teamDataDic = teamDataDic
  self._chipDataList = chipDataList
  self._selectEvent = selectEvent
  self.__clickedPanelAction = BindCallback(self, self._OnClickChipPanel)
  self.__selectChipAction = BindCallback(self, self._OnSelectTeamChip)
  self:_WCRefreshChipList(chipDataList)
  local shopId = WarChessManager:GetWCLevelShopId()
  local shopCoinCfg = (ConfigData.warchess_shop_coin)[shopId]
  self._shopConinCfg = shopCoinCfg
end

UIWarChessSelectChip.InitWCSelectChipRefresh = function(self, refreshEvent, refreshTime)
  -- function num : 0_2
  self._refreshEvent = refreshEvent
  self._refreshLimit = (self._shopConinCfg).battle_times_limit
  self._refreshTime = refreshTime or 0
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(self._refreshEvent ~= nil and self._refreshTime < self._refreshLimit)
  self:UpdateWCSelectChipRefreshInfo()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWarChessSelectChip.InitWCSelectChipSkip = function(self, skipEvent)
  -- function num : 0_3
  self._skipEvent = skipEvent
  ;
  (((self.ui).btn_Skip).gameObject):SetActive(self._skipEvent ~= nil)
  self:UpdateWCSelectChipSkipInfo()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWarChessSelectChip._WCRefreshChipList = function(self, chipDataList)
  -- function num : 0_4 , upvalues : _ENV, cs_Ease
  local afterAnim = function()
    -- function num : 0_4_0 , upvalues : self, chipDataList, _ENV
    self._chipDataList = chipDataList
    self.selectChip = nil
    self._chipItemList = {}
    if self._oldChipListPos == nil then
      self._oldChipListPos = (((self.ui).obj_ChipList).transform).localPosition
    end
    ;
    (self._selectChipPool):HideAll()
    for k,chipData in ipairs(chipDataList) do
      local chipItem = (self._selectChipPool):GetOne()
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (chipItem.gameObject).name = tostring(chipData.dataId)
      chipItem:Show()
      chipItem:InitWCChipDetail(k, chipData, self.resloader, self.__clickedPanelAction)
      chipItem:ShowWCChipDetailEff(5)
      chipItem:InitDissolveTweenSetting()
      chipItem:InitWCChipSelectState()
      ;
      (table.insert)(self._chipItemList, chipItem)
    end
    if #chipDataList ~= 1 then
      ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)(((self.ui).obj_ChipList).transform)
      -- DECOMPILER ERROR at PC72: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (((self.ui).obj_ChipList).transform).localPosition = (Vector3.New)(0, 40, 0)
      -- DECOMPILER ERROR at PC75: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.ui).layout_ChipList).enabled = false
    end
    -- DECOMPILER ERROR at PC78: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).canvas_TeamList).alpha = 0
    if #chipDataList == 1 then
      self:_OnClickChipPanel(((self._selectChipPool).listItem)[1], chipDataList[1])
    end
  end

  if self._chipItemList ~= nil and #self._chipItemList > 0 then
    (UIUtil.AddOneCover)("UISelectChip")
    self:_WCCleanSelect()
    local waitingAnimNum = 0
    do
      local isAddedCallback = false
      local palyOver = function()
    -- function num : 0_4_1 , upvalues : waitingAnimNum, afterAnim, _ENV
    waitingAnimNum = waitingAnimNum - 1
    if waitingAnimNum <= 0 then
      afterAnim()
      ;
      (UIUtil.CloseOneCover)("UISelectChip")
    end
  end

      for chipIndex,chipPanel in ipairs(self._chipItemList) do
        waitingAnimNum = waitingAnimNum + 1
        chipPanel:OnDissolveTweenCompleteAction(palyOver)
        isAddedCallback = true
        chipPanel:PlayDissolveTween()
        ;
        (((self.ui).canvas_TeamList):DOFade(0, 1)):SetEase(cs_Ease.OutQuad)
      end
      AudioManager:PlayAudioById(1123)
      if not isAddedCallback then
        afterAnim()
      end
    end
  else
    do
      afterAnim()
    end
  end
end

UIWarChessSelectChip._InitWCTeamList = function(self, chipItem)
  -- function num : 0_5 , upvalues : _ENV
  (self._selectTeamPool):HideAll()
  local chipData = chipItem:GetWCChipDetailPanelData()
  for _,teamData in pairs(self._teamDataDic) do
    local selectTeamItem = (self._selectTeamPool):GetOne()
    selectTeamItem:InitWCSelectTeamGetChip(teamData, chipData, self.resloader, chipItem.price)
    selectTeamItem:BindWCSelectTeamEvent(self.__selectChipAction)
  end
end

UIWarChessSelectChip.UpdateWCSelectChipRefreshInfo = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._refreshEvent == nil then
    return 
  end
  if self._refreshLimit <= self._refreshTime then
    (((self.ui).btn_Refresh).gameObject):SetActive(false)
    return 
  end
  local costMoney = (self._shopConinCfg).init_fresh_price + self._refreshTime * (self._shopConinCfg).increase_fresh_price
  local money = ((WarChessManager:GetWarChessCtrl()).backPackCtrl):GetWCItemNum((self._shopConinCfg).item1)
  self.__isLackRefreshItem = costMoney > 0 and money < costMoney
  ;
  ((self.ui).img_Lack):SetActive(self.__isLackRefreshItem)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_RefreshPay).text = tostring(costMoney)
  ;
  ((self.ui).tex_Refresh):SetIndex(self.__isLackRefreshItem and 1 or 0)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIWarChessSelectChip.UpdateWCSelectChipSkipInfo = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._skipEvent == nil then
    return 
  end
  local maxChipSold = 0
  for k,chipData in pairs(self._chipDataList) do
    local count = chipData:GetChipCount()
    local price = ((self._shopConinCfg).function_over_payback)[count] or 0
    if maxChipSold < price then
      maxChipSold = price
    end
  end
  if maxChipSold == 0 then
    return 
  end
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_GiveupPrice).text = tostring(maxChipSold)
end

UIWarChessSelectChip.OnClickShowMap = function(self)
  -- function num : 0_8
  local isOpen = ((self.ui).frameNode).activeInHierarchy
  ;
  ((self.ui).tex_MapBtnName):SetIndex(isOpen and 1 or 0)
  ;
  ((self.ui).frameNode):SetActive(not isOpen)
end

UIWarChessSelectChip._OnClickChipPanel = function(self, chipItem, chipData)
  -- function num : 0_9 , upvalues : cs_Ease, _ENV
  if self._selectChipItem == chipItem then
    return 
  end
  if self._selectChipItem ~= nil then
    (self._selectChipItem):SetWCChipSelectState(false, 0.3)
  else
    ;
    ((((self.ui).obj_ChipList).transform):DOLocalMove(self._oldChipListPos, 0.3)):SetEase(cs_Ease.OutQuad)
    ;
    ((((((self.ui).canvas_TeamList).gameObject).transform):DOLocalMoveY(-245, 0.3)):From()):SetEase(cs_Ease.OutQuad)
    ;
    (((self.ui).canvas_TeamList):DOFade(1, 0.3)):SetEase(cs_Ease.OutQuad)
    for k,chipObj in ipairs(self._chipItemList) do
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R8 in 'UnsetPending'

      if chipObj ~= chipItem then
        ((chipObj.ui).img_unSelected).color = (Color.New)(0, 0, 0, 0.4)
      end
    end
  end
  do
    self._selectChipItem = chipItem
    if self._selectChipItem == nil then
      return 
    end
    ;
    (self._selectChipItem):SetWCChipSelectState(true, 0.3)
    self:_InitWCTeamList(self._selectChipItem)
  end
end

UIWarChessSelectChip._OnSelectTeamChip = function(self, teamItem, teamData)
  -- function num : 0_10
  if self._selectChipItem == nil then
    return 
  end
  local index = (self._selectChipItem).index
  local chipData = (self._selectChipItem):GetWCChipDetailPanelData()
  ;
  (self._selectEvent)(index, teamData, function()
    -- function num : 0_10_0 , upvalues : self
    self:Delete()
  end
)
end

UIWarChessSelectChip._OnClickWCMap = function(self)
  -- function num : 0_11
end

UIWarChessSelectChip._OnClickWCSkipChip = function(self)
  -- function num : 0_12 , upvalues : _ENV, cs_Ease
  self:_OnClickChipPanel()
  if self._isGiveUp then
    return 
  end
  self._isGiveUp = true
  if self._skipEvent ~= nil then
    (UIUtil.AddOneCover)("UISelectChip")
    ;
    (self._skipEvent)(function(afterAnimCallabck)
    -- function num : 0_12_0 , upvalues : self, _ENV, cs_Ease
    self:_WCCleanSelect()
    local afterAnim = function()
      -- function num : 0_12_0_0 , upvalues : self, _ENV, afterAnimCallabck
      self:Delete()
      ;
      (UIUtil.CloseOneCover)("UISelectChip")
      if afterAnimCallabck ~= nil then
        afterAnimCallabck()
      end
    end

    local waitingAnimNum = 0
    local isAddedCallback = false
    local palyOver = function()
      -- function num : 0_12_0_1 , upvalues : waitingAnimNum, afterAnim
      waitingAnimNum = waitingAnimNum - 1
      if waitingAnimNum <= 0 then
        afterAnim()
      end
    end

    for chipIndex,chipPanel in ipairs(self._chipItemList) do
      waitingAnimNum = waitingAnimNum + 1
      chipPanel:OnDissolveTweenCompleteAction(palyOver)
      isAddedCallback = true
      chipPanel:PlayDissolveTween()
      ;
      (((self.ui).canvas_TeamList):DOFade(0, 1)):SetEase(cs_Ease.OutQuad)
    end
    AudioManager:PlayAudioById(1123)
    if not isAddedCallback then
      afterAnim()
    end
  end
)
  end
end

UIWarChessSelectChip._OnClickWCRefreshChip = function(self)
  -- function num : 0_13 , upvalues : cs_Ease
  if self._refreshEvent ~= nil and self._refreshTime < self._refreshLimit then
    if self.__isLackRefreshItem then
      return 
    end
    self._refreshTime = self._refreshTime + 1
    self:_OnClickChipPanel()
    ;
    (((self.ui).canvas_TeamList):DOFade(0, 0.3)):SetEase(cs_Ease.OutQuad)
    ;
    (self._refreshEvent)()
  end
end

UIWarChessSelectChip._WCCleanSelect = function(self)
  -- function num : 0_14 , upvalues : _ENV
  for _,v in pairs(self._chipItemList) do
    v:UnSelectAlpha(false)
  end
end

UIWarChessSelectChip.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemNumChange, self._updateWCSelectChipRefreshInfo)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self._selectTeamPool):DeleteAll()
  ;
  ((self.ui).canvas_TeamList):DOKill()
  ;
  ((((self.ui).canvas_TeamList).gameObject).transform):DOKill()
  ;
  (((self.ui).obj_ChipList).transform):DOKill()
  for _,chipObj in ipairs(self._chipItemList) do
    chipObj:KillDOTween()
  end
  if self._selectChipPool ~= nil then
    (self._selectChipPool):HideAll()
  end
  self._chipItemList = nil
  ;
  (base.OnDelete)(self)
end

return UIWarChessSelectChip

