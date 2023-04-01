-- params : ...
-- function num : 0 , upvalues : _ENV
local UINUltSkillHeroItem = class("UINUltSkillHeroItem", UIBaseNode)
local base = UIBaseNode
local cs_ParentContraint = ((CS.UnityEngine).Animations).ParentConstraint
local cs_ConstraintSource = ((CS.UnityEngine).Animations).ConstraintSource
local cs_MessageCommon = CS.MessageCommon
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINUltSkillHeroItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).btnPlus_Root).onClick):AddListener(BindCallback(self, self.__OnClick))
  ;
  (((self.ui).btnPlus_Root).onPress):AddListener(BindCallback(self, self.__OnLongPress))
  ;
  (((self.ui).btnPlus_Root).onPressUp):AddListener(BindCallback(self, self.__OnPressUp))
  if self.headItem == nil then
    self.headItem = (UINHeroHeadItem.New)()
  end
  ;
  (self.headItem):Init((self.ui).heroHeadItem)
  if (self.ui).fxp_metioned ~= nil then
    self.__MentionEffectCompleted = BindCallback(self, self.MentionEffectCompleted)
    ;
    ((self.ui).fxp_metioned):InitEffectCommon(self.__MentionEffectCompleted, ((self.ui).fxp_metioned).name)
  end
  ;
  (((self.ui).tr_hpBar).gameObject):SetActive(false)
  ;
  ((self.ui).img_Wound):SetActive(false)
  ;
  ((self.ui).img_Dead):SetActive(false)
  self.specialUltActiveEffects = nil
  self.curSpecialUltActiveEffect = nil
  self.__OnCreatSpecialUltHearoEffect = BindCallback(self, self.CreateSpecialUltEffect)
  MsgCenter:AddListener(eMsgEventId.OnCreatSpecialUltHearoEffect, self.__OnCreatSpecialUltHearoEffect)
  self.__OnShowSpeicalUltHearoEffect = BindCallback(self, self.ShowSpecialUltEffect)
  MsgCenter:AddListener(eMsgEventId.OnShowSpeicalUltHearoEffect, self.__OnShowSpeicalUltHearoEffect)
  self.__OnHideSpeicalUltHearoEffect = BindCallback(self, self.HideSpecialUltEffect)
  MsgCenter:AddListener(eMsgEventId.OnHideSpeicalUltHearoEffect, self.__OnHideSpeicalUltHearoEffect)
end

UINUltSkillHeroItem.InitUltSkillHeroItem = function(self, battleSkill, resloader, clickFunc, itemIndex, offsetZ, heroData, fxpCanvas, hpCanvas)
  -- function num : 0_1 , upvalues : _ENV
  if self.__IsInit == nil then
    self.offestPosZ = offsetZ.x - itemIndex * offsetZ.y
    self.offestPosX = ((((self.ui).fxp_metioned).transform).localPosition).x
    self.offestPosY = ((((self.ui).fxp_metioned).transform).localPosition).y
    self.hpOffesPosY = ((((self.ui).hpBarCons).transform).localPosition).y
    TimerManager:StartTimer(5, self.OnLayOutResetPos, self, true, true, true)
    self.__IsInit = true
  end
  self.battleSkill = battleSkill
  self.clickFunc = clickFunc
  self.isSkillNoCD = battleSkill.totalCDTime == 0
  self._hasUltSkill = true
  self.__disable = false
  self.__isShowReturnCD = false
  self.__inUltSkillCd = false
  self.heroId = heroData.dataId
  self.resloader = resloader
  self:_InitHeadItem(heroData, resloader)
  self.fxpCanvas = fxpCanvas
  self.hpCanvas = hpCanvas
  self:HideEffect()
  ;
  (self.headItem):SetHpBarActive(true)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINUltSkillHeroItem.InitHeroUltHeadItem = function(self, heroData, resloader, ultNode)
  -- function num : 0_2
  self._ultNode = ultNode
  self._hasUltSkill = false
  self.heroId = heroData.dataId
  self:_InitHeadItem(heroData, resloader)
end

