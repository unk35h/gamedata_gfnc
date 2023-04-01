-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseItem = class("UINBaseItem", UIBaseNode)
local base = UIBaseNode
local UINBaseHead = require("Game.CommonUI.Head.UINBaseHead")
local GuideEnum = require("Game.Guide.GuideEnum")
UINBaseItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__IsLoadedGreatLoopFx = false
  self.__GreatLoopFxGo = nil
  self.__IsLoadedGreatBlastFx = false
  self.__GreatBlastFxGo = nil
  self.__lastUseHeadItem = false
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self.OnClickItemRoot)
  self.defaultQual = ((self.ui).Img_Quality).sprite
  self.defaultQualColor = ((self.ui).img_QualityColor).color
end

UINBaseItem.InitBaseItem = function(self, itemCfg, clickEvent, clickExtrEvent, isHideLoopFx)
  -- function num : 0_1 , upvalues : _ENV, UINBaseHead
  self.itemCfg = itemCfg
  self.clickEvent = clickEvent
  self.clickExtrEvent = clickExtrEvent
  self.quality = itemCfg.quality
  self.__athUid = nil
  local useHeadItem = false
  local sprite = CRH:GetSpriteByItemConfig(itemCfg)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

  if itemCfg.type == eItemType.Avatar or itemCfg.type == eItemType.AvatarFrame then
    ((self.ui).Img_Quality).sprite = self.defaultQual
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_QualityColor).color = self.defaultQualColor
    if self.resloader ~= nil then
      useHeadItem = true
    end
  else
    self:_SetItemQuality(itemCfg)
  end
  if self.__lastUseHeadItem ~= useHeadItem then
    self.__lastUseHeadItem = useHeadItem
    ;
    ((self.ui).obj_item):SetActive(not useHeadItem)
    ;
    ((self.ui).obj_baseHead):SetActive(useHeadItem)
  end
  if useHeadItem then
    if self.baseHeadNode == nil then
      self.baseHeadNode = (UINBaseHead.New)()
      ;
      (self.baseHeadNode):Init((self.ui).obj_baseHead)
    end
    if itemCfg.type == eItemType.Avatar then
      (self.baseHeadNode):InitBaseHead(itemCfg.id, self.resloader)
    else
      ;
      (self.baseHeadNode):InitBaseHeadFrame(itemCfg.id, self.resloader)
    end
  else
    -- DECOMPILER ERROR at PC83: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).Img_ItemPic).sprite = sprite
  end
  ;
  ((self.ui).obj_IsFrag):SetActive(false)
  ;
  ((self.ui).obj_isHreo):SetActive(false)
  ;
  (((self.ui).img_isSmallIcon).gameObject):SetActive(false)
  local smallIcon = itemCfg.small_icon
  if itemCfg.action_type == eItemActionType.HeroCardFrag then
    ((self.ui).obj_IsFrag):SetActive(true)
    ;
    ((self.ui).obj_isHreo):SetActive(true)
  else
    if smallIcon ~= "" and smallIcon ~= nil then
      ((self.ui).obj_IsFrag):SetActive(true)
      ;
      (((self.ui).img_isSmallIcon).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC138: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).img_isSmallIcon).sprite = CRH:GetSprite(smallIcon)
    end
  end
  -- DECOMPILER ERROR at PC147: Confused about usage of register: R8 in 'UnsetPending'

  if itemCfg.small_icon_type then
    ((self.ui).img_isSmallIcon).color = ItemQualityColor[itemCfg.quality]
  else
    -- DECOMPILER ERROR at PC153: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_isSmallIcon).color = Color.white
  end
  self:CloseGreatRewardLoopFx()
  local isGreatItem = ((ConfigData.game_config).itemWithGreatFxDic)[itemCfg.id]
  if isGreatItem and not isHideLoopFx then
    if not self.__IsLoadedGreatLoopFx then
      self:LoadGetGreatRewardLoopFx()
    else
      ;
      (self.__GreatLoopFxGo):SetActive(true)
    end
  end
  local limitTimeItemCfg = (ConfigData.item_time_limit)[itemCfg.id]
  if limitTimeItemCfg ~= nil then
    self:SetLimtTimeTagActive(true)
  else
    self:SetLimtTimeTagActive(false)
  end
  self:SetLimtTimeDetailActive(false)
  self.__clickArg = nil
  self:SetItemRecycyleTag(false)
end

UINBaseItem.SetNotNeedAnyJump = function(self, bool)
  -- function num : 0_2
  self.notNeedAnyJump = bool
end

