-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHBHeroSkinTheme = class("UINHBHeroSkinTheme", UIBaseNode)
local base = UIBaseNode
local UINHandBookSkinTag = require("Game.HandBook.UI.Skin.UINHandBookSkinTag")
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINHBHeroSkinTheme.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHandBookSkinTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).skinItem, self, self.OnClickTheme)
  self._tagPool = (UIItemPool.New)(UINHandBookSkinTag, ((self.ui).hot).gameObject)
  ;
  (((self.ui).hot).gameObject):SetActive(false)
end

UINHBHeroSkinTheme.InitHBThemeItem = function(self, themeCfg, count, resloder, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._themeId = themeCfg.id
  ;
  (((self.ui).img_SkinBg).gameObject):SetActive(false)
  ;
  (self._tagPool):HideAll()
  local totalCount = 0
  for _,skinId in pairs(((ConfigData.skin).themeDic)[self._themeId]) do
    if (PlayerDataCenter.skinData):IsSkinUnlocked(skinId) then
      totalCount = totalCount + 1
    end
  end
  self._totalCount = totalCount
  resloder:LoadABAssetAsync(PathConsts:GetHeroSkinThemePicPath(themeCfg.pic), function(Texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if Texture == nil or IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SkinBg).texture = Texture
    ;
    (((self.ui).img_SkinBg).gameObject):SetActive(true)
  end
)
  self:RefreshHBThemeCollect(count)
  self._callback = callback
end

UINHBHeroSkinTheme.RefreshHBThemeCollect = function(self, count)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).tex_Progress):SetIndex(0, tostring(count), tostring(self._totalCount))
end

UINHBHeroSkinTheme.SetHBHeroSkinThemeTag = function(self, index)
  -- function num : 0_3
  local tag = (self._tagPool):GetOne()
  tag:InitBookSkinTag(index)
end

UINHBHeroSkinTheme.PlayHBHeroSkinThemTween = function(self, delayTime)
  -- function num : 0_4
  self:__StopTween()
  ;
  ((((self.ui).canvasGroup):DOFade(0, 0.2)):From()):SetDelay(delayTime)
  ;
  ((((self.ui).bottom):DOLocalMoveY(-20, 0.2)):From()):SetDelay(delayTime)
  ;
  ((((self.ui).hot):DOFade(0, 0.2)):From()):SetDelay(0.1 + delayTime)
  ;
  (((((self.ui).hot).transform):DOLocalMoveX(-205, 0.2)):From()):SetDelay(0.1 + delayTime)
end

UINHBHeroSkinTheme.__StopTween = function(self)
  -- function num : 0_5
  ((self.ui).canvasGroup):DOComplete()
  ;
  ((self.ui).hot):DOComplete()
  ;
  ((self.ui).bottom):DOComplete()
  ;
  (((self.ui).hot).transform):DOComplete()
end

UINHBHeroSkinTheme.GetHBThemeId = function(self)
  -- function num : 0_6
  return self._themeId
end

UINHBHeroSkinTheme.OnClickTheme = function(self)
  -- function num : 0_7
  if self._callback ~= nil then
    (self._callback)(self)
  end
end

UINHBHeroSkinTheme.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  self:__StopTween()
  ;
  (base.OnDelete)(self)
end

return UINHBHeroSkinTheme

