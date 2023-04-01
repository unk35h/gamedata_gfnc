-- params : ...
-- function num : 0 , upvalues : _ENV
local UIArmaInscriptaQuickEnhance = class("UIArmaInscriptaQuickEnhance", UIBaseWindow)
local base = UIBaseWindow
local UINHeroTalentNodeDetailCost = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailCost")
local UINHeroTalentNodeDetailEffect = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailEffect")
UIArmaInscriptaQuickEnhance.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroTalentNodeDetailCost, UINHeroTalentNodeDetailEffect
  (UIUtil.SetTopStatus)(self, self.OnCloseEnhance, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.OnClickBgClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.OnClickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reduce, self, self.OnClickReduce)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self.OnClickAdd)
  ;
  (((self.ui).btn_Reduce).onPress):AddListener(BindCallback(self, self.OnClickReduce))
  ;
  (((self.ui).btn_Add).onPress):AddListener(BindCallback(self, self.OnClickAdd))
  ;
  (UIUtil.AddValueChangedListener)((self.ui).scrollbar, self, self.OnChangeValueLv)
  self._OnItemChangeFunc = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  self._heroChipPool = (UIItemPool.New)(UINHeroTalentNodeDetailCost, (self.ui).heroNode)
  self._costItemPool = (UIItemPool.New)(UINHeroTalentNodeDetailCost, (self.ui).itemNode)
  self._attriPool = (UIItemPool.New)(UINHeroTalentNodeDetailEffect, (self.ui).attriItem)
  ;
  ((self.ui).heroNode):SetActive(false)
  ;
  ((self.ui).itemNode):SetActive(false)
  ;
  ((self.ui).attriItem):SetActive(false)
end

UIArmaInscriptaQuickEnhance.InitQuickEnhance = function(self, heroData, specWeapon, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._heroData = heroData
  self._specWeapon = specWeapon
  self._callback = callback
  self._maxAddLevel = 0
  self._addLevel = 0
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_CurrLimit).text = tostring((self._specWeapon):GetSpecWeaponCurLevel())
  self:__CalMaxLevel()
  self:__RefreshSelectLevel(1)
end

UIArmaInscriptaQuickEnhance.__CalMaxLevel = function(self)
  -- function num : 0_2
  self._maxAddLevel = (self._specWeapon):GetSpecWeaponMultipleUprageTargetLevel() - (self._specWeapon):GetSpecWeaponCurLevel()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollbar).minValue = 1
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollbar).maxValue = self._maxAddLevel
end

UIArmaInscriptaQuickEnhance.__RefreshSelectLevel = function(self, level, isFromSlider)
  -- function num : 0_3 , upvalues : _ENV
  self._addLevel = (math.floor)(level)
  local targetLevel = (self._specWeapon):GetSpecWeaponCurLevel() + self._addLevel
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_NextLimit).text = tostring(targetLevel)
  self:__RefreshCost()
  self:__RefreshAttribute()
end

UIArmaInscriptaQuickEnhance.__RefreshAttribute = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self._attriPool):HideAll()
  local curLevel = (self._specWeapon):GetSpecWeaponCurLevel()
  local targetLevel = curLevel + self._addLevel
  local targetCfg = (self._specWeapon):GetSpecWeaponLevelCfg(targetLevel)
  local curCfg = (self._specWeapon):GetSpecWeaponLevelCfg()
  local attributeDic = {}
  for attributeId,attributeVal in pairs(targetCfg.level_attribute) do
    if (curCfg.level_attribute)[attributeId] == nil or attributeVal - (curCfg.level_attribute)[attributeId] > 0 then
      local attriCfg = (ConfigData.attribute)[attributeId]
      local showAttriId = attriCfg.merge_attribute > 0 and attriCfg.merge_attribute or attributeId
      if attributeDic[showAttriId] == nil then
        attributeDic[showAttriId] = (self._heroData):GetAttr(showAttriId, false, true)
      end
    end
  end
  ;
  (self._specWeapon):RefreshSpecWeapon((self._specWeapon):GetSpecWeaponCurStep(), targetLevel)
  for showAttriId,attributeVal in pairs(attributeDic) do
    local nextVal = (self._heroData):GetAttr(showAttriId, false, true)
    local item = (self._attriPool):GetOne()
    item:RefreshDetailEffectByAttriId(showAttriId, attributeVal, nextVal)
  end
  ;
  (self._specWeapon):RefreshSpecWeapon((self._specWeapon):GetSpecWeaponCurStep(), curLevel)
