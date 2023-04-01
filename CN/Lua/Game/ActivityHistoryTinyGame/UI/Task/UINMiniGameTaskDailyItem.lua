-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameTaskDailyItem = class("UINMiniGameTaskDailyItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local TaskEnum = require("Game.Task.TaskEnum")
UINMiniGameTaskDailyItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Receive, self, self.OnClickReview)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnClickRefresh)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self._normalColor = ((self.ui).bottom).color
end

UINMiniGameTaskDailyItem.InitMiniGameTaskDailyItem = function(self, actTinyData, taskData, isDaily, callback, refreshcallback)
  -- function num : 0_1 , upvalues : _ENV
  self._actTinyData = actTinyData
  self._taskData = taskData
  self._callback = callback
  self._refreshcallback = refreshcallback
  self._isDaily = isDaily
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Details).text = taskData:GetTaskFirstStepIntro()
  local rewardIds, rewardNums = taskData:GetTaskCfgRewards()
  ;
  (self._rewardPool):HideAll()
  for i,id in ipairs(rewardIds) do
    local count = rewardNums[i]
    local itemCfg = (ConfigData.item)[id]
    local item = (self._rewardPool):GetOne()
    item:InitItemWithCount(itemCfg, count)
  end
  self:RefreshMiniGameTaskDailyItem()
end

UINMiniGameTaskDailyItem.RefreshMiniGameTaskDailyItem = function(self)
  -- function num : 0_2 , upvalues : _ENV, TaskEnum
  local schedule, aim = (self._taskData):GetTaskProcess()
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(schedule), tostring(aim))
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).slider).value = schedule / aim
  local isFinish = (self._taskData).state == (TaskEnum.eTaskState).Picked
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  if isFinish then
    ((self.ui).img_Background).color = (self.ui).color_hasReview
    ;
    (((self.ui).btn_Refresh).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Receive).gameObject):SetActive(false)
    ;
    ((self.ui).finished):SetActive(true)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).taskItem).alpha = 0.7
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).mission).color = Color.white
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (((self.ui).tex_Progress).text).color = Color.white
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Details).color = Color.white
    -- DECOMPILER ERROR at PC73: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).fill).color = Color.white
    return 
  end
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).taskItem).alpha = 1
  local isCanjump = ((self._taskData).stcData).jump_id ~= nil and ((self._taskData).stcData).jump_id > 0
  local isComplete = (self._taskData):CheckComplete()
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(self._isDaily)
  ;
  ((self.ui).finished):SetActive(false)
  ;
  (((self.ui).btn_Receive).gameObject):SetActive(isComplete or isCanjump)
  ;
  ((self.ui).receive):SetIndex(isComplete and 0 or 1)
  -- DECOMPILER ERROR at PC127: Confused about usage of register: R6 in 'UnsetPending'

  if isComplete then
    ((self.ui).bottom).color = self._normalColor
    -- DECOMPILER ERROR at PC133: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).receive).text).color = Color.white
    -- DECOMPILER ERROR at PC138: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_Background).color = Color.white
    -- DECOMPILER ERROR at PC143: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).mission).color = (self.ui).color_block_text
    -- DECOMPILER ERROR at PC149: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).tex_Progress).text).color = (self.ui).color_block_text
    -- DECOMPILER ERROR at PC154: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Details).color = (self.ui).color_block_text
    -- DECOMPILER ERROR at PC158: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).fill).color = self._normalColor
  else
    -- DECOMPILER ERROR at PC164: Confused about usage of register: R6 in 'UnsetPending'

    ((self.ui).bottom).color = Color.white
    -- DECOMPILER ERROR at PC170: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).receive).text).color = (self.ui).color_block_text
    -- DECOMPILER ERROR at PC175: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_Background).color = (self.ui).color_hasReview
    -- DECOMPILER ERROR at PC180: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).mission).color = Color.white
    -- DECOMPILER ERROR at PC186: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).tex_Progress).text).color = Color.white
    -- DECOMPILER ERROR at PC191: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Details).color = Color.white
    -- DECOMPILER ERROR at PC196: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).fill).color = Color.white
  end
  -- DECOMPILER ERROR: 9 unprocessed JMP targets
end

UINMiniGameTaskDailyItem.OnClickReview = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._taskData)
  end
end

UINMiniGameTaskDailyItem.OnClickRefresh = function(self)
  -- function num : 0_4
  if self._refreshcallback ~= nil then
    (self._refreshcallback)(self._taskData)
  end
end

return UINMiniGameTaskDailyItem

