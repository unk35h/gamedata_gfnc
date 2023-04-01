-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessMainTop_PressPanelEffectItem = {}
local base = UIBaseNode
local UINWarChessMainTop_PressPanelEffectItem = class("UINWarChessMainTop_PressPanelEffectItem", UIBaseNode)
UINWarChessMainTop_PressPanelEffectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessMainTop_PressPanelEffectItem.RefreshWCPressEffectItem = function(self, stressCfg)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(stressCfg.describe)
end

UINWarChessMainTop_PressPanelEffectItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessMainTop_PressPanelEffectItem

