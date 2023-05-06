-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local __rt_2 = {1147, 1147, 1147, 1147, 1147}
local __rt_3 = {4280, 4280, 4280, 4280, 4280}
local __rt_4 = {1060, 1021, 1009, 1016, 1029}
local __rt_5 = {1148, 1148, 1148, 1148, 1148}
local __rt_6 = {5860, 5860, 5860, 5860, 5860}
local __rt_7 = {1149, 1149, 1149, 1149, 1149}
local __rt_8 = {6850, 6850, 6850, 6850, 6850}
local __rt_9 = {1061, 1057, 1050, 1019, 1026}
local __rt_10 = {1058, 1064, 1065, 1039, 1052}
local __rt_11 = {1062, 1022, 1034, 1041, 1018}
local __rt_12 = {1201, 1201, 1201, 1201, 1201}
local __rt_13 = {1202, 1202, 1202, 1202, 1202}
local __rt_14 = {1203, 1203, 1203, 1203, 1203}
local __rt_15 = {1058, 1044, 1053, 1063, 1062, 1049, 1051}
local official_assist = {
{
assist_lvs = {1147, 1147, 1147, 1147, 1147, 1147, 1147, 1147, 1147, 1147}
, 
param1 = {1061, 1057, 1050, 1019, 1018, 1060, 1021, 1009, 1016, 1029}
}
, 
{effective = __rt_3, id = 2, param1 = __rt_4}
, 
{assist_lvs = __rt_5, effective = __rt_6, id = 3, param1 = __rt_4}
, 
{assist_lvs = __rt_7, effective = __rt_8, id = 4, param1 = __rt_4}
, 
{effective = __rt_3, id = 5, param1 = __rt_9}
, 
{assist_lvs = __rt_5, effective = __rt_6, id = 6, param1 = __rt_9}
, 
{assist_lvs = __rt_7, effective = __rt_8, id = 7, param1 = __rt_9}
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
, id = 12, param1 = __rt_11}
, 
{
assist_lvs = {1180, 1180, 1180, 1180, 1180}
, 
effective = {3900, 3900, 3900, 3900, 3900}
, id = 13, param1 = __rt_11}
, 
{
assist_lvs = {1181, 1181, 1181, 1181, 1181}
, 
effective = {6200, 6200, 6200, 6200, 6200}
, id = 14, param1 = __rt_11}
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
, 
{assist_lvs = __rt_12, id = 18, param1 = __rt_9}
, 
{assist_lvs = __rt_13, id = 19, param1 = __rt_9}
, 
{assist_lvs = __rt_14, id = 20, param1 = __rt_9}
, 
{assist_lvs = __rt_12, id = 21, param1 = __rt_4}
, 
{assist_lvs = __rt_13, id = 22, param1 = __rt_4}
, 
{assist_lvs = __rt_14, id = 23, param1 = __rt_4}
, 
{
assist_lvs = {1201, 1201, 1201, 1201, 1201, 1201, 1201}
, id = 24, param1 = __rt_15}
, 
{
assist_lvs = {1202, 1202, 1202, 1202, 1202, 1202, 1202}
, id = 25, param1 = __rt_15}
, 
{
assist_lvs = {1203, 1203, 1203, 1203, 1203, 1203, 1203}
, id = 26, param1 = __rt_15}
}
local __default_values = {assist_lvs = __rt_2, effective = __rt_1, id = 1, param1 = __rt_10}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(official_assist) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(official_assist, {__index = __rawdata})
return official_assist

