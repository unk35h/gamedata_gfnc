-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_keyExertion_main = {
{}
}
local __default_values = {activity_des = 475596, all_rewards = "1002=150|6003=1|1502=5|6002=10|5007=5|8205=5|1503=200|1501=1500|1003=15000", general_id = 23001, id = 1, main_des = 343919, main_rewards = "1002=150|6003=1|1502=5|1503=200", 
preprecess_all_rewardIds = {1002, 6003, 1502, 6002, 5007, 8205, 1503, 1501, 1003}
, 
preprecess_all_rewardNums = {150, 1, 5, 10, 5, 5, 200, 1500, 15000}
, 
preprecess_main_rewardIds = {1002, 6003, 1502, 1503}
, 
preprecess_main_rewardNums = {150, 1, 5, 200}
, progress_bar = 100, rewards_bag = 2001, rewards_des = 56793, 
task = {9379}
, task_rule_id = 7601, task_rule_title = 7600, token = 1210}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_keyExertion_main) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_keyExertion_main, {__index = __rawdata})
return activity_keyExertion_main

