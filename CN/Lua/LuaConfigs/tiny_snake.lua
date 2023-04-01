-- params : ...
-- function num : 0 , upvalues : _ENV
local tiny_snake = {
{}
}
local __default_values = {id = 1, 
join_reward_ids = {400045, 1504, 1202}
, 
join_reward_nums = {1, 15, 500}
, join_score = 10, rank_id = 21, snake_guide_id = 28}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(tiny_snake) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(tiny_snake, {__index = __rawdata})
return tiny_snake

