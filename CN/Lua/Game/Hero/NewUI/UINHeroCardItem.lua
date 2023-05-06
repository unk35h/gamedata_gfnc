-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroCardItem = class("UINHeroCardItem", UIBaseNode)
local base = UIBaseNode
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local UIHeroUtil = require("Game.CommonUI.Hero.UIHeroUtil")
local cs_Object = (CS.UnityEngine).Object
UINHeroCardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_Object
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroItem, self, self.OnItemClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SpecIcon, self, self.OnSpecIconClicked)
  ;
  (((self.ui).img_OnSelect).gameObject):SetActive(false)
  ;
  (((self.ui).img_star).gameObject):SetActive(false)
  ;
  ((self.ui).obj_isBench):SetActive(false)
  self:SetRedDotActive(false)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).starArr = {}
  for i = 1, (ConfigData.hero_rank).maxStar / 2 do
    local go = (((self.ui).img_star).gameObject):Instantiate()
    go:SetActive(true)
    local imgItemInfo = go:GetComponent(typeof(CS.UiImageItemInfo))
    ;
    (table.insert)((self.ui).starArr, imgItemInfo)
  end
  self:SetEfficiencyActive(false)
  -- DECOMPILER ERROR at PC79: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).potentialImgWidth = ((((self.ui).img_LimitUp).sprite).textureRect).width
  local mat = (cs_Object.Instantiate)(((self.ui).img_Hero).material)
  -- DECOMPILER ERROR at PC87: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Hero).material = mat
  -- DECOMPILER ERROR at PC95: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Camp).material = (cs_Object.Instantiate)(((self.ui).img_Camp).material)
end

UINHeroCardItem.InitHeroCardItem = function(self, heroData, resloader, clickedAction)
  -- function num : 0_1
  self.heroData = heroData
  self.resloader = resloader
  self.onClickedAction = clickedAction
  self.__initTexture = true
  ;
  ((self.ui).talent):SetActive(false)
  ;
  ((self.ui).img_SpecWeapon):SetActive(false)
  self:RefreshHeroCardItem()
end

UINHeroCardItem.RefreshHeroCardItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.heroData == nil then
    return 
  end
  ;
  ((self.ui).obj_Locked):SetActive((self.heroData).isLockedHero)
  if (self.heroData).isLockedHero then
    self:RefreshFragMerge()
  end
  self:__SetStarUI((self.heroData).star)
  self:__SetHeroLevel((self.heroData).level)
  self:__SetPotential(self.heroData)
  ;
  ((self.ui).tex_HeroID):SetIndex(0, tostring((self.heroData).dataId))
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self.heroData):GetName()
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Quality).color = HeroRareColor[(self.heroData).rare]
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_QualityLight).color = HeroRareColor[(self.heroData).rare]
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Career).sprite = CRH:GetSprite(((self.heroData):GetCareerCfg()).icon, CommonAtlasType.CareerCamp)
  if self.__initTexture then
    self.__initTexture = false
    -- DECOMPILER ERROR at PC74: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Hero).enabled = false
    self:UpdateSkin()
    local campIcon = (LanguageUtil.GetLocaleText)(((self.heroData):GetCampCfg()).icon)
    -- DECOMPILER ERROR at PC88: Confused about usage of register: R2 in 'UnsetPending'

    if campIcon ~= nil then
      ((self.ui).img_Camp).enabled = false
      self:__SetTexture(PathConsts:GetCampPicPath(campIcon), (self.ui).img_Camp)
    end
  end
  do
    self:RefreshTalentState()
    self:RefreshSpecWeaponState()
  end
end

UINHeroCardItem.UpdateSkin = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:__SetTexture(PathConsts:GetCharacterPicPath((self.heroData):GetResPicName()), (self.ui).img_Hero, function()
    -- function num : 0_3_0 , upvalues : self
    if (self.heroData).isLockedHero or (self.heroData):GetHeroIsNotHaveLegalSkin() then
      (((self.ui).img_Hero).material):SetFloat("_CoverColorRate", 1)
    else
      ;
      (((self.ui).img_Hero).material):SetFloat("_CoverColorRate", 0)
    end
  end
)
end

