-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWCEnemySkillItem = class("UIWCEnemySkillItem", UIBaseNode)
local base = UIBaseNode
UIWCEnemySkillItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Item, self, self._OnValueChange)
end

UIWCEnemySkillItem.InitEnemySkillIntroItem = function(self, skillData, onClickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._onClickCallback = onClickCallback
  self._skillData = skillData
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_SkillIcon).sprite = CRH:GetSprite(skillData:GetIcon(), CommonAtlasType.SkillIcon)
  local skillTag = skillData:GetSkillTag()
  ;
  ((self.ui).img_SkillTypeLine):SetIndex(skillTag)
  ;
  ((self.ui).img_SkillType):SetIndex(skillTag)
  local col = eBattleSkillTypeColor[skillData:GetBattleSkillTypeColor()]
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

  if col ~= nil then
    (((self.ui).img_SkillType).image).color = eBattleSkillTypeColor[skillData:GetBattleSkillTypeColor()]
  else
    error((string.format)("Can\'t find type color by battleSkill skillId:%s typeColorId:%s", skillData.dataId, skillData:GetBattleSkillTypeColor()))
  end
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillName).text = skillData:GetName()
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillDesc).text = skillData:GetLevelDescribe(nil, nil, false)
  self:SetRefreshSelectUI(false)
end

UIWCEnemySkillItem._OnValueChange = function(self, value)
  -- function num : 0_2
  self:SetRefreshSelectUI(value)
  if value ~= true then
    return 
  end
  if self._onClickCallback ~= nil then
    (self._onClickCallback)(self._skillData)
  end
end

UIWCEnemySkillItem.SetRefreshSelectUI = function(self, isOn)
  -- function num : 0_3
  local index = isOn and 1 or 0
  ;
  ((self.ui).Img_Select):SetIndex(index)
  if not isOn or not (self.ui).col_SkillNameWhite then
    local nameCol = (self.ui).col_SkillNameBlack
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

UIWCEnemySkillItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UIWCEnemySkillItem

