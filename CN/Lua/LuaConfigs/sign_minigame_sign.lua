-- params : ...
-- function num : 0 , upvalues : _ENV
local sign_minigame_sign = {
{}
}
local __default_values = {
award_num_max = {188, 288, 388}
, 
award_num_min = {100, 200, 300}
, id = 1, total_sign_times = 7}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(sign_minigame_sign) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(sign_minigame_sign, {__index = __rawdata})
return sign_minigame_sign

