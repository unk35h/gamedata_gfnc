-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TaskItem = class("UINCarnival22TaskItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local TaskEnum = require("Game.Task.TaskEnum")
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UINCarnival22TaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChangeTask, self, self.OnClickChange)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetReward, self, self.OnClickGetReward)
  self._normalBgColor = ((self.ui).img_ItemBg).color
end

UINCarnival22TaskItem.BindCarnivalTaskCallback = function(self, changeFunc, comleteFunc, jumpFunc)
  -- function num : 0_1
  self._changeFunc = changeFunc
  self._comleteFunc = comleteFunc
  self._jumpFunc = jumpFunc
end

UINCarnival22TaskItem.InitCarnivalTaskItem = function(self, carnivalData, taskData)
  -- function num : 0_2 , upvalues : _ENV
  self._carnivalData = carnivalData
  self._taskData = taskData
  self._taskId = (self._taskData).id
  local quality = (self._carnivalData):GetCarnivalTaskQuality(self._taskId)
  ;
  ((self.ui).tex_Level):SetIndex(quality - 1)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskDescrption).text = (self._taskData):GetTaskFirstStepIntro()
  local itemIds, itemCounts = (self._taskData):GetTaskCfgRewards()
  ;
  (self._itemPool):HideAll()
  for i,itemId in ipairs(itemIds) do
    local itemCfg = (ConfigData.item)[itemId]
    local count = itemCounts[i]
    local item = (self._itemPool):GetOne()
    item:InitItemWithCount(itemCfg, count)
  end
  self:UpdateCarnivalTaskProcess()
end

UINCarnival22TaskItem.ChangeCarnivalTaskItem = function(self, taskData)
  -- function num : 0_3 , upvalues : _ENV, cs_Ease
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).image).rotation = (Quaternion.Euler)(0, 0, 0)
  ;
  (((self.ui).image):DOLocalRotateQuaternion((Quaternion.Euler)(0, 0, -179), 0.5)):SetEase(cs_Ease.InOutQuad)
  ;
  ((self.ui).ani_taskItem):Play("UI_Carnival22TaskItemOut")
  local clip = ((self.ui).ani_taskItem):GetClip("UI_Carnival22TaskItemOut")
  TimerManager:StartTimer(clip.length, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, taskData
    if not IsNull(self.transform) then
      self:InitCarnivalTaskItem(self._carnivalData, taskData)
      ;
      ((self.ui).ani_taskItem):Play("UI_Carnival22TaskItemIn")
    end
  end
, nil, true)
end

UINCarnival22TaskItem.UpdateCarnivalTaskProcess = function(self)
  -- function num : 0_4 , upvalues : _ENV, TaskEnum
  self._taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(self._taskId, true)
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).taskSlider).value = schedule / aim
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ProgressDes).text = tostring(schedule) .. "/" .. tostring(aim)
  ;
  (((self.ui).btn_GetReward).gameObject):SetActive(true)
  ;
  ((self.ui).obj_Received):SetActive(false)
  ;
  (((self.ui).btn_ChangeTask).gameObject):SetActive(true)
  if (self._taskData).state == (TaskEnum.eTaskState).Picked then
    ((self.ui).obj_Received):SetActive(true)
    ;
    (((self.ui).btn_GetReward).gameObject):SetActive(false)
    ;
    (((self.ui).btn_ChangeTask).gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_ItemBg).color = self._normalBgColor
  else
    if (self._taskData):CheckComplete() then
      ((self.ui).tex_GetReward):SetIndex(2)
      -- DECOMPILER ERROR at PC84: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).img_ItemBg).color = (self.ui).color_s
      ;
      (((self.ui).btn_ChangeTask).gameObject):SetActive(false)
    else
      if ((self._taskData).stcData).jump_id > 0 then
        ((self.ui).tex_GetReward):SetIndex(0)
        -- DECOMPILER ERROR at PC105: Confused about usage of register: R3 in 'UnsetPending'

        ;
        ((self.ui).img_ItemBg).color = self._normalBgColor
      else
        ;
        (((self.ui).btn_GetReward).gameObject):SetActive(false)
      end
    end
  end
end

UINCarnival22TaskItem.OnClickChange = function(self)
  -- function num : 0_5
  if self._changeFunc ~= nil then
    (self._changeFunc)(self._taskId, self)
  end
end

UINCarnival22TaskItem.OnClickGetReward = function(self)
  -- function num : 0_6 , upvalues : TaskEnum
  if (self._taskData).state == (TaskEnum.eTaskState).Picked then
    return 
  else
    -- DECOMPILER ERROR at PC18: Unhandled construct in 'MakeBoolean' P1

    if (self._taskData):CheckComplete() and self._comleteFunc ~= nil then
      (self._comleteFunc)(self._taskId)
    end
  end
  if ((self._taskData).stcData).jump_id > 0 and self._jumpFunc ~= nil then
    (self._jumpFunc)(self._taskId)
  end
end

UINCarnival22TaskItem.GetCarnivalTaskData = function(self)
  -- function num : 0_7
  return self._taskData
end

return UINCarnival22TaskItem

