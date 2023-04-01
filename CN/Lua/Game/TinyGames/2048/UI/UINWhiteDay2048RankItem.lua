-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDay2048RankItem = class("UINWhiteDay2048RankItem", UIBaseNode)
UINWhiteDay2048RankItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).normalColor = ((self.ui).tex_Name).color
end

UINWhiteDay2048RankItem.Init2048RankItem = function(self, rankingData, index, isMine)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_Name).text = tostring(rankingData.name)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(rankingData.score)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Rank).text = tostring(index)
  ;
  ((self.ui).img_MyRank):SetActive(isMine)
  local color = nil
  if isMine then
    color = Color.white
  else
    color = (self.ui).normalColor
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).color = color
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).color = color
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Rank).color = color
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  if index > 3 then
    (((self.ui).img_Crown).image).enabled = false
    return 
  end
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).img_Crown).image).enabled = true
  ;
  ((self.ui).img_Crown):SetIndex(index - 1)
end

return UINWhiteDay2048RankItem

