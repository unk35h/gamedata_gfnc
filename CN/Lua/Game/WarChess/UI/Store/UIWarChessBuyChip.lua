-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWarChessBuyChip = class("UIWarChessBuyChip", UIBaseWindow)
local base = UIBaseWindow
local UINWCChipDetail = require("Game.WarChess.UI.Common.UINWCChipDetail")
local UINWarChessSelectTeam = require("Game.WarChess.UI.Common.UINWarChessSelectTeam")
UIWarChessBuyChip.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCChipDetail, UINWarChessSelectTeam
  ((self.ui).wcChipDetail):SetActive(false)
  self._selectChipPool = (UIItemPool.New)(UINWCChipDetail, (self.ui).wcChipDetail)
  ;
  ((self.ui).teamNode):SetActive(false)
  self._selectTeamPool = (UIItemPool.New)(UINWarChessSelectTeam, (self.ui).teamNode)
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self._OnClickLevel)
  self._selectChipItem = nil
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_RareNum).text = 0
  self.__onWCChipChanged = BindCallback(self, self.OnDynPlayChipUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
  self.__onCoinNumChange = BindCallback(self, self.OnCoinNumChange)
  MsgCenter:AddListener(eMsgEventId.WC_CoinNumChange, self.__onCoinNumChange)
  self.__onWCChipChanged = BindCallback(self, self.OnWCBuyChipChanged)
  MsgCenter:AddListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
end

UIWarChessBuyChip.InitWCBuyChip = function(self, storeDataList, teamDataDic, buyEvent, returnFunc, coinNum, rareNum)
  -- function num : 0_1 , upvalues : _ENV
  self._teamDataDic = teamDataDic
  self._storeDataList = storeDataList
  self._buyEvent = buyEvent
  self._returnEvent = returnFunc
  self._chipItemList = {}
  self.__clickedPanelAction = BindCallback(self, self._OnClickChipPanel)
  self.__buyChipAction = BindCallback(self, self._OnBuyTeamChip)
  self:_WCRefreshChipList(self._storeDataList)
  self:OnCoinNumChange(ConstGlobalItem.WCMoney, coinNum)
  self:OnCoinNumChange(ConstGlobalItem.WCDeployPoint, rareNum)
end

UIWarChessBuyChip.OnCoinNumChange = function(self, itemId, num)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if itemId == ConstGlobalItem.WCMoney then
    ((self.ui).tex_CoinNum).text = tostring(num)
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_RareNum).text = tostring(num)
  end
end

UIWarChessBuyChip._WCRefreshChipList = function(self, storeDataList)
  -- function num : 0_3 , upvalues : _ENV
  local afterAnim = function()
    -- function num : 0_3_0 , upvalues : self, storeDataList, _ENV
    self._storeDataList = storeDataList
    self.selectChip = nil
    self._chipItemList = {}
    ;
    (self._selectChipPool):HideAll()
    for k,storeData in ipairs(storeDataList) do
      local chipData = storeData.chipData
      local chipItem = (self._selectChipPool):GetOne()
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (chipItem.gameObject).name = tostring(chipData.dataId)
      chipItem:Show()
      chipItem:InitWCChipDetail(k, chipData, self.resloader, self.__clickedPanelAction, true)
      chipItem:ShowWCChipDetailEff(5)
      chipItem:InitDissolveTweenSetting()
      chipItem:SetWCChipSelectState(false)
      chipItem:SetIsSellOutActive(storeData.saled)
      ;
      (table.insert)(self._chipItemList, chipItem)
    end
  end

  if #self._chipItemList > 0 then
    (UIUtil.AddOneCover)("UISelectChip")
    self:CleanSelect()
    local waitingAnimNum = 0
    do
      local isAddedCallback = false
      local palyOver = function()
    -- function num : 0_3_1 , upvalues : waitingAnimNum, afterAnim, _ENV
    waitingAnimNum = waitingAnimNum - 1
    if waitingAnimNum <= 0 then
      afterAnim()
      ;
      (UIUtil.CloseOneCover)("UISelectChip")
    end
  end

      for chipIndex,chipItem in ipairs(self._chipItemList) do
        if not chipItem.lockState then
          local chipPanel = chipItem:GetChipDetailPanel()
          waitingAnimNum = waitingAnimNum + 1
          chipPanel:OnDissolveTweenCompleteAction(palyOver)
          isAddedCallback = true
          chipPanel:PlayDissolveTween()
        end
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

