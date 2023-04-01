-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {1}
local __rt_2 = {2; [3] = 1}
local __rt_3 = {[3] = 1}
local __rt_4 = {[0] = 1}
local __rt_5 = {[2] = 1, [3] = 2}
local __rt_6 = {[2] = 1, [4] = 2, [5] = 3}
local __rt_7 = {11}
local __rt_8 = {}
local __rt_9 = {[2] = 1, [3] = 2, [5] = 3}
local __rt_10 = {104}
local __rt_11 = {105}
local __rt_12 = {1119}
local __rt_13 = {1120}
local battle_grid = {
{attr_formula = "tab[26]", 
auto_career = {[4] = 2, [5] = 1}
, creations = __rt_1, grid_skill = "gs_1", icon = "ICON_Grid001", info = 198556, name = 212779, necessary = "tab[1]/tab[2]>0.4"}
, 
{auto_career = __rt_2, 
creations = {2}
, grid_skill = "gs_2", icon = "ICON_Grid002", id = 2, info = 307859, name = 103404, necessary = "tab[1]/tab[2]>0.4"}
, 
{attr_formula = "tab[3]", auto_career = __rt_3, 
creations = {3}
, grid_skill = "gs_3", icon = "ICON_Grid003", id = 3, info = 70968, name = 105182, necessary = "tab[1]/tab[2]>0.4"}
, 
{attr_formula = "tab[3]", 
auto_career = {[2] = 2, [4] = 1}
, 
creations = {4}
, grid_skill = "gs_4", icon = "ICON_Grid004", id = 4, info = 277432, name = 50384}
, 
{attr_formula = "tab[3]", auto_career = __rt_4, 
creations = {5}
, grid_skill = "gs_5", icon = "ICON_Grid005", id = 5, info = 462890, name = 107985, necessary = "tab[1]/tab[2]>0.4"}
, 
{auto_career = __rt_2, 
creations = {6}
, grid_skill = "gs_6", icon = "ICON_Grid006", id = 6, info = 399526, name = 382658, necessary = "tab[1]/tab[2]>0.4"}
, 
{auto_career = __rt_2, 
creations = {7}
, grid_skill = "gs_7", icon = "ICON_Grid007", id = 7, info = 191403, name = 503705, necessary = "tab[1]/tab[2]>0.4"}
, 
{attr_formula = "tab[3]", 
auto_career = {[2] = 2, [3] = 1}
, 
creations = {8}
, grid_skill = "gs_8", icon = "ICON_Grid008", id = 8, info = 203681, name = 401630}
, 
{attr_formula = "tab[26]", auto_career = __rt_5, 
creations = {9}
, grid_skill = "gs_9", icon = "ICON_Grid009", id = 9, info = 260925, name = 369332}
, 
{attr_formula = "tab[26]", auto_career = __rt_6, 
creations = {10}
, grid_skill = "gs_10", icon = "ICON_Grid010", id = 10, info = 384540, name = 430291}
, 
{attr_formula = "tab[26]", auto_career = __rt_6, creations = __rt_7, grid_skill = "gs_11", icon = "ICON_Grid011", id = 11}
, 
{attr_formula = "tab[26]", auto_career = __rt_6, 
creations = {12}
, grid_skill = "gs_12", icon = "ICON_Grid012", id = 12, info = 199777, name = 253480, necessary = "tab[1]/tab[2]>0.6"}
, 
{auto_career = __rt_2, 
creations = {13}
, grid_skill = "gs_13", icon = "ICON_Grid013", id = 13, info = 297354, name = 317646, necessary = "tab[1]/tab[2]>0.5"}
, 
{
auto_career = {1; [3] = 2}
, 
creations = {14}
, grid_skill = "gs_14", icon = "ICON_Grid014", id = 14, info = 470224, name = 161689, necessary = "tab[1]/tab[2]>0.5"}
, 
{auto_career = __rt_8, auto_order = false, 
creations = {15}
, grid_skill = "gs_15", icon = "ICON_Grid015", id = 15, info = 179695, name = 326857, necessary = "0", type = 2, type_relative = true}
, 
{attr_formula = "tab[3]", auto_career = __rt_5, 
creations = {16}
, grid_skill = "gs_16", icon = "ICON_Grid016", id = 16, info = 481670, name = 371887}
, 
{auto_career = __rt_2, 
creations = {17}
, grid_skill = "gs_17", icon = "ICON_Grid017", id = 17, info = 200693, name = 463468, necessary = "tab[1]/tab[2]>0.5"}
, 
{auto_career = __rt_2, 
creations = {18}
, grid_skill = "gs_18", icon = "ICON_Grid018", id = 18, info = 516858, name = 60227, necessary = "tab[1]/tab[2]>0.5"}
, 
{attr_formula = "tab[3]", auto_career = __rt_5, 
creations = {19}
, grid_skill = "gs_19", icon = "ICON_Grid019", id = 19, info = 312347, name = 90407, necessary = "tab[1]/tab[2]>0.5"}
, 
{
creations = {20}
, grid_skill = "gs_20", icon = "ICON_Grid020", id = 20, info = 114414, name = 53605}
, 
{auto_career = __rt_9, 
creations = {21}
, grid_skill = "gs_21", icon = "ICON_Grid021", id = 21, info = 268812, name = 390409, necessary = "0"}
, 
{auto_career = __rt_9, 
creations = {22}
, grid_skill = "gs_22", icon = "ICON_Grid022", id = 22, info = 422922, name = 70210, necessary = "0", type = 2}
, 
{auto_career = __rt_9, 
creations = {23}
, grid_skill = "gs_23", icon = "ICON_Grid022", id = 23, info = 339675, name = 70210, necessary = "0", type = 2}
, 
{abandon_equipment = true, contain_obstacle = true, creations = __rt_8, grid_skill = "TowerDefence.gs_24", icon = "ICON_Grid024", id = 24, info = 180073, name = 443297}
, 
{contain_obstacle = true, 
creations = {25}
, grid_skill = "gs_25", icon = "ICON_Grid025", id = 25, info = 300361, name = 323905}
, 
{abandon_equipment = true, 
creations = {26}
, icon = "ICON_Grid024", id = 26, info = 310290, name = 200660}
, 
{contain_obstacle = true, 
creations = {27, 200}
, grid_skill = "gs_27", icon = "ICON_Grid010", id = 27, info = 231328, name = 72070}
, 
{abandon_equipment = true, auto_order = false, 
creations = {28}
, id = 28, info = 299180, name = 352694}
, 
{abandon_equipment = true, auto_order = false, 
creations = {29}
, id = 29, info = 9967, name = 496850}
, 
{abandon_equipment = true, auto_order = false, 
creations = {30}
, id = 30, info = 276194, name = 234617}
, 
{abandon_equipment = true, auto_order = false, 
creations = {32}
, grid_skill = "gs_31", id = 31, info = 392414, name = 511362}
; 
[100] = {attr_formula = "tab[1]/tab[2]", auto_career = __rt_4, auto_order = false, 
creations = {100}
, grid_skill = "gs_100", icon = "ICON_Grid100", id = 100, info = 147134, name = 105892, priority = 8}
, 
[101] = {attr_formula = "tab[26]", auto_career = __rt_4, 
creations = {101}
, grid_skill = "gs_101", icon = "ICON_Grid101", id = 101, info = 4539, name = 266548, priority = 5}
, 
[102] = {attr_formula = "tab[3]", auto_career = __rt_3, 
creations = {102}
, effect_info = 15908, grid_skill = "gs_102", icon = "ICON_Grid102", id = 102, info = 77801, name = 150175, priority = 9}
, 
[103] = {attr_formula = "tab[26]", 
auto_career = {2, 3, 4, 1, 5}
, career_priority = 5, 
creations = {103}
, grid_skill = "gs_103", icon = "ICON_Grid103", id = 103, info = 324313, name = 104468, priority = 1}
, 
[104] = {attr_formula = "tab[26]", 
auto_career = {4, 5, 3, 2, 1}
, career_priority = 2, grid_skill = "gs_104", icon = "ICON_Grid104", id = 104, info = 276535, name = 366393, priority = 2}
, 
[105] = {attr_formula = "tab[3]", auto_career = __rt_4, creations = __rt_11, grid_skill = "gs_105", icon = "ICON_Grid105", id = 105, info = 196129, name = 82113, priority = 6}
, 
[106] = {attr_formula = "tab[2]", auto_career = __rt_4, career_priority = 1, 
creations = {106}
, grid_skill = "gs_106", icon = "ICON_Grid106", id = 106, info = 496964, name = 325777, priority = 3}
, 
[107] = {attr_formula = "tab[4]", auto_career = __rt_4, 
creations = {107}
, grid_skill = "gs_107", icon = "ICON_Grid107", id = 107, info = 238464, name = 244480, priority = 7}
, 
[108] = {attr_formula = "tab[26]", 
auto_career = {4, 3, 2, 5, 1}
, career_priority = 4, 
creations = {108}
, grid_skill = "gs_108", id = 108, info = 30222, name = 444744, necessary = "tab[1]/tab[2]>0.5", priority = 4}
, 
[1100] = {
creations = {1100}
, grid_skill = "gs_1100", icon = "ICON_Grid1100", id = 1100, info = 281401, name = 15116}
, 
[1101] = {
creations = {1101}
, grid_skill = "gs_1101", icon = "ICON_Grid1101", id = 1101, info = 97644, name = 16056, type = 2}
, 
[1102] = {
creations = {1102}
, grid_skill = "gs_1102", icon = "ICON_Grid1102", id = 1102, info = 50169, name = 320270}
, 
[1103] = {
creations = {1103}
, grid_skill = "gs_1103", icon = "ICON_Grid1103", id = 1103, info = 386574, name = 55121}
, 
[1104] = {abandon_equipment = true, grid_skill = "gs_1104", icon = "ICON_Grid104", id = 1104, info = 268856, isuncover = true, name = 359050}
, 
[1105] = {abandon_equipment = true, creations = __rt_11, grid_skill = "gs_1105", icon = "ICON_Grid105", id = 1105, info = 311415, isuncover = true, name = 474047}
, 
[1106] = {
creations = {31}
, grid_skill = "gs_1106", icon = "", id = 1106, info = 376574, name = 142368}
, 
[1107] = {abandon_equipment = true, attr_formula = "tab[26]", auto_career = __rt_6, creations = __rt_7, grid_skill = "gs_11", icon = "ICON_Grid011", id = 1107}
, 
[1108] = {attr_formula = "tab[26]", auto_career = __rt_6, contain_obstacle = true, 
creations = {1108}
, grid_skill = "gs_11", icon = "ICON_Grid011", id = 1108}
, 
[1109] = {contain_obstacle = true, 
creations = {1109}
, grid_skill = "gs_1100", icon = "ICON_Grid1100", id = 1109, info = 281401, name = 15116}
, 
[1110] = {contain_obstacle = true, 
creations = {1110}
, grid_skill = "gs_1101", icon = "ICON_Grid1101", id = 1110, info = 97644, name = 16056, type = 2}
, 
[1111] = {contain_obstacle = true, 
creations = {1111}
, grid_skill = "gs_1102", icon = "ICON_Grid1102", id = 1111, info = 50169, name = 320270}
, 
[1112] = {contain_obstacle = true, 
creations = {1112}
, grid_skill = "gs_1103", icon = "ICON_Grid1103", id = 1112, info = 386574, name = 55121}
, 
[1113] = {contain_obstacle = true, 
creations = {1113}
, icon = "ICON_Grid020", id = 1113, info = 199733, name = 126813}
, 
[1114] = {
creations = {1114}
, grid_show_type = 1, grid_skill = "gs_1114", icon = "ICON_Grid1114", id = 1114, info = 428828, name = 80606}
, 
[1115] = {
creations = {1115}
, grid_show_type = 1, grid_skill = "gs_1115", icon = "ICON_Grid1115", id = 1115, info = 416470, name = 14798}
, 
[1116] = {
creations = {1116}
, grid_show_type = 1, grid_skill = "gs_1116", icon = "ICON_Grid1116", id = 1116, info = 324520, name = 310180}
, 
[1117] = {
creations = {1117}
, grid_show_type = 1, grid_skill = "gs_1117", icon = "ICON_Grid1117", id = 1117, info = 491439, name = 73777}
, 
[1118] = {
creations = {1118}
, grid_show_type = 1, grid_skill = "gs_1118", icon = "ICON_Grid1118", id = 1118, info = 24423, name = 175962}
, 
[1119] = {creations = __rt_12, grid_skill = "gs_1119", icon = "ICON_Grid1117", id = 1119, info = 192783, name = 114341}
, 
[1120] = {creations = __rt_13, grid_skill = "gs_1120", icon = "ICON_Grid1118", id = 1120, info = 491028, name = 299993}
, 
[1121] = {
creations = {1121}
, grid_skill = "gs_1121", icon = "ICON_Grid1121", id = 1121, info = 456246, name = 522474}
, 
[1122] = {
creations = {1122}
, grid_skill = "gs_1122", icon = "ICON_Grid1121", id = 1122, info = 504573, isuncover = true, name = 308540}
, 
[1123] = {creations = __rt_12, grid_skill = "gs_1123", icon = "ICON_Grid1117", id = 1123, info = 457753, name = 114341}
, 
[1124] = {creations = __rt_13, grid_skill = "gs_1124", icon = "ICON_Grid1118", id = 1124, info = 162350, name = 299993}
, 
[1125] = {auto_career = __rt_8, auto_order = false, cover_priority = 101, 
creations = {1123}
, grid_skill = "gs_1125", icon = "ICON_Grid015", id = 1125, info = 289997, name = 326857, necessary = "0", type_relative = true}
, 
[1126] = {auto_career = __rt_8, auto_order = false, cover_priority = 102, 
creations = {1124}
, grid_skill = "gs_1126", icon = "ICON_Grid015", id = 1126, info = 517807, name = 224979, necessary = "0", type_relative = true}
}
local __default_values = {abandon_equipment = false, attr_formula = "tab[1]", auto_career = __rt_1, auto_order = true, career_priority = 0, contain_obstacle = false, cover_priority = 0, creations = __rt_10, duration = 0, effect_info = "", grid_show_type = 0, grid_skill = "", icon = "ICON_Grid108", id = 1, info = 393057, isuncover = false, name = 26593, necessary = "1", priority = 0, type = 1, type_relative = false}
local base = {__index = __default_values}
for k,v in (_ENV.pairs)(battle_grid) do
  (_ENV.setmetatable)(v, base)
end
local __rawdata = {__basemetatable = base}
;
(_ENV.setmetatable)(battle_grid, {__index = __rawdata})
return battle_grid

