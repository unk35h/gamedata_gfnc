-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentNodeDetailEffect = class("UINHeroTalentNodeDetailEffect", UIBaseNode)
local base = UIBaseNode
UINHeroTalentNodeDetailEffect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._defaultColor = ((self.ui).tex_Att).color
end

UINHeroTalentNodeDetailEffect.RefreshDetailEffectByAttriId = function(self, attributeId, curVal, nextVal, showAddSign, showColor)
  -- function num : 0_1 , upvalues : _ENV
  local name, curValStr, icon = ConfigData:GetAttribute(attributeId, curVal)
  local _, nextValStr, _ = ConfigData:GetAttribute(attributeId, nextVal)
  ;
  (((self.ui).img_Icon).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R12 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(icon)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R12 in 'UnsetPending'

  ;
  ((self.ui).tex_Att).text = (LanguageUtil.GetLocaleText)(name)
  if nextValStr ~= nil then
    if showAddSign then
      curValStr = "+" .. curValStr
      nextValStr = "+" .. nextValStr
    end
    ;
    ((self.ui).tex_Addition):SetIndex(0, curValStr, nextValStr)
  else
    if showAddSign then
      curValStr = "+" .. curValStr
    end
    ;
    ((self.ui).tex_Addition):SetIndex(1, curValStr)
  end
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R12 in 'UnsetPending'

  if showColor ~= nil then
    ((self.ui).tex_Att).color = showColor
  else
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.ui).tex_Att).color = self._defaultColor
  end
end

UINHeroTalentNodeDetailEffect.RefreshDetailEffect = function(self, textDes, curValDes, nextValDes, iconName)
  -- function num : 0_2 , upvalues : _ENV
  if iconName == nil then
    (((self.ui).img_Icon).gameObject):SetActive(false)
  else
    ;
    (((self.ui).img_Icon).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSprite(iconName)
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Att).text = textDes
  if (string.IsNullOrEmpty)(nextValDes) then
    ((self.ui).tex_Addition):SetIndex(1, curValDes)
  else
    ;
    ((self.ui).tex_Addition):SetIndex(0, curValDes, nextValDes)
  end
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Att).color = self._defaultColor
end

return UINHeroTalentNodeDetailEffect