UINBaseItem.SetLimtTimeTagActive = function(self, bValue)
  -- function num : 0_3
  if (self.ui).obj_TimeLimitIcon ~= nil and ((self.ui).obj_TimeLimitIcon).activeSelf ~= bValue then
    ((self.ui).obj_TimeLimitIcon):SetActive(bValue)
  end
end

UINBaseItem.SetLimtTimeDetailActive = function(self, bValue)
  -- function num : 0_4
  if (self.ui).obj_TimeLimitDay ~= nil and ((self.ui).obj_TimeLimitDay).activeSelf ~= bValue then
    ((self.ui).obj_TimeLimitDay):SetActive(bValue)
  end
  if bValue then
    self:SetLimtTimeTagActive(false)
  end
end

UINBaseItem.ShowLimtTimeDetail = function(self, outTime)
  -- function num : 0_5 , upvalues : _ENV
  self:SetLimtTimeDetailActive(true)
  local diffTime = outTime - PlayerDataCenter.timestamp
  if diffTime > 0 then
    local d, h, m, s = TimeUtil:TimestampToTimeInter(diffTime, false, true)
    if d > 0 then
      ((self.ui).tex_TimeLimitText):SetIndex(0, tostring(d))
    else
      if h > 0 then
        ((self.ui).tex_TimeLimitText):SetIndex(1, tostring(h))
      else
        ;
        ((self.ui).tex_TimeLimitText):SetIndex(1, tostring(1))
      end
    end
  else
    do
      ;
      ((self.ui).tex_TimeLimitText):SetIndex(2)
    end
  end
end

UINBaseItem.SetItemNoClickEvent = function(self, bool)
  -- function num : 0_6
  self._noClickEvent = bool
end

UINBaseItem.BindAthItemUid = function(self, uid)
  -- function num : 0_7
  self.__athUid = uid
end

UINBaseItem.BindClickCustomArg = function(self, arg)
  -- function num : 0_8
  self.__clickArg = arg
end

UINBaseItem.BindBaseItemResloader = function(self, resloader)
  -- function num : 0_9
  self.resloader = resloader
end

UINBaseItem.OnClickItemRoot = function(self)
  -- function num : 0_10 , upvalues : _ENV, GuideEnum
  if self._noClickEvent then
    return 
  end
  if self.clickEvent ~= nil then
    (self.clickEvent)(self.itemCfg, self.__clickArg)
  else
    if GuideManager.inGuide and not GuideManager:HasGuideFeature((GuideEnum.GuideFeature).ItemDetail) then
      return 
    end
    local athData = nil
    do
      if self.__athUid ~= nil then
        athData = ((PlayerDataCenter.allAthData).athDic)[self.__athUid]
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_10_0 , upvalues : self, athData
    if win ~= nil then
      win:SetNotNeedAnyJump(self.notNeedAnyJump)
      if athData ~= nil then
        win:InitAthDetail(self.itemCfg, athData)
      else
        win:InitCommonItemDetail(self.itemCfg)
      end
    end
  end
)
    end
  end
  do
    if self.clickExtrEvent ~= nil then
      (self.clickExtrEvent)(self.itemCfg)
    end
  end
end

UINBaseItem.SetIsShowNewTag = function(self, isShow)
  -- function num : 0_11
  ((self.ui).obj_New):SetActive(isShow)
end

UINBaseItem._SetItemQuality = function(self, itemCfg)
  -- function num : 0_12 , upvalues : _ENV
  if itemCfg.heroId ~= nil and itemCfg.type == eItemType.HeroCard then
    local heroCfg = (ConfigData.hero_data)[itemCfg.heroId]
    local rare = ((ConfigData.hero_rank)[heroCfg.rank]).rare
    self.quality = eHeroRareToQaulity[rare]
  end
  do
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).Img_Quality).sprite = CRH:GetSprite(ItemQualitySprite[self.quality], CommonAtlasType.BaseItemQuailty)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_QualityColor).color = ItemQualityColor[self.quality]
  end
end

UINBaseItem.SetPressCallback = function(self, pressEvent, responseOnceByPress)
  -- function num : 0_13
  self.pressEvent = pressEvent
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).btn_Root).responseOnceByPress = responseOnceByPress
  ;
  (((self.ui).btn_Root).onPressUp):AddListener(function()
    -- function num : 0_13_0 , upvalues : self
    (self.pressEvent)(self.itemCfg, false)
  end
)
  ;
  (((self.ui).btn_Root).onPress):AddListener(function()
    -- function num : 0_13_1 , upvalues : self
    (self.pressEvent)(self.itemCfg, true)
  end
)
end

UINBaseItem.GetQuality = function(self)
  -- function num : 0_14
  return self.quality
end

