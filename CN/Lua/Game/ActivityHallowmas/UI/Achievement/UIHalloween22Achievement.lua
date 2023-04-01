-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHalloween22Achievement = class("UIHalloween22Achievement", UIBaseWindow)
local base = UIBaseWindow
local UINHalloweenAchievementStar = require("Game.ActivityHallowmas.UI.Achievement.UINHalloweenAchievementStar")
local UINHalloweenAchievementItem = require("Game.ActivityHallowmas.UI.Achievement.UINHalloweenAchievementItem")
UIHalloween22Achievement.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHalloweenAchievementStar
  (UIUtil.SetTopStatus)(self, self.OnCloseAchievement, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseBtn)
  self._starNumPool = (UIItemPool.New)(UINHalloweenAchievementStar, (self.ui).item_star)
  ;
  ((self.ui).item_star):SetActive(false)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).main).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).main).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._gameobjectDic = {}
  self.__PickedTaskCallback = BindCallback(self, self.__PickedTask)
  self.__OnTaskChangeCallback = BindCallback(self, self.__OnTaskChange)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__OnTaskChangeCallback)
end

UIHalloween22Achievement.InitHalloween22Achievement = function(self, hallowmasData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = hallowmasData
  self._callback = callback
  self._achievementCfg = (self._data):GetHallowmasAchievementCfg()
  self._starMax = ((ConfigData.activity_hallowmas_achievement).starMax)[(self._data):GetActId()]
  self:__Refresh()
end

UIHalloween22Achievement.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:__FindShowTaskDatas()
  ;
  (table.sort)(self._taskDataList, function(a, b)
    -- function num : 0_2_0
    local aComplete = a:CheckComplete()
    local bComplete = b:CheckComplete()
    if aComplete ~= bComplete then
      return aComplete
    end
    local aIsPicked = a.isPicked or false
    local bIsPicked = b.isPicked or false
    if aIsPicked ~= bIsPicked then
      return not aIsPicked
    end
    if (a.stcData).order >= (b.stcData).order then
      do return (a.stcData).order == (b.stcData).order end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  ;
  (self._starNumPool):HideAll()
  for i = self._starMax, 1, -1 do
    local star = (self._starNumPool):GetOne()
    star:InitStarNum(i, (self._taskStarNumDic)[i] or 0)
  end
  local count = #self._taskDataList
  ;
  ((self.ui).tex_Num):SetIndex(0, tostring(self._finishCount), tostring(self._showAllCount))
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).main).totalCount = count
  ;
  ((self.ui).main):RefillCells()
end

UIHalloween22Achievement.__FindShowTaskDatas = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._taskDataList == nil then
    self._taskDataList = {}
    self._taskStarNumDic = {}
    self._tempFixShowCount = 0
    self._tempTaskInitList = {}
    for taskId,achievementCfg in pairs(self._achievementCfg) do
      local taskCfg = (ConfigData.task)[taskId]
      if taskCfg.show_pre or taskCfg == nil or 0 == 0 then
        (table.insert)(self._tempTaskInitList, taskId)
      end
      if not achievementCfg.achievement_hide then
        self._tempFixShowCount = self._tempFixShowCount + 1
      end
    end
  else
    do
      ;
      (table.removeall)(self._taskDataList)
      ;
      (table.clearmap)(self._taskStarNumDic)
      self._showAllCount = self._tempFixShowCount
      self._finishCount = 0
      local Local_TryAddListFunc = nil
      Local_TryAddListFunc = function(taskId)
    -- function num : 0_3_0 , upvalues : _ENV, self, Local_TryAddListFunc
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, true)
    local achievementCfg = (self._achievementCfg)[taskId]
    if achievementCfg == nil then
      error(" hallowmas achievementCfg is nil  " .. tostring(taskId))
      return 
    end
    if achievementCfg.achievement_hide and (taskData.isPicked or taskData:CheckComplete()) then
      (table.insert)(self._taskDataList, taskData)
      self._showAllCount = self._showAllCount + 1
    end
    ;
    (table.insert)(self._taskDataList, taskData)
    if taskData.isPicked then
      local star = achievementCfg.achievement_stars
      local count = (self._taskStarNumDic)[star] or 0
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self._taskStarNumDic)[star] = count + 1
      self._finishCount = self._finishCount + 1
      for i,nextTaskid in ipairs((taskData.stcData).show_next) do
        Local_TryAddListFunc(nextTaskid)
      end
    end
  end

      for i,v in ipairs(self._tempTaskInitList) do
        Local_TryAddListFunc(v)
      end
    end
  end
end

UIHalloween22Achievement.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : UINHalloweenAchievementItem
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  (self._gameobjectDic)[go] = (UINHalloweenAchievementItem.New)()
  ;
  ((self._gameobjectDic)[go]):Init(go)
end

UIHalloween22Achievement.__OnChangeItem = function(self, go, index)
  -- function num : 0_5
  local taskData = (self._taskDataList)[index + 1]
  local item = (self._gameobjectDic)[go]
  local star = ((self._achievementCfg)[taskData.id]).achievement_stars
  item:InitAchieventItem(taskData, star, self.__PickedTaskCallback)
end

UIHalloween22Achievement.__PickedTask = function(self, taskData)
  -- function num : 0_6
  if not taskData:CheckComplete() then
    return 
  end
  ;
  (self._data):ReqHallowmasCommitTask(taskData.id, function()
    -- function num : 0_6_0 , upvalues : self
    self:__Refresh()
  end
)
end

UIHalloween22Achievement.__OnTaskChange = function(self, taskData)
  -- function num : 0_7 , upvalues : _ENV
  if (self._achievementCfg)[taskData.id] == nil then
    return 
  end
  if taskData:CheckComplete() then
    self:__Refresh()
    return 
  end
  for k,v in pairs(self._gameobjectDic) do
    if v:GetHallowAchieveTask() == taskData then
      v:RefreshTaskUI()
      return 
    end
  end
end

UIHalloween22Achievement.OnClickCloseBtn = function(self)
  -- function num : 0_8 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIHalloween22Achievement.OnCloseAchievement = function(self)
  -- function num : 0_9
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIHalloween22Achievement.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__OnTaskChangeCallback)
  ;
  (base.OnDelete)(self)
end

return UIHalloween22Achievement

