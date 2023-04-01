-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackTaskItem = class("UINEventComebackTaskItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local TaskEnum = require("Game.Task.TaskEnum")
local JumpManager = require("Game.Jump.JumpManager")
UINEventComebackTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Received, self, self.__OnClickReceive)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self.__OnClickJump)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINEventComebackTaskItem.InitCombackTaskItem = function(self, taskData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._taskId = taskData.id
  self._taskData = taskData
  self._callback = callback
  local stepCfg = (self._taskData):GetStepCfg()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (self._taskData):GetTaskFirstStepIntro()
  local itemIds, itemCounts = (self._taskData):GetTaskCfgRewards()
  ;
  (self._itemPool):HideAll()
  for i,itemId in ipairs(itemIds) do
    local itemCfg = (ConfigData.item)[itemId]
    if itemCfg.type ~= eItemType.BattlePassPoint then
      local itemCount = itemCounts[i]
      local item = (self._itemPool):GetOne()
      item:InitItemWithCount(itemCfg, itemCount)
    end
  end
  self:__Refresh()
end

UINEventComebackTaskItem.RefreshCombackTaskItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(self._taskId, true)
  self:__Refresh()
end

UINEventComebackTaskItem.__Refresh = function(self)
  -- function num : 0_3 , upvalues : _ENV, TaskEnum
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).slider).value = schedule / aim
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).text = tostring(schedule) .. "/" .. tostring(aim)
  if (self._taskData).state == (TaskEnum.eTaskState).Picked then
    ((self.ui).obj_Completed):SetActive(true)
    ;
    (((self.ui).btn_Received).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Jump).gameObject):SetActive(false)
    for i,rewardItem in ipairs((self._itemPool).listItem) do
      rewardItem:SetPickedUIActive(true)
    end
    return 
  end
  for i,rewardItem in ipairs((self._itemPool).listItem) do
    rewardItem:SetPickedUIActive(false)
  end
  ;
  ((self.ui).obj_Completed):SetActive(false)
  local canReceive = (self._taskData):CheckComplete()
  if canReceive then
    (((self.ui).btn_Received).gameObject):SetActive(true)
    ;
    (((self.ui).btn_Jump).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).btn_Received).gameObject):SetActive(false)
  local canJump = ((self._taskData).stcData).jump_id or 0 > 0
  ;
  (((self.ui).btn_Jump).gameObject):SetActive(canJump)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINEventComebackTaskItem.__OnClickJump = function(self)
  -- function num : 0_4 , upvalues : JumpManager
  local jumpId = ((self._taskData).stcData).jump_id or 0
  if jumpId > 0 then
    local args = ((self._taskData).stcData).jumpArgs
    JumpManager:Jump(jumpId, nil, nil, args)
  end
end

UINEventComebackTaskItem.__OnClickReceive = function(self)
  -- function num : 0_5
  if self._callback then
    (self._callback)(self._taskData)
  end
end

UINEventComebackTaskItem.GetComebackTaskDataItem = function(self)
  -- function num : 0_6
  return self._taskData
end

return UINEventComebackTaskItem

