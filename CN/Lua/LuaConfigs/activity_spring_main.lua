-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_spring_main = {
{}
}
local __default_values = {activity_id = 24001, daily_task_refresh_max = 1, 
env_list = {1, 2, 3, 4, 5, 6}
, general_id = 24001, hard_level_type = 1, 
hard_pre_condition = {12}
, hard_rule_id = 4, id = 1, 
initial_protocol_all = {21102, 25001, 25002, 25003, 25004, 25005}
, interact_item = 1055, main_stage = 240011, 
pre_para1 = {-1}
, 
pre_para2 = {1655971199}
, story_stage = 0, task_daily_release = 2, task_limit = 8, task_rule_id = 9, task_time = 1673942400, tech_id = 6, tech_special_branch = 15, ticket_item = 1007}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_main) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_spring_main, {__index = __rawdata})
return activity_spring_main

