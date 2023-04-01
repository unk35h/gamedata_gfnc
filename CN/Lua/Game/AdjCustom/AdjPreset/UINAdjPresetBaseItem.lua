-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjPresetBaseItem = class("UINAdjPresetBaseItem", UIBaseNode)
local base = UIBaseNode
local CS_MessageCommon = CS.MessageCommon
local ALPHA_BUTTOM_LOCK = 0.3921568627451
UINAdjPresetBaseItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickEdit)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChangeName, self, self.OnClicName)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Del, self, self.OnClickDel)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self.OnClickSelect)
  self._defaultName = ((self.ui).tex_PresetName).text
  self._defaultSelectTxt = ((self.ui).text_empty).text
  self.__OnChangeNameCallback = BindCallback(self, self.__OnChangeName)
  ;
  ((self.ui).text_Select):SetIndex(0)
end

UINAdjPresetBaseItem.InitAdjPresetItem = function(self, teamId, resloader, selectFunc, clickEditFunc)
  -- function num : 0_1
  self._teamId = teamId
  self._resloader = resloader
  self._selectFunc = selectFunc
  self._clickEditFunc = clickEditFunc
  self._unlock = false
  self:__RefreshFixContent()
  self:RefreshAdjPresetItem()
  self:RefreshAdjLockState(true)
end

UINAdjPresetBaseItem.RefreshAdjPresetItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._data = (PlayerDataCenter.allAdjCustomData):GetAdjCustomPresetData(self._teamId)
  local hasData = self._data ~= nil
  ;
  ((self.ui).empty):SetActive(not hasData)
  ;
  ((self.ui).have):SetActive(hasData)
  ;
  (((self.ui).btn_Select).gameObject):SetActive(hasData)
  if hasData then
    self:__RefreshAdjPresetBg()
    self:__RefreshAdjPresetHero()
  end
  self:RefreshAdjPresetItemName()
  ;
  (((self.ui).btn_Del).gameObject):SetActive((PlayerDataCenter.allAdjCustomData):HasAdjPresetCount() > 1)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINAdjPresetBaseItem.RefreshAdjLockState = function(self, isForce)
  -- function num : 0_3 , upvalues : _ENV, ALPHA_BUTTOM_LOCK
  if self._unlock and not isForce then
    return 
  end
  local lock = (PlayerDataCenter.allAdjCustomData):IsAdjPresetUnlock(self._teamId)
  if lock == self._unlock and not isForce then
    return 
  end
  self._unlock = lock
  ;
  (((self.ui).btn_ChangeName).gameObject):SetActive(self._unlock)
  ;
  (((self.ui).tex_PresetName).gameObject):SetActive(self._unlock)
  ;
  ((self.ui).lock):SetActive(not self._unlock)
  ;
  (((self.ui).image_select).gameObject):SetActive(self._unlock)
  local color = ((self.ui).buttom_empty).color
  color.a = self._unlock and 1 or ALPHA_BUTTOM_LOCK
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).buttom_empty).color = color
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R4 in 'UnsetPending'

  if not self._unlock or not Color.white then
    ((self.ui).text_empty).color = Color.black
    -- DECOMPILER ERROR at PC74: Confused about usage of register: R4 in 'UnsetPending'

    if self._unlock then
      ((self.ui).text_empty).text = self._defaultSelectTxt
    else
      local cfg = (ConfigData.main_interface)[self._teamId]
      -- DECOMPILER ERROR at PC90: Confused about usage of register: R5 in 'UnsetPending'

      if cfg ~= nil then
        ((self.ui).text_empty).text = (CheckCondition.GetUnlockInfoLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
      end
    end
  end
end

UINAdjPresetBaseItem.__RefreshAdjPresetHero = function(self)
  -- function num : 0_4
end

UINAdjPresetBaseItem.__RefreshFixContent = function(self)
  -- function num : 0_5
  ((self.ui).img_Index):SetIndex(self._teamId - 1)
  ;
  ((self.ui).curSelect):SetActive(false)
end

UINAdjPresetBaseItem.__RefreshAdjPresetBg = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._data == nil then
    return 
  end
  local bgId = (self._data):GetAdjPresetBgId()
  if bgId == nil then
    return 
  end
  local bgCfg = (ConfigData.background)[bgId]
  if bgCfg == nil then
    return 
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_BgName).text = (LanguageUtil.GetLocaleText)(bgCfg.name)
  local bgPath = PathConsts:GetMainSceneBgPath(bgCfg.src_id_pic_day)
  ;
  (((self.ui).img_Bg).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(bgPath, function(texture)
    -- function num : 0_6_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      (((self.ui).img_Bg).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_Bg).texture = texture
    end
  end
)
end

UINAdjPresetBaseItem.RefreshAdjPresetItemName = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local teamName = nil
  if self._data ~= nil then
    teamName = (self._data):GetAdjPresetName()
  end
  if (string.IsNullOrEmpty)(teamName) then
    teamName = self._defaultName .. tostring(self._teamId)
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_PresetName).text = teamName
end

