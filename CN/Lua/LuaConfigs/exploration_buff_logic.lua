-- params : ...
-- function num : 0 , upvalues : _ENV
local exploration_buff_logic = {
{}
, 
{event_show = true, logic_id = 2}
, 
{event_show = true, logic_id = 3}
, 
{logic_id = 4}
, 
{logic_id = 5}
; 
[8] = {event_show = true, logic_id = 8}
, 
[9] = {event_show = true, logic_id = 9}
, 
[10] = {logic_id = 10}
, 
[11] = {logic_id = 11}
, 
[12] = {logic_id = 12}
, 
[13] = {logic_id = 13}
, 
[14] = {logic_id = 14}
, 
[15] = {event_show = true, logic_id = 15}
, 
[16] = {event_show = true, logic_id = 16}
, 
[17] = {event_show = true, logic_id = 17}
, 
[18] = {event_show = true, logic_id = 18}
, 
[19] = {logic_id = 19}
, 
[20] = {logic_id = 20}
, 
[21] = {logic_id = 21}
, 
[22] = {logic_id = 22}
, 
[23] = {logic_id = 23}
, 
[24] = {logic_id = 24}
, 
[25] = {logic_id = 25}
, 
[26] = {logic_id = 26}
, 
[27] = {event_show = true, logic_id = 27}
, 
[28] = {logic_id = 28}
, 
[30] = {event_show = true, logic_id = 30}
, 
[31] = {event_show = true, logic_id = 31}
, 
[36] = {event_show = true, logic_id = 36}
, 
[37] = {logic_id = 37}
, 
[39] = {event_show = true, logic_id = 39}
, 
[41] = {logic_id = 41}
, 
[42] = {logic_id = 42}
, 
[43] = {logic_id = 43}
, 
[44] = {logic_id = 44}
, 
[45] = {event_show = true, logic_id = 45}
, 
[46] = {event_show = true, logic_id = 46}
, 
[47] = {logic_id = 47}
, 
[48] = {event_show = true, logic_id = 48}
, 
[49] = {event_show = true, logic_id = 49}
, 
[50] = {event_show = true, logic_id = 50}
, 
[51] = {event_show = true, logic_id = 51}
, 
[52] = {event_show = true, logic_id = 52}
}
local __default_values = {event_show = false, logic_id = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(exploration_buff_logic) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(exploration_buff_logic, {__index = __rawdata})
return exploration_buff_logic

