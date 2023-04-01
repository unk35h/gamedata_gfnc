-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {[1002] = 50}
local share = {
[100] = {}
, 
[26001] = {id = 26001}
}
local __default_values = {id = 100, reward = __rt_1, reward_num = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(share) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(share, {__index = __rawdata})
return share

