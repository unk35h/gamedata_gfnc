-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeroInfoState = class("UIHeroInfoState", UIBaseWindow)
local base = UIBaseWindow
local UINSupportHeroAth = require("Game.Formation.UI.SupportHeroList.UINSupportHeroAth")
local UINAthSuitMainItem = require("Game.Arithmetic.AthMain.UINAthSuitMainItem")
local UINHeroTag = require("Game.Hero.NewUI.State.UINHeroTag")
local UINHeroAttrItem = require("Game.Formation.UI.Common.UINHeroAttrItem")
local UINSupportHeroSkill = require("Game.Formation.UI.SupportHeroList.UINSupportHeroSkill")
local HeroInfoData = require("Game.Lottery.Data.HeroInfoData")
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local HeroLookTargetController = require("Game.Hero.Live2D.HeroLookTargetController")
local cs_Shadow = ((CS.UnityEngine).UI).Shadow
local cs_tweening = (CS.DG).Tweening
local cs_DOTween = cs_tweening.DOTween
local cs_ResLoader = CS.ResLoader
UIHeroInfoState.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINHeroTag, UINHeroAttrItem, UINSupportHeroAth, UINAthSuitMainItem, UINSupportHeroSkill
  (UIUtil.SetTopStatus)(self, self._OnClickReturn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowIntro, self, self.OnClickFackerTalent)
  self.resloader = (cs_ResLoader.Create)()
  self.startList = {}
  ;
  (table.insert)(self.startList, (self.ui).img_star)
  ;
  (((self.ui).img_star).gameObject):SetActive(false)
  self.tagPool = (UIItemPool.New)(UINHeroTag, (self.ui).tagItem)
  ;
  ((self.ui).tagItem):SetActive(false)
  self.attrPool = (UIItemPool.New)(UINHeroAttrItem, (self.ui).attriItem)
  ;
  ((self.ui).attriItem):SetActive(false)
  self.athPool = (UIItemPool.New)(UINSupportHeroAth, (self.ui).athItem)
  ;
  ((self.ui).athItem):SetActive(false)
  self.athSuitPool = (UIItemPool.New)(UINAthSuitMainItem, (self.ui).suitItem)
  ;
  ((self.ui).suitItem):SetActive(false)
  self.skillItemList = {}
  for i,skillItemObj in ipairs((self.ui).skillItemArr) do
    local item = (UINSupportHeroSkill.New)()
    item:Init(skillItemObj)
    ;
    (table.insert)(self.skillItemList, item)
  end
  for _,tween in ipairs((self.ui).tweens) do
    tween:DOPlay()
  end
  -- DECOMPILER ERROR at PC111: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_tips).text = ConfigData:GetTipContent(317)
  self._onDescribeChange = BindCallback(self, self._OnSupportHeroDescribeChange)
  MsgCenter:AddListener(eMsgEventId.DescribeSettingChange, self._onDescribeChange)
end

UIHeroInfoState.InitHeroInfoState = function(self, heroId)
  -- function num : 0_1 , upvalues : HeroInfoData
  self.heroId = heroId
  self.heroInfo = (HeroInfoData.New)()
  ;
  (self.heroInfo):InitData(self.heroId)
  ;
  (self.heroInfo):GenMaxTalent()
  ;
  (self.heroInfo):GenSpecWeaopn()
  self:RefreshHeroBase()
  self:RefreshHeroDetail()
  self:RefreshHeroSkill()
  self:RefreshTalentState()
end

UIHeroInfoState.RefreshHeroBase = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local heroCfg = (self.heroInfo).heroCfg
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).text = heroCfg.name_en
  ;
  ((self.ui).efficiency):SetActive(false)
  ;
  ((self.ui).img_Carrer):SetIndex(heroCfg.career - 1)
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(((self.heroInfo).heroData).level))
  local rare = ((self.heroInfo).rankCfg).rare
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Quality).color = HeroRareColor[rare]
  local campCfg = (ConfigData.camp)[(self.heroInfo).camp]
  ;
  (((self.ui).img_Camp).gameObject):SetActive(false)
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetCampPicPath(campCfg.icon), function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_Camp).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Camp).texture = texture
  end
)
  self:LoadHeroModel()
  local tags = ((self.heroInfo).heroData):GetHeroTag()
  ;
  (self.tagPool):HideAll()
  for _,tagId in ipairs(tags) do
    local item = (self.tagPool):GetOne()
    item:InitTag(tagId)
  end
end

