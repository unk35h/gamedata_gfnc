-- params : ...
-- function num : 0 , upvalues : _ENV
local UINContentBase = class("UINContentBase", UIBaseNode)
local base = UIBaseNode
local CS_ScrambleMode = ((CS.DG).Tweening).ScrambleMode
UINContentBase.OnInit = function(self)
  -- function num : 0_0
end

UINContentBase.InitAvgTextSplitParam = function(self)
  -- function num : 0_1
  self._lastTextPos = 0
  self._hasSplit = false
  ;
  (self.avgSystem):AvgShowTextSplitPause(false)
  self:SetAvgTextSpliteIdx(nil)
end

UINContentBase.InitImmediateContent = function(self, content)
  -- function num : 0_2 , upvalues : _ENV
  content = (AvgUtil.GetAvgContentShow)(content)
  return content
end

UINContentBase.SetAvgTextSpliteIdx = function(self, idx)
  -- function num : 0_3
  self._contentSplitIdx = idx
  ;
  (self.avgSystem):SetCurActContentSplitIdx(idx)
end

UINContentBase.InitAvgTextTween = function(self, textComp, textDtanim, content, scramble)
  -- function num : 0_4 , upvalues : CS_ScrambleMode, _ENV
  textDtanim.optionalScrambleMode = scramble and CS_ScrambleMode.Uppercase or CS_ScrambleMode.None
  local hasSplit = (string.find)(content, AvgUtil.contentSpliter)
  if hasSplit then
    self._hasSplit = true
    self._contentList = (string.split)(content, AvgUtil.contentSpliter)
    self:SetAvgTextSpliteIdx(1)
    self._contentTo = (self._contentList)[self._contentSplitIdx]
  else
    self._contentTo = content
  end
  self._contenFrom = ""
  self:PlayAvgTextTween(textComp, textDtanim, self._contenFrom, self._contentTo)
end

UINContentBase.PlayAvgTextTween = function(self, textComp, textDtanim, fromStr, toStr)
  -- function num : 0_5 , upvalues : _ENV
  textComp.text = fromStr
  self._playTween = nil
  textDtanim:DOKill()
  textDtanim:CreateTween()
  local textSpeed = (ConfigData.buildinConfig).AvgTextTweenSpeed * (LanguageUtil.GetWriterSpeed)()
  ;
  (textDtanim.tween):ChangeEndValue(toStr, textSpeed, false)
  if self._lastTextPos ~= 0 then
    (textDtanim.tween):Goto(self._lastTextPos)
  end
  self._playTween = textDtanim.tween
  textDtanim:DOPlayForward()
end

UINContentBase.TryPlayAvgTextSplitTween = function(self, textComp, textDtanim)
  -- function num : 0_6
  if self._hasSplit and self._contentSplitIdx < #self._contentList then
    self:SetAvgTextSpliteIdx(self._contentSplitIdx + 1)
    self._contenFrom = self._contentTo
    self._contentTo = self._contentTo .. (self._contentList)[self._contentSplitIdx]
    ;
    (self.avgSystem):AvgShowTextSplitPause(false)
    self:PlayAvgTextTween(textComp, textDtanim, self._contenFrom, self._contentTo)
  end
end

UINContentBase.TryAvgTextSplitPause = function(self, textComp, textDtanim)
  -- function num : 0_7
  if self._hasSplit and self._contentSplitIdx < #self._contentList then
    (self.avgSystem):AvgShowTextSplitPause(true)
    self._lastTextPos = (self._playTween).position
    if ((self.avgSystem).avgCtrl):GetAvgAutoPlayMode() then
      self:TryPlayAvgTextSplitTween(textComp, textDtanim)
    end
    return true
  end
  ;
  (self.avgSystem):AvgShowTextSplitPause(false)
  return false
end

UINContentBase.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  self._playTween = nil
  ;
  (base.OnDelete)(self)
end

return UINContentBase

