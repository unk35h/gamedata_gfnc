-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_return = {
{}
}
local __default_values = {id = 1, 
role_dic = {[1003] = true, [1007] = true, [1032] = true, [1036] = true}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_return) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_return, {__index = __rawdata})
return activity_return

