-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Task.NewUI.UINTaskListItem")
local UINTaskVer2DayTaskItem = class("UINTaskVer2DayTaskItem", base)
local JumpManager = require("Game.Jump.JumpManager")
local TaskEnum = require("Game.Task.TaskEnum")
local UINTaskUnlockItem = require("Game.ActivityHeroGrow.UI.UINTaskUnlockItem")
UINTaskVer2DayTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINTaskUnlockItem
  (base.OnInit)(self)
  self._taskUnlockItemPool = (UIItemPool.New)(UINTaskUnlockItem, (self.ui).taskUnlockItem)
  ;
  ((self.ui).taskUnlockItem):SetActive(false)
end

UINTaskVer2DayTaskItem.BindCommitFunc = function(self, commitFunc)
  -- function num : 0_1
  self._commitFunc = commitFunc
end

UINTaskVer2DayTaskItem.RefreshRewards = function(self, isPick)
  -- function num : 0_2 , upvalues : base, _ENV
  (self._taskUnlockItemPool):HideAll()
  ;
  (base.RefreshRewards)(self, isPick)
  local unlockCfg = (ConfigData.task_unlock)[(self.taskData).id]
  if unlockCfg ~= nil then
    for _,singleCfg in pairs(unlockCfg) do
      local item = (self._taskUnlockItemPool):GetOne()
      item:InitTaskUnlockItem(singleCfg.type, singleCfg.tips)
      item:SetIsTaskUnlockPicked(isPick)
    end
  end
end

UINTaskVer2DayTaskItem.OnClickBtn = function(self)
  -- function num : 0_3 , upvalues : TaskEnum, JumpManager
  if self.state == (TaskEnum.eTaskState).InProgress then
    local jumpId = (self.taskCfg).jump_id
    local jumpArgs = (self.taskCfg).jumpArgs
    if jumpId ~= nil and jumpId > 0 then
      JumpManager:Jump(jumpId, function(jumpCallback)
    -- function num : 0_3_0
    if jumpCallback ~= nil then
      jumpCallback()
    end
  end
, nil, jumpArgs)
    end
  else
    do
      if self.state == (TaskEnum.eTaskState).Completed and self._commitFunc ~= nil then
        (self._commitFunc)(self.taskData, self)
      end
    end
  end
end

return UINTaskVer2DayTaskItem

