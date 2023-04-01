-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22MainBtn = class("UINActSum22MainBtn", UIBaseNode)
local base = UIBaseNode
UINActSum22MainBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickItem)
  if (self.ui).bottom ~= nil then
    self._bottomColor = ((self.ui).bottom).color
  end
  if (self.ui).tex_Name ~= nil then
    self._namreColor = ((self.ui).tex_Name).color
  end
  self._cnNameColor = ((self.ui).tex_CNName).color
  self._enNameColor = ((self.ui).tex_ENName).color
end

UINActSum22MainBtn.InitSum22Btn = function(self, cfg, isUnlock, callback, lockedCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._isUnlock = isUnlock
  self._callback = callback
  self._lockedCallback = lockedCallback
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_CNName).text = (LanguageUtil.GetLocaleText)(cfg.name)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).text = (LanguageUtil.GetLocaleText)(cfg.name_en)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  if (self.ui).tex_Name ~= nil then
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(cfg.name_func)
  end
  if isUnlock then
    self:RefreshSum22BtnUnlock()
  else
    self:RefreshSum22Locked()
  end
end

UINActSum22MainBtn.RefreshSum22BtnUnlock = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._isUnlock = true
  if (self.ui).lock ~= nil then
    ((self.ui).lock):SetActive(false)
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  if (self.ui).bottom ~= nil then
    ((self.ui).bottom).color = Color.white
  end
  local color = ((self.ui).tex_CNName).color
  color.a = 1
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_CNName).color = color
  color = ((self.ui).tex_ENName).color
  color.a = 1
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).color = color
  if (self.ui).tex_Name ~= nil then
    color = ((self.ui).tex_Name).color
    color.a = 1
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = color
  end
end

UINActSum22MainBtn.RefreshSum22Locked = function(self)
  -- function num : 0_3
  self._isUnlock = false
  if (self.ui).lock ~= nil then
    ((self.ui).lock):SetActive(true)
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  if (self.ui).bottom ~= nil then
    ((self.ui).bottom).color = self._bottomColor
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_CNName).color = self._cnNameColor
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).color = self._enNameColor
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R1 in 'UnsetPending'

  if (self.ui).tex_Name ~= nil then
    ((self.ui).tex_Name).color = self._namreColor
  end
end

UINActSum22MainBtn.OnClickItem = function(self)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC7: Unhandled construct in 'MakeBoolean' P1

  if self._isUnlock and self._callback ~= nil then
    (self._callback)()
  end
  if self._lockedCallback ~= nil then
    (self._lockedCallback)()
  end
end

return UINActSum22MainBtn

