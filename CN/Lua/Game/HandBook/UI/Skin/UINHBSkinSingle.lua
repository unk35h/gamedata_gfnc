-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHBSkinSingle = class("UINHBSkinSingle", UIBaseNode)
local base = UIBaseNode
local UINHeroSkinTag = require("Game.Skin.UI.UINHeroSkinTag")
local UINHandBookSkinTag = require("Game.HandBook.UI.Skin.UINHandBookSkinTag")
local UINHeroSkinSpTag = require("Game.Skin.UI.UINHeroSkinSpTag")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
UINHBSkinSingle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHandBookSkinTag, UINHeroSkinTag, UINHeroSkinSpTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).skinItem, self, self.OnClickHBSingleItem)
  self._bookTagPool = (UIItemPool.New)(UINHandBookSkinTag, ((self.ui).img_Tag).gameObject)
  ;
  (((self.ui).img_Tag).gameObject):SetActive(false)
  self._tagPool = (UIItemPool.New)(UINHeroSkinTag, (self.ui).tagItem)
  ;
  ((self.ui).tagItem):SetActive(false)
  self._tagSpPool = (UIItemPool.New)(UINHeroSkinSpTag, (self.ui).img_SpTag)
  ;
  ((self.ui).img_SpTag):SetActive(false)
end

UINHBSkinSingle.InitHBSkinSingle = function(self, skinCfg, resloader, clickFunc)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self._skinCfg = skinCfg
  self._clickFunc = clickFunc
  local heroId = (self._skinCfg).heroId
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local resModelCfg = skinCtr:GetResModel(heroId, skinCfg ~= nil and skinCfg.id or nil)
  ;
  (self._tagPool):HideAll()
  ;
  (CommonUIUtil.CreateHeroSkinTags)(skinCfg, self._tagPool)
  ;
  (((self.ui).heroFrame).gameObject):SetActive(false)
  local picResPath = PathConsts:GetCharacterPicPath(resModelCfg.src_id_pic)
  resloader:LoadABAssetAsync(picResPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if not IsNull((self.ui).heroFrame) then
      (((self.ui).heroFrame).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).heroFrame).texture = texture
    end
  end
)
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinName).text = (LanguageUtil.GetLocaleText)((self._skinCfg).name)
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = ConfigData:GetHeroNameById(heroId)
  local hasSkin = (PlayerDataCenter.skinData):IsHaveSkin((self._skinCfg).id)
  ;
  ((self.ui).lock):SetActive(not hasSkin)
  ;
  (self._bookTagPool):HideAll()
  local shopGoods = skinCtr:GetGoodsBySkinCfg(self._skinCfg)
  do
    if skinCtr:GetGoodsBySkinCfg(self._skinCfg) ~= nil or skinCtr:GetGiftBySkinCfg(self._skinCfg) ~= nil then
      local bookTag = (self._bookTagPool):GetOne()
      bookTag:InitBookSkinTag(1)
      ;
      (bookTag.transform):SetAsLastSibling()
    end
    do
      if skinCtr:GetActFrameDataBySkinCfg(self._skinCfg) then
        local bookTag = (self._bookTagPool):GetOne()
        bookTag:InitBookSkinTag(2)
        ;
        (bookTag.transform):SetAsLastSibling()
      end
      ;
      (self._tagSpPool):HideAll()
      for _,tagId in ipairs((self._skinCfg).showlabel) do
        local item = (self._tagSpPool):GetOne()
        item:InitSkinSpTag(tagId)
        ;
        (item.transform):SetAsLastSibling()
      end
      local isShowL2DComingSoon = (self._skinCfg).temp_label
      ;
      ((self.ui).obj_L2DComingSoon):SetActive(isShowL2DComingSoon)
      ;
      (((self.ui).obj_L2DComingSoon).transform):SetAsLastSibling()
      ;
      (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).tagGroup)
    end
  end
end

UINHBSkinSingle.OnClickHBSingleItem = function(self)
  -- function num : 0_2
  if self._clickFunc ~= nil then
    (self._clickFunc)((self._skinCfg).id)
  end
end

UINHBSkinSingle.PlayHBSkinSingleAni = function(self, delayTime)
  -- function num : 0_3 , upvalues : cs_DoTweenLoopType
  self:__StopTween()
  ;
  ((((self.ui).bottom):DOLocalMoveX(20, 0.3)):From()):SetDelay(delayTime)
  ;
  ((((self.ui).canvasGroup):DOFade(0, 0.3)):From()):SetDelay(delayTime)
  ;
  ((((self.ui).tex_SkinName):DOFade(0, 0.2)):From()):SetDelay(delayTime)
  ;
  ((((((self.ui).tex_SkinName).transform):DOLocalMoveY(-10, 0.2)):From(true)):SetRelative(true)):SetDelay(delayTime)
  ;
  ((((self.ui).tex_HeroName):DOFade(0, 0.2)):From()):SetDelay(delayTime + 0.1)
  ;
  ((((((self.ui).tex_HeroName).transform):DOLocalMoveY(-10, 0.2)):From(true)):SetRelative(true)):SetDelay(delayTime + 0.1)
  ;
  (((((self.ui).skinTag):DOFade(0.4, 0.1)):From()):SetLoops(3, cs_DoTweenLoopType.Yoyo)):SetDelay(delayTime)
end

UINHBSkinSingle.__StopTween = function(self)
  -- function num : 0_4
  ((self.ui).bottom):DOComplete()
  ;
  ((self.ui).canvasGroup):DOComplete()
  ;
  ((self.ui).tex_SkinName):DOComplete()
  ;
  (((self.ui).tex_SkinName).transform):DOComplete()
  ;
  ((self.ui).tex_HeroName):DOComplete()
  ;
  (((self.ui).tex_HeroName).transform):DOComplete()
  ;
  ((self.ui).skinTag):DOComplete()
end

UINHBSkinSingle.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  self:__StopTween()
  ;
  (base.OnDelete)(self)
end

return UINHBSkinSingle

