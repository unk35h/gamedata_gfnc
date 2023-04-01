-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22SelectBox = class("UINCarnival22SelectBox", UIBaseNode)
local base = UIBaseNode
UINCarnival22SelectBox.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnival22SelectBox.InitSelectBox = function(self, content, content2)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Details).text = (LanguageUtil.GetLocaleText)(content)
  local content2 = (LanguageUtil.GetLocaleText)(content2)
  if (string.IsNullOrEmpty)(content2) then
    (((self.ui).tex_Sub).gameObject):SetActive(false)
  else
    ;
    (((self.ui).tex_Sub).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Sub).text = content2
  end
end

return UINCarnival22SelectBox