end

UIArmaInscriptaQuickEnhance.__RefreshCost = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self._costDic = (self._specWeapon):GetSpecWeaponMultipleUprageCost(self._addLevel)
  ;
  (self._costItemPool):HideAll()
  ;
  (self._heroChipPool):HideAll()
  for itemId,itemCount in pairs(self._costDic) do
    local itemCfg = (ConfigData.item)[itemId]
    local item = nil
    if itemCfg.action_type == eItemActionType.HeroCardFrag then
      item = (self._heroChipPool):GetOne()
      ;
      (item.transform):SetAsFirstSibling()
    else
      item = (self._costItemPool):GetOne()
    end
    item:RefresheDetailCost(itemId, itemCount)
  end
end

UIArmaInscriptaQuickEnhance.OnClickAdd = function(self)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  if self._addLevel < self._maxAddLevel then
    ((self.ui).scrollbar).value = self._addLevel + 1
  end
end

UIArmaInscriptaQuickEnhance.OnClickReduce = function(self)
  -- function num : 0_7
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self._addLevel > 1 then
    ((self.ui).scrollbar).value = self._addLevel - 1
  end
end

UIArmaInscriptaQuickEnhance.OnChangeValueLv = function(self, val)
  -- function num : 0_8
  self:__RefreshSelectLevel(val)
end

UIArmaInscriptaQuickEnhance.OnClickConfirm = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if (PlayerDataCenter.allSpecWeaponData):IsSpecWeaponCloseQuickEnhanceTip() then
    (UIUtil.OnClickBack)()
    if self._callback ~= nil then
      (self._callback)(self._addLevel)
    end
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(window)
    -- function num : 0_9_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    local costIds = {}
    local costNums = {}
    for k,v in pairs(self._costDic) do
      (table.insert)(costIds, k)
      ;
      (table.insert)(costNums, v)
    end
    local tip = ConfigData:GetTipContent(5082, (LanguageUtil.GetRomanNumber)((self._specWeapon):GetSpecWeaponCurStep()), tostring((self._specWeapon):GetSpecWeaponCurLevel() + self._addLevel))
    window:ShowItemCostAny(tip, costIds, costNums, function()
      -- function num : 0_9_0_0 , upvalues : _ENV, self
      (UIUtil.OnClickBack)()
      if self._callback ~= nil then
        (self._callback)(self._addLevel)
      end
    end
, nil)
    window:ShowDontRemindTog(function(flag)
      -- function num : 0_9_0_1 , upvalues : _ENV
      (PlayerDataCenter.allSpecWeaponData):SetSpecWeaponCloseQuickEnhanceTip(flag)
    end
, false)
  end
)
end

UIArmaInscriptaQuickEnhance.OnClickCancle = function(self)
  -- function num : 0_10 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIArmaInscriptaQuickEnhance.__ItemUpdate = function(self, itemDic)
  -- function num : 0_11 , upvalues : _ENV
  for k,v in pairs((ConfigData.spec_weapon_basic_config).totalCostIdDic) do
    if itemDic[k] ~= nil then
      self:__CalMaxLevel()
      return 
    end
  end
end

UIArmaInscriptaQuickEnhance.OnClickBgClose = function(self)
  -- function num : 0_12 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIArmaInscriptaQuickEnhance.OnCloseEnhance = function(self)
  -- function num : 0_13
  self:Delete()
end

UIArmaInscriptaQuickEnhance.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  ;
  (base.OnDelete)(self)
end

return UIArmaInscriptaQuickEnhance

