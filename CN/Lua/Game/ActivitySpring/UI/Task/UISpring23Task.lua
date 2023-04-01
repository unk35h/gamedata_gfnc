-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Task.UIChristmas22Task")
local UISpring23Task = class("UISpring23Task", base)
local ActivitySpringEnum = require("Game.ActivitySpring.Data.ActivitySpringEnum")
local titleTypeEnum = {onceTask = 1, dailyTask = 2}
UISpring23Task.__SetNodeClass = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._LimitTaskNodeClass = require("Game.ActivitySpring.UI.Task.UINSpring23LimitTaskNode")
  self._ActTaskNodeClass = require("Game.ActivitySpring.UI.Task.UINSpring23ActTaskNode")
  self._pageNodeClass = require("Game.ActivitySpring.UI.Task.UINSpring23TaskPageItem")
end

UISpring23Task.__FirstOpenPage = function(self)
  -- function num : 0_1 , upvalues : titleTypeEnum
  self:__SetPage(titleTypeEnum.dailyTask)
end

UISpring23Task.__RefreshReddot = function(self, reddot)
  -- function num : 0_2 , upvalues : ActivitySpringEnum, titleTypeEnum
  local dailyTaskRed = reddot:GetChild((ActivitySpringEnum.reddotType).DailyTask)
  local onceTaskRed = reddot:GetChild((ActivitySpringEnum.reddotType).OnceTask)
  local oncePage = ((self._pageItemPool).listItem)[titleTypeEnum.onceTask]
  if onceTaskRed:GetRedDotCount() <= 0 then
    oncePage:SetChristmasTaskPageRed(oncePage == nil or onceTaskRed == nil)
    local dailyPage = ((self._pageItemPool).listItem)[titleTypeEnum.dailyTask]
    if dailyTaskRed:GetRedDotCount() <= 0 then
      dailyPage:SetChristmasTaskPageRed(dailyPage == nil or dailyTaskRed == nil)
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
end

return UISpring23Task

