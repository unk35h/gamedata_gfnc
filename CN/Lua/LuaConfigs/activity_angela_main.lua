-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_angela_main = {
{}
}
local __default_values = {
group_id = {130, 131, 204}
, id = 1, pop_time_fixed_way = 27, 
pre_condition2 = {27}
, 
pre_para3 = {1104}
, 
pre_para4 = {604800}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_angela_main) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_angela_main, {__index = __rawdata})
return activity_angela_main

