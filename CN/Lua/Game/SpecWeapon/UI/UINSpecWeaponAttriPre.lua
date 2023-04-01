-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponAttriPre = class("UINSpecWeaponAttriPre", UIBaseNode)
local base = UIBaseNode
local UINHeroTalentNodeDetailEffect = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailEffect")
local UINSpecWeaponSkillItem = require("Game.SpecWeapon.UI.UINSpecWeaponSkillItem")
local HeroSkillData = require("Game.PlayerData.Skill.HeroSkillData")
UINSpecWeaponAttriPre.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroTalentNodeDetailEffect, UINSpecWeaponSkillItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).tween_root).onRewind):AddListener(BindCallback(self, self.__OnMoveTweenRewind))
  self._attriPool = (UIItemPool.New)(UINHeroTalentNodeDetailEffect, (self.ui).attItem)
  ;
  ((self.ui).attItem):SetActive(false)
  self._skillPool = (UIItemPool.New)(UINSpecWeaponSkillItem, (self.ui).texDescItem)
  ;
  ((self.ui).texDescItem):SetActive(false)
end

UINSpecWeaponAttriPre.InitSpecWeaponAttriPre = function(self, specWeaponData, heroData, resloader, skillIntroCallback, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._specWeaponData = specWeaponData
  self._skillIntroCallback = skillIntroCallback
  self._resloader = resloader
  self._closeCallback = closeCallback
  self._heroData = heroData
  local baseCfg = (self._specWeaponData):GetSpecWeaponBasicCfg()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self._heroData):GetName()
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroTip).text = (LanguageUtil.GetLocaleText)(baseCfg.name)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)(baseCfg.describe)
  ;
  (((self.ui).img_HeroPic).gameObject):SetActive(false)
  local path = PathConsts:GetCharacterPicPath((self._heroData):GetResPicName())
  ;
  (self._resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    ;
    (((self.ui).img_HeroPic).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPic).texture = texture
  end
)
end

UINSpecWeaponAttriPre.OpenSpecWeaponAttriPre = function(self, lock)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  if lock then
    (((self.ui).text_stage).text).text = ""
    ;
    ((self.ui).heroNode):SetActive(false)
  else
    ;
    ((self.ui).heroNode):SetActive(true)
    self:__Refresh()
  end
  if self.canClose ~= false then
    self.canClose = false
    ;
    ((self.ui).tween_root):DORewind()
    ;
    ((self.ui).tween_root):DOPlayForward()
  end
end

UINSpecWeaponAttriPre.__Refresh = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local step = (self._specWeaponData):GetSpecWeaponCurStep()
  local level = (self._specWeaponData):GetSpecWeaponCurLevel()
  ;
  ((self.ui).text_stage):SetIndex(0, (LanguageUtil.GetRomanNumber)(step), tostring(level))
  self:__RefreshAttri(step, level)
  self:__RefreshSkill(step, level)
end

UINSpecWeaponAttriPre.__RefreshAttri = function(self, step, level)
  -- function num : 0_4 , upvalues : _ENV
  (self._attriPool):HideAll()
  local nowAttriDic = (self._specWeaponData):GetSpecWeaponAttriAddtion()
  local nowShowDic = {}
  for attriId,_ in pairs(nowAttriDic) do
    local attriCfg = (ConfigData.attribute)[attriId]
    local showAttriId = attriCfg.merge_attribute > 0 and attriCfg.merge_attribute or attriId
    if nowShowDic[showAttriId] == nil then
      nowShowDic[showAttriId] = (self._heroData):GetAttr(showAttriId, false, true)
    end
  end
  ;
  (self._specWeaponData):RefreshSpecWeapon(0, 0)
  for attriId,v in pairs(nowShowDic) do
    local item = (self._attriPool):GetOne()
    local oriAttriVal = (self._heroData):GetAttr(attriId, false, true)
    item:RefreshDetailEffectByAttriId(attriId, v - oriAttriVal, nil, false)
  end
  ;
  (self._specWeaponData):RefreshSpecWeapon(step, level)
end

UINSpecWeaponAttriPre.__RefreshSkill = function(self, step, level)
  -- function num : 0_5 , upvalues : _ENV, HeroSkillData
  (self._skillPool):HideAll()
  local nowStepCfg = (self._specWeaponData):GetSpecWeaponStepCfg(step)
  local hasReplaceSkill = (table.count)(nowStepCfg.replaceSkillDic)
  if not hasReplaceSkill then
    ((self.ui).skillNode):SetActive(false)
    return 
  end
  ;
  ((self.ui).skillNode):SetActive(true)
  for i = 1, step do
    local stepCfg = (self._specWeaponData):GetSpecWeaponStepCfg(i)
    do
      for i,skillId in ipairs(stepCfg.new_skills) do
        do
          local item = (self._skillPool):GetOne()
          local desCfg = (ConfigData.spec_weapon_skill_des)[skillId]
          local skillData = (HeroSkillData.New)(skillId, self._heroData)
          skillData:UpdateSkill(1)
          local desStr = (LanguageUtil.GetLocaleText)(desCfg.new_skill_describe)
          item:InitSpecWeaponSkilDes(skillData, desStr, self._resloader, function()
    -- function num : 0_5_0 , upvalues : self, skillId, stepCfg, i
    if self._skillIntroCallback ~= nil then
      (self._skillIntroCallback)(skillId, (stepCfg.last_skills)[i])
    end
  end
)
        end
      end
    end
  end
end

UINSpecWeaponAttriPre.OnClickSkillIntro = function(self)
  -- function num : 0_6
  if self._skillIntroCallback ~= nil then
    (self._skillIntroCallback)()
  end
end

UINSpecWeaponAttriPre.OnClosePreView = function(self)
  -- function num : 0_7
  self.canClose = true
  ;
  ((self.ui).tween_root):DOPlayBackwards()
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
end

UINSpecWeaponAttriPre.__OnMoveTweenRewind = function(self)
  -- function num : 0_8
  if self.canClose then
    self.canClose = false
    self:Hide()
  end
end

UINSpecWeaponAttriPre.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  ((self.ui).tween_root):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINSpecWeaponAttriPre

