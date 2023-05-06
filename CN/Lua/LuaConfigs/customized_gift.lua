-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local customized_gift = {
{
param1 = {120}
, type = 1}
, 
{id = 2, 
param1 = {1037, 1025, 1010, 1026, 1039, 1008, 1018, 1016, 1028, 1022, 1041, 1042, 1043, 1044, 1045, 1046, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 1055, 1057}
, type = 2}
, 
{id = 3, 
param1 = {40}
, type = 3}
, 
{id = 4, 
param1 = {60}
, type = 3}
, 
{id = 5, 
param1 = {15}
, 
param2 = {1004, 1007, 1009, 1012, 1014, 1020, 1021, 1023, 1027, 1034, 1035, 1036}
, type = 4}
, 
{id = 6, 
param1 = {1501, 8205, 1003, 5007}
, 
param2 = {800, 5, 10000, 3}
}
, 
{id = 7, 
param2 = {10, 15, 3000, 12, 1200, 55}
}
, 
{id = 8, 
param1 = {6003, 8231, 8223, 1502, 1501, 6002}
, 
param2 = {5, 5, 12, 25, 12000, 150}
}
, 
{id = 9, 
param1 = {8223, 8205, 1502, 1501, 5007, 1003}
, 
param2 = {2, 8, 3, 1500, 6, 20000}
}
}
local __default_values = {id = 1, 
param1 = {1020, 1504, 1503, 8231, 1018, 1502}
, param2 = __rt_1, type = 5}
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