UINHeroCardItem.OnItemClicked = function(self)
  -- function num : 0_4
  if self.onClickedAction ~= nil then
    (self.onClickedAction)(self.heroData)
  end
end

UINHeroCardItem.SetRedDotActive = function(self, active)
  -- function num : 0_5
  ((self.ui).redDot):SetActive(active)
end

UINHeroCardItem.SetSelectActive = function(self, active, isbench, isFavor)
  -- function num : 0_6
  (((self.ui).img_OnSelect).gameObject):SetActive(active)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  if active then
    if not isbench or not (self.ui).col_SubSelect then
      ((self.ui).img_OnSelect).color = (self.ui).col_Select
      ;
      ((self.ui).obj_isBench):SetActive(isbench)
      if (self.ui).img_selectIcon ~= nil then
        if isFavor then
          ((self.ui).img_selectIcon):SetIndex(1)
        else
          ;
          ((self.ui).img_selectIcon):SetIndex(0)
        end
      end
    end
  end
end

UINHeroCardItem.SetEfficiencyActive = function(self, active)
  -- function num : 0_7 , upvalues : _ENV
  ((self.ui).obj_efficiency):SetActive(active)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  if active then
    ((self.ui).tex_Efficiency).text = tostring((self.heroData):GetFightingPower())
  end
end

UINHeroCardItem.RefreshFightPower = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if (self.heroData).isLockedHero then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Efficiency).text = tostring((self.heroData):GetFightingPower())
end

UINHeroCardItem.SetSpecialGameHeroActive = function(self, sepcShowType)
  -- function num : 0_9 , upvalues : ExplorationEnum
  self.__sepcShowType = sepcShowType
  ;
  (((self.ui).btn_SpecIcon).gameObject):SetActive(sepcShowType > 0)
  if sepcShowType > 0 then
    ((self.ui).img_SpecIcon):SetIndex(sepcShowType - 1)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_SpecIcon).enabled = sepcShowType == (ExplorationEnum.SpecGameTypeAdapter).TD
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINHeroCardItem.ShowTalentStage = function(self, talentLevel)
  -- function num : 0_10 , upvalues : _ENV
  if (ConfigData.buildinConfig).HeroTalentForbid then
    return 
  end
  ;
  ((self.ui).talent):SetActive(true)
  local stage = ConfigData:GetTalentStage(talentLevel)
  ;
  ((self.ui).img_Talent):SetIndex(stage - 1)
end

UINHeroCardItem.RefreshTalentState = function(self)
  -- function num : 0_11
  local talent = (self.heroData):GetHeroDataTalent()
  if talent == nil then
    return 
  end
  self:ShowTalentStage(talent:GetHeroTalentTotalLevel())
end

UINHeroCardItem.RefreshSpecWeaponState = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local weaponId = (PlayerDataCenter.allSpecWeaponData):GetHeroSpecWeaponId((self.heroData).dataId)
  if weaponId == nil then
    return 
  end
  ;
  ((self.ui).img_SpecWeapon):SetActive(true)
  local specWeaponData = (self.heroData):GetHeroDataSpecWeapon(weaponId)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  if specWeaponData == nil then
    ((self.ui).img_SpecWeaponFade).alpha = 0.6
    ;
    ((self.ui).img_SpecWeaponLV):SetIndex(0)
    return 
  end
  local step = specWeaponData:GetSpecWeaponCurStep()
  ;
  ((self.ui).img_SpecWeaponLV):SetIndex(step)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_SpecWeaponFade).alpha = step == 0 and 0.6 or 1
end

UINHeroCardItem.OnSpecIconClicked = function(self)
  -- function num : 0_13 , upvalues : ExplorationEnum, _ENV
  if self.__sepcShowType == (ExplorationEnum.SpecGameTypeAdapter).TD then
    local infoStr = ""
    do
      local specCfg = ((ConfigData.skill_adapter).td_adapter)[(self.heroData).dataId]
      if specCfg ~= nil then
        infoStr = (LanguageUtil.GetLocaleText)(specCfg.adapter_desc)
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_13_0 , upvalues : infoStr, _ENV
    if window == nil then
      return 
    end
    window:InitCommonInfo(infoStr, ConfigData:GetTipContent(950))
    window:SetCommonInfoFontSize((ConfigData.buildinConfig).SpecHeroInfoFontSize)
  end
)
    end
  end
end

UINHeroCardItem.RefreshFragMerge = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if (self.heroData):IsHeroNotMergeable() then
    ((self.ui).obj_canUnlock):SetActive(false)
    ;
    ((self.ui).obj_chipCount):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_canUnlock):SetActive(true)
  ;
  ((self.ui).obj_chipCount):SetActive(true)
  local couldMerge, curFrage, mergeNeedFrage = (self.heroData):GetIsCouldMerge()
  ;
  ((self.ui).obj_canUnlock):SetActive(couldMerge)
  if couldMerge then
    ((self.ui).tex_ChipCount):SetIndex(0, tostring(curFrage), tostring(mergeNeedFrage))
  else
    ;
    ((self.ui).tex_ChipCount):SetIndex(1, tostring(curFrage), tostring(mergeNeedFrage))
  end
end

UINHeroCardItem.__SetStarUI = function(self, starCount)
  -- function num : 0_15 , upvalues : _ENV
  local count = (math.ceil)(starCount / 2)
  local isHalf = starCount % 2
  for i = 1, count do
    ((((self.ui).starArr)[i]).gameObject):SetActive(true)
    ;
    (((self.ui).starArr)[i]):SetIndex(0)
    if i == count and isHalf == 1 then
      (((self.ui).starArr)[i]):SetIndex(1)
    end
  end
  for i = count + 1, #(self.ui).starArr do
    ((((self.ui).starArr)[i]).gameObject):SetActive(false)
  end
end

UINHeroCardItem.__SetPotential = function(self, heroData)
  -- function num : 0_16
  local potentialMaxNum = heroData:GetMaxPotential(true)
  local size = (((self.ui).img_LimitUp_empty).rectTransform).sizeDelta
  size.x = (self.ui).potentialImgWidth * potentialMaxNum
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_LimitUp_empty).rectTransform).sizeDelta = size
  local potential = heroData.potential
  local vec = (((self.ui).img_LimitUp).rectTransform).sizeDelta
  vec.x = (self.ui).potentialImgWidth * potential
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).img_LimitUp).rectTransform).sizeDelta = vec
end

UINHeroCardItem.__SetHeroLevel = function(self, levelNum)
  -- function num : 0_17 , upvalues : _ENV, UIHeroUtil
  ((self.ui).obj_TrimTex):SetActive(levelNum < 10)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Level).text = tostring(levelNum)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Level).color = (UIHeroUtil.GetHeroLevelColor)(levelNum)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINHeroCardItem.__SetTexture = function(self, path, rawImageGo, callback)
  -- function num : 0_18 , upvalues : _ENV
  local heroData = self.heroData
  ;
  (self.resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_18_0 , upvalues : _ENV, self, heroData, rawImageGo, callback
    if IsNull(self.transform) then
      return 
    end
    if heroData ~= self.heroData then
      return 
    end
    rawImageGo.texture = texture
    rawImageGo.enabled = true
    if callback ~= nil then
      callback()
    end
  end
)
end

UINHeroCardItem.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV, base
  DestroyUnityObject(((self.ui).img_Hero).material)
  DestroyUnityObject(((self.ui).img_Camp).material)
  self.resloader = nil
  ;
  (base.OnDelete)(self)
end

return UINHeroCardItem

