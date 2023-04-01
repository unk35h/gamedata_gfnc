-- params : ...
-- function num : 0 , upvalues : _ENV
local handbook_activity = {
{activity_class = 388852}
, 
{id = 2}
, 
{activity_class = 268004, id = 3}
}
local __default_values = {activity_class = 26, class_pic = "", content_count = 0, id = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(handbook_activity) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
handBookActFrameIdDic = {}
}
setmetatable(handbook_activity, {__index = __rawdata})
return handbook_activity

