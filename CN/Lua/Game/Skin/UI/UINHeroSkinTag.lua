-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroSkinTag = class("UINHeroSkinTag", UIBaseNode)
local base = UIBaseNode
local SkinEnum = require("Game.Skin.SkinEnum")
UINHeroSkinTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHeroSkinTag.InitSkinTag = function(self, tagIndex)
  -- function num : 0_1 , upvalues : _ENV, SkinEnum
  self.tagIndex = tagIndex
  local name = ((ConfigData.skin_lable)[self.tagIndex]).name
  name = (LanguageUtil.GetLocaleText)(name)
  ;
  ((self.ui).tex_Tag):SetText(name)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_tag).color = (SkinEnum.ColorShowTags)[self.tagIndex + 1]
end

UINHeroSkinTag.InitSkinTagLive2dLevel = function(self, live2dLevel)
  -- function num : 0_2
  if live2dLevel == 2 then
    self:InitSkinTag(2)
  else
    self:InitSkinTag(1)
  end
end

UINHeroSkinTag.SetSelectState = function(self, isSelect)
  -- function num : 0_3 , upvalues : SkinEnum
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  if isSelect then
    ((self.ui).img_tag).color = (SkinEnum.ColorShowTags)[self.tagIndex + 1]
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_tag).color = (SkinEnum.ColorHideTags)[self.tagIndex + 1]
  end
end

return UINHeroSkinTag

