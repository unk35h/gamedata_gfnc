-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmRoomEdit = class("UINDmRoomEdit", UIBaseNode)
local base = UIBaseNode
local UINDmFntCategoryTog = require("Game.Dorm.DUI.Room.Edit.UINDmFntCategoryTog")
local UINDmRoomFntList = require("Game.Dorm.DUI.Room.Edit.UINDmRoomFntList")
local UINDmRoomFntOperate = require("Game.Dorm.DUI.Room.Edit.UINDmRoomFntOperate")
local UINDmFntThemeList = require("Game.Dorm.DUI.Room.Edit.Theme.UINDmFntThemeList")
local DormEnum = require("Game.Dorm.DormEnum")
local DormUtil = require("Game.Dorm.DormUtil")
local CS_MessageCommon = CS.MessageCommon
UINDmRoomEdit.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDmRoomFntList, UINDmRoomFntOperate, UINDmFntCategoryTog, DormEnum
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnConfirmClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PackUp, self, self._OnClearClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReSet, self, self._OnRestoreClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sort, self, self._OnSortClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BackTheme, self, self._OnBackThemeClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_QuickSet, self, self._OnQuickSetThemeClicked)
  self.dmRoomFntList = (UINDmRoomFntList.New)()
  ;
  (self.dmRoomFntList):Init((self.ui).fntList)
  self.dmRoomFntOp = (UINDmRoomFntOperate.New)()
  ;
  (self.dmRoomFntOp):Init((self.ui).fntOperate)
  self._onClickFntItemFunc = BindCallback(self, self._OnClickFntItem)
  self._OnSelectFntCategoryFunc = BindCallback(self, self._OnSelectFntCategory)
  self._onDormRoomEditDataChange = BindCallback(self, self._DormRoomEditDataChange)
  self._resLoader = ((CS.ResLoader).Create)()
  local iconPath = PathConsts:GetSpriteAtlasPath("UI_DormRoom")
  self._togIconAtlas = (self._resLoader):LoadABAsset(iconPath)
  ;
  ((self.ui).fntCatgTog):SetActive(false)
  self.fntCategoryTogList = (UIItemPool.New)(UINDmFntCategoryTog, (self.ui).fntCatgTog)
  self.catTogItemDic = {}
  for k,catgId in ipairs((ConfigData.dorm_fnt_category).dmFntCategoryIdList) do
    local cfg = (ConfigData.dorm_fnt_category)[catgId]
    local togItem = (self.fntCategoryTogList):GetOne()
    local sprite = (AtlasUtil.GetResldSprite)(self._togIconAtlas, cfg.icon)
    togItem:InitDmFntCategoryTog(cfg, sprite, self._OnSelectFntCategoryFunc)
    -- DECOMPILER ERROR at PC129: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.catTogItemDic)[catgId] = togItem
    if DormEnum.ThemeCatId == catgId then
      togItem:Hide()
    end
  end
  self._dmRoomFntOpShow_InWall = true
  ;
  ((self.ui).fntThemeBack):SetActive(false)
end

UINDmRoomEdit.InitDmRoomtEdit = function(self, dmRoomCtrl)
  -- function num : 0_1 , upvalues : _ENV, DormEnum
  self.dmRoomCtrl = dmRoomCtrl
  ;
  (UIUtil.SetTopStatus)(self, self._OnCancelClicked, nil, DormEnum.ShowRoomInfoFunc)
  self.fntWarehouseCatgList = ((self.dmRoomCtrl).editRoomData):GetFntWarehouseCatgList()
  local themeCatItem = (self.catTogItemDic)[DormEnum.ThemeCatId]
  if themeCatItem ~= nil and ((self.dmRoomCtrl).editRoomData):IsHasAnyDmtThemeFnt() then
    themeCatItem:Show()
  end
  self._selCatgId = nil
  self:DmRoomEditSelectFntMode(false)
  ;
  ((self.ui).fntCatgTogGroup):SetAllTogglesOff()
  for k,togItem in ipairs((self.fntCategoryTogList).listItem) do
    if (togItem.gameObject).activeInHierarchy then
      togItem:SetDmFntCategoryTogOn()
      break
    end
  end
  do
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).typeList).verticalNormalizedPosition = 1
  end
