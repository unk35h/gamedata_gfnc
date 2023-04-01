-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySpringEnum = class("ActivitySpringEnum")
ActivitySpringEnum.reddotType = {OnceTask = 1, DailyTask = 2, Tech = 3, TechItemLimit = 4, Talk = 5, HardLevel = 6, EpEnv = 7}
ActivitySpringEnum.reddotIsRedType = {(ActivitySpringEnum.reddotType).OnceTask, (ActivitySpringEnum.reddotType).DailyTask, (ActivitySpringEnum.reddotType).Talk}
return ActivitySpringEnum

