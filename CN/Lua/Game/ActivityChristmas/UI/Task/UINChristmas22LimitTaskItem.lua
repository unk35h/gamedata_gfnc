-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22LimitTaskItem = class("UINChristmas22LimitTaskItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINChristmas22LimitTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetReward, self, self.ClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.ClickRefresh)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINChristmas22LimitTaskItem.InitChristmas22LimitTaskItem = function(self, taskData, callback, refCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._taskData = taskData
  self._callback = callback
  self._refCallback = refCallback
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

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
  self:RefreshChristmas22LimitTaskItem()
end

UINChristmas22LimitTaskItem.SetChristmas22LimitTaskRef = function(self, flag)
  -- function num : 0_2
  if flag then
    (((self.ui).btn_Refresh).gameObject):SetActive(not (self._taskData):CheckComplete())
  end
end

UINChristmas22LimitTaskItem.RefreshChristmas22LimitTaskItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fill).fillAmount = schedule / aim
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(schedule), tostring(aim))
  local isComplete = (self._taskData):CheckComplete()
  ;
  (((self.ui).img_GetReward).gameObject):SetActive(isComplete)
  ;
  ((self.ui).img_GetReward):SetIndex(0)
  ;
  (((self.ui).tex_GetReward).gameObject):SetActive(isComplete)
  ;
  ((self.ui).tex_GetReward):SetIndex(0)
end

UINChristmas22LimitTaskItem.ClickRefresh = function(self)
  -- function num : 0_4
  if self._refCallback ~= nil then
    (self._refCallback)(self, self._taskData)
  end
end

UINChristmas22LimitTaskItem.ClickConfirm = function(self)
  -- function num : 0_5
  if self._callback ~= nil then
    (self._callback)(self._taskData)
  end
end

return UINChristmas22LimitTaskItem

