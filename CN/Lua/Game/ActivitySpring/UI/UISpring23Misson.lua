-- params : ...
-- function num : 0 , upvalues : _ENV
local UISpring23Misson = class("UISpring23Misson", UIBaseWindow)
local base = UIBaseWindow
local ActivitySpringEnum = require("Game.ActivitySpring.Data.ActivitySpringEnum")
UISpring23Misson.OnInit = function(self)
  -- function num : 0_0
  (((self.ui).btn_task).gameObject):SetActive(false)
end

UISpring23Misson.SetTaskFunc = function(self, openFunc, reddotFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._taskOpenFunc = openFunc
  self._taskRedFunc = reddotFunc
  ;
  (((self.ui).btn_task).gameObject):SetActive(true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_task, self, self.OnClickTask)
end

UISpring23Misson.OnClickTask = function(self)
  -- function num : 0_2
  if self._taskOpenFunc ~= nil then
    (self._taskOpenFunc)()
  end
end

UISpring23Misson.RefreshMissonReddot = function(self)
  -- function num : 0_3
  if self._taskRedFunc ~= nil then
    ((self.ui).redDot_task):SetActive((self._taskRedFunc)())
  end
end

UISpring23Misson.InitSpring23Misson = function(self, springData, onActLbInteractEnterk)
  -- function num : 0_4 , upvalues : _ENV
  self._springData = springData
  self._onActLbInteractEnterk = onActLbInteractEnterk
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_task, self, self.OnClickTaskSpring)
  ;
  (((self.ui).btn_task).gameObject):SetActive(true)
  if self._reddot == nil then
    self._reddot = (self._springData):GetActivityReddot()
    if self._reddot ~= nil then
      self._reddotFunc = BindCallback(self, self.__RefreshRed)
      RedDotController:AddListener((self._reddot).nodePath, self._reddotFunc)
      self:__RefreshRed(self._reddot)
    end
  end
end

UISpring23Misson.OnClickTaskSpring = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._taskOpenFunc ~= nil then
    (self._taskOpenFunc)()
    return 
  end
  if not (self._springData):IsActivityOpen() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Task, function(win)
    -- function num : 0_5_0 , upvalues : self
    if win == nil then
      return 
    end
    ;
    (self._onActLbInteractEnterk)(true)
    win:InitChristmas22Task(self._springData, function()
      -- function num : 0_5_0_0 , upvalues : self
      (self._onActLbInteractEnterk)(false)
    end
)
  end
)
end

UISpring23Misson.__RefreshRed = function(self, reddot)
  -- function num : 0_6 , upvalues : ActivitySpringEnum
  local onceTaskRed = reddot:GetChild((ActivitySpringEnum.reddotType).OnceTask)
  local dailyTaskRed = reddot:GetChild((ActivitySpringEnum.reddotType).DailyTask)
  local isTaskRed = (onceTaskRed ~= nil and onceTaskRed:GetRedDotCount() > 0) or (dailyTaskRed ~= nil and dailyTaskRed:GetRedDotCount() > 0)
  ;
  ((self.ui).redDot_task):SetActive(isTaskRed)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UISpring23Misson.OnCloseSpring23Misson = function(self)
  -- function num : 0_7
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UISpring23Misson.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
  end
  ;
  (base.OnDelete)(self)
end

return UISpring23Misson

