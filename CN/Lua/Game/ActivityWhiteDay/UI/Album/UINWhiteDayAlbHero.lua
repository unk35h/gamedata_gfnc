-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayAlbHero = class("UINWhiteDayAlbHero", UIBaseNode)
local base = UIBaseNode
UINWhiteDayAlbHero.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).heroItem, self, self.OnClickSelect)
end

UINWhiteDayAlbHero.InitAlbHero = function(self, photoHeroCfg, resloader, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._photoHeroCfg = photoHeroCfg
  self._callback = callback
  self:SetAlbHeroSelectState(false)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = ConfigData:GetHeroNameById((self._photoHeroCfg).photo_hero)
  local skinCfg = (ConfigData.skin)[(self._photoHeroCfg).skinId]
  ;
  (((self.ui).img_HeroPic).gameObject):SetActive(false)
  resloader:LoadABAssetAsync(PathConsts:GetCharacterPicPath(skinCfg.src_id_pic), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) then
      return 
    end
    ;
    (((self.ui).img_HeroPic).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPic).texture = texture
  end
)
end

UINWhiteDayAlbHero.SetAlbHeroSelectState = function(self, flag)
  -- function num : 0_2
  ;
  ((self.ui).bottom):SetIndex(flag and 1 or 0)
end

UINWhiteDayAlbHero.OnClickSelect = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._photoHeroCfg, self)
  end
end

UINWhiteDayAlbHero.GetPhotoHeroCfg = function(self)
  -- function num : 0_4
  return self._photoHeroCfg
end

return UINWhiteDayAlbHero

