-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.ChipDiscard.UIEpChipDiscardBase")
local UIEpChipDiscardRoom = class("UIEpChipDiscardRoom", base)
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local cs_MessageCommon = CS.MessageCommon
UIEpChipDiscardRoom.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  ;
  (base.OnInit)(self)
  self.netCtrl = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnStoreMapClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AddTotalCount, self, self.AddChipLimit)
  self._FromMapBackToUI = BindCallback(self, self.FromMapBackToUI)
  MsgCenter:AddListener(eMsgEventId.OnShowingMapRoomClick, self._FromMapBackToUI)
end

UIEpChipDiscardRoom.OnShow = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnShow)(self)
  self:SetChipListSellBtnActive(false)
end

UIEpChipDiscardRoom.OnHide = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnHide)(self)
  self:SetChipListSellBtnActive(true)
end

UIEpChipDiscardRoom.InitEpChipDiscard = function(self, dynPlayer, closeCallback, needConsumeSkill)
  -- function num : 0_3 , upvalues : base, _ENV
  (base.InitEpChipDiscard)(self, dynPlayer, closeCallback, needConsumeSkill)
  ;
  (((self.ui).btn_Map).gameObject):SetActive(ExplorationManager:HasRoomSceneInEp())
  local opDetail = dynPlayer:GetOperatorDetail()
  self.position = opDetail.curPostion
  self.__mapActiveState = false
  self:_SwitchMapBtnState(self.__mapActiveState)
end

UIEpChipDiscardRoom.OnStoreMapClicked = function(self)
  -- function num : 0_4
  self.__mapActiveState = not self.__mapActiveState
  self:_SwitchMapBtnState(self.__mapActiveState)
end

UIEpChipDiscardRoom.FromMapBackToUI = function(self)
  -- function num : 0_5
  self.__mapActiveState = false
  self:_SwitchMapBtnState(self.__mapActiveState)
end

UIEpChipDiscardRoom._SwitchMapBtnState = function(self, openMap)
  -- function num : 0_6 , upvalues : _ENV
  if openMap then
    ((self.ui).tex_MapBtnName):SetIndex(1)
  else
    ;
    ((self.ui).tex_MapBtnName):SetIndex(0)
  end
  ;
  ((self.ui).frameNode):SetActive(not openMap)
  MsgCenter:Broadcast(eMsgEventId.DungeonHeroListActiveSet, openMap)
end

UIEpChipDiscardRoom.AddChipLimit = function(self)
  -- function num : 0_7 , upvalues : cs_MessageCommon, _ENV
  local currentItemNum = (self.dynPlayer):GetItemCount(self.costItemId)
  if self.costItemNum <= currentItemNum then
    (self.netCtrl):CS_EXPLORATION_AlgUpperLimit_PurchaseLimit(self.position)
  else
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(275))
    return 
  end
end

UIEpChipDiscardRoom.BackAction = function(self)
  -- function num : 0_8 , upvalues : base, _ENV, ExplorationEnum
  (base.CloseEpDiscard)(self)
  if self.isOverLimit then
    return false
  end
  ;
  (self.netCtrl):CS_EXPLORATION_AlgUpperLimit_Exit(self.position, function()
    -- function num : 0_8_0 , upvalues : _ENV, ExplorationEnum, self
    MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).DiscardChip)
    self:OnWinClose()
  end
)
end

UIEpChipDiscardRoom.CloseEpDiscard = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIEpChipDiscardRoom.OnDiscardChip = function(self)
  -- function num : 0_10 , upvalues : base, cs_MessageCommon, _ENV
  (base.OnDiscardChip)(self)
  if self.selectedData == nil then
    return 
  end
  if self._regOnDiscardCallback ~= nil then
    (self._regOnDiscardCallback)(self)
    return 
  end
  if not self.isOverLimit then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(260))
    return 
  end
  ;
  (cs_MessageCommon.ShowMessageBox)((string.format)(ConfigData:GetTipContent(287), (self.selectedData):GetName(), tostring(self.selectChipPrice)), function()
    -- function num : 0_10_0 , upvalues : self
    self:StartDiscardChip(self.selectedData)
  end
, nil)
end

UIEpChipDiscardRoom.StartDiscardChip = function(self, chipData)
  -- function num : 0_11 , upvalues : _ENV
  (self.netCtrl):CS_EXPLORATION_AlgUpperLimit_Sold(self.position, chipData.dataId, function()
    -- function num : 0_11_0 , upvalues : _ENV
    AudioManager:PlayAudioById(1040)
  end
)
  self.selectedData = nil
end

UIEpChipDiscardRoom.InitDiscardChipItem = function(self, item, chipData, index)
  -- function num : 0_12
  item:InitDiscardChipItem(self.discardId, chipData, self._onDiscardItemClick, self.dynPlayer)
  item:SetItemSelect(self.selectedData == chipData)
  if self.selectedData == nil and index == 0 then
    self:_OnDiscardItemClick(item)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIEpChipDiscardRoom.SetChipListSellBtnActive = function(self, active)
  -- function num : 0_13 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if win ~= nil then
    win:TrySetLimitSellBtnActive(active)
  end
end

UIEpChipDiscardRoom.OnDelete = function(self)
  -- function num : 0_14 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.OnShowingMapRoomClick, self._FromMapBackToUI)
  MsgCenter:Broadcast(eMsgEventId.DungeonHeroListActiveSet, true)
end

return UIEpChipDiscardRoom

