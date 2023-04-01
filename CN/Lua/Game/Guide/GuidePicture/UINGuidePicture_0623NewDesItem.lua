-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGuidePicture_0623NewDesItem = class("UINGuidePicture_0623NewDesItem", UIBaseNode)
UINGuidePicture_0623NewDesItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINGuidePicture_0623NewDesItem.InitGPNewDesItem = function(self, desCfg)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Number).text = tostring(desCfg.order)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(desCfg.describe)
end

return UINGuidePicture_0623NewDesItem

