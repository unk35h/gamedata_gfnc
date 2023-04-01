-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_name = {
{icon = "ICON_activity_1001", name = 298575}
, 
{icon = "ICON_activity_2001", name = 487929, name_id = 2}
, 
{icon = "ICON_activity_1002", name = 521814, name_id = 3}
, 
{name = 450158, name_id = 4}
, 
{icon = "ICON_activity_6001", name = 25793, name_id = 5}
, 
{name = 162033, name_id = 6}
, 
{icon = "", name = 44806, name_id = 7}
, 
{name = 37803, name_id = 8}
, 
{name = 22524, name_id = 9}
, 
{name = 204546, name_id = 10}
, 
{name = 289805, name_id = 11}
, 
{name = 289569, name_id = 12}
, 
{name = 475525, name_id = 13}
, 
{name = 194679, name_id = 14}
, 
{name = 241023, name_id = 15}
, 
{name = 383910, name_id = 16}
, 
{name = 505951, name_id = 17}
, 
{name = 182919, name_id = 18}
, 
{name = 65423, name_id = 19}
, 
{icon = "ICON_activity_13001", name_id = 20}
, 
{icon = "ICON_activity_1101", name = 110233, name_id = 21}
, 
{icon = "ICON_activity_14001", name = 181582, name_id = 22}
, 
{icon = "ICON_activity_6001", name = 46519, name_id = 23}
, 
{name = 315354, name_id = 24}
, 
{name = 46895, name_id = 25}
, 
{name = 431337, name_id = 26}
, 
{name = 267678, name_id = 27}
, 
{name = 273634, name_id = 28}
, 
{name = 391454, name_id = 29}
, 
{name = 374057, name_id = 30}
, 
{name = 391550, name_id = 31}
, 
{name = 299134, name_id = 32}
, 
{name = 302273, name_id = 33}
, 
{icon = "ICON_activity_6001", name = 162898, name_id = 34}
, 
{name = 377242, name_id = 35}
, 
{name = 138097, name_id = 36}
, 
{icon = "ICON_activity_7001", name = 321460, name_id = 37}
, 
{icon = "ICON_activity_21001", name = 142764, name_id = 38}
, 
{icon = "ICON_activity_4010", name = 96950, name_id = 39}
, 
{icon = "ICON_activity_4010", name = 362351, name_id = 40}
, 
{icon = "ICON_activity_4010", name = 207466, name_id = 41}
, 
{name = 294094, name_id = 42}
, 
{name = 50924, name_id = 43}
, 
{name = 476280, name_id = 44}
, 
{name = 242583, name_id = 45}
, 
{name = 301695, name_id = 46}
, 
{name = 280757, name_id = 47}
, 
{name = 131807, name_id = 48}
, 
{name = 50581, name_id = 49}
, 
{name = 107880, name_id = 50}
, 
{name = 271046, name_id = 51}
, 
{name = 65423, name_id = 52}
, 
{icon = "ICON_activity_14001", name = 181582, name_id = 53}
, 
{icon = "ICON_activity_6001", name = 46519, name_id = 54}
, 
{icon = "ICON_activity_13001", name_id = 55}
, 
{name = 303548, name_id = 56}
, 
{name = 12580, name_id = 57}
; 
[60] = {name = 85472, name_id = 60}
, 
[61] = {icon = "ICON_activity_8001", name = 130009, name_id = 61}
, 
[62] = {icon = "ICON_activity_4010", name = 245536, name_id = 62}
, 
[63] = {icon = "ICON_activity_9001", name = 63375, name_id = 63}
, 
[64] = {name = 89184, name_id = 64}
, 
[65] = {icon = "ICON_activity_6001", name = 413950, name_id = 65}
, 
[66] = {name = 487208, name_id = 66}
, 
[67] = {icon = "ICON_activity_6001", name = 239684, name_id = 67}
, 
[999999] = {icon = "ICON_activity_sign", name = 472901, name_id = 999999}
}
local __default_values = {icon = "ICON_activity_4001", name = 121720, name_id = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_name) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_name, {__index = __rawdata})
return activity_name