UIHeroInfoState.LoadHeroModel = function(self)
  -- function num : 0_3 , upvalues : cs_ResLoader, _ENV, HeroCubismInteration
  if self.heroInfo == nil then
    return 
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  self.bigImgResloader = (cs_ResLoader.Create)()
  local picName = (self.heroInfo):GetResPicName()
  local resPath = PathConsts:GetCharacterLive2DPath(picName)
  local isLocked = (HeroCubismInteration.JudgeL2DLocked)((self.heroInfo).skinId)
  local isHaveL2D = (PlayerDataCenter.skinData):IsHaveL2d((self.heroInfo).skinId)
  if isHaveL2D and not isLocked then
    DestroyUnityObject(self.bigImgGameObject)
    ;
    (self.bigImgResloader):LoadABAssetAsync(resPath, function(l2dModelAsset)
    -- function num : 0_3_0 , upvalues : self, _ENV, HeroCubismInteration
    self.bigImgGameObject = l2dModelAsset:Instantiate(((self.ui).heroHolder).transform)
    ;
    ((self.bigImgGameObject).transform):SetLayer(LayerMask.UI)
    local cs_CubismInterationController = ((self.bigImgGameObject).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
    if cs_CubismInterationController ~= nil then
      self.heroCubismInteration = (HeroCubismInteration.New)()
      local heroId = (self.heroInfo).heroId
      local skinId = (self.heroInfo).skinId
      ;
      (self.heroCubismInteration):InitHeroCubism(cs_CubismInterationController, heroId, skinId, UIManager:GetUICamera(), false)
      ;
      (self.heroCubismInteration):SetInterationOpenWait(false)
      ;
      (self.heroCubismInteration):OpenLookTarget(UIManager:GetUICamera())
      ;
      (self.heroCubismInteration):SetRenderControllerSetting(self:GetWindowSortingLayer(), (self.ui).cav_heroHolder, nil, true)
      ;
      (self.heroCubismInteration):SetL2DPosType("HeroSkin", false)
    end
  end
)
  else
    resPath = PathConsts:GetCharacterBigImgPrefabPath(picName)
    DestroyUnityObject(self.bigImgGameObject)
    ;
    (self.bigImgResloader):LoadABAssetAsync(resPath, function(prefab)
    -- function num : 0_3_1 , upvalues : self, _ENV
    self.bigImgGameObject = prefab:Instantiate(((self.ui).heroHolder).transform)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
    do
      if (self.heroInfo):GetHeroInfoIsNotHaveLegalSkin() then
        local rawImage = (self.bigImgGameObject):FindComponent(eUnityComponentID.RawImage)
        rawImage.material = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_heroPicPaperCut)
      end
      self:UpdateHeroShadow()
    end
  end
)
  end
end

UIHeroInfoState.UpdateHeroShadow = function(self)
  -- function num : 0_4 , upvalues : _ENV, cs_Shadow, cs_DOTween
  if IsNull(self.bigImgGameObject) then
    return 
  end
  self.shadow = (self.bigImgGameObject):GetComponent(typeof(cs_Shadow))
  if self.shadow == nil then
    self.shadow = (self.bigImgGameObject):AddComponent(typeof(cs_Shadow))
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.shadow).effectColor = (Color.New)(0, 0, 0, 0.25)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.shadow).effectDistance = Vector2.zero
  local OverDis = (Vector2.New)(-12, -14)
  self.sdTween = (((cs_DOTween.To)(function()
    -- function num : 0_4_0 , upvalues : self
    return (self.shadow).effectDistance
  end
, function(x)
    -- function num : 0_4_1 , upvalues : self
    -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

    (self.shadow).effectDistance = x
  end
, OverDis, 1)):SetEase((((CS.DG).Tweening).Ease).OutExpo)):SetLink((self.shadow).gameObject)
end

UIHeroInfoState.RefreshHeroDetail = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local starCount = ((self.heroInfo).heroData).star / 2
  local isHalfStar = ((self.heroInfo).heroData):IsHalfStar()
  for i = 1, #self.startList do
    local starItem = (self.startList)[i]
    if i < starCount then
      starItem:SetIndex(0)
    else
      if not isHalfStar or not 1 then
        do
          starItem:SetIndex(i ~= starCount or 0)
          ;
          (starItem.gameObject):SetActive(false)
          -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  for i = #self.startList, starCount do
    local starItem = ((((self.ui).img_star).gameObject):Instantiate()):GetComponent(typeof(CS.UiImageItemInfo))
    ;
    (table.insert)(self.startList, starItem)
    ;
    (starItem.gameObject):SetActive(true)
    if i < starCount then
      starItem:SetIndex(0)
    else
      starItem:SetIndex(isHalfStar and 1 or 0)
    end
  end
  local potentialImgWidth = ((((self.ui).img_Breakthrough).sprite).textureRect).width
  local vec = (((self.ui).img_Breakthrough).rectTransform).sizeDelta
  vec.x = potentialImgWidth * ((self.heroInfo).heroData).potential
  -- DECOMPILER ERROR at PC94: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).img_Breakthrough).rectTransform).sizeDelta = vec
  ;
  (self.attrPool):HideAll()
  for k,attrId in ipairs((ConfigData.game_config).supportDetailAttr) do
    local attrValue = ((self.heroInfo).heroData):GetAttr(attrId)
    local item = (self.attrPool):GetOne()
    item:InitHeroAttrItem(attrId, attrValue, nil)
  end
  ;
  ((self.ui).suitList):SetActive(false)
  local athSlotList = ((self.heroInfo).heroData):GetAthSlotList(true)
  for index,space in ipairs(athSlotList) do
    local item = (self.athPool):GetOne()
    item:InitAth(index, space)
  end
  local weaponId, weaponData = ((self.heroInfo).heroData):GetSpecWeaponData()
  if weaponId then
    ((self.ui).obj_SpecWeapon):SetActive(true)
    local heroId = ((self.heroInfo).heroData).dataId
    ;
    (self.resloader):LoadABAssetAsync(PathConsts:GetSpecWeaponPicPath(heroId), function(texture)
    -- function num : 0_5_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    if not texture then
      error("specWeapon icon texture not exit")
      return 
    end
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SpecWeapon).texture = texture
  end
)
    ;
    ((self.ui).obj_WeaponUnlock):SetActive(false)
    if weaponData then
      ((self.ui).img_ArmaLvbg):SetActive(true)
      local step = weaponData:GetSpecWeaponCurStep()
      -- DECOMPILER ERROR at PC184: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).tex_SpecWeaponState).text = (LanguageUtil.GetRomanNumber)(step)
      -- DECOMPILER ERROR at PC193: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).tex_SpecWeaponLv).text = "LV." .. tostring(weaponData:GetSpecWeaponCurLevel())
    else
      do
        do
          ;
          ((self.ui).img_ArmaLvbg):SetActive(false)
          ;
          ((self.ui).obj_WeaponUnlock):SetActive(true)
          ;
          ((self.ui).obj_SpecWeapon):SetActive(false)
        end
      end
    end
  end
end

UIHeroInfoState.RefreshHeroSkill = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local skillDataList = {}
  for i,skillData in ipairs(((self.heroInfo).heroData).skillList) do
    if not skillData:IsCommonAttack() then
      skillData:UpdateSkill(skillData:GetMaxLevel())
      ;
      (table.insert)(skillDataList, skillData)
    end
  end
  for i = 1, #self.skillItemList do
    local item = (self.skillItemList)[i]
    if #skillDataList < i then
      item:Hide()
    else
      item:Show()
      item:InitSupportHeroSkill(skillDataList[i], self.resloader)
    end
  end
end

UIHeroInfoState.RefreshTalentState = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (((self.ui).btn_ShowIntro).gameObject):SetActive(true)
  local talentData = ((self.heroInfo).heroData):GetHeroDataTalent()
  if talentData == nil then
    ((self.ui).talentHolder):SetActive(false)
    return 
  end
  ;
  ((self.ui).talentHolder):SetActive(true)
  local level = talentData:GetHeroTalentTotalLevel()
  local stage, stageDes = ConfigData:GetTalentStage(level)
  ;
  ((self.ui).img_Talent):SetIndex(stage - 1)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_TalentStage).text = stageDes
end

UIHeroInfoState.OnClickFackerTalent = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if ((self.heroInfo).heroData):GetHeroDataTalent() == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroTalent, function(win)
    -- function num : 0_8_0 , upvalues : self
    if win == nil then
      return 
    end
    self:Hide()
    win:InitHeroTalentMain((self.heroInfo).heroData, function()
      -- function num : 0_8_0_0 , upvalues : self
      self:Show()
    end
)
  end
)
end

UIHeroInfoState._OnClickReturn = function(self)
  -- function num : 0_9 , upvalues : _ENV
  for _,tween in ipairs((self.ui).tweens) do
    tween:DOKill()
  end
  self:Delete()
end

UIHeroInfoState._OnSupportHeroDescribeChange = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.skillItemList == nil then
    return 
  end
  for _,item in ipairs(self.skillItemList) do
    item:UpdateLevelDescribe()
  end
end

UIHeroInfoState.OnDeleteEntity = function(self)
  -- function num : 0_11 , upvalues : base, _ENV, HeroCubismInteration
  (base.OnDeleteEntity)(self)
  ;
  (self.tagPool):DeleteAll()
  ;
  (self.attrPool):DeleteAll()
  ;
  (self.athPool):DeleteAll()
  ;
  (self.athSuitPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.heroLoader ~= nil then
    (self.heroLoader):Put2Pool()
    self.heroLoader = nil
  end
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if not IsNull(self.bigImgGameObject) then
    DestroyUnityObject(self.bigImgGameObject)
  end
  if not IsNull(self.l2dModelIns) then
    (HeroCubismInteration.DestroyInterationInstance)(self.l2dModelIns)
  end
  MsgCenter:RemoveListener(eMsgEventId.DescribeSettingChange, self._onDescribeChange)
end

return UIHeroInfoState

