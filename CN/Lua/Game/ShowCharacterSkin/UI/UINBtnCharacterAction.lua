-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBtnCharacterAction = class("UINBtnCharacterAction", UIBaseNode)
local base = UIBaseNode
UINBtnCharacterAction.OnShow = function(self)
  -- function num : 0_0
end

UINBtnCharacterAction.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_House, self, self.OnClick)
end

UINBtnCharacterAction.InitShowCharacterSkin = function(self, index, tipId, callback)
  -- function num : 0_2 , upvalues : _ENV
  self.index = index
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(tipId))
  self.callback = callback
end

UINBtnCharacterAction.OnClick = function(self)
  -- function num : 0_3
  if self.callback then
    (self.callback)(self.index)
  end
end

UINBtnCharacterAction.OnDelete = function(self)
  -- function num : 0_4
end

return UINBtnCharacterAction