UINUltSkillHeroItem.OnLayOutResetPos = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).hpBarCons).constraintActive = true
  ;
  (self.headItem):SetHpBarParent((self.hpCanvas).transform)
  local vector3 = ((self.headItem).transform):TransformPoint((Vector3.New)(0, self.hpOffesPosY, 0))
  local posDelta = vector3 - ((self.headItem).transform).position
  ;
  ((self.ui).hpBarCons):SetTranslationOffset(0, posDelta)
  ;
  (((self.ui).fxp_lvl1).transform):SetParent((self.fxpCanvas).transform)
  ;
  (((self.ui).fxp_lvl2).transform):SetParent((self.fxpCanvas).transform)
  vector3 = (self.transform):TransformPoint((Vector3.New)(self.offestPosX, self.offestPosY, self.offestPosZ))
  posDelta = vector3 - (self.transform).position
  ;
  ((self.ui).fxp_lvl1Cons):SetTranslationOffset(0, posDelta)
  ;
  ((self.ui).fxp_lvl2Cons):SetTranslationOffset(0, posDelta)
end

UINUltSkillHeroItem._InitHeadItem = function(self, heroData, resloader)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  (self.gameObject).name = tostring(heroData.dataId)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_CD).enabled = false
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).highlight).enabled = false
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_HasUltimate).enabled = self._hasUltSkill or false
  ;
  (self.headItem):InitHeroHeadItem(heroData, resloader)
  self._heroData = heroData
end

UINUltSkillHeroItem.SetShowUltSkillInfoFunc = function(self, showSkillInfoFunc, hideSkillInfoFunc)
  -- function num : 0_5
  self.showSkillInfoFunc = showSkillInfoFunc
  self.hideSkillInfoFunc = hideSkillInfoFunc
end

UINUltSkillHeroItem.OnUpdateLogic_UltSkillItem = function(self, intensity)
  -- function num : 0_6
  if self.isSkillNoCD then
    return 
  end
  if not self._hasUltSkill then
    return 
  end
  local skill = self.battleSkill
  if skill == nil then
    return 
  end
  if skill:IsReadyToTake() and not (skill.maker):IsAbandonUltSkill() and self.__inUltSkillCd then
    self.__inUltSkillCd = false
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_CD).enabled = false
    if self.__usable then
      self:UltSkillUsable(true, intensity)
    end
  end
  if not self.__inUltSkillCd then
    self:UltSkillUsable(false)
    self.__inUltSkillCd = true
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_CD).enabled = true
  end
  self.curCDRatio = (skill.totalCDTime - skill.UICdTime) / skill.totalCDTime
  self.nextCDRatio = (skill.totalCDTime - skill.NextUICdTime) / skill.totalCDTime
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_CD).fillAmount = self.curCDRatio
end

UINUltSkillHeroItem.OnUpdateRender_UltSkillItem = function(self, deltaTime, interpolation)
  -- function num : 0_7 , upvalues : _ENV
  if self.isSkillNoCD then
    return 
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  if ((self.ui).img_CD).enabled then
    ((self.ui).img_CD).fillAmount = (Mathf.Lerp)(self.curCDRatio, self.nextCDRatio, interpolation)
  end
end

UINUltSkillHeroItem.OnUpdateLogic_ReturnCD = function(self)
  -- function num : 0_8
  if self.__isShowReturnCD then
    if self.lastReturnCD > 0 then
      self.lastReturnCD = self.lastReturnCD - 1
    else
      self:HideHeroReturnCD()
    end
  end
end

UINUltSkillHeroItem.OnUpdateRender_ReturnCD = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.__isShowReturnCD then
    local remainSec = (BattleUtil.FrameToTime)(self.lastReturnCD)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_ReCD).text = tostring(remainSec)
  end
end

UINUltSkillHeroItem.__OnClick = function(self)
  -- function num : 0_10 , upvalues : cs_MessageCommon, _ENV
  if self._hasUltSkill == false and (self._ultNode):IsUltSkillSlotFull() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(620))
  end
  if self.__disable or (BattleUtil.IsBattleInPause)() then
    return 
  end
  if self.clickFunc ~= nil then
    (self.clickFunc)(self.battleSkill)
  end
end

UINUltSkillHeroItem.__OnLongPress = function(self)
  -- function num : 0_11
  if self.showSkillInfoFunc ~= nil then
    (self.showSkillInfoFunc)(self, self.battleSkill, self._heroData)
  end
end

UINUltSkillHeroItem.__OnPressUp = function(self)
  -- function num : 0_12
  if self.hideSkillInfoFunc ~= nil then
    (self.hideSkillInfoFunc)()
  end
end

UINUltSkillHeroItem.UltSkillUsable = function(self, usable, intensity)
  -- function num : 0_13
  if self.battleSkill ~= nil and (self.battleSkill).maker ~= nil and ((self.battleSkill).maker):IsAbandonUltSkill() then
    usable = false
  end
  if self.__usable == usable then
    self.__usable = usable
    if self.__disable or self.__inUltSkillCd then
      usable = false
    end
    ;
    (self.headItem):TransparentHeroHeadItem(not usable)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).highlight).enabled = usable
    if usable then
      local color = ((self.ui).highlight).color
      color.a = intensity
      self:AdjustEffect(intensity)
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).highlight).color = color
    else
      do
        self:HideEffect()
      end
    end
  end
end

UINUltSkillHeroItem.SetAllEfxActive = function(self, activeSelf)
  -- function num : 0_14
  if (((self.ui).fxp_metioned).gameObject).activeSelf ~= activeSelf then
    (((self.ui).fxp_metioned).gameObject):SetActive(activeSelf)
  end
  if ((self.ui).fxp_lvl1).activeSelf ~= activeSelf then
    ((self.ui).fxp_lvl1):SetActive(activeSelf)
  end
  if ((self.ui).fxp_lvl2).activeSelf ~= activeSelf then
    ((self.ui).fxp_lvl2):SetActive(activeSelf)
  end
  if self.curSpecialUltActiveEffect ~= nil and (self.curSpecialUltActiveEffect).activeSelf ~= activeSelf then
    (self.curSpecialUltActiveEffect):SetActive(activeSelf)
  end
end

UINUltSkillHeroItem.ShowEfcMetioned = function(self)
  -- function num : 0_15
  if (self.ui).fxp_metioned ~= nil and not self.__disable then
    ((self.ui).fxp_metioned):PlayWithoutPos()
  end
end

UINUltSkillHeroItem.MentionEffectCompleted = function(self, effect)
  -- function num : 0_16
  if not self.__disable then
    if self.curSpecialUltActiveEffect ~= nil then
      if not (self.curSpecialUltActiveEffect).activeSelf then
        (self.curSpecialUltActiveEffect):SetActive(true)
      end
      if (self.ui).fxp_lvl1 ~= nil and ((self.ui).fxp_lvl1).activeSelf then
        ((self.ui).fxp_lvl1):SetActive(false)
      end
      if (self.ui).fxp_lvl2 ~= nil and ((self.ui).fxp_lvl2).activeSelf then
        ((self.ui).fxp_lvl2):SetActive(false)
      end
      return 
    end
    local intensity = ((self.ui).highlight).color
    if intensity.a >= 0.9 then
      if (self.ui).fxp_lvl1 ~= nil and ((self.ui).fxp_lvl1).activeSelf then
        ((self.ui).fxp_lvl1):SetActive(false)
      end
      if (self.ui).fxp_lvl2 ~= nil and not ((self.ui).fxp_lvl2).activeSelf then
        ((self.ui).fxp_lvl2):SetActive(true)
      end
    else
      if (self.ui).fxp_lvl1 ~= nil and not ((self.ui).fxp_lvl1).activeSelf then
        ((self.ui).fxp_lvl1):SetActive(true)
      end
      if (self.ui).fxp_lvl2 ~= nil and ((self.ui).fxp_lvl2).activeSelf then
        ((self.ui).fxp_lvl2):SetActive(false)
      end
    end
  end
end

