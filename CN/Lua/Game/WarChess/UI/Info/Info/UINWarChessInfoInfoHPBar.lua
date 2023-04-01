-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoHPBar = class("UINWarChessInfoInfoHPBar", base)
UINWarChessInfoInfoHPBar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoHPBar.SetWCIIHPBar = function(self, isMonster, rate)
  -- function num : 0_1
  if isMonster then
    ((self.ui).img_light):SetIndex(1)
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_HP).color = (self.ui).hp_monster
  else
    ;
    ((self.ui).img_light):SetIndex(0)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_HP).color = (self.ui).hp_hero
  end
  if rate >= 1 then
    self:Hide()
  else
    self:Show()
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_HP).fillAmount = rate
end

UINWarChessInfoInfoHPBar.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoHPBar

