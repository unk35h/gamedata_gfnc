-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivityKeyExertionTask = class("UINActivityKeyExertionTask", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local CS_DOTweenAnimation = ((CS.DG).Tweening).DOTweenAnimation
local cs_Ease = ((CS.DG).Tweening).Ease
UINActivityKeyExertionTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Receive, self, self.OnClickConfirm)
end

UINActivityKeyExertionTask.InitActivityKeyExertionTask = function(self, taskId, rewardFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._taskId = taskId
  self._taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(self._taskId, true)
  self._rewardFunc = rewardFunc
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Tip).text = (LanguageUtil.GetLocaleText)(((self._taskData).stcData).task_intro)
  local firstRewardIds, _ = (self._taskData):GetTaskCfgRewards()
  local firstRewardCfg = (ConfigData.item)[firstRewardIds[1]]
  local itemName = (LanguageUtil.GetLocaleText)(firstRewardCfg.name)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Reward).sprite = CRH:GetSpriteByItemId(firstRewardCfg.id)
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = itemName
  self:RefreshKeyExertionTask()
end

UINActivityKeyExertionTask.GetActivityKeyExertionId = function(self)
  -- function num : 0_2
  return self._taskId
end

UINActivityKeyExertionTask.RefreshKeyExertionTask = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).slider).value = schedule / aim
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Count).text = tostring(schedule) .. "/" .. tostring(aim)
  if not (self._taskData).isPicked then
    local isComplete = (self._taskData):CheckComplete()
    ;
    (((self.ui).btn_Receive).gameObject):SetActive(isComplete)
    ;
    ((self.ui).current):SetActive(not isComplete)
    ;
    ((self.ui).received):SetActive(false)
  else
    do
      ;
      (((self.ui).btn_Receive).gameObject):SetActive(false)
      ;
      ((self.ui).current):SetActive(false)
      ;
      ((self.ui).received):SetActive(true)
    end
  end
end

UINActivityKeyExertionTask.RefreshKeyExertionTaskPicked = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self._taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(self._taskId, true)
  self:RefreshKeyExertionTask()
end

UINActivityKeyExertionTask.OnClickConfirm = function(self)
  -- function num : 0_5
  if (self._taskData):CheckComplete() and self._rewardFunc ~= nil then
    (self._rewardFunc)(self._taskData, self)
  end
end

return UINActivityKeyExertionTask

