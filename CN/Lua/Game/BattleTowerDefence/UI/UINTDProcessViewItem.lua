-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTDProcessViewItem = class("UINTDProcessViewItem", UIBaseNode)
local base = UIBaseNode
local cs_EaseOutBack = (((CS.DG).Tweening).Ease).OutBack
UINTDProcessViewItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINTDProcessViewItem.InitTDProcessViewItem = function(self, idx, mapData, completed)
  -- function num : 0_1 , upvalues : _ENV
  self.roomX = idx
  if not completed or not (self.ui).col_orange then
    local col = (self.ui).col_gray
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_cube).color = col
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).localScale = Vector3.one
  ;
  (((self.ui).img_Room).gameObject):SetActive(false)
  local roomData = mapData:GetOneRoomByX(idx)
  if roomData == nil then
    return 
  end
  local cfg = roomData:GetRoomTypeCfg()
  if cfg == nil then
    return 
  end
  ;
  (((self.ui).img_Room).gameObject):SetActive(cfg.progress_show_Icon)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Room).sprite = CRH:GetSprite(cfg.icon, CommonAtlasType.ExplorationIcon)
end

UINTDProcessViewItem.PlayScaleTween = function(self)
  -- function num : 0_2 , upvalues : _ENV, cs_EaseOutBack
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (self.transform).localScale = Vector3.zero
  ;
  ((((self.transform):DOScale((Vector3.New)(1.2, 1.2, 1), 0.35)):SetRecyclable(true)):SetLink(self.gameObject)):SetEase(cs_EaseOutBack)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_cube).color = (self.ui).col_orange
end

UINTDProcessViewItem.DOTweenKill = function(self)
  -- function num : 0_3
  (self.transform):DOKill()
end

UINTDProcessViewItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINTDProcessViewItem

