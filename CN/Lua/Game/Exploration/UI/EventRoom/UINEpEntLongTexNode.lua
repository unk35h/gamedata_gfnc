-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.EventRoom.UINEventRoomPageBase")
local UINEpEntLongTexNode = class("UINEpEntLongTexNode", base)
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local cs_Tweening = (CS.DG).Tweening
local EpCommonUtil = require("Game.Exploration.Util.EpCommonUtil")
UINEpEntLongTexNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINEpEntLongTexNode.InitBranchPage = function(self, uiEvent, onChoiceClick)
  -- function num : 0_1 , upvalues : base
  (base.InitBranchPage)(self, uiEvent, onChoiceClick)
end

UINEpEntLongTexNode.RefreshBranchPage = function(self)
  -- function num : 0_2
  self:Show()
  self:RefreshEntChoiceList()
  self:RefreshEventText()
end

UINEpEntLongTexNode.RefreshEventText = function(self)
  -- function num : 0_3 , upvalues : EpCommonUtil, cs_LayoutRebuilder, cs_Tweening
  local eventText = (EpCommonUtil.GetEventReplaceText)((self.uiEvent).eventCfg, "event_txt")
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_EventText).text = eventText
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(((self.ui).tex_EventText).transform)
  ;
  ((self.ui).contentScrollRect):DOKill()
  ;
  ((self.ui).tex_EventText):DOKill()
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_EventText).raycastTarget = true
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

  if ((((self.ui).contentScrollRect).transform).rect).height < ((((self.ui).tex_EventText).transform).sizeDelta).y then
    ((self.ui).contentScrollRect).verticalNormalizedPosition = 1
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_EventText).raycastTarget = false
    ;
    (((((((self.ui).contentScrollRect):DOVerticalNormalizedPos(0, 0.25)):SetSpeedBased()):SetEase((cs_Tweening.Ease).Linear)):SetDelay(1)):OnComplete(function()
    -- function num : 0_3_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).tex_EventText).raycastTarget = true
  end
)):SetLink(((self.ui).contentScrollRect).gameObject)
    return 
  end
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_EventText).text = ""
  ;
  (((self.ui).tex_EventText):DOText(eventText, 1, true)):SetLink(((self.ui).tex_EventText).gameObject)
end

UINEpEntLongTexNode.RefreshEntChoiceList = function(self)
  -- function num : 0_4 , upvalues : base, cs_LayoutRebuilder
  (base.RefreshEntChoiceList)(self)
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).rect)
  local size = ((self.ui).eventContent).sizeDelta
  size.y = ((self.transform).sizeDelta).y - (((self.ui).rect).sizeDelta).y + (((self.ui).eventContent).anchoredPosition).y
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).eventContent).sizeDelta = size
end

UINEpEntLongTexNode.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINEpEntLongTexNode

