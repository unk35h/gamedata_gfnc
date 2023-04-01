-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtHeroInfoItem = class("UINFmtHeroInfoItem", UIBaseNode)
local base = UIBaseNode
local UINFmtHeroHpBarItem = require("Game.Formation.UI.2DFormation.UINFmtHeroHpBarItem")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local UIHeroUtil = require("Game.CommonUI.Hero.UIHeroUtil")
local cs_tweening = (CS.DG).Tweening
UINFmtHeroInfoItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SpecIcon, self, self.OnFmtSpecIconClicked)
  self.potentialImgWidth = ((((self.ui).img_Limit).sprite).textureRect).width
  self.limitInfoWith = (((self.ui).rect_limitInfo).sizeDelta).x
  ;
  (((self.ui).img_star).gameObject):SetActive(false)
  self.starList = {}
  ;
  ((self.ui).hPBar):SetActive(false)
end

UINFmtHeroInfoItem.InitFmtHeroInfo = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_1
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  self.isVirtualData = (self.enterFmtData):IsFmtCtrlVirtualFmtData()
end

UINFmtHeroInfoItem.RefreshFmtheroInfo = function(self, heroData, position, onlyPos)
  -- function num : 0_2
  local oldHeroData = self.heroData
  self.heroData = heroData
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  if position ~= nil then
    (self.transform).anchoredPosition = position
  end
  if onlyPos then
    return 
  end
  self:__TryRefreshHeroStaticInfo(oldHeroData)
  self:__TryRefreshStar()
  self:__TryRefreshSupport()
  self:__TryRefreshPotential()
  self:__TryUpdFmtHeroInfoItemHp()
  self:InitRefreshReddotTip()
  self:RefreshLevelTip()
  self:SetFmtHeroInfoItemLv((self.heroData).level)
end

UINFmtHeroInfoItem.__TryRefreshHeroStaticInfo = function(self, oldHeroData)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  if oldHeroData ~= self.heroData then
    ((self.ui).img_Career).sprite = CRH:GetSprite(((self.heroData):GetCareerCfg()).icon, CommonAtlasType.CareerCamp)
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (self.heroData):GetName()
  end
end

UINFmtHeroInfoItem.__TryRefreshStar = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for k,v in ipairs(self.starList) do
    (v.gameObject):SetActive(false)
    v:SetIndex(0)
  end
  local star = (self.heroData).star
  local count = (math.ceil)(star / 2)
  local isHalf = star % 2 == 1
  for i = 1, count do
    local star = (self.starList)[i]
    if star == nil then
      star = ((((self.ui).img_star).gameObject):Instantiate()):GetComponent(typeof(CS.UiImageItemInfo))
      ;
      (table.insert)(self.starList, star)
    end
    ;
    (star.gameObject):SetActive(true)
    if isHalf and i == count then
      star:SetIndex(1)
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINFmtHeroInfoItem.__TryRefreshSupport = function(self, oldHeroData)
  -- function num : 0_5
  ((self.ui).obj_isSupport):SetActive((self.heroData).isFriendSupport)
end

UINFmtHeroInfoItem.__TryUpdFmtHeroInfoItemHp = function(self)
  -- function num : 0_6 , upvalues : UINFmtHeroHpBarItem, _ENV
  if not (self.enterFmtData):IsFmtInBattleDeploy() then
    return 
  end
  if self.hpBarItem == nil then
    self.hpBarItem = (UINFmtHeroHpBarItem.New)()
    ;
    (self.hpBarItem):Init((self.ui).hPBar)
    ;
    (self.hpBarItem):Show()
  end
  local fmtDungeonDyncData = (self.enterFmtData):GetFmtDungeonDyncData()
  local hpPer = fmtDungeonDyncData:GetDungeonDyncHeroHpPer(self.heroData)
  local maxHp = (self.heroData):GetAttr(eHeroAttr.maxHp)
  ;
  (self.hpBarItem):InitFmtHeroHpBarItem(hpPer, maxHp)
end

UINFmtHeroInfoItem.SetFmtHeroInfoItemLv = function(self, level)
  -- function num : 0_7 , upvalues : _ENV, UIHeroUtil
  ((self.ui).tex_HeroLevel):SetIndex(0, tostring(level))
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).tex_HeroLevel).text).color = (UIHeroUtil.GetHeroLevelColor)(level)
end

UINFmtHeroInfoItem.__TryRefreshPotential = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local potentialMaxNum = (self.heroData):GetMaxPotential(true)
  local potential = (self.heroData).potential
  potentialMaxNum = (math.max)(potential, potentialMaxNum)
  local size = (((self.ui).img_LimitUp_empty).rectTransform).sizeDelta
  size.x = self.potentialImgWidth * potentialMaxNum
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_LimitUp_empty).rectTransform).sizeDelta = size
  local size = ((self.ui).rect_limitInfo).sizeDelta
  size.x = self.limitInfoWith + (potentialMaxNum - 5) * self.potentialImgWidth * 0.25
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rect_limitInfo).sizeDelta = size
  local vec = (((self.ui).img_Limit).rectTransform).sizeDelta
  vec.x = self.potentialImgWidth * potential
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).img_Limit).rectTransform).sizeDelta = vec
end

UINFmtHeroInfoItem.SetChangeMarkState = function(self, flag)
  -- function num : 0_9 , upvalues : _ENV
  if not IsNull((self.ui).tween_CanChange) and not (self.heroData).isFixedFmtHero then
    (((self.ui).tween_CanChange).gameObject):SetActive(flag)
    if flag then
      ((self.ui).tween_CanChange):DORestart()
    else
      ;
      ((self.ui).tween_CanChange):DOPause()
    end
  end
end

