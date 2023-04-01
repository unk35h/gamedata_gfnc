-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local __rt_2 = {255, 255, 255}
local __rt_3 = {2.5, -11.5, 0}
local __rt_4 = {0, 0}
local __rt_5 = {0, 0, 0}
local activity_hero_ui_config = {
[9] = {activity_id = 9, background_res = "CharDunClukayBG", background_text = "CharDunClukayName", background_text_point = __rt_1, background_text_size = __rt_1, 
frame_color = {207, 46, 107}
, mission_panel_name = 72082, quest_skin_type = 2, reward_panel_name = 305923}
, 
[10] = {background_skin = 305902, challenge_icon = "UI_CharDunClothoChallengeIcon", 
frame_color = {147, 21, 22}
, main_stage_icon = "UI_CharDunClothoMianStoryIcon", mission_panel_name = 129536, quest_skin = 305901, reward_panel_name = 355762, skin_type = 1}
, 
[11] = {activity_id = 11, background_res = "CharDunDupinBG", background_skin = 306002, challenge_icon = "UI_CharDunDupinChallengeIcon", 
frame_color = {170, 28, 16}
, main_stage_icon = "UI_CharDunDupinMianStoryIcon", mission_panel_name = 504522, quest_skin = 306001, reward_panel_name = 438233}
, 
[12] = {activity_id = 12, background_res = "CharDunUndlineBG", background_skin = 306101, background_text = "CharDunUndlineName", 
background_text_point = {11.8, 18.7}
, 
background_text_size = {1775.6, 363.7}
, challenge_icon = "UI_CharDunUndlineChallengeIcon", 
frame_color = {66, 85, 216}
, main_stage_icon = "UI_CharDunUndlineMianStoryIcon", mission_panel_name = 273011, quest_skin = 306101, reward_panel_name = 278882}
, 
[13] = {activity_id = 13, background_res = "CharDunJiangYuBG", background_skin = 306201, background_text = "CharDunJiangYuName", 
background_text_point = {16.11, 23.59}
, 
background_text_size = {1779.755, 420.06}
, challenge_icon = "UI_CharDunJiangYuChallengeIcon", 
frame_color = {154, 39, 38}
, main_stage_icon = "UI_CharDunJiangYuMianStoryIcon", main_title_color = __rt_5, mission_panel_name = 487984, quest_skin = 306201, reward_panel_name = 77707, rule_icon_color = __rt_5, shop_title_color = __rt_5}
, 
[14] = {activity_id = 14, background_res = "CharDunYelenaBG", background_skin = 306302, background_text = "CharDunYelenaName", 
background_text_point = {1, 91.5}
, 
background_text_size = {1860.1, 333.3}
, challenge_icon = "UI_CharDunYelenaChallengeIcon", 
frame_color = {118, 81, 221}
, main_down_res = "CharDunYelenaDown", 
main_down_size = {2600, 28}
, main_stage_icon = "UI_CharDunYelenaMianStoryIcon", main_top_res = "CharDunYelenaUp", 
main_top_size = {2600, 128}
, quest_skin = 306301, reward_panel_name = 91640}
, 
[15] = {activity_id = 15, background_res = "CharDunErikaBG", background_skin = 306602, background_text = "CharDunErikaName", 
background_text_point = {729.8, 188.5}
, 
background_text_size = {272.6, 136.3}
, challenge_icon = "UI_CharDunErikaChallengeIcon", main_stage_icon = "UI_CharDunErikaMianStoryIcon", mission_panel_name = 88715, quest_skin = 306601}
}
local __default_values = {activity_id = 10, background_res = "CharDunClothoBG", background_skin = 305801, background_text = "CharDunClothoName", background_text_point = __rt_3, background_text_size = __rt_4, challenge_icon = "UI_CharDun416ChallengeIcon", 
frame_color = {112, 51, 139}
, main_down_res = "", main_down_size = __rt_1, main_stage_icon = "UI_CharDun416MianStoryIcon", main_title_color = __rt_2, main_top_res = "", main_top_size = __rt_1, mission_panel_name = 108758, quest_skin = 305801, quest_skin_type = 1, reward_panel_name = 228152, rule_icon_color = __rt_2, shop_title_color = __rt_2, skin_type = 2}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_hero_ui_config) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_hero_ui_config, {__index = __rawdata})
return activity_hero_ui_config