UINBaseItem.LoadGetRewardFx = function(self, resloader, xRotate)
  -- function num : 0_15 , upvalues : _ENV
  local path = ItemEffPatch[(self.itemCfg).quality]
  if self.__qualityFxGoDic == nil then
    self.__qualityFxGoDic = {}
  end
  if (self.__qualityFxGoDic)[(self.itemCfg).quality] ~= nil then
    local go = (self.__qualityFxGoDic)[(self.itemCfg).quality]
    go:SetActive(true)
    local particleSystem = go:GetComponentInChildren(typeof((CS.UnityEngine).ParticleSystem))
    particleSystem:Stop()
    particleSystem:Play()
    return 
  end
  do
    resloader:LoadABAssetAsync(path, function(prefab)
    -- function num : 0_15_0 , upvalues : _ENV, self, xRotate
    if IsNull(prefab) or self.__stop or IsNull(self.transform) then
      return 
    end
    local go = prefab:Instantiate(self.transform)
    local particleSystem = go:GetComponentInChildren(typeof((CS.UnityEngine).ParticleSystem))
    particleSystem:Stop()
    ;
    (go.transform):Rotate((Vector3.New)(xRotate or 0, 0, 0))
    particleSystem:Play()
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__qualityFxGoDic)[(self.itemCfg).quality] = go
  end
)
  end
end

UINBaseItem.LoadGetGreatRewardFx = function(self, resloader, xRotate)
  -- function num : 0_16 , upvalues : _ENV
  if self.__IsLoadedGreatLoopFx then
    (self.__GreatLoopFxGo):SetActive(false)
  end
  if self.__IsLoadedGreatBlastFx then
    (self.__GreatBlastFxGo):SetActive(true)
  end
  local path = ItemEffPatch.greetBlastThenLoop
  resloader:LoadABAssetAsync(path, function(prefab)
    -- function num : 0_16_0 , upvalues : _ENV, self, xRotate
    if IsNull(prefab) or self.__stop or IsNull(self.transform) then
      return 
    end
    local go = prefab:Instantiate(self.transform)
    local particleSystem = go:GetComponentInChildren(typeof((CS.UnityEngine).ParticleSystem))
    particleSystem:Stop()
    ;
    (go.transform):Rotate((Vector3.New)(xRotate or 0, 0, 0))
    particleSystem:Play()
    self.__IsLoadedGreatBlastFx = true
    self.__GreatBlastFxGo = go
  end
)
end

UINBaseItem.LoadGetGreatRewardLoopFx = function(self, xRotate)
  -- function num : 0_17 , upvalues : _ENV
  if not (self.ui).isNeedGreatFX then
    return 
  end
  local prefab = (CRH:GetBaseItemFx()).greetLoop
  if IsNull(prefab) or self.__stop or IsNull(self.transform) then
    return 
  end
  local go = prefab:Instantiate(self.transform)
  local particleSystem = go:GetComponentInChildren(typeof((CS.UnityEngine).ParticleSystem))
  particleSystem:Stop()
  ;
  (go.transform):Rotate((Vector3.New)(xRotate or 0, 0, 0))
  particleSystem:Play()
  self.__IsLoadedGreatLoopFx = true
  self.__GreatLoopFxGo = go
end

UINBaseItem.TrySetGreatRewardLoopFxScale = function(self, Scale)
  -- function num : 0_18
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  if self.__GreatLoopFxGo ~= nil then
    ((self.__GreatLoopFxGo).transform).localScale = Scale
  end
end

UINBaseItem.CloseGreatRewardLoopFx = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if self.__IsLoadedGreatLoopFx then
    (self.__GreatLoopFxGo):SetActive(false)
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.__GreatLoopFxGo).transform).localScale = Vector3.one
  end
  if self.__IsLoadedGreatBlastFx then
    (self.__GreatBlastFxGo):SetActive(false)
  end
end

UINBaseItem.CloseQualityFx = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self.__qualityFxGoDic ~= nil then
    for _,go in pairs(self.__qualityFxGoDic) do
      go:SetActive(false)
    end
  end
end

UINBaseItem.EnableButton = function(self, flag)
  -- function num : 0_21
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).btn_Root).enabled = flag
end

UINBaseItem.SetItemRecycyleTag = function(self, bool)
  -- function num : 0_22 , upvalues : _ENV
  if not IsNull((self.ui).obj_recycleTag) then
    ((self.ui).obj_recycleTag):SetActive(bool)
  end
end

UINBaseItem.OnHide = function(self)
  -- function num : 0_23
  self.__stop = true
end

UINBaseItem.OnDelete = function(self)
  -- function num : 0_24 , upvalues : base
  (base.OnDelete)(self)
end

return UINBaseItem

