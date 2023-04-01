-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventRoomPageBase = class("UINEventRoomPageBase", UIBaseNode)
local base = UIBaseNode
local EpCommonUtil = require("Game.Exploration.Util.EpCommonUtil")
UINEventRoomPageBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_EventText).text = ""
end

UINEventRoomPageBase.InitBranchPage = function(self, uiEvent, onChoiceClick)
  -- function num : 0_1
  self.uiEvent = uiEvent
  self.onChoiceClick = onChoiceClick
  self.choicePool = (self.uiEvent):GetChoiceItemPool()
  self:RefreshBranchPage(uiEvent)
end

UINEventRoomPageBase.RefreshBranchPage = function(self)
  -- function num : 0_2
  self:RefreshEventText()
  self:RefreshEntChoiceList()
end

UINEventRoomPageBase.RefreshEventText = function(self)
  -- function num : 0_3 , upvalues : EpCommonUtil
  local eventText = (EpCommonUtil.GetEventReplaceText)((self.uiEvent).eventCfg, "event_txt")
  ;
  ((self.ui).tex_EventText):DOKill()
  ;
  (((self.ui).tex_EventText):DOText(eventText, 1, true)):SetLink(((self.ui).tex_EventText).gameObject)
end

UINEventRoomPageBase.RefreshEntChoiceList = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local roomData = (self.uiEvent).roomData
  self.choiceItemDic = {}
  ;
  (self.choicePool):HideAll()
  local extraItemPool = self:_GetExtraItemPool()
  extraItemPool:HideAll()
  for index,choiceData in ipairs(roomData.choiceDatalist) do
    if (choiceData.cfg).gamblebenefit_tag == nil then
      local hasTag = choiceData.cfg == nil
      if (choiceData.cfg).gamblebenefit_tag <= 0 then
        do
          local hasGamble = not hasTag
          do
            if not hasGamble then
              local choiceItem = (self.choicePool):GetOne()
              choiceItem:SetParent((self.ui).rect)
              choiceItem:InitEventChoiceItem(choiceData, self.onChoiceClick)
              if choiceData.displayNewData ~= nil then
                choiceItem:InjectExtraItemPool(extraItemPool)
              end
              choiceItem:RefreshChoiceUI(choiceData.displayNewData)
              -- DECOMPILER ERROR at PC58: Confused about usage of register: R10 in 'UnsetPending'

              ;
              (choiceItem.gameObject).name = tostring(index)
              -- DECOMPILER ERROR at PC60: Confused about usage of register: R10 in 'UnsetPending'

              ;
              (self.choiceItemDic)[index] = choiceItem
            end
            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINEventRoomPageBase._GetExtraItemPool = function(self)
  -- function num : 0_5
  return (self.uiEvent):GetExtraItemPool()
end

UINEventRoomPageBase.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINEventRoomPageBase

