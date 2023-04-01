-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {50001}
local __rt_2 = {50030, 50011, 12}
local __rt_3 = {50030, 50023}
local __rt_4 = {50013, 12, 13}
local __rt_5 = {12, 13}
local __rt_6 = {}
local __rt_7 = {50021, 50001, 12, 13}
local __rt_8 = {12}
local __rt_9 = {50023}
local __rt_10 = {50021}
local __rt_11 = {13}
local warchess_season_level = {
{level_explain = "ID:1000", level_title_bg = "1000"}
, 
{id = 2, level_explain = "ID:1001", level_title_bg = "1001", warchess_level_id = 1001}
, 
{id = 3, level_explain = "ID:1002", level_title_bg = "1002", warchess_level_id = 1002}
, 
{id = 4, level_explain = "ID:1003", level_title_bg = "1003", warchess_level_id = 1003}
, 
{id = 5, level_explain = "ID:1004", level_title_bg = "1004", warchess_level_id = 1004}
, 
{id = 6, level_explain = "ID:1005", level_title_bg = "1005", warchess_level_id = 1005}
, 
{id = 7, warchess_level_id = 1006}
, 
{id = 8, level_explain = "ID:1007", level_title_bg = "1007", warchess_level_id = 1007}
, 
{id = 9, level_explain = "ID:1050", level_title_bg = "1050", warchess_level_id = 1050}
, 
{id = 10, level_explain = "ID:1051", level_title_bg = "1051", warchess_level_id = 1051}
, 
{id = 11, level_explain = "ID:1100", level_reward_show = __rt_2, level_show_difficulty = 2, level_title_bg = "1100", warchess_level_id = 1100, warchess_level_name = 8064}
, 
{id = 12, level_explain = "ID:1101", level_reward_show = __rt_2, level_show_difficulty = 2, level_title_bg = "1101", warchess_level_id = 1101, warchess_level_name = 8064}
, 
{id = 13, level_explain = "ID:1102", level_reward_show = __rt_2, level_show_difficulty = 2, level_title_bg = "1102", warchess_level_id = 1102, warchess_level_name = 8064}
, 
{id = 14, level_explain = "ID:1103", level_reward_show = __rt_2, level_show_difficulty = 2, level_title_bg = "1103", warchess_level_id = 1103, warchess_level_name = 8064}
, 
{id = 15, level_explain = "ID:1105", level_reward_show = __rt_2, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1105, warchess_level_name = 8064}
, 
{id = 16, level_explain = "ID:1106", level_reward_show = __rt_2, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1106, warchess_level_name = 8064}
, 
{id = 17, level_explain = "ID:1200", level_reward_show = __rt_3, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1200, warchess_level_name = 399082}
, 
{id = 18, level_explain = "ID:1202", level_reward_show = __rt_3, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1202, warchess_level_name = 399082}
, 
{id = 19, level_explain = "ID:1201", level_reward_show = __rt_3, level_show_difficulty = 3, level_title_bg = "1201", warchess_level_id = 1201, warchess_level_name = 399082}
, 
{id = 20, level_explain = "ID:1250", level_reward_show = __rt_3, level_show_difficulty = 3, level_title_bg = "1250", warchess_level_id = 1250, warchess_level_name = 399082}
, 
{id = 21, level_explain = "ID:2000", level_reward_show = __rt_4, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2000", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2000, warchess_level_name = 130375}
, 
{id = 22, level_explain = "ID:2002", level_reward_show = __rt_4, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2002", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2002, warchess_level_name = 130375}
, 
{id = 23, level_explain = "ID:2050", level_reward_show = __rt_4, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2050", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2050, warchess_level_name = 130375}
, 
{id = 24, level_explain = "ID:2051", level_reward_show = __rt_4, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2051", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2051, warchess_level_name = 130375}
, 
{id = 25, level_explain = "ID:2100", level_reward_show = __rt_5, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2100", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2100, warchess_level_name = 63912}
, 
{id = 26, level_explain = "ID:2101", level_reward_show = __rt_5, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2101", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2101, warchess_level_name = 63912}
, 
{id = 27, level_explain = "ID:2102", level_reward_show = __rt_5, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2102", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2102, warchess_level_name = 63912}
, 
{id = 28, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2200, warchess_level_name = 482816}
, 
{id = 29, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2201, warchess_level_name = 482816}
, 
{id = 30, level_explain = "ID:1300", 
level_reward_show = {50021, 12}
, level_title_bg = "1300", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1300, warchess_level_name = 401483}
, 
{id = 31, level_explain = "ID:1301", 
level_reward_show = {50021, 50011, 12}
, level_stress_add = 200, level_stress_show = 3, level_title_bg = "1301", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1301, warchess_level_name = 401483}
, 
{id = 32, level_explain = "ID:1104", level_reward_show = __rt_5, level_title_bg = "1104", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1104, warchess_level_name = 401483}
, 
{id = 33, level_explain = "ID:2001", level_reward_show = __rt_7, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2001", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2001, warchess_level_name = 401483}
, 
{id = 34, level_explain = "ID:2003", level_reward_show = __rt_7, level_stress_add = 200, level_stress_show = 3, level_title_bg = "2003", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2003, warchess_level_name = 401483}
, 
{id = 35, level_explain = "ID:1000", level_title_bg = "1000"}
, 
{id = 36, level_explain = "ID:1001", level_title_bg = "1001", warchess_level_id = 1001}
, 
{id = 37, level_explain = "ID:1002", level_title_bg = "1002", warchess_level_id = 1002}
, 
{id = 38, level_explain = "ID:1003", level_title_bg = "1003", warchess_level_id = 1003}
, 
{id = 39, level_explain = "ID:1004", level_title_bg = "1004", warchess_level_id = 1004}
, 
{id = 40, level_explain = "ID:1005", level_title_bg = "1005", warchess_level_id = 1005}
, 
{id = 41, warchess_level_id = 1006}
, 
{id = 42, level_explain = "ID:1007", level_title_bg = "1007", warchess_level_id = 1007}
, 
{id = 43, level_explain = "ID:1050", level_title_bg = "1050", warchess_level_id = 1050}
, 
{id = 44, level_explain = "ID:1051", level_title_bg = "1051", warchess_level_id = 1051}
, 
{id = 45, warchess_level_id = 1008}
, 
{id = 46, warchess_level_id = 1009}
, 
{id = 47, warchess_level_id = 1010}
, 
{id = 48, warchess_level_id = 1011}
, 
{id = 49, warchess_level_id = 1012}
, 
{id = 50, warchess_level_id = 1013}
, 
{id = 51, warchess_level_id = 1014}
, 
{id = 52, warchess_level_id = 1015}
, 
{id = 53, warchess_level_id = 1016}
, 
{id = 54, warchess_level_id = 1017}
, 
{id = 55, warchess_level_id = 1018}
, 
{id = 56, warchess_level_id = 1019}
, 
{id = 57, warchess_level_id = 1020}
, 
{id = 58, level_explain = "ID:1100", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1100", warchess_level_id = 1100, warchess_level_name = 8064}
, 
{id = 59, level_explain = "ID:1101", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1101", warchess_level_id = 1101, warchess_level_name = 8064}
, 
{id = 60, level_explain = "ID:1102", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1102", warchess_level_id = 1102, warchess_level_name = 8064}
, 
{id = 61, level_explain = "ID:1103", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1103", warchess_level_id = 1103, warchess_level_name = 8064}
, 
{id = 62, level_explain = "ID:1105", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1105, warchess_level_name = 8064}
, 
{id = 63, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1106, warchess_level_name = 8064}
, 
{id = 64, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1107, warchess_level_name = 8064}
, 
{id = 65, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1108, warchess_level_name = 8064}
, 
{id = 66, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1109, warchess_level_name = 8064}
, 
{id = 67, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1110, warchess_level_name = 8064}
, 
{id = 68, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1111, warchess_level_name = 8064}
, 
{id = 69, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1112, warchess_level_name = 8064}
, 
{id = 70, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1113, warchess_level_name = 8064}
, 
{id = 71, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1114, warchess_level_name = 8064}
, 
{id = 72, level_explain = "ID:1115", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1115, warchess_level_name = 8064}
, 
{id = 73, level_explain = "ID:1200", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1200, warchess_level_name = 399082}
, 
{id = 74, level_explain = "ID:1202", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1202, warchess_level_name = 399082}
, 
{id = 75, level_explain = "ID:1201", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1201", warchess_level_id = 1201, warchess_level_name = 399082}
, 
{id = 76, level_explain = "ID:1250", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1250", warchess_level_id = 1250, warchess_level_name = 399082}
, 
{id = 77, level_explain = "ID:2000", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2000", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2000, warchess_level_name = 130375}
, 
{id = 78, level_explain = "ID:2002", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2002", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2002, warchess_level_name = 130375}
, 
{id = 79, level_explain = "ID:2050", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2050", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2050, warchess_level_name = 130375}
, 
{id = 80, level_explain = "ID:2051", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2051", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2051, warchess_level_name = 130375}
, 
{id = 81, level_explain = "ID:2051", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2051", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2004, warchess_level_name = 401483}
, 
{id = 82, level_explain = "ID:2100", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2100", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2100, warchess_level_name = 63912}
, 
{id = 83, level_explain = "ID:2101", level_reward_show = __rt_11, level_stress_show = 3, level_title_bg = "2101", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2101, warchess_level_name = 63912}
, 
{id = 84, level_explain = "ID:2102", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2102", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2102, warchess_level_name = 63912}
, 
{id = 85, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2200, warchess_level_name = 482816}
, 
{id = 86, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2201, warchess_level_name = 482816}
, 
{id = 87, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2202, warchess_level_name = 482816}
, 
{id = 88, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2203, warchess_level_name = 482816}
, 
{id = 89, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2204, warchess_level_name = 482816}
, 
{id = 90, level_explain = "ID:1300", level_reward_show = __rt_8, level_title_bg = "1300", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1300, warchess_level_name = 401483}
, 
{id = 91, level_explain = "ID:1301", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "1301", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1301, warchess_level_name = 401483}
, 
{id = 92, level_explain = "ID:1104", level_reward_show = __rt_8, level_title_bg = "1104", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1104, warchess_level_name = 401483}
, 
{id = 93, level_explain = "ID:2001", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2001", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2001, warchess_level_name = 401483}
, 
{id = 94, level_explain = "ID:2003", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2003", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2003, warchess_level_name = 401483}
, 
{id = 95, level_explain = "ID:7000", level_title_bg = "201009", warchess_level_id = 7000}
, 
{id = 96, level_explain = "ID:7001", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2002", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 7001, warchess_level_name = 130375}
, 
{id = 97, level_explain = "ID:7002", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1100", warchess_level_id = 7002}
, 
{id = 98, level_explain = "ID:7003", level_reward_show = __rt_11, level_stress_show = 3, level_title_bg = "2101", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 7003, warchess_level_name = 63912}
, 
{id = 99, level_explain = "ID:7004", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1102", warchess_level_id = 7004}
, 
{id = 100, level_explain = "ID:7005", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "202004", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 7005, warchess_level_name = 130375}
, 
{id = 101, level_explain = "ID:7006", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 7006, warchess_level_name = 399082}
, 
{id = 102, level_explain = "ID:1000", level_title_bg = "1000"}
, 
{id = 103, level_explain = "ID:1001", level_title_bg = "1001", warchess_level_id = 1001}
, 
{id = 104, level_explain = "ID:1002", level_title_bg = "1002", warchess_level_id = 1002}
, 
{id = 105, level_explain = "ID:1003", level_title_bg = "1003", warchess_level_id = 1003}
, 
{id = 106, level_explain = "ID:1004", level_title_bg = "1004", warchess_level_id = 1004}
, 
{id = 107, level_explain = "ID:1005", level_title_bg = "1005", warchess_level_id = 1005}
, 
{id = 108, warchess_level_id = 1006}
, 
{id = 109, level_explain = "ID:1007", level_title_bg = "1007", warchess_level_id = 1007}
, 
{id = 110, level_explain = "ID:1050", level_title_bg = "1050", warchess_level_id = 1050}
, 
{id = 111, level_explain = "ID:1051", level_title_bg = "1051", warchess_level_id = 1051}
, 
{id = 112, level_title_bg = "201008", warchess_level_id = 1008}
, 
{id = 113, level_title_bg = "201009", warchess_level_id = 1009}
, 
{id = 114, level_title_bg = "201010", warchess_level_id = 1010}
, 
{id = 115, level_title_bg = "201011", warchess_level_id = 1011}
, 
{id = 116, level_title_bg = "201012", warchess_level_id = 1012}
, 
{id = 117, level_title_bg = "201013", warchess_level_id = 1013}
, 
{id = 118, level_title_bg = "201014", warchess_level_id = 1014}
, 
{id = 119, level_title_bg = "201015", warchess_level_id = 1015}
, 
{id = 120, level_title_bg = "201016", warchess_level_id = 1016}
, 
{id = 121, level_title_bg = "201017", warchess_level_id = 1017}
, 
{id = 122, level_title_bg = "201018", warchess_level_id = 1018}
, 
{id = 123, level_title_bg = "201019", warchess_level_id = 1019}
, 
{id = 124, level_title_bg = "201020", warchess_level_id = 1020}
, 
{id = 125, level_explain = "ID:1100", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1100", warchess_level_id = 1100, warchess_level_name = 8064}
, 
{id = 126, level_explain = "ID:1101", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1101", warchess_level_id = 1101, warchess_level_name = 8064}
, 
{id = 127, level_explain = "ID:1102", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1102", warchess_level_id = 1102, warchess_level_name = 8064}
, 
{id = 128, level_explain = "ID:1103", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1103", warchess_level_id = 1103, warchess_level_name = 8064}
, 
{id = 129, level_explain = "ID:1105", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1105, warchess_level_name = 8064}
, 
{id = 130, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1106, warchess_level_name = 8064}
, 
{id = 131, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201107", warchess_level_id = 1107, warchess_level_name = 8064}
, 
{id = 132, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201108", warchess_level_id = 1108, warchess_level_name = 8064}
, 
{id = 133, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201109", warchess_level_id = 1109, warchess_level_name = 8064}
, 
{id = 134, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201110", warchess_level_id = 1110, warchess_level_name = 8064}
, 
{id = 135, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201111", warchess_level_id = 1111, warchess_level_name = 8064}
, 
{id = 136, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201112", warchess_level_id = 1112, warchess_level_name = 8064}
, 
{id = 137, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201113", warchess_level_id = 1113, warchess_level_name = 8064}
, 
{id = 138, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201114", warchess_level_id = 1114, warchess_level_name = 8064}
, 
{id = 139, level_explain = "ID:1115", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1115, warchess_level_name = 8064}
, 
{id = 140, level_explain = "ID:1200", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1200, warchess_level_name = 399082}
, 
{id = 141, level_explain = "ID:1202", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1202, warchess_level_name = 399082}
, 
{id = 142, level_explain = "ID:1201", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1201", warchess_level_id = 1201, warchess_level_name = 399082}
, 
{id = 143, level_explain = "ID:1250", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1250", warchess_level_id = 1250, warchess_level_name = 399082}
, 
{id = 144, level_explain = "ID:2000", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2000", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2000, warchess_level_name = 130375}
, 
{id = 145, level_explain = "ID:2002", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2002", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2002, warchess_level_name = 130375}
, 
{id = 146, level_explain = "ID:2050", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2050", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2050, warchess_level_name = 130375}
, 
{id = 147, level_explain = "ID:2051", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2051", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2051, warchess_level_name = 130375}
, 
{id = 148, level_explain = "ID:2051", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "202004", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2004, warchess_level_name = 401483}
, 
{id = 149, level_explain = "ID:2100", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2100", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2100, warchess_level_name = 63912}
, 
{id = 150, level_explain = "ID:2101", level_reward_show = __rt_11, level_stress_show = 3, level_title_bg = "2101", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2101, warchess_level_name = 63912}
, 
{id = 151, level_explain = "ID:2102", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2102", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2102, warchess_level_name = 63912}
, 
{id = 152, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2200, warchess_level_name = 482816}
, 
{id = 153, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2201, warchess_level_name = 482816}
, 
{id = 154, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "202202", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2202, warchess_level_name = 482816}
, 
{id = 155, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2203, warchess_level_name = 482816}
, 
{id = 156, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "202202", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2204, warchess_level_name = 482816}
, 
{id = 157, level_explain = "ID:1300", level_reward_show = __rt_8, level_title_bg = "1300", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1300, warchess_level_name = 401483}
, 
{id = 158, level_explain = "ID:1301", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "1301", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1301, warchess_level_name = 401483}
, 
{id = 159, level_explain = "ID:1104", level_reward_show = __rt_8, level_title_bg = "1104", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1104, warchess_level_name = 401483}
, 
{id = 160, level_explain = "ID:2001", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2001", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2001, warchess_level_name = 401483}
, 
{id = 161, level_explain = "ID:2003", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2003", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2003, warchess_level_name = 401483}
, 
{id = 162, level_explain = "ID:1000", level_title_bg = "1000"}
, 
{id = 163, level_explain = "ID:1001", level_title_bg = "1001", warchess_level_id = 1001}
, 
{id = 164, level_explain = "ID:1002", level_title_bg = "1002", warchess_level_id = 1002}
, 
{id = 165, level_explain = "ID:1003", level_title_bg = "1003", warchess_level_id = 1003}
, 
{id = 166, level_explain = "ID:1004", level_title_bg = "1004", warchess_level_id = 1004}
, 
{id = 167, level_explain = "ID:1005", level_title_bg = "1005", warchess_level_id = 1005}
, 
{id = 168, warchess_level_id = 1006}
, 
{id = 169, level_explain = "ID:1007", level_title_bg = "1007", warchess_level_id = 1007}
, 
{id = 170, level_explain = "ID:1050", level_title_bg = "1050", warchess_level_id = 1050}
, 
{id = 171, level_explain = "ID:1051", level_title_bg = "1051", warchess_level_id = 1051}
, 
{id = 172, level_explain = "ID:1008", level_title_bg = "201008", warchess_level_id = 1008}
, 
{id = 173, level_explain = "ID:1009", level_title_bg = "201009", warchess_level_id = 1009}
, 
{id = 174, level_explain = "ID:1010", level_title_bg = "201010", warchess_level_id = 1010}
, 
{id = 175, level_explain = "ID:1011", level_title_bg = "201011", warchess_level_id = 1011}
, 
{id = 176, level_explain = "ID:1012", level_title_bg = "201012", warchess_level_id = 1012}
, 
{id = 177, level_explain = "ID:1013", level_title_bg = "201013", warchess_level_id = 1013}
, 
{id = 178, level_explain = "ID:1014", level_title_bg = "201014", warchess_level_id = 1014}
, 
{id = 179, level_explain = "ID:1015", level_title_bg = "201015", warchess_level_id = 1015}
, 
{id = 180, level_explain = "ID:1016", level_title_bg = "201016", warchess_level_id = 1016}
, 
{id = 181, level_explain = "ID:1017", level_title_bg = "201017", warchess_level_id = 1017}
, 
{id = 182, level_explain = "ID:1018", level_title_bg = "201018", warchess_level_id = 1018}
, 
{id = 183, level_explain = "ID:1019", level_title_bg = "201019", warchess_level_id = 1019}
, 
{id = 184, level_explain = "ID:1020", level_title_bg = "201020", warchess_level_id = 1020}
, 
{id = 185, level_explain = "ID:1021", level_title_bg = "1021", warchess_level_id = 1021}
, 
{id = 186, level_explain = "ID:1022", level_title_bg = "1022", warchess_level_id = 1022}
, 
{id = 187, level_explain = "ID:1023", level_title_bg = "1023", warchess_level_id = 1023}
, 
{id = 188, level_explain = "ID:1024", level_title_bg = "1024", warchess_level_id = 1024}
, 
{id = 189, level_explain = "ID:1025", level_title_bg = "1025", warchess_level_id = 1025}
, 
{id = 190, level_explain = "ID:1026", level_title_bg = "1026", warchess_level_id = 1026}
, 
{id = 191, level_explain = "ID:1027", level_title_bg = "1027", warchess_level_id = 1027}
, 
{id = 192, level_explain = "ID:1028", level_title_bg = "1028", warchess_level_id = 1028}
, 
{id = 193, level_explain = "ID:1029", level_title_bg = "1029", warchess_level_id = 1029}
, 
{id = 194, level_explain = "ID:1030", level_title_bg = "1030", warchess_level_id = 1030}
, 
{id = 195, level_explain = "ID:1031", level_title_bg = "1031", warchess_level_id = 1031}
, 
{id = 196, level_explain = "ID:1100", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1100", warchess_level_id = 1100, warchess_level_name = 8064}
, 
{id = 197, level_explain = "ID:1101", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1101", warchess_level_id = 1101, warchess_level_name = 8064}
, 
{id = 198, level_explain = "ID:1102", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1102", warchess_level_id = 1102, warchess_level_name = 8064}
, 
{id = 199, level_explain = "ID:1103", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1103", warchess_level_id = 1103, warchess_level_name = 8064}
, 
{id = 200, level_explain = "ID:1105", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1105, warchess_level_name = 8064}
, 
{id = 201, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1106, warchess_level_name = 8064}
, 
{id = 202, level_explain = "ID:1107", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201107", warchess_level_id = 1107, warchess_level_name = 8064}
, 
{id = 203, level_explain = "ID:1108", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201108", warchess_level_id = 1108, warchess_level_name = 8064}
, 
{id = 204, level_explain = "ID:1109", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201109", warchess_level_id = 1109, warchess_level_name = 8064}
, 
{id = 205, level_explain = "ID:1110", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201110", warchess_level_id = 1110, warchess_level_name = 8064}
, 
{id = 206, level_explain = "ID:1111", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201111", warchess_level_id = 1111, warchess_level_name = 8064}
, 
{id = 207, level_explain = "ID:1112", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201112", warchess_level_id = 1112, warchess_level_name = 8064}
, 
{id = 208, level_explain = "ID:1113", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201113", warchess_level_id = 1113, warchess_level_name = 8064}
, 
{id = 209, level_explain = "ID:1114", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201114", warchess_level_id = 1114, warchess_level_name = 8064}
, 
{id = 210, level_explain = "ID:1115", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1115, warchess_level_name = 8064}
, 
{id = 211, level_explain = "ID:1116", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1116", warchess_level_id = 1116, warchess_level_name = 8064}
, 
{id = 212, level_explain = "ID:1117", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1117", warchess_level_id = 1117, warchess_level_name = 8064}
, 
{id = 213, level_explain = "ID:1118", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1118", warchess_level_id = 1118, warchess_level_name = 8064}
, 
{id = 214, level_explain = "ID:1200", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1200, warchess_level_name = 399082}
, 
{id = 215, level_explain = "ID:1202", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1202, warchess_level_name = 399082}
, 
{id = 216, level_explain = "ID:1201", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1201", warchess_level_id = 1201, warchess_level_name = 399082}
, 
{id = 217, level_explain = "ID:1203", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1203", warchess_level_id = 1203, warchess_level_name = 399082}
, 
{id = 218, level_explain = "ID:1204", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1204", warchess_level_id = 1204, warchess_level_name = 399082}
, 
{id = 219, level_explain = "ID:1250", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1250", warchess_level_id = 1250, warchess_level_name = 399082}
, 
{id = 220, level_explain = "ID:2000", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2000", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2000, warchess_level_name = 130375}
, 
{id = 221, level_explain = "ID:2002", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2002", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2002, warchess_level_name = 130375}
, 
{id = 222, level_explain = "ID:2050", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2050", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2050, warchess_level_name = 130375}
, 
{id = 223, level_explain = "ID:2051", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2051", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2051, warchess_level_name = 130375}
, 
{id = 224, level_explain = "ID:2004", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "202004", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2004, warchess_level_name = 401483}
, 
{id = 225, level_explain = "ID:2100", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2100", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2100, warchess_level_name = 63912}
, 
{id = 226, level_explain = "ID:2101", level_reward_show = __rt_11, level_stress_show = 3, level_title_bg = "2101", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2101, warchess_level_name = 63912}
, 
{id = 227, level_explain = "ID:2102", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2102", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2102, warchess_level_name = 63912}
; 
[229] = {id = 229, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2200, warchess_level_name = 482816}
, 
[230] = {id = 230, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2201, warchess_level_name = 482816}
, 
[231] = {id = 231, level_explain = "ID:2202", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "202202", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2202, warchess_level_name = 482816}
, 
[232] = {id = 232, level_explain = "ID:2203", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2203, warchess_level_name = 482816}
, 
[233] = {id = 233, level_explain = "ID:2204", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "202004", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2204, warchess_level_name = 482816}
, 
[234] = {id = 234, level_explain = "ID:1300", level_reward_show = __rt_8, level_title_bg = "1300", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1300, warchess_level_name = 401483}
, 
[235] = {id = 235, level_explain = "ID:1301", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "1301", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1301, warchess_level_name = 401483}
, 
[236] = {id = 236, level_explain = "ID:1104", level_reward_show = __rt_8, level_title_bg = "1104", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1104, warchess_level_name = 401483}
, 
[237] = {id = 237, level_explain = "ID:2001", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2001", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2001, warchess_level_name = 401483}
, 
[238] = {id = 238, level_explain = "ID:2003", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2003", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2003, warchess_level_name = 401483}
, 
[239] = {id = 239, level_explain = "ID:1000", level_title_bg = "1000"}
, 
[240] = {id = 240, level_explain = "ID:1001", level_title_bg = "1001", warchess_level_id = 1001}
, 
[241] = {id = 241, level_explain = "ID:1002", level_title_bg = "1002", warchess_level_id = 1002}
, 
[242] = {id = 242, level_explain = "ID:1003", level_title_bg = "1003", warchess_level_id = 1003}
, 
[243] = {id = 243, level_explain = "ID:1004", level_title_bg = "1004", warchess_level_id = 1004}
, 
[244] = {id = 244, level_explain = "ID:1005", level_title_bg = "1005", warchess_level_id = 1005}
, 
[245] = {id = 245, warchess_level_id = 1006}
, 
[246] = {id = 246, level_explain = "ID:1007", level_title_bg = "1007", warchess_level_id = 1007}
, 
[247] = {id = 247, level_explain = "ID:1050", level_title_bg = "1050", warchess_level_id = 1050}
, 
[248] = {id = 248, level_explain = "ID:1051", level_title_bg = "1051", warchess_level_id = 1051}
, 
[249] = {id = 249, level_explain = "ID:1008", level_title_bg = "201008", warchess_level_id = 1008}
, 
[250] = {id = 250, level_explain = "ID:1009", level_title_bg = "201009", warchess_level_id = 1009}
, 
[251] = {id = 251, level_explain = "ID:1010", level_title_bg = "201010", warchess_level_id = 1010}
, 
[252] = {id = 252, level_explain = "ID:1011", level_title_bg = "201011", warchess_level_id = 1011}
, 
[253] = {id = 253, level_explain = "ID:1012", level_title_bg = "201012", warchess_level_id = 1012}
, 
[254] = {id = 254, level_explain = "ID:1013", level_title_bg = "201013", warchess_level_id = 1013}
, 
[255] = {id = 255, level_explain = "ID:1014", level_title_bg = "201014", warchess_level_id = 1014}
, 
[256] = {id = 256, level_explain = "ID:1015", level_title_bg = "201015", warchess_level_id = 1015}
, 
[257] = {id = 257, level_explain = "ID:1016", level_title_bg = "201016", warchess_level_id = 1016}
, 
[258] = {id = 258, level_explain = "ID:1017", level_title_bg = "201017", warchess_level_id = 1017}
, 
[259] = {id = 259, level_explain = "ID:1018", level_title_bg = "201018", warchess_level_id = 1018}
, 
[260] = {id = 260, level_explain = "ID:1019", level_title_bg = "201019", warchess_level_id = 1019}
, 
[261] = {id = 261, level_explain = "ID:1020", level_title_bg = "201020", warchess_level_id = 1020}
, 
[262] = {id = 262, level_explain = "ID:1021", level_title_bg = "1021", warchess_level_id = 1021}
, 
[263] = {id = 263, level_explain = "ID:1022", level_title_bg = "1022", warchess_level_id = 1022}
, 
[264] = {id = 264, level_explain = "ID:1023", level_title_bg = "1023", warchess_level_id = 1023}
, 
[265] = {id = 265, level_explain = "ID:1024", level_title_bg = "1024", warchess_level_id = 1024}
, 
[266] = {id = 266, level_explain = "ID:1025", level_title_bg = "1025", warchess_level_id = 1025}
, 
[267] = {id = 267, level_explain = "ID:1026", level_title_bg = "1026", warchess_level_id = 1026}
, 
[268] = {id = 268, level_explain = "ID:1027", level_title_bg = "1027", warchess_level_id = 1027}
, 
[269] = {id = 269, level_explain = "ID:1028", level_title_bg = "1028", warchess_level_id = 1028}
, 
[270] = {id = 270, level_explain = "ID:1029", level_title_bg = "1029", warchess_level_id = 1029}
, 
[271] = {id = 271, level_explain = "ID:1030", level_title_bg = "1030", warchess_level_id = 1030}
, 
[272] = {id = 272, level_explain = "ID:1031", level_title_bg = "1031", warchess_level_id = 1031}
, 
[273] = {id = 273, level_explain = "ID:1100", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1100", warchess_level_id = 1100, warchess_level_name = 8064}
, 
[274] = {id = 274, level_explain = "ID:1101", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1101", warchess_level_id = 1101, warchess_level_name = 8064}
, 
[275] = {id = 275, level_explain = "ID:1102", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1102", warchess_level_id = 1102, warchess_level_name = 8064}
, 
[276] = {id = 276, level_explain = "ID:1103", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1103", warchess_level_id = 1103, warchess_level_name = 8064}
, 
[277] = {id = 277, level_explain = "ID:1105", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1105, warchess_level_name = 8064}
, 
[278] = {id = 278, level_explain = "ID:1106", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1106", warchess_level_id = 1106, warchess_level_name = 8064}
, 
[279] = {id = 279, level_explain = "ID:1107", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201107", warchess_level_id = 1107, warchess_level_name = 8064}
, 
[280] = {id = 280, level_explain = "ID:1108", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201108", warchess_level_id = 1108, warchess_level_name = 8064}
, 
[281] = {id = 281, level_explain = "ID:1109", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201109", warchess_level_id = 1109, warchess_level_name = 8064}
, 
[282] = {id = 282, level_explain = "ID:1110", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201110", warchess_level_id = 1110, warchess_level_name = 8064}
, 
[283] = {id = 283, level_explain = "ID:1111", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201111", warchess_level_id = 1111, warchess_level_name = 8064}
, 
[284] = {id = 284, level_explain = "ID:1112", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201112", warchess_level_id = 1112, warchess_level_name = 8064}
, 
[285] = {id = 285, level_explain = "ID:1113", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201113", warchess_level_id = 1113, warchess_level_name = 8064}
, 
[286] = {id = 286, level_explain = "ID:1114", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "201114", warchess_level_id = 1114, warchess_level_name = 8064}
, 
[287] = {id = 287, level_explain = "ID:1115", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1105", warchess_level_id = 1115, warchess_level_name = 8064}
, 
[288] = {id = 288, level_explain = "ID:1116", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1116", warchess_level_id = 1116, warchess_level_name = 8064}
, 
[289] = {id = 289, level_explain = "ID:1117", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1117", warchess_level_id = 1117, warchess_level_name = 8064}
, 
[290] = {id = 290, level_explain = "ID:1118", level_reward_show = __rt_8, level_show_difficulty = 2, level_title_bg = "1118", warchess_level_id = 1118, warchess_level_name = 8064}
, 
[291] = {id = 291, level_explain = "ID:1200", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1200, warchess_level_name = 399082}
, 
[292] = {id = 292, level_explain = "ID:1202", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1200", warchess_level_id = 1202, warchess_level_name = 399082}
, 
[293] = {id = 293, level_explain = "ID:1201", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1201", warchess_level_id = 1201, warchess_level_name = 399082}
, 
[294] = {id = 294, level_explain = "ID:1203", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1203", warchess_level_id = 1203, warchess_level_name = 399082}
, 
[295] = {id = 295, level_explain = "ID:1204", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1204", warchess_level_id = 1204, warchess_level_name = 399082}
, 
[296] = {id = 296, level_explain = "ID:1250", level_reward_show = __rt_9, level_show_difficulty = 3, level_title_bg = "1250", warchess_level_id = 1250, warchess_level_name = 399082}
, 
[297] = {id = 297, level_explain = "ID:2000", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2000", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2000, warchess_level_name = 130375}
, 
[298] = {id = 298, level_explain = "ID:2002", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2002", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2002, warchess_level_name = 130375}
, 
[299] = {id = 299, level_explain = "ID:2050", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2050", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2050, warchess_level_name = 130375}
, 
[300] = {id = 300, level_explain = "ID:2051", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "2051", level_type = 4, warchess_level_icon = "ICON_season_box", warchess_level_id = 2051, warchess_level_name = 130375}
, 
[301] = {id = 301, level_explain = "ID:2004", level_reward_show = __rt_10, level_stress_show = 3, level_title_bg = "202004", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2004, warchess_level_name = 401483}
, 
[302] = {id = 302, level_explain = "ID:2100", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2100", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2100, warchess_level_name = 63912}
, 
[303] = {id = 303, level_explain = "ID:2101", level_reward_show = __rt_11, level_stress_show = 3, level_title_bg = "2101", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2101, warchess_level_name = 63912}
, 
[304] = {id = 304, level_explain = "ID:2102", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2102", level_type = 4, warchess_level_icon = "ICON_season_digger", warchess_level_id = 2102, warchess_level_name = 63912}
, 
[305] = {id = 305, level_explain = "ID:2200", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2200, warchess_level_name = 482816}
, 
[306] = {id = 306, level_explain = "ID:2201", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2201", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2201, warchess_level_name = 482816}
, 
[307] = {id = 307, level_explain = "ID:2202", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "202202", level_type = 1, warchess_level_icon = "ICON_season_pumpkin", warchess_level_id = 2202, warchess_level_name = 482816}
, 
[308] = {id = 308, level_explain = "ID:2203", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "2200", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2203, warchess_level_name = 482816}
, 
[309] = {id = 309, level_explain = "ID:2204", level_reward_show = __rt_6, level_stress_show = 3, level_title_bg = "202004", level_type = 1, warchess_level_icon = "ICON_season_recover", warchess_level_id = 2204, warchess_level_name = 482816}
, 
[310] = {id = 310, level_explain = "ID:1300", level_reward_show = __rt_8, level_title_bg = "1300", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1300, warchess_level_name = 401483}
, 
[311] = {id = 311, level_explain = "ID:1301", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "1301", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1301, warchess_level_name = 401483}
, 
[312] = {id = 312, level_explain = "ID:1104", level_reward_show = __rt_8, level_title_bg = "1104", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 1104, warchess_level_name = 401483}
, 
[313] = {id = 313, level_explain = "ID:2001", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2001", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2001, warchess_level_name = 401483}
, 
[314] = {id = 314, level_explain = "ID:2003", level_reward_show = __rt_8, level_stress_show = 3, level_title_bg = "2003", level_type = 2, warchess_level_icon = "ICON_season_special", warchess_level_id = 2003, warchess_level_name = 401483}
}
local __default_values = {id = 1, level_explain = "ID:1006", level_reward_show = __rt_1, level_show_difficulty = 1, level_stress_add = 100, level_stress_show = 2, level_title_bg = "1006", level_type = 3, warchess_level_icon = "ICON_season_battle", warchess_level_id = 1000, warchess_level_name = 77830}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in (_ENV.pairs)(warchess_season_level) do
  (_ENV.setmetatable)(v, base)
end
local __rawdata = {__basemetatable = base}
;
(_ENV.setmetatable)(warchess_season_level, {__index = __rawdata})
return warchess_season_level

