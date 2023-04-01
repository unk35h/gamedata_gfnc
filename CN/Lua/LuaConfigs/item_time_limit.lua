-- params : ...
-- function num : 0 , upvalues : _ENV
local item_time_limit = {
[906] = {id = 906, time = 3600}
, 
[3009] = {time = 1666857599, type = 1}
, 
[3010] = {id = 3010, time = 1680163199, type = 1}
, 
[5012] = {id = 5012}
, 
[5013] = {id = 5013}
, 
[5014] = {id = 5014}
}
local __default_values = {id = 3009, time = 604800, type = 2}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(item_time_limit) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(item_time_limit, {__index = __rawdata})
return item_time_limit

