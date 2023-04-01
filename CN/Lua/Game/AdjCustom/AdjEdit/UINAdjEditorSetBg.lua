-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorSetBg = class("UINAdjEditorSetBg", UIBaseNode)
local base = UIBaseNode
local UINAdjEditorSetBgItem = require("Game.AdjCustom.AdjEdit.UINAdjEditorSetBgItem")
local CS_ResLoader = CS.ResLoader
local CS_MessageCommon = CS.MessageCommon
UINAdjEditorSetBg.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_ResLoader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).bgList).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).bgList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).bgList).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self.__OnSelectBgCallback = BindCallback(self, self.__OnSelectBg)
  self._bgGoItemDic = {}
  self._bgIdItemDic = nil
  self._resloader = (CS_ResLoader.Create)()
  self._defaultConfirmColor = ((self.ui).img_confirm).color
  self.__OnListenItemUpdateCallback = BindCallback(self, self.__OnListenItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnListenItemUpdateCallback)
end

UINAdjEditorSetBg.InitUINAdjEditorSetBg = function(self, editMain)
  -- function num : 0_1
  self._editMain = editMain
end

UINAdjEditorSetBg.UpdateUINAdjEditorSetBg = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._bgIdItemDic = {}
  self._bgList = {}
  for k,bgCfg in pairs(ConfigData.background) do
    if not bgCfg.background_locked then
      (table.insert)(self._bgList, bgCfg)
    end
  end
  ;
  (table.sort)(self._bgList, function(a, b)
    -- function num : 0_2_0
    if a.order >= b.order then
      do return a.order == b.order end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).bgList).totalCount = #self._bgList
  ;
  ((self.ui).bgList):RefillCells()
  self:__RefreshConfirmState()
end

UINAdjEditorSetBg.__OnInstantiateItem = function(self, go)
  -- function num : 0_3 , upvalues : UINAdjEditorSetBgItem
  local bgItem = (UINAdjEditorSetBgItem.New)()
  bgItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._bgGoItemDic)[go] = bgItem
end

UINAdjEditorSetBg.__OnChangeItem = function(self, go, index)
  -- function num : 0_4
  local bgItem = (self._bgGoItemDic)[go]
  local oriBgId = bgItem:GetAdjBgItemId()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  if oriBgId ~= nil and (self._bgIdItemDic)[oriBgId] == bgItem then
    (self._bgIdItemDic)[oriBgId] = nil
  end
  local bgCfg = (self._bgList)[index + 1]
  bgItem:InitAdjBgItem(bgCfg, self._resloader, self.__OnSelectBgCallback)
  bgItem:SetAdjBgSelectState(bgCfg.id == (self._editMain):GetAdjEditBgId())
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._bgIdItemDic)[bgCfg.id] = bgItem
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINAdjEditorSetBg.__OnReturnItem = function(self, go)
  -- function num : 0_5
  local bgItem = (self._bgGoItemDic)[go]
  local bgId = bgItem:GetAdjBgItemId()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  if bgId ~= nil then
    (self._bgIdItemDic)[bgId] = nil
  end
end

UINAdjEditorSetBg.__OnSelectBg = function(self, bgId)
  -- function num : 0_6
  local oriBgId = (self._editMain):GetAdjEditBgId()
  if bgId == oriBgId then
    return 
  end
  local oriBgItem = (self._bgIdItemDic)[(self._editMain):GetAdjEditBgId()]
  if oriBgItem ~= nil then
    oriBgItem:SetAdjBgSelectState(false)
  end
  local bgItem = (self._bgIdItemDic)[bgId]
  if bgItem ~= nil then
    bgItem:SetAdjBgSelectState(true)
  end
  ;
  (self._editMain):SetAdjEditBg(bgId)
  self:__RefreshConfirmState()
end

UINAdjEditorSetBg.__RefreshConfirmState = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local selectBgId = (self._editMain):GetAdjEditBgId()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  if PlayerDataCenter:GetItemCount((self._editMain):GetAdjEditBgId()) > 0 then
    ((self.ui).img_confirm).color = self._defaultConfirmColor
  else
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_confirm).color = Color.gray
  end
end

UINAdjEditorSetBg.OnClickConfirm = function(self)
  -- function num : 0_8 , upvalues : _ENV, CS_MessageCommon
  if PlayerDataCenter:GetItemCount((self._editMain):GetAdjEditBgId()) == 0 then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(407))
    return 
  end
  ;
  (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).Operation)
end

UINAdjEditorSetBg.__OnListenItemUpdate = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self._bgIdItemDic == nil then
    return 
  end
  for k,item in pairs(self._bgIdItemDic) do
    item:RefreshAdjBgLockState()
  end
  self:__RefreshConfirmState()
end

UINAdjEditorSetBg.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnListenItemUpdateCallback)
  ;
  (base.OnDelete)(self)
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
end

return UINAdjEditorSetBg

