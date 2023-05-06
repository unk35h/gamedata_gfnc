-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAdjPreset = class("UIAdjPreset", UIBaseWindow)
local base = UIBaseWindow
local UINAdjPresetSingleItem = require("Game.AdjCustom.AdjPreset.UINAdjPresetSingleItem")
local UINAdjPresetMultItem = require("Game.AdjCustom.AdjPreset.UINAdjPresetMultItem")
local CS_ResLoader = CS.ResLoader
UIAdjPreset.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAdjPresetSingleItem, UINAdjPresetMultItem, CS_ResLoader
  (UIUtil.SetTopStatus)(self, self.__BackAdjPresetWin, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickConfirm)
  self._singlePool = (UIItemPool.New)(UINAdjPresetSingleItem, (self.ui).presetSingleItem)
  ;
  ((self.ui).presetSingleItem):SetActive(false)
  self._multItem = (UINAdjPresetMultItem.New)()
  ;
  (self._multItem):Init((self.ui).presetMultItem)
  ;
  (self._multItem):Hide()
  self._presetIDItemDic = nil
  self.__OnSelectCallback = BindCallback(self, self.__OnSelect)
  self.__OnEnterEditCallback = BindCallback(self, self.__OnEnterEdit)
  self.__OnBackPresetCallback = BindCallback(self, self.__OnBackPreset)
  self._resloader = (CS_ResLoader.Create)()
  self.__RefreshItemCallback = BindCallback(self, self.__RefreshItem)
  MsgCenter:AddListener(eMsgEventId.AdjCustomModify, self.__RefreshItemCallback)
  self.__RefreshLockStateCallback = BindCallback(self, self.__RefreshLockState)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__RefreshLockStateCallback)
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    homeUI:OpenOtherCoverWin()
  end
end

UIAdjPreset.InitAdjPreset = function(self, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._callback = callback
  ;
  (self._singlePool):HideAll()
  ;
  (self._multItem):Hide()
  self._curSelect = (PlayerDataCenter.allAdjCustomData):GetUsingAdjCustomPresetId()
  self._presetIDItemDic = {}
  for i = 1, (ConfigData.game_config).adjCustomTeamMax do
    local item = nil
    if ((ConfigData.game_config).adjCustomMultDic)[i] then
      item = self._multItem
      item:Show()
    else
      item = (self._singlePool):GetOne()
    end
    item:InitAdjPresetItem(i, self._resloader, self.__OnSelectCallback, self.__OnEnterEditCallback)
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self._presetIDItemDic)[i] = item
  end
  do
    local selectItem = (self._presetIDItemDic)[self._curSelect or 0]
    if selectItem ~= nil then
      selectItem:SetSelectAdjPresetItemState(true)
    end
  end
end

UIAdjPreset.__RefreshView = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for k,item in pairs(self._presetIDItemDic) do
    item:RefreshAdjPresetItem()
    item:SetSelectAdjPresetItemState(k == self._curSelect)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIAdjPreset.__RefreshItem = function(self, id)
  -- function num : 0_3
  self:__RefreshView()
end

UIAdjPreset.__RefreshLockState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for k,item in pairs(self._presetIDItemDic) do
    item:RefreshAdjLockState()
  end
end

UIAdjPreset.__OnSelect = function(self, teamId)
  -- function num : 0_5 , upvalues : _ENV
  if self._curSelect == teamId then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.AdjCustom)
  network:CS_MainInterface_PresetChange(teamId, function()
    -- function num : 0_5_0 , upvalues : self, teamId
    local selectItem = (self._presetIDItemDic)[self._curSelect or 0]
    if selectItem ~= nil then
      selectItem:SetSelectAdjPresetItemState(false)
    end
    self._curSelect = teamId
    local selectItem = (self._presetIDItemDic)[self._curSelect or 0]
    if selectItem ~= nil then
      selectItem:SetSelectAdjPresetItemState(true)
    end
  end
)
end

UIAdjPreset.__OnEnterEdit = function(self, teamId, index)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.AdjEditor, function(window)
    -- function num : 0_6_0 , upvalues : self, teamId, index
    if window == nil then
      return 
    end
    self:Hide()
    window:InitUIAdjEditor(teamId, index, self.__OnBackPresetCallback)
  end
)
end

UIAdjPreset.__OnBackPreset = function(self)
  -- function num : 0_7
  self:Show()
end

UIAdjPreset.OnClickConfirm = function(self)
  -- function num : 0_8 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIAdjPreset.__BackAdjPresetWin = function(self)
  -- function num : 0_9 , upvalues : _ENV
  self:Delete()
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    homeUI:BackFromOtherCoverWin()
  end
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIAdjPreset.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.OnDelete)(self)
  ;
  (self._multItem):Delete()
  ;
  (self._singlePool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.AdjCustomModify, self.__RefreshItemCallback)
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__RefreshLockStateCallback)
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
end

return UIAdjPreset

