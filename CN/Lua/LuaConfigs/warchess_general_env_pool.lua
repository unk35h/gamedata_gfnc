-- params : ...
-- function num : 0 , upvalues : _ENV
local warchess_general_env_pool = {
{}
, 
{id = 2}
, 
{id = 3}
, 
{id = 4}
, 
{id = 5}
, 
{id = 6}
, 
{id = 7}
, 
{id = 8}
}
local __default_values = {id = 1, strategy_id = 0}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(warchess_general_env_pool) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(warchess_general_env_pool, {__index = __rawdata})
return warchess_general_env_pool

