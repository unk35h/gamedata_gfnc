-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponLvUp = class("UINSpecWeaponLvUp", UIBaseNode)
local base = UIBaseNode
local UINHeroTalentNodeDetailCost = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailCost")
local UINHeroTalentNodeDetailEffect = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailEffect")
local UINSpecWeaponLockCondItem = require("Game.SpecWeapon.UI.UINSpecWeaponLockCondItem")
local UINSpecWeaponSkillItem = require("Game.SpecWeapon.UI.UINSpecWeaponSkillItem")
local HeroSkillData = require("Game.PlayerData.Skill.HeroSkillData")
local UIAttrUtil = require("Game.CommonUI.Hero.Attr.UIAttrUtil")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local cs_MessageCommon = CS.MessageCommon
UINSpecWeaponLvUp.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpecWeaponLockCondItem, UINHeroTalentNodeDetailCost, UINHeroTalentNodeDetailEffect, UINSpecWeaponSkillItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  self._lockItemPool = (UIItemPool.New)(UINSpecWeaponLockCondItem, (self.ui).unlockTip)
  ;
  ((self.ui).unlockTip):SetActive(false)
  self._costItemPool = (UIItemPool.New)(UINHeroTalentNodeDetailCost, (self.ui).costItem)
  ;
  ((self.ui).costItem):SetActive(false)
  self._heroChipPool = (UIItemPool.New)(UINHeroTalentNodeDetailCost, (self.ui).heroChipItem)
  ;
  ((self.ui).heroChipItem):SetActive(false)
  self._effectItemPool = (UIItemPool.New)(UINHeroTalentNodeDetailEffect, (self.ui).attItem)
  ;
  ((self.ui).attItem):SetActive(false)
  self._skillItemPool = (UIItemPool.New)(UINSpecWeaponSkillItem, (self.ui).texDescItem)
  ;
  ((self.ui).texDescItem):SetActive(false)
  ;
  (((self.ui).tween_root).onRewind):AddListener(BindCallback(self, self.__OnMoveTweenRewind))
  self._confirmBtnColor = ((self.ui).img_Confirm).color
  self._confirmTexColor = (((self.ui).tex_Confirm).text).color
  self.__OnItemUpdateCallback = BindCallback(self, self.__OnItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemUpdateCallback)
end

UINSpecWeaponLvUp.InitSpecWeaponLvUp = function(self, specWeaponData, heroData, lvupCallback, skillIntroCallback, callback)
  -- function num : 0_1
  self._specWeaponData = specWeaponData
  self._heroData = heroData
  self._lvupCallback = lvupCallback
  self._skillIntroCallback = skillIntroCallback
  self._callback = callback
end

UINSpecWeaponLvUp.SetSpecWeaponLvipResloader = function(self, resloader)
  -- function num : 0_2
  self._resloader = resloader
end

UINSpecWeaponLvUp.OpenSpecWeaponLvUp = function(self, selectStep, selectLevel)
  -- function num : 0_3
  if selectStep ~= nil then
    local continueStep = (self._specWeaponData):IsSpecWeaponContinueStep()
    local curStep = (self._specWeaponData):GetSpecWeaponCurStep()
    if continueStep and curStep + 1 == selectStep then
      self:RefreshSpecWeaponLvUp()
    else
      self:__RefreshPreview(selectStep, selectLevel, curStep < selectStep)
    end
  elseif selectLevel ~= nil then
    local continueLevel = (self._specWeaponData):IsSpecWeaponContinueLevel()
    local curLevel = (self._specWeaponData):GetSpecWeaponCurLevel()
    if continueLevel and curLevel + 1 == selectLevel then
      self:RefreshSpecWeaponLvUp()
    else
      self:__RefreshPreview(selectStep, selectLevel, curLevel < selectLevel)
    end
  else
    self:RefreshSpecWeaponLvUp()
  end
  if self.canClose ~= false then
    self.canClose = false
    ;
    ((self.ui).tween_root):DORewind()
    ;
    ((self.ui).tween_root):DOPlayForward()
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINSpecWeaponLvUp.RefreshSpecWeaponLvUp = function(self)
  -- function num : 0_4
  self._curStep = (self._specWeaponData):GetSpecWeaponCurStep()
  self._curLevel = (self._specWeaponData):GetSpecWeaponCurLevel()
  self._isStepUp = (self._specWeaponData):IsSpecWeaponContinueStep()
  self._locked = self._curStep == 0
  ;
  ((self.ui).unlockAction):SetActive(self._locked)
  ;
  ((self.ui).enhancementInfo):SetActive((not self._locked and not self._isStepUp))
  if not self._locked then
    ((self.ui).breakthroughAction):SetActive(self._isStepUp)
    ;
    ((self.ui).costArea):SetActive(true)
    ;
    ((self.ui).btn_Nothing):SetActive(false)
    ;
    (((self.ui).btn_Confirm).gameObject):SetActive(true)
    ;
    (((self.ui).tex_NowLv).gameObject):SetActive(true)
    ;
    ((self.ui).arrow):SetActive(true)
    if self._locked then
      self:__RefreshSkillNode()
      self:__RefreshUnlockNode()
    elseif self._isStepUp then
      self:__RefreshSkillNode()
    else
      self:__RefreshAttrNode()
    end
    self:__RefreshCostNode()
    -- DECOMPILER ERROR: 7 unprocessed JMP targets
  end
