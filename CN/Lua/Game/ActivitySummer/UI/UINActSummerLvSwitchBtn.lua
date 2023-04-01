-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSummerLvSwitchBtn = class("UINActSummerLvSwitchBtn", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
UINActSummerLvSwitchBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickSummerLv)
end

UINActSummerLvSwitchBtn.InitSummerLvBtn = function(self, diffIdx, callback)
  -- function num : 0_1
  self.index = diffIdx
  self.callback = callback
  self:_InitUI(diffIdx)
  self:_InitTweenByDiffIdx(diffIdx)
  self:SetSummerLvState(false)
end

UINActSummerLvSwitchBtn.SetSummerLvState = function(self, flag)
  -- function num : 0_2 , upvalues : _ENV
  if flag == self._flag then
    return 
  end
  self._flag = flag
  local index = (self.index - 1) * 2 + (flag and 0 or 1)
  ;
  ((self.ui).img_Buttom):SetIndex(index)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).img_Select).image).enabled = flag
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Bar).fillAmount = flag and 1 or 0
  if not flag or not Color.white then
    local texCol = (self.ui).col_texBlack
  end
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).tex_Name).text).color = texCol
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).tex_NameEn).text).color = texCol
  self:_PlayTweenByFlag(flag)
end

UINActSummerLvSwitchBtn._InitUI = function(self, diffIdx)
  -- function num : 0_3
  local index = diffIdx - 1
  ;
  ((self.ui).tex_Name):SetIndex(index)
  ;
  ((self.ui).tex_NameEn):SetIndex(index)
  ;
  ((self.ui).img_Select):SetIndex(index)
  if index ~= 0 or not (self.ui).col_simple then
    local col = (self.ui).col_Hard
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Bar).color = col
end

UINActSummerLvSwitchBtn._InitTweenByDiffIdx = function(self, diffIdx)
  -- function num : 0_4 , upvalues : cs_DoTween
  if self._seq ~= nil then
    (self._seq):Kill()
    self._seq = nil
  end
  local seq = (cs_DoTween.Sequence)()
  seq:Append(((self.ui).img_Bar):DOFillAmount(1, 0.25))
  if diffIdx == 1 then
    seq:Join(((((self.ui).img_Select).image):DOFillAmount(0, 0.5)):From())
  else
    seq:Join(((((self.ui).img_Select).image):DOFade(0, 0.25)):From())
  end
  seq:SetAutoKill(false)
  self._seq = seq
end

UINActSummerLvSwitchBtn._PlayTweenByFlag = function(self, flag)
  -- function num : 0_5
  if self._seq == nil then
    self:_InitTweenByDiffIdx(self.index)
  end
  if flag then
    (self._seq):Restart()
  else
    ;
    (self._seq):Pause()
    ;
    (self._seq):Rewind()
  end
end

UINActSummerLvSwitchBtn.OnClickSummerLv = function(self)
  -- function num : 0_6
  if self.callback ~= nil then
    (self.callback)(self.index)
  end
end

UINActSummerLvSwitchBtn.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  if self._seq ~= nil then
    (self._seq):Kill()
    self._seq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINActSummerLvSwitchBtn

