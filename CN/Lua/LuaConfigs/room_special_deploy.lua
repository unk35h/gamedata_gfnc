-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {[0] = true, [4] = true}
local __rt_2 = {
deployGridDic = {__rt_1; [0] = __rt_1, [5] = __rt_1, [6] = __rt_1}
}
local __rt_3 = {true, true; [4] = true, [5] = true}
local __rt_4 = {true, true, true, true, true}
local __rt_5 = {[2] = true, [3] = true, [4] = true}
local __rt_6 = {[3] = true, [4] = true, [5] = true, [6] = true}
local __rt_7 = {[4] = true, [6] = true}
local __rt_8 = {[4] = true, [5] = true, [6] = true}
local __rt_9 = {[2] = true, [4] = true}
local __rt_10 = {true, true, true, true, true, true; [0] = true}
local __rt_11 = {[3] = true}
local __rt_12 = {true, true, true}
local __rt_13 = {true, true, true, true; [0] = true}
local __rt_14 = {[2] = true}
local __rt_15 = {[0] = true, [2] = true, [4] = true}
local __rt_16 = {true; [3] = true}
local __rt_17 = {true; [0] = true, [3] = true, [4] = true}
local __rt_18 = {[4] = true}
local __rt_19 = {}
local room_special_deploy = {__rt_2, __rt_2, 
{
deployGridDic = {__rt_4, __rt_4, __rt_5; [0] = __rt_3}
}
, 
{
deployGridDic = {
{[3] = true, [5] = true, [6] = true}
, __rt_6, __rt_7; [0] = __rt_6}
}
, 
{
deployGridDic = {[2] = __rt_8, [3] = __rt_6, 
[4] = {[3] = true, [4] = true, [6] = true}
, [5] = __rt_6, [6] = __rt_8, [7] = __rt_7}
}
, 
{
deployGridDic = {__rt_5, __rt_5, __rt_5, __rt_4, __rt_10, __rt_10, 
{true; [0] = true, [3] = true, [5] = true, [6] = true, [8] = true}
, 
{true; [0] = true, [5] = true, [6] = true, [8] = true}
; [0] = __rt_9}
}
, 
{
deployGridDic = {[2] = __rt_11, 
[3] = {true, true, true, true}
, 
[4] = {true, true; [4] = true}
, [5] = __rt_4, 
[6] = {[2] = true, [3] = true}
}
}
, 
{
deployGridDic = {[2] = __rt_12, [3] = __rt_12}
}
, 
{
deployGridDic = {[2] = __rt_12, [3] = __rt_13, [4] = __rt_14}
}
, 
{
deployGridDic = {[2] = __rt_14, [3] = __rt_15, [4] = __rt_14}
}
, 
{
deployGridDic = {[2] = __rt_12, [3] = __rt_16, [4] = __rt_14}
}
, 
{
deployGridDic = {__rt_11, __rt_13, __rt_13, 
{true, true; [0] = true, [4] = true}
}
}
, 
{
deployGridDic = {[0] = __rt_15, [3] = __rt_15, [6] = __rt_15}
}
, 
{
deployGridDic = {__rt_1, __rt_1, __rt_1, __rt_1, __rt_17, __rt_15; [0] = __rt_13}
}
, 
{
deployGridDic = {__rt_1; [0] = __rt_17, [5] = __rt_17, [6] = __rt_1}
}
, 
{
deployGridDic = {__rt_1; [0] = __rt_12, [5] = __rt_17, [6] = __rt_14}
}
, 
{
deployGridDic = {__rt_12, 
{true, true; [0] = true}
; [0] = __rt_11, [6] = __rt_18}
}
, 
{
deployGridDic = {__rt_14; [0] = __rt_13, [3] = __rt_1}
}
, 
{
deployGridDic = {__rt_14; [0] = __rt_12, [3] = __rt_14, [5] = __rt_12, [6] = __rt_14}
}
, 
{
deployGridDic = {[0] = __rt_14, [2] = __rt_15, [4] = __rt_15, [6] = __rt_14}
}
, 
{
deployGridDic = {__rt_13; [0] = __rt_13, [3] = __rt_14, [4] = __rt_14}
}
, __rt_19, __rt_19, __rt_19, 
{
deployGridDic = {[0] = __rt_1, [6] = __rt_1}
}
, 
{
deployGridDic = {[3] = __rt_11, [4] = __rt_3, [5] = __rt_5}
}
, 
{
deployGridDic = {__rt_11, __rt_9, __rt_3, __rt_9}
}
, 
{
deployGridDic = {__rt_14}
}
, 
{
deployGridDic = {[2] = __rt_13, [3] = __rt_16, [4] = __rt_15}
}
, 
{
deployGridDic = {__rt_15; [0] = __rt_13, [5] = __rt_15, [6] = __rt_15}
}
, 
{
deployGridDic = {__rt_12, __rt_1, __rt_1, __rt_17, __rt_14}
}
, 
{
deployGridDic = {[2] = __rt_14, [3] = __rt_17, [4] = __rt_13, [5] = __rt_14}
}
, 
{
deployGridDic = {[0] = __rt_15, [6] = __rt_15}
}
}
local __default_values = {
deployGridDic = {
[0] = {[0] = true}
, [6] = __rt_18}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(room_special_deploy) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(room_special_deploy, {__index = __rawdata})
return room_special_deploy

