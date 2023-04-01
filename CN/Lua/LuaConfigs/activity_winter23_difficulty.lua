-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_winter23_difficulty = {
[250011] = {difficulty_id = 2, difficulty_name = 65844, sort = 2}
, 
[250012] = {difficulty_desc = 360319, difficulty_name_en = "NORMAL", sector_id = 250012}
}
local __default_values = {difficulty_desc = 144507, difficulty_id = 1, difficulty_name = 59556, difficulty_name_en = "HARD", sector_id = 250011, sort = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_winter23_difficulty) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_winter23_difficulty, {__index = __rawdata})
return activity_winter23_difficulty