end

UINDmRoomEdit.ReinitDmRoomtEditData = function(self)
  -- function num : 0_2
  self.fntWarehouseCatgList = ((self.dmRoomCtrl).editRoomData):GetFntWarehouseCatgList()
  local themeCfg = self._curThemeCfg
  self:_OnSelectFntCategory(self._selCatgId, true)
  if themeCfg ~= nil then
    self:ShowDmRoomEditThemeFntList(themeCfg)
  end
end

UINDmRoomEdit.DmRoomEditSelectFntMode = function(self, isEnter)
  -- function num : 0_3
  if isEnter then
    self:DmRoomEditOperateShow(true)
    ;
    ((self.ui).listRoot):SetActive(false)
  else
    self:DmRoomEditOperateShow(false)
    ;
    ((self.ui).listRoot):SetActive(true)
    self:TryRefreshDmRoomEditList()
  end
end

UINDmRoomEdit.DmRoomEditOperateShow = function(self, isShow, inWallVisible)
  -- function num : 0_4
  if inWallVisible then
    self._dmRoomFntOpShow_InWall = isShow
  else
    self._dmRoomFntOpShow = isShow
  end
  if self._dmRoomFntOpShow_InWall and self._dmRoomFntOpShow then
    (self.dmRoomFntOp):Show()
  else
    ;
    (self.dmRoomFntOp):Hide()
  end
end

UINDmRoomEdit.TryRefreshDmRoomEditList = function(self)
  -- function num : 0_5
  if ((self.ui).listRoot).activeInHierarchy and self.waitDmRoomFntListRefresh then
    self:_RefreshDmRoomEditFntList()
    self.waitDmRoomFntListRefresh = false
  end
  if self._themeListNode ~= nil and ((self._themeListNode).gameObject).activeInHierarchy and self._waitDmRoomThemeListRefresh then
    (self._themeListNode):RefillDmRoomThemeList()
    self._waitDmRoomThemeListRefresh = false
  end
end

UINDmRoomEdit._RefreshDmRoomEditFntList = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not self._themefntWarehouseList and not (self.fntWarehouseCatgList)[self._selCatgId] then
    local fntWarehouseList = table.emptytable
  end
  self:__RefreshFntListUI(fntWarehouseList, false)
end

UINDmRoomEdit._UpdCategoryLimitNum = function(self)
  -- function num : 0_7 , upvalues : _ENV, DormUtil
  local fntCatgCfg = (ConfigData.dorm_fnt_category)[self._selCatgId]
  local roomType = (((self.dmRoomCtrl).roomEntity).roomData):GetDmRoomType()
  local limitNum = (DormUtil.GetDmFntNumLimit)(roomType, fntCatgCfg)
  if limitNum == 0 then
    ((self.ui).obj_currFntCatg):SetActive(false)
  else
    ;
    ((self.ui).obj_currFntCatg):SetActive(true)
    local sprite = (AtlasUtil.GetResldSprite)(self._togIconAtlas, fntCatgCfg.icon)
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_CatgIcon).sprite = sprite
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_typeName).text = (LanguageUtil.GetLocaleText)(fntCatgCfg.name)
    local curNum = (((self.dmRoomCtrl).roomEntity).roomData):GetDmRoomFntCategoryNum(self._selCatgId)
    local maxNum = limitNum
    ;
    ((self.ui).tex_typeCount):SetIndex(0, tostring(curNum), tostring(maxNum))
    local isMax = maxNum <= curNum
    -- DECOMPILER ERROR at PC75: Confused about usage of register: R8 in 'UnsetPending'

    if not isMax or not ((self.ui).catgBgColor)[2] then
      ((self.ui).img_CurrFntCatg).color = ((self.ui).catgBgColor)[1]
      -- DECOMPILER ERROR at PC86: Confused about usage of register: R8 in 'UnsetPending'

      if not isMax or not Color.white then
        ((self.ui).img_CatgIcon).color = Color.black
        -- DECOMPILER ERROR at PC97: Confused about usage of register: R8 in 'UnsetPending'

        if not isMax or not Color.white then
          ((self.ui).tex_typeName).color = Color.black
          -- DECOMPILER ERROR at PC109: Confused about usage of register: R8 in 'UnsetPending'

          if not isMax or not Color.white then
            do
              (((self.ui).tex_typeCount).text).color = Color.black
              -- DECOMPILER ERROR: 10 unprocessed JMP targets
            end
          end
        end
      end
    end
  end
