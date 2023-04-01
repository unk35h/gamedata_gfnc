-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHalloween22Main = class("UIHalloween22Main", UIBaseWindow)
local base = UIBaseWindow
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
local cs_MessageCommon = CS.MessageCommon
UIHalloween22Main.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseHalloween)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_LimitTask, self, self.OnClickTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reward, self, self.OnClickReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.OnClickBattle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_StoryReview, self, self.OnClickStoryReview)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Achievement, self, self.OnClickAchievement)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Guide, self, self.OnClickGuide)
  self.__RefreshCallback = BindCallback(self, self.__Refresh)
  MsgCenter:AddListener(eMsgEventId.ActivityHallowmas, self.__RefreshCallback)
  MsgCenter:AddListener(eMsgEventId.WCS_ExitAndClear, self.__RefreshCallback)
end

UIHalloween22Main.InitHalloween22 = function(self, actHallowmasData, enterFunc, backCallback)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(3350)
  self._backCallback = backCallback
  self._data = actHallowmasData
  self._enterFunc = enterFunc
  self._cfg = (self._data):GetHallowmasMainCfg()
  self:__RefreshFix()
  self:__Refresh()
  if (self._cfg).guide_id > 0 then
    (UIUtil.SetTopStateInfoFunc)(self, function()
    -- function num : 0_1_0 , upvalues : _ENV, self
    local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
    ;
    (GuidePicture.OpenGuidePicture)((self._cfg).guide_id, nil)
  end
)
  end
  if self._timerId == nil then
    self._timerId = TimerManager:StartTimer(1, BindCallback(self, self.__TimeCountdown), self)
  end
  self._reddot = (self._data):GetActivityReddot()
  if self._reddot ~= nil then
    self._reddotFunc = BindCallback(self, self.__RefreshReddot)
    RedDotController:AddListener((self._reddot).nodePath, self._reddotFunc)
    self:__RefreshReddot(self._reddot)
  end
  local avgid = (self._cfg).first_avg
  if avgid > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed(avgid)
    if not played and (self._data):IsActivityRunning() then
      self:Hide()
      ;
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgid, function()
    -- function num : 0_1_1 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self:Show()
    GuideManager:StartNewGuide((self._cfg).first_guide)
  end
)
      return 
    end
  end
end

UIHalloween22Main.__RefreshFix = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local nameCfg = ConfigData.activity_hallowmas_name
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskName).text = (LanguageUtil.GetLocaleText)((nameCfg[1]).name)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_RewardName).text = (LanguageUtil.GetLocaleText)((nameCfg[2]).name)
  local guideSecotorId = ((self._data):GetHallowmasMainCfg()).guide_stage
  local secotrCfg = (ConfigData.sector)[guideSecotorId]
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_guide).text = (LanguageUtil.GetLocaleText)(secotrCfg.name)
end

UIHalloween22Main.__Refresh = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local taskCount = (table.count)((self._data):GetHallowmasDailyTaskIdDic())
  local taskLimit = (self._cfg).task_limit
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskNum).text = tostring(taskCount) .. "/" .. tostring(taskLimit)
  local exp = (self._data):GetHallowmasCurExp()
  local expLimit = (self._data):GetHallowmasCurExpLimit()
  ;
  ((self.ui).tex_RewardLv):SetIndex(0, tostring((self._data):GetHallowmasLv()))
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_RewardPoint).text = tostring(exp) .. "/" .. tostring(expLimit)
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  ;
  ((self.ui).obj_Jump):SetActive(isUnComplete)
end

UIHalloween22Main.__TimeCountdown = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._expireTime == nil or PlayerDataCenter.timestamp < self._expireTime then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._data)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).text).text = title
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Timer).text = timeStr
      self._expireTime = expireTime
    end
    local diffStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._expireTime)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Day).text = diffStr
    if diff <= 0 then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UIHalloween22Main.EnterHallowmasSector = function(self, selectSector)
  -- function num : 0_5
  if selectSector ~= ((self._data):GetHallowmasMainCfg()).story_stage then
    return 
  end
  self:OnClickStoryReview()
end

UIHalloween22Main.__RefreshReddot = function(self, reddot)
  -- function num : 0_6 , upvalues : ActivityHallowmasEnum
  local taskRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).DailyTask)
  local expRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Exp)
  local achievementRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Achievement)
  local sectorAvgRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).SectorAvg)
  local taskRedCount = taskRed ~= nil and taskRed:GetRedDotCount() or 0
  local expRedCount = expRed ~= nil and expRed:GetRedDotCount() or 0
  local achievementRedCount = achievementRed ~= nil and achievementRed:GetRedDotCount() or 0
  local sectorAvgRedCount = sectorAvgRed ~= nil and sectorAvgRed:GetRedDotCount() or 0
  ;
  ((self.ui).red_task):SetActive(taskRedCount > 0)
  ;
  ((self.ui).red_reward):SetActive(expRedCount > 0)
  ;
  ((self.ui).red_achienement):SetActive(achievementRedCount > 0)
  ;
  ((self.ui).red_storyReview):SetActive(sectorAvgRedCount > 0)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIHalloween22Main.OnClickTask = function(self)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Halloween22Task, function(win)
    -- function num : 0_7_0 , upvalues : self
    if win ~= nil then
      win:InitHalloweenTask(self._data)
    end
  end
)
end

UIHalloween22Main.OnClickReward = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Halloween22Bouns, function(win)
    -- function num : 0_8_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitHalloween22Bouns(self._data)
  end
)
end

UIHalloween22Main.OnClickBattle = function(self)
  -- function num : 0_9 , upvalues : _ENV, SectorStageDetailHelper
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  do
    if isUnComplete then
      local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
      ctrl:ContinuehallowmasSeason()
      return 
    end
    if not (SectorStageDetailHelper.IsWarchessSeasonNoCollide)(((self._data):GetHallowmasMainCfg()).warchess_season_id, true) then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.Halloween22ModeSelect, function(win)
    -- function num : 0_9_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitModeSelect(self._data)
  end
)
  end
end

UIHalloween22Main.OnClickGuide = function(self)
  -- function num : 0_10 , upvalues : _ENV, cs_MessageCommon
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  do
    if isUnComplete then
      local tips = ConfigData:GetTipContent(((self._data):GetHallowmasMainCfg()).ban_guide_tip)
      ;
      (cs_MessageCommon.ShowMessageTips)(tips)
      return 
    end
    if self._enterFunc ~= nil then
      self:Hide()
      ;
      (self._enterFunc)(((self._data):GetHallowmasMainCfg()).guide_stage, 1, nil, function()
    -- function num : 0_10_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:Show()
    end
  end
)
    end
  end
end

UIHalloween22Main.OnClickStoryReview = function(self)
  -- function num : 0_11 , upvalues : SectorStageDetailHelper, _ENV
  if not (SectorStageDetailHelper.IsSectorNoCollide)(((self._data):GetHallowmasMainCfg()).story_stage, true) then
    return 
  end
  if self._enterFunc ~= nil then
    self:Hide()
    ;
    (self._enterFunc)(((self._data):GetHallowmasMainCfg()).story_stage, 1, nil, function()
    -- function num : 0_11_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:Show()
    end
  end
)
  end
end

UIHalloween22Main.OnClickAchievement = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Halloween22Achievement, function(win)
    -- function num : 0_12_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitHalloween22Achievement(self._data)
  end
)
end

UIHalloween22Main.OnCloseHalloween = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:PlaySectorBgm()
  end
  self:Delete()
  if self._backCallback ~= nil then
    (self._backCallback)(false)
  end
end

UIHalloween22Main.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
    self._reddot = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivityHallowmas, self.__RefreshCallback)
  MsgCenter:RemoveListener(eMsgEventId.WCS_ExitAndClear, self.__RefreshCallback)
  ;
  (base.OnDelete)(self)
end

return UIHalloween22Main

