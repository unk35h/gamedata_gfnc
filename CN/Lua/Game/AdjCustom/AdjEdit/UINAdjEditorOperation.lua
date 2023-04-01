-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorOperation = class("UINAdjEditorOperation", UIBaseNode)
local base = UIBaseNode
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
local UINAdjEditorOperationHeroModify = require("Game.AdjCustom.AdjEdit.UINAdjEditorOperationHeroModify")
local CS_ResLoader = CS.ResLoader
UINAdjEditorOperation.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAdjEditorOperationHeroModify, CS_ResLoader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchHero, self, self.OnClickSelectHero)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelHeroSkin, self, self.OnClickSelectSkin)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).bgItem, self, self.OnClickSelectBg)
  self._heroModifyPool = (UIItemPool.New)(UINAdjEditorOperationHeroModify, (self.ui).ctrlItem)
  ;
  (((self.ui).ctrlItem).gameObject):SetActive(false)
  self._modifyNodeDic = nil
  self._goModifyDic = {}
  self._resLoader = (CS_ResLoader.Create)()
end

UINAdjEditorOperation.InitUINAdjEditorOperation = function(self, editorMain)
  -- function num : 0_1
  self._editorMain = editorMain
end

UINAdjEditorOperation.GetAdjMainHeroId = function(self)
  -- function num : 0_2
  if self._editorMain == nil then
    return 
  end
  return (self._editorMain):GetAdjMainHeroId()
end

UINAdjEditorOperation.GetAdjMainSkinId = function(self)
  -- function num : 0_3
  if self._editorMain == nil then
    return 
  end
  return (self._editorMain):GetAdjMainSkinId()
end

UINAdjEditorOperation.UpdateUINAdjEditorOperation = function(self)
  -- function num : 0_4
  self:RefreshAdjOperaBgSelect()
  self:RefreshAdjOperaHeroSelect()
  self:RefreshAdjL2DTogGroup()
  local heroIndexDic = (self._editorMain):GetAdjEditAdjIndexDic()
  local index = (self._editorMain):GetAdjModifyIndex()
  if heroIndexDic[index] == nil then
    (self._editorMain):ChangeAdjModifyIndex(1)
  end
end

UINAdjEditorOperation.RefreshAdjOperaBgSelect = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local bgId = (self._editorMain):GetAdjEditBgId()
  local bgCfg = (ConfigData.background)[bgId]
  if bgCfg == nil then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(bgCfg.name)
  local bgPath = PathConsts:GetMainBgThumbnail(tostring(bgCfg.id))
  ;
  (self._resLoader):LoadABAssetAsync(bgPath, function(texture)
    -- function num : 0_5_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(self.transform) then
      ((self.ui).img_Bg).texture = texture
    end
  end
)
end

UINAdjEditorOperation.RefreshAdjOperaHeroSelect = function(self)
  -- function num : 0_6
  (self._heroModifyPool):HideAll()
  self._modifyNodeDic = {}
  local heroIndexDic = (self._editorMain):GetAdjEditAdjIndexDic()
  local limitCount = (self._editorMain):GetAdjCurCount()
  for i = 1, limitCount do
    local heroId = heroIndexDic[i]
    if heroId ~= nil then
      local item = (self._heroModifyPool):GetOne()
      local data = (self._editorMain):GetAdjEditorAdjInfo(heroId)
      item:InitAdjHeroModify(self._editorMain, data)
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self._modifyNodeDic)[heroId] = item
      local itemGo = (item.transform).gameObject
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R11 in 'UnsetPending'

      if (self._goModifyDic)[itemGo] == nil then
        (self._goModifyDic)[itemGo] = item
      end
    end
  end
  ;
  ((self.ui).obj_text1):SetActive(limitCount > 1)
  ;
  ((self.ui).obj_text2):SetActive(limitCount > 1)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINAdjEditorOperation.IsActiveLive2d = function(self)
  -- function num : 0_7
  if self._editorMain == nil then
    return false
  end
  return (self._editorMain):GetAdjL2DOpen()
end

UINAdjEditorOperation.IsHideLive2dBg = function(self)
  -- function num : 0_8
  if self._editorMain == nil then
    return false
  end
  local skinId = (self._editorMain):GetAdjMainSkinId()
  return (self._editorMain):IsHideLive2dBg(skinId)
end

UINAdjEditorOperation.CanEditorActiveLive2d = function(self)
  -- function num : 0_9
  if self._editorMain == nil then
    return false
  end
  if not (self._editorMain):IsAdjForbidL2d() then
    return true
  end
  return false
end

UINAdjEditorOperation.CanEditorHideLive2dBg = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if not self:CanEditorActiveLive2d() then
    return false
  end
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local skinId = self:GetAdjMainSkinId()
  local canHideLive2dBg = skinCtrl:CanHideLive2dBg(skinId)
  return canHideLive2dBg
end

UINAdjEditorOperation.RefreshAdjL2DTogGroup = function(self)
  -- function num : 0_11 , upvalues : _ENV, UINCommonSwitchToggle
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
    (((self.activeLive2dToggle).ui).tex_ToggleName):SetIndex((self._editorMain):GetAdjL2dLevel() - 1)
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

UINAdjEditorOperation.OnActiveLive2dChanged = function(self, isOn)
  -- function num : 0_12
  if self._editorMain ~= nil then
    (self._editorMain):SetAdjEditL2dTog(isOn)
  end
  local canEditorHideLive2dBg = self:CanEditorHideLive2dBg()
  if self.hideLive2dBgToggle ~= nil and canEditorHideLive2dBg then
    (((self.hideLive2dBgToggle).ui).mask):SetActive(not isOn)
  end
end

UINAdjEditorOperation.OnHideLive2dBgChanged = function(self, isOn)
  -- function num : 0_13
  if self._editorMain ~= nil then
    if not self:IsActiveLive2d() then
      return 
    end
    local heroId = self:GetAdjMainHeroId()
    local skinId = self:GetAdjMainSkinId()
    ;
    (self._editorMain):SetHideL2dBgTog(heroId, skinId, isOn)
  end
end

UINAdjEditorOperation.RefreshAdjOperaHeroSize = function(self, heroId)
  -- function num : 0_14
  local item = (self._modifyNodeDic)[heroId]
  if item ~= nil then
    item:RefreshAdjHeroModify()
  end
end

UINAdjEditorOperation.RefreshAdjOperationHeroMain = function(self)
  -- function num : 0_15 , upvalues : _ENV
  for k,item in pairs(self._modifyNodeDic) do
    item:RefreshAdjHeroState()
  end
end

UINAdjEditorOperation.OnClickSelectBg = function(self)
  -- function num : 0_16
  (self._editorMain):AdjEditJumpSubNode(((self._editorMain).subType).SetBg)
end

UINAdjEditorOperation.OnClickSelectHero = function(self)
  -- function num : 0_17
  (self._editorMain):AdjEditJumpSubNode(((self._editorMain).subType).SetHero)
end

UINAdjEditorOperation.OnClickSelectSkin = function(self)
  -- function num : 0_18
  (self._editorMain):AdjEditJumpSubNode(((self._editorMain).subType).SetSkin)
end

UINAdjEditorOperation.OnClickConfirm = function(self)
  -- function num : 0_19
  (self._editorMain):SaveAdjEdit()
end

UINAdjEditorOperation.OnDelete = function(self)
  -- function num : 0_20 , upvalues : base
  (base.OnDelete)(self)
  if self.Live2dEditorTogglePool ~= nil then
    (self.Live2dEditorTogglePool):DeleteAll()
  end
  if self._resLoader ~= nil then
    (self._resLoader):Put2Pool()
    self._resLoader = nil
  end
end

return UINAdjEditorOperation

