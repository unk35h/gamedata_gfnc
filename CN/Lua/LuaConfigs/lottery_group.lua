-- params : ...
-- function num : 0 , upvalues : _ENV
local lottery_group = {
{}
, 
{
list = {56, 57}
, lottery_group = 2}
, 
{
list = {59, 60}
, lottery_group = 3}
, 
{
list = {63, 64}
, lottery_group = 4}
, 
{
list = {86, 87}
, lottery_group = 5}
}
local __default_values = {
list = {52, 53}
, lottery_group = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(lottery_group) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
ltrGroupIdMap = {[52] = 1, [53] = 1, [56] = 2, [57] = 2, [59] = 3, [60] = 3, [63] = 4, [64] = 4, [86] = 5, [87] = 5}
}
setmetatable(lottery_group, {__index = __rawdata})
return lottery_group

