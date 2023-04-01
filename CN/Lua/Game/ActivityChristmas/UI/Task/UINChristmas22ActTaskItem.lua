-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22ActTaskItem = class("UINChristmas22ActTaskItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINChristmas22ActTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ItemClick, self, self.OnClickConfirm)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
end

UINChristmas22ActTaskItem.InitChristmas22ActTaskItem = function(self, taskData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._taskData = taskData
  self._callback = callback
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskDes).text = (self._taskData):GetTaskFirstStepIntro()
  ;
  (self._itemPool):HideAll()
  local itemids, itemnums = (self._taskData):GetTaskCfgRewards()
  for i,itemId in ipairs(itemids) do
    local itemNum = itemnums[i]
    local itemCfg = (ConfigData.item)[itemId]
    local item = (self._itemPool):GetOne()
    item:InitItemWithCount(itemCfg, itemNum)
  end
  self:RefreshChristmas22ActTaskItem()
end

UINChristmas22ActTaskItem.RefreshChristmas22ActTaskItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:__RefreshFill()
  for i,v in ipairs((self._itemPool).listItem) do
    v:SetPickedUIActive((self._taskData).isPicked)
  end
  if (self._taskData).isPicked then
    self:__RefreshPickConfirmBtn()
  else
    self:__RefreshConfirmBtn()
  end
end

UINChristmas22ActTaskItem.__RefreshFill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fill).fillAmount = schedule / aim
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(schedule), tostring(aim))
end

UINChristmas22ActTaskItem.__RefreshPickConfirmBtn = function(self)
  -- function num : 0_4
  ((self.ui).isOver):SetActive(true)
  ;
  ((self.ui).state):SetActive(false)
end

UINChristmas22ActTaskItem.__RefreshConfirmBtn = function(self)
  -- function num : 0_5
  ((self.ui).isOver):SetActive(false)
  ;
  ((self.ui).state):SetActive(true)
  local isComplete = (self._taskData):CheckComplete()
  ;
  (((self.ui).img_state).gameObject):SetActive(isComplete)
  ;
  ((self.ui).tex_State):SetIndex(isComplete and 0 or 1)
end

UINChristmas22ActTaskItem.OnClickConfirm = function(self)
  -- function num : 0_6
  if self._callback ~= nil then
    (self._callback)(self._taskData)
  end
end

UINChristmas22ActTaskItem.GetChristmasActTaskId = function(self)
  -- function num : 0_7
  return (self._taskData).id
end

return UINChristmas22ActTaskItem

