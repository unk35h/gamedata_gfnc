-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {13007, 0, 0}
local __rt_2 = {13008, 0, 0}
local sector_act_des_cover = {
[6] = {
act_tip_long = {13010, 0, 0}
, 
act_tip_short = {13011, 0, 0}
, 
normal_tip_short = {154, 0, 0}
}
, 
[90011] = {normal_tip_long = __rt_1, sector_id = 90011}
}
local __default_values = {act_name = 247873, act_name_en = "COPLEY", act_tip_long = __rt_1, act_tip_short = __rt_2, 
normal_tip_long = {13000, 0, 0}
, normal_tip_short = __rt_2, sector_id = 6}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(sector_act_des_cover) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(sector_act_des_cover, {__index = __rawdata})
return sector_act_des_cover

