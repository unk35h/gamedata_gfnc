-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {9, 25, 6}
local __rt_2 = {8, 60, 15}
local spec_weapon_basic_config = {
[10021] = {audio_id = 4206, avg_enter = "anna", describe = 517401, name = 479398}
, 
[10071] = {avg_enter = "chelsea", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2507] = true}
, describe = 180918, hero_id = 1007, id = 10071, name = 197584, 
pre_para1 = {1007, 1007, 1007}
}
, 
[10081] = {avg_enter = "gin", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2508] = true}
, describe = 18783, hero_id = 1008, id = 10081, 
pre_para1 = {1008, 1008, 1008}
}
, 
[10101] = {audio_id = 4200, avg_enter = "evelyn", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2510] = true}
, describe = 518906, hero_id = 1010, id = 10101, name = 83132, 
pre_para1 = {1010, 1010, 1010}
}
, 
[10111] = {audio_id = 4206, avg_enter = "camellia", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2511] = true}
, describe = 36550, hero_id = 1011, id = 10111, name = 178134, 
pre_para1 = {1011, 1011, 1011}
}
, 
[10161] = {audio_id = 4207, avg_enter = "banxsy", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2516] = true}
, describe = 383900, hero_id = 1016, id = 10161, name = 270323, 
pre_para1 = {1016, 1016, 1016}
}
, 
[10181] = {audio_id = 4210, avg_enter = "florence", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2518] = true}
, describe = 340349, hero_id = 1018, id = 10181, name = 248283, 
pre_para1 = {1018, 1018, 1018}
}
, 
[10191] = {audio_id = 4202, avg_enter = "fern", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2519] = true}
, describe = 514070, hero_id = 1019, id = 10191, name = 20621, 
pre_para1 = {1019, 1019, 1019}
}
, 
[10211] = {audio_id = 4208, avg_enter = "groove", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2521] = true}
, describe = 247225, hero_id = 1021, id = 10211, name = 55633, 
pre_para1 = {1021, 1021, 1021}
}
, 
[10221] = {audio_id = 4212, avg_enter = "aki", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2522] = true}
, describe = 23222, hero_id = 1022, id = 10221, name = 135449, 
pre_para1 = {1022, 1022, 1022}
}
, 
[10251] = {audio_id = 4205, avg_enter = "twigs", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2525] = true}
, describe = 98651, hero_id = 1025, id = 10251, name = 269139, 
pre_para1 = {1025, 1025, 1025}
}
, 
[10311] = {audio_id = 4204, avg_enter = "imhotep", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2531] = true}
, describe = 170120, hero_id = 1031, id = 10311, name = 243881, 
pre_para1 = {1031, 1031, 1031}
}
, 
[10341] = {audio_id = 4211, avg_enter = "abigail", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2534] = true}
, describe = 346091, hero_id = 1034, id = 10341, name = 56266, 
pre_para1 = {1034, 1034, 1034}
}
, 
[10391] = {audio_id = 4203, 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2539] = true}
, describe = 185734, hero_id = 1039, id = 10391, name = 369848, 
pre_para1 = {1039, 1039, 1039}
}
, 
[10411] = {audio_id = 4201, avg_enter = "delacey", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2541] = true}
, hero_id = 1041, id = 10411, name = 36349, 
pre_para1 = {1041, 1041, 1041}
}
, 
[10461] = {audio_id = 4213, avg_enter = "daiyan", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2546] = true}
, describe = 439626, hero_id = 1046, id = 10461, name = 178707, 
pre_para1 = {1046, 1046, 1046}
}
, 
[10571] = {avg_enter = "turing", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2557] = true}
, describe = 303486, hero_id = 1057, id = 10571, name = 417349, 
pre_para1 = {1057, 1057, 1057}
}
}
local __default_values = {audio_id = 4209, avg_enter = "Centaureissi", 
costIdDic = {[1003] = true, [1503] = true, [1505] = true, [2502] = true}
, describe = 168187, fragTotal = 220, hero_id = 1002, id = 10021, name = 117363, pre_condition = __rt_1, 
pre_para1 = {1002, 1002, 1002}
, pre_para2 = __rt_2, weapon_lock = false}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(spec_weapon_basic_config) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
heroWeaponMapping = {
[1002] = {10021}
, 
[1007] = {10071}
, 
[1008] = {10081}
, 
[1010] = {10101}
, 
[1011] = {10111}
, 
[1016] = {10161}
, 
[1018] = {10181}
, 
[1019] = {10191}
, 
[1021] = {10211}
, 
[1022] = {10221}
, 
[1025] = {10251}
, 
[1031] = {10311}
, 
[1034] = {10341}
, 
[1039] = {10391}
, 
[1041] = {10411}
, 
[1046] = {10461}
, 
[1057] = {10571}
}
, 
totalCostIdDic = {[1003] = true, [1503] = true, [1505] = true, [2502] = true, [2507] = true, [2508] = true, [2510] = true, [2511] = true, [2516] = true, [2518] = true, [2519] = true, [2521] = true, [2522] = true, [2525] = true, [2531] = true, [2534] = true, [2539] = true, [2541] = true, [2546] = true, [2557] = true}
}
setmetatable(spec_weapon_basic_config, {__index = __rawdata})
return spec_weapon_basic_config

