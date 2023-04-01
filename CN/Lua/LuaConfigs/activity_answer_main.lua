-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_answer_main = {
{}
}
local __default_values = {id = 1, rule_des = 7801, rule_title = 7800, wrong_cd = 3}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_answer_main) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_answer_main, {__index = __rawdata})
return activity_answer_main

