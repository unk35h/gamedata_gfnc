-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum22Task = class("UIActSum22Task", UIBaseWindow)
local base = UIBaseWindow
local UINActSum22TaskItem = require("Game.ActivitySummer.Year22.Task.UINActSum22TaskItem")
local cs_MessageCommon = CS.MessageCommon
UIActSum22Task.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActSum22TaskItem
  (UIUtil.SetTopStatus)(self, self.OnClickTaskClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Tip, self, self.OnClickTip)
  self._taskPool = (UIItemPool.New)(UINActSum22TaskItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self.__SendCommitTaskCallback = BindCallback(self, self.__SendCommitTask)
  self.__SendRefreshTaskCallback = BindCallback(self, self.__SendRefreshTask)
  self.__RefreshTaskCallback = BindCallback(self, self.__RefreshTask)
  MsgCenter:AddListener(eMsgEventId.ActivitySectorIIIDayTimeout, self.__RefreshTaskCallback)
end

UIActSum22Task.InitSum22Task = function(self, sum22Data, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._sum22Data = sum22Data
  self._callback = callback
  local mainCfg = (self._sum22Data):GetSectorIIIMainCfg()
  self._taskLimitCount = mainCfg.task_limit
  ;
  (self._taskPool):HideAll()
  for i = 1, self._taskLimitCount do
    local item = (self._taskPool):GetOne()
    item:InitSum22TaskItem(i, self._sum22Data, self.__SendCommitTaskCallback, self.__SendRefreshTaskCallback)
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7127))
  if self._timerId == nil then
    self._timerId = TimerManager:StartTimer(1, self.__TimerCountdown, self)
    self:__TimerCountdown()
  end
  self:__RefreshTask()
end

UIActSum22Task.__RefreshTask = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local taskIdList = (self._sum22Data):GetSectorIIITaskIds()
  for i,item in ipairs((self._taskPool).listItem) do
    local taskData = nil
    if taskIdList[i] ~= nil then
      taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskIdList[i])
    end
    item:Refresh22TaskItem(taskData)
  end
  local taskCurCount = #taskIdList
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Number).text = tostring(taskCurCount) .. "/" .. tostring(self._taskLimitCount)
  local isFull = taskCurCount == self._taskLimitCount
  ;
  ((self.ui).time):SetActive(not isFull)
  ;
  ((self.ui).limit):SetActive(isFull)
  local times, maxTimes = (self._sum22Data):GetSectorIIITaskRefTimes()
  ;
  ((self.ui).tex_RefreshTimes):SetIndex(0, tostring(maxTimes - times), tostring(maxTimes))
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIActSum22Task.__SendCommitTask = function(self, taskData)
  -- function num : 0_3 , upvalues : _ENV
  if not taskData:CheckComplete() then
    return 
  end
  ;
  (self._sum22Data):ReqCommitSectorIIITask(taskData, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self:__RefreshTask()
  end
)
end

UIActSum22Task.__SendRefreshTask = function(self, taskData)
  -- function num : 0_4 , upvalues : _ENV, cs_MessageCommon
  if taskData:CheckComplete() then
    return 
  end
  local times, maxTimes = (self._sum22Data):GetSectorIIITaskRefTimes()
  local tip = ConfigData:GetTipContent(7129)
  tip = (string.format)(tip, tostring(maxTimes - times), tostring(maxTimes))
  ;
  (cs_MessageCommon.ShowMessageBox)(tip, function()
    -- function num : 0_4_0 , upvalues : self, taskData, _ENV
    (self._sum22Data):ReqChangeSectorIIITask(taskData.id, function()
      -- function num : 0_4_0_0 , upvalues : _ENV, self
      if IsNull(self.transform) then
        return 
      end
      self:__RefreshTask()
    end
)
  end
, nil)
end

UIActSum22Task.__TimerCountdown = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local expireTime = (self._sum22Data):GetActSectorIIIExpireTime()
  local diff = expireTime - PlayerDataCenter.timestamp
  diff = (math.max)(diff, 0)
  local d, h, m, s = TimeUtil:TimestampToTimeInter((math.floor)(diff), false, true)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = (string.format)("%02d:%02d:%02d", h, m, s)
end

UIActSum22Task.OnClickTip = function(self)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(win)
    -- function num : 0_6_0 , upvalues : self
    if win == nil then
      return 
    end
    local mainCfg = (self._sum22Data):GetSectorIIIMainCfg()
    win:InitCommonInfoByRule(mainCfg.task_rule_id, true)
  end
)
end

UIActSum22Task.OnClickTaskClose = function(self)
  -- function num : 0_7
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIActSum22Task.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivitySectorIIIDayTimeout, self.__RefreshTaskCallback)
  ;
  (base.OnDelete)(self)
end

return UIActSum22Task

