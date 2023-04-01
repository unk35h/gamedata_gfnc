-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechFinalBG = class("UINCarnival22TechFinalBG", UIBaseNode)
local base = UIBaseNode
UINCarnival22TechFinalBG.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnival22TechFinalBG.InitTechFinalBG = function(self, techLineCfg)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_TitleEN).text = (LanguageUtil.GetLocaleText)(techLineCfg.name_en)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleCN).text = (LanguageUtil.GetLocaleText)(techLineCfg.intro)
end

return UINCarnival22TechFinalBG

