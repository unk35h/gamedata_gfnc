-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_tech_type = {
[5] = {}
, 
[6] = {activity_tech_item = 1216, activity_tech_type = 6, 
return_tech_item = {[1217] = 1}
}
, 
[7] = {activity_tech_item = 1223, activity_tech_type = 7, 
return_tech_item = {[1224] = 1}
}
}
local __default_values = {activity_tech_item = 1212, activity_tech_type = 5, 
return_tech_item = {[1213] = 1}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_tech_type) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_tech_type, {__index = __rawdata})
return activity_tech_type

