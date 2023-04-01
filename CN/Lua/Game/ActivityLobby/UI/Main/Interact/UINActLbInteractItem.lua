-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActLbInteractItem = class("UINActLbInteractItem", base)
UINActLbInteractItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Interact, self, self._OnInteractBtnClick)
end

UINActLbInteractItem.InitActLbInteractItem = function(self, intrctAction, atlas)
  -- function num : 0_1 , upvalues : _ENV
  self._intrctAction = intrctAction
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = intrctAction:GetLbIntrctActionName()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = intrctAction:GetLbIntrctActionSubName()
  local spriteName = intrctAction:GetLbIntrctActionIconName()
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).icon).sprite = (AtlasUtil.GetResldSprite)(atlas, spriteName)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Buttom).color = Color.white
  ;
  ((self.ui).info):SetActive(false)
  ;
  ((self.ui).obj_Progress):SetActive(false)
  ;
  ((self.ui).obj_Lock):SetActive(false)
  intrctAction:InvokeLbIntrctActionUIInit(self)
end

UINActLbInteractItem.SetActLbIntrctItemHighlight = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_Buttom).color = (self.ui).col_Highlight
end

UINActLbInteractItem._OnInteractBtnClick = function(self)
  -- function num : 0_3
  if self._intrctAction ~= nil then
    (self._intrctAction):InvokeLbIntrctAction()
  end
end

UINActLbInteractItem.SetSetActLbIntrctItemProgress = function(self, progressStr)
  -- function num : 0_4
  ((self.ui).info):SetActive(true)
  ;
  ((self.ui).obj_Progress):SetActive(true)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).text = progressStr
end

UINActLbInteractItem.SetSetActLbIntrctItemLock = function(self)
  -- function num : 0_5
  ((self.ui).info):SetActive(true)
  ;
  ((self.ui).obj_Lock):SetActive(true)
end

UINActLbInteractItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLbInteractItem

