-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINEnemyBreakDes = class("UINEnemyBreakDes", base)
UINEnemyBreakDes.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Item, self, self._OnValueChange)
end

UINEnemyBreakDes.InitEnemyBreakDes = function(self, breakCompnt, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._breakCompnt = breakCompnt
  self._clickFunc = clickFunc
  local breakConfig = breakCompnt.breakConfig
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_BkIcon).sprite = CRH:GetSprite(breakConfig.DesIcon, CommonAtlasType.SkillIcon)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_BkName).text = breakConfig.DesName
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_BkDesc).text = breakConfig.Description
  self:UpdEnemyBreakDesSelectUI(false)
end

UINEnemyBreakDes._OnValueChange = function(self, value)
  -- function num : 0_2
  self:UpdEnemyBreakDesSelectUI(value)
  if value ~= true then
    return 
  end
  if self._clickFunc ~= nil then
    (self._clickFunc)(self._breakCompnt)
  end
end

UINEnemyBreakDes.UpdEnemyBreakDesSelectUI = function(self, isOn)
  -- function num : 0_3 , upvalues : _ENV
  local index = isOn and 1 or 0
  ;
  ((self.ui).Img_Select):SetIndex(index)
  if not isOn or not Color.white then
    local nameCol = Color.black
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_BkName).color = nameCol
  if not isOn or not (self.ui).col_DescWhite then
    local descCol = (self.ui).col_DescBlack
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_BkDesc).color = descCol
end

UINEnemyBreakDes.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINEnemyBreakDes

