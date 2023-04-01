-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEnemySkillItem = class("UINEnemySkillIntroItem", UIBaseNode)
local base = UIBaseNode
UINEnemySkillItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Item, self, self._OnValueChange)
end

UINEnemySkillItem.InitEnemySkillIntroItem = function(self, skillData, onClickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._onClickCallback = onClickCallback
  self._skillData = skillData
  local monsterLabelid = skillData:GetSkillMonsterLabel()
  local isMonsterLabelSkill = monsterLabelid ~= nil
  ;
  ((self.ui).uINSkillItem):SetActive(not isMonsterLabelSkill)
  ;
  ((self.ui).uINTagItem):SetActive(isMonsterLabelSkill)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R5 in 'UnsetPending'

  if not isMonsterLabelSkill then
    ((self.ui).img_SkillIcon).sprite = CRH:GetSprite(skillData:GetIcon(), CommonAtlasType.SkillIcon)
  else
    local monsterLableCfg = (ConfigData.monster_lable)[monsterLabelid]
    local monsterLableThemeCfg = (ConfigData.monster_lable_theme)[monsterLableCfg.label_theme]
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_mlskillIcon).sprite = CRH:GetSprite(monsterLableThemeCfg.icon, CommonAtlasType.SkillIcon)
    -- DECOMPILER ERROR at PC53: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_monsterLabel).color = (Color.IntArray2Color)(monsterLableThemeCfg.bg)
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_monsterLabelDes).text = (LanguageUtil.GetLocaleText)(monsterLableThemeCfg.theme_des)
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_monsterLabelDes).color = (Color.IntArray2Color)(monsterLableThemeCfg.color)
  end
  local skillTag = skillData:GetSkillTag()
  ;
  ((self.ui).img_SkillTypeLine):SetIndex(skillTag)
  ;
  ((self.ui).img_SkillType):SetIndex(skillTag)
  local col = eBattleSkillTypeColor[skillData:GetBattleSkillTypeColor()]
  -- DECOMPILER ERROR at PC93: Confused about usage of register: R7 in 'UnsetPending'

  if col ~= nil then
    (((self.ui).img_SkillType).image).color = eBattleSkillTypeColor[skillData:GetBattleSkillTypeColor()]
  else
    error((string.format)("Can\'t find type color by battleSkill skillId:%s typeColorId:%s", skillData.dataId, skillData:GetBattleSkillTypeColor()))
  end
  -- DECOMPILER ERROR at PC108: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillName).text = skillData:GetName()
  -- DECOMPILER ERROR at PC115: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillDesc).text = skillData:GetLevelDescribe(nil, nil, false)
  self:SetRefreshSelectUI(false)
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINEnemySkillItem._OnValueChange = function(self, value)
  -- function num : 0_2
  self:SetRefreshSelectUI(value)
  if value ~= true then
    return 
  end
  if self._onClickCallback ~= nil then
    (self._onClickCallback)(self._skillData)
  end
end

UINEnemySkillItem.SetRefreshSelectUI = function(self, isOn)
  -- function num : 0_3 , upvalues : _ENV
  local index = isOn and 1 or 0
  ;
  ((self.ui).Img_Select):SetIndex(index)
  if not isOn or not Color.white then
    local nameCol = Color.black
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillName).color = nameCol
  if not isOn or not (self.ui).col_DescWhite then
    local descCol = (self.ui).col_DescBlack
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillDesc).color = descCol
end

UINEnemySkillItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINEnemySkillItem

