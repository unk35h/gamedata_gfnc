-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorSetHeroIcon = class("UINAdjEditorSetHeroIcon", UIBaseNode)
local base = UIBaseNode
UINAdjEditorSetHeroIcon.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickHeroIcon)
end

UINAdjEditorSetHeroIcon.InitAdjSetHeroIcon = function(self, heroId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._heroId = heroId
  self._callback = callback
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_UserHead).sprite = CRH:GetHeroSkinSprite(self._heroId)
  ;
  ((self.ui).isSelect):SetActive(false)
end

UINAdjEditorSetHeroIcon.SetAdjHeroIconUsedState = function(self, flag)
  -- function num : 0_2
  ((self.ui).isSelect):SetActive(flag)
end

UINAdjEditorSetHeroIcon.OnClickHeroIcon = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._heroId)
  end
end

UINAdjEditorSetHeroIcon.GetAdjHeroIconId = function(self)
  -- function num : 0_4
  return self._heroId
end

return UINAdjEditorSetHeroIcon

