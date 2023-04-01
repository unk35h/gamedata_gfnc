-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivityHalloweenTask = class("UINActivityHalloweenTask", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local CS_DOTweenAnimation = ((CS.DG).Tweening).DOTweenAnimation
local cs_Ease = ((CS.DG).Tweening).Ease
UINActivityHalloweenTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnClickRefreshTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self.OnClickConfirm)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINActivityHalloweenTask.InitHalloweenTask = function(self, taskId, refreshFunc, rewardFunc, jumpFunc)
  -- function num : 0_1 , upvalues : _ENV
  self:ShowHalloweenTween()
  self._taskId = taskId
  self._taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(self._taskId, true)
  self._refreshFunc = refreshFunc
  self._rewardFunc = rewardFunc
  self._jumpFunc = jumpFunc
  self:__RefreshFix()
  self:RefreshHalloweenTask()
end

UINActivityHalloweenTask.__RefreshFix = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Des).text = (self._taskData):GetTaskFirstStepIntro()
  ;
  (self._rewardPool):HideAll()
  local ids, nums = (self._taskData):GetTaskCfgRewards()
  for i,rewardId in ipairs(ids) do
    local rewardNum = nums[i]
    local itemCfg = (ConfigData.item)[rewardId]
    local item = (self._rewardPool):GetOne()
    item:InitItemWithCount(itemCfg, rewardNum)
  end
end

UINActivityHalloweenTask.RefreshHalloweenTaskPicked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(self._taskId, true)
  self:RefreshHalloweenTask()
end

UINActivityHalloweenTask.RefreshHalloweenTask = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fill).fillAmount = schedule / aim
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(schedule) .. "/" .. tostring(aim)
  for i,v in ipairs((self._rewardPool).listItem) do
    v:SetPickedUIActive((self._taskData).isPicked)
  end
  if not (self._taskData).isPicked then
    local isComplete = (self._taskData):CheckComplete()
    ;
    (((self.ui).img_Clear).gameObject):SetActive(isComplete)
    if isComplete then
      ((self.ui).img_Jump):SetIndex(1)
      ;
      ((self.ui).tex_Jump):SetIndex(1)
      ;
      (((self.ui).btn_Jump).gameObject):SetActive(true)
    else
      if ((self._taskData).stcData).jump_id or 0 > 0 then
        ((self.ui).img_Jump):SetIndex(0)
        ;
        ((self.ui).tex_Jump):SetIndex(0)
        ;
        (((self.ui).btn_Jump).gameObject):SetActive(true)
      else
        ;
        (((self.ui).btn_Jump).gameObject):SetActive(false)
      end
    end
  else
    do
      ;
      (((self.ui).btn_Jump).gameObject):SetActive(false)
      ;
      (((self.ui).img_Clear).gameObject):SetActive(true)
    end
  end
end

UINActivityHalloweenTask.RefreshHalloweenRefBtn = function(self, flag)
  -- function num : 0_5
  if flag then
    if not (self._taskData).isPicked then
      flag = not (self._taskData):CheckComplete()
    else
      flag = false
    end
  end
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(flag)
end

UINActivityHalloweenTask.SetHalloweenGhost = function(self, index)
  -- function num : 0_6
  self._index = index
  ;
  ((self.ui).img_Ghost):SetIndex(index - 1)
end

UINActivityHalloweenTask.GetHalloweenGhost = function(self)
  -- function num : 0_7
  return self._index
end

UINActivityHalloweenTask.OnClickRefreshTask = function(self)
  -- function num : 0_8
  if self._refreshFunc ~= nil then
    (self._refreshFunc)(self._taskData, self)
  end
end

UINActivityHalloweenTask.ShowHalloweenTween = function(self)
  -- function num : 0_9 , upvalues : _ENV, cs_Ease
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).item).alpha = 1
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).img_Clear).transform).localScale = Vector3.one
  local color = ((self.ui).img_Clear).color
  color.a = 1
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Clear).color = color
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).img_Ghost).transform).localRotation = (Quaternion.Euler)(0, 0, 0)
  color = (((self.ui).img_Ghost).image).color
  color.a = 1
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).img_Ghost).image).color = color
  ;
  ((((self.transform):DOMoveY(-100, 0.5)):From()):SetEase(cs_Ease.OutQuart)):SetRelative(true)
  ;
  ((((self.ui).item):DOFade(0, 0.5)):From()):SetEase(cs_Ease.OutQuart)
  ;
  (((((self.ui).img_Clear).transform):DOScale((Vector3.New)(2, 2, 2), 0.5)):From()):SetEase(cs_Ease.InQuart)
  ;
  ((((self.ui).img_Clear):DOFade(0, 0.5)):From()):SetEase(cs_Ease.OutQuart)
  ;
  (((((self.ui).img_Ghost).image):DOFade(0, 0.5)):From()):SetEase(cs_Ease.OutQuart)
  ;
  (((((self.ui).img_Ghost).transform):DORotateQuaternion((Quaternion.Euler)(0, 0, 30), 0.5)):From()):SetEase(cs_Ease.InOutSine)
end

UINActivityHalloweenTask.HideHalloweenTween = function(self, callback)
  -- function num : 0_10
  (self.transform):DOMoveY(20, 0.5)
  ;
  (((self.ui).item):DOFade(0, 0.5)):OnComplete(callback)
end

UINActivityHalloweenTask.OnClickConfirm = function(self)
  -- function num : 0_11
  -- DECOMPILER ERROR at PC11: Unhandled construct in 'MakeBoolean' P1

  if (self._taskData):CheckComplete() and self._rewardFunc ~= nil then
    (self._rewardFunc)(self._taskData, self)
  end
  if not (self._taskData).isPicked and self._jumpFunc ~= nil then
    (self._jumpFunc)(self._taskData)
  end
end

UINActivityHalloweenTask.GetHalloweenTaskId = function(self)
  -- function num : 0_12
  return self._taskId
end

return UINActivityHalloweenTask

