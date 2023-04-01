-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Avg.UI.Base.UINContentBase")
local UINAvgDialog = class("UINAvgDialog", base)
local CS_ResLoader = CS.ResLoader
local CS_Canvas = (CS.UnityEngine).Canvas
local CS_ScrambleMode = ((CS.DG).Tweening).ScrambleMode
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local SpecialStr = "bravo"
UINAvgDialog.ctor = function(self, avgSystem)
  -- function num : 0_0
  self.avgSystem = avgSystem
end

UINAvgDialog.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, CS_Canvas
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).tween_Narrator).onComplete):AddListener(BindCallback(self, self.OnDialogTweenComplete))
  ;
  (((self.ui).tween_Dialog).onComplete):AddListener(BindCallback(self, self.OnDialogTweenComplete))
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tween_Narrator).isIndependentUpdate = (self.avgSystem):AvgIgnoreTimeScale()
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tween_Dialog).isIndependentUpdate = (self.avgSystem):AvgIgnoreTimeScale()
  ;
  (CS_Canvas.ForceUpdateCanvases)()
  ;
  (((self.ui).text_Dialog).onHrefClick):AddListener((self.avgSystem):GetOnClickAvgTextLinkCallback())
  ;
  (((self.ui).tex_TextNarrator).onHrefClick):AddListener((self.avgSystem):GetOnClickAvgTextLinkCallback())
  self.avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg)
end

UINAvgDialog.SetAvgDialogBottom = function(self, height)
  -- function num : 0_2
  local anchoredPosition = ((self.ui).textNarratorNode).anchoredPosition
  anchoredPosition.y = height
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).textNarratorNode).anchoredPosition = anchoredPosition
end

UINAvgDialog.ShowAvgDialog = function(self, content, shake, immediate, scramble, speakerName, isNarratage, posX)
  -- function num : 0_3 , upvalues : SpecialStr, _ENV
  self:Show()
  self:InitAvgTextSplitParam()
  self.shake = shake
  self:ClearShakeTween()
  self.isNarratage = isNarratage
  if self.isNarratage then
    (((self.ui).textNarratorNode).gameObject):SetActive(true)
    ;
    ((self.ui).dialogNode):SetActive(false)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R8 in 'UnsetPending'

    if speakerName == SpecialStr then
      ((self.ui).tex_TextNarratorSpeaker).text = PlayerDataCenter.playerName
    else
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_TextNarratorSpeaker).text = speakerName
    end
    if immediate then
      content = self:InitImmediateContent(content)
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_TextNarrator).text = content
      self:OnDialogTweenComplete()
    else
      self:InitAvgTextTween((self.ui).tex_TextNarrator, (self.ui).tween_Narrator, content, scramble)
    end
  else
    ;
    (((self.ui).textNarratorNode).gameObject):SetActive(false)
    ;
    ((self.ui).dialogNode):SetActive(true)
    if speakerName ~= -1 then
      content = speakerName .. "：" .. content
    end
    local extents = (((self.ui).text_Dialog).rectTransform).sizeDelta
    extents.y = 0
    local sizeDelta = ((self.ui).text_Dialog):PreSetTextSizeDelta(content, false, true, extents)
    -- DECOMPILER ERROR at PC88: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).text_Dialog_Layout).preferredHeight = sizeDelta.y
    if immediate then
      content = self:InitImmediateContent(content)
      -- DECOMPILER ERROR at PC97: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).text_Dialog).text = content
      self:OnDialogTweenComplete()
    else
      self:InitAvgTextTween((self.ui).text_Dialog, (self.ui).tween_Dialog, content, scramble)
    end
    local pos = (((self.ui).dialogNode).transform).anchoredPosition
    pos.x = posX or 0
    -- DECOMPILER ERROR at PC120: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (((self.ui).dialogNode).transform).anchoredPosition = pos
  end
  do
    self.contentLenth = #content
  end
end

UINAvgDialog._GetTextComp = function(self)
  -- function num : 0_4
  if self.isNarratage then
    return (self.ui).tex_TextNarrator, (self.ui).tween_Narrator
  else
    return (self.ui).text_Dialog, (self.ui).tween_Dialog
  end
end

UINAvgDialog.OnDialogTweenComplete = function(self)
  -- function num : 0_5 , upvalues : _ENV, cs_LayoutRebuilder
  local textComp, textDtanim = self:_GetTextComp()
  if self:TryAvgTextSplitPause(textComp, textDtanim) then
    return 
  end
  if self.shake then
    if self.isNarratage then
      self.shakeTween = ((((self.ui).tex_TextNarrator).transform):DOShakePosition(0.4, (Vector3.New)(10, 10, 0), 20)):SetUpdate((self.avgSystem):AvgIgnoreTimeScale())
    else
      ;
      (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((((self.ui).text_Dialog).transform).parent)
      self.shakeTween = ((((self.ui).text_Dialog).transform):DOShakePosition(0.4, (Vector3.New)(10, 10, 0), 20)):SetUpdate((self.avgSystem):AvgIgnoreTimeScale())
    end
  end
  ;
  (self.avgSystem):ShowTextComplete(self.contentLenth)
end

UINAvgDialog.SkipAvgContent = function(self)
  -- function num : 0_6
  local textComp, textDtanim = self:_GetTextComp()
  if (self._playTween):IsPlaying() then
    textDtanim:DOComplete()
    return 
  end
  self:TryPlayAvgContentSplitTween()
end

UINAvgDialog.TryPlayAvgContentSplitTween = function(self)
  -- function num : 0_7
  local textComp, textDtanim = self:_GetTextComp()
  self:TryPlayAvgTextSplitTween(textComp, textDtanim)
end

UINAvgDialog.EndAvgContent = function(self)
  -- function num : 0_8
  if self.isNarratage then
    ((self.ui).tween_Narrator):DOKill()
  else
    ;
    ((self.ui).tween_Dialog):DOKill()
  end
end

UINAvgDialog.ClearShakeTween = function(self)
  -- function num : 0_9
  if self.shakeTween ~= nil then
    (self.shakeTween):Rewind()
    ;
    (self.shakeTween):Kill()
    self.shakeTween = nil
  end
end

UINAvgDialog.ShowAvgUI = function(self, show)
  -- function num : 0_10
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = show and 1 or 0
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).interactable = show
end

UINAvgDialog.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  self:ClearShakeTween()
  ;
  ((self.ui).tween_Narrator):DOKill()
  ;
  ((self.ui).tween_Dialog):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINAvgDialog

