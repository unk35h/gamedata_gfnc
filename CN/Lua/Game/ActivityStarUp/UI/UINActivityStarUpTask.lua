-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivityStarUpTask = class("UINActivityStarUpTask", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local JumpManager = require("Game.Jump.JumpManager")
UINActivityStarUpTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self.OnClickGet)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Goto, self, self.OnClickGoto)
  ;
  ((self.ui).rewardItem):SetActive(false)
  self.rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
end

UINActivityStarUpTask.InitItem = function(self, activityInfo, taskInfo)
  -- function num : 0_1 , upvalues : _ENV
  self.activityInfo = activityInfo
  self.taskInfo = taskInfo
  local isFinish = taskInfo.state == proto_object_QuestState.QuestStateCompleted
  ;
  (self.rewardPool):HideAll()
  for i,v in ipairs((taskInfo.stcData).rewardIds) do
    local item = (self.rewardPool):GetOne(true)
    local itemCfg = (ConfigData.item)[v]
    local num = ((taskInfo.stcData).rewardNums)[i]
    item:InitItemWithCount(itemCfg, num, nil, isFinish)
  end
  ;
  ((self.ui).tex_TaskIntro):SetIndex(isFinish and 0 or 1, (LanguageUtil.GetLocaleText)((taskInfo.stcData).name))
  self:UpdateUI()
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINActivityStarUpTask.UpdateUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.taskInfo).state == proto_object_QuestState.QuestStateCompleted then
    ((self.ui).img_Buttom):SetIndex(2)
  else
    if (self.taskInfo):CheckComplete() then
      ((self.ui).img_Buttom):SetIndex(1)
    else
      ;
      ((self.ui).img_Buttom):SetIndex(0)
    end
  end
  ;
  ((self.ui).obj_Unfinish):SetActive(false)
  ;
  ((self.ui).obj_Completed):SetActive(false)
  ;
  (((self.ui).btn_Get).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Goto).gameObject):SetActive(false)
  local isFinish = (self.taskInfo).state == proto_object_QuestState.QuestStateCompleted
  local isPicked = (self.taskInfo).state == proto_object_QuestState.QuestStateExpired
  if not isFinish then
    local isComplect = (self.taskInfo):CheckComplete()
  end
  local isCanjump = ((self.taskInfo).stcData).jump_id ~= nil and ((self.taskInfo).stcData).jump_id > 0
  ;
  (((self.ui).btn_Goto).gameObject):SetActive((not isComplect and not isPicked and isCanjump))
  ;
  (((self.ui).obj_Unfinish).gameObject):SetActive((not isComplect and not isPicked and not isCanjump))
  if isComplect then
    (((self.ui).btn_Get).gameObject):SetActive(not isFinish)
    ;
    ((self.ui).obj_Completed):SetActive((not isComplect and isPicked))
    local schedule, aim = (self.taskInfo):GetTaskProcess()
    -- DECOMPILER ERROR at PC140: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_Progress).text = tostring(schedule) .. "/" .. tostring(aim)
    local progress = schedule / aim
    if progress >= 1 or not progress then
      progress = 1
    end
    self.barWidth = ((((self.ui).bar).rectTransform).rect).width
    local vec = (((self.ui).img_Fill).rectTransform).sizeDelta
    vec.x = self.barWidth * progress
    -- DECOMPILER ERROR at PC163: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (((self.ui).img_Fill).rectTransform).sizeDelta = vec
    for i,v in ipairs((self.rewardPool).listItem) do
      v:SetPickedUIActive(isFinish)
    end
    -- DECOMPILER ERROR: 15 unprocessed JMP targets
  end
end

UINActivityStarUpTask.OnClickGoto = function(self)
  -- function num : 0_3 , upvalues : JumpManager
  if ((self.taskInfo).stcData).jump_id ~= nil and ((self.taskInfo).stcData).jump_id > 0 then
    JumpManager:Jump(((self.taskInfo).stcData).jump_id, nil, nil, ((self.taskInfo).stcData).jumpArgs)
  end
end

UINActivityStarUpTask.OnClickGet = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local actFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  actFrameNet:CS_Activity_Quest_Commit((self.activityInfo):GetActivityFrameId(), (self.taskInfo).id, function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    (self.activityInfo):UpdateStarUpRedddot()
    if IsNull(self.transform) or not self._showCommonReward then
      return 
    end
    local ids, nums = (self.taskInfo):GetTaskCfgRewards()
    local rewardDic = {}
    for i,id in ipairs(ids) do
      rewardDic[id] = nums[i]
    end
    ;
    (UIUtil.ShowCommonReward)(rewardDic)
  end
)
end

UINActivityStarUpTask.SetActLimitTaskShowCommonReward = function(self)
  -- function num : 0_5
  self._showCommonReward = true
end

UINActivityStarUpTask.UpdActLimitTaskIsNew = function(self, isNew)
  -- function num : 0_6
  ((self.ui).obj_New):SetActive(isNew)
end

UINActivityStarUpTask.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallBack)
  ;
  (base.OnDelete)(self)
end

return UINActivityStarUpTask

