-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_spring_level_detail = {
[240001] = {level_des = 426048}
, 
[240002] = {id = 240002, level_des = 387719}
, 
[240003] = {id = 240003}
}
local __default_values = {id = 240001, level_des = 321815}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_level_detail) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_spring_level_detail, {__index = __rawdata})
return activity_spring_level_detail

