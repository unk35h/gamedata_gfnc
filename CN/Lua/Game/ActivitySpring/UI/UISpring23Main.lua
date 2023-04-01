-- params : ...
-- function num : 0 , upvalues : _ENV
local UISpring23Main = class("UISpring23Main", UIBaseWindow)
local base = UIBaseWindow
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local cs_MessageCommon = CS.MessageCommon
UISpring23Main.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseSpring)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_story, self, self.OnClickStory)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_hard, self, self.OnClickStory)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_StartListen, self, self.OnClickStrartPlay)
end

UISpring23Main.InitSpring23Main = function(self, actSpringData, enterFunc, backCallback)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(3360)
  self._data = actSpringData
  self._enterFunc = enterFunc
  self._backCallback = backCallback
end

UISpring23Main.__TryOpenNewUnlock = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local actUnlockInfo = (self._data):GetActHallowmasUnlockInfo()
  if actUnlockInfo:IsExistActUnlockInfo() then
    UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Unlock, function(window)
    -- function num : 0_2_0 , upvalues : _ENV, self, actUnlockInfo
    if window == nil then
      return 
    end
    window:Christmas22UnlockBindFunc(BindCallback(self, self.OnClickStorySector), BindCallback(self, self.OnClickSeason), BindCallback(self, self.OnClickDungeon))
    window:InitChristmas22NewUnlock(actUnlockInfo, self._data)
  end
)
  end
end

UISpring23Main.EnterChristmas22Sector = function(self, selectSector)
  -- function num : 0_3
  if selectSector ~= (self._cfg).story_stage then
    return 
  end
  self:OnClickStorySector()
end

UISpring23Main.__OnTimeDown = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._expireTime == nil or PlayerDataCenter.timestamp < self._expireTime then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._data)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).title).text = title
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Timer).text = timeStr
      self._expireTime = expireTime
    end
    local diffStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._expireTime)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Days).text = diffStr
    if diff <= 0 then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UISpring23Main.__Refresh = function(self)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).tex_bound_Progress):SetIndex(0, tostring((self._data):GetHallowmasLv()), tostring((self._data):GetHallowmasCurExp()), tostring((self._data):GetHallowmasCurExpLimit()))
  local taskCount = (table.count)((self._data):GetHallowmasDailyTaskIdDic())
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_task_Progress).text = tostring(taskCount) .. "/" .. tostring((self._cfg).task_limit)
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  ;
  ((self.ui).img_ListeningBg):SetActive(isUnComplete)
end

UISpring23Main.__RefreshReddot = function(self, reddot)
  -- function num : 0_6 , upvalues : ActivityHallowmasEnum, _ENV
  local taskRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).DailyTask)
  local expRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Exp)
  local achievementRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Achievement)
  local sectorAvgRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).SectorAvg)
  local techRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Tech)
  local taskRedCount = taskRed ~= nil and taskRed:GetRedDotCount() or 0
  local expRedCount = expRed ~= nil and expRed:GetRedDotCount() or 0
  local achievementRedCount = achievementRed ~= nil and achievementRed:GetRedDotCount() or 0
  local sectorAvgRedCount = sectorAvgRed ~= nil and sectorAvgRed:GetRedDotCount() or 0
  local techRedCount = techRed ~= nil and techRed:GetRedDotCount() or 0
  ;
  ((self._btnNodeDic)[BtnEnum.StorySector]):SetChristmasBtnRed(sectorAvgRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Tech]):SetChristmasBtnRed(techRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Bonus]):SetChristmasBtnRed(expRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Task]):SetChristmasBtnRed(taskRedCount > 0 or achievementRedCount > 0)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UISpring23Main.SetXMasDunSectorCallback = function(self, callback)
  -- function num : 0_7
  self.xMasDunCallback = callback
end

UISpring23Main.OnClickStory = function(self)
  -- function num : 0_8
end

UISpring23Main.OnClickHardDun = function(self)
  -- function num : 0_9
end

UISpring23Main.OnClickSeason = function(self)
  -- function num : 0_10 , upvalues : _ENV, SectorStageDetailHelper
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  do
    if isUnComplete then
      local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
      ctrl:ContinuehallowmasSeason()
      return 
    end
    if not (SectorStageDetailHelper.IsWarchessSeasonNoCollide)((self._cfg).warchess_season_id, true) then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22ModeSelect, function(window)
    -- function num : 0_10_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitChristmas22ModeSelect(self._data)
  end
)
  end
end

UISpring23Main.OnClickStrartPlay = function(self)
  -- function num : 0_11 , upvalues : _ENV, SectorStageDetailHelper
  if self._data == nil then
    error("spring act data not exist")
    return 
  end
  local mainCfg = (self._data):GetSpringMainCfg()
  local sectorId = mainCfg.main_stage
  if not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23LevelModSelect, function(window)
    -- function num : 0_11_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitSpring23ModeSelect(self._data)
  end
)
end

UISpring23Main.OnCloseSpring = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:PlaySectorBgm()
  end
  self:Delete()
  if self._backCallback then
    (self._backCallback)(false)
  end
end

UISpring23Main.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
    self._reddot = nil
  end
  ;
  (base.OnDelete)(self)
end

return UISpring23Main

