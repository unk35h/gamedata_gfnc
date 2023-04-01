-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN3DFormationWarningNode = class("UIN3DFormationWarningNode", UIBaseNode)
local base = UIBaseNode
UIN3DFormationWarningNode.ctor = function(self, fmtCtrl)
  -- function num : 0_0
  self.fmtCtrl = fmtCtrl
end

UIN3DFormationWarningNode.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UIN3DFormationWarningNode.OpenWarningTip4WcLevel = function(self)
  -- function num : 0_2
  ((self.ui).twinkle):SetActive(true)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).warningOutLine).color = (self.ui).color_red
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).warningInside).color = (self.ui).color_red
  ;
  ((self.ui).tex_warningDes):SetIndex(0)
end

UIN3DFormationWarningNode.OpenWarningTip4SectorIIMultEffic = function(self)
  -- function num : 0_3
  ((self.ui).twinkle):SetActive(false)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).warningOutLine).color = (self.ui).color_yellow
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).warningInside).color = (self.ui).color_yellow
  ;
  ((self.ui).tex_warningDes):SetIndex(1)
end

UIN3DFormationWarningNode.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UIN3DFormationWarningNode

