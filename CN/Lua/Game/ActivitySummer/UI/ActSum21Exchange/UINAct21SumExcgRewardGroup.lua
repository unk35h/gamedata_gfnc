-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAct21SumExcgRewardGroup = class("UINAct21SumExcgRewardGroup", UIBaseNode)
local base = UIBaseNode
UINAct21SumExcgRewardGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINAct21SumExcgRewardGroup.InitAct21SumExcgRewardGroup = function(self, qualityId, usedNum, totalNum)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).title).color = ((self.ui).color_tileBg)[qualityId]
  ;
  ((self.ui).tex_GroupTitle):SetIndex(qualityId - 1)
  ;
  ((self.ui).tex_Total):SetIndex(0, tostring(totalNum - usedNum), tostring(totalNum))
end

UINAct21SumExcgRewardGroup.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINAct21SumExcgRewardGroup

