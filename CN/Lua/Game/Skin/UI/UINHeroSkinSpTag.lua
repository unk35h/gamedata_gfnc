-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroSkinSpTag = class("UINHeroSkinSpTag", UIBaseNode)
local base = UIBaseNode
UINHeroSkinSpTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHeroSkinSpTag.InitSkinSpTag = function(self, tagId)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).text).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipTag(TipTag.skinTag, tagId))
end

return UINHeroSkinSpTag

