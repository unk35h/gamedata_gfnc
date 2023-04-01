-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {1147, 1147, 1147, 1147, 1147}
local __rt_2 = {4280, 4280, 4280, 4280, 4280}
local __rt_3 = {1060, 1021, 1009, 1016, 1029}
local __rt_4 = {1148, 1148, 1148, 1148, 1148}
local __rt_5 = {5860, 5860, 5860, 5860, 5860}
local __rt_6 = {1149, 1149, 1149, 1149, 1149}
local __rt_7 = {6850, 6850, 6850, 6850, 6850}
local __rt_8 = {1061, 1057, 1050, 1019, 1026}
local __rt_9 = {1058, 1064, 1065, 1039, 1052}
local __rt_10 = {1062, 1022, 1034, 1041, 1018}
local warchess_assist = {
{
assist_lvs = {1147, 1147, 1147, 1147, 1147, 1147, 1147, 1147, 1147, 1147}
, 
effective = {}
, 
param1 = {1061, 1057, 1050, 1019, 1018, 1060, 1021, 1009, 1016, 1029}
}
, 
{id = 2, param1 = __rt_3}
, 
{assist_lvs = __rt_4, effective = __rt_5, id = 3, param1 = __rt_3}
, 
{assist_lvs = __rt_6, effective = __rt_7, id = 4, param1 = __rt_3}
, 
{id = 5, param1 = __rt_8}
, 
{assist_lvs = __rt_4, effective = __rt_5, id = 6, param1 = __rt_8}
, 
{assist_lvs = __rt_6, effective = __rt_7, id = 7, param1 = __rt_8}
, 
{
assist_lvs = {1175, 1175, 1175, 1175, 1175}
, 
effective = {1100, 1100, 1100, 1100, 1100}
, id = 8}
, 
{
assist_lvs = {1176, 1176, 1176, 1176, 1176}
, 
effective = {1200, 1200, 1200, 1200, 1200}
, id = 9}
, 
{
assist_lvs = {1177, 1177, 1177, 1177, 1177}
, 
effective = {1800, 1800, 1800, 1800, 1800}
, id = 10}
, 
{
assist_lvs = {1178, 1178, 1178, 1178, 1178}
, 
effective = {3300, 3300, 3300, 3300, 3300}
, id = 11}
, 
{
assist_lvs = {1179, 1179, 1179, 1179, 1179}
, 
effective = {2500, 2500, 2500, 2500, 2500}
, id = 12, param1 = __rt_10}
, 
{
assist_lvs = {1180, 1180, 1180, 1180, 1180}
, 
effective = {3900, 3900, 3900, 3900, 3900}
, id = 13, param1 = __rt_10}
, 
{
assist_lvs = {1181, 1181, 1181, 1181, 1181}
, 
effective = {6200, 6200, 6200, 6200, 6200}
, id = 14, param1 = __rt_10}
, 
{
assist_lvs = {1182, 1182, 1182, 1182, 1182}
, 
effective = {3200, 3200, 3200, 3200, 3200}
, id = 15}
, 
{
assist_lvs = {1183, 1183, 1183, 1183, 1183}
, 
effective = {4500, 4500, 4500, 4500, 4500}
, id = 16}
, 
{
assist_lvs = {1184, 1184, 1184, 1184, 1184}
, 
effective = {6900, 6900, 6900, 6900, 6900}
, id = 17}
}
local __default_values = {assist_lvs = __rt_1, effective = __rt_2, id = 1, param1 = __rt_9}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(warchess_assist) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(warchess_assist, {__index = __rawdata})
return warchess_assist

