-- params : ...
-- function num : 0 , upvalues : _ENV
local UISettingDisplayPanel = class("UISettingDisplayPanel", UIBaseNode)
local UIMultiSwitchTogItem = require("Game.Setting.UI.UIMultiSwitchTogItem")
local UISingleSwitchTogItem = require("Game.Setting.UI.UISingleSwitchTogItem")
UISettingDisplayPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).multiTogItem):SetActive(false)
  self.multiSwitchToggleItemList = {}
  self.singleSwitchToggleItemList = {}
  self.warningTextItemList = {}
  self.NeedSet = true
end

UISettingDisplayPanel.InitDisplayPanel = function(self, ctrl)
  -- function num : 0_1 , upvalues : _ENV, UIMultiSwitchTogItem
  self.ctrl = ctrl
  self.multiSwitchToggleItemList = {}
  self.warningTextItemList = {}
  self.NeedSet = true
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Warning).text = ConfigData:GetTipContent(8004)
  local systemSaveData = (self.ctrl):GetSystemSaveData()
  local RecommendPerformanceLevel = (GameSystemInfo.GetDefaultPerformance)()
  local currentPerformanceLevelCallback = BindCallback(self.ctrl, (self.ctrl).GetPerformanceLevel)
  local performanceLevelCallback = BindCallback(self, self.OnPerformanceLevelChanged)
  local performanceLevelName = (ConfigData:GetPerformanceTypeinfoByName("mode")).option_group_name
  self.screenSettingmultiSwitchTogItem = (UIMultiSwitchTogItem.New)()
  ;
  (self.screenSettingmultiSwitchTogItem):Init((self.ui).screenSettingList)
  ;
  (self.screenSettingmultiSwitchTogItem):InitUIMultiSwitchPerformanceLevelTogItem(currentPerformanceLevelCallback, performanceLevelName, RecommendPerformanceLevel, performanceLevelCallback, self)
  self.customToggle = (((self.screenSettingmultiSwitchTogItem).ui).togItemList)[#((self.screenSettingmultiSwitchTogItem).ui).togItemList]
  ;
  (UIUtil.AddValueChangedListener)(((self.customToggle).ui).togItem, self, self.OnCustomTogChanged)
  if (self.ctrl):GetPerformanceLevel() == 0 then
    self:SetPerformanceLevelCustom()
  end
  local currentResolutionCallback = BindCallback(systemSaveData, systemSaveData.GetDisplaySettingValue, "resolution")
  local resolutionCallback = BindCallback(self, self.OnResolutionChanged)
  local resolutionOptionName = (ConfigData:GetPerformanceTypeinfoByName("resolution")).option_group_name
  self:InitMultiDisplayItem(currentResolutionCallback, resolutionOptionName, (self.ui).resolutionItem, resolutionCallback, true)
  local currentTextureLimitCallback = BindCallback(systemSaveData, systemSaveData.GetDisplaySettingValue, "texture_limit")
  local textureLimitCallback = BindCallback(self, self.OnTextureLimitChanged)
  local textureLimitOptionName = (ConfigData:GetPerformanceTypeinfoByName("texture_limit")).option_group_name
  self:InitMultiDisplayItem(currentTextureLimitCallback, textureLimitOptionName, (self.ui).textureLimitItem, textureLimitCallback, true)
  local currentEffectQualityCallback = BindCallback(systemSaveData, systemSaveData.GetDisplaySettingValue, "effect_quality")
  local effectQualityCallback = BindCallback(self, self.OnEffectQualityChanged)
  local effectQualityOptionName = (ConfigData:GetPerformanceTypeinfoByName("effect_quality")).option_group_name
  self:InitMultiDisplayItem(currentEffectQualityCallback, effectQualityOptionName, (self.ui).effectQualityItem, effectQualityCallback)
  local currentModelQualityCallback = BindCallback(systemSaveData, systemSaveData.GetDisplaySettingValue, "model_quality")
  local modelQualityCallback = BindCallback(self, self.OnModelQualityChanged)
  local modelQualityOptionName = (ConfigData:GetPerformanceTypeinfoByName("model_quality")).option_group_name
  self:InitMultiDisplayItem(currentModelQualityCallback, modelQualityOptionName, (self.ui).modelQualityItem, modelQualityCallback)
  local currentPostEffectCallback = BindCallback(systemSaveData, systemSaveData.GetDisplaySettingValue, "post_effect")
  local postEffectCallback = BindCallback(self, self.OnPostEffectChanged)
  local postEffectOptionName = (ConfigData:GetPerformanceTypeinfoByName("post_effect")).option_group_name
  self:InitMultiDisplayItem(currentPostEffectCallback, postEffectOptionName, (self.ui).postEffectItem, postEffectCallback)
  local currentMaxFpsCallback = BindCallback(systemSaveData, systemSaveData.GetDisplaySettingValue, "frame_rate")
  local maxFpsCallback = BindCallback(self, self.OnMaxFpsChanged)
  local frameConfigName = (GameSystemInfo.IsMuMuSimulator)() and "mumu_frame_rate" or "frame_rate"
  local maxFpsOptionPerformanceTypeinfo = ConfigData:GetPerformanceTypeinfoByName(frameConfigName)
  local maxFpsOptionName = maxFpsOptionPerformanceTypeinfo.option_group_name
  local maxFpsNeedWarning = maxFpsOptionPerformanceTypeinfo.warning
  if maxFpsNeedWarning then
    self:InitDisWarningItem(currentMaxFpsCallback, maxFpsOptionName, (self.ui).t_MaxFps)
  end
  self:InitMultiDisplayItem(currentMaxFpsCallback, maxFpsOptionName, (self.ui).maxFpsItem, maxFpsCallback, false)
  self.singleSwitchToggleItemList = {}
  local singleDisplayItemNameList = {ConfigData:GetTipContent(8002), ConfigData:GetTipContent(8001)}
  local currnetDynShadowCallback = BindCallback(self, self.IsOnPerformanceTypeinfoByName, "dyn_shadow")
  self:InitSingleDisplayItem((self.ui).tog_Shadow, currnetDynShadowCallback, singleDisplayItemNameList, self.OnDynShadowChanged)
  local currnetAntiAliasingCallback = BindCallback(self, self.IsOnPerformanceTypeinfoByName, "anti_aliasing")
  local antiAliasingNeedWarning = (ConfigData:GetPerformanceTypeinfoByName("anti_aliasing")).warning
  if antiAliasingNeedWarning then
    self:InitDisWarningItem(currnetAntiAliasingCallback, ((self.ui).tog_aa).name, (self.ui).t_AntiAliasing)
  end
  self:InitSingleDisplayItem((self.ui).tog_aa, currnetAntiAliasingCallback, singleDisplayItemNameList, self.OnAntiAliasingChanged)
  local currnetOutlineCallback = BindCallback(self, self.IsOnPerformanceTypeinfoByName, "outline")
  self:InitSingleDisplayItem((self.ui).tog_Outline, currnetOutlineCallback, singleDisplayItemNameList, self.OnOutlineChanged)
  local currnetOpenLittleManCallback = BindCallback(self, self.IsOnPerformanceTypeinfoByName, "open_little_man")
  self:InitSingleDisplayItem((self.ui).tog_OpenLittleMan, currnetOpenLittleManCallback, singleDisplayItemNameList, self.OnOpenLittleManChanged)
  local currnetOpenWeatherCallback = BindCallback(self, self.IsOnPerformanceTypeinfoByName, "open_weather")
  self:InitSingleDisplayItem((self.ui).tog_OpenWeather, currnetOpenWeatherCallback, singleDisplayItemNameList, self.OnOpenWeatherChanged)
end

UISettingDisplayPanel.InitMultiDisplayItem = function(self, curValue, strList, togGroup, bindEvent, isReverse)
  -- function num : 0_2 , upvalues : UIMultiSwitchTogItem, _ENV
  local itemGo = ((self.ui).multiTogItem):Instantiate(togGroup.transform)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (itemGo.transform).anchoredPosition3D = (self.ui).offset_tog
  itemGo:SetActive(true)
  local multiSwitchTogItem = (UIMultiSwitchTogItem.New)()
  multiSwitchTogItem:Init(itemGo)
  multiSwitchTogItem:InitUIMultiSwitchTogItem(curValue, strList, isReverse, bindEvent, self)
  ;
  (((CS.UnityEngine).Canvas).ForceUpdateCanvases)()
  ;
  (table.insert)(self.multiSwitchToggleItemList, multiSwitchTogItem)
end

UISettingDisplayPanel.InitDisWarningItem = function(self, curValue, strList, parent)
  -- function num : 0_3 , upvalues : _ENV
  local warningText = (((self.ui).tex_Warning).gameObject):Instantiate(parent)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (warningText.transform).anchoredPosition = (Vector2.Temp)(20, 0)
  local v = curValue()
  warningText:SetActive(v or v == 1)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.warningTextItemList)[strList] = warningText
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UISettingDisplayPanel.InitSingleDisplayItem = function(self, obj, isOFFEvent, nameList, event)
  -- function num : 0_4 , upvalues : UISingleSwitchTogItem, _ENV
  local singleSwitchTogItem = (UISingleSwitchTogItem.New)()
  singleSwitchTogItem:Init(obj)
  singleSwitchTogItem:InitSingleSwitchTogItem(isOFFEvent, nameList, event, self)
  ;
  (((CS.UnityEngine).Canvas).ForceUpdateCanvases)()
  ;
  (table.insert)(self.singleSwitchToggleItemList, singleSwitchTogItem)
end

UISettingDisplayPanel.OnPerformanceLevelChanged = function(self, value, togItem)
  -- function num : 0_5
  self.NeedSet = false
  if value then
    (self.ctrl):SetPerformanceLevel(togItem.index)
    self:SetPerformanceLevelToggle()
  end
  self.NeedSet = true
end

UISettingDisplayPanel.OnCustomTogChanged = function(self)
  -- function num : 0_6
  (self.ctrl):SetPerformanceLevel(0)
end

UISettingDisplayPanel.SetPerformanceLevelToggle = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for index,multiSwitchTogItem in ipairs(self.multiSwitchToggleItemList) do
    multiSwitchTogItem:SelectCurrentValue()
  end
  for index,singleSwitchTogItem in ipairs(self.singleSwitchToggleItemList) do
    singleSwitchTogItem:SelectCurrentValue()
  end
end

UISettingDisplayPanel.SetPerformanceLevelCustom = function(self)
  -- function num : 0_8
  if self.NeedSet then
    (self.ctrl):SetPerformanceLevel(0)
    ;
    (((self.screenSettingmultiSwitchTogItem).ui).toggleGroup):SetAllTogglesOff()
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.customToggle).ui).togItem).isOn = true
    ;
    (((self.customToggle).ui).togItem):Select()
  end
end

UISettingDisplayPanel.OnResolutionChanged = function(self, value, togItem)
  -- function num : 0_9
  if value then
    self:SetPerformanceLevelCustom()
    ;
    (self.ctrl):SetResolutionIndex(togItem.index)
  end
end

UISettingDisplayPanel.OnTextureLimitChanged = function(self, value, togItem)
  -- function num : 0_10
  if value then
    self:SetPerformanceLevelCustom()
    ;
    (self.ctrl):SetTextureLimit(togItem.index)
  end
end

UISettingDisplayPanel.OnEffectQualityChanged = function(self, value, togItem)
  -- function num : 0_11
  if value then
    self:SetPerformanceLevelCustom()
    ;
    (self.ctrl):SetEffectQuality(togItem.index)
  end
end

UISettingDisplayPanel.OnModelQualityChanged = function(self, value, togItem)
  -- function num : 0_12
  if value then
    self:SetPerformanceLevelCustom()
    ;
    (self.ctrl):SetModelQuality(togItem.index)
  end
end

UISettingDisplayPanel.OnPostEffectChanged = function(self, value, togItem)
  -- function num : 0_13
  if value then
    self:SetPerformanceLevelCustom()
    ;
    (self.ctrl):SetPostEffect(togItem.index)
  end
end

UISettingDisplayPanel.OnMaxFpsChanged = function(self, value, togItem)
  -- function num : 0_14 , upvalues : _ENV
  if value then
    self:SetPerformanceLevelCustom()
    ;
    (self.ctrl):SetFrameRateIndex(togItem.index)
    local maxFpsOptionPerformanceTypeinfo = ConfigData:GetPerformanceTypeinfoByName("frame_rate")
    local maxFpsOptionName = maxFpsOptionPerformanceTypeinfo.option_group_name
    if togItem.index == 0 then
      do
        ((self.warningTextItemList)[maxFpsOptionName]):SetActive((self.warningTextItemList)[maxFpsOptionName] == nil)
        -- DECOMPILER ERROR: 2 unprocessed JMP targets
      end
    end
  end
end

UISettingDisplayPanel.IsOnPerformanceTypeinfoByName = function(self, name)
  -- function num : 0_15
  local systemSaveData = (self.ctrl):GetSystemSaveData()
  do return systemSaveData:GetDisplaySettingValue(name) == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UISettingDisplayPanel.OnDynShadowChanged = function(self, value)
  -- function num : 0_16
  self:SetPerformanceLevelCustom()
  ;
  (self.ctrl):SetDynShadowIndex(value == true and 1 or 0)
end

UISettingDisplayPanel.OnAntiAliasingChanged = function(self, value)
  -- function num : 0_17
  self:SetPerformanceLevelCustom()
  ;
  (self.ctrl):SetAntiAliasingIndex(value == true and 1 or 0)
  if (self.ui).tog_aa ~= nil and (self.warningTextItemList)[((self.ui).tog_aa).name] ~= nil then
    ((self.warningTextItemList)[((self.ui).tog_aa).name]):SetActive(value)
  end
end

UISettingDisplayPanel.OnOutlineChanged = function(self, value)
  -- function num : 0_18
  self:SetPerformanceLevelCustom()
  ;
  (self.ctrl):SetOutlineIndex(value == true and 1 or 0)
end

UISettingDisplayPanel.OnOpenLittleManChanged = function(self, value)
  -- function num : 0_19
  self:SetPerformanceLevelCustom()
  ;
  (self.ctrl):SetOpenLittleManIndex(value == true and 1 or 0)
end

UISettingDisplayPanel.OnOpenWeatherChanged = function(self, value)
  -- function num : 0_20
  self:SetPerformanceLevelCustom()
  ;
  (self.ctrl):SetOpenWeatherIndex(value == true and 1 or 0)
end

return UISettingDisplayPanel