end

UINSpecWeaponLvUp.__RefreshPreview = function(self, selectStep, selectLevel, isNext)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).unlockAction):SetActive(false)
  ;
  ((self.ui).btn_Nothing):SetActive(true)
  ;
  (((self.ui).btn_Confirm).gameObject):SetActive(false)
  ;
  (((self.ui).tex_NowLv).gameObject):SetActive(false)
  ;
  ((self.ui).arrow):SetActive(false)
  if not isNext then
    ((self.ui).tex_nothing):SetIndex(0)
  else
    local befrontStep, befrontLevel = (self._specWeaponData):GetSpecWeaponFrontRoot(selectStep, selectLevel)
    ;
    ((self.ui).tex_nothing):SetIndex(1, (LanguageUtil.GetRomanNumber)(befrontStep), tostring(befrontLevel))
  end
  do
    ;
    ((self.ui).enhancementInfo):SetActive(selectLevel ~= nil)
    ;
    ((self.ui).breakthroughAction):SetActive(selectStep ~= nil)
    ;
    ((self.ui).costArea):SetActive(isNext)
    if selectStep ~= nil then
      ((self.ui).tex_SkillTip):SetIndex(2)
      local stepCfg = (self._specWeaponData):GetSpecWeaponStepCfg(selectStep)
      -- DECOMPILER ERROR at PC90: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_NextLv).text = (LanguageUtil.GetRomanNumber)(selectStep)
      self:__RefreshSkillPreview(stepCfg.new_skills, stepCfg.last_skills)
      if isNext then
        self:__RefreshCostPreview(stepCfg.cost_ids, stepCfg.cost_nums)
      end
    else
      ((self.ui).tex_SkillTip):SetIndex(1)
      local levelCfg = (self._specWeaponData):GetSpecWeaponLevelCfg(selectLevel)
      local lastLevelCfg = (self._specWeaponData):GetSpecWeaponLevelCfg(selectLevel - 1)
      -- DECOMPILER ERROR at PC120: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).tex_NextLv).text = tostring(selectLevel)
      self:__RefreshAttPreview(lastLevelCfg, levelCfg)
      if isNext then
        self:__RefreshCostPreview(lastLevelCfg.cost_ids, lastLevelCfg.cost_nums)
      end
    end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

UINSpecWeaponLvUp.__RefreshUnlockNode = function(self)
  -- function num : 0_6 , upvalues : _ENV, CheckerGlobalConfig
  ((self.ui).tex_SkillTip):SetIndex(0)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_NowLv).text = (LanguageUtil.GetRomanNumber)(self._curStep)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_NextLv).text = (LanguageUtil.GetRomanNumber)(self._curStep + 1)
  ;
  (self._lockItemPool):HideAll()
  local basicCfg = (self._specWeaponData):GetSpecWeaponBasicCfg()
  for i,preCond in ipairs(basicCfg.pre_condition) do
    local checker = CheckerGlobalConfig[preCond]
    local para1 = (basicCfg.pre_para1)[i]
    local para2 = (basicCfg.pre_para2)[i]
    local unlockSingle = (checker ~= nil and ((checker.Checker).ParamsCheck)({preCond, para1, para2}))
    local item = (self._lockItemPool):GetOne()
    item:InitLockCond(preCond, para1, para2)
    if not unlockSingle or not (self.ui).color_unlock then
      do
        item:SetLockCondColor((self.ui).color_locked)
        -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINSpecWeaponLvUp.__RefreshSkillNode = function(self)
  -- function num : 0_7 , upvalues : _ENV, HeroSkillData
  ((self.ui).tex_SkillTip):SetIndex(2)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_NowLv).text = (LanguageUtil.GetRomanNumber)(self._curStep)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_NextLv).text = (LanguageUtil.GetRomanNumber)(self._curStep + 1)
  ;
  (self._skillItemPool):HideAll()
  local stepCfg = (self._specWeaponData):GetSpecWeaponStepCfg(self._curStep + 1)
  if stepCfg.new_skills ~= nil then
    for i,skillId in ipairs(stepCfg.new_skills) do
      do
        local skillData = (HeroSkillData.New)(skillId, self._heroData)
        skillData:UpdateSkill(1)
        local item = (self._skillItemPool):GetOne()
        local desCfg = (ConfigData.spec_weapon_skill_des)[skillId]
        local desStr = (LanguageUtil.GetLocaleText)(desCfg.new_skill_describe)
        item:InitSpecWeaponSkilDes(skillData, desStr, self._resloader, function()
    -- function num : 0_7_0 , upvalues : self, skillId, stepCfg, i
    if self._skillIntroCallback ~= nil then
      (self._skillIntroCallback)(skillId, (stepCfg.last_skills)[i])
    end
  end
)
      end
    end
  end
end

UINSpecWeaponLvUp.__RefreshAttrNode = function(self)
  -- function num : 0_8 , upvalues : _ENV, UIAttrUtil
  ((self.ui).tex_SkillTip):SetIndex(1)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_NowLv).text = tostring(self._curLevel)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_NextLv).text = tostring(self._curLevel + 1)
  local nextLevelCfg = (self._specWeaponData):GetSpecWeaponLevelCfg(self._curLevel + 1)
  local nowLevelCfg = (self._specWeaponData):GetSpecWeaponLevelCfg(self._curLevel)
  local nowAttri = {}
  local nextAttri = {}
  for attrId,attrNum in pairs(nextLevelCfg.level_attribute) do
    if nowLevelCfg == nil or (nowLevelCfg.level_attribute)[attrId] ~= attrNum then
      local attriCfg = (ConfigData.attribute)[attrId]
      local showAttriId = attriCfg.merge_attribute > 0 and attriCfg.merge_attribute or attrId
      nowAttri[showAttriId] = (self._heroData):GetAttr(showAttriId, false, true)
    end
  end
  ;
  (self._specWeaponData):RefreshSpecWeapon(self._curStep, self._curLevel + 1)
  for arttri,_ in pairs(nowAttri) do
    nextAttri[arttri] = (self._heroData):GetAttr(arttri, false, true)
  end
  ;
  (self._specWeaponData):RefreshSpecWeapon(self._curStep, self._curLevel)
  ;
  (self._effectItemPool):HideAll()
  local attriIds, attriNums = (UIAttrUtil.GetAttrSortListData)(nowAttri)
  for i,attrId in pairs(attriIds) do
    local attriValue = attriNums[i]
    local item = (self._effectItemPool):GetOne()
    item:RefreshDetailEffectByAttriId(attrId, attriValue, nextAttri[attrId], false)
  end
end

UINSpecWeaponLvUp.__RefreshCostNode = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if (self._specWeaponData):IsSpecWeaponFullLevel() then
    (self._costItemPool):HideAll()
    ;
    (self._heroChipPool):HideAll()
    return 
  end
  local costIds, costNums = (self._specWeaponData):GetSpecWeaponUprageCost()
  ;
  (self._costItemPool):HideAll()
  ;
  (self._heroChipPool):HideAll()
  for i,costId in ipairs(costIds) do
    local costCount = costNums[i]
    local itemCfg = (ConfigData.item)[costId]
    local item = nil
    if itemCfg.action_type == eItemActionType.HeroCardFrag then
      item = (self._heroChipPool):GetOne()
      ;
      (item.transform):SetAsFirstSibling()
    else
      item = (self._costItemPool):GetOne()
    end
    item:RefresheDetailCost(costId, costCount)
  end
  self:__RefershSWConfirmState()
end

UINSpecWeaponLvUp.__RefershSWConfirmState = function(self)
  -- function num : 0_10
  local canLvUp = (self._specWeaponData):IsSpecWeaponCouldUprage()
  ;
  ((self.ui).img_Decorate):SetActive(canLvUp)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  if canLvUp then
    ((self.ui).img_Confirm).color = self._confirmBtnColor
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_Confirm).text).color = self._confirmTexColor
    ;
    ((self.ui).tex_Confirm):SetIndex(0)
  else
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Confirm).color = (self.ui).color_unable
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_Confirm).text).color = (self.ui).color_unableText
    ;
    ((self.ui).tex_Confirm):SetIndex((self._specWeaponData):IsSpecWeaponCouldUnlock() and 1 or 2)
  end
end

