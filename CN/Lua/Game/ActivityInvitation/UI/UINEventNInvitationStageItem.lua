-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventNInvitationStageItem = class("UINEventNInvitationStageItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINEventNInvitationStageItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._item = (UINBaseItemWithReceived.New)()
  ;
  (self._item):Init((self.ui).uINBaseItemWithReceived)
end

UINEventNInvitationStageItem.InitInvitationStageItem = function(self, index, invitationData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._invitationData = invitationData
  self._index = index
  self._callback = callback
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).text).text = tostring(index)
  local rewardCfg = ((self._invitationData):GetInvitaionRewardCfg())[self._index]
  local itemId = (rewardCfg.invitation_reward_ids)[1]
  local itemNum = (rewardCfg.invitation_reward_nums)[1]
  self._itemCfg = (ConfigData.item)[itemId]
  ;
  (self._item):InitItemWithCount((ConfigData.item)[itemId], itemNum, BindCallback(self, self.OnClickItem))
  self:RefreshInvitationStageItem()
end

UINEventNInvitationStageItem.RefreshInvitationStageItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isunlock = self._index <= #(self._invitationData):GetInvitationInvitees()
  local isPicked = (self._invitationData):IsInvitationRewardPicked(self._index)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  if not isunlock or not Color.black then
    ((self.ui).image).color = (self.ui).color_locked
    ;
    (self._item):SetPickedUIActive(isPicked)
    if isunlock then
      ((self.ui).redDot):SetActive(not isPicked)
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
end

UINEventNInvitationStageItem.OnClickItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if not (self._invitationData):IsInvitationRewardPicked(self._index) and self._index <= #(self._invitationData):GetInvitationInvitees() then
    if self._callback ~= nil then
      (self._callback)(self._index, self)
    end
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_3_0 , upvalues : _ENV, self
    if win ~= nil then
      win:SetNotNeedAnyJump(false)
      if athData ~= nil then
        win:InitAthDetail(self._itemCfg, nil)
      else
        win:InitCommonItemDetail(self._itemCfg)
      end
    end
  end
)
end

return UINEventNInvitationStageItem

