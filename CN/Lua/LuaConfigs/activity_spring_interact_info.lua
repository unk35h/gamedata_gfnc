-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {"UI_Icon1", "UI_Icon2", "UI_Icon3"}
local __rt_2 = {"UI_Icon3"}
local __rt_3 = {"UI_Icon2"}
local __rt_4 = {"UI_Icon1", "UI_Icon2"}
local __rt_5 = {}
local activity_spring_interact_info = {
[2200140] = {index = "PART 01", tags = __rt_1}
, 
[2200141] = {id = 2200141, 
tags = {"UI_Icon1"}
}
, 
[2200142] = {id = 2200142, tags = __rt_2}
, 
[2200143] = {id = 2200143, tags = __rt_3}
, 
[2200144] = {id = 2200144, index = "PART 03", 
tags = {"UI_Icon1", "UI_Icon3"}
}
, 
[2200145] = {id = 2200145, index = "PART 03", tags = __rt_3}
, 
[2200146] = {id = 2200146, index = "PART 04", tags = __rt_4}
, 
[2200147] = {id = 2200147, index = "PART 04", tags = __rt_2}
, 
[2200148] = {id = 2200148, index = "PART 05", tags = __rt_1}
, 
[2200149] = {id = 2200149, index = "PART 06", tags = __rt_2}
, 
[2200150] = {id = 2200150, index = "PART 06", tags = __rt_4}
, 
[2200151] = {id = 2200151, index = "PART 07", tags = __rt_2}
, 
[2200152] = {id = 2200152, index = "PART 07", tags = __rt_4}
, 
[2200153] = {id = 2200153, index = "PART 08", tags = __rt_1}
, 
[2200154] = {id = 2200154, index = "PART 09", tags = __rt_1}
, 
[2200155] = {character = "jiangyu", id = 2200155, index = "PART 01"}
, 
[2200156] = {character = "jiangyu", id = 2200156}
, 
[2200157] = {character = "jiangyu", id = 2200157, index = "PART 03"}
, 
[2200158] = {character = "kuro_newyear", id = 2200158, index = "PART 01"}
, 
[2200159] = {character = "kuro_newyear", id = 2200159}
, 
[2200160] = {character = "kuro_newyear", id = 2200160, index = "PART 03"}
, 
[2200161] = {character = "florence_newyear", id = 2200161, index = "PART 01"}
, 
[2200162] = {character = "florence_newyear", id = 2200162}
, 
[2200163] = {character = "florence_newyear", id = 2200163, index = "PART 03"}
, 
[2200164] = {character = "aki_newyear", id = 2200164, index = "PART 01"}
, 
[2200165] = {character = "aki_newyear", id = 2200165}
, 
[2200166] = {character = "aki_newyear", id = 2200166, index = "PART 03"}
, 
[2200167] = {character = "sakuya_newyear", id = 2200167, index = "PART 01"}
, 
[2200168] = {character = "sakuya_newyear", id = 2200168}
, 
[2200169] = {character = "sakuya_newyear", id = 2200169, index = "PART 03"}
, 
[2200170] = {character = "croque_newyear", id = 2200170, index = "PART 01"}
, 
[2200171] = {character = "croque_newyear", id = 2200171}
, 
[2200172] = {character = "croque_newyear", id = 2200172, index = "PART 03"}
}
local __default_values = {activity_id = 1, bg = "ActWhite22_2_small", character = "", id = 2200140, index = "PART 02", tags = __rt_5}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_interact_info) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
activityAvgsDic = {
{2200140, 2200141, 2200142, 2200143, 2200144, 2200145, 2200146, 2200147, 2200148, 2200149, 2200150, 2200151, 2200152, 2200153, 2200154, 2200155, 2200156, 2200157, 2200158, 2200159, 2200160, 2200161, 2200162, 2200163, 2200164, 2200165, 2200166, 2200167, 2200168, 2200169, 2200170, 2200171, 2200172}
}
}
setmetatable(activity_spring_interact_info, {__index = __rawdata})
return activity_spring_interact_info

