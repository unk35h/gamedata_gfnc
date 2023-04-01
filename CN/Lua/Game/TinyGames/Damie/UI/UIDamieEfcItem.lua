-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDamieEfcItem = class("UIDamieEfcItem", UIBaseNode)
local base = UIBaseNode
local cs_Tweening = (CS.DG).Tweening
local cs_DoTween = cs_Tweening.DOTween
local cs_DoTweenLoopType = cs_Tweening.LoopType
UIDamieEfcItem.OnShow = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnShow)(self)
  if self.hideTimer ~= nil then
    TimerManager:StopTimer(self.hideTimer)
    self.hideTimer = nil
  end
  ;
  ((self.ui).obj_Punch):SetActive(true)
end

UIDamieEfcItem.Active = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.hideTimer = TimerManager:StartTimer(0.4, (BindCallback(self, self.__HidePunch)), nil, true, false, true)
end

UIDamieEfcItem.__HidePunch = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).obj_Punch):SetActive(false)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).imag_PunchEfc).transform).localScale = Vector3.zero
  ;
  ((self.ui).img_GetScore):SetActive(false)
end

UIDamieEfcItem.OnInit = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).tex_GetScore):SetIndex(1)
end

UIDamieEfcItem.UpdateScore = function(self, score, id)
  -- function num : 0_4 , upvalues : _ENV, cs_DoTween, cs_Tweening, cs_DoTweenLoopType
  ((self.ui).img_GetScore):SetActive(true)
  ;
  ((self.ui).tex_GetScore):SetIndex(0, tostring(score))
  AudioManager:PlayAudioById(1213)
  -- DECOMPILER ERROR at PC35: Unhandled construct in 'MakeBoolean' P1

  if self:IsPair(id) and self.shakeSeq ~= nil and self.dataId == 18 and (self.shakeSeq):IsComplete() then
    (self.shakeSeq):Rewind()
    self:UpdatePunch()
    return 
  end
  ;
  (self.shakeSeq):Pause()
  ;
  (((self.ui).obj_Punch).transform):SetLocalScale(1, 1, 1)
  ;
  ((self.ui).img_Punch):SetLocalScale(1, 1, 1)
  ;
  (((self.ui).imag_PunchEfc).transform):SetLocalScale(0, 0, 0)
  ;
  (self.shakeSeq):Rewind()
  if self.shakeSeq ~= nil then
    (self.shakeSeq):Kill()
    self.shakeSeq = nil
  end
  ;
  (((self.ui).obj_Punch).transform):SetLocalScale(1, 1, 1)
  ;
  ((self.ui).img_Punch):SetLocalScale(1, 1, 1)
  ;
  (((self.ui).imag_PunchEfc).transform):SetLocalScale(0, 0, 0)
  self.shakeSeq = (cs_DoTween.Sequence)()
  ;
  (self.shakeSeq):SetUpdate(true)
  ;
  (self.shakeSeq):SetAutoKill(false)
  if self.dataId == 18 then
    (self.shakeSeq):Append(((((self.ui).obj_Punch).transform):DOPunchScale((Vector3.New)(0.7, 0.7, 0), 0.1, 1, 1)):SetEase((cs_Tweening.Ease).InQuad))
  else
    ;
    (self.shakeSeq):Append((((((self.ui).obj_Punch).transform):DOScale((Vector2.New)(0.8, 0.8), 0.1)):SetEase((cs_Tweening.Ease).OutQuad)):SetLoops(2, cs_DoTweenLoopType.Yoyo))
    ;
    (self.shakeSeq):Insert(0.05, (((self.ui).imag_PunchEfc).transform):DOScale(Vector2.one, 0.1))
  end
end

UIDamieEfcItem.IsPair = function(self, id)
  -- function num : 0_5
  if self.dataId ~= id then
    self.dataId = id
    return false
  end
  return true
end

UIDamieEfcItem.UpdatePunch = function(self)
  -- function num : 0_6
  local trans = (self.ui).img_Punch
  trans:SetLocalScale(-(trans.localScale).x, (trans.localScale).y, (trans.localScale).z)
end

UIDamieEfcItem.UpdateState = function(self)
  -- function num : 0_7
  ((self.ui).imag_PunchEfc):SetActive(true)
end

UIDamieEfcItem.OnHide = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnHide)(self)
  if self.hideTimer ~= nil then
    TimerManager:StopTimer(self.hideTimer)
    self.hideTimer = nil
  end
  ;
  ((self.ui).tex_GetScore):SetIndex(1)
  ;
  ((self.ui).img_Punch):SetLocalScale(1, 1, 1)
  ;
  (((self.ui).obj_Punch).transform):SetLocalScale(1, 1, 1)
  ;
  (((self.ui).imag_PunchEfc).transform):SetLocalScale(0, 0, 0)
end

UIDamieEfcItem.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnDelete)(self)
  if self.shakeSeq ~= nil then
    (self.shakeSeq):Kill()
    self.shakeSeq = nil
  end
end

return UIDamieEfcItem

