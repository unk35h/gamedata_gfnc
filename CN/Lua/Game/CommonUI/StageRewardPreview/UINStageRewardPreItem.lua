-- params : ...
-- function num : 0 , upvalues : _ENV
local UINStageRewardPreItem = class("UINStageRewardPreItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINStageRewardPreItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithCount, false)
end

UINStageRewardPreItem.InitStageRewardPreItem = function(self, rewardPreCfg, isPick)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Point).text = tostring(rewardPreCfg.need_point)
  ;
  (self.rewardItemPool):HideAll()
  for k,itemId in ipairs(rewardPreCfg.rewardIds) do
    local itemNum = (rewardPreCfg.rewardNums)[k]
    local item = (self.rewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    item:InitItemWithCount(itemCfg, itemNum, nil, isPick)
    item:SetNotNeedAnyJump(true)
  end
end

UINStageRewardPreItem.GetStageRewardPreItemCurHolder = function(self)
  -- function num : 0_2
  return (self.ui).curHolder
end

UINStageRewardPreItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (self.rewardItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINStageRewardPreItem

