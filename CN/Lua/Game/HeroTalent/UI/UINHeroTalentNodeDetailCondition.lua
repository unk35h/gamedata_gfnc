-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentNodeDetailCondition = class("UINHeroTalentNodeDetailCondition", UIBaseNode)
local base = UIBaseNode
UINHeroTalentNodeDetailCondition.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHeroTalentNodeDetailCondition.RefreshDetailCondition = function(self, textDes, unlock)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Condition).text = textDes
  ;
  ((self.ui).img_Root):SetIndex(unlock and 0 or 1)
end

return UINHeroTalentNodeDetailCondition

