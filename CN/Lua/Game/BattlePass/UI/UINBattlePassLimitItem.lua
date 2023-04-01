-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattlePassLimitItem = class("UINBattlePassLimitItem", UIBaseNode)
local base = UIBaseNode
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINBattlePassLimitItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Pick, self, self.OnPassBaseItemClicked)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).baseItem)
end

UINBattlePassLimitItem.UpdatePassLimitItemUI = function(self, passInfo, clickEvent)
  -- function num : 0_1 , upvalues : _ENV
  local passCfg = passInfo.passCfg
  self.clickEvent = clickEvent
  self.passInfo = passInfo
  local availableCount = passInfo:GetNoTakenLimitRewardCount()
  self._availableCount = availableCount
  ;
  ((self.ui).obj_CanRecive):SetActive(availableCount > 0)
  ;
  ((self.ui).obj_lock):SetActive(not passInfo:IsPassFullLevel())
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

  if availableCount > 0 then
    ((self.ui).tex_Count).text = tostring(availableCount)
  end
  local itemId = passCfg.limit_reward_id
  local itemCount = passCfg.limit_reward_num
  local itemCfg = (ConfigData.item)[itemId]
  ;
  (self.baseItem):InitItemWithCount(itemCfg, itemCount, nil)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINBattlePassLimitItem.OnPassBaseItemClicked = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._availableCount <= 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.EventBattlePassRewardPreview, function(window)
    -- function num : 0_2_0 , upvalues : self
    if window == nil then
      return 
    end
    local passCfg = (self.passInfo).passCfg
    window:InitBPRewardPreview(passCfg.limit_reward_id, passCfg.preview_reward_ids, passCfg.preview_reward_nums)
  end
)
    return 
  end
  if self.clickEvent ~= nil then
    (self.clickEvent)()
  end
end

UINBattlePassLimitItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINBattlePassLimitItem

