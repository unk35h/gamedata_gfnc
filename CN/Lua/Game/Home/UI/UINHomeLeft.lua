-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHomeLeft = class("UINHomeLeft", UIBaseNode)
local base = UIBaseNode
local UINHomeBanner = require("Game.Home.Banner.UINHomeBanner")
local HomeBannerManager = require("Game.Home.Banner.HomeBannerManager")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local UINHomeGeneralBtn = require("Game.Home.UI.UINHomeGeneralBtn")
local TaskEnum = require("Game.Task.TaskEnum")
local CS_Ease = ((CS.DG).Tweening).Ease
UINHomeLeft.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, ActivityFrameEnum
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_HideUI, self, self.SetShowMainUI, false)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_ShowMain, self, self.SetShowMainUI, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelectBoardHero, self, self.OnClickChangeAdjutantBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self.OnClickTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_QuickTaskGet, self, self.OnQuickTaskGetBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HomeSide, self, self.OnClickHomeSide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Chat, self, self.OnClickHomeChat)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Friend, self, self.OnClickFriend)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_Novice, self, self.OnClickActivity, (ActivityFrameEnum.eActivityEnterType).Novice)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_Limited, self, self.OnClickActivity, (ActivityFrameEnum.eActivityEnterType).LimitTime)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_SpEvent, self, self.OnClickActivity, (ActivityFrameEnum.eActivityEnterType).Comeback)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_LukcyBag, self, self.OnClickActivity, (ActivityFrameEnum.eActivityEnterType).KeyExertion)
  self._OnKeyExertionTokenItemChangeFunc = BindCallback(self, self.__RefreshKeyExertion)
  MsgCenter:AddListener(eMsgEventId.ActivityKeyExertionTokenNumChange, self._OnKeyExertionTokenItemChangeFunc)
  self.__onTaskCommitComplete = BindCallback(self, self.OnTaskCommitComplete)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__onTaskCommitComplete)
  self.__onTaskPeroidCommit = BindCallback(self, self.OnTaskPeroidCommit)
  MsgCenter:AddListener(eMsgEventId.PeroidCommitComplete, self.__onTaskPeroidCommit)
  self.__RefreshWorldChatNewMessage = BindCallback(self, self.RefreshWorldChatNewMessage)
  MsgCenter:AddListener(eMsgEventId.OnNewWordChatDataCome, self.__RefreshWorldChatNewMessage)
  self.__RefreshActivityShow = BindCallback(self, self.RefreshActivityShow)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__RefreshActivityShow)
  ;
  (((self.ui).voiceScrollRect).gameObject):SetActive(false)
  ;
  ((self.ui).ani_VoiceIcon):SetActive(false)
  self:RefreshBannerWidget()
end

UINHomeLeft.InitHomeLeftNode = function(self, homeUI)
  -- function num : 0_1
  self.homeUI = homeUI
  self.homeController = homeUI.homeController
  self:RegistTaskRedDot()
  self:RegistSideRedDot()
  self:RegistActivityRedDot()
  self:RefreshAdjBtn()
end

UINHomeLeft.OnHomeShow = function(self)
  -- function num : 0_2
  self:RefreshTaskBtn()
  self:RefreshActivityShow()
  self:RefreshWorldChatShow()
  self:RefreshFriendBtn()
  self:RefreshAdjBtn()
end

UINHomeLeft.SetShowMainUI = function(self, bool)
  -- function num : 0_3
  (self.homeUI):SetHomeShowMainUI(bool)
  ;
  (((self.ui).btn_ShowMain).gameObject):SetActive(not bool)
end

UINHomeLeft.ShowHeroVoiceText = function(self, show, text, notShowWave, voiceDuration)
  -- function num : 0_4 , upvalues : _ENV, CS_Ease
  ((self.ui).voiceScrollRect):DOKill()
  if self._heroVoiceTextTimerId ~= nil then
    TimerManager:StopTimer(self._heroVoiceTextTimerId)
    self._heroVoiceTextTimerId = nil
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  if show then
    ((self.ui).tex_Voice).text = text
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).voiceScrollRect).verticalNormalizedPosition = 1
    self._heroVoiceTextTimerId = TimerManager:StartTimer(1, function()
    -- function num : 0_4_0 , upvalues : self, voiceDuration, CS_Ease
    self._heroVoiceTextTimerId = nil
    if voiceDuration <= 0 or ((((self.ui).tex_Voice).transform).rect).height <= ((((self.ui).voiceScrollRect).transform).rect).height then
      return 
    end
    local duration = voiceDuration * 0.8
    local delay = voiceDuration * 0.1
    ;
    (((((self.ui).voiceScrollRect):DOVerticalNormalizedPos(0, duration)):SetLink(((self.ui).voiceScrollRect).gameObject)):SetDelay(delay)):SetEase(CS_Ease.Linear)
  end
, nil, true, true, true)
  end
  if show then
    ((self.ui).ani_VoiceIcon):SetActive(not notShowWave)
    ;
    (((self.ui).voiceScrollRect).gameObject):SetActive(show)
    ;
    (((self.ui).tex_Dialog).gameObject):SetActive(not show)
  end
end

UINHomeLeft.RefreshActivityShow = function(self)
  -- function num : 0_5 , upvalues : _ENV, ActivityFrameEnum
  local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  ;
  (((self.ui).btn_Novice).gameObject):SetActive(activityCtrl:IsHaveShowByEnterType((ActivityFrameEnum.eActivityEnterType).Novice))
  ;
  (((self.ui).btn_Limited).gameObject):SetActive(activityCtrl:IsHaveShowByEnterType((ActivityFrameEnum.eActivityEnterType).LimitTime))
  ;
  (((self.ui).btn_SpEvent).gameObject):SetActive(activityCtrl:IsHaveShowByEnterType((ActivityFrameEnum.eActivityEnterType).Comeback))
  ;
  (((self.ui).btn_LukcyBag).gameObject):SetActive(activityCtrl:IsHaveShowByEnterType((ActivityFrameEnum.eActivityEnterType).KeyExertion))
  self:__RefreshComebackEntryText()
  self:__RefreshComebackTime()
  self:__RefreshKeyExertion()
end

UINHomeLeft.OnClickActivity = function(self, enterType, activityId)
  -- function num : 0_6 , upvalues : _ENV, ActivityFrameEnum
  if (ControllerManager:GetController(ControllerTypeId.HomeController)).isRunningAutoShow then
    return 
  end
  if enterType == (ActivityFrameEnum.eActivityEnterType).Comeback then
    local comebackController = ControllerManager:GetController(ControllerTypeId.ActivityComeback, true)
    local comebackData = comebackController:GetTheLatestComebackData()
    UIManager:ShowWindowAsync(comebackData:GetComebackWindowId(), function(window)
    -- function num : 0_6_0 , upvalues : self, _ENV, activityId
    if window ~= nil then
      (self.homeUI):OpenOtherWin()
      window:SetFromWhichUI(eBaseWinFromWhere.home)
      window:InitActivityCombackMain(activityId)
    end
  end
)
    return 
  end
  do
    if enterType == (ActivityFrameEnum.eActivityEnterType).KeyExertion then
      local keyExertionController = ControllerManager:GetController(ControllerTypeId.ActivityKeyExertion, true)
      local keyExertionData = keyExertionController:GetTheLatestKeyExertionData()
      if keyExertionData == nil then
        return 
      end
      keyExertionController:OpenKeyExertion(keyExertionData:GetActId(), function(window)
    -- function num : 0_6_1 , upvalues : self, _ENV
    if window ~= nil then
      (self.homeUI):OpenOtherCoverWin()
      window:SetFromWhichUI(eBaseWinFromWhere.homeCorver)
    end
  end
)
      return 
    end
    do
      UIManager:ShowWindowAsync(UIWindowTypeID.ActivityFrameMain, function(window)
    -- function num : 0_6_2 , upvalues : self, _ENV, enterType, activityId
    if window ~= nil then
      (self.homeUI):OpenOtherWin()
      window:SetFromWhichUI(eBaseWinFromWhere.home)
      window:InitFrameMain(enterType, activityId)
    end
  end
)
    end
  end
end

UINHomeLeft.OnClickHomeSide = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.sideWin == nil then
    UIManager:ShowWindowAsync(UIWindowTypeID.HomeSide, function(win)
    -- function num : 0_7_0 , upvalues : self
    if win ~= nil then
      self.sideWin = win
      ;
      (self.sideWin):InitSide(self.homeUI)
      ;
      (self.sideWin):OpenSide()
    end
  end
)
  else
    ;
    (self.sideWin):OpenSide()
  end
end

UINHomeLeft.OnClickTask = function(self, taskTypeID)
  -- function num : 0_8 , upvalues : _ENV
  local taskController = ControllerManager:GetController(ControllerTypeId.Task, false)
  if taskController == nil then
    error("get taskController error")
    return 
  end
  taskController:ShowTaskUI(taskTypeID, eBaseWinFromWhere.home, function(win)
    -- function num : 0_8_0 , upvalues : _ENV, self
    win:SetFromWhichUI(eBaseWinFromWhere.home)
    ;
    (self.homeUI):OpenOtherWin()
  end
)
end

UINHomeLeft.RefreshAdjBtn = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_MainPreset_ui)
  ;
  (((self.ui).btn_SelectBoardHero).gameObject):SetActive(isUnlock)
end

UINHomeLeft.OnClickChangeAdjutantBtn = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_MainPreset_ui) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.AdjPreset, function(window)
    -- function num : 0_10_0 , upvalues : self, _ENV
    if window == nil then
      return 
    end
    ;
    ((self.homeUI).homeAdjutant):RecordCurCubismHeroId()
    window:InitAdjPreset(function()
      -- function num : 0_10_0_0 , upvalues : self, _ENV
      if ((self.homeUI).homeAdjutant):IsChangeCubismHero() and not GuideManager.inGuide then
        (self.homeController):PlayLoginHeroGreeting()
      end
      ;
      ((self.homeUI).homeAdjutant):ClearCurCubismHeroRecord()
    end
)
    window:SetFromWhichUI(eBaseWinFromWhere.home)
  end
)
end

UINHomeLeft.RefreshWorldChatShow = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Chat)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).btn_Chat).interactable = isUnlock
  if isUnlock then
    self:RefreshWorldChatNewMessage()
    ;
    ((self.ui).img_chat):SetIndex(1)
  else
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Message).color = (self.ui).color_chatgray
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Message).fontStyle = 0
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Message).text = unlockDes
    ;
    ((self.ui).img_chat):SetIndex(0)
  end
end

UINHomeLeft.RefreshWorldChatNewMessage = function(self, removeNum, isChatRefresh)
  -- function num : 0_12 , upvalues : _ENV
  if not ((self.ui).btn_Chat).interactable then
    return 
  end
  local chatWin = UIManager:GetWindow(UIWindowTypeID.ChatSystem)
  if not isChatRefresh and chatWin ~= nil then
    return 
  end
  if (PlayerDataCenter.homeChatDataCenter):GetNewChatNum() > 0 then
    local chatData = (PlayerDataCenter.homeChatDataCenter):GetLatestChatData()
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

    if chatData == nil then
      ((self.ui).tex_Message).color = (self.ui).color_chatgray
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).fontStyle = 2
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).text = ConfigData:GetTipContent(TipContent.ChatNoNewMessage)
    else
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).color = Color.white
      -- DECOMPILER ERROR at PC52: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).fontStyle = 0
      local str = chatData:GetContent4Home()
      local index = ((self.ui).tex_Message):GetFirstLineMaxLengthStrIndex(str)
      if index ~= -1 and index < (string.len)(str) then
        str = (string.sub)(str, 1, index) .. "…"
      end
      -- DECOMPILER ERROR at PC78: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).text = str
    end
  else
    do
      -- DECOMPILER ERROR at PC84: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).color = (self.ui).color_chatgray
      -- DECOMPILER ERROR at PC87: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).fontStyle = 2
      -- DECOMPILER ERROR at PC95: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).text = ConfigData:GetTipContent(TipContent.ChatNoNewMessage)
    end
  end
end

UINHomeLeft.OnClickHomeChat = function(self)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ChatSystem, function(win)
    -- function num : 0_13_0 , upvalues : self
    if win ~= nil then
      win:InitChatSystem()
      self:RefreshWorldChatNewMessage(0, true)
    end
  end
)
end

UINHomeLeft.RefreshFriendBtn = function(self)
  -- function num : 0_14 , upvalues : UINHomeGeneralBtn, _ENV
  if self.friendBtn == nil then
    self.friendBtn = (UINHomeGeneralBtn.New)()
    ;
    (self.friendBtn):Init(((self.ui).btn_Friend).gameObject)
    ;
    (self.homeController):AddRedDotEvent((self.friendBtn):GetRedDotFunc(), RedDotStaticTypeId.Main, RedDotStaticTypeId.UserFriend)
  end
  local isUnlock, unlockDes = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Friend)
  ;
  (self.friendBtn):RefeshUnlockInfo(isUnlock, unlockDes)
