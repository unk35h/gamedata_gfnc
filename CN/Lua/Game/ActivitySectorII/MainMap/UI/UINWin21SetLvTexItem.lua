-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWin21SetLvTexItem = class("UINWin21SetLvTexItem", UIBaseNode)
local base = UIBaseNode
UINWin21SetLvTexItem.ctor = function(self, win)
  -- function num : 0_0
  self.win = win
end

UINWin21SetLvTexItem.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.bgSize = UIManager.BackgroundStretchSize
end

UINWin21SetLvTexItem.InitWin21SetLvTexItem = function(self, cs_DoTween, cs_Ease)
  -- function num : 0_2 , upvalues : _ENV
  local showSeq = (cs_DoTween.Sequence)()
  showSeq:Append(((((self.ui).rect_Image):DOLocalMove((Vector3.New)(-232, -169, 0), 0.33)):SetEase(cs_Ease.OutCirc)):From())
  showSeq:Join(((((self.ui).fade_Image):DOFade(0, 0.1)):SetLoops(4)):From())
  showSeq:SetAutoKill(false)
  showSeq:Pause()
  self.showSeq = showSeq
  local hlightSeq = (cs_DoTween.Sequence)()
  hlightSeq:Append(((self.transform):DOLocalMoveY(16, 1)):SetRelative(true))
  hlightSeq:Pause()
  hlightSeq:SetAutoKill(false)
  self.hlightSeq = hlightSeq
end

UINWin21SetLvTexItem.PlayShowTween = function(self)
  -- function num : 0_3
  self.isShow = true
  ;
  (self.showSeq):Restart()
end

UINWin21SetLvTexItem.RewindShowTween = function(self)
  -- function num : 0_4
  self.isShow = false
  ;
  (self.showSeq):Rewind()
end

UINWin21SetLvTexItem.PlayHighlightTween = function(self)
  -- function num : 0_5
  (self.hlightSeq):Restart()
end

UINWin21SetLvTexItem.OnMapGesture = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.screenPos = (UIManager.UICamera):WorldToScreenPoint((self.transform).position)
  local maxX = (self.bgSize).x < (self.screenPos).x
  local minX = (self.screenPos).x < 0
  local maxY = (self.bgSize).y < (self.screenPos).y
  local minY = (self.screenPos).x < 0
  if maxX or minX or maxY or minY then
    self:RewindShowTween()
    return 
  end
  if not self.isShow and not (self.showSeq).isPlaying then
    self:PlayShowTween()
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINWin21SetLvTexItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (self.showSeq):Kill()
  self.showSeq = nil
  ;
  (self.hlightSeq):Kill()
  self.hlightSeq = nil
  ;
  (base.OnDelete)(self)
end

return UINWin21SetLvTexItem

