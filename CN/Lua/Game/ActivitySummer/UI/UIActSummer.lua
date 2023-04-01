-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSummer = class("UIActSummer", UIBaseWindow)
local base = UIBaseWindow
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UIActSummer.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Main, self, self.OnClickMainEp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Challenge, self, self.OnClickChallenge)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Weekly, self, self.OnClickWeekly)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ActShop, self, self.OnClickSummerShop)
  self.__OnListenUpdate = BindCallback(self, self.OnListenItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnListenUpdate)
  self.__OnRefreshTimeDayPass = BindCallback(self, self.__RefreshTimeDayPass)
  MsgCenter:AddListener(eMsgEventId.SectorActivityTimePass, self.__OnRefreshTimeDayPass)
  self._unlockMat = (((CS.UnityEngine).Object).Instantiate)(((self.ui).img_btn_Main).material)
  ;
  (self._unlockMat):SetFloat("_Intensity", 5)
  self.__OnShowSummerUI = BindCallback(self, self.OnShowSummerUI)
  self.__OnEnterSectorISector = BindCallback(self, self.OnEnterSectorISector)
end

UIActSummer.InitActivitySummer = function(self, sectorIData, normalDungeonCallback, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(3108)
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Sector).name, (eAuSelct.Sector).roomSelect)
  self.summerData = sectorIData
  self.summerCfg = (self.summerData):GetSectorICfg()
  self._coinId = (self.summerData):GetActSectorIDataCoinId()
  self.normalDungeonCallback = normalDungeonCallback
  self.closeCallback = closeCallback
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_btn_Main).material = self._unlockMat
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_btn_Challenge).material = self._unlockMat
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Item).sprite = CRH:GetSpriteByItemId(self._coinId)
  self.sectorList = {(self.summerCfg).easy_stage, (self.summerCfg).hard_stage}
  self:_PlayWinTweenOrComplete(self.summerData)
  self:RefreshSummer()
  self:__InitActReddot()
  if (self.summerCfg).first_avg > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed((self.summerCfg).first_avg)
    if not played and (self.summerData):IsActivityRunning() then
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, (self.summerCfg).first_avg)
    end
  end
end

UIActSummer.__InitActReddot = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.__onActivitySectorIReddot == nil then
    self.__onActivitySectorIReddot = function(node)
    -- function num : 0_2_0 , upvalues : self
    ((self.ui).obj_challengeRedDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    local node = (self.summerData):GetActivityReddot()
    if node:GetRedDotCount() <= 0 then
      do
        ((self.ui).obj_challengeRedDot):SetActive(node == nil)
        RedDotController:AddListener(node.nodePath, self.__onActivitySectorIReddot)
        -- DECOMPILER ERROR: 2 unprocessed JMP targets
      end
    end
  end
end

UIActSummer.RefreshSummer = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Count).text = PlayerDataCenter:GetItemCount(self._coinId)
  self:__RefreshTimeOutData()
  self:__RefreshTimeDayPass()
  self:__RefreshTimeWeeklyState()
  if PlayerDataCenter.timestamp < self._outDataTime and self.timerId == nil then
    self.timerId = TimerManager:StartTimer(1, self.OnTimerEndTimeCountDown, self)
  end
  self:OnTimerEndTimeCountDown()
end

UIActSummer.__RefreshTimeOutData = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self._outDataTime = (self.summerData):GetActivityEndTime()
  if PlayerDataCenter.timestamp < self._outDataTime then
    local date = TimeUtil:TimestampToDate(self._outDataTime, false, true)
    ;
    ((self.ui).tex_Time):SetIndex(0, (string.format)("%02d", date.year), (string.format)("%02d", date.month), (string.format)("%02d", date.day), (string.format)("%02d", date.hour), (string.format)("%02d", date.min))
    ;
    ((self.ui).challengeLockItem):SetActive(false)
    ;
    (((self.ui).tex_ChallengeCount).gameObject):SetActive(true)
  else
    do
      self._outDataTime = (self.summerData):GetActivityDestroyTime()
      do
        local date = TimeUtil:TimestampToDate(self._outDataTime, false, true)
        ;
        ((self.ui).tex_Time):SetIndex(1, (string.format)("%02d", date.year), (string.format)("%02d", date.month), (string.format)("%02d", date.day), (string.format)("%02d", date.hour), (string.format)("%02d", date.min))
        ;
        ((self.ui).challengeLockItem):SetActive(true)
        ;
        (((self.ui).tex_ChallengeCount).gameObject):SetActive(false)
        if self._outDataTime < PlayerDataCenter.timestamp and self.timerId ~= nil then
          self.timerId = TimerManager:StopTimer(self.timerId)
          self.timerId = nil
        end
      end
    end
  end