UINAdjPresetBaseItem.OnClickSelect = function(self)
  -- function num : 0_8 , upvalues : _ENV, CS_MessageCommon
  if not (PlayerDataCenter.allAdjCustomData):IsAdjPresetUnlock(self._teamId) then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(404))
    return 
  end
  if self._data == nil then
    if self._clickEditFunc ~= nil then
      (self._clickEditFunc)(self._teamId, 1)
    end
    return 
  end
  if self._selectFunc ~= nil then
    (self._selectFunc)(self._teamId)
  end
end

UINAdjPresetBaseItem.OnClicName = function(self)
  -- function num : 0_9 , upvalues : _ENV, CS_MessageCommon
  if not (PlayerDataCenter.allAdjCustomData):IsAdjPresetUnlock(self._teamId) then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(404))
    return 
  end
  if self._data == nil then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(403))
    return 
  end
  if CloseCustomBename then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(393))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.AdjPresetNameChange, function(window)
    -- function num : 0_9_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitAdjPresetNameChange(((self.ui).tex_PresetName).text, self.__OnChangeNameCallback)
  end
)
end

UINAdjPresetBaseItem.__OnChangeName = function(self, nameStr)
  -- function num : 0_10 , upvalues : _ENV
  local network = NetworkManager:GetNetwork(NetworkTypeID.AdjCustom)
  network:CS_MainInterface_PresetRename(self._teamId, nameStr, function()
    -- function num : 0_10_0 , upvalues : self
    self:RefreshAdjPresetItemName()
  end
)
end

UINAdjPresetBaseItem.OnClickEdit = function(self)
  -- function num : 0_11 , upvalues : _ENV, CS_MessageCommon
  if not (PlayerDataCenter.allAdjCustomData):IsAdjPresetUnlock(self._teamId) then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(404))
    return 
  end
  if self._clickEditFunc ~= nil then
    (self._clickEditFunc)(self._teamId, 1)
  end
end

UINAdjPresetBaseItem.OnClickDel = function(self)
  -- function num : 0_12 , upvalues : _ENV, CS_MessageCommon
  if (PlayerDataCenter.allAdjCustomData):HasAdjPresetCount() <= 1 then
    return 
  end
  if (PlayerDataCenter.allAdjCustomData):GetUsingAdjCustomPresetId() == self._teamId then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(408))
    return 
  end
  if self._data == nil or not (PlayerDataCenter.allAdjCustomData):IsAdjPresetUnlock(self._teamId) then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.AdjCustom)
  network:CS_MainInterface_PresetDel(self._teamId)
end

UINAdjPresetBaseItem.SetSelectAdjPresetItemState = function(self, flag)
  -- function num : 0_13
  ((self.ui).curSelect):SetActive(flag)
  ;
  ((self.ui).text_Select):SetIndex(flag and 1 or 0)
  local color = ((self.ui).img_Select).color
  color.a = flag and 0.2 or 1
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Select).color = color
end

UINAdjPresetBaseItem.GetAdjPresetItemTeamId = function(self)
  -- function num : 0_14
  return self._teamId
end

return UINAdjPresetBaseItem

