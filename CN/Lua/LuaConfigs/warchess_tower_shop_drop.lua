-- params : ...
-- function num : 0 , upvalues : _ENV
local warchess_tower_shop_drop = {
{}
, 
{tower_id = 2}
, 
{tower_id = 3}
, 
{tower_id = 4}
, 
{tower_id = 5}
, 
{tower_id = 6}
, 
{tower_id = 7}
, 
{tower_id = 8}
, 
{tower_id = 9}
, 
{tower_id = 10}
, 
{tower_id = 11}
, 
{tower_id = 12}
, 
{stage_id = 13, tower_id = 13}
, 
{stage_id = 13, tower_id = 14}
, 
{stage_id = 13, tower_id = 15}
, 
{stage_id = 13, tower_id = 16}
, 
{stage_id = 13, tower_id = 17}
, 
{stage_id = 13, tower_id = 18}
, 
{stage_id = 13, tower_id = 19}
, 
{stage_id = 13, tower_id = 20}
, 
{stage_id = 13, tower_id = 21}
}
local __default_values = {stage_id = 0, tower_id = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(warchess_tower_shop_drop) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(warchess_tower_shop_drop, {__index = __rawdata})
return warchess_tower_shop_drop