end

UINDmRoomEdit.ShowDmRoomEditThemeFntList = function(self, themeCfg)
  -- function num : 0_8 , upvalues : _ENV
  self._curThemeCfg = themeCfg
  local fntWarehouseList = {}
  for fntId,num in pairs(themeCfg.theme_furniture_id) do
    local fntWarehousedata = ((self.dmRoomCtrl).editRoomData):GetDmStorageFntData(fntId)
    if fntWarehousedata == nil then
      fntWarehousedata = ((self.dmRoomCtrl).editRoomData):NewDmStorateFnt(fntId, 0)
    end
    ;
    (table.insert)(fntWarehouseList, fntWarehousedata)
  end
  ;
  (self.dmRoomFntList):SetDmRoomFntListInTheme(themeCfg.theme_furniture_id)
  ;
  ((self.ui).fntThemeBack):SetActive(true)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ThemeName).text = (LanguageUtil.GetLocaleText)(themeCfg.theme_name)
  ;
  (((self.ui).btn_QuickSet).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R3 in 'UnsetPending'

  if not self:_IsCanQuickSetTheme() or not Color.white then
    (((self.ui).btn_QuickSet).targetGraphic).color = Color.gray
    self:__RefreshFntListUI(fntWarehouseList, true)
    self._themefntWarehouseList = fntWarehouseList
  end
end

UINDmRoomEdit._OnBackThemeClicked = function(self)
  -- function num : 0_9
  self:_ResetThemeFntList()
  ;
  (self.dmRoomFntList):Hide()
  ;
  (self._themeListNode):Show()
  self:TryRefreshDmRoomEditList()
end

UINDmRoomEdit._IsCanQuickSetTheme = function(self)
  -- function num : 0_10
  if not (((self.dmRoomCtrl).roomEntity).roomData):IsBigRoomType() and self._curThemeCfg and (self._curThemeCfg).only_big then
    return false
  end
  return true
end

UINDmRoomEdit._OnQuickSetThemeClicked = function(self)
  -- function num : 0_11 , upvalues : CS_MessageCommon, _ENV
  if self._curThemeCfg == nil then
    return 
  end
  if not self:_IsCanQuickSetTheme() then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2040))
    return 
  end
  local noneFnt = true
  local hasAllTheme = true
  for fntId,num in pairs((self._curThemeCfg).theme_furniture_id) do
    local storageFntData = ((self.dmRoomCtrl).editRoomData):GetDmStorageFntData(fntId)
    if storageFntData ~= nil and storageFntData.count > 0 then
      noneFnt = false
    end
    if storageFntData == nil or storageFntData.count < num then
      hasAllTheme = false
    end
  end
  do
    if (noneFnt == false and hasAllTheme == false) or noneFnt then
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2039))
      return 
    end
    if (string.IsNullOrEmpty)((self._curThemeCfg).theme_coord) then
      error((string.format)("dormThemeCfg.theme_coord is Null Or Empty, theme id:%s", (self._curThemeCfg).id))
      return 
    end
    local themeData = (table.String2Table)((self._curThemeCfg).theme_coord)
    ;
    (self.dmRoomCtrl):LoadDmRoomTheme(themeData)
    if not hasAllTheme then
      (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(2041))
    end
  end
end

UINDmRoomEdit._ShowThemeList = function(self)
  -- function num : 0_12 , upvalues : UINDmFntThemeList
  if self._themeListNode == nil then
    self._themeListNode = (UINDmFntThemeList.New)()
    ;
    (self._themeListNode):Init((self.ui).fntThemeList)
  end
  ;
  (self.dmRoomFntList):Hide()
  local inBigRoom = (((self.dmRoomCtrl).roomEntity).roomData):IsBigRoomType()
  ;
  (self._themeListNode):InitDmFntThemeList(inBigRoom, (self.dmRoomCtrl).editRoomData, self._resLoader, self)
  ;
  ((self.ui).fntEmpty):SetActive(false)
end

UINDmRoomEdit._ResetThemeFntList = function(self)
  -- function num : 0_13
  ((self.ui).fntThemeBack):SetActive(false)
  ;
  (((self.ui).btn_QuickSet).gameObject):SetActive(false)
  self._curThemeCfg = nil
  self._themefntWarehouseList = nil
  ;
  (self.dmRoomFntList):SetDmRoomFntListInTheme(nil)
end

UINDmRoomEdit._OnSelectFntCategory = function(self, catgId, isForce)
  -- function num : 0_14 , upvalues : DormEnum, _ENV
  if self._selCatgId == catgId and not isForce then
    return 
  end
  self._selCatgId = catgId
  self:_UpdCategoryLimitNum()
  self:_ResetThemeFntList()
  if catgId == DormEnum.ThemeCatId then
    self:_ShowThemeList()
    return 
  end
  if not (self.fntWarehouseCatgList)[catgId] then
    local fntWarehouseList = table.emptytable
  end
  self:__RefreshFntListUI(fntWarehouseList, true)
end

UINDmRoomEdit._OnClickFntItem = function(self, fntWarehouseData, fntItem)
  -- function num : 0_15 , upvalues : CS_MessageCommon, _ENV, DormUtil
  if not (((self.dmRoomCtrl).roomEntity).roomData):IsBigRoomType() and (fntWarehouseData.fntCfg).only_big then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2037))
    return 
  end
  if fntWarehouseData.count == 0 then
    return 
  end
  if not fntWarehouseData.isDefaultDmFnt then
    local catgId = (fntWarehouseData.fntCfg).category
    local fntCatgCfg = (ConfigData.dorm_fnt_category)[catgId]
    local roomType = (((self.dmRoomCtrl).roomEntity).roomData):GetDmRoomType()
    local limitNum = (DormUtil.GetDmFntNumLimit)(roomType, fntCatgCfg)
    if limitNum > 0 then
      local curNum = (((self.dmRoomCtrl).roomEntity).roomData):GetDmRoomFntCategoryNum(catgId)
      local maxNum = limitNum
      if maxNum <= curNum then
        local msg = (string.format)(ConfigData:GetTipContent(2027), (LanguageUtil.GetLocaleText)(fntCatgCfg.name))
        ;
        (CS_MessageCommon.ShowMessageTipsWithErrorSound)(msg)
        return 
      end
    end
  end
  do
    ;
    (self.dmRoomCtrl):InstallFnt(fntWarehouseData)
  end
end

UINDmRoomEdit._DormRoomEditDataChange = function(self, fntWarehouseDataDic)
  -- function num : 0_16 , upvalues : _ENV, DormEnum
  local newWarehouseDataDic = {}
  for fntWarehouseData,isNew in pairs(fntWarehouseDataDic) do
    local catgId = (fntWarehouseData.fntCfg).category
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R9 in 'UnsetPending'

    if isNew then
      if not (self.fntWarehouseCatgList)[catgId] then
        (self.fntWarehouseCatgList)[catgId] = {}
        do
          local catgList = (self.fntWarehouseCatgList)[catgId]
          ;
          (table.insert)(catgList, fntWarehouseData)
          if newWarehouseDataDic then
            newWarehouseDataDic[fntWarehouseData.id] = fntWarehouseData
          end
          -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC33: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  local refreshFntList = false
  if self._themefntWarehouseList ~= nil then
    for k,v in ipairs(self._themefntWarehouseList) do
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R9 in 'UnsetPending'

      if newWarehouseDataDic[v.id] ~= nil then
        (self._themefntWarehouseList)[k] = newWarehouseDataDic[v.id]
      end
    end
    refreshFntList = true
  end
  if self._selCatgId == DormEnum.ThemeCatId and self._themeListNode ~= nil then
    self._waitDmRoomThemeListRefresh = false
    if ((self._themeListNode).gameObject).activeInHierarchy then
      (self._themeListNode):RefillDmRoomThemeList(false)
    else
      self._waitDmRoomThemeListRefresh = true
    end
  else
    refreshFntList = true
  end
  if refreshFntList then
    (self.dmRoomFntList):RefreshDmRoomFntList()
    self.waitDmRoomFntListRefresh = false
    if ((self.ui).listRoot).activeInHierarchy then
      self:_RefreshDmRoomEditFntList()
    else
      self.waitDmRoomFntListRefresh = true
    end
  end
  self:_UpdCategoryLimitNum()
  -- DECOMPILER ERROR: 11 unprocessed JMP targets
end

UINDmRoomEdit._OnConfirmClicked = function(self)
  -- function num : 0_17
  (self.dmRoomCtrl):ConfirmDormRoomEdit()
end

UINDmRoomEdit._OnCancelClicked = function(self)
  -- function num : 0_18 , upvalues : CS_MessageCommon, _ENV
  if (self.dmRoomCtrl):HasDmRoomEdited() then
    (CS_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(2011), function()
    -- function num : 0_18_0 , upvalues : self
    self:_ExitEdit(false)
  end
, nil)
    return false
  else
    self:_ExitEdit(true)
  end
end

UINDmRoomEdit._ExitEdit = function(self, popStack)
  -- function num : 0_19
  (self.dmRoomCtrl):ExitDormRoomEdit(false, popStack)
end

UINDmRoomEdit._OnRestoreClicked = function(self)
  -- function num : 0_20 , upvalues : CS_MessageCommon, _ENV
  (CS_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(2010), function()
    -- function num : 0_20_0 , upvalues : self
    (self.dmRoomCtrl):RestoreDormRoomEdit()
  end
, nil)
end

UINDmRoomEdit._OnSortClicked = function(self)
  -- function num : 0_21
end

UINDmRoomEdit._OnClearClicked = function(self)
  -- function num : 0_22 , upvalues : CS_MessageCommon, _ENV
  (CS_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(2008), function()
    -- function num : 0_22_0 , upvalues : self
    (self.dmRoomCtrl):ClearAllFnt()
  end
, nil)
end

UINDmRoomEdit.OnShow = function(self)
  -- function num : 0_23 , upvalues : _ENV
  MsgCenter:AddListener(eMsgEventId.DormRoomEditDataChange, self._onDormRoomEditDataChange)
end

UINDmRoomEdit.OnHide = function(self)
  -- function num : 0_24 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.DormRoomEditDataChange, self._onDormRoomEditDataChange)
end

UINDmRoomEdit.__RefreshFntListUI = function(self, fntWarehouseList, refill)
  -- function num : 0_25
  local hasData = #fntWarehouseList > 0
  ;
  ((self.ui).fntEmpty):SetActive(not hasData)
  if self._themeListNode then
    (self._themeListNode):Hide()
  end
  if hasData then
    (self.dmRoomFntList):Show()
    ;
    (self.dmRoomFntList):InitDmRoomFntList(fntWarehouseList, self._onClickFntItemFunc, (((self.dmRoomCtrl).roomEntity).roomData):IsBigRoomType())
    ;
    (self.dmRoomFntList):RefreshDmRoomFntList()
    ;
    (self.dmRoomFntList):RefillDmRoomFntList(refill)
  else
    (self.dmRoomFntList):Hide()
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINDmRoomEdit.OnDelete = function(self)
  -- function num : 0_26 , upvalues : base
  (self.fntCategoryTogList):DeleteAll()
  ;
  (self.dmRoomFntList):Delete()
  ;
  (self.dmRoomFntOp):Delete()
  if self._themeListNode ~= nil then
    (self._themeListNode):Delete()
    self._themeListNode = nil
  end
  if self._resLoader ~= nil then
    (self._resLoader):Put2Pool()
    self._resLoader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINDmRoomEdit

