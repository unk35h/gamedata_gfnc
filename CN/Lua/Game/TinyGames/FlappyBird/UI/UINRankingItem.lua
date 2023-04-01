-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRankingItem = class("UINRankingItem", UIBaseNode)
local base = UIBaseNode
UINRankingItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINRankingItem.InitWithRankData = function(self, rankingData, index, isMine)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_UserName).text = tostring(rankingData.name)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Sccore).text = tostring(rankingData.score)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Ranking).text = tostring(index)
  ;
  ((self.ui).img_Frame):SetIndex(isMine and 1 or 0)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

  if index > 3 then
    (((self.ui).img_Crown).image).enabled = false
    return 
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_Crown).image).enabled = true
  ;
  ((self.ui).img_Crown):SetIndex(index - 1)
end

UINRankingItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINRankingItem

