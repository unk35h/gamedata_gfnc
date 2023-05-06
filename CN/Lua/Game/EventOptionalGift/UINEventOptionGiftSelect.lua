-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventOptionGiftSelect = class("UINEventOptionGiftSelect", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINCmUseGiftItem = require("Game.CommonUI.UseGift.UINCmUseGiftItem")
local cs_MessageCommon = CS.MessageCommon
UINEventOptionGiftSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCmUseGiftItem, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfitm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Hide)
  self.__OnSelectItemCallback = BindCallback(self, self.__OnSelectItem)
  self._waitSelectItemPool = (UIItemPool.New)(UINCmUseGiftItem, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self._showSelectItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount_1)
  ;
  ((self.ui).uINBaseItemWithCount_1):SetActive(false)
  self._selectMarkList = {}
  ;
  (table.insert)(self._selectMarkList, (self.ui).img_Selected)
  self._emptyList = {}
  ;
  (table.insert)(self._emptyList, (self.ui).empty)
end

UINEventOptionGiftSelect.InitEventOptionGiftSelect = function(self, payGiftInfo, confirmFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._payGiftInfo = payGiftInfo
  self._confirmFunc = confirmFunc
  self._itemNodeDic = {}
  self._itemCountDic = {}
  self._selectItemList = {}
  self._customCfg = (self._payGiftInfo):GetSelectGiftCustomCfg()
  ;
  (self._waitSelectItemPool):HideAll()
  for i,itemId in ipairs((self._customCfg).param1) do
    local itemCfg = (ConfigData.item)[itemId]
    local itemCount = ((self._customCfg).param2)[i]
    local item = (self._waitSelectItemPool):GetOne()
    item:InitCmUseGiftItem(itemCfg, itemCount, self.__OnSelectItemCallback)
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._itemNodeDic)[itemId] = item
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._itemCountDic)[itemId] = itemCount
  end
  self:__RefreshSelectState()
end

UINEventOptionGiftSelect.__OnSelectItem = function(self, itemCfg)
  -- function num : 0_2 , upvalues : _ENV
  if (table.contain)(self._selectItemList, itemCfg.id) then
    (table.removebyvalue)(self._selectItemList, itemCfg.id)
    self:__RefreshSelectState()
    return 
  end
  if (self._payGiftInfo):GetSelectGiftCustomCount() <= #self._selectItemList then
    return 
  end
  ;
  (table.insert)(self._selectItemList, itemCfg.id)
  self:__RefreshSelectState()
end

UINEventOptionGiftSelect.__RefreshSelectState = function(self)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).tex_Tip):SetIndex(0, tostring((self._payGiftInfo):GetSelectGiftCustomCount()), tostring(#self._selectItemList))
  for i,go in ipairs(self._selectMarkList) do
    local itemId = (self._selectItemList)[i]
    go:SetActive(itemId ~= nil)
    if itemId ~= nil then
      local itemNode = (self._itemNodeDic)[itemId]
      ;
      (go.transform):SetParent(itemNode.transform)
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (go.transform).localPosition = Vector3.zero
      go:SetActive(true)
    end
  end
  for i = #self._selectMarkList + 1, #self._selectItemList do
    local go = ((self.ui).img_Selected):Instantiate()
    local itemId = (self._selectItemList)[i]
    local itemNode = (self._itemNodeDic)[itemId]
    ;
    (go.transform):SetParent(itemNode.transform)
    -- DECOMPILER ERROR at PC65: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (go.transform).localPosition = Vector3.zero
    go:SetActive(true)
    ;
    (table.insert)(self._selectMarkList, go)
  end
  ;
  (self._showSelectItemPool):HideAll()
  for i,itemId in ipairs(self._selectItemList) do
    local item = (self._showSelectItemPool):GetOne()
    local itemCount = (self._itemCountDic)[itemId]
    local itemCfg = (ConfigData.item)[itemId]
    item:InitItemWithCount(itemCfg, itemCount)
  end
  local remainCount = (self._payGiftInfo):GetSelectGiftCustomCount() - #self._selectItemList
  for i,go in ipairs(self._emptyList) do
    local flag = i <= remainCount
    go:SetActive(flag)
    if flag then
      (go.transform):SetAsLastSibling()
    end
  end
  for i = #self._emptyList + 1, remainCount do
    local go = ((self.ui).empty):Instantiate((((self.ui).empty).transform).parent)
    go:SetActive(true)
    ;
    (table.insert)(self._emptyList, go)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINEventOptionGiftSelect.OnClickConfitm = function(self)
  -- function num : 0_4 , upvalues : cs_MessageCommon, _ENV
  if #self._selectItemList ~= (self._payGiftInfo):GetSelectGiftCustomCount() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(424))
    return 
  end
  do
    if self._confirmFunc ~= nil then
      local selectItemNums = {}
      for i,itemId in ipairs(self._selectItemList) do
        (table.insert)(selectItemNums, (self._itemCountDic)[itemId])
      end
      ;
      (self._confirmFunc)(self._payGiftInfo, self._selectItemList, selectItemNums)
    end
    self:Hide()
  end
end

return UINEventOptionGiftSelect

