-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {-0.4, 1.2, -0.03}
local battle_mvp = {
[300703] = {
camera_offset_vector3 = {-0.2, 1.2, -0.03}
}
, 
[301003] = {id = 301003}
, 
[301204] = {
camera_offset_vector3 = {0.2, 1.4, -0.03}
, id = 301204}
, 
[301604] = {
camera_offset_vector3 = {0.55, 1.3, 0.4}
, id = 301604}
, 
[301803] = {id = 301803}
, 
[302404] = {
camera_offset_vector3 = {0.2, 1.3, 0.75}
, id = 302404}
, 
[304804] = {
camera_offset_vector3 = {0.4, 1.5, 0.27}
, id = 304804}
}
local __default_values = {camera_offset_vector3 = __rt_1, id = 300703}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(battle_mvp) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(battle_mvp, {__index = __rawdata})
return battle_mvp

