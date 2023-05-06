-- params : ...
-- function num : 0 , upvalues : _ENV
local pay_gift_pop_des = {
{}
}
local __default_values = {des = 328717, group_pop = 1, name = 35932}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(pay_gift_pop_des) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
popGroup = {
{6, 220, 221}
}
}
setmetatable(pay_gift_pop_des, {__index = __rawdata})
return pay_gift_pop_des