UINFmtHeroInfoItem.SetFmtSpecialGameHeroActive = function(self, sepcShowType)
  -- function num : 0_10 , upvalues : ExplorationEnum
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

UINFmtHeroInfoItem.OnFmtSpecIconClicked = function(self)
  -- function num : 0_11 , upvalues : ExplorationEnum, _ENV
  if self.__sepcShowType == (ExplorationEnum.SpecGameTypeAdapter).TD then
    local infoStr = ""
    do
      local specCfg = ((ConfigData.skill_adapter).td_adapter)[(self.heroData).dataId]
      if specCfg ~= nil then
        infoStr = (LanguageUtil.GetLocaleText)(specCfg.adapter_desc)
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_11_0 , upvalues : infoStr, _ENV
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

UINFmtHeroInfoItem.FmtHeroAblePotential = function(self)
  -- function num : 0_12
  if self.isVirtualData then
    return false
  end
  return self.__heroAblePotential
end

UINFmtHeroInfoItem.RefreshLevelTip = function(self)
  -- function num : 0_13
  self.__heroAblePotential = false
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).img_CanLevelUp).image).enabled = false
  if self.heroData == nil or self.isVirtualData then
    return 
  end
  if (self.heroData).isFriendSupport or (self.heroData).isFixedFmtHero then
    return 
  end
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R1 in 'UnsetPending'

  if (self.heroData):CanHeroUsePotential() and not (self.heroData):IsHeroLongTrailLevel() then
    (((self.ui).img_CanLevelUp).image).enabled = true
    ;
    ((self.ui).img_CanLevelUp):SetIndex(1)
    self.__heroAblePotential = true
    return 
  end
  if not (self.heroData):AbleUpLevel() then
    return 
  end
  local canLevelUp, _ = (self.heroData):GenHeroCanQuickLevelUp()
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R3 in 'UnsetPending'

  if canLevelUp and not (self.heroData):IsHeroLongTrailLevel() then
    (((self.ui).img_CanLevelUp).image).enabled = true
    ;
    ((self.ui).img_CanLevelUp):SetIndex(0)
  end
end

UINFmtHeroInfoItem.InitRefreshReddotTip = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local ok, redNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.HeroWindow, (self.heroData).dataId, RedDotStaticTypeId.HeroStarUp)
  if ok then
    if self.__refreshAbleUpStar == nil then
      self.__refreshAbleUpStar = function(node)
    -- function num : 0_14_0 , upvalues : self
    self:RefreshReddotTip()
  end

      RedDotController:AddListener(redNode.nodePath, self.__refreshAbleUpStar)
    end
    self:RefreshReddotTip()
  end
end

UINFmtHeroInfoItem.__RemoveRefreshReddotTip = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.__refreshAbleUpStar ~= nil then
    local ok, redNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.HeroWindow, (self.heroData).dataId, RedDotStaticTypeId.HeroStarUp)
    if ok then
      RedDotController:RemoveListener(redNode.nodePath, self.__refreshAbleUpStar)
    end
    self.__refreshAbleUpStar = nil
  end
end

UINFmtHeroInfoItem.RefreshReddotTip = function(self)
  -- function num : 0_16 , upvalues : _ENV, cs_tweening
  local isShow = false
  do
    if self.heroData ~= nil and not self.isVirtualData then
      local ok, redNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.HeroWindow, (self.heroData).dataId, RedDotStaticTypeId.HeroStarUp)
      if ok and redNode:GetRedDotCount() > 0 then
        isShow = true
      end
    end
    if (self.heroData).isFriendSupport or (self.heroData).isFixedFmtHero then
      isShow = false
    end
    if isShow and (self.heroData):AbleUpgradeStar() then
      if self.extraStar == nil then
        self.extraStar = ((((self.ui).img_star).gameObject):Instantiate()):GetComponent(typeof(CS.UiImageItemInfo))
      end
      if (self.heroData):IsHalfStar() then
        local index = 1
        for i = 1, #self.starList do
          if not (((self.starList)[i]).gameObject).activeSelf then
            index = i - 1
            break
          end
          if i == #self.starList then
            index = i
          end
        end
        do
          do
            local parentTr = ((self.starList)[index]).transform
            ;
            ((self.extraStar).transform):SetParent(parentTr)
            -- DECOMPILER ERROR at PC93: Confused about usage of register: R4 in 'UnsetPending'

            ;
            ((self.extraStar).transform).localPosition = Vector3.zero
            ;
            (self.extraStar):SetIndex(0)
            ;
            ((self.extraStar).transform):SetParent((((self.ui).img_star).transform).parent)
            ;
            ((self.extraStar).transform):SetAsLastSibling()
            ;
            (self.extraStar):SetIndex(1)
            if self.extraStarTween ~= nil then
              (self.extraStarTween):Rewind()
              ;
              (self.extraStarTween):Kill()
              self.extraStarTween = nil
            end
            ;
            ((self.extraStar).gameObject):SetActive(true)
            self.extraStarTween = (((self.extraStar).image):DOFade(0.2, 0.5)):SetLoops(-1, (cs_tweening.LoopType).Yoyo)
            if self.extraStarTween ~= nil then
              (self.extraStarTween):Rewind()
              ;
              (self.extraStarTween):Kill()
              self.extraStarTween = nil
            end
            if self.extraStar ~= nil then
              ((self.extraStar).gameObject):SetActive(false)
            end
          end
        end
      end
    end
  end
end

UINFmtHeroInfoItem.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  self:__RemoveRefreshReddotTip()
  if self.extraStarTween ~= nil then
    (self.extraStarTween):Rewind()
    ;
    (self.extraStarTween):Kill()
    self.extraStarTween = nil
  end
  if self.hpBarItem ~= nil then
    (self.hpBarItem):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINFmtHeroInfoItem

