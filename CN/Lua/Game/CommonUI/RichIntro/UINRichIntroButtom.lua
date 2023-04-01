-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRichIntroButtom = class("UINRichIntroButtom", UIBaseNode)
local base = UIBaseNode
UINRichIntroButtom.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RichIntro, self, self.OnBtnClick)
end

UINRichIntroButtom.InitRichIntroButtom = function(self, onClickCallBack, isTog)
  -- function num : 0_1
  self._onClickCallBack = onClickCallBack
  self._isTog = isTog
  self:SwitchUIState(false)
end

UINRichIntroButtom.SwitchUIState = function(self, isOn)
  -- function num : 0_2
  self._isOn = isOn
  local idx = self._isTog and not isOn and 1 or 0
  ;
  ((self.ui).img_RichIntro):SetIndex(idx)
  if not self._isTog or isOn or not (self.ui).col_IconWhite then
    local iconCol = (self.ui).col_IconBlack
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).color = iconCol
end

UINRichIntroButtom.SetIntroBtnActive = function(self, active)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull(self.gameObject) then
    return 
  end
  ;
  (self.gameObject):SetActive(active)
end

UINRichIntroButtom.OnBtnClick = function(self)
  -- function num : 0_4
  if self._onClickCallBack ~= nil then
    (self._onClickCallBack)()
  end
end

UINRichIntroButtom.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINRichIntroButtom

