-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_general_daily_task = {
[25001] = {}
}
local __default_values = {daily_task_refresh_max = 1, id = 25001, task_daily_release = 2, task_limit = 8, task_time = 1677744000}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_general_daily_task) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_general_daily_task, {__index = __rawdata})
return activity_general_daily_task

