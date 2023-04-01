-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjPresetBaseItem = require("Game.AdjCustom.AdjPreset.UINAdjPresetBaseItem")
local UINAdjPresetMultItem = class("UINAdjPresetMultItem", UINAdjPresetBaseItem)
local base = UINAdjPresetBaseItem
local CS_UnityEngine_GameObject = (CS.UnityEngine).GameObject
local UINAdjPresetItemSkinName = require("Game.AdjCustom.AdjPreset.UINAdjPresetItemSkinName")
UINAdjPresetMultItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINAdjPresetItemSkinName
  (base.OnInit)(self)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_sec, self, self.OnClickSecLoad)
  self._heroIconPool = {}
  ;
  (table.insert)(self._heroIconPool, (self.ui).img_Hero)
  ;
  (((self.ui).img_Hero).gameObject):SetActive(false)
  self._heroNameTextPool = (UIItemPool.New)(UINAdjPresetItemSkinName, (self.ui).obj_HeroName)
  ;
  ((self.ui).obj_HeroName):SetActive(false)
  self._heroNameIconDic = {}
end

UINAdjPresetMultItem.__RefreshAdjPresetHero = function(self)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.__RefreshAdjPresetHero)(self)
  self:__CycleResource()
  local heroList = (self._data):GetAdjPresetHeroList()
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  for index,heorId in ipairs(heroList) do
    local heroPreset = (self._data):GetAdjPresetElemData(heorId)
    do
      local heroNameText = (self._heroNameTextPool):GetOne()
      ;
      (heroNameText.transform):SetAsLastSibling()
      if heroPreset.skinId == 0 or not heroPreset.skinId then
        local skinId = ((ConfigData.hero_data)[heroPreset.dataId]).default_skin
      end
      heroNameText:RefreshAdjPresetItemSkinName(skinId, (index == 1 and (self._data):GetAdjPresetUseL2d()))
      local heroIcon = self:__GetNewHeroIcon()
      ;
      (heroIcon.transform):SetAsLastSibling()
      local modelCfg = skinCtrl:GetResModel(heroPreset.dataId, heroPreset.skinId)
      ;
      (self._resloader):LoadABAssetAsync(PathConsts:GetCharacterPicPath(modelCfg.src_id_pic), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self, heroIcon
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    ;
    (heroIcon.gameObject):SetActive(true)
    heroIcon.texture = texture
  end
)
      -- DECOMPILER ERROR at PC68: Confused about usage of register: R13 in 'UnsetPending'

      ;
      (self._heroNameIconDic)[heorId] = heroIcon
    end
  end
  ;
  ((self.ui).heroEmpty):SetActive(#heroList < 2)
  ;
  (((self.ui).heroEmpty).transform):SetAsLastSibling()
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINAdjPresetMultItem.__GetNewHeroIcon = function(self)
  -- function num : 0_2 , upvalues : _ENV, CS_UnityEngine_GameObject
  local total = #self._heroIconPool
  do
    if total > 0 then
      local img = (self._heroIconPool)[total]
      ;
      (table.remove)(self._heroIconPool, total)
      return img
    end
    local obj = (CS_UnityEngine_GameObject.Instantiate)(((self.ui).img_Hero).gameObject, (((self.ui).img_Hero).transform).parent)
    local img = obj:GetComponent(typeof(((CS.UnityEngine).UI).RawImage))
    return img
  end
end

UINAdjPresetMultItem.__CycleResource = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self._heroNameTextPool):HideAll()
  for k,heroIcon in pairs(self._heroNameIconDic) do
    (table.insert)(self._heroIconPool, heroIcon)
    ;
    (heroIcon.gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self._heroNameIconDic)[k] = nil
  end
end

UINAdjPresetMultItem.OnClickSecLoad = function(self)
  -- function num : 0_4
  if self._clickEditFunc ~= nil then
    (self._clickEditFunc)(self._teamId, 2)
  end
end

return UINAdjPresetMultItem

