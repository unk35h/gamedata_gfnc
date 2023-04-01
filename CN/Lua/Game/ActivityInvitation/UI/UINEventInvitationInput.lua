-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventInvitationInput = class("UINEventInvitationInput", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local cs_MessageCommon = CS.MessageCommon
UINEventInvitationInput.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confim, self, self.OnClickCommit)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Hide)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINEventInvitationInput.InitInvitationInput = function(self, invitationData)
  -- function num : 0_1 , upvalues : _ENV
  self._invitationData = invitationData
  self._callback = callback
  ;
  (self._itemPool):HideAll()
  local cfg = (self._invitationData):GetInvitationMainCfg()
  for i,itemId in ipairs(cfg.return_reward_ids) do
    local item = (self._itemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    local itemNum = (cfg.return_reward_nums)[i]
    item:InitItemWithCount(itemCfg, itemNum)
  end
end

UINEventInvitationInput.OnClickCommit = function(self)
  -- function num : 0_2 , upvalues : _ENV, cs_MessageCommon
  PlayerClickCollectManager:BtnClickNumCollect(1002)
  if not (self._invitationData):IsInvitationReturnUser() or (self._invitationData):IsInvitationReturnPicked() then
    return 
  end
  local code = ((self.ui).inputField).text
  if #code == 0 then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7704))
    return 
  end
  if code == (self._invitationData):GetInvitationCode() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7706))
    return 
  end
  ;
  (self._invitationData):ReqInvitationRegister(code)
end

return UINEventInvitationInput

