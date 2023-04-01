-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {0.9, 1.5, 1, 3.5}
local activity_lobby = {
[24001] = {
born_pos = {-2, -2}
}
, 
[25001] = {act_id = 25001, bgm = 3380, 
cam_bound = {-13.6, -2.26, 6.4, 6.8}
, character = 1001, first_avg = 2500101, guide_id = 41, obj_ui = "ActLbEntityInfo_23Winter", scene_name = "ActivityLobby_2023winter", time_obj = 5, 
top_res = {1062, 1007}
}
}
local __default_values = {act_id = 24001, bgm = 3370, 
born_pos = {-1.6, -1.35}
, 
cam_bound = {-13.35, -2, 5.9, 5.9}
, character = 0, character_skin = 0, first_avg = 2200140, guide_id = 34, move_spd = 2.5, obj_ui = "ActLbEntityInfo_23Spring", scene_name = "ActivityLobby_2023spring", time_obj = 1, 
top_res = {1055, 1007}
, ui_scale = __rt_1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_lobby) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_lobby, {__index = __rawdata})
return activity_lobby

