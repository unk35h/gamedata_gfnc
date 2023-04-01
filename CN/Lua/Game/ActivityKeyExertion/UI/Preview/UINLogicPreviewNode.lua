-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLogicPreviewNode = class("UINLogicPreviewNode", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINLogicPreviewNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Bg, self, self.OnClickClose)
end

UINLogicPreviewNode.InitLogicPreviewNode = function(self, itemIds, itemNums, title)
  -- function num : 0_1 , upvalues : _ENV
  if not self.settedTopStatus then
    (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
    self.settedTopStatus = true
  end
  ;
  (self.__itemPool):HideAll()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = title
  for iIndex,vRewardId in ipairs(itemIds) do
    local rewardNum = itemNums[iIndex]
    local item = (self.__itemPool):GetOne()
    item:InitItemWithCount((ConfigData.item)[vRewardId], rewardNum)
    item:Show()
  end
end

UINLogicPreviewNode.OnClickClose = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.settedTopStatus then
    (UIUtil.OnClickBack)()
  end
end

UINLogicPreviewNode.BackAction = function(self)
  -- function num : 0_3
  self.settedTopStatus = false
  self:Hide()
end

return UINLogicPreviewNode

