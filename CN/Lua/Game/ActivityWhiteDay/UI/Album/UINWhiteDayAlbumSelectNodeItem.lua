-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayAlbumSelectNodeItem = class("UINWhiteDayAlbumSelectNodeItem", UIBaseNode)
local base = UIBaseNode
UINWhiteDayAlbumSelectNodeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetPhoto, self, self.__OnClickGetPhoto)
end

UINWhiteDayAlbumSelectNodeItem.InitWDSelectNodeItem = function(self, isRandom, itemId, itemCostNum, desStr, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.isRandom = isRandom
  self.clickCallback = clickCallback
  if isRandom then
    ((self.ui).tex_Type):SetIndex(1)
    ;
    ((self.ui).tex_Count):SetIndex(1, tostring(itemCostNum))
  else
    ;
    ((self.ui).tex_Type):SetIndex(0)
    ;
    ((self.ui).tex_Count):SetIndex(0, tostring(itemCostNum))
  end
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_ItemIcon).sprite = CRH:GetSpriteByItemId(itemId)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = desStr
end

UINWhiteDayAlbumSelectNodeItem.__OnClickGetPhoto = function(self)
  -- function num : 0_2
  if self.clickCallback ~= nil then
    (self.clickCallback)(self.isRandom)
  end
end

UINWhiteDayAlbumSelectNodeItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayAlbumSelectNodeItem

