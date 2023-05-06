-- params : ...
-- function num : 0 , upvalues : _ENV
local dungeon_buff = {
[20003] = {describe = 3185, icon = "ICON_xy_3", name = 476326}
, 
[20004] = {buff_id = 20004, describe = 273381, icon = "ICON_xy_4", name = 119410}
, 
[20006] = {buff_id = 20006, describe = 517734, icon = "ICON_xy_6", name = 91553}
, 
[20007] = {buff_id = 20007, describe = 151925, icon = "ICON_xy_7", name = 270754}
, 
[20018] = {buff_id = 20018, buff_type = 2, describe = 218546, icon = "ICON_xy_18", name = 377177}
, 
[20019] = {buff_id = 20019, buff_type = 2, describe = 1259, icon = "ICON_xy_19", name = 498986}
, 
[20020] = {buff_id = 20020, buff_type = 2, describe = 379323, icon = "ICON_xy_20", name = 78969}
, 
[20022] = {buff_id = 20022, buff_type = 2, describe = 350422, icon = "ICON_xy_22", name = 396237}
, 
[20023] = {buff_id = 20023, buff_type = 2, describe = 217949, icon = "ICON_xy_23", name = 483339}
, 
[20034] = {buff_id = 20034, describe = 281719, icon = "ICON_root_34", name = 11768}
, 
[20038] = {buff_id = 20038, buff_type = 2, describe = 226546, icon = "ICON_root_38", name = 487003}
, 
[20044] = {buff_id = 20044, buff_type = 2, describe = 342973, icon = "ICON_root_44", name = 257551}
, 
[20048] = {buff_id = 20048, buff_type = 2, describe = 245831, icon = "ICON_root_48", name = 408092}
, 
[20057] = {buff_id = 20057, describe = 435374, icon = "ICON_4T_2", name = 127079}
, 
[20092] = {buff_id = 20092, icon = "ICON_root_54", name = 471255}
, 
[20143] = {buff_id = 20143, buff_type = 2, describe = 235173, icon = "ICON_xy_61", name = 220608}
, 
[20154] = {buff_id = 20154, buff_type = 2, describe = 217370, icon = "ICON_xy_69", name = 35460}
, 
[20155] = {buff_id = 20155, buff_type = 2, describe = 367859, icon = "ICON_xy_70", name = 374832}
, 
[20171] = {buff_id = 20171, describe = 315264, name = 523650}
, 
[20173] = {buff_id = 20173, buff_type = 2, describe = 90158, icon = "ICON_root_55", name = 280766}
, 
[20174] = {buff_id = 20174, buff_type = 2, describe = 89942, icon = "ICON_root_56", name = 232502}
, 
[20175] = {buff_id = 20175, buff_type = 2, describe = 324790, icon = "ICON_root_57", name = 433452}
, 
[20176] = {buff_id = 20176, buff_type = 2, describe = 410518, icon = "ICON_root_58", name = 354892}
, 
[20177] = {buff_id = 20177, buff_type = 2, describe = 141365, icon = "ICON_root_59", name = 69924}
, 
[20178] = {buff_id = 20178, buff_type = 2, describe = 240420, icon = "ICON_root_60", name = 280233}
, 
[20179] = {buff_id = 20179, buff_type = 2, describe = 444210, icon = "ICON_root_61", name = 11398}
, 
[20180] = {buff_id = 20180, buff_type = 2, describe = 119513, icon = "ICON_root_42", name = 381990}
, 
[20227] = {buff_id = 20227, buff_type = 2, describe = 158266, icon = "ICON_xy_72", name = 504493}
, 
[21010] = {buff_id = 21010, describe = 481251, is_hide = true, name = 301134}
, 
[21013] = {buff_id = 21013, describe = 196876, is_hide = true, name = 281432}
, 
[21014] = {buff_id = 21014, describe = 128605, is_hide = true, name = 302746}
, 
[21015] = {buff_id = 21015, describe = 432551, is_hide = true, name = 276833}
, 
[21017] = {buff_id = 21017, describe = 114560, is_hide = true, name = 406288}
, 
[21018] = {buff_id = 21018, describe = 203494, is_hide = true, name = 6355}
, 
[21019] = {buff_id = 21019, describe = 418472, is_hide = true, name = 131742}
, 
[21022] = {buff_id = 21022, describe = 150719, is_hide = true, name = 346566}
, 
[21023] = {buff_id = 21023, describe = 315605, is_hide = true, name = 32943}
, 
[21024] = {buff_id = 21024, describe = 79669, is_hide = true, name = 306635}
, 
[21026] = {buff_id = 21026, describe = 448044, is_hide = true, name = 170620}
, 
[21027] = {buff_id = 21027, describe = 106328, is_hide = true, name = 356207}
, 
[21030] = {buff_id = 21030, describe = 25259, is_hide = true, name = 216970}
, 
[21031] = {buff_id = 21031, describe = 515968, is_hide = true, name = 468055}
, 
[21032] = {buff_id = 21032, describe = 363700, is_hide = true, name = 197175}
, 
[21033] = {buff_id = 21033, describe = 46292, is_hide = true, name = 464984}
, 
[21034] = {buff_id = 21034, describe = 74418, is_hide = true, name = 417545}
, 
[21035] = {buff_id = 21035, describe = 333773, is_hide = true, name = 198864}
, 
[21060] = {buff_id = 21060, buff_type = 2, describe = 387786, icon = "ICON_xy_JNH_19", name = 307750}
, 
[21062] = {buff_id = 21062, buff_type = 2, describe = 281665, icon = "ICON_xy_JNH_22", name = 18312}
, 
[21065] = {buff_id = 21065, buff_type = 2, describe = 4437, icon = "ICON_xy_JNH_34", name = 100976}
, 
[21067] = {buff_id = 21067, buff_type = 2, describe = 71609, icon = "ICON_xy_JNH_40", name = 367919}
, 
[21080] = {buff_id = 21080, describe = 509147, is_hide = true, name = 44018}
, 
[21081] = {buff_id = 21081, describe = 191600, is_hide = true, name = 239959}
, 
[21082] = {buff_id = 21082, describe = 65926, is_hide = true, name = 211836}
, 
[21083] = {buff_id = 21083, describe = 111684, is_hide = true, name = 277140}
, 
[21084] = {buff_id = 21084, describe = 317014, is_hide = true, name = 277140}
, 
[21085] = {buff_id = 21085, describe = 9129, is_hide = true, name = 277140}
, 
[21086] = {buff_id = 21086, describe = 153483, is_hide = true, name = 277140}
, 
[21087] = {buff_id = 21087, describe = 369886, is_hide = true, name = 277140}
, 
[21088] = {buff_id = 21088, describe = 160624, is_hide = true}
, 
[21089] = {buff_id = 21089, describe = 99047, is_hide = true}
, 
[21090] = {buff_id = 21090, describe = 37470, is_hide = true}
, 
[21091] = {buff_id = 21091, describe = 500181, is_hide = true}
, 
[21092] = {buff_id = 21092, describe = 438604, is_hide = true}
, 
[21093] = {buff_id = 21093, describe = 282544, is_hide = true, name = 485856}
, 
[21094] = {buff_id = 21094, describe = 407258, is_hide = true, name = 485856}
, 
[21095] = {buff_id = 21095, describe = 99373, is_hide = true, name = 485856}
, 
[21096] = {buff_id = 21096, describe = 243727, is_hide = true, name = 485856}
, 
[21097] = {buff_id = 21097, describe = 460130, is_hide = true, name = 485856}
, 
[21210] = {buff_id = 21210, describe = 104339, is_hide = true, name = 177646}
, 
[21211] = {buff_id = 21211, describe = 188482, is_hide = true, name = 507163}
, 
[21212] = {buff_id = 21212, describe = 420019, is_hide = true, name = 312393}
, 
[21213] = {buff_id = 21213, describe = 422550, is_hide = true, name = 117621}
, 
[21214] = {buff_id = 21214, describe = 377006, is_hide = true, name = 447138}
, 
[21215] = {buff_id = 21215, describe = 458618, is_hide = true, name = 252367}
, 
[21216] = {buff_id = 21216, describe = 77972, is_hide = true, name = 57596}
, 
[21217] = {buff_id = 21217, describe = 523737, is_hide = true, name = 387113}
, 
[21233] = {buff_id = 21233, describe = 363258, icon = "ICON_root_54", name = 304676}
, 
[21234] = {buff_id = 21234, buff_type = 2, describe = 106683, icon = "ICON_xy_28", name = 289307}
, 
[22001] = {buff_id = 22001, describe = 226497, icon = "ICON_xy_DC1", name = 141653}
, 
[22002] = {buff_id = 22002, describe = 253599, icon = "ICON_xy_DC2", name = 404255}
, 
[22003] = {buff_id = 22003, describe = 147678, icon = "ICON_xy_DC3", name = 399538}
, 
[22004] = {buff_id = 22004, describe = 46167, icon = "ICON_xy_DC4", name = 374886}
, 
[22005] = {buff_id = 22005, describe = 77773, icon = "ICON_xy_DC5", name = 441489}
, 
[22006] = {buff_id = 22006, buff_type = 2, describe = 279303, icon = "ICON_xy_DC6", name = 77051}
, 
[22007] = {buff_id = 22007, buff_type = 2, describe = 45235, icon = "ICON_xy_DC7", name = 244363}
, 
[22008] = {buff_id = 22008, buff_type = 2, describe = 341373, icon = "ICON_xy_DC8", name = 169691}
, 
[22009] = {buff_id = 22009, buff_type = 2, describe = 245600, icon = "ICON_xy_DC9", name = 138492}
, 
[22010] = {buff_id = 22010, buff_type = 2, describe = 379228, icon = "ICON_xy_DC10", name = 109330}
, 
[22011] = {buff_id = 22011, buff_type = 2, describe = 295925, icon = "ICON_xy_22", name = 396237}
, 
[22012] = {buff_id = 22012, buff_type = 2, describe = 468056, icon = "ICON_xy_23", name = 483339}
, 
[22013] = {buff_id = 22013, icon = "ICON_root_54", name = 471255}
, 
[22014] = {buff_id = 22014, buff_type = 2, describe = 354509, icon = "ICON_xy_22", name = 396237}
, 
[22015] = {buff_id = 22015, buff_type = 2, describe = 174688, icon = "ICON_xy_23", name = 483339}
, 
[22102] = {buff_id = 22102, buff_type = 2, describe = 355364, icon = "ICON_xy_JNH_19", name = 307750}
, 
[22205] = {buff_id = 22205, buff_type = 2, describe = 166517, icon = "ICON_xy_74", name = 35460}
, 
[25008] = {buff_id = 25008, buff_type = 0, describe = 217229, icon = "ICON_CJ_XY17", name = 474252}
, 
[40033] = {buff_id = 40033, describe = 345401, icon = "ICON_root_34", name = 11768}
}
local __default_values = {buff_id = 20003, buff_type = 1, describe = 50822, icon = "ICON_g_atn_1", is_hide = false, name = 231031}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in (_ENV.pairs)(dungeon_buff) do
  (_ENV.setmetatable)(v, base)
end
local __rawdata = {__basemetatable = base}
;
(_ENV.setmetatable)(dungeon_buff, {__index = __rawdata})
return dungeon_buff

