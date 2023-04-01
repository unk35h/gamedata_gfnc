-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_winter23_farm_desc = {
[250011102] = {}
, 
[250011107] = {drop_up_desc = 200023, stage_id = 250011107}
, 
[250011113] = {drop_up_desc = 481636, stage_id = 250011113}
, 
[250011114] = {drop_up_desc = 242043, stage_id = 250011114}
, 
[250011119] = {drop_up_desc = 88720, stage_id = 250011119}
, 
[250011122] = {drop_up_desc = 358207, stage_id = 250011122}
, 
[250012102] = {stage_id = 250012102}
, 
[250012107] = {drop_up_desc = 200023, stage_id = 250012107}
, 
[250012113] = {drop_up_desc = 481636, stage_id = 250012113}
, 
[250012114] = {drop_up_desc = 242043, stage_id = 250012114}
, 
[250012119] = {drop_up_desc = 88720, stage_id = 250012119}
, 
[250012122] = {drop_up_desc = 358207, stage_id = 250012122}
}
local __default_values = {drop_up_desc = "", stage_id = 250011102}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_winter23_farm_desc) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_winter23_farm_desc, {__index = __rawdata})
return activity_winter23_farm_desc

