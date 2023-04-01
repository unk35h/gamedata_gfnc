-- params : ...
-- function num : 0 , upvalues : _ENV
local model_spec_sign = {
{pre_sign = "low_monster_"}
, 
{id = 2}
}
local __default_values = {id = 1, pre_sign = "ew_"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(model_spec_sign) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(model_spec_sign, {__index = __rawdata})
return model_spec_sign