end

UIActSummer.__RefreshTimeDayPass = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local _, battleCount, allCount = (self.summerData):GetSectorIBattleCount()
  local remainCount = allCount - battleCount
  ;
  ((self.ui).tex_ChallengeCount):SetIndex(0, (string.format)("%d/%d", remainCount, allCount))
  self._nextDayTime = nil
  ;
  (((self.ui).tex_challenge_Time).gameObject):SetActive(false)
  if not (self.summerData):IsActivityRunning() then
    return 
  end
  local nextShowTime = (self.summerData):GetNextExpireTimeInShow()
  if (self.summerData):GetActivityEndTime() < nextShowTime then
    return 
  end
  ;
  (((self.ui).tex_challenge_Time).gameObject):SetActive(true)
  self._nextDayTime = nextShowTime
end

UIActSummer.__RefreshTimeWeeklyState = function(self)
  -- function num : 0_6
  local islock = false
  ;
  ((self.ui).weeklyLockItem):SetActive(islock)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).fade_Weekly).alpha = islock and 0.6 or 1
  self._weeklyTime = islock and (self.summerCfg).weekly_time or nil
end

UIActSummer.OnTimerEndTimeCountDown = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local remainTime = self._outDataTime - PlayerDataCenter.timestamp
  if remainTime > 0 then
    if remainTime > 86400 then
      ((self.ui).tex_Day):SetIndex(0, tostring((math.ceil)(remainTime / 86400)))
    else
      if remainTime > 3600 then
        ((self.ui).tex_Day):SetIndex(1, tostring((math.ceil)(remainTime / 3600)))
      else
        ;
        ((self.ui).tex_Day):SetIndex(2, tostring((math.ceil)(remainTime / 60)))
      end
    end
  else
    self:__RefreshTimeOutData()
  end
  do
    if self._weeklyTime ~= nil then
      local coutdown = self._weeklyTime - PlayerDataCenter.timestamp
      if coutdown > 0 then
        if coutdown > 86400 then
          ((self.ui).tex_unlcokTime):SetIndex(0, tostring((math.ceil)(coutdown / 86400)))
        else
          if coutdown > 3600 then
            ((self.ui).tex_unlcokTime):SetIndex(1, tostring((math.ceil)(coutdown / 3600)))
          else
            ;
            ((self.ui).tex_unlcokTime):SetIndex(2, tostring((math.ceil)(coutdown / 60)))
          end
        end
      else
        self:__RefreshTimeWeeklyState()
      end
    end
    if self._nextDayTime ~= nil then
      local coutdown = self._nextDayTime - PlayerDataCenter.timestamp
      if coutdown > 0 then
        local str = TimeUtil:TimestampToTime(coutdown)
        ;
        ((self.ui).tex_challenge_Time):SetIndex(0, str)
      else
        do
          self._nextDayTime = self:__RefreshTimeDayPass()
        end
      end
    end
  end
end

UIActSummer._PlayWinTweenOrComplete = function(self, summerData)
  -- function num : 0_8 , upvalues : _ENV
  if summerData:GetMainWindowIsFirstInit() then
    summerData:SetMainWindowIsFirstInit(false)
  else
    for _,compoment in ipairs((self.ui).DOTweens) do
      compoment:DOComplete()
    end
  end
end

UIActSummer.OnClickMainEp = function(self)
  -- function num : 0_9 , upvalues : SectorStageDetailHelper, _ENV
  if not (self.summerData):IsActivityRunning() then
    self:OnEnterSectorISector((self.summerCfg).hard_stage)
    return 
  end
  local flag, defaultSectorId = (self.summerData):GetLastSectorISector()
  if flag then
    self:OnEnterSectorISector(defaultSectorId)
    return 
  end
  if not (SectorStageDetailHelper.IsSectorNoCollide)((self.summerCfg).hard_stage, true) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSummerLvSwitch, function(window)
    -- function num : 0_9_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    local defaultSelectIndex = 1
    local stageId = ((((ConfigData.sector_stage).sectorDiffDic)[(self.summerCfg).hard_stage])[1])[1]
    if stageId ~= nil then
      local stageCfg = (ConfigData.sector_stage)[stageId]
      if stageCfg ~= nil then
        local preStageId = (stageCfg.pre_stage)[1]
      end
    end
    do
      if not (PlayerDataCenter.sectorStage):IsStageComplete(preStageId) or not #self.sectorList then
        window:InitIActSummerLvSwitch(self.sectorList, defaultSelectIndex, self.__OnEnterSectorISector)
      end
    end
  end
)
end

UIActSummer.OnClickChallenge = function(self)
  -- function num : 0_10
  if not (self.summerData):IsActivityRunning() then
    return 
  end
  self:OnEnterSectorISector((self.summerCfg).rechallenge_stage)
end

UIActSummer.OnEnterSectorISector = function(self, sectorId)
  -- function num : 0_11 , upvalues : SectorStageDetailHelper
  if (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) and self.normalDungeonCallback ~= nil then
    self:OnHideSummerUI()
    ;
    (self.normalDungeonCallback)(sectorId, 1, nil, self.__OnShowSummerUI)
  end
end

UIActSummer.OnClickWeekly = function(self)
  -- function num : 0_12 , upvalues : _ENV, JumpManager
  if PlayerDataCenter.timestamp < (self.summerCfg).weekly_time then
    return 
  end
  JumpManager:Jump((JumpManager.eJumpTarget).WeeklyChallenge)
end

UIActSummer.OnClickSummerShop = function(self)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum21Exchange, function(win)
    -- function num : 0_13_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitActSum21Exchange(self.summerData, true)
  end
)
end

UIActSummer.OnListenItemUpdate = function(self, itemUpdate)
  -- function num : 0_14 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if itemUpdate[self._coinId] ~= nil then
    ((self.ui).tex_Count).text = PlayerDataCenter:GetItemCount(self._coinId)
  end
end

UIActSummer.OnHideSummerUI = function(self)
  -- function num : 0_15 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.ActSummer)
end

UIActSummer.OnShowSummerUI = function(self)
  -- function num : 0_16 , upvalues : _ENV
  UIManager:ShowWindowOnly(UIWindowTypeID.ActSummer)
end

UIActSummer._OnClickClose = function(self, isToHome)
  -- function num : 0_17 , upvalues : _ENV
  do
    if not isToHome then
      local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
      if sectorCtrl ~= nil then
        sectorCtrl:PlaySectorBgm()
      end
    end
    if self.closeCallback ~= nil then
      (self.closeCallback)(isToHome)
    end
    self:Delete()
  end
end

UIActSummer.__RemoveActReddot = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.__onActivitySectorIReddot ~= nil then
    local node = (self.summerData):GetActivityReddot()
    if node ~= nil then
      RedDotController:RemoveListener(node.nodePath, self.__onActivitySectorIReddot)
    end
    self.__onActivitySectorIReddot = nil
  end
end

UIActSummer.OnDelete = function(self)
  -- function num : 0_19 , upvalues : base, _ENV
  (base.OnDelete)(self)
  DestroyUnityObject(self._unlockMat)
  self:__RemoveActReddot()
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnListenUpdate)
  MsgCenter:RemoveListener(eMsgEventId.SectorActivityTimePass, self.__OnRefreshTimeDayPass)
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
end

return UIActSummer

