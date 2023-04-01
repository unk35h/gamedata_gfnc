-- params : ...
-- function num : 0 , upvalues : _ENV
local warchess_season = {
{}
, 
{
env_id = {1, 2, 3}
, id = 2, 
towers = {5, 6, 7, 8, 9, 10, 11, 12, 13}
, warchess_item = 2}
, 
{
env_id = {4, 5}
, id = 3, 
towers = {14, 15, 16, 17, 18, 19, 20, 21}
, warchess_item = 3}
}
local __default_values = {
env_id = {0}
, id = 1, max_save = 3, 
towers = {1, 2, 3, 4}
, warchess_item = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(warchess_season) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(warchess_season, {__index = __rawdata})
return warchess_season
