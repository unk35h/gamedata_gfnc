-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_spring_level = {
{}
}
local __default_values = {
dungeon_levels = {240001, 240002, 240003}
, id = 1, pic_small = "ActCarnival22Rouge_small", ranklist_id = 24}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_level) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_spring_level, {__index = __rawdata})
return activity_spring_level

