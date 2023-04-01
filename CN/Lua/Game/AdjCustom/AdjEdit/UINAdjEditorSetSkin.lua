-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorSetSkin = class("UINAdjEditorSetSkin", UIBaseNode)
local base = UIBaseNode
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
local UINAdjEditorSkinItem = require("Game.AdjCustom.AdjEdit.UINAdjEditorSkinItem")
local CS_ResLoader = CS.ResLoader
local CS_MessageCommon = CS.MessageCommon
UINAdjEditorSetSkin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAdjEditorSkinItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.OnClickCancle)
  self.__OnSelectAdjSkinCallback = BindCallback(self, self.__OnSelectAdjSkin)
  self._skinPool = (UIItemPool.New)(UINAdjEditorSkinItem, (self.ui).skinPreviewItem)
  ;
  ((self.ui).skinPreviewItem):SetActive(false)
  self._defaultConfirmColor = ((self.ui).img_confirm).color
  self.__RefreshSkinlockStateCallback = BindCallback(self, self.__RefreshSkinlockState)
  MsgCenter:AddListener(eMsgEventId.UpdateHeroSkin, self.__RefreshSkinlockStateCallback)
end

UINAdjEditorSetSkin.InitUINAdjEditorSetSkin = function(self, editMain)
  -- function num : 0_1
  self._editMain = editMain
end

UINAdjEditorSetSkin.GetAdjMainHeroId = function(self)
  -- function num : 0_2
  if self._editMain == nil then
    return 
  end
  return (self._editMain):GetAdjMainHeroId()
end

UINAdjEditorSetSkin.GetAdjMainSkinId = function(self)
  -- function num : 0_3
  if self._editMain == nil then
    return 
  end
  return (self._editMain):GetAdjMainSkinId()
end

UINAdjEditorSetSkin.SetUINAdjLastSubType = function(self, subType)
  -- function num : 0_4
  self._returnToHero = subType == ((self._editMain).subType).SetHero
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINAdjEditorSetSkin.IsActiveLive2d = function(self)
  -- function num : 0_5
  if self._editMain == nil then
    return false
  end
  return (self._editMain):GetAdjL2DOpen()
end

UINAdjEditorSetSkin.IsHideLive2dBg = function(self)
  -- function num : 0_6
  if self._editMain == nil then
    return false
  end
  local skinId = (self._editMain):GetAdjMainSkinId()
  return (self._editMain):IsHideLive2dBg(skinId)
end

UINAdjEditorSetSkin.IsFirstHeroInteration = function(self)
  -- function num : 0_7
  if self._editMain == nil then
    return false
  end
  local modifyIndex = (self._editMain):GetAdjModifyIndex()
  do return modifyIndex == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINAdjEditorSetSkin.CanEditorActiveLive2d = function(self)
  -- function num : 0_8
  if self._editMain == nil then
    return false
  end
  if (self._editMain):IsAdjForbidL2d() or not self:IsFirstHeroInteration() then
    return false
  end
  return true
end

UINAdjEditorSetSkin.CanEditorHideLive2dBg = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if not self:CanEditorActiveLive2d() then
    return false
  end
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local skinId = self:GetAdjMainSkinId()
  local canHideLive2dBg = skinCtrl:CanHideLive2dBg(skinId)
  return canHideLive2dBg
end

UINAdjEditorSetSkin.RefreshAdjL2DTogGroup = function(self)
  -- function num : 0_10 , upvalues : _ENV, UINCommonSwitchToggle
  local canEditorActiveLive2d = self:CanEditorActiveLive2d()
  local canEditorHideLive2dBg = self:CanEditorHideLive2dBg()
  local IsNeedEditorLive2dSetting = canEditorActiveLive2d or canEditorHideLive2dBg
  ;
  ((self.ui).live2DEditorGroup):SetActive(IsNeedEditorLive2dSetting)
  if self.Live2dEditorTogglePool ~= nil then
    (self.Live2dEditorTogglePool):HideAll()
  end
  if not IsNeedEditorLive2dSetting then
    return 
  end
  if self.Live2dEditorTogglePool == nil then
    self.Live2dEditorTogglePool = (UIItemPool.New)(UINCommonSwitchToggle, (self.ui).live2dEidtorToggle, false)
  end
  local isActiveLive2d = self:IsActiveLive2d()
  if canEditorActiveLive2d then
    self.activeLive2dToggle = (self.Live2dEditorTogglePool):GetOne()
    local __OnActiveLive2dChanged = BindCallback(self, self.OnActiveLive2dChanged)
    ;
    (self.activeLive2dToggle):InitCommonSwitchToggle(isActiveLive2d, __OnActiveLive2dChanged)
    ;
    (((self.activeLive2dToggle).ui).tex_ToggleName):SetIndex((self._editMain):GetAdjL2dLevel() - 1)
    ;
    (((self.activeLive2dToggle).ui).mask):SetActive(false)
  end
  do
    if canEditorHideLive2dBg then
      self.hideLive2dBgToggle = (self.Live2dEditorTogglePool):GetOne()
      local IsHideLive2dBg = self:IsHideLive2dBg()
      local __OnHideLive2dBgChanged = BindCallback(self, self.OnHideLive2dBgChanged)
      ;
      (self.hideLive2dBgToggle):InitCommonSwitchToggle(IsHideLive2dBg, __OnHideLive2dBgChanged)
      ;
      (((self.hideLive2dBgToggle).ui).tex_ToggleName):SetIndex(2)
      if canEditorActiveLive2d then
        (((self.hideLive2dBgToggle).ui).mask):SetActive(not isActiveLive2d)
      end
    end
  end
end

UINAdjEditorSetSkin.OnActiveLive2dChanged = function(self, isOn)
  -- function num : 0_11
  if self._editMain ~= nil then
    (self._editMain):SetAdjEditL2dTog(isOn)
  end
  local canEditorHideLive2dBg = self:CanEditorHideLive2dBg()
  if self.hideLive2dBgToggle ~= nil and canEditorHideLive2dBg then
    (((self.hideLive2dBgToggle).ui).mask):SetActive(not isOn)
  end
end

UINAdjEditorSetSkin.OnHideLive2dBgChanged = function(self, isOn)
  -- function num : 0_12
  if self._editMain ~= nil then
    if not self:IsActiveLive2d() then
      return 
    end
    local heroId = self:GetAdjMainHeroId()
    local skinId = self:GetAdjMainSkinId()
    ;
    (self._editMain):SetHideL2dBgTog(heroId, skinId, isOn)
  end
end

UINAdjEditorSetSkin.UpdateUINAdjEditorSetSkin = function(self)
  -- function num : 0_13 , upvalues : _ENV, CS_ResLoader
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  local adjIndexDic = (self._editMain):GetAdjEditAdjIndexDic()
  local modifyIndex = (self._editMain):GetAdjModifyIndex()
  self._heroId = adjIndexDic[modifyIndex]
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = ConfigData:GetHeroNameById(self._heroId)
  local modifyData = (self._editMain):GetAdjEditorAdjInfo(self._heroId)
  self._defaultSkinId = modifyData.skinId
  self._resloader = (CS_ResLoader.Create)()
  ;
  (self._skinPool):HideAll()
  local heroCfg = (ConfigData.hero_data)[self._heroId]
  local skins = {heroCfg.default_skin}
  for i,skinId in ipairs(heroCfg.skin) do
    if (PlayerDataCenter.skinData):IsSkinUnlocked(skinId) then
      (table.insert)(skins, skinId)
    end
  end
  local selectItem = nil
  for i,skinId in ipairs(skins) do
    local skinItem = (self._skinPool):GetOne()
    local skinCfg = (ConfigData.skin)[skinId]
    skinItem:InitAdjSkinItem(self._heroId, skinCfg, self._resloader, self.__OnSelectAdjSkinCallback)
    if skinId == modifyData.skinId then
      selectItem = skinItem
    end
  end
  if selectItem == nil then
    selectItem = ((self._skinPool).listItem)[1]
    ;
    (self._editMain):SetAdjEditHeroSkin(self._heroId, (selectItem:GetAdjSkinItemSkin()).id)
  end
  selectItem:SetAdjSkinItemSelect(true)
  -- DECOMPILER ERROR at PC105: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinName).text = (LanguageUtil.GetLocaleText)((selectItem:GetAdjSkinItemSkin()).name)
  self:RefreshAdjL2DTogGroup()
  self:__RefreshConfirmState()
end

UINAdjEditorSetSkin.OnClickConfirm = function(self)
  -- function num : 0_14 , upvalues : _ENV, CS_MessageCommon
  local adjInfo = (self._editMain):GetAdjEditorAdjInfo(self._heroId)
  if not (PlayerDataCenter.skinData):IsHaveSkin(adjInfo.skinId) then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(405))
    return 
  end
  ;
  (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).Operation)
end

UINAdjEditorSetSkin.__RefreshConfirmState = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local adjInfo = (self._editMain):GetAdjEditorAdjInfo(self._heroId)
  local canUse = (PlayerDataCenter.skinData):IsHaveSkin(adjInfo.skinId)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  if not canUse or not self._defaultConfirmColor then
    ((self.ui).img_confirm).color = Color.gray
    ;
    ((self.ui).obj_confirmText):SetActive(canUse)
    ;
    ((self.ui).isLocked):SetActive(not canUse)
    if not canUse then
      local skinCfg = (ConfigData.skin)[adjInfo.skinId]
      do
        local LockedDesFunc = function()
    -- function num : 0_15_0 , upvalues : _ENV, adjInfo, skinCfg, self
    local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
    local flag, condition = skinCtr:CheckSourceValid(adjInfo.skinId)
    if flag then
      if condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active then
        local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
        local actData = skinCtr:GetActFrameDataBySkinCfg(skinCfg)
        if actData ~= nil then
          ((self.ui).tex_LockDes):SetIndex(2, actData.name)
        else
          ;
          ((self.ui).tex_LockDes):SetIndex(0)
        end
      else
        do
          if condition == proto_csmsg_SystemFunctionID.SystemFunctionID_HeroRank then
            ((self.ui).tex_LockDes):SetIndex(1)
          else
            if condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Store or condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Gift then
              ((self.ui).tex_LockDes):SetIndex(3)
            else
              ;
              ((self.ui).tex_LockDes):SetIndex(0)
            end
          end
          ;
          ((self.ui).tex_LockDes):SetIndex(0)
        end
      end
    end
  end

        local conditionShopParam = (skinCfg.conditionParamDic)[proto_csmsg_SystemFunctionID.SystemFunctionID_Store]
        if conditionShopParam ~= nil then
          local shopCtr = ControllerManager:GetController(ControllerTypeId.Shop)
          shopCtr:GetShopData(conditionShopParam[1], function(shopData)
    -- function num : 0_15_1 , upvalues : _ENV, self, LockedDesFunc
    if not IsNull(self.transform) then
      LockedDesFunc()
    end
  end
)
        else
          do
            LockedDesFunc()
          end
        end
      end
    end
  end
end

UINAdjEditorSetSkin.OnClickCancle = function(self)
  -- function num : 0_16
  (self._editMain):SetAdjEditHeroSkin(self._heroId, self._defaultSkinId)
  if self._returnToHero then
    (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).SetHero)
  else
    ;
    (self._editMain):ResetAdjCache()
    ;
    (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).Operation)
  end
end

UINAdjEditorSetSkin.__OnSelectAdjSkin = function(self, skinItem)
  -- function num : 0_17 , upvalues : _ENV
  for _,item in ipairs((self._skinPool).listItem) do
    item:SetAdjSkinItemSelect(item == skinItem)
  end
  local skinCfg = skinItem:GetAdjSkinItemSkin()
  ;
  (self._editMain):SetAdjEditHeroSkin(self._heroId, skinCfg.id)
  self:RefreshAdjL2DTogGroup()
  self:__RefreshConfirmState()
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinName).text = (LanguageUtil.GetLocaleText)(skinCfg.name)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINAdjEditorSetSkin.__RefreshSkinlockState = function(self)
  -- function num : 0_18 , upvalues : _ENV
  for i,v in ipairs((self._skinPool).listItem) do
    v:RefreshAdjSkinLockState()
  end
end

UINAdjEditorSetSkin.OnDelete = function(self)
  -- function num : 0_19 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHeroSkin, self.__RefreshSkinlockStateCallback)
  if self.Live2dEditorTogglePool ~= nil then
    (self.Live2dEditorTogglePool):DeleteAll()
  end
  if self._multFrame ~= nil then
    (self._multFrame):Delete()
  end
  if self._singleFrame ~= nil then
    (self._singleFrame):Delete()
  end
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
end

return UINAdjEditorSetSkin

