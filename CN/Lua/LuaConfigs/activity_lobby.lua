-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local __rt_2 = {0.9, 1.5, 1, 3.5}
local __rt_3 = {-13.6, -2.26, 6.4, 6.8}
local activity_lobby = {
[24001] = {bgm = 3370, 
born_pos = {-2, -2}
, 
cam_bound = {-13.35, -2, 5.9, 5.9}
, obj_ui = "ActLbEntityInfo_23Spring", time_obj = 1}
, 
[25001] = {act_id = 25001, bgm = 3380, character = 1001, first_avg = 2500101, guide_id = 41, obj_ui = "ActLbEntityInfo_23Winter", scene_name = "ActivityLobby_2023winter", 
top_res = {1062, 1007}
}
, 
[31001] = {act_id = 31001, bgm_selector = "Selector_Mus_Home", 
born_pos = {0.05, -0.1}
, first_avg = 3100011, guide_id = 45, opening = "season_01", openingKeepTime = 0.5, openingStartTime = 3.5, 
opening_args = {3.5, 0.5}
, scene_name = "ActivityLobby_Season", selector_label = "SelectorLabel_Base", 
top_res = {1064, 1007}
}
}
local __default_values = {act_id = 24001, bgm = 3002, bgm_selector = "", 
born_pos = {-1.6, -1.35}
, cam_bound = __rt_3, character = 0, character_skin = 0, first_avg = 2200140, guide_id = 34, move_spd = 2.5, obj_ui = "ActLbEntityInfo_23Season1", opening = "", openingKeepTime = 0, openingStartTime = 0, opening_args = __rt_1, scene_name = "ActivityLobby_2023spring", selector_label = "", time_obj = 5, 
top_res = {1055, 1007}
, ui_scale = __rt_2}
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

