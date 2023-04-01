-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjPresetBaseItem = require("Game.AdjCustom.AdjPreset.UINAdjPresetBaseItem")
local UINAdjPresetSingleItem = class("UINAdjPresetSingleItem", UINAdjPresetBaseItem)
local base = UINAdjPresetBaseItem
local UINAdjPresetItemSkinName = require("Game.AdjCustom.AdjPreset.UINAdjPresetItemSkinName")
UINAdjPresetSingleItem.__RefreshAdjPresetHero = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINAdjPresetItemSkinName
  (base.__RefreshAdjPresetHero)(self)
  local heroPreset = (self._data):GetAdjPresetElemMain()
  if heroPreset == nil then
    return 
  end
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local modelCfg = skinCtrl:GetResModel(heroPreset.dataId, heroPreset.skinId)
  ;
  (((self.ui).img_Hero).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetCharacterPicPath(modelCfg.src_id_pic), function(texture)
    -- function num : 0_0_0 , upvalues : _ENV, self
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    ;
    (((self.ui).img_Hero).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Hero).texture = texture
  end
)
  if heroPreset.skinId == 0 or not heroPreset.skinId then
    local skinId = ((ConfigData.hero_data)[heroPreset.dataId]).default_skin
  end
  if self._skinNameItem == nil then
    self._skinNameItem = (UINAdjPresetItemSkinName.New)()
    ;
    (self._skinNameItem):Init((self.ui).obj_HeroName)
  end
  ;
  (self._skinNameItem):RefreshAdjPresetItemSkinName(skinId, (self._data):GetAdjPresetUseL2d())
end

return UINAdjPresetSingleItem

