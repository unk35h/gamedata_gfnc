-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessBuffDetail = class("UINWarChessBuffDetail", UIBaseNode)
local base = UIBaseNode
UINWarChessBuffDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessBuffDetail.InitEpBuffDetail = function(self, dynEpBuffData)
  -- function num : 0_1 , upvalues : _ENV
  local buffIcon = dynEpBuffData:GetWCBuffIcon()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  if not (string.IsNullOrEmpty)(buffIcon) then
    ((self.ui).img_Icon).sprite = CRH:GetSprite(buffIcon, CommonAtlasType.ExplorationIcon)
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = dynEpBuffData:GetWCBuffName()
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = dynEpBuffData:GetWCBuffDes()
end

UINWarChessBuffDetail.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessBuffDetail

