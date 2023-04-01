-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnivalRankItem = class("UINCarnivalRankItem", UIBaseNode)
local base = UIBaseNode
UINCarnivalRankItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnivalRankItem.InitCarnivalItem = function(self, rankingData, index, isMine)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_PlayerName).text = tostring(rankingData.name)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(rankingData.score)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Rank).text = tostring(index)
  ;
  ((self.ui).rankItem):SetIndex(isMine and 0 or 1)
  if index > 3 then
    (((self.ui).img_Crown).gameObject):SetActive(false)
  else
    ;
    (((self.ui).img_Crown).gameObject):SetActive(true)
    ;
    ((self.ui).img_Crown):SetIndex(index - 1)
  end
end

return UINCarnivalRankItem

