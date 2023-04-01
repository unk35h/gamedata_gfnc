-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorSkinItem = class("UINAdjEditorSkinItem", UIBaseNode)
local base = UIBaseNode
local UINHeroSkinTag = require("Game.Skin.UI.UINHeroSkinTag")
local UINHeroSkinSpTag = require("Game.Skin.UI.UINHeroSkinSpTag")
local ALPHA_MASK_UNLOCK = 0.29803921568627
local ALPHA_MASK_LOCKED = 0.7843137254902
UINAdjEditorSkinItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroSkinTag, UINHeroSkinSpTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).tagItem):SetActive(false)
  self.tagPool = (UIItemPool.New)(UINHeroSkinTag, (self.ui).tagItem)
  self._tagSpPool = (UIItemPool.New)(UINHeroSkinSpTag, (self.ui).img_SpTag)
  ;
  ((self.ui).img_SpTag):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_skinPreviewItem, self, self.OnClickSkinItem)
end

UINAdjEditorSkinItem.InitAdjSkinItem = function(self, heroId, skinCfg, resLoader, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._heroId = heroId
  self._skinCfg = skinCfg
  self._clickFunc = clickFunc
  self._unlock = false
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local resModelCfg = skinCtr:GetResModel(heroId, skinCfg ~= nil and skinCfg.id or nil)
  ;
  (self.tagPool):HideAll()
  ;
  (CommonUIUtil.CreateHeroSkinTags)(skinCfg, self.tagPool)
  ;
  (((self.ui).img_Skin).gameObject):SetActive(false)
  local picResPath = PathConsts:GetCharacterPicPath(resModelCfg.src_id_pic)
  resLoader:LoadABAssetAsync(picResPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if not IsNull((self.ui).img_Skin) then
      (((self.ui).img_Skin).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_Skin).texture = texture
    end
  end
)
  if skinCfg == nil or not skinCfg.theme then
    local themId = (ConfigData.game_config).defaultSkinThemId
  end
  local skinTheme = (ConfigData.skinTheme)[themId]
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R10 in 'UnsetPending'

  if self._skinCfg == nil or not (LanguageUtil.GetLocaleText)((self._skinCfg).name) then
    ((self.ui).tex_HeroName).text = ConfigData:GetHeroNameById(self._heroId)
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_SkinName).text = skinTheme ~= nil and (LanguageUtil.GetLocaleText)(skinTheme.name) or ""
    ;
    (self._tagSpPool):HideAll()
    for _,tagId in ipairs((self._skinCfg).showlabel) do
      local item = (self._tagSpPool):GetOne()
      item:InitSkinSpTag(tagId)
    end
    self:SetAdjSkinItemSelect(false)
    self:RefreshAdjSkinLockState()
  end
end

UINAdjEditorSkinItem.SetAdjSkinItemSelect = function(self, flag)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).img_Quailty).gameObject):SetActive(flag)
  if self._unlock then
    (((self.ui).maskBlack).gameObject):SetActive(not flag)
  else
    ;
    (((self.ui).maskBlack).gameObject):SetActive(true)
  end
  for i,v in ipairs((self.tagPool).listItem) do
    v:SetSelectState(flag)
  end
end

UINAdjEditorSkinItem.RefreshAdjSkinLockState = function(self)
  -- function num : 0_3 , upvalues : _ENV, ALPHA_MASK_UNLOCK, ALPHA_MASK_LOCKED
  if self._unlock then
    return 
  end
  self._unlock = (PlayerDataCenter.skinData):IsHaveSkin((self._skinCfg).id)
  if self._unlock then
    local color = ((self.ui).maskBlack).color
    color.a = ALPHA_MASK_UNLOCK
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).maskBlack).color = color
    ;
    ((self.ui).lock):SetActive(false)
  else
    do
      local color = ((self.ui).maskBlack).color
      color.a = ALPHA_MASK_LOCKED
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).maskBlack).color = color
      ;
      ((self.ui).lock):SetActive(true)
    end
  end
end

UINAdjEditorSkinItem.OnClickSkinItem = function(self)
  -- function num : 0_4
  if self._clickFunc ~= nil then
    (self._clickFunc)(self)
  end
end

UINAdjEditorSkinItem.GetAdjSkinItemSkin = function(self)
  -- function num : 0_5
  return self._skinCfg
end

return UINAdjEditorSkinItem

