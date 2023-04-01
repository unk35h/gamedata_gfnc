-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayShiftNodeItem = class("UINWhiteDayShiftNodeItem", UIBaseNode)
local base = UIBaseNode
UINWhiteDayShiftNodeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_optionItem, self, self.__OnClick)
end

UINWhiteDayShiftNodeItem.InitWDShiftItem = function(self, typeCfg, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  if typeCfg == nil then
    self.typeIndex = nil
    ;
    (((self.ui).img_Icon).gameObject):SetActive(false)
    ;
    ((self.ui).tex_Option):SetIndex(1)
  else
    self.typeIndex = typeCfg.group_id
    ;
    (((self.ui).img_Icon).gameObject):SetActive(true)
    ;
    ((self.ui).img_Icon):SetIndex(self.typeIndex - 1)
    ;
    ((self.ui).tex_Option):SetIndex(0, (LanguageUtil.GetLocaleText)(typeCfg.effect_text))
  end
  self.clickCallback = clickCallback
end

UINWhiteDayShiftNodeItem.__OnClick = function(self)
  -- function num : 0_2
  if self.clickCallback ~= nil then
    (self.clickCallback)(self.typeIndex)
  end
end

UINWhiteDayShiftNodeItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayShiftNodeItem

