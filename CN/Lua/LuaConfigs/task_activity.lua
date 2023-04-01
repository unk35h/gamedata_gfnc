-- params : ...
-- function num : 0 , upvalues : _ENV
local task_activity = {
{}
, 
{id = 2, 
refresh_limit = {[6048] = 5}
, 
refresh_task = {6048}
, 
task = {6049, 6050, 6051, 6052, 6053, 6054}
}
}
local __default_values = {id = 1, 
refresh_limit = {[6036] = 10}
, 
refresh_task = {6036}
, refresh_time = 1, 
task = {6037, 6038, 6039, 6040, 6041, 6042, 6043, 6044, 6045, 6046, 6047}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(task_activity) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(task_activity, {__index = __rawdata})
return task_activity

