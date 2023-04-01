-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayTaskItem = class("UINWhiteDayTaskItem", UIBaseNode)
local base = UIBaseNode
local JumpManager = require("Game.Jump.JumpManager")
UINWhiteDayTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self.__OnClickJump)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Complete, self, self.__OnClickComplete)
end

UINWhiteDayTaskItem.InitWDTaskItem = function(self, AWDCtrl, taskId, isMult, multRateText, multRate, isEndless, completeTask)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
  local taskCfg = (ConfigData.task)[taskId]
  if taskCfg == nil then
    return 
  end
  self.taskId = taskId
  self.isMult = isMult
  self.multRate = multRate
  self.taskData = taskData
  self.taskCfg = taskCfg
  self.isEndless = isEndless
  self.completeTask = completeTask
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(taskCfg.name)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(taskCfg.task_intro)
  local rewardId, rewardNum = nil, nil
  for index,itemId in pairs(taskCfg.rewardIds) do
    rewardId = itemId
    rewardNum = (taskCfg.rewardNums)[index]
    do break end
  end
  do
    ;
    ((self.ui).tex_Count):SetIndex(0, tostring(rewardNum))
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(rewardId)
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R12 in 'UnsetPending'

    if taskData == nil then
      ((self.ui).slider_progress).value = 1
      ;
      ((self.ui).img_Completed):SetActive(true)
      ;
      (((self.ui).btn_Jump).gameObject):SetActive(false)
      ;
      (((self.ui).btn_Complete).gameObject):SetActive(false)
      ;
      (((self.ui).tex_ProgressBar).gameObject):SetActive(false)
      ;
      ((self.ui).tex_Complete):SetActive(true)
    else
      local isComplete = taskData:CheckComplete()
      ;
      ((self.ui).img_Completed):SetActive(false)
      ;
      (((self.ui).btn_Jump).gameObject):SetActive(not isComplete)
      ;
      (((self.ui).btn_Complete).gameObject):SetActive(isComplete)
      ;
      (((self.ui).tex_ProgressBar).gameObject):SetActive(not isComplete)
      ;
      ((self.ui).tex_Complete):SetActive(isComplete)
      -- DECOMPILER ERROR at PC126: Confused about usage of register: R13 in 'UnsetPending'

      if isComplete then
        ((self.ui).slider_progress).value = 1
      else
        local schedule, aim = taskData:GetTaskProcess()
        ;
        ((self.ui).tex_ProgressBar):SetIndex(0, tostring(schedule), tostring(aim))
        -- DECOMPILER ERROR at PC144: Confused about usage of register: R15 in 'UnsetPending'

        ;
        ((self.ui).slider_progress).value = schedule / aim
      end
    end
    do
      ;
      ((self.ui).obj_MultLabel):SetActive(isMult)
      -- DECOMPILER ERROR at PC154: Confused about usage of register: R12 in 'UnsetPending'

      if isMult then
        ((self.ui).tex_MultLabel).text = multRateText
      end
    end
  end
end

UINWhiteDayTaskItem.__OnClickJump = function(self)
  -- function num : 0_2 , upvalues : JumpManager, _ENV
  if self.taskCfg == nil then
    return 
  end
  local Jump = function()
    -- function num : 0_2_0 , upvalues : self, JumpManager, _ENV
    local jumpId = (self.taskCfg).jump_id
    local jumpArgs = (self.taskCfg).jumpArgs
    if jumpId ~= nil and jumpId > 0 then
      JumpManager:Jump(jumpId, function(jumpCallback)
      -- function num : 0_2_0_0 , upvalues : _ENV
      (UIUtil.OnClickBack)()
      if jumpCallback ~= nil then
        jumpCallback()
      end
    end
, nil, jumpArgs)
    end
  end

  local game2048Ctrl = (self.AWDCtrl):GetWD2048GameCtrl()
  if game2048Ctrl ~= nil and game2048Ctrl:IsGame2048Started() then
    ((CS.MessageCommon).ShowMessageBox)(ConfigData:GetTipContent(7200), function()
    -- function num : 0_2_1 , upvalues : Jump
    Jump()
  end
, nil)
    return 
  end
  Jump()
end

UINWhiteDayTaskItem.__OnClickComplete = function(self)
  -- function num : 0_3
  if self.completeTask ~= nil then
    (self.completeTask)(self)
  end
end

UINWhiteDayTaskItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayTaskItem

