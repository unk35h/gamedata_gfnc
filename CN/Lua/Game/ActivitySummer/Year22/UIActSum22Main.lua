-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum22Main = class("UIActSum22Main", UIBaseWindow)
local base = UIBaseWindow
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local cs_MovieManager = (CS.MovieManager).Instance
local cs_MessageCommon = CS.MessageCommon
local UINActSum22MainBtn = require("Game.ActivitySummer.Year22.UINActSum22MainBtn")
local ActivitySectorIIIEnum = require("Game.ActivitySectorIII.ActivitySectorIIIEnum")
local SnakeGameController = require("Game.TinyGames.Snake.SnakeGameController")
UIActSum22Main.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActSum22MainBtn
  (UIUtil.SetTopStatus)(self, self.OnClickSum22Close, nil, self.ShowInfoFunc)
  local btnFuncTable = {[1] = self.OnEnterMainSecotrLevel, [2] = self.OnClickTask, [3] = self.OnEnterDeputySectorLevel, [4] = self.OnClickShop, [5] = self.OnClickTech, [6] = self.OnClickGame, [7] = self.OnClickRepeatLevel}
  self._btnDic = {}
  local winCfg = ConfigData.activity_summer_entrance_name
  for i,cfg in ipairs(winCfg) do
    if ((self.ui).btnNode_array)[i] ~= nil then
      local item = (UINActSum22MainBtn.New)()
      item:Init(((self.ui).btnNode_array)[i])
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._btnDic)[i] = item
      local isUnlock = cfg.unlock_time <= PlayerDataCenter.timestamp
      local bindCallback = BindCallback(self, btnFuncTable[i])
      local bindLockCallback = BindCallback(self, self.OnClickLocked, cfg.unlock_time)
      item:InitSum22Btn(cfg, isUnlock, bindCallback, bindLockCallback)
      if not isUnlock then
        if self._waitLockBtnDic == nil then
          self._waitLockBtnDic = {}
          self._waitLockTimeCount = 0
        end
        -- DECOMPILER ERROR at PC82: Confused about usage of register: R12 in 'UnsetPending'

        if (self._waitLockBtnDic)[cfg.unlock_time] == nil then
          (self._waitLockBtnDic)[cfg.unlock_time] = {}
          self._waitLockTimeCount = self._waitLockTimeCount + 1
        end
        ;
        (table.insert)((self._waitLockBtnDic)[cfg.unlock_time], i)
      end
    end
  end
  self.__CoinRefreshCallback = BindCallback(self, self.__CoinRefresh)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__CoinRefreshCallback)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIActSum22Main.OnShow = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnShow)(self)
  self:__PlayEnterEffect()
end

UIActSum22Main.InitSum22Main = function(self, sum22Data, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_MovieManager
  AudioManager:PlayAudioById(3340)
  self._sum22Data = sum22Data
  self._callback = callback
  if self._timerId == nil then
    self._timerId = TimerManager:StartTimer(1, self.__TimeCountdown, self)
  end
  self._sum22Cfg = (self._sum22Data):GetSectorIIIMainCfg()
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Token).sprite = CRH:GetSpriteByItemId((self._sum22Cfg).token_item, true)
  local nextTime = (self._sum22Cfg).main2nd_start
  local timeData = TimeUtil:TimestampToDate(nextTime, false, true)
  local timeStr = (string.format)("%d/%02d/%02d %02d:%02d", timeData.year, timeData.month, timeData.day, timeData.hour, timeData.min)
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_tip).text = (string.format)(ConfigData:GetTipContent(7126), timeStr)
  self:__TimeCountdown()
  self:__CoinRefresh()
  self._actReddot = (self._sum22Data):GetActivityReddot()
  if self._actReddot ~= nil then
    self:__RefreshActReddot(self._actReddot)
    self.__RefreshActReddotCallback = BindCallback(self, self.__RefreshActReddot)
    RedDotController:AddListener((self._actReddot).nodePath, self.__RefreshActReddotCallback)
  end
  local loadNoive_func = function()
    -- function num : 0_2_0 , upvalues : self, cs_MovieManager, _ENV
    if self.moviePlayer == nil then
      self.moviePlayer = cs_MovieManager:GetMoviePlayer()
    end
    ;
    (self.moviePlayer):SetVideoRender((self.ui).movie)
    local path = PathConsts:GetAvgVideoPath((self._sum22Cfg).bg_video)
    ;
    (self.moviePlayer):PlayVideo(path, nil, 1, false)
    ;
    (self.moviePlayer):SetLoopSeek(30, 179, false)
    ;
    (self.moviePlayer):StartSeek(0)
  end

  local info_func = function()
    -- function num : 0_2_1 , upvalues : _ENV
    local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
    ;
    (GuidePicture.OpenGuidePicture)(26, nil, true)
  end

  local avgid = (self._sum22Cfg).first_avg
  if avgid > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    do
      local played = avgPlayCtrl:IsAvgPlayed(avgid)
      local actId = (self._sum22Data):GetActId()
      if not played and (self._sum22Data):IsActivityRunning() then
        self:Hide()
        ;
        (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgid, function()
    -- function num : 0_2_2 , upvalues : _ENV, self, loadNoive_func, actId, info_func
    if IsNull(self.transform) then
      return 
    end
    self:Show()
    loadNoive_func()
    if not (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetSum22ActEnter(actId) then
      info_func()
      ;
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetSum22ActEnter(actId)
    end
  end
)
        return 
      else
        if not (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetSum22ActEnter(actId) then
          info_func()
          ;
          (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetSum22ActEnter(actId)
        end
      end
    end
  end
  do
    loadNoive_func()
  end
end

UIActSum22Main.SelectSum22Sector = function(self, sectorId)
  -- function num : 0_3
  if sectorId == (self._sum22Cfg).main_sector then
    self:OnEnterMainSecotrLevel()
  else
    if sectorId == (self._sum22Cfg).story_stage then
      self:OnEnterDeputySectorLevel()
    end
  end
end

UIActSum22Main.__TimeCountdown = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActivityFrameUtil
  if self._waitLockBtnDic ~= nil then
    for time,ids in pairs(self._waitLockBtnDic) do
      if time < PlayerDataCenter.timestamp then
        for _,index in ipairs(ids) do
          local item = (self._btnDic)[index]
          item:RefreshSum22BtnUnlock()
        end
        -- DECOMPILER ERROR at PC22: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self._waitLockBtnDic)[time] = nil
        self._waitLockTimeCount = self._waitLockTimeCount - 1
      end
    end
    if self._waitLockTimeCount == 0 then
      self._waitLockBtnDic = nil
      self._waitLockTimeCount = nil
    end
  end
  do
    if self._nextTime or 0 < PlayerDataCenter.timestamp then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._sum22Data)
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_endTime).text = title .. "  " .. timeStr
      self._nextTime = expireTime
    end
    local countdownStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._nextTime)
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_countDown).text = countdownStr
    if diff < 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UIActSum22Main.__CoinRefresh = function(self)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Token).text = tostring(PlayerDataCenter:GetItemCount((self._sum22Cfg).token_item))
end

UIActSum22Main.OnEnterMainSecotrLevel = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not (self._sum22Data):IsActivityRunning() then
    return 
  end
  self:Hide()
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22Map, function(win)
    -- function num : 0_6_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitSum22Map(self._sum22Data, function()
      -- function num : 0_6_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:Show()
      end
    end
)
  end
)
end

UIActSum22Main.OnClickTask = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if not (self._sum22Data):IsActivityRunning() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22Task, function(win)
    -- function num : 0_7_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitSum22Task(self._sum22Data, function()
      -- function num : 0_7_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:__PlayEnterEffect()
      end
    end
)
  end
)
end

UIActSum22Main.OnEnterDeputySectorLevel = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self:Hide()
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevel, function(win)
    -- function num : 0_8_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitSectorLevel((self._sum22Cfg).story_stage, function()
      -- function num : 0_8_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:Show()
      end
    end
, nil, nil, nil)
  end
)
end

UIActSum22Main.OnClickShop = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22Shop, function(win)
    -- function num : 0_9_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitSum22Shop(self._sum22Data, function()
      -- function num : 0_9_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:__PlayEnterEffect()
      end
    end
)
  end
)
end

UIActSum22Main._DelayWindowActive = function(self, active)
  -- function num : 0_10 , upvalues : _ENV
  if active then
    TimerManager:StopTimer(self._activeTimerId)
    self:Show()
  else
    self._activeTimerId = TimerManager:StartTimer(1, self.Hide, self, true)
  end
end

UIActSum22Main.OnClickTech = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22StrategyMain, function(win)
    -- function num : 0_11_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitActSum22StrategyMain(self._sum22Data)
  end
)
end

