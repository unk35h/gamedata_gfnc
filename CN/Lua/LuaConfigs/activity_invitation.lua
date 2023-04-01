-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_invitation = {
{}
}
local __default_values = {activity_des = 7702, code_length = 5, id = 1, invitation_max = 3, 
return_reward_ids = {3001, 5007, 1003}
, 
return_reward_nums = {1, 10, 50000}
, rule_des = 7701, rule_title = 7700, rward_max = 3, title_icon = "UI_EventInvitationLogo_1"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_invitation) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_invitation, {__index = __rawdata})
return activity_invitation

