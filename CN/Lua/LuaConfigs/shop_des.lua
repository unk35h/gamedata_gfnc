-- params : ...
-- function num : 0 , upvalues : _ENV
local shop_des = {
{info_des = 404163}
, 
{id = 2, info_des = 506321}
, 
{id = 3}
, 
{id = 4, info_des = 237438, info_rule = 11}
, 
{id = 5, info_des = 446945, info_rule = 12}
}
local __default_values = {id = 1, info_des = 13944, info_rule = 0}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(shop_des) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(shop_des, {__index = __rawdata})
return shop_des

