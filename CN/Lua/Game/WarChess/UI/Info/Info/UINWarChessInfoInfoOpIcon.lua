-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoOpIcon = class("UINWarChessInfoInfoOpIcon", base)
local cs_tweening = (CS.DG).Tweening
local cs_Ease = ((CS.DG).Tweening).Ease
UINWarChessInfoInfoOpIcon.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoOpIcon.SetWCIIOpIcon = function(self, iconAtlas, iconName)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).img_opIcon).enabled = iconName ~= nil
  if iconName == nil then
    return 
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_opIcon).sprite = (AtlasUtil.GetResldSprite)(iconAtlas, iconName)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINWarChessInfoInfoOpIcon.OnShow = function(self)
  -- function num : 0_2 , upvalues : base, _ENV, cs_tweening, cs_Ease
  (base.OnShow)(self)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localPosition = Vector3.zero
  ;
  (((self.transform):DOLocalMoveY(10, 1.5)):SetLoops(-1, (cs_tweening.LoopType).Yoyo)):SetEase(cs_Ease.InOutQuad)
end

UINWarChessInfoInfoOpIcon.PlayWCIIIOpIconntoTween = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (self.transform).localScale = Vector3.one
  ;
  ((self.transform):DOScale(0, 0.3)):From()
end

UINWarChessInfoInfoOpIcon.OnHide = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self.transform):DOKill()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localScale = Vector3.one
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localPosition = Vector3.zero
end

UINWarChessInfoInfoOpIcon.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoOpIcon

