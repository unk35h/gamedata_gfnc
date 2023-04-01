-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_task_limit = {
[30001] = {}
}
local __default_values = {activity_id = 30001, bg_path = "LimitTaskBG1", description = 261066, img_hero_path = "LimitTaskHero1", 
taskTypeDic = {[801] = true}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_task_limit) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_task_limit, {__index = __rawdata})
return activity_task_limit