UINUltSkillHeroItem.AdjustEffect = function(self, intensity)
  -- function num : 0_17
  if not self.__disable then
    if self.curSpecialUltActiveEffect ~= nil then
      if not (self.curSpecialUltActiveEffect).activeSelf then
        (self.curSpecialUltActiveEffect):SetActive(true)
      end
      if (self.ui).fxp_lvl1 ~= nil and ((self.ui).fxp_lvl1).activeSelf then
        ((self.ui).fxp_lvl1):SetActive(false)
      end
      if (self.ui).fxp_lvl2 ~= nil and ((self.ui).fxp_lvl2).activeSelf then
        ((self.ui).fxp_lvl2):SetActive(false)
      end
      return 
    end
    if intensity >= 1 then
      if (self.ui).fxp_lvl1 ~= nil and ((self.ui).fxp_lvl1).activeSelf then
        ((self.ui).fxp_lvl1):SetActive(false)
      end
      if (self.ui).fxp_lvl2 ~= nil and not ((self.ui).fxp_lvl2).activeSelf then
        ((self.ui).fxp_lvl2):SetActive(true)
      end
    else
      if (self.ui).fxp_lvl1 ~= nil and not ((self.ui).fxp_lvl1).activeSelf then
        ((self.ui).fxp_lvl1):SetActive(true)
      end
      if (self.ui).fxp_lvl2 ~= nil and ((self.ui).fxp_lvl2).activeSelf then
        ((self.ui).fxp_lvl2):SetActive(false)
      end
    end
  end
end

UINUltSkillHeroItem.HideEffect = function(self)
  -- function num : 0_18
  if (self.ui).fxp_lvl1 ~= nil and ((self.ui).fxp_lvl1).activeSelf then
    ((self.ui).fxp_lvl1):SetActive(false)
  end
  if (self.ui).fxp_lvl2 ~= nil and ((self.ui).fxp_lvl2).activeSelf then
    ((self.ui).fxp_lvl2):SetActive(false)
  end
  if self.curSpecialUltActiveEffect ~= nil and (self.curSpecialUltActiveEffect).activeSelf then
    (self.curSpecialUltActiveEffect):SetActive(false)
  end
end

UINUltSkillHeroItem.CreateSpecialUltEffect = function(self, skillDataID, resPath, isAllItem, heroID)
  -- function num : 0_19 , upvalues : _ENV, cs_ParentContraint, cs_ConstraintSource
  if not isAllItem and heroID ~= self.heroId then
    return 
  end
  if self.resloader == nil then
    return 
  end
  if self.specialUltActiveEffects == nil then
    self.specialUltActiveEffects = {}
  end
  if (self.specialUltActiveEffects)[skillDataID] ~= nil then
    return 
  end
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetCharacterPrefab(resPath), function(effectAsset)
    -- function num : 0_19_0 , upvalues : self, _ENV, cs_ParentContraint, cs_ConstraintSource, skillDataID
    if effectAsset == nil then
      return 
    end
    local obj = effectAsset:Instantiate(self.transform)
    local constraint = obj:AddComponent(typeof(cs_ParentContraint))
    local source = cs_ConstraintSource()
    source.weight = 1
    source.sourceTransform = self.transform
    constraint:AddSource(source)
    ;
    (obj.transform):SetParent((self.fxpCanvas).transform)
    local vector3 = (self.transform):TransformPoint((Vector3.New)(self.offestPosX, self.offestPosY, self.offestPosZ))
    local posDelta = vector3 - (self.transform).position
    constraint:SetTranslationOffset(0, posDelta)
    constraint.constraintActive = true
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.specialUltActiveEffects)[skillDataID] = obj
    obj:SetActive(false)
  end
)
end

UINUltSkillHeroItem.ShowSpecialUltEffect = function(self, skillDataID, heroID)
  -- function num : 0_20
  if self.heroId ~= heroID then
    return 
  end
  if self.specialUltActiveEffects == nil then
    return 
  end
  if (self.specialUltActiveEffects)[skillDataID] == nil then
    return 
  end
  if self.curSpecialUltActiveEffect ~= nil and (self.curSpecialUltActiveEffect).activeSelf then
    (self.curSpecialUltActiveEffect):SetActive(false)
  end
  self.curSpecialUltActiveEffect = (self.specialUltActiveEffects)[skillDataID]
  if self.curSpecialUltActiveEffect ~= nil and not (self.curSpecialUltActiveEffect).activeSelf then
    (self.curSpecialUltActiveEffect):SetActive(true)
  end
end