UINSpecWeaponLvUp.__RefreshCostPreview = function(self, costIds, costNums)
  -- function num : 0_11 , upvalues : _ENV
  (self._costItemPool):HideAll()
  ;
  (self._heroChipPool):HideAll()
  for i,costId in ipairs(costIds) do
    local costCount = costNums[i]
    local itemCfg = (ConfigData.item)[costId]
    local item = nil
    if itemCfg.action_type == eItemActionType.HeroCardFrag then
      item = (self._heroChipPool):GetOne()
      ;
      (item.transform):SetAsFirstSibling()
    else
      item = (self._costItemPool):GetOne()
    end
    item:RefresheDetailCost(costId, costCount)
  end
end

UINSpecWeaponLvUp.__RefreshSkillPreview = function(self, newSkills, lastSkills)
  -- function num : 0_12 , upvalues : _ENV, HeroSkillData
  (self._skillItemPool):HideAll()
  for i,skillId in ipairs(newSkills) do
    do
      local item = (self._skillItemPool):GetOne()
      local skillData = (HeroSkillData.New)(skillId, self._heroData)
      skillData:UpdateSkill(1)
      local desCfg = (ConfigData.spec_weapon_skill_des)[skillId]
      local desStr = (LanguageUtil.GetLocaleText)(desCfg.new_skill_describe)
      item:InitSpecWeaponSkilDes(skillData, desStr, self._resloader, function()
    -- function num : 0_12_0 , upvalues : self, skillId, lastSkills, i
    if self._skillIntroCallback ~= nil then
      (self._skillIntroCallback)(skillId, lastSkills[i])
    end
  end
)
    end
  end
end

UINSpecWeaponLvUp.__RefreshAttPreview = function(self, lastLevelCfg, levelCfg)
  -- function num : 0_13 , upvalues : _ENV, UIAttrUtil
  local diffAttrMap = {}
  for attrId,attrNum in pairs(levelCfg.level_attribute) do
    local lastValue = 0
    lastValue = lastLevelCfg == nil or (lastLevelCfg.level_attribute)[attrId] or 0
    if lastValue < attrNum then
      diffAttrMap[attrId] = attrNum - (lastValue)
    end
  end
  local attriIds, attriNums = (UIAttrUtil.GetAttrSortListData)(diffAttrMap)
  ;
  (self._effectItemPool):HideAll()
  for i,attriId in ipairs(attriIds) do
    local item = (self._effectItemPool):GetOne()
    local attriValue = attriNums[i]
    item:RefreshDetailEffectByAttriId(attriId, attriValue, nil, false)
  end
end

UINSpecWeaponLvUp.__OnItemUpdate = function(self)
  -- function num : 0_14 , upvalues : _ENV
  for i,v in ipairs((self._heroChipPool).listItem) do
    v:RefreshDetailCostState()
  end
  for i,v in ipairs((self._costItemPool).listItem) do
    v:RefreshDetailCostState()
  end
  self:__RefershSWConfirmState()
end

UINSpecWeaponLvUp.OnClickConfirm = function(self)
  -- function num : 0_15 , upvalues : _ENV, cs_MessageCommon
  if self._locked and not (self._specWeaponData):IsSpecWeaponCouldUnlock() then
    local baseCfg = (self._specWeaponData):GetSpecWeaponBasicCfg()
    local unlockInfos = (CheckCondition.GetUnlockAndInfoList)(baseCfg.pre_condition, baseCfg.pre_para1, baseCfg.pre_para2)
    for i,unlockInfo in ipairs(unlockInfos) do
      if not unlockInfo.unlock then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(unlockInfo.lockReason, true)
      end
    end
    return 
  end
  do
    if not (self._specWeaponData):IsSpecWeaponCouldUprage() then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(252))
      return 
    end
    if self._lvupCallback ~= nil then
      (self._lvupCallback)()
    end
    if (self._specWeaponData):IsSpecWeaponContinueStep() then
      AudioManager:PlayAudioById(1249)
    else
      if (self._specWeaponData):IsSpecWeaponContinueLevel() then
        AudioManager:PlayAudioById(1248)
      else
        AudioManager:PlayAudioById(1247)
      end
    end
  end
end

UINSpecWeaponLvUp.OnCloseLvup = function(self)
  -- function num : 0_16
  self.canClose = true
  ;
  ((self.ui).tween_root):DOPlayBackwards()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UINSpecWeaponLvUp.__OnMoveTweenRewind = function(self)
  -- function num : 0_17
  if self.canClose then
    self.canClose = false
    self:Hide()
  end
end

UINSpecWeaponLvUp.OnDelete = function(self)
  -- function num : 0_18 , upvalues : cs_MessageCommon, _ENV, base
  (cs_MessageCommon.HideAllTips)()
  ;
  ((self.ui).tween_root):DOKill()
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemUpdateCallback)
  ;
  (base.OnDelete)(self)
end

return UINSpecWeaponLvUp