UIActSum22Main.OnClickGame = function(self)
  -- function num : 0_12 , upvalues : SnakeGameController, _ENV
  local snakeCtrl = (SnakeGameController.New)(self._sum22Data, false)
  snakeCtrl:EnterSnakeGame()
  local sum22Data = self._sum22Data
  snakeCtrl:BindSnakeExitEvent(function()
    -- function num : 0_12_0 , upvalues : _ENV, sum22Data
    local loadMapUIFunc = function()
      -- function num : 0_12_0_0 , upvalues : _ENV, sum22Data
      UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22Main, function(win)
        -- function num : 0_12_0_0_0 , upvalues : sum22Data, _ENV
        if win == nil then
          return 
        end
        win:InitSum22Main(sum22Data, function()
          -- function num : 0_12_0_0_0_0 , upvalues : _ENV
          local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
          if sectorCtrl ~= nil then
            sectorCtrl:ResetToNormalState()
            sectorCtrl:PlaySectorBgm()
          end
        end
)
      end
)
    end

    ;
    ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
      -- function num : 0_12_0_1 , upvalues : _ENV, loadMapUIFunc
      local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
      sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMapUIFunc, nil)
    end
)
  end
)
end

UIActSum22Main.OnClickRepeatLevel = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if not (self._sum22Data):IsActivityRunning() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22DunRepeat, function(win)
    -- function num : 0_13_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    self:_DelayWindowActive(false)
    win:InitSum22DunRepeat(self._sum22Data, function()
      -- function num : 0_13_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:_DelayWindowActive(true)
        self:__PlayEnterEffect()
      end
    end
)
  end
)
end

UIActSum22Main.OnClickLocked = function(self, time)
  -- function num : 0_14 , upvalues : _ENV, cs_MessageCommon
  local str = (os.date)(ConfigData:GetTipContent(921), time)
  ;
  (cs_MessageCommon.ShowMessageTipsWithErrorSound)(str)
end

UIActSum22Main.__PlayEnterEffect = function(self)
  -- function num : 0_15 , upvalues : _ENV
  for i,v in ipairs((self.ui).tweens_show) do
    v:DORewind()
    v:DOPlayForward()
  end
  for i,v in ipairs((self.ui).anis_enter) do
    v:Play()
  end
end

UIActSum22Main.OnClickSum22Close = function(self, isToHome)
  -- function num : 0_16 , upvalues : _ENV
  do
    if not isToHome then
      local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
      if sectorCtrl ~= nil then
        sectorCtrl:PlaySectorBgm()
      end
    end
    self:Delete()
    if self._callback ~= nil then
      (self._callback)(false)
    end
  end
end

UIActSum22Main.ShowInfoFunc = function()
  -- function num : 0_17 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)(26, nil)
end

UIActSum22Main.__RefreshActReddot = function(self, actRedDot)
  -- function num : 0_18 , upvalues : ActivitySectorIIIEnum
  local taskNode = actRedDot:GetChild((ActivitySectorIIIEnum.eActRedDotTypeId).task)
  local techNode = actRedDot:GetChild((ActivitySectorIIIEnum.eActRedDotTypeId).tech)
  local mapNode = actRedDot:GetChild((ActivitySectorIIIEnum.eActRedDotTypeId).map)
  local isTaskRed = taskNode ~= nil and taskNode:GetRedDotCount() > 0
  local isTechRed = techNode ~= nil and techNode:GetRedDotCount() > 0
  local isMapRed = mapNode ~= nil and mapNode:GetRedDotCount() > 0
  ;
  ((self.ui).taskRedDot):SetActive(isTaskRed)
  ;
  ((self.ui).techBlueDot):SetActive(isTechRed)
  ;
  ((self.ui).mapBlueDot):SetActive(isMapRed or isTechRed)
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UIActSum22Main.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV, cs_MovieManager, base
  if self._actReddot ~= nil then
    RedDotController:RemoveListener((self._actReddot).nodePath, self.__RefreshActReddotCallback)
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__CoinRefreshCallback)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  TimerManager:StopTimer(self._activeTimerId)
  if self.moviePlayer ~= nil then
    (self.moviePlayer):ReSet()
    cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  for i,v in ipairs((self.ui).tweens_show) do
    v:DOKill()
  end
  ;
  (base.OnDelete)(self)
end

return UIActSum22Main