end

UINHomeLeft.OnClickFriend = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if not (self.friendBtn).isUnlock then
    (self.friendBtn):ShowUnlockDes()
    return 
  end
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.UserFreined, function(win)
    -- function num : 0_15_0 , upvalues : self, _ENV
    if win ~= nil then
      (self.homeUI):OpenOtherWin()
      win:SetFromWhichUI(eBaseWinFromWhere.home)
      win:InitUserFriend()
    end
  end
)
end

UINHomeLeft.RefreshBannerWidget = function(self)
  -- function num : 0_16 , upvalues : HomeBannerManager, _ENV, UINHomeBanner
  ((self.ui).obj_advTv):SetActive(false)
  self:AdjutantBtn2Banner(false)
  HomeBannerManager:RefreshBannerDataList(function(bannerDataList)
    -- function num : 0_16_0 , upvalues : _ENV, self, UINHomeBanner
    if IsNull(self.gameObject) then
      return 
    end
    if bannerDataList ~= nil and #bannerDataList > 0 then
      if self.bannerUI == nil then
        self.bannerUI = (UINHomeBanner.New)()
        ;
        (self.bannerUI):Init((self.ui).obj_advTv)
      end
      ;
      (self.bannerUI):Show()
      ;
      (self.bannerUI):InitialHomeBanner(bannerDataList)
      self:AdjutantBtn2Banner(true)
    else
      ;
      ((self.ui).obj_advTv):SetActive(false)
      self:AdjutantBtn2Banner(false)
    end
  end
)
end

UINHomeLeft.AdjutantBtn2Banner = function(self, hasBanner)
  -- function num : 0_17 , upvalues : _ENV
  if self.hasBanner == hasBanner then
    return 
  end
  self.hasBanner = hasBanner
  local MoveX = Vector3.zero
  if hasBanner then
    MoveX = (Vector3.New)(514.475, 0, 0)
  else
    MoveX = (Vector3.New)(-514.475, 0, 0)
  end
  local hidePos = (((self.ui).btn_HideUI).transform).localPosition
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).btn_HideUI).transform).localPosition = MoveX + hidePos
  local boardHeroPos = (((self.ui).btn_SelectBoardHero).transform).localPosition
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).btn_SelectBoardHero).transform).localPosition = MoveX + boardHeroPos
end

