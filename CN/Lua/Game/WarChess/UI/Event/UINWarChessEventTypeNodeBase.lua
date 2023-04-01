-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessEventTypeNodeBase = class("UINWarChessEventTypeNodeBase", base)
UINWarChessEventTypeNodeBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_EventText).text = ""
end

UINWarChessEventTypeNodeBase.InitWCEventNode = function(self, uiEvent, eventCfg, choiceDatas, onChoiceClick)
  -- function num : 0_1
  self.uiEvent = uiEvent
  self.eventCfg = eventCfg
  self.choiceDatas = choiceDatas
  self.onChoiceClick = onChoiceClick
  self:RefreshEventText()
  self:RefreshEntChoiceList()
end

UINWarChessEventTypeNodeBase.RefreshEventText = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local eventText = (LanguageUtil.GetLocaleText)((self.eventCfg).event_txt)
  ;
  ((self.ui).tex_EventText):DOKill()
  ;
  (((self.ui).tex_EventText):DOText(eventText, 1, true)):SetLink(((self.ui).tex_EventText).gameObject)
end

UINWarChessEventTypeNodeBase.RefreshEntChoiceList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local choicePool = (self.uiEvent):GetWCChoicePool()
  choicePool:HideAll()
  for index,choiceData in ipairs(self.choiceDatas) do
    local choiceItem = choicePool:GetOne()
    ;
    (choiceItem.transform):SetParent((self.ui).rect)
    choiceItem:InitWCEventChoiceItem(choiceData, self.onChoiceClick)
  end
end

UINWarChessEventTypeNodeBase.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessEventTypeNodeBase

