-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {512818, 233171}
local __rt_2 = {410728, 341131}
local game_set_describe = {
{name = "skill", option_group_name = __rt_1, setting_name = 27027}
, 
{id = 2, option_group_name = __rt_1, setting_name = 291054}
, 
{defalt_detail = 2, id = 3, name = "open_ultimateSkill", 
option_group_name = {410728, 136238, 341131}
, setting_name = 181771}
, 
{id = 4, name = "quick_move", setting_name = 37119}
, 
{id = 5, name = "quick_interaction"}
}
local __default_values = {defalt_detail = 0, id = 1, name = "function", option_group_name = __rt_2, setting_name = 175490}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(game_set_describe) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(game_set_describe, {__index = __rawdata})
return game_set_describe

