-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local customized_gift = {
{
param1 = {120}
, type = 1}
, 
{id = 2, type = 2}
, 
{id = 3, 
param1 = {40}
}
, 
{id = 4, 
param1 = {60}
}
, 
{id = 5, 
param1 = {15}
, 
param2 = {1004, 1007, 1009, 1012, 1014, 1020, 1021, 1023, 1027, 1034, 1035, 1036}
, type = 4}
}
local __default_values = {id = 1, 
param1 = {1037, 1025, 1010, 1026, 1039, 1008, 1018, 1016, 1028, 1022, 1041, 1042, 1043, 1044, 1045, 1046, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1057}
, param2 = __rt_1, type = 3}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(customized_gift) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(customized_gift, {__index = __rawdata})
return customized_gift