UINHomeLeft.RegistTaskRedDot = function(self)
  -- function num : 0_18 , upvalues : _ENV
  (self.homeController):AddRedDotEvent(function(num)
    -- function num : 0_18_0 , upvalues : self
    ((self.ui).task_obj_RedDot):SetActive(num > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
, RedDotStaticTypeId.Main, RedDotStaticTypeId.Task)
end

UINHomeLeft.RegistSideRedDot = function(self)
  -- function num : 0_19 , upvalues : _ENV
  (self.homeController):AddRedDotEvent(function(num)
    -- function num : 0_19_0 , upvalues : self, _ENV
    (((self.ui).side_obj_RedDot).gameObject):SetActive(num > 0)
    if num < 10 then
      (((self.ui).tex_sideRedDotNum).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_sideRedDotNum).text = tostring(num)
      ;
      ((self.ui).side_obj_RedDot):SetIndex(0)
    else
      (((self.ui).tex_sideRedDotNum).gameObject):SetActive(false)
      ;
      ((self.ui).side_obj_RedDot):SetIndex(1)
    end
    if num > 0 then
      ((self.ui).tex_Dialog):SetIndex(2)
    else
      ((self.ui).tex_Dialog):SetIndex(1)
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
, RedDotStaticTypeId.Main, RedDotStaticTypeId.MainSide)
end

UINHomeLeft.RegistActivityRedDot = function(self)
  -- function num : 0_20 , upvalues : _ENV
  (self.homeController):AddRedDotEvent(function(num)
    -- function num : 0_20_0 , upvalues : self
    ((self.ui).redDot_activity_novice):SetActive(num > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
, RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityFrameNovice)
  ;
  (self.homeController):AddRedDotEvent(function(num)
    -- function num : 0_20_1 , upvalues : self
    ((self.ui).redDot_activity_limitTime):SetActive(num > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
, RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityFrameLimitTime)
  ;
  (self.homeController):AddRedDotEvent(function(num)
    -- function num : 0_20_2 , upvalues : self
    ((self.ui).redDot_comeback):SetActive(num > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
, RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityComeback)
  ;
  (self.homeController):AddRedDotEvent(function(num)
    -- function num : 0_20_3 , upvalues : self
    ((self.ui).redDot_luckyBag):SetActive(num > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
, RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityKeyExertion)
end

UINHomeLeft.OnQuickTaskGetBtn = function(self)
  -- function num : 0_21 , upvalues : _ENV, TaskEnum
  if self.__quickTaskData == nil then
    return 
  end
  local taskController = ControllerManager:GetController(ControllerTypeId.Task)
  if taskController ~= nil then
    local taskIds = {(TaskEnum.eTaskType).MainTask, (TaskEnum.eTaskType).DailyTask, (TaskEnum.eTaskType).WeeklyTask, (TaskEnum.eTaskType).LargeActivityTask, (TaskEnum.eTaskType).HeroActivityTask}
    local ids, perodicDic = taskController:GetAllRewards(taskIds)
    if (table.count)(ids) >= 1 then
      taskController:SendOneKeyPick(ids)
    end
    if (table.count)(perodicDic) > 0 then
      for type,dic in pairs(perodicDic) do
        taskController:SendCommitTaskPeriodArray(dic, type)
      end
    end
    do
      do
        do return  end
        if self.__quickIsPeroid then
          (ControllerManager:GetController(ControllerTypeId.Task, true)):SendCommitTaskPeriod(((self.__quickTaskData).stcData).id, ((self.__quickTaskData).stcData).type)
        else
          local isTaskCompelete = (self.__quickTaskData):CheckComplete()
          if not isTaskCompelete then
            return 
          end
          ;
          (ControllerManager:GetController(ControllerTypeId.Task, true)):SendCommitQuestReward(self.__quickTaskData)
        end
      end
    end
  end
end

UINHomeLeft.RefreshTaskBtn = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local isUnlock = (self.homeController):IsFuncUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_TaskUi)
  ;
  (((self.ui).btn_Task).gameObject):SetActive(isUnlock)
  if not isUnlock then
    return 
  end
  local taskData, isTaskCompelete, isPeroid = (PlayerDataCenter.allTaskData):GetTaskData4Home()
  self.__quickTaskData = taskData
  self.__quickIsPeroid = isPeroid
  if taskData == nil then
    ((self.ui).tex_TaskInfo):SetIndex(1)
    ;
    (((self.ui).btn_QuickTaskGet).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).btn_QuickTaskGet).gameObject):SetActive(isTaskCompelete)
  if self.__quickIsPeroid then
    local infoContent = ""
    local strbase = (LanguageUtil.GetLocaleText)(ConfigData:GetTipTag(TipTag.questsTag, ((self.__quickTaskData).stcData).type))
    if not (string.IsNullOrEmpty)(strbase) then
      infoContent = (string.format)(strbase, ((self.__quickTaskData).stcData).id)
    else
      warn("task type is not a period,type:" .. tostring(((self.__quickTaskData).stcData).type) .. " local_text_id:" .. tostring(((ConfigData.game_config).taskPeroidInfo)[((self.__quickTaskData).stcData).type]))
    end
    ;
    ((self.ui).tex_TaskInfo):SetIndex(0, infoContent)
  else
    do
      if taskData.schedule <= taskData.aim then
        ((self.ui).tex_TaskInfo):SetIndex(0, taskData:GetTaskFirstStepIntro())
        return 
      end
    end
  end
end

UINHomeLeft.OnTaskCommitComplete = function(self, taskStcData)
  -- function num : 0_23
  if self.__quickIsPeroid then
    return 
  end
  if self.__quickTaskData == nil or taskStcData == nil then
    return 
  end
  if (self.__quickTaskData).id == taskStcData.id then
    self:RefreshTaskBtn()
  end
end

UINHomeLeft.OnTaskPeroidCommit = function(self, peroidData)
  -- function num : 0_24
  if not self.__quickIsPeroid then
    return 
  end
  if self.__quickTaskData == peroidData then
    self:RefreshTaskBtn()
  end
end

UINHomeLeft.__RefreshKeyExertion = function(self, tokenId)
  -- function num : 0_25 , upvalues : _ENV
  local keyExertionCtrl = ControllerManager:GetController(ControllerTypeId.ActivityKeyExertion)
  if keyExertionCtrl == nil then
    return 
  end
  local keyExertionData = keyExertionCtrl:GetTheLatestKeyExertionData()
  if keyExertionData == nil then
    return 
  end
  local destroyTm = keyExertionData:GetActivityDestroyTime()
  if destroyTm <= PlayerDataCenter.timestamp then
    return 
  end
  local currentTokenId = keyExertionData:GetKeyExertionTokenId()
  if tokenId ~= nil and tokenId ~= currentTokenId then
    return 
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_LukcyBag).texture = (self.resloader):LoadABAsset(PathConsts:GetActivityKeyExertionPath((keyExertionData:GetKeyExertionMainCfg()).enter_picture))
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(currentTokenId)
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(keyExertionData:GetKeyExertionPackageFragmentNum()), tostring(keyExertionData:GetKeyExertionPackageFragmentMaxNum()))
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (keyExertionData.actInfo).name
end

UINHomeLeft.__RefreshComebackEntryText = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback)
  if comebackCtrl == nil then
    return 
  end
  local comebackData = comebackCtrl:GetTheLatestComebackData()
  if comebackData == nil then
    return 
  end
  local destroyTm = comebackData:GetActivityDestroyTime()
  if destroyTm <= PlayerDataCenter.timestamp then
    return 
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_comebackText).text = comebackData:GetComebackEntryText()
end

UINHomeLeft.__RefreshComebackTime = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if self._comebackTimerId ~= nil then
    TimerManager:StopTimer(self._comebackTimerId)
    self._comebackTimerId = nil
  end
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback)
  if comebackCtrl == nil then
    return 
  end
  local comebackData = comebackCtrl:GetTheLatestComebackData()
  if comebackData == nil then
    return 
  end
  local destroyTm = comebackData:GetActivityDestroyTime()
  if destroyTm <= PlayerDataCenter.timestamp then
    return 
  end
  local Local_TimeFunc = function()
    -- function num : 0_27_0 , upvalues : destroyTm, _ENV, self
    local diffTime = destroyTm - PlayerDataCenter.timestamp
    if diffTime <= 0 then
      if self._comebackTimerId ~= nil then
        TimerManager:StopTimer(self._comebackTimerId)
        self._comebackTimerId = nil
      end
      ;
      ((self.ui).tex_Comeback_Time):SetIndex(2, "0")
      return 
    end
    if diffTime < 3600 then
      ((self.ui).tex_Comeback_Time):SetIndex(2, tostring((math.floor)(diffTime / 60)))
    else
      if diffTime < 86400 then
        ((self.ui).tex_Comeback_Time):SetIndex(1, tostring((math.floor)(diffTime / 3600)))
      else
        ;
        ((self.ui).tex_Comeback_Time):SetIndex(0, tostring((math.floor)(diffTime / 86400)))
      end
    end
  end

  self._comebackTimerId = TimerManager:StartTimer(1, Local_TimeFunc, nil, false)
  Local_TimeFunc()
end

UINHomeLeft.OnDelete = function(self)
  -- function num : 0_28 , upvalues : _ENV, base
  if self.sideWin ~= nil then
    (self.sideWin):Delete()
    self.sideWin = nil
  end
  if self.bannerUI ~= nil then
    (self.bannerUI):Delete()
    self.bannerUI = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self._heroVoiceTextTimerId ~= nil then
    TimerManager:StopTimer(self._heroVoiceTextTimerId)
    self._heroVoiceTextTimerId = nil
  end
  if self._comebackTimerId ~= nil then
    TimerManager:StopTimer(self._comebackTimerId)
    self._comebackTimerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__onTaskCommitComplete)
  MsgCenter:RemoveListener(eMsgEventId.PeroidCommitComplete, self.__onTaskPeroidCommit)
  MsgCenter:RemoveListener(eMsgEventId.OnNewWordChatDataCome, self.__RefreshWorldChatNewMessage)
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__RefreshActivityShow)
  MsgCenter:RemoveListener(eMsgEventId.ActivityKeyExertionTokenNumChange, self._OnKeyExertionTokenItemChangeFunc)
  ;
  (base.OnDelete)(self)
end

return UINHomeLeft

