-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGetHeroSkin = class("UIGetHeroSkin", UIBaseWindow)
local base = UIBaseWindow
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
local UINHeroSkinTag = require("Game.Skin.UI.UINHeroSkinTag")
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
UIGetHeroSkin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroSkinTag
  (UIUtil.AddButtonListener)((self.ui).Btn_immediate, self, self.OnClickUse)
  ;
  (UIUtil.AddButtonListener)((self.ui).Btn_Close, self, self.OnCloseHeroSkin)
  self.tagPool = (UIItemPool.New)(UINHeroSkinTag, (self.ui).tagItem, false)
  self.skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
end

UIGetHeroSkin.InitGetHeroSkin = function(self, skinCfg, callback)
  -- function num : 0_1
  self._callback = callback
  self.skinCfg = skinCfg
  self:StopGetHeroCv()
  self:StopHomeLive2dVoice()
  self:InitializeUI()
  self:InitTweens()
  self:RefreshGetHeroSkinInfo()
end

UIGetHeroSkin.GetHeroId = function(self)
  -- function num : 0_2 , upvalues : _ENV
  do
    if self.heroId == nil and self.skinCtrl and self.skinCfg ~= nil then
      local skinId = self:GetSkinId()
      self.heroId = ((ConfigData.hero_data)[(self.skinCtrl):GetHeroId(skinId)]).id
    end
    return self.heroId
  end
end

UIGetHeroSkin.GetSkinId = function(self)
  -- function num : 0_3
  if self.skinCfg ~= nil then
    return (self.skinCfg).id
  end
end

UIGetHeroSkin.InitializeUI = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local windowX = ((((self.ui).obj_Center).transform).rect).width
  local windowY = ((((self.ui).obj_Center).transform).rect).height
  self._defaultWindowSize = {windowX, windowY}
  local middleCenter = (Vector2.New)(0.5, 0.5)
  ;
  (((self.ui).obj_Center).gameObject):SetActive(true)
  ;
  (((self.ui).obj_IntroMask).gameObject):SetActive(true)
  ;
  (((self.ui).group_Top).gameObject):SetActive(true)
  ;
  (((self.ui).group_Bottom).gameObject):SetActive(true)
  ;
  (((self.ui).group_left).gameObject):SetActive(false)
  ;
  (((self.ui).group_Right).gameObject):SetActive(false)
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).group_Top).sizeDelta = (Vector2.New)(0, -windowY / 2)
  -- DECOMPILER ERROR at PC73: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).group_Bottom).sizeDelta = (Vector2.New)(0, -windowY / 2)
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).obj_Center).transform).sizeDelta = (Vector2.New)(74, windowX)
  -- DECOMPILER ERROR at PC92: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).obj_Center).transform).rotation = (Quaternion.Euler)(0, 0, 90)
  -- DECOMPILER ERROR at PC100: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Background).sizeDelta = (Vector2.New)(windowX, windowX)
  -- DECOMPILER ERROR at PC103: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).LeftLineGroup).anchorMin = middleCenter
  -- DECOMPILER ERROR at PC106: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).LeftLineGroup).anchorMax = middleCenter
  -- DECOMPILER ERROR at PC109: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).RightLineGroup).anchorMin = middleCenter
  -- DECOMPILER ERROR at PC112: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).RightLineGroup).anchorMax = middleCenter
  -- DECOMPILER ERROR at PC121: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).LeftLineGroup).localPosition = (Vector2.New)(-19, -windowX / 2)
  -- DECOMPILER ERROR at PC129: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).RightLineGroup).localPosition = (Vector2.New)(19, windowX / 2)
  -- DECOMPILER ERROR at PC138: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).group_left).transform).localPosition = (Vector2.New)(0, 0)
  -- DECOMPILER ERROR at PC147: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).group_Right).transform).localPosition = (Vector2.New)(0, 0)
  -- DECOMPILER ERROR at PC155: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).LeftLineGroup).sizeDelta = (Vector2.New)(40, 0)
  -- DECOMPILER ERROR at PC163: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).RightLineGroup).sizeDelta = (Vector2.New)(40, 0)
  ;
  (((self.ui).img_Background).gameObject):SetActive(false)
  ;
  ((self.ui).textNode):SetActive(self:SkinHasVoice())
end