UIWarChessBuyChip._InitWCTeamList = function(self, chipItem)
  -- function num : 0_4 , upvalues : _ENV
  (self._selectTeamPool):HideAll()
  local chipData = chipItem:GetWCChipDetailPanelData()
  for _,teamData in pairs(self._teamDataDic) do
    local selectTeamItem = (self._selectTeamPool):GetOne()
    selectTeamItem:InitWCSelectTeamBuyChip(teamData, chipData, self.resloader, chipItem.price)
    selectTeamItem:BindWCSelectTeamEvent(nil, self.__buyChipAction)
  end
end

UIWarChessBuyChip.SetDefaultChip = function(self, chipData)
  -- function num : 0_5 , upvalues : _ENV
  local chipItem = nil
  for k,v in ipairs(self._chipItemList) do
    if v:GetWCChipDetailPanelData() == chipData then
      chipItem = v
      break
    end
  end
  do
    if chipItem ~= nil then
      self:_OnClickChipPanel(chipItem, chipData)
    end
  end
end

UIWarChessBuyChip.OnDynPlayChipUpdate = function(self, chipList, dynPlayer)
  -- function num : 0_6
end

UIWarChessBuyChip.GetStoreDataByIndex = function(self, index)
  -- function num : 0_7
  local storeData = (self._storeDataList)[index]
  return storeData
end

UIWarChessBuyChip.OnBuyChipSuccessCallback = function(self, chipItem, storeData)
  -- function num : 0_8 , upvalues : _ENV
  chipItem:SetIsSellOutActive(storeData.saled)
  local tempChipItem = nil
  for k,v in ipairs(self._chipItemList) do
    local storeData = self:GetStoreDataByIndex(v.index)
    if v ~= chipItem and storeData ~= nil and not storeData.saled then
      tempChipItem = v
      break
    end
  end
  do
    if tempChipItem ~= nil then
      self:_OnClickChipPanel(tempChipItem, tempChipItem:GetWCChipDetailPanelData())
    else
      self:_OnClickLevel()
    end
  end
end

UIWarChessBuyChip._OnClickChipPanel = function(self, chipItem, chipData)
  -- function num : 0_9
  if self._selectChipItem == chipItem then
    return 
  end
  if self._selectChipItem ~= nil then
    (self._selectChipItem):SetWCChipSelectState(false, 0.3)
  end
  self._selectChipItem = chipItem
  ;
  (self._selectChipItem):SetWCChipSelectState(true, 0.3)
  self:_InitWCTeamList(self._selectChipItem)
end

UIWarChessBuyChip._OnBuyTeamChip = function(self, teamItem, teamData)
  -- function num : 0_10
  if self._selectChipItem == nil then
    return 
  end
  local storeData = self:GetStoreDataByIndex((self._selectChipItem).index)
  if self._buyEvent ~= nil and storeData ~= nil then
    (self._buyEvent)(self._selectChipItem, teamData, storeData)
  end
end

UIWarChessBuyChip._OnClickLevel = function(self)
  -- function num : 0_11
  if self._returnEvent ~= nil then
    local index = -1
    do
      do
        if self._selectChipItem ~= nil then
          local storeData = self:GetStoreDataByIndex((self._selectChipItem).index)
          if storeData ~= nil then
            index = storeData.idx
          end
        end
        ;
        (self._returnEvent)(index)
        self:Delete()
      end
    end
  end
end

UIWarChessBuyChip.OnWCBuyChipChanged = function(self, chipList, dynPlayer)
  -- function num : 0_12 , upvalues : _ENV
  if self._selectChipItem == nil then
    return 
  end
  for _,teamItem in pairs((self._selectTeamPool).listItem) do
    local teamData = teamItem:GetWCSelectTeamData()
    if teamData ~= nil and teamData:GetTeamDynPlayer() == dynPlayer then
      local chipData = (self._selectChipItem):GetWCChipDetailPanelData()
      teamItem:InitWCSelectTeamBuyChip(teamData, chipData, self.resloader, (self._selectChipItem).price)
      return 
    end
  end
end

UIWarChessBuyChip.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  for _,chipObj in ipairs(self._chipItemList) do
    chipObj:KillDOTween()
  end
  ;
  (self._selectTeamPool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.WC_CoinNumChange, self.__onCoinNumChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
  MsgCenter:RemoveListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
  ;
  (base.OnDelete)(self)
end

return UIWarChessBuyChip

