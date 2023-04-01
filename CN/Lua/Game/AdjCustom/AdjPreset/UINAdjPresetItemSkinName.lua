-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjPresetItemSkinName = class("UINAdjPresetItemSkinName", UIBaseNode)
local base = UIBaseNode
local UINHeroSkinTag = require("Game.Skin.UI.UINHeroSkinTag")
UINHeroSkinTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroSkinTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._tagItem = (UINHeroSkinTag.New)()
  ;
  (self._tagItem):Init((self.ui).tagItem)
end

UINHeroSkinTag.RefreshAdjPresetItemSkinName = function(self, skinId, usingL2d)
  -- function num : 0_1 , upvalues : _ENV
  local skinCfg = (ConfigData.skin)[skinId]
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = ConfigData:GetHeroNameById(skinCfg.heroId) .. "\n" .. (LanguageUtil.GetLocaleText)(skinCfg.name)
  if not usingL2d then
    (self._tagItem):Hide()
  else
    ;
    (self._tagItem):Show()
    ;
    (self._tagItem):InitSkinTagLive2dLevel(skinCfg.live2d_level)
  end
end

return UINHeroSkinTag

