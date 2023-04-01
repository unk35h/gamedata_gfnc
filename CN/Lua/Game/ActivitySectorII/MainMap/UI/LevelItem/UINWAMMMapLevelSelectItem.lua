-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWAMMMapLevelSelectItem = class("UINWAMMMapLevelSelectItem", UIBaseNode)
local base = UIBaseNode
UINWAMMMapLevelSelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWAMMMapLevelSelectItem.InitSelectItem = function(self, levelData)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Title).text = levelData:GetLevelTitle()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_SubTitle).text = levelData:GetLevelSubTitle()
end

UINWAMMMapLevelSelectItem.PlayOnSelectTween = function(self, isBattle)
  -- function num : 0_2
  if isBattle then
    ((self.ui).tween_img_Sel):DORestart()
    ;
    ((self.ui).tween_baseHolder):DORestart()
    ;
    ((self.ui).tween_descItem):DORestart()
  end
  ;
  ((self.ui).obj_battleSelect):SetActive(isBattle)
  ;
  ((self.ui).obj_avgSelect):SetActive(not isBattle)
end

UINWAMMMapLevelSelectItem.RefreshSelectItemChallenge = function(self, hasChallenge, totalNum, passedNum)
  -- function num : 0_3
  ((self.ui).challenge):SetActive(hasChallenge)
  if not hasChallenge then
    return 
  end
  local size = ((self.ui).rect_challengeBg).sizeDelta
  size.x = 40 * totalNum
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rect_challengeBg).sizeDelta = size
  size = ((self.ui).rect_ChallengeCur).sizeDelta
  size.x = 40 * passedNum
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rect_ChallengeCur).sizeDelta = size
end

UINWAMMMapLevelSelectItem.PlayOnCancleSelectTween = function(self)
  -- function num : 0_4
end

UINWAMMMapLevelSelectItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINWAMMMapLevelSelectItem

