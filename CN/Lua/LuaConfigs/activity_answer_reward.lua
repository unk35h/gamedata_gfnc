-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {1, 5}
local activity_answer_reward = {
{
[3] = {need_score = 3}
, 
[6] = {need_score = 6, 
rewardIds = {1503, 8103}
, 
rewardNums = {150, 5}
, score_reward = "1503=150|8103=5"}
, 
[10] = {
rewardIds = {6003, 5007}
, score_reward = "6003=1|5007=5"}
}
}
local __default_values = {id = 1, need_score = 10, 
rewardIds = {1502, 3005}
, rewardNums = __rt_1, score_reward = "1502=1|3005=5"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_answer_reward) do
  for k1,v1 in pairs(v) do
    setmetatable(v1, base)
  end
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_answer_reward, {__index = __rawdata})
return activity_answer_reward

