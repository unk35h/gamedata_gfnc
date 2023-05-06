-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_head = {
[25001] = {head_pic_path = "Winter23/UI_Winter23CommonTopBG"}
, 
[31001] = {activity_id = 31001, 
head_bar_color = {255, 165, 0}
}
}
local __default_values = {activity_id = 25001, 
head_bar_color = {109, 143, 81}
, head_pic_path = "UI_Season23AprilCommonTopBG"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_head) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_head, {__index = __rawdata})
return activity_head

