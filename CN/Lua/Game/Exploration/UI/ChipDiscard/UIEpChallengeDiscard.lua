-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.ChipDiscard.UIEpChipDiscardBase")
local UIEpChallengeDiscard = class("UIEpChallengeDiscard", base)
UIEpChallengeDiscard.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.CloseEpDiscard)
end

UIEpChallengeDiscard.OnShow = function(self)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.OnShow)(self)
  if not ExplorationManager:IsInTDExp() then
    MsgCenter:Broadcast(eMsgEventId.DungeonHeroListActiveSet, false)
  end
end

UIEpChallengeDiscard.OnHide = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.OnHide)(self)
  if not ExplorationManager:IsInTDExp() then
    MsgCenter:Broadcast(eMsgEventId.DungeonHeroListActiveSet, true)
  end
end

UIEpChallengeDiscard.InitEpChipDiscard = function(self, dynPlayer, closeCallback, needConsumeSkill)
  -- function num : 0_3 , upvalues : base
  (base.InitEpChipDiscard)(self, dynPlayer, closeCallback, needConsumeSkill)
  ;
  (((self.ui).btn_AddTotalCount).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Map).gameObject):SetActive(false)
end

UIEpChallengeDiscard.OnChipListChange = function(self, isFirstOpen)
  -- function num : 0_4 , upvalues : base
  (base.OnChipListChange)(self, isFirstOpen)
  self:SetEmptyUI(#self.chipDataList <= 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIEpChallengeDiscard.CloseEpDiscard = function(self)
  -- function num : 0_5 , upvalues : base
  (base.CloseEpDiscard)(self)
  if self.isOverLimit then
    return 
  end
  self:OnWinClose()
end

UIEpChallengeDiscard.OnWinClose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnWinClose)(self)
end

UIEpChallengeDiscard.OnDiscardChip = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnDiscardChip)(self)
  local msg = (string.format)(ConfigData:GetTipContent(288), (self.selectedData):GetName(), tostring(self.selectChipPrice))
  ;
  ((CS.MessageCommon).ShowMessageBox)(msg, function()
    -- function num : 0_7_0 , upvalues : _ENV, self
    local netCtrl = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
    netCtrl:CS_EXPLORATION_Alg_Sold((self.selectedData).dataId, function()
      -- function num : 0_7_0_0 , upvalues : _ENV
      AudioManager:PlayAudioById(1040)
    end
)
    self.selectedData = nil
  end
, nil)
end

UIEpChallengeDiscard.InitDiscardChipItem = function(self, item, chipData, index)
  -- function num : 0_8
  item:InitDiscardChipItemInSellout(self.discardId, chipData, self._onDiscardItemClick, self.dynPlayer)
  item:SetItemSelect(self.selectedData == chipData)
  if self.selectedData == nil and index == 0 then
    self:_OnDiscardItemClick(item)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIEpChallengeDiscard.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  self.selectedData = nil
  ;
  (base.OnDelete)(self)
end

return UIEpChallengeDiscard