UINUltSkillHeroItem.HideSpecialUltEffect = function(self, skillDataID, heroID)
  -- function num : 0_21
  if self.heroId ~= heroID then
    return 
  end
  if self.specialUltActiveEffects == nil then
    return 
  end
  if (self.specialUltActiveEffects)[skillDataID] == nil then
    return 
  end
  if self.curSpecialUltActiveEffect ~= nil and (self.specialUltActiveEffects)[skillDataID] == self.curSpecialUltActiveEffect then
    if (self.curSpecialUltActiveEffect).activeSelf then
      (self.curSpecialUltActiveEffect):SetActive(false)
    end
    self.curSpecialUltActiveEffect = nil
  end
end

UINUltSkillHeroItem.DeleteAllSpecialEffect = function(self)
  -- function num : 0_22 , upvalues : _ENV
  if self.specialUltActiveEffects ~= nil then
    for k,effectObj in pairs(self.specialUltActiveEffects) do
      DestroyUnityObject(effectObj)
    end
  end
  do
    self.specialUltActiveEffects = nil
    self.curSpecialUltActiveEffect = nil
  end
end

UINUltSkillHeroItem.IsHeroItemDisabled = function(self)
  -- function num : 0_23
  if not self.__disable then
    return self.__inUltSkillCd
  end
end

UINUltSkillHeroItem.DisableUltSkillHeroItem = function(self, disable)
  -- function num : 0_24
  self.__disable = disable
  if disable then
    (self.headItem):TransparentHeroHeadItem(true)
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).highlight).enabled = false
    self:HideEffect()
  else
    ;
    (self.headItem):TransparentHeroHeadItem(not self.__usable)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).highlight).enabled = self.__usable
    if self.__usable then
      self:AdjustEffect((((self.ui).highlight).color).a)
    end
  end
end

UINUltSkillHeroItem.ShowHeroReturnCD = function(self, returnCD)
  -- function num : 0_25
  if self.__isShowReturnCD == true or returnCD == nil then
    return 
  end
  self.__isShowReturnCD = true
  self.lastReturnCD = returnCD
  ;
  ((self.ui).returnCD):SetActive(true)
end

UINUltSkillHeroItem.HideHeroReturnCD = function(self)
  -- function num : 0_26
  if self.__isShowReturnCD then
    self.__isShowReturnCD = false
    ;
    ((self.ui).returnCD):SetActive(false)
  end
end

UINUltSkillHeroItem.SetSideHpBarActive = function(self, bool, rate)
  -- function num : 0_27
  if bool then
    self:__RefreshIsWoundOrDead(rate)
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_hP).fillAmount = rate
  else
    ;
    ((self.ui).img_Wound):SetActive(false)
    ;
    ((self.ui).img_Dead):SetActive(false)
  end
  ;
  (((self.ui).tr_hpBar).gameObject):SetActive(bool)
end

UINUltSkillHeroItem.__RefreshIsWoundOrDead = function(self, rate)
  -- function num : 0_28
  local amount = rate
  local isWound = amount <= 0.3
  local isDead = amount <= 0
  if isWound then
    ((self.ui).img_Wound):SetActive(not isDead)
    ;
    ((self.ui).img_Dead):SetActive(isDead)
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINUltSkillHeroItem.OnHide = function(self)
  -- function num : 0_29
  self.clickFunc = nil
  self.battleSkill = nil
  self.__disable = false
  self.__inUltSkillCd = false
  self.resloader = nil
  self.__isShowReturnCD = false
  self:DeleteAllSpecialEffect()
  self:SetAllEfxActive(false)
  ;
  (self.headItem):SetHpBarActive(false)
end

UINUltSkillHeroItem.OnDelete = function(self)
  -- function num : 0_30 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnCreatSpecialUltHearoEffect, self.__OnCreatSpecialUltHearoEffect)
  MsgCenter:RemoveListener(eMsgEventId.OnShowSpeicalUltHearoEffect, self.__OnShowSpeicalUltHearoEffect)
  MsgCenter:RemoveListener(eMsgEventId.OnHideSpeicalUltHearoEffect, self.__OnHideSpeicalUltHearoEffect)
  ;
  (self.headItem):Delete()
  self.fxpCanvas = nil
  self.hpCanvas = nil
  ;
  (base.OnDelete)(self)
end

return UINUltSkillHeroItem

