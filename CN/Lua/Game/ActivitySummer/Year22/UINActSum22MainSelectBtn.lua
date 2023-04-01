-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySummer.Year22.UINActSum22MainBtn")
local UINActSum22MainSelectBtn = class("UINActSum22MainSelectBtn", base)
UINActSum22MainSelectBtn.RefreshSum22BtnUnlock = function(self)
  -- function num : 0_0
  self._isUnlock = true
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).ani_selected).enabled = true
  ;
  ((self.ui).finished):SetActive(false)
  ;
  (((self.ui).tex_CNName).gameObject):SetActive(true)
  ;
  (((self.ui).tex_ENName).gameObject):SetActive(true)
end

UINActSum22MainSelectBtn.RefreshSum22Locked = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self._isUnlock = false
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).ani_selected).enabled = false
  ;
  ((self.ui).finished):SetActive(true)
  ;
  (((self.ui).tex_CNName).gameObject):SetActive(false)
  ;
  (((self.ui).tex_ENName).gameObject):SetActive(false)
  local color = (Color.New)(1, 1, 1, 0.2)
  for i,v in ipairs((self.ui).arr_imgs) do
    v.color = color
  end
end

return UINActSum22MainSelectBtn

