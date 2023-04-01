-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSectorTaskItem = class("UINSectorTaskItem", UIBaseNode)
local base = UIBaseNode
local TaskEnum = require("Game.Task.TaskEnum")
UINSectorTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.isPicking = false
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).Btn_TaskItem, self, self.__OnTaskItemClick)
  self.originSizeDelta = {x = (((self.ui).rect_Process).sizeDelta).x, y = (((self.ui).rect_Process).sizeDelta).y}
end

UINSectorTaskItem.RefreshSectorTaskItem = function(self, taskData, iconIndex, onClickAction)
  -- function num : 0_1
  self.taskData = taskData
  self.__onClickAction = onClickAction
  ;
  ((self.ui).img_IconItemInfo):SetIndex(iconIndex)
  self:__RefreshTaskItemUI()
  self:__RefreshColor()
end

UINSectorTaskItem.__RefreshTaskItemUI = function(self)
  -- function num : 0_2 , upvalues : _ENV, TaskEnum
  local stcData = (self.taskData).stcData
  local taskStepCfg = ((ConfigData.taskStep)[stcData.id])[1]
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  if taskStepCfg ~= nil then
    ((self.ui).tex_Intro).text = (self.taskData):GetTaskFirstStepIntro()
  else
    error("can\'t read taskStepCfg id:" .. tostring(((self.taskData).stcData).id))
  end
  if #stcData.rewardIds > 0 then
    local rewardId = (stcData.rewardIds)[1]
    local rewardNum = (stcData.rewardNums)[1]
    local itemCfg = (ConfigData.item)[rewardId]
    ;
    ((self.ui).obj_ResNode):SetActive(true)
    ;
    ((self.ui).tex_Count):SetIndex(0, tostring(rewardNum))
  else
    do
      ;
      ((self.ui).obj_ResNode):SetActive(false)
      ;
      ((self.ui).obj_bar):SetActive(false)
      ;
      (((self.ui).tex_Num).gameObject):SetActive(false)
      ;
      ((self.ui).obj_Completed):SetActive(false)
      ;
      ((self.ui).obj_Picked):SetActive(false)
      local hideProgress = ((self.taskData).stcData).is_hideProgress
      local cfg = (ConfigData.active_level)[(self.taskData).id]
      if cfg ~= nil and cfg.is_daily == true then
        ((self.ui).obj_dailyNode):SetActive(true)
        self:RefreshRemainingTime(PlayerDataCenter.timestamp)
        self.isDailyTask = true
      else
        ;
        ((self.ui).obj_dailyNode):SetActive(false)
        self.isDailyTask = false
      end
      if (self.taskData):CheckComplete() then
        ((self.ui).img_State):SetIndex(1)
        ;
        ((self.ui).obj_Completed):SetActive(true)
        if not hideProgress then
          ((self.ui).obj_bar):SetActive(true)
          local schedule, aim = (self.taskData):GetTaskProcess()
          -- DECOMPILER ERROR at PC140: Confused about usage of register: R7 in 'UnsetPending'

          ;
          ((self.ui).rect_Process).sizeDelta = (Vector2.New)((self.originSizeDelta).x, (self.originSizeDelta).y)
        end
      else
        do
          if (self.taskData).state == (TaskEnum.eTaskState).InProgress then
            ((self.ui).img_State):SetIndex(0)
            if not hideProgress then
              ((self.ui).obj_bar):SetActive(true)
              ;
              (((self.ui).tex_Num).gameObject):SetActive(true)
              local schedule, aim = (self.taskData):GetTaskProcess()
              -- DECOMPILER ERROR at PC180: Confused about usage of register: R7 in 'UnsetPending'

              ;
              ((self.ui).rect_Process).sizeDelta = (Vector2.New)(schedule / aim * (self.originSizeDelta).x, (self.originSizeDelta).y)
              -- DECOMPILER ERROR at PC195: Confused about usage of register: R7 in 'UnsetPending'

              ;
              ((self.ui).tex_Num).text = tostring((math.min)(schedule, aim)) .. "/" .. tostring(aim)
            end
          else
            do
              ;
              ((self.ui).img_State):SetIndex(2)
              ;
              ((self.ui).obj_Picked):SetActive(true)
            end
          end
        end
      end
    end
  end
end

UINSectorTaskItem.RefreshRemainingTime = function(self, timestamp)
  -- function num : 0_3 , upvalues : _ENV
  if not self.isDailyTask then
    return 
  end
  local nextTime = TimeUtil:TimestampToDate((math.floor)(TimeUtil:TimpApplyLogicOffset(timestamp)))
  nextTime.hour = 0
  nextTime.min = 0
  nextTime.sec = 0
  local nextRefreshTimestamp = TimeUtil:DateToTimestamp(nextTime) + 86400 + 3600 * TimeUtil:GetDayPassTime()
  local remainTimestamp = (math.max)((math.floor)(nextRefreshTimestamp - timestamp), 0)
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remainTimestamp, false, true)
  if h < 10 or not tostring(h) then
    local hStr = "0" .. tostring(h)
  end
  if m < 10 or not tostring(m) then
    local mStr = "0" .. tostring(m)
  end
  if s < 10 or not tostring(s) then
    local sStr = "0" .. tostring(s)
  end
  ;
  ((self.ui).tex_refreshTime):SetIndex(0, hStr, mStr, sStr)
end

UINSectorTaskItem.__OnTaskItemClick = function(self)
  -- function num : 0_4
  (self.__onClickAction)(self.taskData)
end

UINSectorTaskItem.__RefreshColor = function(self)
  -- function num : 0_5 , upvalues : _ENV, TaskEnum
  local color = Color.white
  if (self.taskData).state == (TaskEnum.eTaskState).Picked then
    color = (self.ui).col_picked
  else
    if not (self.taskData):CheckComplete() then
      color = (self.ui).col_inProgress
    end
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Intro).color = color
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).color = color
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).tex_Count).text).color = color
end

UINSectorTaskItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINSectorTaskItem

