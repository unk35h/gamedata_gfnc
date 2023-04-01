-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSnakeGameRankItem = class("UINSnakeGameRankItem", UIBaseNode)
UINSnakeGameRankItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINSnakeGameRankItem.InitSnakeRankItem = function(self, rankingData, index, isMine)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_PlayerName).text = tostring(rankingData.name)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(rankingData.score)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Rank).text = tostring(index)
  if index > 3 then
    ((self.ui).obj_icon):SetActive(false)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Rank).color = Color.white
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_item).color = (self.ui).color_other
  else
    ;
    ((self.ui).obj_icon):SetActive(true)
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Rank).color = Color.black
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_item).color = ((self.ui).color_array)[index]
  end
end

return UINSnakeGameRankItem