UIGetHeroSkin.InitTweens = function(self)
  -- function num : 0_5 , upvalues : cs_DoTween, _ENV, cs_Ease
  local lineWidth = 38.66431
  local TopGroup = (self.ui).Tween_TopGroup
  local BottomGroup = (self.ui).Tween_BottomGroup
  local halfX = (self._defaultWindowSize)[1] / 2
  local halfY = (self._defaultWindowSize)[2] / 2
  local stripeY = (((self.ui).rect_Stripe).localPosition).y
  local texCloudY = (((self.ui).rect_Stripe).localPosition).y
  self.twSequence = (cs_DoTween.Sequence)()
  ;
  (self.twSequence):AppendCallback(function()
    -- function num : 0_5_0 , upvalues : _ENV, TopGroup, cs_Ease, BottomGroup, self, halfY, texCloudY, stripeY, lineWidth
    for index,moveItem in ipairs(TopGroup) do
      if index == 1 then
        ((moveItem:DOLocalMove((Vector2.New)(0, 0), 0.25)):From()):SetEase(cs_Ease.OutQuart)
      else
        ;
        (((moveItem:DOLocalMove((Vector2.New)(0, 0), 0.2 * index)):From()):SetEase(cs_Ease.OutQuart)):SetDelay(0.1)
      end
    end
    for index,bottomItem in ipairs(BottomGroup) do
      if index == 1 then
        ((bottomItem:DOLocalMove((Vector2.New)(0, 0), 0.25)):From()):SetEase(cs_Ease.OutQuart)
      else
        ;
        (((bottomItem:DOLocalMove((Vector2.New)(0, 0), 0.2 * index)):From()):SetEase(cs_Ease.OutQuart)):SetDelay(0.1)
      end
    end
    ;
    ((((self.ui).rect_TexProjectionTop):DOLocalMove((Vector2.New)(0, -halfY - 164), 0.5)):From()):SetEase(cs_Ease.OutQuart)
    ;
    ((((self.ui).rect_neuralCloud):DOLocalMoveY(-texCloudY - 164, 0.5)):From()):SetEase(cs_Ease.OutQuart)
    ;
    ((((self.ui).rect_TexProjectionBottom):DOLocalMove((Vector2.New)(0, halfY + 164), 0.5)):From()):SetEase(cs_Ease.OutQuart)
    ;
    ((((self.ui).rect_Stripe):DOLocalMoveY(stripeY + 164, 0.5)):From()):SetEase(cs_Ease.OutQuart)
    ;
    (((self.ui).LeftLineGroup):DOSizeDelta((Vector2.New)(lineWidth, (self._defaultWindowSize)[1] * 1.1), 0.5)):SetEase(cs_Ease.OutQuart)
    ;
    ((((self.ui).RightLineGroup):DOSizeDelta((Vector2.New)(lineWidth, (self._defaultWindowSize)[1] * 1.1), 0.5)):SetEase(cs_Ease.OutQuart)):OnComplete(function()
      -- function num : 0_5_0_0 , upvalues : self
      (((self.ui).img_Background).gameObject):SetActive(true)
    end
)
  end
)
  ;
  (self.twSequence):AppendInterval(0.6)
  ;
  (self.twSequence):AppendCallback(function()
    -- function num : 0_5_1 , upvalues : self, _ENV, cs_Ease
    (((self.ui).obj_Center):DORotateQuaternion((Quaternion.Euler)(0, 0, 0), 0.45)):SetEase(cs_Ease.InOutSine)
  end
)
  ;
  (self.twSequence):AppendInterval(0.45)
  ;
  (self.twSequence):AppendCallback(function()
    -- function num : 0_5_2 , upvalues : self, _ENV, halfX, lineWidth, halfY, cs_Ease
    (((self.ui).group_left).gameObject):SetActive(true)
    ;
    (((self.ui).group_Right).gameObject):SetActive(true)
    ;
    (((self.ui).group_Top).gameObject):SetActive(false)
    ;
    (((self.ui).group_Bottom).gameObject):SetActive(false)
    ;
    (((self.ui).LeftLineGroup):DOLocalMove((Vector2.New)(-halfX + lineWidth / 2, -halfY), 0.4)):SetEase(cs_Ease.OutQuart)
    ;
    (((self.ui).RightLineGroup):DOLocalMove((Vector2.New)(halfX - lineWidth / 2, halfY), 0.4)):SetEase(cs_Ease.OutQuart)
    ;
    (((self.ui).group_left):DOLocalMoveX(-halfX + lineWidth / 2, 0.4)):SetEase(cs_Ease.OutQuart)
    ;
    (((self.ui).group_Right):DOLocalMoveX(halfX - lineWidth / 2, 0.4)):SetEase(cs_Ease.OutQuart)
    ;
    (((((self.ui).img_Background).gameObject).transform):DOSizeDelta((Vector2.New)((self._defaultWindowSize)[1], (self._defaultWindowSize)[2]), 0.4)):SetEase(cs_Ease.OutQuart)
    ;
    ((((self.ui).obj_Center):DOSizeDelta((Vector2.New)((self._defaultWindowSize)[1], (self._defaultWindowSize)[2]), 0.4)):SetEase(cs_Ease.OutQuart)):OnComplete(function()
      -- function num : 0_5_2_0 , upvalues : self
      ((self.ui).obj_IntroMask):SetActive(false)
      ;
      ((self.ui).obj_CastMask):SetActive(false)
    end
)
    self:__PlayGetSkinVoice()
  end
)
  ;
  (self.twSequence):Restart()
end

UIGetHeroSkin.RefreshGetHeroSkinInfo = function(self)
  -- function num : 0_6 , upvalues : _ENV, HeroCubismInteration
  if self.skinCfg == nil then
    error("skinCfg is nil")
    return 
  end
  if #(self.skinCfg).showlabel > 0 then
    ((self.ui).obj_Tag):SetActive(true)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_promotion).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipTag(TipTag.skinTag, ((self.skinCfg).showlabel)[1]))
  else
    ;
    ((self.ui).obj_Tag):SetActive(false)
  end
  local isShowL2DComingSoon = (self.skinCfg).temp_label
  ;
  ((self.ui).obj_L2DComingSoon):SetActive(isShowL2DComingSoon)
  ;
  (((self.ui).obj_L2DComingSoon).transform):SetAsLastSibling()
  local heroId = self:GetHeroId()
  local heroName = ((ConfigData.hero_data)[heroId]).name
  local skinName = (self.skinCfg).name
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinTitle).text = (string.format)("%s「%s」", (LanguageUtil.GetLocaleText)(heroName), (LanguageUtil.GetLocaleText)(skinName))
  ;
  (((self.ui).Tex_immediate).gameObject):SetActive(true)
  ;
  (((self.ui).tex_isEquiped).gameObject):SetActive(false)
  local color = (self.ui).defaultColor
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  local skinId = self:GetSkinId()
  if heroId == nil or heroData == nil then
    (((self.ui).Tex_immediate).gameObject):SetActive(false)
    ;
    (((self.ui).tex_isEquiped).gameObject):SetActive(true)
    ;
    ((self.ui).tex_isEquiped):SetIndex(1)
    color = (self.ui).deepColor
  else
    if heroData.skinId == skinId then
      (((self.ui).Tex_immediate).gameObject):SetActive(false)
      ;
      (((self.ui).tex_isEquiped).gameObject):SetActive(true)
      ;
      ((self.ui).tex_isEquiped):SetIndex(0)
      color = (self.ui).deepColor
    end
  end
  -- DECOMPILER ERROR at PC139: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_immediate).color = color
  ;
  (self.tagPool):HideAll()
  ;
  (CommonUIUtil.CreateHeroSkinTags)(self.skinCfg, self.tagPool)
  -- DECOMPILER ERROR at PC163: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (string.format)("[%s]", (LanguageUtil.GetLocaleText)(((ConfigData.skinTheme)[(self.skinCfg).theme]).name))
  -- DECOMPILER ERROR at PC171: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinName).text = (LanguageUtil.GetLocaleText)((self.skinCfg).name)
  -- DECOMPILER ERROR at PC179: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)((self.skinCfg).describe)
  local resModel = (self.skinCtrl):GetResModel(heroId, skinId)
  if not IsNull(self.l2dModelIns) then
    (HeroCubismInteration.DestroyInterationInstance)(self.l2dModelIns)
    self.l2dModelIns = nil
    self.l2dBinding = nil
  end
  if not IsNull(self.bigImgGameObject) then
    DestroyUnityObject(self.bigImgGameObject)
  end
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
    self.l2dBinding = nil
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  self.l2dBinding = nil
  local isHaveL2D = (PlayerDataCenter.skinData):IsHaveL2d(skinId)
  if isHaveL2D then
    local resPath = PathConsts:GetCharacterLive2DPath(resModel.src_id_pic)
    self:__LoadLive2D(resPath)
  else
    do
      self:__LoadPic(PathConsts:GetCharacterBigImgPrefabPath((self.skinCfg).src_id_pic))
    end
  end
end

UIGetHeroSkin.__LoadLive2D = function(self, path)
  -- function num : 0_7 , upvalues : _ENV, HeroCubismInteration
  self.Live2DResloader = ((CS.ResLoader).Create)()
  local l2dModelAsset = (self.Live2DResloader):LoadABAsset(path)
  if IsNull(self.transform) or IsNull(l2dModelAsset) then
    return 
  end
  self.l2dModelIns = l2dModelAsset:Instantiate()
  ;
  ((self.l2dModelIns).transform):SetParent(((self.ui).heroFade).transform)
  ;
  ((self.l2dModelIns).transform):SetLayer(LayerMask.UI)
  local cs_CubismInterationController = ((self.l2dModelIns).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
  if cs_CubismInterationController ~= nil then
    self.heroCubismInteration = (HeroCubismInteration.New)()
    local heroId = self:GetHeroId()
    local skinId = self:GetSkinId()
    ;
    (self.heroCubismInteration):InitHeroCubism(cs_CubismInterationController, heroId, skinId, UIManager:GetUICamera(), false)
    ;
    (self.heroCubismInteration):SetInterationOpenWait(false)
    ;
    (self.heroCubismInteration):OpenLookTarget(UIManager:GetUICamera())
    ;
    (self.heroCubismInteration):SetRenderControllerSetting(self:GetWindowSortingLayer(), (self.ui).heroFade, 1, true)
    ;
    (self.heroCubismInteration):SetL2DPosType("HeroSkin", false)
  end
  do
    self.l2dBinding = {}
    ;
    (UIUtil.LuaUIBindingTable)(self.l2dModelIns, self.l2dBinding)
  end
end

UIGetHeroSkin.__LoadPic = function(self, path)
  -- function num : 0_8 , upvalues : _ENV
  self.bigImgResloader = ((CS.ResLoader).Create)()
  ;
  (self.bigImgResloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_8_0 , upvalues : _ENV, self
    if IsNull(prefab) or IsNull(self.transform) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate(((self.ui).picHolder).transform)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
  end
)
end

UIGetHeroSkin.StopGetHeroCv = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.playCvcallBack ~= nil then
    AudioManager:StopAudioByBack(self.playCvcallBack)
  end
end

UIGetHeroSkin.StopHomeLive2dVoice = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local homeController = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeController ~= nil then
    homeController:ResetShowHeroVoiceImme()
  end
end

UIGetHeroSkin.SkinHasVoice = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local skinId = self:GetSkinId()
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  return cvCtr:HasSkinCv(skinId)
end

UIGetHeroSkin.__PlayGetSkinVoice = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local skinId = self:GetSkinId()
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  if cvCtr:HasSkinCv(skinId) then
    local heroId = self:GetHeroId()
    local voiceId = 101
    local text = cvCtr:GetCvText(heroId, voiceId, skinId)
    self:StopGetHeroCv()
    self.playCvcallBack = cvCtr:PlayCv(heroId, voiceId, function()
    -- function num : 0_12_0
  end
, true, skinId)
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Audio).text = text
  end
end

UIGetHeroSkin.OnClickUse = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if (((self.ui).tex_isEquiped).gameObject).activeSelf == true then
    return 
  end
  local heroId = self:GetHeroId()
  local callback = function()
    -- function num : 0_13_0 , upvalues : _ENV, self
    local win = UIManager:GetWindow(UIWindowTypeID.HeroSkin)
    if win ~= nil then
      win:ClickHeroSkinUseCallback()
    end
    ;
    (((self.ui).Tex_immediate).gameObject):SetActive(false)
    ;
    (((self.ui).tex_isEquiped).gameObject):SetActive(true)
    ;
    ((self.ui).tex_isEquiped):SetIndex(0)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_immediate).color = (self.ui).deepColor
  end

  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  skinCtrl:HeroSkinChange(heroId, self.skinCfg, callback)
end

UIGetHeroSkin.OnCloseHeroSkin = function(self)
  -- function num : 0_14
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIGetHeroSkin.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  if self.twSequence ~= nil then
    (self.twSequence):Kill()
    self.twSequence = nil
  end
  ;
  ((self.ui).group_left):DOKill()
  ;
  ((self.ui).group_Right):DOKill()
  ;
  ((self.ui).img_Background):DOKill()
  ;
  ((self.ui).FontUICanvas):DOKill()
  ;
  ((((self.ui).img_Background).gameObject).transform):DOKill()
  ;
  ((self.ui).obj_Center):DOKill()
  ;
  ((self.ui).RightLineGroup):DOKill()
  ;
  ((self.ui).LeftLineGroup):DOKill()
  for index,topItem in ipairs((self.ui).Tween_TopGroup) do
    topItem:DOKill()
  end
  for index,bottomItem in ipairs((self.ui).Tween_BottomGroup) do
    bottomItem:DOKill()
  end
  ;
  ((self.ui).rect_TexProjectionTop):DOKill()
  ;
  ((self.ui).rect_neuralCloud):DOKill()
  ;
  ((self.ui).rect_TexProjectionBottom):DOKill()
  ;
  ((self.ui).rect_Stripe):DOKill()
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
    self.l2dBinding = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  self:StopGetHeroCv()
  self.heroId = nil
  ;
  (base.OnDelete)(self)
end

return UIGetHeroSkin

