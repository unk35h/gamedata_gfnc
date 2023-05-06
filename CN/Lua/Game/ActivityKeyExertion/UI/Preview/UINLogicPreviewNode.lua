-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLogicPreviewNode = class("UINLogicPreviewNode", UIBaseNode)
local base = UIBaseNode
local UINKeyExertionRewardItem = require("Game.ActivityKeyExertion.UI.UINKeyExertionRewardItem")
UINLogicPreviewNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINKeyExertionRewardItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__itemPool = (UIItemPool.New)(UINKeyExertionRewardItem, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Bg, self, self.OnClickClose)
end

UINLogicPreviewNode.InitLogicPreviewNode = function(self, keyExertionData)
  -- function num : 0_1 , upvalues : _ENV
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack(true)
  self._data = keyExertionData
  self:UpdateCurrentNode()
end

UINLogicPreviewNode.UpdateCurrentNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._data == nil then
    return 
  end
  local allrewardIds, allrewardNums = (self._data):GetKeyExertionAllReward()
  ;
  (self.__itemPool):HideAll()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self._data):GetKeyExertionAllRewardDes()
  for iIndex,vRewardId in ipairs(allrewardIds) do
    local rewardNum = allrewardNums[iIndex]
    local item = (self.__itemPool):GetOne()
    local isShowAllPicked = ((self._data):GetBigRewardId() == vRewardId and (self._data):GetIsBigRewardAllPicked())
    item:InitKeyExertionRewardItem((ConfigData.item)[vRewardId], rewardNum, isShowAllPicked)
    item:Show()
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINLogicPreviewNode.OnClickClose = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UINLogicPreviewNode.BackAction = function(self)
  -- function num : 0_4
  self:Hide()
end

UINLogicPreviewNode.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.__itemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINLogicPreviewNode

