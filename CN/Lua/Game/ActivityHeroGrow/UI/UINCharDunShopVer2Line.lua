-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCharDunShopVer2Line = class("UINCharDunShopVer2Line", UIBaseNode)
local base = UIBaseNode
UINCharDunShopVer2Line.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCharDunShopVer2Line.InitCharDunShopVer2LineHorize = function(self, length, reverse, startScore, endScore)
  -- function num : 0_1
  self:__SetData(startScore, endScore)
  local scale = (self.transform).localScale
  scale.x = reverse and -1 or 1
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).localScale = scale
  local sizeDelta = (self.transform).sizeDelta
  sizeDelta.x = length
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = sizeDelta
end

UINCharDunShopVer2Line.InitCharDunShopVer2LineVertial = function(self, length, reverse, startScore, endScore)
  -- function num : 0_2
  self:__SetData(startScore, endScore)
  local scale = (self.transform).localScale
  scale.y = reverse and -1 or 1
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).localScale = scale
  local sizeDelta = (self.transform).sizeDelta
  sizeDelta.y = length
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = sizeDelta
end

UINCharDunShopVer2Line.__SetData = function(self, startScore, endScore)
  -- function num : 0_3
  self._startScore = startScore
  self._endScore = endScore
  self._diffScore = self._endScore - self._startScore
end

UINCharDunShopVer2Line.RefreshCharDunShopVer2Line = function(self, score)
  -- function num : 0_4
  local diff = score - self._startScore
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fill).fillAmount = diff / self._diffScore
end

return UINCharDunShopVer2Line

