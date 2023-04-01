-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayEventNode = class("UINWhiteDayEventNode", UIBaseNode)
local base = UIBaseNode
local JumpManager = require("Game.Jump.JumpManager")
UINWhiteDayEventNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.__OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_TaskBtn, self, self.__OnClickTaskBtn)
end

UINWhiteDayEventNode.InitWDEventNode = function(self, AWDCtrl, AWDLineData, closeCallback)
  -- function num : 0_1
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
  self.closeCallback = closeCallback
  self:RefreshWDEventHeroUI()
  self:RefreshWDEventTaskUI()
end

UINWhiteDayEventNode.RefreshWDEventHeroUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local assistHeroId = (self.AWDLineData):GetWDLDAssistHeroID()
  if assistHeroId == nil then
    local isGirl = ((PlayerDataCenter.inforData):GetSex())
    -- DECOMPILER ERROR at PC9: Overwrote pending register: R3 in 'AssignReg'

    local headId = .end
    if isGirl then
      headId = ConstGlobalItem.ProfessorGridHead
    else
      headId = ConstGlobalItem.ProfessorBodyHead
    end
    local cfg = (ConfigData.portrait)[headId]
    if cfg == nil then
      return 
    end
    local icon = cfg.icon
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R6 in 'UnsetPending'

    if not (string.IsNullOrEmpty)(icon) then
      ((self.ui).img_HeroPic).sprite = CRH:GetSprite(icon, CommonAtlasType.HeroHeadIcon)
    end
  else
    do
      local heroData = (PlayerDataCenter.heroDic)[assistHeroId]
      local skinId = heroData.skinId
      -- DECOMPILER ERROR at PC51: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).img_HeroPic).sprite = CRH:GetHeroSkinSprite(assistHeroId, skinId)
    end
  end
end

UINWhiteDayEventNode.RefreshWDEventTaskUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local taskId = (self.AWDLineData):GetWDLEventTaksId()
  local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
  local taskCfg = (ConfigData.task)[taskId]
  if taskData == nil or taskCfg == nil or (ConfigData.taskStep)[taskId] == nil then
    self:__OnClickClose()
    return 
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Task).text = taskData:GetTaskFirstStepIntro()
  local isComplete = taskData:CheckComplete()
  ;
  ((self.ui).tex_Complete):SetActive(isComplete)
  ;
  (((self.ui).tex_ProgressBar).gameObject):SetActive(not isComplete)
  if isComplete then
    ((self.ui).tex_TaskBtn):SetIndex(1)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).slider_task).value = 1
  else
    local schedule, aim = taskData:GetTaskProcess()
    ;
    ((self.ui).tex_TaskBtn):SetIndex(0)
    ;
    ((self.ui).tex_ProgressBar):SetIndex(0, tostring(schedule), tostring(aim))
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).slider_task).value = schedule / aim
  end
  do
    for index,itemId in ipairs(taskCfg.rewardIds) do
      local itemNum = (taskCfg.rewardNums)[index]
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        return 
      end
      if itemCfg.action_type == eItemActionType.ActExp then
        ((self.ui).tex_Award):SetIndex(0, tostring(itemNum))
        break
      end
      if itemCfg.action_type == eItemActionType.ActAcc then
        ((self.ui).tex_Award):SetIndex(1, TimeUtil:TimestampToTime(itemNum))
        break
      end
      do
        do
          local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
          ;
          ((self.ui).tex_Award):SetIndex(2, itemName, tostring(itemNum))
          do break end
          -- DECOMPILER ERROR at PC128: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
    local eventType = ((ConfigData.activity_white_day_event).taskId2TypeDic)[taskId]
    if eventType == nil then
      error("can\'t get WD event task\'s event type")
    end
    local eventCfg = (ConfigData.activity_white_day_event)[eventType]
    -- DECOMPILER ERROR at PC148: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_EventDesc).text = (LanguageUtil.GetLocaleText)(eventCfg.event_des)
    self.taskData = taskData
    self.taskCfg = taskCfg
    self.isComplete = isComplete
  end
end

UINWhiteDayEventNode.__OnClickTaskBtn = function(self)
  -- function num : 0_4 , upvalues : _ENV, JumpManager
  -- DECOMPILER ERROR at PC9: Unhandled construct in 'MakeBoolean' P1

  if self.isComplete and self.taskData ~= nil then
    local AWDData = (self.AWDLineData):GetAWDData()
    do
      local TryPlayExp = function()
    -- function num : 0_4_0 , upvalues : self, AWDData, _ENV
    (self.AWDCtrl):WDTryShowFactroyLevelUp(AWDData, function()
      -- function num : 0_4_0_0 , upvalues : _ENV
      local whiteDayWin = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
      if whiteDayWin ~= nil then
        (whiteDayWin.infoBtnNode):TryPlayWDLevelExpTween()
      end
    end
)
  end

      local showReward = function()
    -- function num : 0_4_1 , upvalues : self, _ENV, TryPlayExp
    local lineId = (self.AWDLineData):GetWDLDLineID()
    MsgCenter:Broadcast(eMsgEventId.WhiteDayOrderChange, lineId)
    local rewards, nums = (self.taskData):GetTaskCfgRewards()
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = (CommonRewardData.CreateCRDataUseList)(rewards, nums)
    CRData:SetCRShowOverFunc(TryPlayExp)
    if CRData:IsCRDHasCouldShow() then
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_4_1_0 , upvalues : CRData
      if window == nil then
        return 
      end
      window:AddAndTryShowReward(CRData)
    end
)
    else
      TryPlayExp()
    end
    self:__OnClickClose()
    if (table.indexof)(rewards, ConstGlobalItem.WhiteTimeShort) then
      MsgCenter:Broadcast(eMsgEventId.WhiteDayOrderChange, (self.AWDLineData):GetWDLDLineID(), true)
    end
  end

      ;
      (self.AWDCtrl):WDEndlessTaskCommit(AWDData, (self.taskData).id, showReward)
    end
  end
  do
    if self.taskCfg == nil then
      return 
    end
    local jumpId = (self.taskCfg).jump_id
    local jumpArgs = (self.taskCfg).jumpArgs
    if jumpId ~= nil and jumpId > 0 then
      JumpManager:Jump(jumpId, function(jumpCallback)
    -- function num : 0_4_2
    if jumpCallback ~= nil then
      jumpCallback()
    end
  end
, nil, jumpArgs)
    end
  end
end

UINWhiteDayEventNode.__OnClickClose = function(self)
  -- function num : 0_5
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
end

UINWhiteDayEventNode.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayEventNode

