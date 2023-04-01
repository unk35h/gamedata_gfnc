-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local activity_spring_advanced_env = {
{env_des = 94304, env_name = 17537}
, 
{
difficulty_des = {5, 6, 7, 8}
, env_des_extra = "+10%", env_id = 2, need_interact = 1, 
stage_id = {240011102, 240011108, 240011114, 240011120}
}
, 
{
difficulty_des = {9, 10, 11, 12}
, env_des = 24202, env_des_extra = "+20%", env_id = 3, env_name = 410724, need_interact = 3, 
stage_id = {240011103, 240011109, 240011115, 240011121}
}
, 
{
difficulty_des = {13, 14, 15, 16}
, env_des = 449735, env_des_extra = "+30%", env_id = 4, env_name = 235255, need_interact = 6, 
stage_id = {240011104, 240011110, 240011116, 240011122}
}
, 
{
difficulty_des = {17, 18, 19, 20}
, env_des = 326033, env_des_extra = "+40%", env_id = 5, env_name = 418297, need_interact = 10, 
stage_id = {240011105, 240011111, 240011117, 240011123}
}
, 
{
difficulty_des = {21, 22, 23, 24}
, env_des = 80342, env_des_extra = "+50%", env_id = 6, env_name = 487088, need_interact = 15, 
stage_id = {240011106, 240011112, 240011118, 240011124}
}
}
local __default_values = {
difficulty_des = {1, 2, 3, 4}
, env_des = 193543, env_des_extra = "", env_id = 1, env_name = 109622, need_interact = 0, pre_condition = __rt_1, pre_para1 = __rt_1, pre_para2 = __rt_1, 
stage_id = {240011101, 240011107, 240011113, 240011119}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_advanced_env) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
preconditionDic = {}
}
setmetatable(activity_spring_advanced_env, {__index = __rawdata})
return activity_spring_advanced_env

