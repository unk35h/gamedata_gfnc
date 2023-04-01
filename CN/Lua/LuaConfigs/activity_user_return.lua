-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_user_return = {
{inPage = 1001}
, 
{
activity_avg = {}
, general_id = 2, id = 2, login_popup = 30, 
showitem_id = {1057}
}
}
local __default_values = {
activity_avg = {16, 17, 18}
, general_id = 1, id = 1, inPage = 0, login_popup = 10, 
showitem_id = {1038}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_user_return) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_user_return, {__index = __rawdata})
return activity_user_return

