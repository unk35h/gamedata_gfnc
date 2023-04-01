-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {50001}
local __rt_2 = {}
local __rt_3 = {52449}
local __rt_4 = {1}
local __rt_5 = {50030, 50011, 12}
local __rt_6 = {50030, 50023}
local __rt_7 = {"BOSS"}
local __rt_8 = {142330}
local __rt_9 = {21283}
local __rt_10 = {248719}
local __rt_11 = {0.8, 0.16, 0.1}
local __rt_12 = {331725}
local __rt_13 = {236955}
local __rt_14 = {90010}
local __rt_15 = {97945}
local __rt_16 = {329038}
local __rt_17 = {288721}
local warchess_room_monster = {
[3000001] = {icon = 7, mon_name = 339671, tag_des = __rt_3, team_id = 3000001, type = 1}
, 
[3000002] = {icon = 8, id = 3000002, mon_name = 170192, tag_des = __rt_3, team_id = 3000002, type = 2}
, 
[3000003] = {dorp_icon = __rt_5, icon = 9, id = 3000003, mon_name = 491071, tag_des = __rt_3, team_id = 3000003, type = 3}
, 
[3000004] = {dorp_icon = __rt_6, id = 3000004, special_effect = "40001", team_id = 3000004}
, 
[3000011] = {icon = 7, id = 3000011, mon_name = 339671, tag_des = __rt_3, team_id = 3000011, type = 1}
, 
[3000012] = {icon = 8, id = 3000012, mon_name = 170192, tag_des = __rt_3, team_id = 3000012, type = 2}
, 
[3000013] = {dorp_icon = __rt_5, icon = 9, id = 3000013, mon_name = 491071, tag_des = __rt_3, team_id = 3000013, type = 3}
, 
[3000014] = {dorp_icon = __rt_6, id = 3000014, special_effect = "40001", team_id = 3000014}
, 
[3010011] = {icon = 7, id = 3010011, mon_name = 339671, tag_des = __rt_8, team_id = 3010011, type = 1}
, 
[3010012] = {icon = 8, id = 3010012, mon_name = 170192, tag_des = __rt_8, team_id = 3010012, type = 2}
, 
[3010013] = {dorp_icon = __rt_5, icon = 9, id = 3010013, mon_name = 491071, tag_des = __rt_8, team_id = 3010013, type = 3}
, 
[3010014] = {dorp_icon = __rt_6, id = 3010014, special_effect = "40001", team_id = 3010014}
, 
[3010021] = {icon = 7, id = 3010021, mon_name = 339671, tag_des = __rt_8, team_id = 3010021, type = 1}
, 
[3010022] = {icon = 8, id = 3010022, mon_name = 170192, tag_des = __rt_8, team_id = 3010022, type = 2}
, 
[3010023] = {dorp_icon = __rt_5, icon = 9, id = 3010023, mon_name = 491071, tag_des = __rt_8, team_id = 3010023, type = 3}
, 
[3010024] = {dorp_icon = __rt_6, id = 3010024, special_effect = "40001", team_id = 3010024}
, 
[3010031] = {icon = 7, id = 3010031, mon_name = 339671, tag_des = __rt_8, team_id = 3010031, type = 1}
, 
[3010032] = {icon = 8, id = 3010032, mon_name = 170192, tag_des = __rt_8, team_id = 3010032, type = 2}
, 
[3010033] = {dorp_icon = __rt_5, icon = 9, id = 3010033, mon_name = 491071, tag_des = __rt_8, team_id = 3010033, type = 3}
, 
[3010034] = {dorp_icon = __rt_6, id = 3010034, special_effect = "40001", team_id = 3010034}
, 
[3010041] = {icon = 7, id = 3010041, mon_name = 339671, tag_des = __rt_8, team_id = 3010041, type = 1}
, 
[3010042] = {icon = 8, id = 3010042, mon_name = 170192, tag_des = __rt_8, team_id = 3010042, type = 2}
, 
[3010043] = {dorp_icon = __rt_5, icon = 9, id = 3010043, mon_name = 491071, tag_des = __rt_8, team_id = 3010043, type = 3}
, 
[3010044] = {dorp_icon = __rt_6, id = 3010044, special_effect = "40001", team_id = 3010044}
, 
[3010051] = {icon = 7, id = 3010051, mon_name = 506430, tag_des = __rt_9, team_id = 3010051, type = 1}
, 
[3010052] = {icon = 8, id = 3010052, mon_name = 336951, tag_des = __rt_9, team_id = 3010052, type = 2}
, 
[3010053] = {dorp_icon = __rt_5, icon = 9, id = 3010053, mon_name = 133543, tag_des = __rt_9, team_id = 3010053, type = 3}
, 
[3010054] = {dorp_icon = __rt_6, id = 3010054, special_effect = "40001", team_id = 3010054}
, 
[3010061] = {icon = 7, id = 3010061, mon_name = 506430, tag_des = __rt_9, team_id = 3010061, type = 1}
, 
[3010062] = {icon = 8, id = 3010062, mon_name = 336951, tag_des = __rt_9, team_id = 3010062, type = 2}
, 
[3010063] = {dorp_icon = __rt_5, icon = 9, id = 3010063, mon_name = 133543, tag_des = __rt_9, team_id = 3010063, type = 3}
, 
[3010064] = {dorp_icon = __rt_6, id = 3010064, special_effect = "40001", team_id = 3010064}
, 
[3010071] = {icon = 7, id = 3010071, mon_name = 506430, tag_des = __rt_9, team_id = 3010071, type = 1}
, 
[3010072] = {icon = 8, id = 3010072, mon_name = 336951, tag_des = __rt_9, team_id = 3010072, type = 2}
, 
[3010073] = {dorp_icon = __rt_5, icon = 9, id = 3010073, mon_name = 133543, tag_des = __rt_9, team_id = 3010073, type = 3}
, 
[3010074] = {dorp_icon = __rt_6, id = 3010074, special_effect = "40001", team_id = 3010074}
, 
[3010081] = {icon = 7, id = 3010081, mon_name = 506430, tag_des = __rt_9, team_id = 3010081, type = 1}
, 
[3010082] = {icon = 8, id = 3010082, mon_name = 336951, tag_des = __rt_9, team_id = 3010082, type = 2}
, 
[3010083] = {dorp_icon = __rt_5, icon = 9, id = 3010083, mon_name = 133543, tag_des = __rt_9, team_id = 3010083, type = 3}
, 
[3010084] = {dorp_icon = __rt_6, id = 3010084, special_effect = "40001", team_id = 3010084}
, 
[3010091] = {icon = 7, id = 3010091, mon_name = 300734, tag_des = __rt_3, team_id = 3010091, type = 1}
, 
[3010092] = {icon = 8, id = 3010092, mon_name = 131255, tag_des = __rt_3, team_id = 3010092, type = 2}
, 
[3010093] = {dorp_icon = __rt_5, icon = 9, id = 3010093, mon_name = 452134, tag_des = __rt_3, team_id = 3010093, type = 3}
, 
[3010094] = {dorp_icon = __rt_6, id = 3010094, special_effect = "40001", team_id = 3010094}
, 
[3010101] = {icon = 7, id = 3010101, mon_name = 300734, tag_des = __rt_3, team_id = 3010101, type = 1}
, 
[3010102] = {icon = 8, id = 3010102, mon_name = 131255, tag_des = __rt_3, team_id = 3010102, type = 2}
, 
[3010103] = {dorp_icon = __rt_5, icon = 9, id = 3010103, mon_name = 452134, tag_des = __rt_3, team_id = 3010103, type = 3}
, 
[3010104] = {dorp_icon = __rt_6, id = 3010104, special_effect = "40001", team_id = 3010104}
, 
[3010116] = {icon = 7, id = 3010116, mon_name = 300734, tag_des = __rt_3, team_id = 3010116, type = 1}
, 
[3010117] = {icon = 8, id = 3010117, mon_name = 131255, tag_des = __rt_3, team_id = 3010117, type = 2}
, 
[3010118] = {dorp_icon = __rt_5, icon = 9, id = 3010118, mon_name = 452134, tag_des = __rt_3, team_id = 3010118, type = 3}
, 
[3010119] = {dorp_icon = __rt_6, id = 3010119, special_effect = "40001", team_id = 3010119}
, 
[3010126] = {icon = 7, id = 3010126, mon_name = 300734, tag_des = __rt_3, team_id = 3010126, type = 1}
, 
[3010127] = {icon = 8, id = 3010127, mon_name = 131255, tag_des = __rt_3, team_id = 3010127, type = 2}
, 
[3010128] = {dorp_icon = __rt_5, icon = 9, id = 3010128, mon_name = 452134, tag_des = __rt_3, team_id = 3010128, type = 3}
, 
[3010129] = {dorp_icon = __rt_6, id = 3010129, special_effect = "40001", team_id = 3010129}
, 
[3010201] = {dorp_icon = __rt_6, id = 3010201, special_effect = "40001", team_id = 3010124}
, 
[3010301] = {dorp_icon = __rt_6, id = 3010301, special_effect = "40001", team_id = 3010134}
, 
[3010401] = {icon = 7, id = 3010401, mon_name = 506430, tag_des = __rt_9, team_id = 3010051, type = 1}
, 
[3010402] = {icon = 7, id = 3010402, mon_name = 339671, tag_des = __rt_8, team_id = 3010021, type = 1}
, 
[3010403] = {icon = 7, id = 3010403, mon_name = 343376, tag_des = __rt_3, team_id = 3010091, type = 1}
, 
[3010404] = {icon = 8, id = 3010404, mon_name = 336951, tag_des = __rt_9, team_id = 3010052, type = 2}
, 
[3010405] = {icon = 8, id = 3010405, mon_name = 170192, tag_des = __rt_8, team_id = 3010022, type = 2}
, 
[3010406] = {icon = 8, id = 3010406, mon_name = 173897, tag_des = __rt_3, team_id = 3010092, type = 2}
, 
[3010407] = {dorp_icon = __rt_5, icon = 9, id = 3010407, mon_name = 133543, tag_des = __rt_9, team_id = 3010053, type = 3}
, 
[3010408] = {dorp_icon = __rt_5, icon = 9, id = 3010408, mon_name = 491071, tag_des = __rt_8, team_id = 3010023, type = 3}
, 
[3010409] = {dorp_icon = __rt_5, icon = 9, id = 3010409, mon_name = 494776, tag_des = __rt_3, team_id = 3010093, type = 3}
, 
[3010410] = {dorp_icon = __rt_6, id = 3010410, special_effect = "40001", team_id = 3010410}
, 
[3010510] = {dorp_icon = __rt_6, id = 3010510, special_effect = "40001", team_id = 3010114}
, 
[3010601] = {icon = 7, id = 3010601, mon_name = 506430, tag_des = __rt_9, team_id = 3010051, type = 1}
, 
[3010602] = {icon = 7, id = 3010602, mon_name = 339671, tag_des = __rt_8, team_id = 3010021, type = 1}
, 
[3010603] = {icon = 7, id = 3010603, mon_name = 343376, tag_des = __rt_3, team_id = 3010091, type = 1}
, 
[3010604] = {icon = 8, id = 3010604, mon_name = 336951, tag_des = __rt_9, team_id = 3010052, type = 2}
, 
[3010605] = {icon = 8, id = 3010605, mon_name = 170192, tag_des = __rt_8, team_id = 3010022, type = 2}
, 
[3010606] = {icon = 8, id = 3010606, mon_name = 173897, tag_des = __rt_3, team_id = 3010092, type = 2}
, 
[3010607] = {dorp_icon = __rt_5, icon = 9, id = 3010607, mon_name = 133543, tag_des = __rt_9, team_id = 3010053, type = 3}
, 
[3010608] = {dorp_icon = __rt_5, icon = 9, id = 3010608, mon_name = 491071, tag_des = __rt_8, team_id = 3010023, type = 3}
, 
[3010609] = {dorp_icon = __rt_5, icon = 9, id = 3010609, mon_name = 494776, tag_des = __rt_3, team_id = 3010093, type = 3}
, 
[3010610] = {dorp_icon = __rt_6, id = 3010610, outiline_hdr = 320, 
outline_color = {0.5, 0.2, 0.4}
, outline_enable = true, outline_scale = 3, outline_wider = 10, special_effect = "40001", team_id = 3010410}
, 
[3010704] = {dorp_icon = __rt_6, id = 3010704, special_effect = "40001", team_id = 3010704}
, 
[3010804] = {dorp_icon = __rt_6, id = 3010804, special_effect = "40001", team_id = 3010804}
, 
[3010805] = {dorp_icon = __rt_6, id = 3010805, special_effect = "40001", team_id = 3010805}
, 
[3010904] = {dorp_icon = __rt_6, id = 3010904, special_effect = "40001", team_id = 3010904}
, 
[3011004] = {dorp_icon = __rt_6, id = 3011004, special_effect = "40001", team_id = 3011004}
, 
[3011104] = {dorp_icon = __rt_6, id = 3011104, special_effect = "40001", team_id = 3011104}
, 
[3011304] = {dorp_icon = __rt_6, id = 3011304, special_effect = "40001", team_id = 3011304}
, 
[3011504] = {dorp_icon = __rt_6, id = 3011504, special_effect = "40001", team_id = 3011504}
, 
[3011704] = {dorp_icon = __rt_6, id = 3011704, special_effect = "40001", team_id = 3011704}
, 
[3011803] = {dorp_icon = __rt_6, id = 3011803, special_effect = "40001", team_id = 3011804}
, 
[3011804] = {dorp_icon = __rt_6, id = 3011804, special_effect = "40001", team_id = 3011804}
, 
[3011805] = {dorp_icon = __rt_6, id = 3011805, special_effect = "40001", team_id = 3011805}
, 
[3011806] = {dorp_icon = __rt_6, id = 3011806, special_effect = "40001", team_id = 3011806}
, 
[3011807] = {dorp_icon = __rt_6, id = 3011807, special_effect = "40001", team_id = 3011807}
, 
[3011904] = {dorp_icon = __rt_6, id = 3011904, special_effect = "40001", team_id = 3011904}
, 
[3012001] = {dorp_icon = __rt_6, id = 3012001, special_effect = "40001", team_id = 3012001}
, 
[3012002] = {dorp_icon = __rt_6, id = 3012002, special_effect = "40001", team_id = 3012002}
, 
[3012003] = {dorp_icon = __rt_6, id = 3012003, special_effect = "40001", team_id = 3012003}
, 
[3012004] = {dorp_icon = __rt_6, id = 3012004, special_effect = "40001", team_id = 3012004}
, 
[3015101] = {icon = 7, id = 3015101, mon_name = 300734, tag_des = __rt_3, team_id = 3015101, type = 1}
, 
[3015102] = {icon = 7, id = 3015102, mon_name = 300734, tag_des = __rt_3, team_id = 3015102, type = 1}
, 
[3015103] = {icon = 7, id = 3015103, mon_name = 300734, tag_des = __rt_3, team_id = 3015103, type = 1}
, 
[3015104] = {dorp_icon = __rt_6, id = 3015104, special_effect = "40001", team_id = 3015104}
, 
[3015201] = {icon = 8, id = 3015201, mon_name = 131255, tag_des = __rt_3, team_id = 3015201, type = 2}
, 
[3015202] = {icon = 8, id = 3015202, mon_name = 131255, tag_des = __rt_3, team_id = 3015202, type = 2}
, 
[3015204] = {dorp_icon = __rt_6, id = 3015204, special_effect = "40001", team_id = 3015204}
, 
[3015301] = {dorp_icon = __rt_5, icon = 9, id = 3015301, mon_name = 452134, tag_des = __rt_3, team_id = 3015301, type = 3}
, 
[3015302] = {dorp_icon = __rt_5, icon = 9, id = 3015302, mon_name = 452134, tag_des = __rt_3, team_id = 3015302, type = 3}
, 
[3015404] = {dorp_icon = __rt_6, id = 3015404, special_effect = "40001", team_id = 3015404}
, 
[3016001] = {icon = 7, id = 3016001, mon_name = 339671, tag_des = __rt_10, team_id = 3010021, type = 1}
, 
[3016002] = {icon = 8, id = 3016002, mon_name = 170192, tag_des = __rt_10, team_id = 3010022, type = 2}
, 
[3016003] = {dorp_icon = __rt_5, icon = 9, id = 3016003, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_10, team_id = 3010023, type = 3}
, 
[3016101] = {icon = 7, id = 3016101, mon_name = 300734, tag_des = __rt_3, team_id = 3017101, type = 1}
, 
[3016102] = {icon = 7, id = 3016102, mon_name = 300734, tag_des = __rt_3, team_id = 3017102, type = 1}
, 
[3016201] = {icon = 8, id = 3016201, mon_name = 131255, tag_des = __rt_3, team_id = 3017201, type = 2}
, 
[3016202] = {icon = 8, id = 3016202, mon_name = 131255, tag_des = __rt_3, team_id = 3017202, type = 2}
, 
[3016206] = {dorp_icon = __rt_5, icon = 9, id = 3016206, mon_name = 452134, tag_des = __rt_3, team_id = 3016206, type = 3}
, 
[3017001] = {dorp_icon = __rt_6, id = 3017001, special_effect = "40001", team_id = 3016104}
, 
[3017002] = {dorp_icon = __rt_6, id = 3017002, special_effect = "40001", team_id = 3016105}
, 
[3017003] = {dorp_icon = __rt_6, id = 3017003, special_effect = "40001", team_id = 3016106}
, 
[3017012] = {icon = 8, id = 3017012, mon_name = 170192, tag_des = __rt_8, team_id = 3017012, type = 2}
, 
[3017021] = {icon = 7, id = 3017021, mon_name = 339671, tag_des = __rt_8, team_id = 3017021, type = 1}
, 
[3017033] = {dorp_icon = __rt_5, icon = 9, id = 3017033, mon_name = 491071, tag_des = __rt_8, team_id = 3017033, type = 3}
, 
[3017043] = {dorp_icon = __rt_5, icon = 9, id = 3017043, mon_name = 491071, tag_des = __rt_8, team_id = 3017043, type = 3}
, 
[3017052] = {icon = 8, id = 3017052, mon_name = 336951, tag_des = __rt_9, team_id = 3017052, type = 2}
, 
[3017061] = {icon = 7, id = 3017061, mon_name = 506430, tag_des = __rt_9, team_id = 3017061, type = 1}
, 
[3017073] = {dorp_icon = __rt_5, icon = 9, id = 3017073, mon_name = 133543, tag_des = __rt_9, team_id = 3017073, type = 3}
, 
[3017083] = {dorp_icon = __rt_5, icon = 9, id = 3017083, mon_name = 133543, tag_des = __rt_9, team_id = 3017083, type = 3}
, 
[3017084] = {icon = 8, id = 3017084, mon_name = 131255, tag_des = __rt_3, team_id = 3017084, type = 2}
, 
[3017085] = {dorp_icon = __rt_5, icon = 9, id = 3017085, mon_name = 452134, tag_des = __rt_3, team_id = 3017085, type = 3}
, 
[3017999] = {dorp_icon = __rt_6, id = 3017999, special_effect = "40001", team_id = 3017999}
, 
[3020101] = {icon = 7, id = 3020101, mon_name = 300734, tag_des = __rt_3, team_id = 3020101, type = 1}
, 
[3020102] = {icon = 8, id = 3020102, mon_name = 131255, tag_des = __rt_3, team_id = 3020102, type = 2}
, 
[3020104] = {dorp_icon = __rt_6, id = 3020104, special_effect = "40001", team_id = 3020104}
, 
[3020201] = {icon = 7, id = 3020201, mon_name = 300734, tag_des = __rt_3, team_id = 3020201, type = 1}
, 
[3020202] = {icon = 8, id = 3020202, mon_name = 336951, tag_des = __rt_9, team_id = 3020202, type = 2}
, 
[3020204] = {dorp_icon = __rt_6, id = 3020204, special_effect = "40001", team_id = 3020204}
, 
[3020301] = {icon = 7, id = 3020301, mon_name = 506430, tag_des = __rt_9, team_id = 3020301, type = 1}
, 
[3020302] = {icon = 8, id = 3020302, mon_name = 336951, tag_des = __rt_9, team_id = 3020302, type = 2}
, 
[3020303] = {icon = 8, id = 3020303, mon_name = 336951, tag_des = __rt_9, team_id = 3020303, type = 2}
, 
[3020304] = {dorp_icon = __rt_6, id = 3020304, special_effect = "40001", team_id = 3020304}
, 
[3020501] = {icon = 7, id = 3020501, mon_name = 506430, tag_des = __rt_9, team_id = 3020501, type = 1}
, 
[3020502] = {icon = 8, id = 3020502, mon_name = 336951, tag_des = __rt_9, team_id = 3020502, type = 2}
, 
[3020503] = {icon = 8, id = 3020503, mon_name = 336951, tag_des = __rt_9, team_id = 3020503, type = 2}
, 
[3020505] = {dorp_icon = __rt_6, id = 3020505, special_effect = "40001", team_id = 3020505}
, 
[3030101] = {icon = 7, id = 3030101, mon_name = 300734, tag_des = __rt_3, team_id = 3030101, type = 1}
, 
[3030102] = {icon = 7, id = 3030102, mon_name = 300734, tag_des = __rt_3, team_id = 3030102, type = 1}
, 
[3030103] = {icon = 8, id = 3030103, mon_name = 131255, tag_des = __rt_3, team_id = 3030103, type = 2}
, 
[3030104] = {icon = 8, id = 3030104, mon_name = 131255, tag_des = __rt_3, team_id = 3030104, type = 2}
, 
[3030105] = {dorp_icon = __rt_6, id = 3030105, special_effect = "40001", team_id = 3030105}
, 
[3030201] = {icon = 7, id = 3030201, mon_name = 300734, tag_des = __rt_3, team_id = 3030201, type = 1}
, 
[3030202] = {icon = 8, id = 3030202, mon_name = 131255, tag_des = __rt_3, team_id = 3030202, type = 2}
, 
[3030203] = {icon = 8, id = 3030203, mon_name = 131255, tag_des = __rt_3, team_id = 3030203, type = 2}
, 
[3030204] = {dorp_icon = __rt_6, id = 3030204, special_effect = "40001", team_id = 3030204}
, 
[3030301] = {icon = 7, id = 3030301, mon_name = 300734, tag_des = __rt_3, team_id = 3030301, type = 1}
, 
[3030302] = {icon = 7, id = 3030302, mon_name = 300734, tag_des = __rt_3, team_id = 3030302, type = 1}
, 
[3030303] = {icon = 8, id = 3030303, mon_name = 131255, tag_des = __rt_3, team_id = 3030303, type = 2}
, 
[3030304] = {icon = 8, id = 3030304, mon_name = 131255, tag_des = __rt_3, team_id = 3030304, type = 2}
, 
[3030305] = {dorp_icon = __rt_6, id = 3030305, special_effect = "40001", team_id = 3030305}
, 
[3040101] = {icon = 7, id = 3040101, mon_name = 300734, tag_des = __rt_3, team_id = 3040101, type = 1}
, 
[3040102] = {icon = 8, id = 3040102, mon_name = 131255, tag_des = __rt_3, team_id = 3040102, type = 2}
, 
[3040103] = {dorp_icon = __rt_6, id = 3040103, special_effect = "40001", team_id = 3040103}
, 
[3040201] = {icon = 7, id = 3040201, mon_name = 300734, tag_des = __rt_3, team_id = 3040201, type = 1}
, 
[3040202] = {icon = 8, id = 3040202, mon_name = 131255, tag_des = __rt_3, team_id = 3040202, type = 2}
, 
[3040203] = {dorp_icon = __rt_6, id = 3040203, special_effect = "40001", team_id = 3040201}
, 
[3040301] = {icon = 7, id = 3040301, mon_name = 300734, tag_des = __rt_3, team_id = 3040301, type = 1}
, 
[3040302] = {icon = 8, id = 3040302, mon_name = 131255, tag_des = __rt_3, team_id = 3040302, type = 2}
, 
[3040303] = {dorp_icon = __rt_6, id = 3040303, special_effect = "40001", team_id = 3040303}
, 
[3050101] = {icon = 7, id = 3050101, mon_name = 506430, tag_des = __rt_12, team_id = 3050101, type = 1}
, 
[3050102] = {icon = 8, id = 3050102, mon_name = 336951, tag_des = __rt_12, team_id = 3050102, type = 2}
, 
[3050103] = {dorp_icon = __rt_5, icon = 9, id = 3050103, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3050103, type = 3}
, 
[3050104] = {dorp_icon = __rt_6, id = 3050104, special_effect = "40001", team_id = 3050104}
, 
[3060101] = {icon = 7, id = 3060101, mon_name = 506430, tag_des = __rt_13, team_id = 3060101, type = 1}
, 
[3060102] = {icon = 8, id = 3060102, mon_name = 336951, tag_des = __rt_13, team_id = 3060102, type = 2}
, 
[3060103] = {dorp_icon = __rt_5, icon = 9, id = 3060103, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_13, team_id = 3060103, type = 3}
, 
[3060104] = {dorp_icon = __rt_6, id = 3060104, special_effect = "40001", team_id = 3060104}
, 
[3060105] = {dorp_icon = __rt_2, icon = 9, id = 3060105, mon_name = 133543, tag_des = __rt_13, team_id = 3120515, type = 3}
, 
[3060106] = {icon = 7, id = 3060106, mon_name = 506430, tag_des = __rt_13, team_id = 3060101, type = 1}
, 
[3060107] = {icon = 8, id = 3060107, mon_name = 336951, tag_des = __rt_13, team_id = 3060102, type = 2}
, 
[3060108] = {dorp_icon = __rt_5, icon = 9, id = 3060108, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_13, team_id = 3060103, type = 3}
, 
[3060109] = {dorp_icon = __rt_6, id = 3060109, special_effect = "40001", team_id = 3060104}
, 
[3060110] = {dorp_icon = __rt_2, icon = 9, id = 3060110, mon_name = 133543, tag_des = __rt_13, team_id = 3120515, type = 3}
, 
[3061201] = {icon = 7, id = 3061201, mon_name = 506430, tag_des = __rt_9, team_id = 3061201, type = 1}
, 
[3061202] = {icon = 8, id = 3061202, mon_name = 336951, tag_des = __rt_9, team_id = 3061202, type = 2}
, 
[3061203] = {dorp_icon = __rt_5, icon = 9, id = 3061203, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_9, team_id = 3061203, type = 3}
, 
[3061204] = {dorp_icon = __rt_6, id = 3061204, special_effect = "40001", team_id = 3061204}
, 
[3061301] = {icon = 7, id = 3061301, mon_name = 506430, tag_des = __rt_9, team_id = 3061301, type = 1}
, 
[3061302] = {icon = 8, id = 3061302, mon_name = 336951, tag_des = __rt_9, team_id = 3061302, type = 2}
, 
[3061303] = {dorp_icon = __rt_5, icon = 9, id = 3061303, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_9, team_id = 3061303, type = 3}
, 
[3061304] = {dorp_icon = __rt_6, id = 3061304, special_effect = "40001", team_id = 3061304}
, 
[3061401] = {icon = 7, id = 3061401, mon_name = 506430, tag_des = __rt_9, team_id = 3061401, type = 1}
, 
[3061402] = {icon = 8, id = 3061402, mon_name = 336951, tag_des = __rt_9, team_id = 3061402, type = 2}
, 
[3061403] = {dorp_icon = __rt_5, icon = 9, id = 3061403, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_9, team_id = 3061403, type = 3}
, 
[3061404] = {dorp_icon = __rt_6, id = 3061404, special_effect = "40001", team_id = 3061404}
, 
[3062101] = {icon = 7, id = 3062101, mon_name = 506430, tag_des = __rt_14, team_id = 3062101, type = 1}
, 
[3062102] = {icon = 8, id = 3062102, mon_name = 336951, tag_des = __rt_14, team_id = 3062102, type = 2}
, 
[3062103] = {dorp_icon = __rt_5, icon = 9, id = 3062103, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3062103, type = 3}
, 
[3062104] = {dorp_icon = __rt_6, id = 3062104, special_effect = "40001", team_id = 3062104}
, 
[3110011] = {icon = 7, id = 3110011, mon_name = 339671, tag_des = __rt_15, team_id = 3110011, type = 1}
, 
[3110012] = {icon = 8, id = 3110012, mon_name = 170192, tag_des = __rt_15, team_id = 3110012, type = 2}
, 
[3110013] = {dorp_icon = __rt_5, icon = 9, id = 3110013, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110013, type = 3}
, 
[3110014] = {dorp_icon = __rt_6, id = 3110014, special_effect = "40001", team_id = 3110014}
, 
[3110021] = {icon = 7, id = 3110021, mon_name = 339671, tag_des = __rt_15, team_id = 3110021, type = 1}
, 
[3110022] = {icon = 8, id = 3110022, mon_name = 170192, tag_des = __rt_15, team_id = 3110022, type = 2}
, 
[3110023] = {dorp_icon = __rt_5, icon = 9, id = 3110023, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110023, type = 3}
, 
[3110024] = {dorp_icon = __rt_6, id = 3110024, special_effect = "40001", team_id = 3110024}
, 
[3110031] = {icon = 7, id = 3110031, mon_name = 339671, tag_des = __rt_15, team_id = 3110031, type = 1}
, 
[3110032] = {icon = 8, id = 3110032, mon_name = 170192, tag_des = __rt_15, team_id = 3110032, type = 2}
, 
[3110033] = {dorp_icon = __rt_5, icon = 9, id = 3110033, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110033, type = 3}
, 
[3110034] = {dorp_icon = __rt_6, id = 3110034, special_effect = "40001", team_id = 3110034}
, 
[3110041] = {icon = 7, id = 3110041, mon_name = 339671, tag_des = __rt_15, team_id = 3110041, type = 1}
, 
[3110042] = {icon = 8, id = 3110042, mon_name = 170192, tag_des = __rt_15, team_id = 3110042, type = 2}
, 
[3110043] = {dorp_icon = __rt_5, icon = 9, id = 3110043, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110043, type = 3}
, 
[3110044] = {dorp_icon = __rt_6, id = 3110044, special_effect = "40001", team_id = 3110044}
, 
[3110051] = {icon = 7, id = 3110051, mon_name = 506430, tag_des = __rt_15, team_id = 3110051, type = 1}
, 
[3110052] = {icon = 8, id = 3110052, mon_name = 336951, tag_des = __rt_15, team_id = 3110052, type = 2}
, 
[3110053] = {dorp_icon = __rt_5, icon = 9, id = 3110053, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110053, type = 3}
, 
[3110054] = {dorp_icon = __rt_6, id = 3110054, special_effect = "40001", team_id = 3110054}
, 
[3110061] = {icon = 7, id = 3110061, mon_name = 506430, tag_des = __rt_15, team_id = 3110061, type = 1}
, 
[3110062] = {icon = 8, id = 3110062, mon_name = 336951, tag_des = __rt_15, team_id = 3110062, type = 2}
, 
[3110063] = {dorp_icon = __rt_5, icon = 9, id = 3110063, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110063, type = 3}
, 
[3110064] = {dorp_icon = __rt_6, id = 3110064, special_effect = "40001", team_id = 3110064}
, 
[3110071] = {icon = 7, id = 3110071, mon_name = 506430, tag_des = __rt_15, team_id = 3110071, type = 1}
, 
[3110072] = {icon = 8, id = 3110072, mon_name = 336951, tag_des = __rt_15, team_id = 3110072, type = 2}
, 
[3110073] = {dorp_icon = __rt_5, icon = 9, id = 3110073, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110073, type = 3}
, 
[3110074] = {dorp_icon = __rt_6, id = 3110074, special_effect = "40001", team_id = 3110074}
, 
[3110081] = {icon = 7, id = 3110081, mon_name = 506430, tag_des = __rt_15, team_id = 3110081, type = 1}
, 
[3110082] = {icon = 8, id = 3110082, mon_name = 336951, tag_des = __rt_15, team_id = 3110082, type = 2}
, 
[3110083] = {dorp_icon = __rt_5, icon = 9, id = 3110083, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110083, type = 3}
, 
[3110084] = {dorp_icon = __rt_6, id = 3110084, special_effect = "40001", team_id = 3110084}
, 
[3110091] = {icon = 7, id = 3110091, mon_name = 300734, tag_des = __rt_15, team_id = 3110091, type = 1}
, 
[3110092] = {icon = 8, id = 3110092, mon_name = 131255, tag_des = __rt_15, team_id = 3110092, type = 2}
, 
[3110093] = {dorp_icon = __rt_5, icon = 9, id = 3110093, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110093, type = 3}
, 
[3110094] = {dorp_icon = __rt_6, id = 3110094, special_effect = "40001", team_id = 3110094}
, 
[3110101] = {icon = 7, id = 3110101, mon_name = 300734, tag_des = __rt_15, team_id = 3110101, type = 1}
, 
[3110102] = {icon = 8, id = 3110102, mon_name = 131255, tag_des = __rt_15, team_id = 3110102, type = 2}
, 
[3110103] = {dorp_icon = __rt_5, icon = 9, id = 3110103, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110103, type = 3}
, 
[3110104] = {dorp_icon = __rt_6, id = 3110104, special_effect = "40001", team_id = 3110104}
, 
[3110116] = {icon = 7, id = 3110116, mon_name = 300734, tag_des = __rt_15, team_id = 3110116, type = 1}
, 
[3110117] = {icon = 8, id = 3110117, mon_name = 131255, tag_des = __rt_15, team_id = 3110117, type = 2}
, 
[3110118] = {dorp_icon = __rt_5, icon = 9, id = 3110118, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110118, type = 3}
, 
[3110119] = {dorp_icon = __rt_6, id = 3110119, special_effect = "40001", team_id = 3110119}
, 
[3110126] = {icon = 7, id = 3110126, mon_name = 300734, tag_des = __rt_15, team_id = 3110126, type = 1}
, 
[3110127] = {icon = 8, id = 3110127, mon_name = 131255, tag_des = __rt_15, team_id = 3110127, type = 2}
, 
[3110128] = {dorp_icon = __rt_5, icon = 9, id = 3110128, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_15, team_id = 3110128, type = 3}
, 
[3110129] = {dorp_icon = __rt_6, id = 3110129, special_effect = "40001", team_id = 3110129}
, 
[3110131] = {icon = 7, id = 3110131, mon_name = 300734, tag_des = __rt_16, team_id = 3110131, type = 1}
, 
[3110132] = {icon = 8, id = 3110132, mon_name = 131255, tag_des = __rt_16, team_id = 3110132, type = 2}
, 
[3110133] = {dorp_icon = __rt_5, icon = 9, id = 3110133, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110133, type = 3}
, 
[3110134] = {dorp_icon = __rt_6, id = 3110134, special_effect = "40001", team_id = 3110134}
, 
[3110141] = {icon = 7, id = 3110141, mon_name = 300734, tag_des = __rt_16, team_id = 3110141, type = 1}
, 
[3110142] = {icon = 8, id = 3110142, mon_name = 131255, tag_des = __rt_16, team_id = 3110142, type = 2}
, 
[3110143] = {dorp_icon = __rt_5, icon = 9, id = 3110143, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110143, type = 3}
, 
[3110144] = {dorp_icon = __rt_6, id = 3110144, special_effect = "40001", team_id = 3110144}
, 
[3110151] = {icon = 7, id = 3110151, mon_name = 506430, tag_des = __rt_16, team_id = 3110151, type = 1}
, 
[3110152] = {icon = 8, id = 3110152, mon_name = 336951, tag_des = __rt_16, team_id = 3110152, type = 2}
, 
[3110153] = {dorp_icon = __rt_5, icon = 9, id = 3110153, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110153, type = 3}
, 
[3110154] = {dorp_icon = __rt_6, id = 3110154, special_effect = "40001", team_id = 3110154}
, 
[3110161] = {icon = 7, id = 3110161, mon_name = 300734, tag_des = __rt_16, team_id = 3110161, type = 1}
, 
[3110162] = {icon = 8, id = 3110162, mon_name = 131255, tag_des = __rt_16, team_id = 3110162, type = 2}
, 
[3110163] = {dorp_icon = __rt_5, icon = 9, id = 3110163, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110163, type = 3}
, 
[3110164] = {dorp_icon = __rt_6, id = 3110164, special_effect = "40001", team_id = 3110164}
, 
[3110171] = {icon = 7, id = 3110171, mon_name = 339671, tag_des = __rt_16, team_id = 3110171, type = 1}
, 
[3110172] = {icon = 8, id = 3110172, mon_name = 170192, tag_des = __rt_16, team_id = 3110172, type = 2}
, 
[3110173] = {dorp_icon = __rt_5, icon = 9, id = 3110173, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110173, type = 3}
, 
[3110174] = {dorp_icon = __rt_6, id = 3110174, special_effect = "40001", team_id = 3110174}
, 
[3110181] = {icon = 7, id = 3110181, mon_name = 506430, tag_des = __rt_16, team_id = 3110181, type = 1}
, 
[3110182] = {icon = 8, id = 3110182, mon_name = 336951, tag_des = __rt_16, team_id = 3110182, type = 2}
, 
[3110183] = {dorp_icon = __rt_5, icon = 9, id = 3110183, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110183, type = 3}
, 
[3110184] = {dorp_icon = __rt_6, id = 3110184, special_effect = "40001", team_id = 3110184}
, 
[3110191] = {icon = 7, id = 3110191, mon_name = 300734, tag_des = __rt_16, team_id = 3110191, type = 1}
, 
[3110192] = {icon = 8, id = 3110192, mon_name = 131255, tag_des = __rt_16, team_id = 3110192, type = 2}
, 
[3110193] = {dorp_icon = __rt_5, icon = 9, id = 3110193, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110193, type = 3}
, 
[3110194] = {dorp_icon = __rt_6, id = 3110194, special_effect = "40001", team_id = 3110194}
, 
[3110201] = {icon = 7, id = 3110201, mon_name = 300734, tag_des = __rt_16, team_id = 3110201, type = 1}
, 
[3110202] = {icon = 8, id = 3110202, mon_name = 131255, tag_des = __rt_16, team_id = 3110202, type = 2}
, 
[3110203] = {dorp_icon = __rt_5, icon = 9, id = 3110203, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110203, type = 3}
, 
[3110204] = {dorp_icon = __rt_6, id = 3110204, special_effect = "40001", team_id = 3110204}
, 
[3116106] = {dorp_icon = __rt_6, id = 3116106, special_effect = "40001", team_id = 3116106}
, 
[3117086] = {dorp_icon = __rt_2, icon = 7, id = 3117086, mon_name = 300734, tag_des = __rt_3, team_id = 3117086, type = 1}
, 
[3120501] = {dorp_icon = __rt_2, icon = 9, id = 3120501, mon_name = 452134, tag_des = __rt_3, team_id = 3120501, type = 3}
, 
[3120502] = {dorp_icon = __rt_2, icon = 9, id = 3120502, mon_name = 452134, tag_des = __rt_3, team_id = 3120502, type = 3}
, 
[3120503] = {dorp_icon = __rt_2, icon = 9, id = 3120503, mon_name = 452134, tag_des = __rt_3, team_id = 3120503, type = 3}
, 
[3120504] = {dorp_icon = __rt_2, icon = 9, id = 3120504, mon_name = 452134, tag_des = __rt_3, team_id = 3120504, type = 3}
, 
[3120505] = {dorp_icon = __rt_6, id = 3120505, special_effect = "40001", team_id = 3120505}
, 
[3120506] = {dorp_icon = __rt_2, icon = 9, id = 3120506, mon_name = 452134, tag_des = __rt_3, team_id = 3120506, type = 3}
, 
[3120507] = {dorp_icon = __rt_2, icon = 8, id = 3120507, mon_name = 170192, tag_des = __rt_8, team_id = 3110012, type = 2}
, 
[3120508] = {dorp_icon = __rt_2, icon = 8, id = 3120508, mon_name = 170192, tag_des = __rt_8, team_id = 3110022, type = 2}
, 
[3120509] = {dorp_icon = __rt_2, icon = 8, id = 3120509, mon_name = 336951, tag_des = __rt_9, team_id = 3110062, type = 2}
, 
[3120510] = {dorp_icon = __rt_2, icon = 8, id = 3120510, mon_name = 336951, tag_des = __rt_9, team_id = 3110072, type = 2}
, 
[3120511] = {dorp_icon = __rt_6, id = 3120511, special_effect = "40001", team_id = 3120511}
, 
[3120512] = {dorp_icon = __rt_6, id = 3120512, special_effect = "40001", team_id = 3120512}
, 
[3120513] = {dorp_icon = __rt_6, id = 3120513, special_effect = "40001", team_id = 3120513}
, 
[3120514] = {dorp_icon = __rt_6, id = 3120514, special_effect = "40001", team_id = 3120514}
, 
[3120515] = {dorp_icon = __rt_6, id = 3120515, special_effect = "40001", team_id = 3120515}
, 
[3130001] = {icon = 7, id = 3130001, mon_name = 506430, tag_des = __rt_17, team_id = 3130001, type = 1}
, 
[3130002] = {icon = 7, id = 3130002, mon_name = 506430, tag_des = __rt_17, team_id = 3130002, type = 1}
, 
[3130003] = {icon = 7, id = 3130003, mon_name = 506430, tag_des = __rt_17, team_id = 3130003, type = 1}
, 
[3130004] = {icon = 7, id = 3130004, mon_name = 506430, tag_des = __rt_17, team_id = 3130004, type = 1}
, 
[3130005] = {icon = 7, id = 3130005, mon_name = 506430, tag_des = __rt_17, team_id = 3130005, type = 1}
, 
[3130006] = {icon = 7, id = 3130006, mon_name = 506430, tag_des = __rt_17, team_id = 3130006, type = 1}
, 
[3130007] = {icon = 7, id = 3130007, mon_name = 506430, tag_des = __rt_17, team_id = 3130007, type = 1}
, 
[3130008] = {icon = 7, id = 3130008, mon_name = 506430, tag_des = __rt_17, team_id = 3130008, type = 1}
, 
[3130009] = {icon = 7, id = 3130009, mon_name = 506430, tag_des = __rt_17, team_id = 3130009, type = 1}
, 
[3130010] = {icon = 7, id = 3130010, mon_name = 506430, tag_des = __rt_17, team_id = 3130010, type = 1}
, 
[3130021] = {icon = 8, id = 3130021, mon_name = 336951, tag_des = __rt_17, team_id = 3130021, type = 2}
, 
[3130022] = {icon = 8, id = 3130022, mon_name = 336951, tag_des = __rt_17, team_id = 3130022, type = 2}
, 
[3130023] = {icon = 8, id = 3130023, mon_name = 336951, tag_des = __rt_17, team_id = 3130023, type = 2}
, 
[3130024] = {icon = 8, id = 3130024, mon_name = 336951, tag_des = __rt_17, team_id = 3130024, type = 2}
, 
[3130025] = {icon = 8, id = 3130025, mon_name = 336951, tag_des = __rt_17, team_id = 3130025, type = 2}
, 
[3130026] = {icon = 8, id = 3130026, mon_name = 336951, tag_des = __rt_17, team_id = 3130026, type = 2}
, 
[3130027] = {icon = 8, id = 3130027, mon_name = 336951, tag_des = __rt_17, team_id = 3130027, type = 2}
, 
[3130028] = {icon = 8, id = 3130028, mon_name = 336951, tag_des = __rt_17, team_id = 3130028, type = 2}
, 
[3130029] = {icon = 8, id = 3130029, mon_name = 336951, tag_des = __rt_17, team_id = 3130029, type = 2}
, 
[3130030] = {icon = 8, id = 3130030, mon_name = 336951, tag_des = __rt_17, team_id = 3130030, type = 2}
, 
[3130041] = {dorp_icon = __rt_5, icon = 9, id = 3130041, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130041, type = 3}
, 
[3130042] = {dorp_icon = __rt_5, icon = 9, id = 3130042, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130042, type = 3}
, 
[3130043] = {dorp_icon = __rt_5, icon = 9, id = 3130043, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130043, type = 3}
, 
[3130044] = {dorp_icon = __rt_5, icon = 9, id = 3130044, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130044, type = 3}
, 
[3130045] = {dorp_icon = __rt_5, icon = 9, id = 3130045, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130045, type = 3}
, 
[3130046] = {dorp_icon = __rt_5, icon = 9, id = 3130046, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130046, type = 3}
, 
[3130047] = {dorp_icon = __rt_5, icon = 9, id = 3130047, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130047, type = 3}
, 
[3130048] = {dorp_icon = __rt_5, icon = 9, id = 3130048, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130048, type = 3}
, 
[3130049] = {dorp_icon = __rt_5, icon = 9, id = 3130049, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130049, type = 3}
, 
[3130050] = {dorp_icon = __rt_5, icon = 9, id = 3130050, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130050, type = 3}
, 
[3130051] = {icon = 7, id = 3130051, mon_name = 300734, tag_des = __rt_16, team_id = 3110131, type = 1}
, 
[3130052] = {icon = 8, id = 3130052, mon_name = 131255, tag_des = __rt_16, team_id = 3110132, type = 2}
, 
[3130053] = {dorp_icon = __rt_5, icon = 9, id = 3130053, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110133, type = 3}
, 
[3130054] = {dorp_icon = __rt_6, id = 3130054, special_effect = "40001", team_id = 3110134}
, 
[3130055] = {icon = 7, id = 3130055, mon_name = 300734, tag_des = __rt_16, team_id = 3110141, type = 1}
, 
[3130056] = {icon = 8, id = 3130056, mon_name = 131255, tag_des = __rt_16, team_id = 3110142, type = 2}
, 
[3130057] = {dorp_icon = __rt_5, icon = 9, id = 3130057, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110143, type = 3}
, 
[3130058] = {dorp_icon = __rt_6, id = 3130058, special_effect = "40001", team_id = 3110144}
, 
[3130059] = {icon = 7, id = 3130059, mon_name = 506430, tag_des = __rt_16, team_id = 3110151, type = 1}
, 
[3130060] = {icon = 8, id = 3130060, mon_name = 336951, tag_des = __rt_16, team_id = 3110152, type = 2}
, 
[3130061] = {dorp_icon = __rt_5, icon = 9, id = 3130061, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110153, type = 3}
, 
[3130062] = {dorp_icon = __rt_6, id = 3130062, special_effect = "40001", team_id = 3110154}
, 
[3130063] = {icon = 7, id = 3130063, mon_name = 300734, tag_des = __rt_16, team_id = 3110161, type = 1}
, 
[3130064] = {icon = 8, id = 3130064, mon_name = 131255, tag_des = __rt_16, team_id = 3110162, type = 2}
, 
[3130065] = {dorp_icon = __rt_5, icon = 9, id = 3130065, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110163, type = 3}
, 
[3130066] = {dorp_icon = __rt_6, id = 3130066, special_effect = "40001", team_id = 3110164}
, 
[3130067] = {icon = 7, id = 3130067, mon_name = 339671, tag_des = __rt_16, team_id = 3110171, type = 1}
, 
[3130068] = {icon = 8, id = 3130068, mon_name = 170192, tag_des = __rt_16, team_id = 3110172, type = 2}
, 
[3130069] = {dorp_icon = __rt_5, icon = 9, id = 3130069, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110173, type = 3}
, 
[3130070] = {dorp_icon = __rt_6, id = 3130070, special_effect = "40001", team_id = 3110174}
, 
[3130071] = {icon = 7, id = 3130071, mon_name = 506430, tag_des = __rt_16, team_id = 3110181, type = 1}
, 
[3130072] = {icon = 8, id = 3130072, mon_name = 336951, tag_des = __rt_16, team_id = 3110182, type = 2}
, 
[3130073] = {dorp_icon = __rt_5, icon = 9, id = 3130073, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110183, type = 3}
, 
[3130074] = {dorp_icon = __rt_6, id = 3130074, special_effect = "40001", team_id = 3110184}
, 
[3130075] = {icon = 7, id = 3130075, mon_name = 300734, tag_des = __rt_16, team_id = 3110191, type = 1}
, 
[3130076] = {icon = 8, id = 3130076, mon_name = 131255, tag_des = __rt_16, team_id = 3110192, type = 2}
, 
[3130077] = {dorp_icon = __rt_5, icon = 9, id = 3130077, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110193, type = 3}
, 
[3130078] = {dorp_icon = __rt_6, id = 3130078, special_effect = "40001", team_id = 3110194}
, 
[3130079] = {icon = 7, id = 3130079, mon_name = 300734, tag_des = __rt_16, team_id = 3110201, type = 1}
, 
[3130080] = {icon = 8, id = 3130080, mon_name = 131255, tag_des = __rt_16, team_id = 3110202, type = 2}
, 
[3130081] = {dorp_icon = __rt_5, icon = 9, id = 3130081, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110203, type = 3}
, 
[3130082] = {dorp_icon = __rt_6, id = 3130082, special_effect = "40001", team_id = 3110204}
, 
[3130083] = {dorp_icon = __rt_6, id = 3130083, special_effect = "40001", team_id = 3120505}
, 
[3130084] = {dorp_icon = __rt_6, id = 3130084, special_effect = "40001", team_id = 3120512}
, 
[3130085] = {dorp_icon = __rt_6, id = 3130085, special_effect = "40001", team_id = 3116106}
, 
[3130086] = {dorp_icon = __rt_6, id = 3130086, special_effect = "40001", team_id = 3120511}
, 
[3130087] = {dorp_icon = __rt_6, id = 3130087, special_effect = "40001", team_id = 3120513}
, 
[3130088] = {dorp_icon = __rt_6, id = 3130088, special_effect = "40001", team_id = 3120514}
, 
[3130089] = {dorp_icon = __rt_6, id = 3130089, special_effect = "40001", team_id = 3120515}
, 
[3130100] = {icon = 7, id = 3130100, mon_name = 506430, tag_des = __rt_12, team_id = 3130100, type = 1}
, 
[3130101] = {icon = 7, id = 3130101, mon_name = 506430, tag_des = __rt_12, team_id = 3130101, type = 1}
, 
[3130102] = {icon = 7, id = 3130102, mon_name = 506430, tag_des = __rt_12, team_id = 3130102, type = 1}
, 
[3130103] = {icon = 7, id = 3130103, mon_name = 506430, tag_des = __rt_12, team_id = 3130103, type = 1}
, 
[3130104] = {icon = 7, id = 3130104, mon_name = 506430, tag_des = __rt_12, team_id = 3130104, type = 1}
, 
[3130105] = {icon = 7, id = 3130105, mon_name = 506430, tag_des = __rt_12, team_id = 3130105, type = 1}
, 
[3130106] = {icon = 7, id = 3130106, mon_name = 506430, tag_des = __rt_12, team_id = 3130106, type = 1}
, 
[3130107] = {icon = 7, id = 3130107, mon_name = 506430, tag_des = __rt_12, team_id = 3130107, type = 1}
, 
[3130108] = {icon = 7, id = 3130108, mon_name = 506430, tag_des = __rt_12, team_id = 3130108, type = 1}
, 
[3130109] = {icon = 7, id = 3130109, mon_name = 506430, tag_des = __rt_12, team_id = 3130109, type = 1}
, 
[3130120] = {icon = 8, id = 3130120, mon_name = 336951, tag_des = __rt_12, team_id = 3130120, type = 2}
, 
[3130121] = {icon = 8, id = 3130121, mon_name = 336951, tag_des = __rt_12, team_id = 3130121, type = 2}
, 
[3130122] = {icon = 8, id = 3130122, mon_name = 336951, tag_des = __rt_12, team_id = 3130122, type = 2}
, 
[3130123] = {icon = 8, id = 3130123, mon_name = 336951, tag_des = __rt_12, team_id = 3130123, type = 2}
, 
[3130124] = {icon = 8, id = 3130124, mon_name = 336951, tag_des = __rt_12, team_id = 3130124, type = 2}
, 
[3130125] = {icon = 8, id = 3130125, mon_name = 336951, tag_des = __rt_12, team_id = 3130125, type = 2}
, 
[3130126] = {icon = 8, id = 3130126, mon_name = 336951, tag_des = __rt_12, team_id = 3130126, type = 2}
, 
[3130127] = {icon = 8, id = 3130127, mon_name = 336951, tag_des = __rt_12, team_id = 3130127, type = 2}
, 
[3130128] = {icon = 8, id = 3130128, mon_name = 336951, tag_des = __rt_12, team_id = 3130128, type = 2}
, 
[3130129] = {icon = 8, id = 3130129, mon_name = 336951, tag_des = __rt_12, team_id = 3130129, type = 2}
, 
[3130140] = {dorp_icon = __rt_5, icon = 9, id = 3130140, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130140, type = 3}
, 
[3130141] = {dorp_icon = __rt_5, icon = 9, id = 3130141, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130141, type = 3}
, 
[3130142] = {dorp_icon = __rt_5, icon = 9, id = 3130142, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130142, type = 3}
, 
[3130143] = {dorp_icon = __rt_5, icon = 9, id = 3130143, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130143, type = 3}
, 
[3130144] = {dorp_icon = __rt_5, icon = 9, id = 3130144, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130144, type = 3}
, 
[3130145] = {dorp_icon = __rt_5, icon = 9, id = 3130145, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130145, type = 3}
, 
[3130146] = {dorp_icon = __rt_5, icon = 9, id = 3130146, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130146, type = 3}
, 
[3130147] = {dorp_icon = __rt_5, icon = 9, id = 3130147, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130147, type = 3}
, 
[3130148] = {dorp_icon = __rt_5, icon = 9, id = 3130148, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130148, type = 3}
, 
[3130149] = {dorp_icon = __rt_5, icon = 9, id = 3130149, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_12, team_id = 3130149, type = 3}
, 
[3130150] = {icon = 7, id = 3130150, mon_name = 300734, tag_des = __rt_16, team_id = 3110131, type = 1}
, 
[3130151] = {icon = 8, id = 3130151, mon_name = 131255, tag_des = __rt_16, team_id = 3110132, type = 2}
, 
[3130152] = {dorp_icon = __rt_5, icon = 9, id = 3130152, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110133, type = 3}
, 
[3130153] = {dorp_icon = __rt_6, id = 3130153, special_effect = "40001", team_id = 3110134}
, 
[3130154] = {icon = 7, id = 3130154, mon_name = 300734, tag_des = __rt_16, team_id = 3110141, type = 1}
, 
[3130155] = {icon = 8, id = 3130155, mon_name = 131255, tag_des = __rt_16, team_id = 3110142, type = 2}
, 
[3130156] = {dorp_icon = __rt_5, icon = 9, id = 3130156, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110143, type = 3}
, 
[3130157] = {dorp_icon = __rt_6, id = 3130157, special_effect = "40001", team_id = 3110144}
, 
[3130158] = {icon = 7, id = 3130158, mon_name = 506430, tag_des = __rt_16, team_id = 3110151, type = 1}
, 
[3130159] = {icon = 8, id = 3130159, mon_name = 336951, tag_des = __rt_16, team_id = 3110152, type = 2}
, 
[3130160] = {dorp_icon = __rt_5, icon = 9, id = 3130160, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110153, type = 3}
, 
[3130161] = {dorp_icon = __rt_6, id = 3130161, special_effect = "40001", team_id = 3110154}
, 
[3130162] = {icon = 7, id = 3130162, mon_name = 300734, tag_des = __rt_16, team_id = 3110161, type = 1}
, 
[3130163] = {icon = 8, id = 3130163, mon_name = 131255, tag_des = __rt_16, team_id = 3110162, type = 2}
, 
[3130164] = {dorp_icon = __rt_5, icon = 9, id = 3130164, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110163, type = 3}
, 
[3130165] = {dorp_icon = __rt_6, id = 3130165, special_effect = "40001", team_id = 3110164}
, 
[3130166] = {icon = 7, id = 3130166, mon_name = 339671, tag_des = __rt_16, team_id = 3110171, type = 1}
, 
[3130167] = {icon = 8, id = 3130167, mon_name = 170192, tag_des = __rt_16, team_id = 3110172, type = 2}
, 
[3130168] = {dorp_icon = __rt_5, icon = 9, id = 3130168, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110173, type = 3}
, 
[3130169] = {dorp_icon = __rt_6, id = 3130169, special_effect = "40001", team_id = 3110174}
, 
[3130170] = {icon = 7, id = 3130170, mon_name = 506430, tag_des = __rt_16, team_id = 3110181, type = 1}
, 
[3130171] = {icon = 8, id = 3130171, mon_name = 336951, tag_des = __rt_16, team_id = 3110182, type = 2}
, 
[3130172] = {dorp_icon = __rt_5, icon = 9, id = 3130172, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110183, type = 3}
, 
[3130173] = {dorp_icon = __rt_6, id = 3130173, special_effect = "40001", team_id = 3110184}
, 
[3130174] = {icon = 7, id = 3130174, mon_name = 300734, tag_des = __rt_16, team_id = 3110191, type = 1}
, 
[3130175] = {icon = 8, id = 3130175, mon_name = 131255, tag_des = __rt_16, team_id = 3110192, type = 2}
, 
[3130176] = {dorp_icon = __rt_5, icon = 9, id = 3130176, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110193, type = 3}
, 
[3130177] = {dorp_icon = __rt_6, id = 3130177, special_effect = "40001", team_id = 3110194}
, 
[3130178] = {icon = 7, id = 3130178, mon_name = 300734, tag_des = __rt_16, team_id = 3110201, type = 1}
, 
[3130179] = {icon = 8, id = 3130179, mon_name = 131255, tag_des = __rt_16, team_id = 3110202, type = 2}
, 
[3130180] = {dorp_icon = __rt_5, icon = 9, id = 3130180, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110203, type = 3}
, 
[3130181] = {dorp_icon = __rt_6, id = 3130181, special_effect = "40001", team_id = 3110204}
, 
[3130182] = {dorp_icon = __rt_6, id = 3130182, special_effect = "40001", team_id = 3120505}
, 
[3130183] = {dorp_icon = __rt_6, id = 3130183, special_effect = "40001", team_id = 3120512}
, 
[3130184] = {dorp_icon = __rt_6, id = 3130184, special_effect = "40001", team_id = 3116106}
, 
[3130185] = {dorp_icon = __rt_6, id = 3130185, special_effect = "40001", team_id = 3120511}
, 
[3130186] = {dorp_icon = __rt_6, id = 3130186, special_effect = "40001", team_id = 3120513}
, 
[3130187] = {dorp_icon = __rt_6, id = 3130187, special_effect = "40001", team_id = 3120514}
, 
[3130188] = {dorp_icon = __rt_6, id = 3130188, special_effect = "40001", team_id = 3120515}
, 
[3140001] = {icon = 7, id = 3140001, mon_name = 506430, tag_des = __rt_14, type = 1}
, 
[3140002] = {icon = 8, id = 3140002, mon_name = 336951, tag_des = __rt_14, team_id = 3140002, type = 2}
, 
[3140003] = {dorp_icon = __rt_5, icon = 9, id = 3140003, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140003, type = 3}
, 
[3140004] = {icon = 7, id = 3140004, mon_name = 506430, tag_des = __rt_14, team_id = 3140004, type = 1}
, 
[3140005] = {icon = 8, id = 3140005, mon_name = 336951, tag_des = __rt_14, team_id = 3140005, type = 2}
, 
[3140006] = {dorp_icon = __rt_5, icon = 9, id = 3140006, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140006, type = 3}
, 
[3140007] = {icon = 7, id = 3140007, mon_name = 506430, tag_des = __rt_14, team_id = 3140007, type = 1}
, 
[3140008] = {icon = 8, id = 3140008, mon_name = 336951, tag_des = __rt_14, team_id = 3140008, type = 2}
, 
[3140009] = {dorp_icon = __rt_5, icon = 9, id = 3140009, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140009, type = 3}
, 
[3140010] = {icon = 7, id = 3140010, mon_name = 506430, tag_des = __rt_14, team_id = 3140010, type = 1}
, 
[3140011] = {icon = 8, id = 3140011, mon_name = 336951, tag_des = __rt_14, team_id = 3140011, type = 2}
, 
[3140012] = {dorp_icon = __rt_5, icon = 9, id = 3140012, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140012, type = 3}
, 
[3140013] = {icon = 7, id = 3140013, mon_name = 506430, tag_des = __rt_14, team_id = 3140013, type = 1}
, 
[3140014] = {icon = 8, id = 3140014, mon_name = 336951, tag_des = __rt_14, team_id = 3140014, type = 2}
, 
[3140015] = {dorp_icon = __rt_5, icon = 9, id = 3140015, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140015, type = 3}
, 
[3140016] = {icon = 7, id = 3140016, mon_name = 506430, tag_des = __rt_14, team_id = 3140016, type = 1}
, 
[3140017] = {icon = 8, id = 3140017, mon_name = 336951, tag_des = __rt_14, team_id = 3140017, type = 2}
, 
[3140018] = {dorp_icon = __rt_5, icon = 9, id = 3140018, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140018, type = 3}
, 
[3140019] = {icon = 7, id = 3140019, mon_name = 506430, tag_des = __rt_14, team_id = 3140019, type = 1}
, 
[3140020] = {icon = 8, id = 3140020, mon_name = 336951, tag_des = __rt_14, team_id = 3140020, type = 2}
, 
[3140047] = {dorp_icon = __rt_6, id = 3140047, type = 3}
, 
[3140048] = {dorp_icon = __rt_6, id = 3140048, type = 3}
, 
[3140049] = {dorp_icon = __rt_6, id = 3140049, type = 3}
, 
[3140050] = {dorp_icon = __rt_6, id = 3140050, type = 3}
, 
[3140051] = {dorp_icon = __rt_6, id = 3140051, type = 3}
, 
[3140052] = {dorp_icon = __rt_6, id = 3140052, special_effect = "40006"}
, 
[3140053] = {dorp_icon = __rt_6, id = 3140053, special_effect = "40001", team_id = 3140999, type = 3}
, 
[3140054] = {dorp_icon = __rt_6, id = 3140054, special_effect = "40006"}
, 
[3140060] = {icon = 7, id = 3140060, mon_name = 506430, tag_des = __rt_8, team_id = 3140131, type = 1}
, 
[3140061] = {icon = 8, id = 3140061, mon_name = 336951, tag_des = __rt_8, team_id = 3140132, type = 2}
, 
[3140062] = {dorp_icon = __rt_5, icon = 9, id = 3140062, mon_name = 133543, outiline_hdr = 200, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_8, team_id = 3140133, type = 3}
, 
[3140063] = {icon = 9, id = 3140063, tag_des = __rt_8, team_id = 3140149}
, 
[3140101] = {icon = 7, id = 3140101, mon_name = 506430, tag_des = __rt_14, team_id = 3140101, type = 1}
, 
[3140102] = {icon = 8, id = 3140102, mon_name = 336951, tag_des = __rt_14, team_id = 3140102, type = 2}
, 
[3140103] = {dorp_icon = __rt_5, icon = 9, id = 3140103, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140103, type = 3}
, 
[3140104] = {icon = 7, id = 3140104, mon_name = 506430, tag_des = __rt_14, team_id = 3140104, type = 1}
, 
[3140105] = {icon = 8, id = 3140105, mon_name = 336951, tag_des = __rt_14, team_id = 3140105, type = 2}
, 
[3140106] = {dorp_icon = __rt_5, icon = 9, id = 3140106, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140106, type = 3}
, 
[3140107] = {icon = 7, id = 3140107, mon_name = 506430, tag_des = __rt_14, team_id = 3140107, type = 1}
, 
[3140108] = {icon = 8, id = 3140108, mon_name = 336951, tag_des = __rt_14, team_id = 3140108, type = 2}
, 
[3140109] = {dorp_icon = __rt_5, icon = 9, id = 3140109, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_14, team_id = 3140109, type = 3}
, 
[3140110] = {icon = 7, id = 3140110, mon_name = 506430, tag_des = __rt_13, team_id = 3140110, type = 1}
, 
[3140111] = {icon = 8, id = 3140111, mon_name = 336951, tag_des = __rt_13, team_id = 3140111, type = 2}
, 
[3140112] = {dorp_icon = __rt_5, icon = 9, id = 3140112, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_13, team_id = 3140112, type = 3}
, 
[3140113] = {icon = 7, id = 3140113, mon_name = 506430, tag_des = __rt_13, team_id = 3140113, type = 1}
, 
[3140114] = {icon = 8, id = 3140114, mon_name = 336951, tag_des = __rt_13, team_id = 3140114, type = 2}
, 
[3140115] = {dorp_icon = __rt_5, icon = 9, id = 3140115, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_13, team_id = 3140115, type = 3}
, 
[3140116] = {icon = 7, id = 3140116, mon_name = 506430, tag_des = __rt_13, team_id = 3140116, type = 1}
, 
[3140117] = {icon = 8, id = 3140117, mon_name = 336951, tag_des = __rt_13, team_id = 3140117, type = 2}
, 
[3140118] = {dorp_icon = __rt_5, icon = 9, id = 3140118, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_13, team_id = 3140118, type = 3}
, 
[3140119] = {icon = 7, id = 3140119, mon_name = 300734, tag_des = __rt_16, team_id = 3140119, type = 1}
, 
[3140120] = {icon = 8, id = 3140120, mon_name = 131255, tag_des = __rt_16, team_id = 3140120, type = 2}
, 
[3140121] = {dorp_icon = __rt_5, icon = 9, id = 3140121, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3140121, type = 3}
, 
[3140122] = {dorp_icon = __rt_6, id = 3140122, special_effect = "40001", team_id = 3140122}
, 
[3140123] = {icon = 7, id = 3140123, mon_name = 300734, tag_des = __rt_16, team_id = 3140123, type = 1}
, 
[3140124] = {icon = 8, id = 3140124, mon_name = 131255, tag_des = __rt_16, team_id = 3140124, type = 2}
, 
[3140125] = {dorp_icon = __rt_5, icon = 9, id = 3140125, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3140125, type = 3}
, 
[3140126] = {dorp_icon = __rt_6, id = 3140126, special_effect = "40001", team_id = 3140126}
, 
[3140127] = {icon = 7, id = 3140127, mon_name = 506430, tag_des = __rt_16, team_id = 3140127, type = 1}
, 
[3140128] = {icon = 8, id = 3140128, mon_name = 336951, tag_des = __rt_16, team_id = 3140128, type = 2}
, 
[3140129] = {dorp_icon = __rt_5, icon = 9, id = 3140129, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3140129, type = 3}
, 
[3140130] = {dorp_icon = __rt_6, id = 3140130, special_effect = "40001", team_id = 3140130}
, 
[3140131] = {icon = 7, id = 3140131, mon_name = 300734, tag_des = __rt_16, team_id = 3140131, type = 1}
, 
[3140132] = {icon = 8, id = 3140132, mon_name = 131255, tag_des = __rt_16, team_id = 3140132, type = 2}
, 
[3140133] = {dorp_icon = __rt_5, icon = 9, id = 3140133, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3140133, type = 3}
, 
[3140134] = {dorp_icon = __rt_6, id = 3140134, special_effect = "40001", team_id = 3140134}
, 
[3140135] = {icon = 7, id = 3140135, mon_name = 339671, tag_des = __rt_16, team_id = 3140135, type = 1}
, 
[3140136] = {icon = 8, id = 3140136, mon_name = 170192, tag_des = __rt_16, team_id = 3140136, type = 2}
, 
[3140137] = {dorp_icon = __rt_5, icon = 9, id = 3140137, mon_name = 491071, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3140137, type = 3}
, 
[3140138] = {dorp_icon = __rt_6, id = 3140138, special_effect = "40001", team_id = 3140138}
, 
[3140139] = {icon = 7, id = 3140139, mon_name = 506430, tag_des = __rt_16, team_id = 3140139, type = 1}
, 
[3140140] = {icon = 8, id = 3140140, mon_name = 336951, tag_des = __rt_16, team_id = 3140140, type = 2}
, 
[3140141] = {dorp_icon = __rt_5, icon = 9, id = 3140141, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3140141, type = 3}
, 
[3140142] = {dorp_icon = __rt_6, id = 3140142, special_effect = "40001", team_id = 3140142}
, 
[3140143] = {dorp_icon = __rt_6, id = 3140143, special_effect = "40001", team_id = 3140143}
, 
[3140144] = {dorp_icon = __rt_6, id = 3140144, special_effect = "40001", team_id = 3140144}
, 
[3140145] = {dorp_icon = __rt_6, id = 3140145, special_effect = "40001", team_id = 3140145}
, 
[3140146] = {dorp_icon = __rt_6, id = 3140146, special_effect = "40001", team_id = 3140146}
, 
[3140147] = {dorp_icon = __rt_6, id = 3140147, special_effect = "40001", team_id = 3140147}
, 
[3140148] = {dorp_icon = __rt_6, id = 3140148, special_effect = "40001", team_id = 3140148}
, 
[5000001] = {icon = 7, id = 5000001, mon_name = 506430, tag_des = __rt_17, team_id = 3130001, type = 1}
, 
[5000002] = {icon = 8, id = 5000002, mon_name = 336951, tag_des = __rt_17, team_id = 3130021, type = 2}
, 
[5000003] = {dorp_icon = __rt_5, icon = 9, id = 5000003, mon_name = 133543, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_17, team_id = 3130041, type = 3}
, 
[5000004] = {icon = 7, id = 5000004, mon_name = 300734, tag_des = __rt_16, team_id = 3110131, type = 1}
, 
[5000005] = {icon = 8, id = 5000005, mon_name = 131255, tag_des = __rt_16, team_id = 3110132, type = 2}
, 
[5000006] = {dorp_icon = __rt_5, icon = 9, id = 5000006, mon_name = 452134, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, special_effect = "40004", tag_des = __rt_16, team_id = 3110133, type = 3}
, 
[31400119] = {icon = 10, id = 31400119, mon_name = 272982, outiline_hdr = 200, outline_color = __rt_11, outline_enable = true, outline_scale = 5, outline_wider = 6, 
tag_des = {66324}
, team_id = 3140102, type = 2}
}
local __default_values = {dorp_icon = __rt_1, icon = 2, id = 3000001, mon_name = 183456, outiline_hdr = 0, outline_color = __rt_2, outline_enable = false, outline_scale = 0, outline_wider = 0, special_effect = "", tag_des = __rt_7, tag_type = __rt_4, team_id = 3140001, type = 4}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in (_ENV.pairs)(warchess_room_monster) do
  (_ENV.setmetatable)(v, base)
end
local __rawdata = {__basemetatable = base}
;
(_ENV.setmetatable)(warchess_room_monster, {__index = __rawdata})
return warchess_room_monster

